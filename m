Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35506 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEPLoE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 07:44:04 -0400
Received: by mail-it0-f41.google.com with SMTP id c15so60175050ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 04:44:04 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q193sm6462185ioe.47.2017.05.16.04.44.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2017 04:44:02 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
 <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
 <20170512203644.26e068e5@jupiter.sol.kaishome.de>
 <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
 <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2e2b167a-ab39-9f24-9170-3caa9afcde0f@gmail.com>
Date: Tue, 16 May 2017 07:43:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-15 15:49, Kai Krakow wrote:
> Am Mon, 15 May 2017 08:03:48 -0400
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>>> That's why I don't trust any of my data to them. But I still want
>>> the benefit of their speed. So I use SSDs mostly as frontend caches
>>> to HDDs. This gives me big storage with fast access. Indeed, I'm
>>> using bcache successfully for this. A warm cache is almost as fast
>>> as native SSD (at least it feels almost that fast, it will be
>>> slower if you threw benchmarks at it).
>> That's to be expected though, most benchmarks don't replicate actual
>> usage patterns for client systems, and using SSD's for caching with
>> bcache or dm-cache for most server workloads except a file server
>> will usually get you a performance hit.
>
> You mean "performance boost"? Almost every read-most server workload
> should benefit... I file server may be the exact opposite...
In my experience, short of some types of file server and non-interactive 
websites, read-mostly server workloads are rare.
>
> Also, I think dm-cache and bcache work very differently and are not
> directly comparable. Their benefit depends much on the applied workload.
The low-level framework is different, and much of the internals are 
different, but based on most of the testing I've done, running them in 
the same mode (write-back/write-through/etc) will on average get you 
roughly the same performance.
>
> If I remember right, dm-cache is more about keeping "hot data" in the
> flash storage while bcache is more about reducing seeking. So dm-cache
> optimizes for bigger throughput of SSDs while bcache optimizes for
> almost-zero seek overhead of SSDs. Depending on your underlying
> storage, one or the other may even give zero benefit or worsen
> performance. Which is what I'd call a "performance hit"... I didn't
> ever try dm-cache, tho. For reasons I don't remember exactly, I didn't
> like something about how it's implemented, I think it was related to
> crash recovery. I don't know if that still holds true with modern
> kernels. It may have changed but I never looked back to revise that
> decision.
dm-cache is a bit easier to convert to or from in-place and is in my 
experience a bit more flexible in data handling, but has the issue that 
you can still see the FS on the back-end storage (because it has no 
superblock or anything like that on the back-end storage), which means 
it's almost useless with BTRFS, and it requires a separate cache device 
for each back-end device (as well as an independent metadata device, but 
that's usually tiny since it's largely just used as a bitmap to track 
what blocks are clean in-cache).

bcache is more complicated to set up initially, and _requires_ a kernel 
with bcache support to access even if you aren't doing any caching, but 
it masks the back-end (so it's safe to use with BTRFS (recent versions 
of it are at least)), and it doesn't require a 1:1 mapping of cache 
devices to back-end storage.
>
>
>> It's worth noting also that on average, COW filesystems like BTRFS
>> (or log-structured-filesystems will not benefit as much as
>> traditional filesystems from SSD caching unless the caching is built
>> into the filesystem itself, since they don't do in-place rewrites (so
>> any new write by definition has to drop other data from the cache).
>
> Yes, I considered that, too. And when I tried, there was almost no
> perceivable performance difference between bcache-writearound and
> bcache-writeback. But the latency of performance improvement was much
> longer in writearound mode, so I sticked to writeback mode. Also,
> writing random data is faster because bcache will defer it to
> background and do writeback in sector order. Sequential access is
> passed around bcache anyway, harddisks are already good at that.
>
> But of course, the COW nature of btrfs will lower the hit rate I can
> on writes. That's why I see no benefit in using bcache-writethrough
> with btrfs.
Yeah, on average based on my own testing, write-through mode is 
worthless for COW filesystems, and write-back is only worthwhile if you 
have a large enough cache proportionate to your bandwidth requirements 
(4G should be more than enough for a desktop or workstation, but servers 
may need huge amounts of space), while write-around is only worthwhile 
for stuff that needs read performance but doesn't really care about latency.

