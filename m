Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49149 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaLAISX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 03:18:23 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 9E6AC20876
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Dec 2014 19:18:21 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: pro/cons of raid1 with mdadm/lvm2
Date: Mon, 1 Dec 2014 19:18:19 +1100
References: <20141130121147.45884217@atmarama> <E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au> <CAJCQCtTM8JpH_-E6dsbV53aCx7V9ptH94peST63KJ6AR=OCDqQ@mail.gmail.com>
In-Reply-To: <CAJCQCtTM8JpH_-E6dsbV53aCx7V9ptH94peST63KJ6AR=OCDqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201412011918.19753.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 1 Dec 2014, Chris Murphy <lists@colorremedies.com> wrote:
> On Sun, Nov 30, 2014 at 3:06 PM, Russell Coker <russell@coker.com.au> wrote:
> > When the 2 disks have different data mdadm has no way of knowing which
> > one is correct and has a 50% chance of overwriting good data. But BTRFS
> > does checksums on all reads and solves the problem of corrupt data - as
> > long as you don't have 2 corrupt sectors in matching blocks.
> 
> Yeah. I'm not sure though if openSUSE 13.2 prevents users from
> creating btrfs raid1 volumes entirely, or if it's just an install time
> limitation.

With BTRFS you can make it RAID-1 afterwards.  The possibility of data loss 
during system install usually isn't something you are concerned about so this 
shouldn't be a problem.

> I know that Fedora's installer won't allow the user to create Btrfs on
> LVM, and it probably doesn't allow it on md raid either.

For LVM that's reasonable, for MD-RAID that would be a bug IMHO.

On Mon, 1 Dec 2014, Roman Mamedov <rm@romanrm.net> wrote:
>   * mdadm RAID has much better read balancing;
>     Btrfs reads are satisfied from what's in effect a random drive
> (PID-based balancing of threads to drives), mdadm reads from the
> less-loaded drive. Also mdadm has a way to specify some RAID1 array
> members as to be never used for reads if at all possible ("write-mostly"),
> which helps in RAID1 of HDD and SSD.

True.  But that's just a lack of performance tuning in the current code, it 
will be fixed at some future time.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
