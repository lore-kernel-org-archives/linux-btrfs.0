Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47179 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaCQAv4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 20:51:56 -0400
Date: Sun, 16 Mar 2014 17:51:45 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20140317005145.GZ16946@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
 <20140316231729.GA29149@merlins.org>
 <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com>

On Sun, Mar 16, 2014 at 05:23:25PM -0600, Chris Murphy wrote:
> 
> On Mar 16, 2014, at 5:17 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > - but no matter how I remove the faulty drive, there is no rebuild on a
> >  new drive procedure that works yet
> > 
> > Correct?
> 
> I'm not sure. From what I've read we should be able to add a device to raid5/6, but I don't know if it's expected we can add a device to a degraded raid5/6. If the add device succeeded, then I ought to be able to remove the missing devid, and then do a balance which should cause reconstruction.
> 
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30714.html

Thanks for the link, that's what I thought I read recently.

So, on 3.14, I can confirm
polgara:/mnt/btrfs_backupcopy# btrfs replace start 3 /dev/sdm1 /mnt/btrfs_backupcopy
[68377.679233] BTRFS warning (device dm-9): dev_replace cannot yet handle RAID5/RAID6

polgara:/mnt/btrfs_backupcopy# btrfs device delete /dev/mapper/crypt_sde1 `pwd`
ERROR: error removing the device '/dev/mapper/crypt_sde1' - Invalid argument
and yet
Mar 16 17:48:35 polgara kernel: [69285.032615] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 805, rd 4835, flush 0, corrupt 0, gen 0
Mar 16 17:48:35 polgara kernel: [69285.033791] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
Mar 16 17:48:35 polgara kernel: [69285.034379] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 806, rd 4835, flush 0, corrupt 0, gen 0
Mar 16 17:48:35 polgara kernel: [69285.035361] BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
Mar 16 17:48:35 polgara kernel: [69285.035943] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 807, rd 4835, flush 0, corrupt 0, gen 0

So from here, it sounds like I can try:
1) unmount the filesystem
2) hope that remounting it without that device will work
3) btrfs device add to recreate the missing drive.

Before I do #1 and get myself in a worse state than I am (working
filesystem), does that sound correct?

(again, the data is irrelevant, I have a btrfs receive on it that has
been running for hours and that I'd have to restart, but that's it).

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
