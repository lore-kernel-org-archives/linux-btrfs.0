Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15026 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbbKXAq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 19:46:26 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <1448175373.7143.24.camel@scientia.net> <56526790.6020907@cn.fujitsu.com>
 <1448302368.2100.28.camel@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5653B34B.9000103@cn.fujitsu.com>
Date: Tue, 24 Nov 2015 08:46:03 +0800
MIME-Version: 1.0
In-Reply-To: <1448302368.2100.28.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/23 19:12 +0100:
> On Mon, 2015-11-23 at 09:10 +0800, Qu Wenruo wrote:
>> Also, you won't want compiler to do extra optimization
> I did the following:
> $ export CFLAGS="-g -O0 -Wall -D_FORTIFY_SOURCE=2"

Wow, I didn't ever know it's possible to override FORTIFY_SOURCE to 
suppress the warning.

Great tip!

> $ ./configure --disable-convert --disable-documentation
>
> So if you want me to get rid of _FORTIFY_SOURCE, please tell.
>
>
>>
>> After make, you won't need to install the btrfs-progs, you can just
>> use
>> gdb to debug local ./btrfsck and add new breakpoints to do the trick.
> # gdb ./btrfs
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
> (gdb) break cmds-check.c:4421
> Breakpoint 1 at 0x42d000: file cmds-check.c, line 4421.

Yes, that's one possible code where set the bad_extent flag.

But there are also some other places like line 4411, 4394 and 4387.

So there are still 3 breakpoint needs to add.

At least, we ruled out one possible case.

Thanks for all the result you provide, we are firmly getting to the 
result now.

Thanks,
Qu

> (gdb) run check /dev/mapper/data-b
> Starting program: /home/calestyo/bfsck/btrfs-tools-4.3/btrfs check /dev/mapper/data-b
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
> ...
> bad extent [6619620278272, 6619620294656), type mismatch with chunk
> bad extent [6619620294656, 6619620311040), type mismatch with chunk
> bad extent [6619620311040, 6619620327424), type mismatch with chunk
> checking free space cache
> checking fs roots
>
> with not breakpoint reached. And I've actually did that with both btrfs
> where the problem occurred (the master, and the one that send/received
> snapshots incrementally from it).
>
>
> Hope that helps... anything further to do?
>
> Chris.
>

-- 
This message has been scanned for viruses and
dangerous content by FCNIC, and is
believed to be clean.

