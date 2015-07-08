Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36177 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbGHX6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 19:58:24 -0400
Received: by pddu5 with SMTP id u5so66556598pdd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 16:58:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$cc970$278beac6$e66cdc18$1262676c@cox.net>
References: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
	<CAJCQCtT6csRoN+Bbfx=u8LHCZMnrsoBff+nbatXvCqVU-0iOGg@mail.gmail.com>
	<CAFdkf7PPbH0mw1KW2TkkF5bm=cjN2iJEOzZwVAxh0f1xzjDWuA@mail.gmail.com>
	<pan$cc970$278beac6$e66cdc18$1262676c@cox.net>
Date: Thu, 9 Jul 2015 02:58:24 +0300
Message-ID: <CAFdkf7M9FM3E_BF_GC5_ohVDi98Y2oU1NTkW35=auvqx=s6BpA@mail.gmail.com>
Subject: Re: Error while balance after convert from ext4
From: =?UTF-8?B?0J3QuNC60L7Qu9Cw0Lkg0J7QstGH0LjQvdC90LjQutC+0LI=?=
	<nik.ovchin@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-07-09 2:32 GMT+03:00 Duncan <1i5t5.duncan@cox.net>:
> Николай Овчинников posted
> on Wed, 08 Jul 2015 22:38:20 +0300 as excerpted:
>
>> 2015-07-08 16:56 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>>> I've reproduced this bug with a brand new ext4 system, converted with
>>> btrfs-progs 4.1 and a 4.1 kernel. The conversion is OK. And btrfs check
>>> is ok after conversion, after removing the ext2_saved snapshot, and
>>> after defrag. The implosion happens on balance and the fs goes read
>>> only.
>
>> What about btrfsck and btrfs-image errors?
>
> C Murphy mentioned btrfs check (saying it was fine after conversion).
> Btrfsck is now the check subcommand under the primary btrfs tool, with
> the standalone btrfsck deprecated and to be removed after a few
> transition releases.
>
> But he didn't cover btrfs-image.  Valid point/question there.
>

btrfs check have same error

root@ovchin-eee:/home/ovchin/btrfs-progs# gdb ./btrfs
GNU gdb (Debian 7.7.1+dfsg-5) 7.7.1
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./btrfs...done.
(gdb) run check /dev/sda7
Starting program: /home/ovchin/btrfs-progs/btrfs check /dev/sda7
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Checking filesystem on /dev/sda7
UUID: 489fb2ac-7f1a-46da-9fb8-964e483c8081
checking extents

Program received signal SIGABRT, Aborted.
0x00007ffff6fc6107 in __GI_raise (sig=sig@entry=6)
    at ../nptl/sysdeps/unix/sysv/linux/raise.c:56
56      ../nptl/sysdeps/unix/sysv/linux/raise.c: Нет такого файла или каталога.
(gdb) bt
#0  0x00007ffff6fc6107 in __GI_raise (sig=sig@entry=6)
    at ../nptl/sysdeps/unix/sysv/linux/raise.c:56
#1  0x00007ffff6fc74e8 in __GI_abort () at abort.c:89
#2  0x000000000042cd25 in add_tree_backref
(extent_cache=0x7fffffffe530, bytenr=7707766784,
    parent=0, root=4, found_ref=1) at cmds-check.c:4421
#3  0x00000000004309a2 in add_root_to_pending (buf=0x6dcd00,
extent_cache=0x7fffffffe530,
    pending=0x7fffffffe510, seen=0x7fffffffe520, nodes=0x7fffffffe4f0,
objectid=4)
    at cmds-check.c:5961
#4  0x0000000000434abb in deal_root_from_list (list=0x7fffffffe200,
root=0x6eaa10,
    bits=0x6f1170, bits_nr=1024, pending=0x7fffffffe510, seen=0x7fffffffe520,
    reada=0x7fffffffe500, nodes=0x7fffffffe4f0, extent_cache=0x7fffffffe530,
    chunk_cache=0x7fffffffe590, dev_cache=0x7fffffffe5a0,
block_group_cache=0x7fffffffe570,
    dev_extent_cache=0x7fffffffe540) at cmds-check.c:7803
#5  0x0000000000434f95 in check_chunks_and_extents (root=0x6eaa10) at
cmds-check.c:7973
#6  0x00000000004381a0 in cmd_check (argc=1, argv=0x7fffffffe810) at
cmds-check.c:9402
#7  0x0000000000409dec in main (argc=2, argv=0x7fffffffe810) at btrfs.c:245
