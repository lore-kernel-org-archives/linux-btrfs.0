From: Marcel Runte <marcel.runte@web.de>
Subject: Re: Kernel oops after compile error
Date: Thu, 31 Jul 2008 20:53:56 +0200
Message-ID: <1905891602@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Yan Zheng wrote Marcel:
> 
> This is a known issue caused by AppArmor. See following URL.
> 
> http://oss.oracle.com/pipermail/btrfs-devel/2008-February/000491.html
> 
> Regards
> YZ

YZ,

patch described in your link is included in http://www.kernel.org/hg/index.cgi/btrfs/kernel/rev/9da425337329, which I used for compilation. Even putting an alias like "alias gcc = 'gcc -DREMOVE_SUID_PATH'" or doing a "CC='gcc -DREMOVE_SUID_PATH'; make"leads to same error message when compiling file.c

-Marcel
