Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32913 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbcD0XTe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 19:19:34 -0400
Received: by mail-oi0-f66.google.com with SMTP id f63so10037802oig.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Apr 2016 16:19:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5720A0E8.5000407@gmail.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
	<pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
	<571E154C.9060604@gmail.com>
	<CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
	<571F4CD0.9050004@gmail.com>
	<CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
	<CAJCQCtQbCbR9V7z4jZCejbKLJyhBbtrZJmcQBkX=VnxReBf46g@mail.gmail.com>
	<5720A0E8.5000407@gmail.com>
Date: Wed, 27 Apr 2016 17:19:33 -0600
Message-ID: <CAJCQCtThbwkDQUNFT_Xuao1=HnktFYHebSTruXAJWZOGExBdxA@mail.gmail.com>
Subject: Re: Add device while rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Juan Alberto Cirez <jacirez@rdcsafety.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 5:22 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-26 20:58, Chris Murphy wrote:
>>
>> On Tue, Apr 26, 2016 at 5:44 AM, Juan Alberto Cirez
>> <jacirez@rdcsafety.com> wrote:
>>>
>>>
>>> With GlusterFS as a distributed volume, the files are already spread
>>> among the servers causing file I/O to be spread fairly evenly among
>>> them as well, thus probably providing the benefit one might expect
>>> with stripe (RAID10).
>>
>>
>> Yes, the raid1 of Btrfs is just so you don't have to rebuild volumes
>> if you lose a drive. But since raid1 is not n-way copies, and only
>> means two copies, you don't really want the file systems getting that
>> big or you increase the chances of a double failure.
>>
>> I've always though it'd be neat in a Btrfs + GlusterFS, if it were
>> possible for Btrfs to inform Gluster FS of "missing/corrupt" files,
>> and then for Btrfs to drop reference for those files, instead of
>> either rebuilding or remaining degraded. And then let GlusterFS deal
>> with replication of those files to maintain redundancy. i.e. the Btrfs
>> volumes would be single profile for data, and raid1 for metadata. When
>> there's n-way raid1, each drive can have a copy of the file system,
>> and it'd tolerate in effect n-1 drive failures and the file system
>> could at least still inform Gluster (or Ceph) of the missing data, the
>> file system still remains valid, only briefly degraded, and can still
>> be expanded when new drives become available.
>
> FWIW, I _think_ this can be done with the scrubbing code in GlusterFS. It's
> designed to repair data mismatches, but I'm not sure how it handles missing
> copies of data.  However, in the current state, there's no way without
> external scripts to handle re-shaping of the storage bricks if part of them
> fails.

Yeah I haven't tried doing a scrub, parsing dmesg for busted file
paths, and feeling those paths into rm to see what happens. Will they
get deleted without additional errors? If so good, then scrub again
should be clean. And then btrfs dev missing to get rid of the broken
device *and* cause missing metadata to be replicated again and now in
theory the fs should be back to normal. But it'd have to be tested
with a umount followed by mount to see if -o degraded is still
required.

-- 
Chris Murphy
