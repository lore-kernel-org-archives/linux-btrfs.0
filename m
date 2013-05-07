Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62216 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab3EGKBO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 06:01:14 -0400
Message-ID: <5188D21B.6010008@cn.fujitsu.com>
Date: Tue, 07 May 2013 18:06:19 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: russell@coker.com.au
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs compile warnings on i386
References: <201305071938.03938.russell@coker.com.au>
In-Reply-To: <201305071938.03938.russell@coker.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Thanks for reporting,
i will deal with this issue.

Thanks,
Wang

> https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/
> 
> I've just tried building btrfs-progs on i386 with a git pull from a few 
> minutes ago and I got the following warnings:
> 
>     [CC]     btrfs-list.o
> btrfs-list.c: In function 'filter_by_parent':
> btrfs-list.c:1183:34: warning: cast to pointer from integer of different size 
> [-Wint-to-pointer-cast]
>     [CC]     cmds-subvolume.o
> cmds-subvolume.c: In function 'cmd_subvol_show':
> cmds-subvolume.c:917:5: warning: cast from pointer to integer of different size 
> [-Wpointer-to-int-cast]
>     [CC]     cmds-restore.o
> cmds-restore.c: In function 'decompress_lzo':
> cmds-restore.c:116:10: warning: passing argument 4 of 'lzo1x_decompress_safe' 
> from incompatible pointer type [enabled by default]
> In file included from cmds-restore.c:31:0:
> /usr/include/lzo/lzo1x.h:77:1: note: expected 'lzo_uint *' but argument is of 
> type 'size_t *'
> 
> I've compiled it on Debian/Wheezy on i386 and AMD64.  On AMD64 there are no 
> warnings but the above warnings appear on i386.
> 



