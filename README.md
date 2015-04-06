# [Tag Manager] Plugin Maker #

## Pré-requisitos: ##
- Git
- Terminal que interprete shell script

## Instalação: ##
Utilize o comando abaixo para realizar o download do script da automação:
Obs: Por padrão, o download é feito na home (~/) do usuário.

### Linux & Mac ###
``` bash
$ cd ~ && if [ ! -f .plugin-maker.sh ]; then curl -G https://raw.githubusercontent.com/uolcombr/tag-manager-plugins/master/.plugin-maker.sh -o .plugin-maker.sh ; fi;
```

### WINDOWS ###
``` bash
$ cd ~ && if [ ! -f .plugin-maker.sh ]; then curl -G https://raw.githubusercontent.com/uolcombr/tag-manager-plugins/windows/.plugin-maker.sh -o .plugin-maker.sh ; fi;
```

Após o download, é necessário incluir do script no .bash_profile ou .bashrc do utilizador.

Utilize um editor de texto de sua preferência para abrir o arquivo e faça o import do script:

``` bash
# Import via .bash_profile / .bashrc

if [[ -f "$HOME/.plugin-maker.sh" ]]; then
    . "$HOME/.plugin-maker.sh";
fi
```

## Utilização ##
Após importar o script, o commando tm-plugin-maker estará disponível para uso aceitando uma string como argumento, sendo este o nome do plugin desejado.

Obs: Por padrão, todos os nomes dos plugins começam com "plugin-", porém na automação não é necessário utilizar esse prefixo, pois ele será inserido automaticamente.

Obs 2:  Nomes de plugin que terminarem com "-test" não serão autorizados.
Import via .bash_profile / .bashrc
$ tm-plugin-maker feature-name

Após este comando, uma confirmação será exibida, caso as nomenclaturas estejam de acordo digite YES.

``` bash
=================================================================================
[Tag Manager Plugin Maker]
The followiing name will be used:
Project Name:                 plugin-feature-name
Module Compact Name:          featurename
Module Package Name:          feature.name
Module Camel Name:            featureName
Module Total Camel Name:      FeatureName
=================================================================================
Do you agree with these names? Type 'YES' to proceed =
```

Após a confirmação, um template para iniciar o projeto será gerado com todas as nomenclaturas listadas.

Na próxima etapa, o gerador questionará sobre a necessidade de criar um repositório na sessão gituol.intranet/tag-manager-plugins, caso esteja de acordo com as informações, digite YES para prosseguir.

Obs: Atenção para esta fase, porque todo repositório criado no gituol.intranet não pode ser deletado.

Obs 2: Se essa etapa não for necessária, entre com qualquer valor diferente de YES que ela será descartada.

``` bash
[?] Do you want to create a git repository in https://web.gituol.intranet/tag-manager-plugins ?
[WARN] THIS STEP CANNOT BE UNDONE !!!
Type 'YES' to proceed =
```

Na conclusão do processo, um projeto com a seguinte estrutura será gerado:

``` bash
.
|____.git/
|____pom.xml
|____src
| |____main
| | |____js
| | | |____uolpd
| | | | |____tagmanager
| | | | | |____featurename
| | | | | | |____init.js
| | | | | | |____Logs.js
| | | | | | |____NameSpace.js
| | | | | | |____TypeValidator.js
| | |____resources
| | | |____.gitignore
| | | |____assembly.xml
| | | |____grunt
| | | | |____Gruntfile.js
| | | | |____karma.conf.js
| | | | |____package.json
| | | |____scripts
| | | | |____init-grunt.sh
| |____test
| | |____js
| | | |____uolpd
| | | | |____tagmanager
| | | | | |____featurename
| | | | | | |____LogsTest.js
| | | | | | |____NameSpaceTest.js
| | | | | | |____TypeValidatorTest.js
| | |____resources
| | | |____ArrayUtils.js
| | | |____Assert.js
| | | |____TestUtils.js
```
