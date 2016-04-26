==============
INSTALLATION

Dependencies :

1. Octave : In most unices, octave is available as a package (e.g., 
   for apt-get or yum). In Mac OS X, it is available as a formula in 
   Homebrew (http://brew.sh), which means it can also be installed in 
   Linux user space with Linuxbrew :

   https://github.com/Linuxbrew/linuxbrew

   Windows binaries are available from GNU : 

   https://www.gnu.org/software/octave/download.html

   were you can also find instructions for installing from sources

   https://www.gnu.org/software/octave/doc/interpreter/Installation.html


2. GraphicsMagick must be installed for image i/o to work. If your 
   package manager won't install it automatically, it must be 
   installed *before* compiling Octave :

   http://www.graphicsmagick.org


3. Octave Packages
   
   Install the mandatory packages image, io, statistics, and optional
   package parallel typing those commands in Octave console:

   pkg install -forge image
   pkg install -forge io
   pkg install -forge statistics
   pkg install -forge parallel

   Alternatively, download the .tar.gz files from :

   http://octave.sourceforge.net/image/
   http://octave.sourceforge.net/io/
   http://octave.sourceforge.net/statistics/
   http://octave.sourceforge.net/parallel/

   Then, from Octave console type :
   pkg install path/to/file-version.tar.gz


==============
RUNNING

