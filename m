Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:55664 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbeDGRQj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Apr 2018 13:16:39 -0400
Received: by mail-it0-f54.google.com with SMTP id 142-v6so5929978itl.5
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Apr 2018 10:16:39 -0700 (PDT)
MIME-Version: 1.0
From: Menion <menion@gmail.com>
Date: Sat, 7 Apr 2018 19:16:18 +0200
Message-ID: <CAJVZm6dAcTC7e4RFtfhrJ-DdnR8m4tGGh=z-EAM2uOKVCU_sdg@mail.gmail.com>
Subject: Unable to compile btrfs progs 4.16 on ubuntu Xenial
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all
Apparently it is not possible to compile with python bindings the
btrfs progs on ubuntu xenial

checking for a Python interpreter with version >= 3.4... python3
checking for python3... /usr/bin/python3
checking for python3 version... 3.5
checking for python3 platform... linux
checking for python3 script directory... ${prefix}/lib/python3.5/site-packages
checking for python3 extension module directory...
${exec_prefix}/lib/python3.5/site-packages
checking for python-3.5... no
configure: error: Package requirements (python-3.5) were not met:

No package 'python-3.5' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables PYTHON_CFLAGS
and PYTHON_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.

/usr/lib/python3.5/site-packages exists, but on Ubuntu the package
name is python3.5 and not python-3.5

Bye
