Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51635 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFELwI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 07:52:08 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id A487544570C
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Jun 2014 13:52:04 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
Subject: latest btrfs-progs and asciidoc dependency
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 05 Jun 2014 12:52:04 +0100
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <0f2f49c05a626f2f2e635a6db818e302@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trying to build the latest btrfs-progs failed form me on Debian 7 with 
this:

(...)
     [CC]     btrfs-show-super.o
     [LD]     btrfs-show-super
Making all in Documentation
     ASCIIDOC btrfs.xml
/bin/sh: 3: asciidoc: not found
make[1]: *** [btrfs.xml] Error 127
make: *** [build-Documentation] Error 2


And it looks the dependency is ~1 GB of new packages? O_o

# apt-get install asciidoc
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following extra packages will be installed:
   dblatex docbook docbook-dsssl docbook-utils docbook-xml docbook-xsl ed 
fonts-droid ghostscript jadetex latex-beamer latex-xcolor libcupsimage2 
libdrm-intel1 libdrm-nouveau1a libdrm-radeon1
   libdrm2 libencode-locale-perl libfile-basedir-perl 
libfile-desktopentry-perl libfile-listing-perl libfile-mimeinfo-perl 
libfont-afm-perl libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa
   libgraphite3 libgs9 libgs9-common libhtml-form-perl 
libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl 
libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl 
libhttp-date-perl
   libhttp-message-perl libhttp-negotiate-perl libijs-0.35 
libio-socket-ip-perl libio-socket-ssl-perl libjbig2dec0 libkpathsea6 
liblcms1 liblcms2-2 liblwp-mediatypes-perl
   liblwp-protocol-https-perl libmailtools-perl libnet-dbus-perl 
libnet-http-perl libnet-ssleay-perl libopenjpeg2 libosp5 libostyle1c2 
libpaper-utils libpaper1 libpciaccess0 libpoppler19
   libptexenc1 libsgmls-perl libsocket-perl libsp1c2 libtie-ixhash-perl 
liburi-perl libutempter0 libwww-perl libwww-robotrules-perl 
libx11-protocol-perl libxaw7 libxcb-glx0 libxcb-shape0
   libxml-parser-perl libxml-twig-perl libxml-xpathengine-perl 
libxml2-utils libxmu6 libxv1 libxxf86dga1 libxxf86vm1 lmodern luatex 
openjade pgf poppler-data preview-latex-style prosper
   ps2eps sgml-data sgmlspl sp tcl8.4 tex-common tex-gyre texlive 
texlive-base texlive-bibtex-extra texlive-binaries texlive-common 
texlive-doc-base texlive-extra-utils texlive-font-utils
   texlive-fonts-recommended texlive-fonts-recommended-doc 
texlive-generic-recommended texlive-latex-base texlive-latex-base-doc 
texlive-latex-extra texlive-latex-extra-doc
   texlive-latex-recommended texlive-latex-recommended-doc texlive-luatex 
texlive-math-extra texlive-pictures texlive-pictures-doc 
texlive-pstricks texlive-pstricks-doc tipa tk8.4
   ttf-marvosym x11-utils x11-xserver-utils xbitmaps xdg-utils xmlto 
xsltproc xterm
Suggested packages:
   vim-addon-manager source-highlight graphicsmagick-imagemagick-compat 
imagemagick latex-cjk-all opensp pdf-viewer texlive-lang-cyrillic 
texlive-xetex transfig docbook-defguide psgml
   docbook-dsssl-doc docbook-xsl-doc-html docbook-xsl-doc-pdf 
docbook-xsl-doc-text docbook-xsl-doc libsaxon-java libxalan2-java 
libxslthl-java docbook-xsl-saxon fop xalan dbtoepub
   ghostscript-cups ghostscript-x hpijs libglide3 libdata-dump-perl 
liblcms-utils liblcms2-utils libcrypt-ssleay-perl sgmls-doc 
libauthen-ntlm-perl libunicode-map8-perl libunicode-string-perl
   xml-twig-tools doc-base poppler-utils fonts-japanese-mincho 
fonts-ipafont-mincho fonts-japanese-gothic fonts-ipafont-gothic 
fonts-arphic-ukai fonts-arphic-uming fonts-unfonts-core
   postscript-viewer perlsgml w3-recs tcl-tclreadline debhelper 
texlive-doc-en perl-tk purifyeps chktex latexmk dvipng xindy dvidvi 
fragmaster lacheck latexdiff psutils t1utils
   libfile-which-perl dot2tex mesa-utils nickle cairo-5c xorg-docs-core 
gvfs-bin xmltex xfonts-cyrillic
Recommended packages:
   wish
The following NEW packages will be installed:
   asciidoc dblatex docbook docbook-dsssl docbook-utils docbook-xml 
docbook-xsl ed fonts-droid ghostscript jadetex latex-beamer latex-xcolor 
libcupsimage2 libdrm-intel1 libdrm-nouveau1a
   libdrm-radeon1 libdrm2 libencode-locale-perl libfile-basedir-perl 
libfile-desktopentry-perl libfile-listing-perl libfile-mimeinfo-perl 
libfont-afm-perl libgl1-mesa-dri libgl1-mesa-glx
   libglapi-mesa libgraphite3 libgs9 libgs9-common libhtml-form-perl 
libhtml-format-perl libhtml-parser-perl libhtml-tagset-perl 
libhtml-tree-perl libhttp-cookies-perl libhttp-daemon-perl
   libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl 
libijs-0.35 libio-socket-ip-perl libio-socket-ssl-perl libjbig2dec0 
libkpathsea6 liblcms1 liblcms2-2 liblwp-mediatypes-perl
   liblwp-protocol-https-perl libmailtools-perl libnet-dbus-perl 
libnet-http-perl libnet-ssleay-perl libopenjpeg2 libosp5 libostyle1c2 
libpaper-utils libpaper1 libpciaccess0 libpoppler19
   libptexenc1 libsgmls-perl libsocket-perl libsp1c2 libtie-ixhash-perl 
liburi-perl libutempter0 libwww-perl libwww-robotrules-perl 
libx11-protocol-perl libxaw7 libxcb-glx0 libxcb-shape0
   libxml-parser-perl libxml-twig-perl libxml-xpathengine-perl 
libxml2-utils libxmu6 libxv1 libxxf86dga1 libxxf86vm1 lmodern luatex 
openjade pgf poppler-data preview-latex-style prosper
   ps2eps sgml-data sgmlspl sp tcl8.4 tex-common tex-gyre texlive 
texlive-base texlive-bibtex-extra texlive-binaries texlive-common 
texlive-doc-base texlive-extra-utils texlive-font-utils
   texlive-fonts-recommended texlive-fonts-recommended-doc 
texlive-generic-recommended texlive-latex-base texlive-latex-base-doc 
texlive-latex-extra texlive-latex-extra-doc
   texlive-latex-recommended texlive-latex-recommended-doc texlive-luatex 
texlive-math-extra texlive-pictures texlive-pictures-doc 
texlive-pstricks texlive-pstricks-doc tipa tk8.4
   ttf-marvosym x11-utils x11-xserver-utils xbitmaps xdg-utils xmlto 
xsltproc xterm
0 upgraded, 128 newly installed, 0 to remove and 38 not upgraded.
Need to get 716 MB of archives.
After this operation, 1,199 MB of additional disk space will be used.
Do you want to continue [Y/n]? n
Abort.


-- 
Tomasz Chmielewski
http://www.sslrack.com
