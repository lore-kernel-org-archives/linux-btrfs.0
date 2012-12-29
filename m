Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59278 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2L2DOq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 22:14:46 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Chris Murphy <lists@colorremedies.com>
Subject: Re: corrupt filesystem after snapshots on 3.2
Date: Sat, 29 Dec 2012 14:14:35 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201212291031.44745.russell+btrfs@coker.com.au> <E14A2E56-6517-4634-ACDD-099C4D2AE315@colorremedies.com>
In-Reply-To: <E14A2E56-6517-4634-ACDD-099C4D2AE315@colorremedies.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201212291414.37552.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 29 Dec 2012, Chris Murphy <lists@colorremedies.com> wrote:
> Add another disk, or disk partition, to the Btrfs volume. That'll give it
> more space and hopefully you can back out at that point.

# df -h /mnt/tmp
Filesystem              Size  Used Avail Use% Mounted on
/dev/mapper/rjca-crypt   12G   12G  637M  95% /mnt/tmp

I didn't expect that to work because the filesystem already reported free 
space.  I removed the snapshots and had problems during/after the removal so 
it seemed that there was space.

# btrfs filesystem show --all-devices
Label: none  uuid: 0f0b48e9-d2f7-4280-b417-4d1f5a933975
        Total devices 3 FS bytes used 5.63GB
        devid    1 size 6.00GB used 6.00GB path /dev/dm-16
        devid    2 size 6.00GB used 6.00GB path /dev/dm-17
        devid    3 size 6.00GB used 19.00MB path /dev/dm-18

However I've added another device and now "du -h" completes without any kernel 
panic (a major improvement).  Now I'm seeing the above, apparently 19MB used 
on the new dm-18 device seems to be making all the difference.

# btrfs subvol list /mnt/tmp
ERROR: Failed to lookup path for root 0 - No such file or directory

Strangely I was getting the above error while the btrfs scrub was in progress, 
but it went away when the scrub finished.  That seems like a bug to me.

Now the filesystem is now OK and I've copied all the data off it.  The data 
appears to be all intact (much of it could be verified against another system).

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
