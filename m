Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:56842
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739Ab2L1FDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 00:03:18 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Another novice question & comment
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201212281134.10604.russell@coker.com.au>
Date: Thu, 27 Dec 2012 22:03:13 -0700
Cc: "linux-btrfs Mailing list" <linux-btrfs@vger.kernel.org>
Message-Id: <89B2AE69-E8D1-46FA-ABE9-8A6BDA352B6E@colorremedies.com>
References: <50DC5B51.9060506@czarc.net> <50DCA11C.2050501@czarc.net> <5BAA2347-6336-4C05-B075-BEF93427EF07@colorremedies.com> <201212281134.10604.russell@coker.com.au>
To: russell@coker.com.au
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 27, 2012, at 5:34 PM, Russell Coker <russell@coker.com.au> wrote:

> On Fri, 28 Dec 2012, Chris Murphy <lists@colorremedies.com> wrote:
>> On Dec 27, 2012, at 12:27 PM, Gene Czarcinski <gene@czarc.net> wrote:
>>> Oh thanks for that little reminder that you can put btrfs on an LV.
>> 
>> I find it's more trouble than it's worth. It doesn't bring much to the
>> table.
> 
> I've tried using LVM and BTRFS together.  While they work the combination 
> doesn't seem to offer much benefit.  LVM is good for snapshots (which BTRFS does 
> better) and also for dividing a device that is larger than your filesystem can 
> properly support (also not a problem for BTRFS).
> 
> http://etbe.coker.com.au/2012/12/17/using-btrfs/
> 
> At the above URL I've documented some of the things I'm currently doing with 
> BTRFS in production.  I'm still considering what's the best way of managing 
> virtual machines. My current method is to run a server with two disks that 
> have separate LVM VGs and give each VM a pair of block devices to run BTRFS 
> RAID-1.
> 
> The other option I'm considering is a single BTRFS RAID-1 taking all disk 
> space and giving each VM a single block device that's a file on the BTRFS 
> filesystem.  Presumably that will give a significant performance hit because of 
> double filesystem overhead but will make management a little easier and 
> possibly reduce seeks when multiple VMs are writing to disk.

What the VMs are doing makes a big difference. But in any case you'd need to benchmark the various configurations that are possible.

Off hand it seems to be better to have the host running the more complex/capable file system, in this case btrfs on whole drives. And then the guests write to a file, with a simpler file system like ext4, and optionally disable journaling.

For a handful of VMs that aren't doing heavy writes, then either dedicated partitions or LVs (in effect the same thing), is probably OK. But I suspect as you get busier VMs, or add more VMs, this will not scale. You'll quickly get too much disk contention, VM's demanding their own disk region is being written to NOW and will simply slow down while they wait for the disk to handle the request. Whereas if you have the VM guests use ext4 (optionally disable journaling) to a file, either XFS or Btrfs will aggregate those requests much more efficiently than individual VMs can.

But still needs to be tested.

Chris Murphy