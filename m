Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40008 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIEQuB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Sep 2014 12:50:01 -0400
Received: by mail-pa0-f51.google.com with SMTP id rd3so22764792pab.10
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 09:50:01 -0700 (PDT)
Message-ID: <5409E9BE.2040002@kernel.dk>
Date: Fri, 05 Sep 2014 10:50:06 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
CC: NeilBrown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>,
        Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: ext4 vs btrfs performance on SSD array
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>	<20140902000822.GA20473@dastard>	<20140902012222.GA21405@infradead.org>	<20140903100158.34916d34@notabene.brown>	<20140905160808.GA7967@infradead.org> <x497g1ivx4e.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497g1ivx4e.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2014 10:40 AM, Jeff Moyer wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
>> On Wed, Sep 03, 2014 at 10:01:58AM +1000, NeilBrown wrote:
>>> Do we still need maximums at all?
>>
>> I don't think we do.  At least on any system I work with I have to
>> increase them to get good performance without any adverse effect on
>> throttling.
>>
>>> So can we just remove the limit on max_sectors and the RAID5 stripe cache
>>> size?  I'm certainly keen to remove the later and just use a mempool if the
>>> limit isn't needed.
>>> I have seen reports that a very large raid5 stripe cache size can cause
>>> a reduction in performance.  I don't know why but I suspect it is a bug that
>>> should be found and fixed.
>>>
>>> Do we need max_sectors ??
> 
> I'm assuming we're talking about max_sectors_kb in
> /sys/block/sdX/queue/.
> 
>> I'll send a patch to remove it and watch for the fireworks..
> 
> :) I've seen SSDs that actually degrade in performance if I/O sizes
> exceed their internal page size (using artificial benchmarks; I never
> confirmed that with actual workloads).  Bumping the default might not be
> bad, but getting rid of the tunable would be a step backwards, in my
> opinion.
> 
> Are you going to bump up BIO_MAX_PAGES while you're at it?

The reason it's 256 right (or since forever, actually) is that this is
one single 4kb page. If you go higher, that would require a higher order
allocation. Not impossible, but it's definitely a potential issue. It's
a lot saner to string bios at that point, with separate 0 order allocs.

-- 
Jens Axboe

