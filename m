Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58326 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaIAJJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Sep 2014 05:09:58 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Mon, 01 Sep 2014 11:09:41 +0200
Message-ID: <5322846.kPR8ohTNYd@ax5200p>
In-Reply-To: <1484373.Oezxgh4u8P@ax5200p>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <1409192882.1582.13.camel@localhost.localdomain> <1484373.Oezxgh4u8P@ax5200p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag 01 September 2014, 10:47:26 schrieb Marc Dietrich:
> Guy,
> 
> Am Donnerstag 28 August 2014, 10:28:02 schrieb Gui Hecheng:
> > And for the last one and the crucial one...
> > ==5569== Invalid read of size 4
> > ==5569==    at 0x41E394: decompress (cmds-restore.c:93)
> > ==5569==    by 0x41F291: search_dir (cmds-restore.c:378)
> > along with
> > ==5569== Invalid read of size 1
> > ==5569==    at 0x548DDB6: lzo1x_decompress_safe
> > ==5569==    by 0x41E3BD: decompress (cmds-restore.c:122)
> > ==5569==    by 0x41F291: search_dir (cmds-restore.c:378)
> > 
> > Sorry, I'm not able to reproduce it yet, it may be just what you've
> > guessed that corruption happens. But I am sure that there are bugs
> > around the decompress routine, because I've got "failed to inflate"s too
> > with a non-corrupted btrfs. I'm going to track it down.
> 
> this one still exists. It took me a while to reproduce this (actually, find
> the file which causes it). So we have:
> 
> ==27292== Invalid read of size 8
> ==27292==    at 0x57A10D2: lzo1x_decompress_safe (in
> /usr/lib64/liblzo2.so.2.0.0)
> ==27292==    by 0x41E9ED: decompress (cmds-restore.c:129)
> ==27292==    by 0x41F8A7: search_dir (cmds-restore.c:386)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x420C6F: cmd_restore (cmds-restore.c:1319)
> ==27292==    by 0x4042FC: main (btrfs.c:247)
> ==27292==  Address 0x6280afc is 24,572 bytes inside a block of size 24,576
> alloc'd
> ==27292==    at 0x4C277AB: malloc (in
> /usr/lib64/valgrind/vgpreload_memcheck- amd64-linux.so)
> ==27292==    by 0x41F577: search_dir (cmds-restore.c:317)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x41FFE6: search_dir (cmds-restore.c:916)
> ==27292==    by 0x420C6F: cmd_restore (cmds-restore.c:1319)
> ==27292==    by 0x4042FC: main (btrfs.c:247)
> ==27292==
> ==27292== (action on error) vgdb me ...
> 
> and the attached debug backtrace is (I attached the full bt):
> 
> Program received signal SIGTRAP, Trace/breakpoint trap.
> 0x00000000057a10d2 in lzo1x_decompress_safe () from /usr/lib64/liblzo2.so.2
> (gdb) bt
> #0  0x00000000057a10d2 in lzo1x_decompress_safe () from
> /usr/lib64/liblzo2.so.2

after installing debuginfo for liblzo I get

#0  lzo1x_decompress_safe (in=0x1 <error: Cannot access memory at address 
0x1>, in@entry=0x6280a6d "\017ource/core/dom/webl\001", 
    in_len=103290581, in_len@entry=3176, out=out@entry=0x63229a0 
"ource/core/dom/webcore_dom.StaticNodeList.o", 
    out_len=out_len@entry=0x7feff9de0, wrkmem=0x6322a55, wrkmem@entry=0x0) at 
src/lzo1x_d.ch:184
        ip = 0x1 <error: Cannot access memory at address 0x1>
        ip_end = 0x62816d5 ""
        op_end = 0x6323ae3 ""

I'll keep the debug session open just in case.

Marc


> #1  0x000000000041e9ee in decompress_lzo (decompress_len=0x7feff9f60,
> compress_len=417,
>     outbuf=0x63229a0 "ource/core/dom/webcore_dom.StaticNodeList.o",
> inbuf=0x6280a6d "\017ource/core/dom/webl\001") at cmds-restore.c:129
> #2  decompress (inbuf=inbuf@entry=0x627ab00 "zU\001",
> outbuf=outbuf@entry=0x631a9a0 "<X", compress_len=compress_len@entry=24576,
>     decompress_len=decompress_len@entry=0x7feff9f60,
> compress=compress@entry=2) at cmds-restore.c:155
> #3  0x000000000041f8a8 in copy_one_extent (pos=4063232, fi=<optimized out>,
> leaf=0x5fb58d0, fd=4, root=0x61405c0) at cmds-restore.c:386
> #4  copy_file (file=0x66a700 <path_name>
> "/work/chromium/src/out/Release/.ninja_deps", key=0x7feffb080, fd=4,
> root=0x61405c0)
>     at cmds-restore.c:659
> #5  search_dir (root=root@entry=0x61405c0, key=key@entry=0x7feffc2d0,
> output_rootdir=output_rootdir@entry=0x7fefffdb0 "/work",
>     in_dir=in_dir@entry=0x6602d70 "/chromium/src/out/Release",
> mreg=mreg@entry=0x7fefffd60) at cmds-restore.c:840
> #6  0x000000000041ffe7 in search_dir (root=root@entry=0x61405c0,
> key=key@entry=0x7feffd520,
>     output_rootdir=output_rootdir@entry=0x7fefffdb0 "/work",
> in_dir=in_dir@entry=0x6df4d90 "/chromium/src/out",
>     mreg=mreg@entry=0x7fefffd60) at cmds-restore.c:916
> #7  0x000000000041ffe7 in search_dir (root=root@entry=0x61405c0,
> key=key@entry=0x7feffe770,
>     output_rootdir=output_rootdir@entry=0x7fefffdb0 "/work",
> in_dir=in_dir@entry=0x65d7080 "/chromium/src", mreg=mreg@entry=0x7fefffd60)
>     at cmds-restore.c:916
> #8  0x000000000041ffe7 in search_dir (root=root@entry=0x61405c0,
> key=key@entry=0x7fefff9c0,
>     output_rootdir=output_rootdir@entry=0x7fefffdb0 "/work",
> in_dir=in_dir@entry=0x6f35ac0 "/chromium", mreg=mreg@entry=0x7fefffd60)
>     at cmds-restore.c:916
> #9  0x000000000041ffe7 in search_dir (root=root@entry=0x61405c0,
> key=key@entry=0x7fefffe30,
>     output_rootdir=output_rootdir@entry=0x7fefffdb0 "/work",
> in_dir=in_dir@entry=0x45ab43 "", mreg=mreg@entry=0x7fefffd60)
>     at cmds-restore.c:916
> #10 0x0000000000420c70 in cmd_restore (argc=<optimized out>, argv=<optimized
> out>) at cmds-restore.c:1319
> #11 0x00000000004042fd in main (argc=8, argv=0x7feffffa0) at btrfs.c:247

