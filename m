Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50799 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaFPKfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 06:35:41 -0400
From: Russell Coker <russell@coker.com.au>
To: Lennart Poettering <lennart@poettering.net>
Reply-To: russell@coker.com.au
Cc: kreijack@inwind.it, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Date: Mon, 16 Jun 2014 20:35:36 +1000
Message-ID: <1753705.q94Xp43O1l@xev>
In-Reply-To: <20140616101448.GB18016@tango.0pointer.de>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16 Jun 2014 12:14:49 Lennart Poettering wrote:
> On Mon, 16.06.14 10:17, Russell Coker (russell@coker.com.au) wrote:
> > > I am not really following though why this trips up btrfs though. I am
> > > not sure I understand why this breaks btrfs COW behaviour. I mean,
> > > fallocate() isn't necessarily supposed to write anything really, it's
> > > mostly about allocating disk space in advance. I would claim that
> > > journald's usage of it is very much within the entire reason why it
> > > exists...
> > 
> > I don't believe that fallocate() makes any difference to fragmentation on
> > BTRFS.  Blocks will be allocated when writes occur so regardless of an
> > fallocate() call the usage pattern in systemd-journald will cause
> > fragmentation.
> 
> journald's write pattern looks something like this: append something to
> the end, make sure it is written, then update a few offsets stored at
> the beginning of the file to point to the newly appended data. This is
> of course not easy to handle for COW file systems. But then again, it's
> probably not too different from access patterns of other database or
> database-like engines...

Not being too different from the access patterns of other databases means 
having all the same problems as other databases...  Oracle is now selling ZFS 
servers specifically designed for running the Oracle database, but that's with 
"hybrid storage" "flash" (ZIL and L2ARC on SSD).  While BTRFS doesn't support 
features equivalent for ZIL and L2ARC it's easy to run a separate filesystem 
on SSD for things that need performance (few if any current BTRFS users would 
have a database too big to entirely fit on a SSD).

The problem we are dealing with is "database-like" access patterns on systems 
that are not designed as database servers.

Would it be possible to get an interface for defragmenting files that's not 
specific to BTRFS?  If we had a standard way of doing this then systemd-
journald could request a defragment of the file at appropriate times.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

