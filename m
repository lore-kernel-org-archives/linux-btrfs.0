From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: Re: Kernel oops after compile error
Date: Fri, 1 Aug 2008 11:01:09 +0800
Message-ID: <3d0408630807312001r773281afm87fff466444d2b3d@mail.gmail.com>
References: <1905891602@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Marcel Runte" <marcel.runte@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1905891602@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

2008/8/1 Marcel Runte <marcel.runte@web.de>:
> patch described in your link is included in http://www.kernel.org/hg/index.cgi/btrfs/kernel/rev/9da425337329, which I used for compilation. Even putting an alias like "alias gcc = 'gcc -DREMOVE_SUID_PATH'" or doing a "CC='gcc -DREMOVE_SUID_PATH'; make"leads to same error message when compiling file.c
>

Linux kernel uses its own building system, putting alias has no
effect. Please try modify the code directly.

YZ
