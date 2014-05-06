Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53643 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaEFWpN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 18:45:13 -0400
Received: by mail-ee0-f51.google.com with SMTP id e51so167710eek.24
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 15:45:11 -0700 (PDT)
Message-ID: <53696607.4090103@googlemail.com>
Date: Wed, 07 May 2014 00:45:27 +0200
From: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs raid allocator
References: <5368BC62.2020701@googlemail.com> <97F9F845-5EF6-4AC8-AD58-AE0E183742FF@colorremedies.com>
In-Reply-To: <97F9F845-5EF6-4AC8-AD58-AE0E183742FF@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06.05.2014 23:49, Chris Murphy wrote:
>
> On May 6, 2014, at 4:41 AM, Hendrik Siedelmann
> <hendrik.siedelmann@googlemail.com> wrote:
>
>> Hello all!
>>
>> I would like to use btrfs (or anyting else actually) to maximize
>> raid0 performance. Basically I have a relatively constant stream of
>> data that simply has to be written out to disk.
>
> I think the only way to know what works best for your workload is to
> test configurations with the actual workload. For optimization of
> multiple device file systems, it's hard to beat XFS on raid0 or even
> linear/concat due to its parallelization, if you have more than one
> stream (or a stream that produces a lot of files that XFS can
> allocate into separate allocation groups). Also mdadm supports use
> specified strip/chunk sizes, whereas currently on Btrfs this is fixed
> to 64KiB. Depending on the file size for your workload, it's possible
> a much larger strip will yield better performance.

Thanks, that's quite a few knobs I can try out - I just have a lot of 
data - with a rate up to 450MB/s that I want to write out in time, 
preferably without having to rely on too expensive hardware.

> Another optimization is hardware RAID with a battery backed write
> cache (the drives' write cache are disabled) and using nobarrier
> mount option. If your workload supports linear/concat then it's fine
> to use md linear for this. What I'm not sure of is if it's an OK
> practice to disable barriers if the system is on a UPS (rather than a
> battery backed hardware RAID cache). You should post the workload and
> hardware details on the XFS list to get suggestions about such
> things. They'll also likely recommend the deadline scheduler over
> cfq.

Actually data integrity does not matter for the workload. If everything 
is succesfull the result will be backed up - before that full filesystem 
corruption is acceptable as a failure mode.

> Unless you have a workload really familiar to the responder, they'll
> tell you any benchmarking you do needs to approximate the actual
> workflow. A mismatched benchmark to the workload will lead you to the
> wrong conclusions. Typically when you optimize for a particular
> workload, other workloads suffer.
>
> Chris Murphy
>

Thanks again for all the infos! I'll get back if everything works fine - 
or if it doesn't ;-)

Cheers
Hendrik
