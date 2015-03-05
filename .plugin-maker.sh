#!/bin/sh
#
# ##################################### #
#
# Copyright 2013-2014 UOL - Universo Online Team
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#    http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ##################################### #
# Command Line Plugin Generator v1.0
# created by Samuel Tamassia Martinez
# improved by Júlio Gori Corradi
# ##################################### #

__tm-plugin-maker () {
    if [[ ! -z "$DIVIDER" ]]; then
        DIVIDER=`printf %81s | tr " " "="`;
    fi

    names=();
    moduleName=''; # dynad-track ===> {{moduleName}}
    projectName=''; # plugin-dynad-track ===> {{projectName}}
    testProjectName=''; # plugin-dynad-track-test
    modulePackageName=''; # dynad.track ===> {{packageName}}
    moduleCompactName=''; # dynadtrack ===> {{moduleCompactName}}
    moduleCamelName=''; # dynadTrack ===> {{moduleCamelName}}
    moduleTotalCamelName=''; # DynadTrack ===> {{moduleTotalCamelName}}
    moduleWebPageName=''; # DynadTrackWebPage ===> {{moduleWebPageName}}

    moduleNameToken='{{moduleName}}';
    projectNameToken='{{projectName}}';
    modulePackageNameToken='{{packageName}}';
    moduleCompactNameToken='{{moduleCompactName}}';
    moduleCamelNameToken='{{moduleCamelName}}';
    moduleTotalCamelNameToken='{{moduleTotalCamelName}}';
    moduleWebPageNameToken='{{moduleWebPageNameToken}}';

    authLimiter=0;

    __namesInArray () {
        for name in `echo "$1" | tr "-" "\n"`; do
            length=${#names[@]};
            names[$length]=$name;
        done
    }

    __createCompactName () {
        compactName='';
        for name in `echo $1 | tr "-" "\n"`
        do
            compactName="$compactName$name";
        done
        moduleCompactName=$compactName;
    }

    __createPackageName () {
        packageName=`echo $1 | tr "-" "."`;
        modulePackageName=$packageName;
    }

    __createWebPageName () {
        WEB_PAGE="WebPage";
        moduleWebPageName="$moduleTotalCamelName$WEB_PAGE";
    }

    __createCamelName () {
        camelName='';
        i=0;

        for name in `echo $1 | tr "-" "\n"`
        do
            if [ $i -eq 0 ]; then
                camelName="$camelName$name";
                let "i=i+1";
            else
                name="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}";
                camelName="$camelName$name";
            fi
        done

        if [ $2 = true ]; then # create a full camel name. e.g. FullCamelName
            camelName="$(tr '[:lower:]' '[:upper:]' <<< ${camelName:0:1})${camelName:1}";
            moduleTotalCamelName=$camelName;
        else
            moduleCamelName=$camelName;
        fi
    }

    __createNames () {
        moduleName=$1;
        projectName='plugin-'$moduleName;
        testProjectName='plugin-'$moduleName'-test';
        __namesInArray $1;
        __createCompactName $1;
        __createPackageName $1;
        __createCamelName $1 false;
        __createCamelName $1 true;
        __createWebPageName;

        echo "$DIVIDER";
        echo "[Tag Manager Plugin Maker]";
        echo "";
        echo "The followiing name will be used: ";
        echo "Project Name:                 "$projectName;
        echo "Module Compact Name:          "$moduleCompactName;
        echo "Module Package Name:          "$modulePackageName;
        echo "Module Camel Name:            "$moduleCamelName;
        echo "Module Total Camel Name:      "$moduleTotalCamelName;
        echo "$DIVIDER";
        echo "";
    }

    __clone_project () {
        mkdir "$1" && cd "$1";
        git clone https://gituol.intranet/git/tag-manager-plugins/plugin-maker.git;
        cp -rf plugin-maker/* ./;
        rm -rf plugin-maker/;
        rm -rf .git/;

        if [[ -f ".plugin-maker.sh" ]]; then
            rm -rf ".plugin-maker.sh";
        fi

        repositoryURL="https://gituol.intranet/git/tag-manager-plugins/$1.git";
        git init && git remote add origin "$repositoryURL";
    }

    __replaceTextInFile () {
        sed -i.bak "s/$1/$2/" $3;
        rm -rf $3.bak;
    }

    __adjustProjectFolder(){
        __replaceTextInFile $projectNameToken $projectName ./pom.xml
        mv ./src/test/js/uolpd/tagmanager/plugin ./src/test/js/uolpd/tagmanager/$moduleCompactName

        __replaceTextInFile $moduleCompactNameToken $moduleCompactName ./src/test/js/uolpd/tagmanager/$moduleCompactName/LogsTest.html
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/test/js/uolpd/tagmanager/$moduleCompactName/LogsTest.js
        __replaceTextInFile $moduleCompactNameToken $moduleCompactName ./src/test/js/uolpd/tagmanager/$moduleCompactName/NameSpaceTest.html
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/test/js/uolpd/tagmanager/$moduleCompactName/NameSpaceTest.js
        __replaceTextInFile $moduleCompactNameToken $moduleCompactName ./src/test/js/uolpd/tagmanager/$moduleCompactName/TypeValidatorTest.html
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/test/js/uolpd/tagmanager/$moduleCompactName/TypeValidatorTest.js

        __replaceTextInFile $moduleCamelNameToken $moduleCamelName ./src/main/resources/grunt/Gruntfile.js
        __replaceTextInFile $moduleCompactNameToken $moduleCompactName ./src/main/resources/grunt/Gruntfile.js
        __replaceTextInFile $moduleNameToken $moduleName ./src/main/resources/grunt/Gruntfile.js

        __replaceTextInFile $moduleCompactNameToken $moduleCompactName ./src/main/resources/grunt/karma.conf.js


        mv ./src/main/js/uolpd/tagmanager/plugin ./src/main/js/uolpd/tagmanager/$moduleCompactName
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/main/js/uolpd/tagmanager/$moduleCompactName/init.js
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/main/js/uolpd/tagmanager/$moduleCompactName/Logs.js
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/main/js/uolpd/tagmanager/$moduleCompactName/NameSpace.js
        __replaceTextInFile $moduleTotalCamelNameToken $moduleTotalCamelName ./src/main/js/uolpd/tagmanager/$moduleCompactName/TypeValidator.js
    }

    __createGitRepository () {
        echo "[INFO] Requesting for new repository to be generated...";

        curl -k -u $1:$2 --data "repository=$projectName" https://web.gituol.intranet/tag-manager-plugins/criar-repositorio;

        echo "[SUCCESS] Your repository has been created successfully!";
        echo "[INFO] Visit https://web.gituol.intranet/tag-manager-plugins/$projectName";
    }

    __askForAuth () {
        read -p "User name for gituol.intranet: " username;
        echo "Password for $username@gituol.intranet: "
        read -s password;

        __authUser $username $password;
    }

    __authUser () {
        echo "";
        echo "[INFO] Authenticating user in gituol.intranet..";

        auth=`curl -G -s -k -u $1:$2 https://web.gituol.intranet/tag-manager-plugins/ | grep 401`;
        authLimiter=$(( authLimiter + 1 ));

        if  !(echo "$auth" | grep -E '^401$'); then
            echo "[SUCCESS] Success during authentication from $1";
            authLimiter=0;

            __createGitRepository $1 $2;
        else
            echo "[ERROR] Fail during  authentication from $1";

            if [[ $authLimiter < 3 ]]; then
                echo "[INFO] Please, try again!";
                __askForAuth $1 $2;
            else
                echo "[ERROR] You tryed to much times. Stopping operation.";
                echo "";
                echo "[INFO] Better to create your repository manually in https://web.gituol.intranet/tag-manager-plugins/";
            fi
        fi
    }

    __main () {
        if !(echo "$1" | grep -E '^((plugin-|-)[a-z-]+)|([a-z-]+(-test|-))$'); then
            __createNames "$1";

            read -p "Do you agree with these names? Type 'YES' to proceed = " answer;

            if [ "$answer" = "YES" ];
            then
                echo "[INFO] Downloading the plugin template."
                __clone_project "$projectName";
                echo "[INFO] Preparing project folder...";
                __adjustProjectFolder;

                echo "";
                echo "$DIVIDER";
                echo "";
                echo "[?] Do you want to create a git repository in https://web.gituol.intranet/tag-manager-plugins ?";
                echo "[WARN] THIS STEP CANNOT BE UNDONE !!!";
                read -p "Type 'YES' to proceed = " answer;

                if [[ "$answer" == "YES" ]]; then
                    gitURL=https://web.gituol.intranet/tag-manager-plugins/$projectName;
                    echo "";
                    echo "[INFO] The URL of your plugin will be $gitURL";
                    read -p "[?] That's correct? Type 'YES' to proceed = " answer;

                    if [[ "$answer" == "YES" ]]; then
                        __askForAuth;
                    else
                        echo "[INFO] The remote repository wasn't created.";
                    fi
                else
                    echo "[INFO] The remote repository wasn't created.";
                fi

                echo "";
                echo "$DIVIDER";
                echo "    Done!!!";
                echo "$DIVIDER";
            fi
        else
            echo "$DIVIDER";
            echo "[Tag Manager Plugin Maker]";
            echo "";
            echo "Don't need to call your plugin as \"plugin-custom-name\".";
            echo "Just input \"custom-name\" and let us do the rest.";
            echo "$DIVIDER";
        fi
    }

    __main $1;
}

alias tm-plugin-maker=__tm-plugin-maker;
