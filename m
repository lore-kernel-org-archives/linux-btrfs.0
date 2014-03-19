Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55440 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752899AbaCSGc5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 02:32:57 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53119 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WQA3c-002tkH-QY
	for linux-btrfs@vger.kernel.org; Wed, 19 Mar 2014 00:32:57 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5 mostly works, just no rebuilds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140319060902.GM6143@merlins.org>
Date: Wed, 19 Mar 2014 00:32:55 -0600
Message-Id: <CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com> <1395002246-3840-1-git-send-email-fdmanana@gmail.com> <20140316222026.GU16946@merlins.org> <pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net> <20140319060902.GM6143@merlins.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 19, 2014, at 12:09 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> 7) you can remove a drive from an array, add files, and then if you plug
>   the drive in, it apparently gets auto sucked in back in the array.
> There is no rebuild that happens, you now have an inconsistent array where
> one drive is not at the same level than the other ones (I lost all files I added 
> after the drive was removed when I added the drive back).

Seems worthy of a dedicated bug report and keeping an eye on in the future, not good.

>> 
>> polgara:/mnt/btrfs_backupcopy# df -h .
>> Filesystem              Size  Used Avail Use% Mounted on
>> /dev/mapper/crypt_sdb1  4.1T  3.0M  4.1T   1% /mnt/btrfs_backupcopy
> 
> Let's add one drive
>> polgara:/mnt/btrfs_backupcopy# btrfs device add -f /dev/mapper/crypt_sdm1 /mnt/btrfs_backupcopy/
>> polgara:/mnt/btrfs_backupcopy# df -h .
>> Filesystem              Size  Used Avail Use% Mounted on
>> /dev/mapper/crypt_sdb1  4.6T  3.0M  4.6T   1% /mnt/btrfs_backupcopy
> 
> Oh look it's bigger now. We need to manual rebalance to use the new drive:

You don't have to. As soon as you add the additional drive, newly allocated chunks will stripe across all available drives. e.g. 1 GB allocations striped across 3x drives, if I add a 4th drive, initially any additional writes are only to the first three drives but once a new data chunk is allocated it gets striped across 4 drives.


> 
> In other words, btrfs happily added my device that was way behind and gave me an incomplete fileystem instead of noticing
> that sdj1 was behind and giving me a degraded filesystem.
> Moral of the story: do not ever re-add a device that got kicked out if you wrote new data after that, or you will end up with an older version of your filesystem (on the plus side, it's consistent and apparently without data corruption. That said, btrfs scrub complained loudly of many errors it didn't know how to fix.

Sure the whole thing isn't corrupt. But if anything written while degraded vanishes once the missing device is reattached, and you remount normally (non-degraded), that's data loss. Yikes!


> There you go, hope this helps.

Yes. Thanks!

Chris Murphy