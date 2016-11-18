Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:49546 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752017AbcKRSJi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 13:09:38 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/2] RAID5/6 scrub race fix
References: <20161115025024.25299-1-quwenruo@cn.fujitsu.com>
 <20161117231310.GN21290@hungrycats.org>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <dc2a9254-fd86-a448-c327-d3ea2ea20ddd@libero.it>
Date: Fri, 18 Nov 2016 19:09:34 +0100
MIME-Version: 1.0
In-Reply-To: <20161117231310.GN21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zygo
On 2016-11-18 00:13, Zygo Blaxell wrote:
> On Tue, Nov 15, 2016 at 10:50:22AM +0800, Qu Wenruo wrote:
>> Fix the so-called famous RAID5/6 scrub error.
>>
>> Thanks Goffredo Baroncelli for reporting the bug, and make it into our
>> sight.
>> (Yes, without the Phoronix report on this,
>> https://www.phoronix.com/scan.php?page=news_item&px=Btrfs-RAID-56-Is-Bad,
>> I won't ever be aware of it)
> 
> If you're hearing about btrfs RAID5 bugs for the first time through
> Phoronix, then your testing coverage is *clearly* inadequate.
> 
> Fill up a RAID5 array, start a FS stress test, pull a drive out while
> that's running, let the FS stress test run for another hour, then try
> to replace or delete the missing device.  If there are any crashes,
> corruptions, or EIO during any part of this process (assuming all the
> remaining disks are healthy), then btrfs RAID5 is still broken, and
> you've found another bug to fix.
> 
> The fact that so many problems in btrfs can still be found this way
> indicates to me that nobody is doing this basic level of testing
> (or if they are, they're not doing anything about the results).

[...]

Sorry but I don't find useful this kind of discussion. 
Yes BTRFS RAID5/6 needs a lot of care. Yes, *our* test coverage is far to be complete; but this is not a fault of a single person; and Qu tried to solve one issue and for this we should say only tanks..

Even if you don't find valuable the work of Qu (and my little one :-) ), this required some time and need to be respected.

Finally, I don't think that we should compare the RAID-hole with this kind of bug(fix). The former is a design issue, the latter is a bug related of one of the basic feature of the raid system (recover from the lost of a disk/corruption).

Even the MD subsystem (which is far behind btrfs) had tolerated the raid-hole until last year. And its solution is far to be cheap (basically the MD subsystem wrote the data first in the journal then on the disk... which is the kind of issue that a COW filesystem would solve).

BR
G.Baroncelli






-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
