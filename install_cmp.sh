#!/bin/bash --login
 
# $1 component name
# $2 path to installation folder
# $3 archive web link
# $4 configure arguments
 
NAME=$1
ROOT=$2
ARC_LINK=$3
CFG_ARGS=$4
 
mkdir -p ${ROOT}
cd ${ROOT}
 
wget ${ARC_LINK}
 
if test -f "${NAME}.tar.lz"; then
  lzip -d ${NAME}.tar.lz
  tar -xvf ${NAME}.tar
else
  tar -xvzf ${NAME}.tar.gz
fi
rm ${NAME}.tar*
 
cd ${NAME}
 
if test -f "${CFG_ARGS}"; then
  cfg_args_file="${CFG_ARGS}"
  while IFS= read -r cfg_line
  do
    ./configure ${cfg_line} --prefix=${ROOT}
    make clean
    make
    make install
  done < "$cfg_args_file"
else
  ./configure ${CFG_ARGS} --prefix=${ROOT}
  make
  make install
fi
 
cd ${ROOT}
rm -rf ${NAME}
 
if [ -d "${ROOT}/bin" ]; then
  update_env.sh ${ROOT} PATH ${ROOT}/bin ${PATH}
fi
 
if [ -d "${ROOT}/include" ]; then
  update_env.sh ${ROOT} CPATH ${ROOT}/include ${CPATH}
fi
 
if [ -d "${ROOT}/share/man" ]; then
  update_env.sh ${ROOT} MANPATH ${ROOT}/share/man ${MANPATH}
fi
 
if [ -d "${ROOT}/share/aclocal" ]; then
  update_env.sh ${ROOT} ACLOCAL_PATH ${ROOT}/share/aclocal ${ACLOCAL_PATH}
fi
 
if [ -d "${ROOT}/lib" ]; then
  update_env.sh ${ROOT} LIBRARY_PATH ${ROOT}/lib ${LIBRARY_PATH}
  update_env.sh ${ROOT} LD_LIBRARY_PATH ${ROOT}/lib ${LD_LIBRARY_PATH}
  update_env.sh ${ROOT} LD_RUN_PATH ${ROOT}/lib ${LD_RUN_PATH}
fi
 
if [ -d "${ROOT}/lib/pkgconfig" ]; then
  update_env.sh ${ROOT} PKG_CONFIG_PATH ${ROOT}/lib/pkgconfig ${PKG_CONFIG_PATH}
fi