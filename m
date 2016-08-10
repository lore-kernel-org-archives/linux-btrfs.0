Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34892 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbcHJWBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 18:01:46 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so12213172wmg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 15:01:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
From: Dave T <davestechshop@gmail.com>
Date: Wed, 10 Aug 2016 18:01:44 -0400
Message-ID: <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        ahferroin7@gmail.com
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for all the responses, guys! I really appreciate it. This
information is very helpful. I will be working through the suggestions
(e.g., check without repair) for the next hour or so. I'll report back
when I have something to report.

My drive is a Samsung 950 Pro nvme drive, which in most respects is
treated like an SSD. (the only difference I am aware of is that trim
isn't needed).

> But until recently dup mode data on single device was impossible, so I
> doubt you were using that, and while dup mode metadata was the normal
> default, on ssd that changes to single mode as well.

Your assumptions are correct: single mode for data and metadata.

Does anyone have any thoughts about using dup mode for metadata on a
Samsung 950 Pro (or any NVMe drive)?

I will be very disappointed if I cannot use btrfs + dm-crypt. As far
as I can see, there is no alternative given that I need to use
snapshots (and LVM, as good as it is, has severe performance penalties
for its snapshots). I'm required to use crypto. I cannot risk doing
without snapshots. Therefore, btrfs + dm-crypt seem like my only
viable solution. Plus it is my preferred solution. I like both tools.

If all goes well, we are planning to implement a production file
server for our office with dm-crypt + btrfs (and a lot fo spinning
disks).

In the office we currently have another system identical to mine
running the same drive with dm-crypt + btrfs, the same operating
system, the same nvidia GPU and properitary driver and it is running
fine. One difference is that it is overclocked substantially (mine
isn't). I would have expected it would give a problem before mine
would. But it seems to be rock solid. I just ran btrfs scrub on it and
it finished in a few seconds with no errors.

On my computer I have run two extensive memory tests (8 cpu cores in
parallel, all tests). The current test has been running for 14 hrs
with no errors. (I think that 8 cores in parallel make this equivalent
to a much longer test with the default single cpu settings.)
Therefore, I do not beieve this issue is caused by RAM.

I'm hoping there is no configuration error or other mistake I made in
setting these systems up that would lead to the problems I'm
experiencing.

BTW, I was able to copy all the files to another drive with no
problem. I used "cp -a" to copy, then I ran "rsync -a" twiice to make
sure nothing was missed. My guess is that I'll be able to copy this
right back onto the root filesystem after I resolve whatever the
problem is and my operating system will be back to the same state it
was in prior to this problem.

OK, I'm off to try btrfs check without --repair... thanks again!

For reference:

btrfs-progs v4.6.1
Linux 4.6.4-1-ARCH #1 SMP PREEMPT Mon Jul 11 19:12:32 CEST 2016 x86_64 GNU/Linux



On Wed, Aug 10, 2016 at 5:21 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I'm using LUKS, aes xts-plain64, on six devices. One is using mixed-bg
> single device. One is dsingle mdup. And then 2x2 mraid1 draid1. I've
> had zero problems. The two computers these run on do have aesni
> support. Aging wise, they're all at least a  year old. But I've been
> using Btrfs on LUKS for much longer than that.
>
>
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
