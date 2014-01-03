Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54157 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaACB4P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2014 20:56:15 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Tim Cuthbertson <ratcheer@gmail.com>
Subject: Re: Managing large volumes
Date: Fri, 3 Jan 2014 12:55:43 +1100
Cc: linux-btrfs@vger.kernel.org
References: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
In-Reply-To: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201401031255.43845.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 3 Jan 2014, Tim Cuthbertson <ratcheer@gmail.com> wrote:
> I am a bit confused and I have probably managed to outsmart myself.
> For about 15 months, I have been running my system on a single, large
> btrfs volume. It is RAID-0 on two SATA-III HDD's for a total of 1.9
> TB. This is a home system running Siduction (Debian Sid) Linux. While
> I have root, home, and a special data directory each as separate
> subvolumes, I am beginning to wonder whether I should have made each
> of these on separate partitions and separate btrfs filesystems.

Why do you use RAID-0?

> Am am at a point where I would like to do a fresh install of my OS
> without losing my home and data contents. And I do not think separate
> btrfs subvolumes will help me on that. Is that correct? Is there a way
> to prevent an OS installation from formatting the /home and /data
> subvolumes while completely replacing the root subvolume? Or do I need
> to completely repartition my drives so I don't get into this
> situation, again?

A fairly standard OS install feature is to not run mkfs on a partition.  So if 
you had your system configured such that the current root is a subvol and that 
the root of the BTRFS filesystem has no names that match a regular 
installation (IE not having /usr etc) then it should just work.  Even if you 
use a /home subvol for the home directories that shouldn't be a real problem 
as the account creation process shouldn't remove old accounts.

One other issue you may have is that you need the installer to have a new 
enough kernel to support the filesystem.  If you install a system from a 
Debian/Wheezy CD and then upgrade it to Debian/Unstable then I think it gets 
some new filesystem features that make it impossible to mount with 
Debian/Wheezy.  I recall having to upgrade a Debian/Wheezy system to a 
Debian/Unstable kernel so it could mount a BTRFS removable device that had 
been mounted on a Debian/Unstable system.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
