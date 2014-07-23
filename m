Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43459 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751549AbaGWNd0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 09:33:26 -0400
Message-ID: <53CFB99F.1050705@fb.com>
Date: Wed, 23 Jul 2014 09:33:19 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Morten Stevens <mstevens@fedoraproject.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs kernel workqueues performance regression
References: <CAKSJeFKteZNUnJmN3dnYaHLnayQhZNNTKX5co_smMqwy1JgQNA@mail.gmail.com> <53C5673F.6010702@fb.com> <20140722233955.GU4453@dastard>
In-Reply-To: <20140722233955.GU4453@dastard>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/22/2014 07:39 PM, Dave Chinner wrote:
> On Tue, Jul 15, 2014 at 01:39:11PM -0400, Chris Mason wrote:
>> On 07/15/2014 11:26 AM, Morten Stevens wrote:
>>> Hi,
>>>
>>> I see that btrfs is using kernel workqueues since linux 3.15. After
>>> some tests I noticed performance regressions with fs_mark.
>>>
>>> mount options: rw,relatime,compress=lzo,space_cache
>>>
>>> fs_mark on Kernel 3.14.9:
>>>
>>> # fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
>>> FSUse%        Count         Size    Files/sec     App Overhead
>>>      1        65536        51200      17731.4           723894
>>>      1       131072        51200      16832.6           685444
>>>      1       196608        51200      19604.5           652294
>>>      1       262144        51200      18663.6           630067
>>>      1       327680        51200      20112.2           692769
>>>
>>> The results are really nice! compress=lzo performs very good.
>>>
>>> fs_mark after upgrading to Kernel 3.15.4:
>>>
>>> # fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
>>> FSUse%        Count         Size    Files/sec     App Overhead
>>>      0        65536        51200      10718.1           749540
>>>      0       131072        51200       8601.2           853050
>>>      0       196608        51200      11623.2           558546
>>>      0       262144        51200      11534.2           536342
>>>      0       327680        51200      11167.4           578562
>>>
>>> That's really a big performance regression :(
>>>
>>> What do you think? It's easy to reproduce with fs_mark.
>>
>> I wasn't able to trigger regressions here when we first merged it, but I
>> was sure that something would pop up.  fs_mark is sensitive to a few
>> different factors outside just the worker threads, so it could easily be
>> another change as well.
>>
>> With 16 threads, the btree locking also has a huge impact, and we've
>> made change there too.
> 
> FWIW, I ran my usual 16-way fsmark test last week on my sparse 500TB
> perf test rig on btrfs. It sucked, big time, much worse than it's
> sucked in the past. It didn't scale past a single thread - 1 thread
> got 24,000 files/s, 2 threads got 25,000 files/s 16 threads got
> 22,000 files/s.

We had a trylock in the btree search code that always took the spinlock
but did a trylock on the blocking lock.  This was changed to a trylock
on the spinlock too because some of the callers were using trylock
differently than in the past.

It's a regression for this kind of run, but makes the btrfs locking much
less mystical.  I'm fixing up the performance regression part for the
next merge window, but I didn't want to mess around too much with it in
3.16 with all the other locking churn.

For this kind of fsmark run the best results still come from one subvol
per thread.

-chris
