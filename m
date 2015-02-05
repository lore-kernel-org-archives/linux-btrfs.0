Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47379 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750706AbbBEFQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 00:16:25 -0500
Message-ID: <54D2FCA7.4070108@cn.fujitsu.com>
Date: Thu, 5 Feb 2015 13:16:23 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: What does scrub tell me?
References: <CAPs0Big=8SsBRFjrDPcradYW100GUnWEzC=ycvvDQScTSYKt5A@mail.gmail.com> <pan$e108e$e9933d01$2069a082$32e36a2e@cox.net>
In-Reply-To: <pan$e108e$e9933d01$2069a082$32e36a2e@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: What does scrub tell me?
From: Duncan <1i5t5.duncan@cox.net>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年02月05日 11:43
> Sandy McArthur Jr posted on Wed, 04 Feb 2015 12:31:07 -0500 as excerpted:
>
>> Does a btrfs scrub verify the integrity of the whole filesystem or just
>> the data in that filesystem?
> Btrfs scrub verifies both data and metadata /checksum/ integrity.  From
> the below it looks like that's very likely what you're most worried about
> anyway and you likely already get what I explain in the next paragraph,
> but for the benefit of others that read this... =:^)
>
> A lot of people misunderstand what scrub does and try to use it as if it
> were btrfs check, verifying metadata structure and function integrity as
> well, and then wonder why their filesystem passes scrub and yet won't
> balance or has other filesystem errors.  Thus the emphasis on
> /checksum/.  (Meta)data can be valid as saved and still be corrupt,
> because it was corrupted before the save due to a bug.  The checksum, and
> thus scrub, verifies that you're getting exactly what was saved, but it,
> by itself, doesn't say anything about whether what was saved was actually
> valid in the first place, and a lot of folks miss the significance of
> that difference until it is explained to them.
>
>> I recently removed some unreliable drives from my multi-volume RAID1
>> btrfs filesystem and ran a scrub that completed with two corrected
>> errors (see below).  I've struggled with this filesystem due to poor
>> choices in hardware on my part and had to recover it several times. As
>> of now I've eliminated all older drives or drives labeled as "desktop"
>> drives. (Knowing what I know now, I'm impressed with how well btrfs has
>> preserved my data despite myself.)
>>
>> I'm at a point where I can grow my existing btrfs filesystem as RAID1 or
>> I can afford to migrate data to a new btrfs single filesystem and then
>> add drives back in to get back to RAID1 mirroring again. Is there value
>> to starting a fresh btrfs filesystem given my history?
>>
>>
>> # btrfs scrub status /mcmedia/ ; echo ; btrfs --version
>> scrub status for 94b3345e-2589-423c-a228-d569bf94ab58
>> scrub resumed at Mon Feb  2 22:03:14 2015 and finished after 204126
>> seconds
>> total bytes scrubbed: 23.38TiB with 2 errors
>> error details: csum=2
>> corrected errors: 2, uncorrectable errors: 0, unverified errors: 0
>>
>> Btrfs v3.18.2
> If you like you can run a btrfs check (--readonly, without --repair or
> similar write option) and/or btrfs balance, and if they complete without
> error, it's reasonably safe to assume your filesystem is "clean".
A small note here, default btrfsck (--readonly,or even with --repair) 
will not detect data csum error.
You can make btrfsck to check data csum by using --check-data-csum option.

If it is data csum error only, that means you are lucky enough, btrfsck 
--init-csum-tree will recalculate data
csum. So even there may be some error in your data, but you can still 
read them out.

Or, if the error is in your metadata, that's bad, it may cause disaster 
from missing a lot of files to kernel panic.

Or, it's just a false alert, like RAID5/6 will report false alert result 
due to kernel bug.

Thanks,
Qu


>
> That said, personally, I prefer to start "clean" every few kernel (and
> thus btrfs-tools userspace as well) cycles in any case, for a couple
> reasons.
>
> Here, I do it as part of my regular backup cycle, where my first-level
> backup is a set of btrfs of the same size, and I do a fresh mkfs.btrfs to
> purge the old backup, mount the new filesystem, copy everything over from
> the working filesystem, reboot to the backup (for root) or unmount the
> working btrfs and mount the backup to test the backup, then when I'm
> satisfied with the now tested backup, reverse the cycle, doing a
> mkfs.btrfs of my normal working filesystem and copying everything back
> from the backup.  (FWIW, my second level backup is non-btrfs, reiserfs in
> my case since I've used it for years and it has proved itself very
> resilient since data=ordered by default, thru the various hardware issues
> I've had.  I do test pre-release kernels and that way, if there's a
> serious btrfs bug that eats both my working copy and the backup when I
> try to boot to it for recovery, I still have the reiserfs backup, which
> will hopefully be unaffected.)
>
> The reasons:
>
> 1) Btrfs is still under rapid, not entirely stable yet, development.  By
> starting clean I eliminate the filesystem back-history and with it the
> possibility of some previously unknown side effect of some long fixed bug
> coming back to haunt me.  This probably isn't as likely to eliminate
> issues now as it was back before say 3.11 (when they started dropping the
> most dire warnings, IIRC), but I'm used to doing it now, and call it
> sysadmin superstition if you like, but I still rest better when I can
> say, OK, I know for sure that filesystem couldn't have been affected by
> anything previous to 3.x kernel and userspace, as that's when I created
> it.
>
> 2) As long as you don't have to worry about compatibility with old
> kernels, a fresh mkfs.btrfs allows you to take advantage of (relatively)
> newer filesystem options like skinny-metadata, no-holes, and 16 KiB
> nodesizes.  These make the filesystem more efficient.  While some such
> features can be enabled at runtime, not all of them can, and the old data/
> metadata will still be written with the old options until a balance or
> whatever to rewrite them.
>
> Of course if you need to maintain compatibility with old enough kernels
> you'll want to turn off these features anyway, and this reason disappears.
>
> Meanwhile, if the filesystem is still reasonably new, time-wise, even if
> it has been thru some tough hardware issues, and you originally created
> it with the options you wanted already, this reason goes away in that
> case as well, as the available options have remained steady for awhile
> now, tho the defaults have recently changed for a couple of them.
>
> Bottomline:
>
> While you're likely fine in terms of filesystem stability, particularly
> if you run a btrfs check and a balance and they both work fine, I'd still
> personally recommend a fresh mkfs for the reasons above, given the
> current opportunity and the fact that running the check and balance are
> likely to take a good chunk of the time that starting with a fresh
> mkfs.btrfs, copying things over, and balancing back to the expanded
> raid1, would take, and you won't know if the existing setup is reliable
> until you do that check and balance anyway, so you may well end up with a
> clean filesystem in any case.
>
> IOW, if it were my system, I'd go the clean mkfs.btrfs route. =:^)
>

