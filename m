Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36201 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754669AbdCBR0x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 12:26:53 -0500
Received: by mail-lf0-f54.google.com with SMTP id y193so36853230lfd.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Mar 2017 09:26:52 -0800 (PST)
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <7247209c-cd17-d8c6-5f51-a77ff2d9242e@gmail.com>
Date: Thu, 2 Mar 2017 20:26:49 +0300
MIME-Version: 1.0
In-Reply-To: <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

02.03.2017 16:41, Duncan пишет:
> Chris Murphy posted on Wed, 01 Mar 2017 17:30:37 -0700 as excerpted:
> 
>> [1717713.408675] BTRFS warning (device dm-8): missing devices (1)
>> exceeds the limit (0), writeable mount is not allowed
>> [1717713.446453] BTRFS error (device dm-8): open_ctree failed
>>
>> [chris@f25s ~]$ uname
>> -r 4.9.8-200.fc25.x86_64
>>
>> I thought this was fixed. I'm still getting a one time degraded rw
>> mount, after that it's no longer allowed, which really doesn't make any
>> sense because those single chunks are on the drive I'm trying to mount.
>> I don't understand what problem this proscription is trying to avoid. If
>> it's OK to mount rw,degraded once, then it's OK to allow it twice. If
>> it's not OK twice, it's not OK once.
> 
> AFAIK, no, it hasn't been fixed, at least not in mainline, because the 
> patches to fix it got stuck in some long-running project patch queue 
> (IIRC, the one for on-degraded auto-device-replace), with no timeline 
> known to me on mainline merge.
> 
> Meanwhile, the problem as I understand it is that at the first raid1 
> degraded writable mount, no single-mode chunks exist, but without the 
> second device, they are created. 

Is not it the root cause? I would expect it to create degraded mirrored
chunks that will be synchronized when second device is added back.

 (It's not clear to me whether they are
> created with the first write, that is, ignoring any space in existing 
> degraded raid1 chunks, or if that's used up first and the single-mode 
> chunks only created later, when a new chunk must be allocated to continue 
> writing as the old ones are full.)
> 
> So the first degraded-writable mount is allowed, because no single-mode 
> chunks yet exist, while after such single-mode chunks are created, the 
> existing dumb algorithm won't allow further writable mounts, because it 
> sees single-mode chunks on a multi-device filesystem, and never mind that 
> all the single mode chunks are there, it simply doesn't check that and 
> won't allow writable mount because some /might/ be on the missing device.
> 
> The patches stuck in queue would make btrfs more intelligent about that, 
> having it check each chunk as listed in the chunk tree, and if at least 
> one copy is available (as would be the case for single-mode chunks 
> created after the degraded mount), writable mount would still be 
> allowed.  But... that's stuck in a long running project queue with no 
> known timetable for merging... <grumble, grumble>... so the only way to 
> get it is to go find and merge them yourself, in your own build.
> 

Will it replicate single mode chunks when second device is added?
