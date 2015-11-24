Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25548 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751568AbbKXCJx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 21:09:53 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <1448175373.7143.24.camel@scientia.net> <56526790.6020907@cn.fujitsu.com>
 <1448302368.2100.28.camel@scientia.net> <5653B34B.9000103@cn.fujitsu.com>
 <1448330029.14125.13.camel@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5653C6D5.1010908@cn.fujitsu.com>
Date: Tue, 24 Nov 2015 10:09:25 +0800
MIME-Version: 1.0
In-Reply-To: <1448330029.14125.13.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/24 02:53 +0100:
> On Tue, 2015-11-24 at 08:46 +0800, Qu Wenruo wrote:
>> But there are also some other places like line 4411, 4394 and 4387.
> Ah of course, I didn't have a look for further places....
>
> $ grep -n "rec->wrong_chunk_type = 1" cmds-check.c
> 4387:			rec->wrong_chunk_type = 1;
> 4394:		rec->wrong_chunk_type = 1;
> 4411:			rec->wrong_chunk_type = 1;
> 4421:			rec->wrong_chunk_type = 1;
>
>
>
>> So there are still 3 breakpoint needs to add.
> GNU gdb (Debian 7.10-1) 7.10
> Copyright (C) 2015 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
> <http://www.gnu.org/software/gdb/documentation/>.
> For help, type "help".
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from ./btrfs...done.
> (gdb) break cmds-check.c:4387
> Breakpoint 1 at 0x42cf2b: file cmds-check.c, line 4387.
> (gdb) break cmds-check.c:4394
> Breakpoint 2 at 0x42cf57: file cmds-check.c, line 4394.
> (gdb) break cmds-check.c:4411
> Breakpoint 3 at 0x42cfa6: file cmds-check.c, line 4411.
> (gdb) break cmds-check.c:4421
> Breakpoint 4 at 0x42d000: file cmds-check.c, line 4421.
> (gdb) run check /dev/mapper/data-b
> Starting program: /home/calestyo/bfsck/btrfs-tools-4.3/btrfs check /dev/mapper/data-b
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
> Checking filesystem on /dev/mapper/data-b
> UUID: 250ddae1-7b37-4b22-89e9-4dc5886c810f
> checking extents
>
> Breakpoint 1, check_extent_type (rec=0x20a6740) at cmds-check.c:4387
> 4387				rec->wrong_chunk_type = 1;
> (gdb) continue
> Continuing.
>
> Breakpoint 1, check_extent_type (rec=0x20a6740) at cmds-check.c:4387
> 4387				rec->wrong_chunk_type = 1;
> (gdb) cont 100
> Will ignore next 99 crossings of breakpoint 1.  Continuing.
>
> Breakpoint 1, check_extent_type (rec=0x20a9880) at cmds-check.c:4387
> 4387				rec->wrong_chunk_type = 1;
> (gdb) cont 1000
> Will ignore next 999 crossings of breakpoint 1.  Continuing.

Great, that's the direct cause.

After some quick glance, it seems that extent_record->metadata does not 
always reflect the right status of the extent.

I'll dig further to see what's causing the problem.

Thanks for all the debug info, it really helps a lot!
Qu
>
> That goes on for a few millions... until we get the:
> bad extent [6619620016128, 6619620032512), type mismatch with chunk
> bad extent [6619620032512, 6619620048896), type mismatch with chunk
> again.. and the check exits normally with:
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 5862373889375 bytes used err is 0
> total csum bytes: 5715302800
> total tree bytes: 9903816704
> total fs tree bytes: 2475769856
> total extent tree bytes: 938393600
> btree space waste bytes: 1072581913
> file data blocks allocated: 9170230497280
>   referenced 9281014861824
> btrfs-progs v4.3
> [Inferior 1 (process 18130) exited normally]
>
>
> So it's the one in 4378.
>
> Anything further to do? :)
>
> Chris.
>

-- 
This message has been scanned for viruses and
dangerous content by FCNIC, and is
believed to be clean.

