Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbeDHIv2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Apr 2018 04:51:28 -0400
Subject: Re: Unable to compile btrfs progs 4.16 on ubuntu Xenial
To: Menion <menion@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAJVZm6dAcTC7e4RFtfhrJ-DdnR8m4tGGh=z-EAM2uOKVCU_sdg@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <744d42cf-7ace-2921-00ae-86340ad743d7@suse.com>
Date: Sun, 8 Apr 2018 11:51:24 +0300
MIME-Version: 1.0
In-Reply-To: <CAJVZm6dAcTC7e4RFtfhrJ-DdnR8m4tGGh=z-EAM2uOKVCU_sdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.04.2018 20:16, Menion wrote:
> Hi all
> Apparently it is not possible to compile with python bindings the
> btrfs progs on ubuntu xenial
> 
> checking for a Python interpreter with version >= 3.4... python3
> checking for python3... /usr/bin/python3
> checking for python3 version... 3.5
> checking for python3 platform... linux
> checking for python3 script directory... ${prefix}/lib/python3.5/site-packages
> checking for python3 extension module directory...
> ${exec_prefix}/lib/python3.5/site-packages
> checking for python-3.5... no
> configure: error: Package requirements (python-3.5) were not met:
> 
> No package 'python-3.5' found
> 
> Consider adjusting the PKG_CONFIG_PATH environment variable if you
> installed software in a non-standard prefix.
> 
> Alternatively, you may set the environment variables PYTHON_CFLAGS
> and PYTHON_LIBS to avoid the need to call pkg-config.
> See the pkg-config man page for more details.
> 
> /usr/lib/python3.5/site-packages exists, but on Ubuntu the package
> name is python3.5 and not python-3.5


Do you have libpython3-dev installed? When I installed it on my ubuntu i
could compile the progs irrespective of whether --prefix was passed or not
> 
> Bye
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
