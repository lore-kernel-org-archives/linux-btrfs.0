Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17063 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752991AbbKWBKv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Nov 2015 20:10:51 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <1448175373.7143.24.camel@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56526790.6020907@cn.fujitsu.com>
Date: Mon, 23 Nov 2015 09:10:40 +0800
MIME-Version: 1.0
In-Reply-To: <1448175373.7143.24.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/22 07:56 +0100:
> Hey Qu.
>
>
> On Sun, 2015-11-22 at 10:04 +0800, Qu Wenruo wrote:
>> If any of you can recompile btrfs-progs and use gdb to debug it,
>> would
>> anyone please to investigate where did the wrong_chunk_type is set?
>> It is in the function check_extent_type():
>
> Not 100% what you want... AFAIU, you just want to see whether that line
> is reached?
>
> If didn't re-compile but used the btrfs-tools-dbg package, but I guess
> that should do.
>
> In the debian version that line seems to be at:
> 4374
> 4375 /* Check if the type of extent matches with its chunk */
> 4376 static void check_extent_type(struct extent_record *rec)
> 4377 {
> ...
> 4419                         bg_type = BTRFS_BLOCK_GROUP_METADATA;
> 4420                 if (!(bg_cache->flags & bg_type))
> 4421                         rec->wrong_chunk_type = 1;
> 4422         }
> 4423 }
>
> Running:
> # gdb btrfs
> (gdb) dir /root/btrfs-tools-4.3
> Source directories searched: /root/btrfs-tools-4.3:$cdir:$cwd
> (gdb) break cmds-check.c:4421
> Breakpoint 1 at 0x41d859: file cmds-check.c, line 4421.
> (gdb) run check /dev/mapper/data-b
> Starting program: /bin/btrfs check /dev/mapper/data-b
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
>
> ... in fact reaches that breakpoint:
> Breakpoint 1, check_extent_type (rec=rec@entry=0x884290) at cmds-check.c:4423
> 4423	}

Normally you can use -dbg package, but as you experienced, a lot of 
reasons like optimization from compiler can cause such situation.

That's why I recommended to compile the package from scratch.

And if you want to compile, it's also recommended to disable unrelated 
component by disabling document(needs xmlto and ascii) and convert(needs 
a lot of ext2 related headers).
"./configure --disable-convert --disable-documentation" should do the trick.

Also, you won't want compiler to do extra optimization, so after 
configuration, you'd better edit Makefile and change optimization level 
to 0, by changing the "-O1" (o and one) to "-O0" (o and zero) of CFLAGS.

Then make, compiler will complain about the optimization level as some 
headers need it, but that's OK and won't cause anything wrong.

After make, you won't need to install the btrfs-progs, you can just use 
gdb to debug local ./btrfsck and add new breakpoints to do the trick.

Thanks,
Qu

>
> ... but the error message ("bad extent [5993525264384, 5993525280768),
> type mismatch with chunk") doesn't seem to be printed at that stage...
>
>
> If I continue, it goes for a while:
>
> Breakpoint 1, check_extent_type (rec=rec@entry=0x884290) at cmds-check.c:4423
> 4423	}
> (gdb) cont 100000
> Will ignore next 99999 crossings of breakpoint 1.  Continuing.
>
> and so on for at least several million crossings... I then removed the
> breakpoint and after a longer while the usual error messages came up.
>
>
> Does that help?
>
> Chris.
>
