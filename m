Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50527 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2L1AeR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 19:34:17 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Chris Murphy <lists@colorremedies.com>
Subject: Re: Another novice question & comment
Date: Fri, 28 Dec 2012 11:34:10 +1100
Cc: "linux-btrfs Mailing list" <linux-btrfs@vger.kernel.org>
References: <50DC5B51.9060506@czarc.net> <50DCA11C.2050501@czarc.net> <5BAA2347-6336-4C05-B075-BEF93427EF07@colorremedies.com>
In-Reply-To: <5BAA2347-6336-4C05-B075-BEF93427EF07@colorremedies.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212281134.10604.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Dec 2012, Chris Murphy <lists@colorremedies.com> wrote:
> On Dec 27, 2012, at 12:27 PM, Gene Czarcinski <gene@czarc.net> wrote:
> > Oh thanks for that little reminder that you can put btrfs on an LV.
> 
> I find it's more trouble than it's worth. It doesn't bring much to the
> table.

I've tried using LVM and BTRFS together.  While they work the combination 
doesn't seem to offer much benefit.  LVM is good for snapshots (which BTRFS does 
better) and also for dividing a device that is larger than your filesystem can 
properly support (also not a problem for BTRFS).

http://etbe.coker.com.au/2012/12/17/using-btrfs/

At the above URL I've documented some of the things I'm currently doing with 
BTRFS in production.  I'm still considering what's the best way of managing 
virtual machines. My current method is to run a server with two disks that 
have separate LVM VGs and give each VM a pair of block devices to run BTRFS 
RAID-1.

The other option I'm considering is a single BTRFS RAID-1 taking all disk 
space and giving each VM a single block device that's a file on the BTRFS 
filesystem.  Presumably that will give a significant performance hit because of 
double filesystem overhead but will make management a little easier and 
possibly reduce seeks when multiple VMs are writing to disk.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
