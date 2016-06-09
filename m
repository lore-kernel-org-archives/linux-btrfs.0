Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36830 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbcFILit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 07:38:49 -0400
Received: by mail-io0-f175.google.com with SMTP id n127so35103335iof.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 04:38:49 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id s205sm13326664itd.16.2016.06.09.04.38.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 09 Jun 2016 04:38:47 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: linux-btrfs@vger.kernel.org
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
 <CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
 <dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
 <pan$f0f75$1ba12fd1$de89e173$5dda67a@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <aa93e9e0-eade-085c-c955-2f7e433d92f8@gmail.com>
Date: Thu, 9 Jun 2016 07:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <pan$f0f75$1ba12fd1$de89e173$5dda67a@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-09 02:16, Duncan wrote:
> Austin S. Hemmelgarn posted on Fri, 03 Jun 2016 10:21:12 -0400 as
> excerpted:
>
>> As far as BTRFS raid10 mode in general, there are a few things that are
>> important to remember about it:
>> 1. It stores exactly two copies of everything, any extra disks just add
>> to the stripe length on each copy.
>
> I'll add one more, potentially very important, related to this one:
>
> Btrfs raid mode (any of them) works in relation to individual chunks,
> *NOT* individual devices.
>
> What that means for btrfs raid10 in combination with the above exactly
> two copies rule, is that it works rather differently than a standard
> raid10, which can tolerate loss of two devices as long as they're from
> the same mirror set, as the other mirror set will then still be whole.
> Because with btrfs raid10 the mirror sets are dynamic per-chunk, loss of
> a second device close to assures loss of data, because the very likely
> true assumption is that both mirror sets will be affected for some
> chunks, but not others.
Actually, that's not _quite_ the case.  Assuming that you have an even 
number of devices, BTRFS raid10 will currently always span all the 
available devices with two striped copies of the data (if there's an odd 
number, it spans one less than the total, and rotates which one gets 
left out of each chunk).  This means that as long as all the devices are 
the same size and you have have stripes that are the full width of the 
array (you can end up with shorter ones if you have run in degraded mode 
or expanded the array), your probability of data loss per-chunk goes 
down as you add more devices (because the probability of a two device 
failure affecting both copies of a stripe in a given chunk decreases), 
but goes up as you add more chunks (because you then have to apply that 
probability for each individual chunk).  Once you've lost one disk, the 
probability that losing another will compromise a specific chunk is:
1/(N - 1)
Where N is the total number of devices.
The probability that it will compromise _any_ chunk is:
(1/(N - 1))/C
Where C is the total number of chunks
BTRFS raid1 mode actually has the exact same probabilities, but they 
apply even if you have an odd number of disks.
>
> By using a layered approach, btrfs raid1 on top (for its error correction
> from the other copy feature) of a pair of mdraid0s, you force one of the
> btrfs raid1 copies to each of the mdraid0s, thus making allocation more
> deterministic than btrfs raid10, and can thus again tolerate loss of two
> devices, as long as they're from the same underlying mdraid0.
>
> (Traditionally, raid1 on top of raid0 is called raid01, and is
> discouraged compared to raid10, raid0 on top of raid1, because device
> failure and replacement with the latter triggers a much more localized
> rebuild than the former, across the pair of devices in the raid1 when
> it's closest to the physical devices, across the whole array, one raid0
> to the other, when the raid1 is on top.  However, btrfs raid1's data
> integrity and error repair from the good mirror feature is generally
> considered to be useful enough to be worth the rebuild-inefficiency of
> the raid01 design.)
>
> So in regard to failure tolerance, btrfs raid10 is far closer to
> traditional raid5, loss of a single device is tolerated, loss of a second
> before a repair is complete generally means data loss -- there's not the
> chance of it being on the same mirror set to save you that traditional
> raid10 has.
>
> Similarly, btrfs raid10 doesn't have the cleanly separate pair of mirrors
> on raid0 arrays that traditional raid10 does, thus doesn't have the fault
> tolerance of losing say the connection or power to one entire device
> bank, as long as it's all one mirror set, that traditional raid10 has.
>
> And again, doing the layered thing with btrfs raid1 on top and mdraid0
> (or whatever else) underneath gets that back for you, if you set it up
> that way, of course.
And will get you better performance than just BTRFS most of the time too.

