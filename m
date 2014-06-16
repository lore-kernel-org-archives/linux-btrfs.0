Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:37277 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFPARo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 20:17:44 -0400
From: Russell Coker <russell@coker.com.au>
To: Lennart Poettering <lennart@poettering.net>
Reply-To: russell@coker.com.au
Cc: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Date: Mon, 16 Jun 2014 10:17:39 +1000
Message-ID: <1709025.rRUgx5gMp1@xev>
In-Reply-To: <20140615221307.GE24386@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16 Jun 2014 00:13:07 Lennart Poettering wrote:
> On Sat, 14.06.14 09:52, Goffredo Baroncelli (kreijack@libero.it) wrote:
> > > Which effectively means that by the time the 8 MiB is filled, each 4 KiB
> > > block has been rewritten to a new location and is now an extent unto
> > > itself.  So now that 8 MiB is composed of 2048 new extents, each one a
> > > single 4 KiB block in size.
> > 
> > Several people pointed fallocate as the problem. But I don't
> > understand the reason.
> 
> BTW, the reason we use fallocate() in journald is not about trying to
> optimize anything. It's only used for one reason: to avoid SIGBUS on
> disk/quota full, since we actually write everything to the files using
> mmap(). I mean, writing things with mmap() is always problematic, and
> handling write errors is awfully difficult, but at least two of the most
> common reasons for failure we'd like protect against in advance, under
> the assumption that disk/quota full will be reported immediately by the
> fallocate(), and the mmap writes later on will then necessarily succeed.

I just did some tests using fallocate(1).  I did the tests both with and 
without the -n option which appeared to make no difference.

I started by allocating a 24G file on a 106G filesystem that had 30G free 
according to df.  The first time that took almost 2 minutes of system CPU time 
on a Q8400 CPU.

I then made a snapshot of the subvol and then used dd with the conv=notrunc 
option to overwrite it.  The amount of reported disk space decreased in line 
with the progress of dd.  So in the case of snapshots the space will be USED 
(not just reserved) when you call fallocate and there is no guarantee that 
space will be available when you write to it.

My systems have cron jobs to make read-only snapshots of all subvols.  On 
these systems you have no guarantee that mmap will succeed - apart from the 
fact that the variety of problems BTRFS has in the case of running out of disk 
space makes me more careful to avoid that on BTRFS than on other filesystems.

> I am not really following though why this trips up btrfs though. I am
> not sure I understand why this breaks btrfs COW behaviour. I mean,
> fallocate() isn't necessarily supposed to write anything really, it's
> mostly about allocating disk space in advance. I would claim that
> journald's usage of it is very much within the entire reason why it
> exists...

I don't believe that fallocate() makes any difference to fragmentation on 
BTRFS.  Blocks will be allocated when writes occur so regardless of an 
fallocate() call the usage pattern in systemd-journald will cause 
fragmentation.

> Anyway, happy to change these things around if necesary, but first I'd
> like to have a very good explanation why fallocate() wouldn't be the
> right thing to invoke here, and a suggestion what we should do instead
> to cover this usecase...

Systemd could request that the files in question be defragmented.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

