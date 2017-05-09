Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43686 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdEIFP0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 01:15:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d7xUT-00041z-Fb
        for linux-btrfs@vger.kernel.org; Tue, 09 May 2017 07:15:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "Corrected" errors persist after scrubbing
Date: Tue, 9 May 2017 05:15:11 +0000 (UTC)
Message-ID: <pan$d3e73$ea803de4$43e524a3$646b47cc@cox.net>
References: <92b9b7cd-5b54-775f-95c1-4788b2d3ea67@hale.ee>
        <CAJCQCtRmMtm5PW-TsUw+erQdXC9K41F0Nys5R+CRv0=KRh7aHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 08 May 2017 13:26:16 -0600 as excerpted:

> On Sat, May 6, 2017 at 4:33 AM, Tom Hale <tom@hale.ee> wrote:
>> Below (and also attached because of formatting) is an example of `btrfs
>> scrub` incorrectly reporting that errors have been corrected.
>>
>> In this example, /dev/md127 is the device created by running:
>> mdadm --build /dev/md0 --level=faulty --raid-devices=1 /dev/loop0
>>
>> The filesystem is RAID1.
>>
>> # mdadm --grow /dev/md0 --layout=rp400
>> layout for /dev/md0 set to 12803
>> # btrfs scrub start -Bd /mnt/tmp
>> scrub device /dev/md127 (id 1) done
>>         scrub started at Fri May  5 19:23:54 2017 and finished after
>> 00:00:01
>>         total bytes scrubbed: 200.47MiB with 8 errors
>>         error details: read=8
>>         corrected errors: 8, uncorrectable errors: 0, unverified errors: 248
>> scrub device /dev/loop1 (id 2) done
>>         scrub started at Fri May  5 19:23:54 2017 and finished after
>> 00:00:01
>>         total bytes scrubbed: 200.47MiB with 0 errors
>> WARNING: errors detected during scrubbing, corrected
>> # ### But the errors haven't really been corrected, they're still there:
>> # mdadm --grow /dev/md0 --layout=clear # Stop producing additional errors
>> layout for /dev/md0 set to 31
>> # btrfs scrub start -Bd /mnt/tmp
>> scrub device /dev/md127 (id 1) done
>>         scrub started at Fri May  5 19:24:24 2017 and finished after
>> 00:00:00
>>         total bytes scrubbed: 200.47MiB with 8 errors
>>         error details: read=8
>>         corrected errors: 8, uncorrectable errors: 0, unverified errors: 248
>> scrub device /dev/loop1 (id 2) done
>>         scrub started at Fri May  5 19:24:24 2017 and finished after
>> 00:00:00
>>         total bytes scrubbed: 200.47MiB with 0 errors
>> WARNING: errors detected during scrubbing, corrected
>> #
> 
> 
> What are the complete kernel messages for the scrub event? This should
> show what problem Btrfs detects and how it fixes it, and what sectors
> it's fixing each time.

I'm also wondering what version of kernel and btrfs-progs are being
used here.  For two reasons:

First:

AFAIK newer code shouldn't report unverified, which was originally
reported for blocks where the checksums of the blocks containing the
checksums of the unverified errors were in bad blocks.  IOW, the lower
branches of the tree couldn't be checked because higher ones were
still being repaired.

Back then, in ordered to fix such errors, one had to do multiple passes
manually, until there were no more unverified errors, each pass fixing
errors at one level so the levels below it could actually be checked in
the next pass.

I know because I had a pair of ssds where I deliberately kept an ssd
that was going bad in the btrfs raid1 pair, in ordered to see how things
worked over time.  So I got quite some experience running and rerunning
scrubs until all the errors were corrected after multiple passes!

But newer versions catch that problem and I believe actually use the
second copy for the verifications, so as long as there's no uncorrectable,
there should be no unverified, either.  (Either that or they do multiple
passes automatically, like I used to do manually.  I'm not sure which
except the former should be simpler and faster so I suspect that's what's
done.)

So the fact that there's unverified errors reported hints to me that
the used versions may be old.  Either that, or it's a different mechanism
generating the unverified, that I'm not familiar with and that doesn't
get corrected from the other copy or via multipass like the ones I have
experience with do.  But that's why I say "hint".

Second:

AFAIK there was a short period around kernel 4.10 and early 4.11-rcs where
read-errors were indeed not being corrected properly.  To my knowledge this
was in operation, not scrub, but perhaps certain scrub cases were affected
as well.

AFAIK this problem is entirely fixed in 4.11 release, and presumably in the
4.10 stables, and I don't believe 4.8 and earlier were affected at all (but
I'm not sure about 4.9, I /think/ it was before the regression, but some
4.9-stable releases /might/ be affected), but whatever the OP's running
/might/ just be in that gap, it'd take a dev or someone following those
specific patches closer than I did to know specifically what's affected
and thus be able to say for sure, if the OP's running something 4.9 or 4.10,
or early 4.11-rcs, but not the latest 4.11 release.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

