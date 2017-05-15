Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34584 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758323AbdEOMD6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 08:03:58 -0400
Received: by mail-io0-f169.google.com with SMTP id k91so71637164ioi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 May 2017 05:03:58 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 123sm5107323iow.28.2017.05.15.05.03.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 May 2017 05:03:51 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
 <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
 <20170512203644.26e068e5@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
Date: Mon, 15 May 2017 08:03:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170512203644.26e068e5@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-12 14:36, Kai Krakow wrote:
> Am Fri, 12 May 2017 15:02:20 +0200
> schrieb Imran Geriskovan <imran.geriskovan@gmail.com>:
>
>> On 5/12/17, Duncan <1i5t5.duncan@cox.net> wrote:
>>> FWIW, I'm in the market for SSDs ATM, and remembered this from a
>>> couple weeks ago so went back to find it.  Thanks. =:^)
>>>
>>> (I'm currently still on quarter-TB generation ssds, plus spinning
>>> rust for the larger media partition and backups, and want to be rid
>>> of the spinning rust, so am looking at half-TB to TB, which seems
>>> to be the pricing sweet spot these days anyway.)
>>
>> Since you are taking ssds to mainstream based on your experience,
>> I guess your perception of data retension/reliability is better than
>> that of spinning rust. Right? Can you eloborate?
>>
>> Or an other criteria might be physical constraints of spinning rust
>> on notebooks which dictates that you should handle the device
>> with care when running.
>>
>> What was your primary motivation other than performance?
>
> Personally, I don't really trust SSDs so much. They are much more
> robust when it comes to physical damage because there are no physical
> parts. That's absolutely not my concern. Regarding this, I trust SSDs
> better than HDDs.
>
> My concern is with fail scenarios of some SSDs which die unexpected and
> horribly. I found some reports of older Samsung SSDs which failed
> suddenly and unexpected, and in a way that the drive completely died:
> No more data access, everything gone. HDDs start with bad sectors and
> there's a good chance I can recover most of the data except a few
> sectors.
Older is the key here.  Some early SSD's did indeed behave like that, 
but most modern ones do generally show signs that they will fail in the 
near future.  There's also the fact that traditional hard drives _do_ 
fail like that sometimes, even without rough treatment.
>
> When SSD blocks die, they are probably huge compared to a sector (256kB
> to 4MB usually because that's erase block sizes). If this happens, the
> firmware may decide to either allow read-only access or completely deny
> access. There's another situation where dying storage chips may
> completely mess up the firmware and there's no longer any access to
> data.
I've yet to see an SSD that blocks user access to an erase block. 
Almost every one I've seen will instead rewrite the block (possibly with 
the corrupted data intact (that is, without mangling it further)) to one 
of the reserve blocks, and then just update it's internal mapping so 
that the old block doesn't get used, and the new one is pointing to the 
right place.  Some of the really good SSD's even use erasure coding in 
the FTL for data verification instead of CRC's, so they can actually 
reconstruct the missing bits when they do this.

Traditional hard drives usually do this too these days (they've been 
under-provisioned since before SSD's existed), which is part of why 
older disks tend to be noisier and slower (the reserved space is usually 
at the far inside or outside of the platter, so using sectors from there 
to replace stuff leads to long seeks).
>
> That's why I don't trust any of my data to them. But I still want the
> benefit of their speed. So I use SSDs mostly as frontend caches to
> HDDs. This gives me big storage with fast access. Indeed, I'm using
> bcache successfully for this. A warm cache is almost as fast as native
> SSD (at least it feels almost that fast, it will be slower if you threw
> benchmarks at it).
That's to be expected though, most benchmarks don't replicate actual 
usage patterns for client systems, and using SSD's for caching with 
bcache or dm-cache for most server workloads except a file server will 
usually get you a performance hit.

It's worth noting also that on average, COW filesystems like BTRFS (or 
log-structured-filesystems will not benefit as much as traditional 
filesystems from SSD caching unless the caching is built into the 
filesystem itself, since they don't do in-place rewrites (so any new 
write by definition has to drop other data from the cache).
