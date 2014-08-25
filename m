Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30531 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752145AbaHYKVt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 06:21:49 -0400
Message-ID: <1408962091.11888.10.camel@localhost.localdomain>
Subject: Re: btrfs restore memory corruption (bug: 82701)
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Marc Dietrich <marvin24@gmx.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Mon, 25 Aug 2014 18:21:31 +0800
In-Reply-To: <2541460.r9GW3Dua9b@ax5200p>
References: <2058629.ulFxBAG3Lx@fb07-iapwap2>
	 <1408689825.22226.14.camel@localhost.localdomain>
	 <2743777.ssdxK72F8y@fb07-iapwap2> <2541460.r9GW3Dua9b@ax5200p>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-08-25 at 10:58 +0200, Marc Dietrich wrote:
> Am Freitag 22 August 2014, 10:42:18 schrieb Marc Dietrich:
> > Am Freitag, 22. August 2014, 14:43:45 schrieb Gui Hecheng:
> > > On Thu, 2014-08-21 at 16:19 +0200, Marc Dietrich wrote:
> > > > Am Donnerstag, 21. August 2014, 17:52:16 schrieb Gui Hecheng:
> > > > > On Mon, 2014-08-18 at 11:25 +0200, Marc Dietrich wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I did a checkout of the latest btrfs progs to repair my damaged
> > > > > > filesystem.
> > > > > > Running btrfs restore gives me several failed to inflate: -6 and
> > > > > > crashes
> > > > > > with some memory corruption. I ran it again with valgrind and got:
> > > > > > 
> > > > > > valgrind --log-file=x2 -v --leak-check=yes btrfs restore /dev/sda9
> > > > > > /mnt/backup
> > > > > > 
> > > > > > ==8528== Memcheck, a memory error detector
> > > > > > ==8528== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et
> > > > > > al.
> > > > > > ==8528== Using Valgrind-3.8.1 and LibVEX; rerun with -h for
> > > > > > copyright
> > > > > > info
> > > > > > ==8528== Command: btrfs restore /dev/sda9 /mnt/backup
> > > > > > ==8528== Parent PID: 8453
> > > > > > ==8528==
> > > > > > ==8528== Syscall param pwrite64(buf) points to uninitialised byte(s)
> > > > > > ==8528==    at 0x59BE3C3: __pwrite_nocancel (in
> > > > > > /lib64/libpthread-2.18.so)
> > > > > > ==8528==    by 0x41F22F: search_dir (cmds-restore.c:392)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
> > > > > > ==8528==    by 0x4043FE: main (btrfs.c:286)
> > > > > > ==8528==  Address 0x66956a0 is 7,056 bytes inside a block of size
> > > > > > 8,192
> > > > > > alloc'd
> > > > > > ==8528==    at 0x4C277AB: malloc (in
> > > > > > /usr/lib64/valgrind/vgpreload_memcheck- amd64-linux.so)
> > > > > > ==8528==    by 0x41EEAD: search_dir (cmds-restore.c:316)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x41F8D0: search_dir (cmds-restore.c:895)
> > > > > > ==8528==    by 0x4204B8: cmd_restore (cmds-restore.c:1284)
> > > > > > ==8528==    by 0x4043FE: main (btrfs.c:286)
> > > > > 
> > > > > -------------------[snip]---------------------------------
> > > > > .... leaks ...
> > > > > ----------------------------------------------------------
> > > 
> > > For the leak below...
> > > I've no idea why the @decompress_lzo() is not statisfied with @inbuf
> > > with the exact size of the disk bytes.
> > > Or maybe the compressed data had just sufferred damages...
> > > 
> > > BTW, when you wrote your data, did that kernel has the following commit
> > > for btrfs?
> > > 
> > > 	commit: 59516f6017c589e7316418fda6128ba8f829a77f
> > 
> > mmh, I used the master branch which is still on 3.14.2 (from k.org).
> > 
> > Ah, there is a development branch on another repo (repo.or.cz). Why oh why?
> 
> Guy, 
> 
> sorry to quote an earlier mail, I forgot to add you as CC on you latest post 
> and I'm not subscribed to the list.
> 
> > There is a development branch for btrfs-progs from david:
> > http://github.com/kdave/btrfs-progs.git if you would like to try.
> 
> ok, thanks will try.
> 
> > But here, what I mean is your *kernel* version when you wrote your data.
> 
> I'm using btrfs since 3.14 or so (and maybe also some random distro kernel 
> based on 3.11). The partition contained a lot of larger git trees and virtual 
> machines - yes, not ideal for btrfs but a nice testcase ...
> 
> > There is a change for btrfs-restore which depends on a kernel commit.
> > If you wrote your data with a older kernel and apply the 3.14.2
> > btrfs-progs to restore, then there may be wandering stuffs.
> 
> wow. That should never happend I think. Userspace should always be able to fix 
> corruptions made by earlier kernels (except disk layout changes maybe).
> 
> > Now, I am just suspecting such a scenario.
> 
> Possbile. So how to proceed? If I checkout the latest brtfs from the repo 
> above and restore again, are you still interested in the results?

Ah, I think you could clone the progs from the repo and apply the two
small pieces that I mentioned before.
Yes, I am still trying to follow the issues with restore. It seems
btrfs-restore needs more effect from btrfs developers since it doesn't
survive tough scenarioes.

> It seems there are lots of people reporting corruptions on the list and also 
> lots of fixes posted. Maybe it's better to restart from new (format a the 
> partiton) and report problems happen after that. What do you think?

Oh, I think you've just found a really good case for btrfs-restore.
Maybe you could keep a image of that, just like Zooko did here:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36701.html

Thanks,
-Gui

> Marc


