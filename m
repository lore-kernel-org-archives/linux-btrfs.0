Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53662 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751692AbdGETfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jul 2017 15:35:50 -0400
From: Nick Terrell <terrelln@fb.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
CC: "dsterba@suse.cz" <dsterba@suse.cz>, E V <eliventer@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Yann Collet <cyan@fb.com>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Date: Wed, 5 Jul 2017 19:35:33 +0000
Message-ID: <B19A0CF8-3CB8-4EA1-AC6A-2383B4BD944A@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
 <20170630142133.GU2866@twin.jikos.cz>
 <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
 <15B9D85B-F8AF-44B3-B644-7E4F13A3764C@fb.com>
 <0cf10bfd-8631-7542-be31-7cc04379b0a9@gmail.com>
 <20170705181854.a4d35h2dgp4t3hlt@angband.pl>
 <eb05605b-e3e5-2312-437e-4ae1fafa8bab@gmail.com>
In-Reply-To: <eb05605b-e3e5-2312-437e-4ae1fafa8bab@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/5/17, 11:45 AM, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>On 2017-07-05 14:18, Adam Borowski wrote:
>> On Wed, Jul 05, 2017 at 07:43:27AM -0400, Austin S. Hemmelgarn
>> wrote:
>>> On 2017-06-30 19:01, Nick Terrell wrote:
>>>>> There is also the fact of deciding what to use for the default
>>>>> when specified without a level.  This is easy for lzo and zlib,
>>>>> where we can just use the existing level, but for zstd we would
>>>>> need to decide how to handle a user just specifying 'zstd'
>>>>> without a level.  I agree with E V that level 3 appears to be
>>>>> the turnover point, and would suggest using that for the
>>>>> default.
>>>> 
>>>> I chose level 1 because I thought if we had to choose one
>>>> speed/compression trade off, faster would be better. However,
>>>> with a configerable compression level, level 3 is a great
>>>> default, and is the default of the zstd CLI.
>>> Actually, even if it's not configurable, I would prefer 3, as that
>>> still performs better in both respects (speed and compression
>>> ratio) than zlib while being sufficiently different from lzo
>>> performance to make it easy to decide on one or the other.  As far
>>> as configurable levels for regular usage on a filesystem, there are
>>> only three levels you benchmarked that I would be interested in,
>>> namely level 1 (highly active data on slow storage with a fast
>>> CPU), 3 (stuff I would use zlib for today), and 15 (stuff I would
>>> use out-of-band compression for today (for example, archival
>>> storage)).
>> 
>> If you guys are going to argue between 1 and 3, just go the cracovian
>> deal and settle at 2. :Ã¾

I'll change the default to level 3 in the next update.

>> 
>> But more seriously: zstd looks so much better than lzo and zlib than
>> I'd suggest making it the default compression in cases where there's
>> no way to choose, such as chattr +c.  But then, changing the default
>> before the previous LTS kernel can mount it would be irresponsible --
>> thus, if you can get it into 4.14, we're looking at 4.19 at soonest
>> (or later if we consider distro kernels).
> To be entirely honest, we probably should have switched to LZO as the
> default a while back to put things more in-line with ZFS (which
> traditionally favors performance for in-line compression) and Windows
> (which uses a custom LZ77 derivative that's wicked fast on most modern
> systems).  I would say that as soon as we get to the point that the last 
> two LTS releases support it, zstd should probably become the default.
>
> Also, slightly OT, but I would love to have the ability to set per 
> volume (not subvolume but volume itself) what to use for compression 
> when no algorithm is specified.
>> 
>> Which means the timing is quite tight: if, per DSterba's request,
>> /lib/ parts are going via a non-btrfs tree, there'll be not enough
>> adequate testing in -next.  Thus, would it be possible to have /lib/
>> patches in btrfs-next but not in for-linus?  That would allow testing
>> so you can catch the LTS train.
>> 
>>>>>> So, I don't see any problem making the level configurable.
>>>>> I would actually love to see this, I regularly make use of
>>>>> varying compression both on BTRFS (with separate filesystems)
>>>>> and on the ZFS-based NAS systems we have at work (where it can
>>>>> be set per-dataset) to allow better compression on less
>>>>> frequently accessed data.
>>>> 
>>>> I would love to see configurable compression level as well. Would
>>>> you want me to add it to my patch set, or should I adapt my patch
>>>> set to work on top of it when it is ready?
>> 
>> Note that as zstd is new, there's no backwards compat to care of,
>> thus you are free to use whatever -o/prop syntax you'd like.  If zstd
>> ends up being configurable while zlib is not -- oh well, there's no
>> reason to use zlib anymore other than for mounting with old kernels,
>> in which case we can't use configurable props anyway.  Unlike zlib,
>> lzo is not strictly worse than configurable zstd, but it has only one
>> level so there's nothing to configure as well.
>> 
>> Thus, I'd suggest skipping the issue and implement levels for zstd
>> only.
> I would mostly agree, with one possible exception.  _If_ zlib at the max
> level gets similar compression ratios to zstd on it's higher levels
> _and_ it also gets better performance on at least one aspect (I think
> zlib at level 9 will probably have better compression performance than
> zstd at level 15, but I'm not sure about the compression ratio), then I
> would argue that it might be worth implementing levels for zlib.
> Actually determining that will of course require proper testing, but
> that's probably better left as a separate discussion.

For every zlib level, there is one or more level if zstd that performes
better in all of compression speed, decompression speed, and compression
level. zstd also has levels that compress better than zlib, but slower
compression speed and faster decompression speed.

These benchmarks are run in userland, but I expect the results to be the
same in BtrFS. See the lzbench compression benchmark
https://github.com/inikep/lzbench. There are corner cases where zlib can
compress better than zstd, but I wouldn't expect to see them often, and
the gains on other files should offset the small loss on the edge cases.

>> As for testing: I assume you guys are doing stress testing on amd64
>> already, right?  I got two crappy arm64 machines but won't be able to
>> test there before 4.13 (Icenowy has been lazy and didn't push any
>> near-mainline patch set recently; every single Pine64/Pinebook kernel
>> pushed by anyone but her didn't work for me so I don't even bother
>> trying anymore).  On the other hand, the armhf box I'm running Debian
>> rebuilds on is a gem among cheap SoCs.  After Nick fixed the
>> flickering workspaces bug, there were no further hiccups; on monday I
>> switched to 4.12.0 + btrfs-for-4.13 + zstd (thus luckily avoiding
>> that nowait aio bug), also no explosions yet.
> Which reminds me, I forgot to mention in my last e-mail, I ran stress
> tests over the holiday weekend with pretty much the same kernel
> combination on QEMU instances for amd64, i686, armv7a, armv6 (EABI only
> on both), arm64, ppc64 (both big and little endian), and 32-bit MIPS
> (new ABI only, also both big and little endian), and saw no issues
> relating to zstd or BTRFS (I did run into some other issues, but they 
> were because I still don't have things quite configured properly for 
> this new testing setup).

Thanks for running the stress tests! 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
