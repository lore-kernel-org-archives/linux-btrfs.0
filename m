Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:35666 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbHLTap (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 15:30:45 -0400
Received: by vkfi73 with SMTP id i73so9988266vkf.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 12:30:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CB942B.7050301@gmail.com>
References: <55C2840E.4030909@gmail.com>
	<55C340B5.20005@gmail.com>
	<55CB942B.7050301@gmail.com>
Date: Wed, 12 Aug 2015 13:30:44 -0600
Message-ID: <CAJCQCtSaO7jXeJKe+jkMWcRkG6zmUrc+T=jiSD-54ewfAZXV1A@mail.gmail.com>
Subject: Re: bedup --defrag freezing
From: Chris Murphy <lists@colorremedies.com>
To: Konstantin Svist <fry.kun@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 12, 2015 at 12:44 PM, Konstantin Svist <fry.kun@gmail.com> wrote:
> On 08/06/2015 04:10 AM, Austin S Hemmelgarn wrote:
>> On 2015-08-05 17:45, Konstantin Svist wrote:
>>> Hi,
>>>
>>> I've been running btrfs on Fedora for a while now, with bedup --defrag
>>> running in a night-time cronjob.
>>> Last few runs seem to have gotten stuck, without possibility of even
>>> killing the process (kill -9 doesn't work) -- all I could do is hard
>>> power cycle.
>>>
>>> Did something change recently? Is bedup simply too out of date? What
>>> should I use to de-duplicate across snapshots instead? Etc.?
>>>
>> AFAIK, bedup hasn't been actively developed for quite a while (I'm
>> actually kind of surprised it runs with the newest btrfs-progs).
>> Personally, I'd suggest using duperemove
>> (https://github.com/markfasheh/duperemove)
>
> Thanks, good to know.
> Tried duperemove -- it looks like it builds a database of its own
> checksums every time it runs... why won't it use BTRFS internal
> checksums for fast rejection? Would run a LOT faster...

I think the reason is duperremove does extent based deduplication.
Where Btrfs checksums are 4KiB block based, not extent based. And so
many 4KiB CRC32C checksums would need to be in memory, that could be
kinda expensive. And also, I don't know if CRC32C checksums have
essentially no practical chance of collision. If it's really rare,
rather than "so improbable as to be impossible" then you could end up
with "really rare" corruption where incorrect deduplication happens.

There was a patch late last  year I think to re-introduce sha256 hash
as the checksum, but as far as I know it's not in btrfs-progs yet. I
forget if that's file, extent or block based.

-- 
Chris Murphy
