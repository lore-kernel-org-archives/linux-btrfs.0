Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:27105 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663Ab3EMRVQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 13:21:16 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Remove a materially failed device from a Btrfs "single-raid" using partitions
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5191071B.7090209@influence-pc.fr>
Date: Mon, 13 May 2013 11:21:12 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <5741BE95-3287-4054-A3AE-EC9CE4A26909@colorremedies.com>
References: <5190F59F.405@influence-pc.fr> <CAFWF=akT1vSPSXkAKCf9y3Ej63XSmBGC_MZKk0BCRxz2diCHFg@mail.gmail.com> <5190F9C7.1080904@influence-pc.fr> <CAFWF=ak4mKMgNZHx6pxuhY7pCEE0G-aifGNi_zRX5zyAUh7n-g@mail.gmail.com> <5191071B.7090209@influence-pc.fr>
To: Vincent <vincent@influence-pc.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 13, 2013, at 9:30 AM, Vincent <vincent@influence-pc.fr> wrote:

> Shit, I've followed the official documentation https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices
> 
> With, as explain:
> mkfs.btrfs -d single /dev/sda3 /dev/sdb1 /dev/sdc1 /dev/sdd1

You did this originally, not just a couple hours ago, right? Because if you did it again, of course you've deleted all of your data by creating a new file system.
> 
> mount -o degraded /dev/sda3 /media/single-raid/

This should work, and you should be able to rsync or copy the data off the file system onto a new one, except for data that's on the failed drive. I'm not sure what sort of errors you get when copying data that the file system knows isn't available.

> btrfs device delete missing /media/single-raid/

I don't expect this to apply to either -d single or -d raid0. It doesn't actually have any benefit or meaning. I'd say at best, my expectation is you could copy out the surviving data, in degraded mode, out of the btrfs file system onto a new file system. I do not expect it's possible to replace the dead drive and go happily along with just the missing data being lost. You'll have to create a new file system at some point.


> And now all my datas on ALL drive has been deleted. How could I retrieve datas on my Btrfs formatted partition now?!

If you really formatted it, I'd expect this. If that was an example of the original mkfs, I'd expect degraded should allow access to data on working drives. Maybe read/write is possible, but personally I'd prefer the file system in such a degraded state to be read only. And get the surviving data off.

But I am not a Btrfs developer.


Chris Murphy