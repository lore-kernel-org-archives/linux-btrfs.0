Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:54545 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdLBBn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 20:43:58 -0500
Date: Sat, 2 Dec 2017 02:43:57 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202014357.GC20205@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl>
 <2a14e451-c3fb-1e58-41dd-e98aeb5d24ec@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <2a14e451-c3fb-1e58-41dd-e98aeb5d24ec@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 02, 2017 at 09:05:50 +0800, Qu Wenruo wrote:

>> qgroupid         rfer         excl 
>> --------         ----         ---- 
>> 0/260        12.25GiB      3.22GiB	from 170712 - first snapshot
>> 0/312        17.54GiB      4.56GiB	from 170811
>> 0/366        25.59GiB      2.44GiB	from 171028
>> 0/370        23.27GiB     59.46MiB 	from 111118 - prev snapshot
>> 0/388        21.69GiB      7.16GiB	from 171125 - last snapshot
>> 0/291        24.29GiB      9.77GiB	default subvolume
> 
> You may need to manually sync the filesystem (trigger a transaction
> commitment) to update qgroup accounting.

The data I've pasted were just calculated.

>> # btrfs quota enable /
>> # btrfs qgroup show /
>> WARNING: quota disabled, qgroup data may be out of date
>> [...]
>> # btrfs quota enable /		- for the second time!
>> # btrfs qgroup show /
>> WARNING: qgroup data inconsistent, rescan recommended
> 
> Please wait the rescan, or any number is not correct.

Here I was pointing that first "quota enable" resulted in "quota
disabled" warning until I've enabled it once again.

> It's highly recommended to read btrfs-quota(8) and btrfs-qgroup(8) to
> ensure you understand all the limitation.

I probably won't understand them all, but this is not an issue of my
concern as I don't use it. There is simply no other way I am aware that
could show me per-subvolume stats. Well, straightforward way, as the
hard way I'm using (btrfs send) confirms the problem.

You could simply remove all the quota results I've posted and there will
be the underlaying problem, that the 25 GB of data I got occupies 52 GB.
At least one recent snapshot, that was taken after some minor (<100 MB) changes
from the subvolume, that has undergo some minor changes since then,
occupied 8 GB during one night when the entire system was idling.

This was crosschecked on files metadata (mtimes compared) and 'du'
results.


As a last-resort I've rebalanced the disk (once again), this time with
-dconvert=raid1 (to get rid of the single residue).

-- 
Tomasz Pala <gotar@pld-linux.org>
