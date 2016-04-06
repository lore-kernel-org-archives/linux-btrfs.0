Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36155 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbcDFDr6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 23:47:58 -0400
Received: by mail-wm0-f53.google.com with SMTP id v188so8549520wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 20:47:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160404165517.GD3412@twin.jikos.cz>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20160322133812.GK8095@twin.jikos.cz>
	<56F1FEAF.2070806@cn.fujitsu.com>
	<20160324134217.GP29764@twin.jikos.cz>
	<56F496AA.9000102@cn.fujitsu.com>
	<20160404165517.GD3412@twin.jikos.cz>
Date: Tue, 5 Apr 2016 23:47:56 -0400
Message-ID: <CAD=QJKjvKVZTdqVVZJGtve+9teRXgGpv4chY_NV7P5BuFwB1Gw@mail.gmail.com>
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 April 2016 at 12:55, David Sterba <dsterba@suse.cz> wrote:
>> >> Not exactly. If we are using unsafe hash, e.g MD5, we will use MD5 only
>> >> for both in-memory and on-disk backend. No SHA256 again.
>> >
>> > I'm proposing unsafe but fast, which MD5 is not. Look for xxhash or
>> > murmur. As they're both order-of-magnitutes faster than sha1/md5, we can
>> > actually hash both to reduce the collisions.
>>
>> Don't quite like the idea to use 2 hash other than 1.
>> Yes, some program like rsync uses this method, but this also involves a
>> lot of details, like the order to restore them on disk.
>
> I'm considering fast-but-unsafe hashes for the in-memory backend, where
> the speed matters and we cannot hide the slow sha256 calculations behind
> the IO (ie. no point to save microseconds if the IO is going to take
> milliseconds).
>
>> >> In that case, for MD5 hit case, we will do a full byte-to-byte
>> >> comparison. It may be slow or fast, depending on the cache.
>> >
>> > If the probability of hash collision is low, so the number of needed
>> > byte-to-byte comparisions is also low.

It is unlikely that I will use dedupe, but I imagine your work will
apply tot he following wishlist:

1. Allow disabling of memory-backend hash via a kernel argument,
sysctl, or mount option for those of us have ECC RAM.
    * page_cache never gets pushed to swap, so this should be safe, no?
2. Implementing an intelligent cache so that it's possible to offset
the cost of hashing the most actively read data.  I'm guessing there's
already some sort of weighed cache eviction algorithm in place, but I
don't yet know how to look into it, let alone enough to leverage it...
    * on the topic of leaning on the cache, I've been thinking about
ways to optimize reads, while minimizing seeks on multi-spindle raid1
btrfs volumes.  I'm guessing that someone will commit a solution
before I manage to teach myself enough about filesystems to contribute
something useful.

That's it, in terms of features I want ;-)

It's probably a well-known fact, but sha512 is roughly 40 to 50%
faster than sha256, and 40 to 50% slower than sha1 on my 1200-series
Xeon v3 (Haswell), for 8192 size blocks.

Wish I could do more right now!
Nicholas
