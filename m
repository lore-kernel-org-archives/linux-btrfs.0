Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21232 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752512AbcJLBcY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 21:32:24 -0400
Subject: Re: RAID system with adaption to changed number of disks
To: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
Date: Wed, 12 Oct 2016 09:32:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/12/2016 07:58 AM, Chris Murphy wrote:
> https://btrfs.wiki.kernel.org/index.php/Status
> Scrub + RAID56 Unstable will verify but not repair
>
> This doesn't seem quite accurate. It does repair the vast majority of
> the time. On scrub though, there's maybe a 1 in 3 or 1 in 4 chance bad
> data strip results in a.) fixed up data strip from parity b.) wrong
> recomputation of replacement parity c.) good parity is overwritten
> with bad, silently, d.) if parity reconstruction is needed in the
> future e.g. device or sector failure, it results in EIO, a kind of
> data loss.
>
> Bad bug. For sure.
>
> But consider the identical scenario with md or LVM raid5, or any
> conventional hardware raid5. A scrub check simply reports a mismatch.
> It's unknown whether data or parity is bad, so the bad data strip is
> propagated upward to user space without error. On a scrub repair, the
> data strip is assumed to be good, and good parity is overwritten with
> bad.

Totally true.

Original RAID5/6 design is only to handle missing device, not rotted bits.

>
> So while I agree in total that Btrfs raid56 isn't mature or tested
> enough to consider it production ready, I think that's because of the
> UNKNOWN causes for problems we've seen with raid56. Not the parity
> scrub bug which - yeah NOT good, not least of which is the data
> integrity guarantees Btrfs is purported to make are substantially
> negated by this bug. I think the bark is worse than the bite. It is
> not the bark we'd like Btrfs to have though, for sure.
>

Current btrfs RAID5/6 scrub problem is, we don't take full usage of tree 
and data checksum.

In ideal situation, btrfs should detect which stripe is corrupted, and 
only try to recover data/parity if recovered data checksum matches.

For example, for a very traditional RAID5 layout like the following:

   Disk 1    |   Disk 2    |  Disk 3     |
-----------------------------------------
   Data 1    |   Data 2    |  Parity     |

Scrub should check data stripe 1 and 2, against their checksum first

[All data extents has csum]
1) All csum matches
    Good, then check parity.
    1.1) Parity matches
         Nothing wrong at all

    1.1) Parity mismatch
         Just recalculate parity. Corruption may happen in unused data
         space or in parity. Either way recalculate parity is good
         enough.

2) One data stripe csum mismatches(missing), parity mismatches too
    We only know one data stripe mismatch, not sure if parity is OK.
    Try to recover that data stripe from parity, and recheck csum.

    2.1) Recovered data stripe matches csum
         That data stripe is corrupted and parity is OK
         Recoverable.

    2.2) Recovered data stripe mismatch csum
         Both that data stripe and parity is corrupted.

3) Two data stripes csum mismatch, no matter parity matches or not
    At least 2 stripes are screwed up. no fix anyway.

[Some data extents has no csum(nodatasum)]
4) Existing(or no csum at all) csum matches, parity matches
    Good, nothing to worry about

5) Exist csum mismatch for one data stripe, parity mismatch
    Like 2), try to recover that data stripe, and re-check csum.

    5.1) recovered data stripes matches csum
         At least we can recover the data covered by csum.
         Corrupted no-csum data is not our concern.

    5.2) recovered data stripes mismatches csum
         Screwed up

6) No csum at all, parity mismatch
    We are screwed up, just like traditional RAID5.

And I'm coding for the above cases in btrfs-progs to implement an 
off-line scrub tool.

Currently it looks good, and can already handle case from 1) to 3).
And I tend to ignore any full stripe who lacks checksum and parity 
mismatches.

But as you can see, there are so many things(csum exists,matches pairty 
matches, missing devices) involved in btrfs RAID5(RAID6 will be more 
complex), it's already much complex than traditional RAID5/6 or current 
scrub implementation.


So what current kernel scub lacks is:
1) Detection of good/bad stripes
2) Recheck of recovery attempts

But that's all traditional RAID5/6 lacks unless there is some hidden 
checksum like btrfs they can use.

Thanks,
Qu


