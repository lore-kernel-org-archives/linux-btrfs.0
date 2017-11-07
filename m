Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933540AbdKGIpb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 03:45:31 -0500
Subject: Re: feedback on three different scrub methods
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTsfNgSBDdnq0uFd1ZRRY0AWbv=rx5X1UUGp1i9hK-4hw@mail.gmail.com>
 <f5558865-088d-66c7-e168-e99da9f7532d@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <523ef442-8be9-f1e2-d1a3-ab7e2f8a85c3@suse.com>
Date: Tue, 7 Nov 2017 10:45:27 +0200
MIME-Version: 1.0
In-Reply-To: <f5558865-088d-66c7-e168-e99da9f7532d@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.11.2017 02:54, Qu Wenruo wrote:
> 
> 
> On 2017年11月07日 04:17, Chris Murphy wrote:
>> I just did scrubs on five different volumes using all three scrub
>> methods. There were no errors found, so the test leaves uncertain what
>> the error handling differences are between the three scrubs. But at
>> the least with no errors, there are also no disagreements between the
>> three methods.
>>
>> 1. Speed. Both normal online scrub and the btrfsck --check-data-csum
>> methods, I get ~275MB/s transfers per iotop. Whereas with --offline
>> scrub I'm seeing 60%-67% of that, or ~170MB/s transfers. That's
>> substantially slower. If it were using less CPU or the system more
>> responsive, it might be worth that trade off in time. But the CPU %
>> and system responsiveness for other tasks seemed the same, it just
>> took longer.
> 
> First, --check-data-csum will only check the first copy if it's good.
> So --check-data-csum is doing a little cheating here.
> 
> Further more, IIRC current offline scrub branch doesn't have the extent
> cache enabled, and since it's completely relying on extent tree, quite a
> lot of time is spent on doing similar tree search and causing extra
> random IO.
> 
> I can be totally wrong, but if offline scrub rebased to latest
> btrfs-progs (v4.13.3), it may have some small improvement.
> 
>>
>> 2. Each method reports different statistics in different formats. And
>> that's fine except I can't make heads or tails out of the information
>> presented, making it basically useless at least to this user.
> 
> Offline scrub in fact can reuse the whole kernel scrub ioctl structure.
> So it can completely report the same content as kernel.
> 
> However the problem is, for offline scrub, my primary goal is to report
> error as detail as possible, to verify kernel scrub.

(Not an expert on scrub but just thinking out loud). Having a separate
from kernel scrub for validation purposes sounds good. However, does it
make sense to have a switch to alternate between the output format. I.e.
if you want to do validation of kernel scrub aka testing then use the
switch to get your very detailed output and see if it makes sense. OTOH
if you wan to use scrub instead of the kernel for whatever reason
(perhaps this could be the default) then just output the same format as
kernel?


> 
> So it has different output, but it can be improved.
> 
>>
>> [chris@f26s ~]$ sudo /srv/scratch/gitsworking/btrfs-progs/btrfs check
>> --check-data-csum /dev/mapper/sdd
>> Checking filesystem on /dev/mapper/sdd
>> UUID: f5adc913-bbea-4340-8b5f-3411e2cda642
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 601877024768 bytes used, no error found
>> total csum bytes: 586444884
>> total tree bytes: 1208827904
>> total fs tree bytes: 510672896
>> total extent tree bytes: 53755904
>> btree space waste bytes: 142065358
>> file data blocks allocated: 2213492944896
>>  referenced 1977848909824
>>
>>
>> [chris@f26s ~]$ sudo btrfs-progs/btrfs scrub start --offline
>> /dev/mapper/sdd
>> [sudo] password for chris:
>> Scrub result:
>> Tree bytes scrubbed: 2417655808
>> Tree extents scrubbed: 295124
>> Data bytes scrubbed: 2398080548864
>> Data extents scrubbed: 751158
>> Data bytes without csum: 297271296
>> Read error: 0
>> Verify error: 0
>> Csum error: 0
>>
>> I'm not finding any way these add up. Seems like --offline's tree
>> bytes scrubbed + data bytes scrubbed should add up to
>> --check-data-csum's found bytes - waste bytes? But no, I have no idea
>> what I'm looking at or how it's useful to the user, but OK.
> 
> Offline scrub counts all copies for both data and metadata.
> So it will be more than btrfs check output.
> 
> But to be honest, I didn't review btrfs check numbers, so it may have
> something wrong.
> 
> Thanks for the feedback,
> Qu
> 
>>
>>
>> I used kernel 4.13.10 and btrfs-progs 4.13.3 for the usual 'btrfs
>> scrub start' and the less common 'btrfs check ----check-data-csum'
>> methods; and Qu's v4.11.1-89-gf939adf2 with offline_scrub checked out.
>>
>>
>>
>>
> 
