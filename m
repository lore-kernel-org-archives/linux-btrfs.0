Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:59837 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbeGPS63 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 14:58:29 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: waxhead@dirtcellar.net, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
Date: Mon, 16 Jul 2018 20:29:46 +0200
MIME-Version: 1.0
In-Reply-To: <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2018 04:37 PM, waxhead wrote:
> David Sterba wrote:
>> An interesting question is the naming of the extended profiles. I picked
>> something that can be easily understood but it's not a final proposal.
>> Years ago, Hugo proposed a naming scheme that described the
>> non-standard raid varieties of the btrfs flavor:
>>
>> https://marc.info/?l=linux-btrfs&m=136286324417767
>>
>> Switching to this naming would be a good addition to the extended raid.
>>
> As just a humble BTRFS user I agree and really think it is about time to move far away from the RAID terminology. However adding some more descriptive profile names (or at least some aliases) would be much better for the commoners (such as myself).
> 
> For example:
> 
> Old format / New Format / My suggested alias
> SINGLE  / 1C     / SINGLE
> DUP     / 2CD    / DUP (or even MIRRORLOCAL1)
> RAID0   / 1CmS   / STRIPE


> RAID1   / 2C     / MIRROR1
> RAID1c3 / 3C     / MIRROR2
> RAID1c4 / 4C     / MIRROR3
> RAID10  / 2CmS   / STRIPE.MIRROR1

Striping and mirroring/pairing are orthogonal properties; mirror and parity are mutually exclusive. What about

RAID1 -> MIRROR1
RAID10 -> MIRROR1S
RAID1c3 -> MIRROR2
RAID1c3+striping -> MIRROR2S

and so on...

> RAID5   / 1CmS1P / STRIPE.PARITY1
> RAID6   / 1CmS2P / STRIPE.PARITY2

To me these should be called something like

RAID5 -> PARITY1S
RAID6 -> PARITY2S

The S final is due to the fact that usually RAID5/6 spread the data on all available disks

Question #1: for "parity" profiles, does make sense to limit the maximum disks number where the data may be spread ? If the answer is not, we could omit the last S. IMHO it should. 
Question #2: historically RAID10 is requires 4 disks. However I am guessing if the stripe could be done on a different number of disks: What about RAID1+Striping on 3 (or 5 disks) ? The key of striping is that every 64k, the data are stored on a different disk....







> 
> I find that writing something like "btrfs balance start -dconvert=stripe5.parity2 /mnt" is far less confusing and therefore less error prone than writing "-dconvert=1C5S2P".
> 
> While Hugo's suggestion is compact and to the point I would call for expanding that so it is a bit more descriptive and human readable.
> 
> So for example : STRIPE<num> where <num> obviously is the same as Hugo proposed - the number of storage devices for the stripe and no <num> would be best to mean 'use max devices'.
> For PARITY then <num> is obviously required
> 
> Keep in mind that most people (...and I am willing to bet even Duncan which probably HAS backups ;) ) get a bit stressed when their storage system is degraded. With that in mind I hope for more elaborate, descriptive and human readable profile names to be used to avoid making mistakes using the "compact" layout.
> 
> ...and yes, of course this could go both ways. A more compact (and dare I say cryptic) variant can cause people to stop and think before doing something and thus avoid errors,
> 
> Now that I made my point I can't help being a bit extra hash, obnoxious and possibly difficult so I would also suggest that Hugo's format could have been changed (dare I say improved?) from....
> 
> numCOPIESnumSTRIPESnumPARITY
> 
> to.....
> 
> REPLICASnum.STRIPESnum.PARITYnum
> 
> Which would make the above table look like so:
> 
> Old format / My Format / My suggested alias
> SINGLE  / R0.S0.P0 / SINGLE
> DUP     / R1.S1.P0 / DUP (or even MIRRORLOCAL1)
> RAID0   / R0.Sm.P0 / STRIPE
> RAID1   / R1.S0.P0 / MIRROR1
> RAID1c3 / R2.S0.P0 / MIRROR2
> RAID1c4 / R3.S0.P0 / MIRROR3
> RAID10  / R1.Sm.P0 / STRIPE.MIRROR1
> RAID5   / R1.Sm.P1 / STRIPE.PARITY1
> RAID6   / R1.Sm.P2 / STRIPE.PARITY2
> 
> And i think this is much more readable, but others may disagree. And as a side note... from a (hobby) coders perspective this is probably simpler to parse as well.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
