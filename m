Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37828 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbcAIW3c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jan 2016 17:29:32 -0500
Received: by mail-ig0-f170.google.com with SMTP id h5so53531741igh.0
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 14:29:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$84a33$9b12297$c9fad6dd$fe3dbd43@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
	<pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
	<CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
	<pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
	<CAJCQCtRkDrUhiCsgO5Wm=1OhpbtxaR58SLLg5JxZvYQE_nSTUQ@mail.gmail.com>
	<pan$84a33$9b12297$c9fad6dd$fe3dbd43@cox.net>
Date: Sat, 9 Jan 2016 15:29:31 -0700
Message-ID: <CAJCQCtRw9_YAneGeBW-CjwzuqGgOtKR4sNNd1RveUD3LQBXUVw@mail.gmail.com>
Subject: Re: evidence of persistent state, despite device disconnects
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 9, 2016 at 3:55 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Tue, 05 Jan 2016 14:47:52 -0700 as excerpted:
>
>> On Tue, Jan 5, 2016 at 7:50 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>>
>>> If however you mounted it degraded,rw at some point, then I'd say the
>>> bug is in wetware, as in that case, based on my understanding, it's
>>> working as intended.  I was inclined to believe that was what happened
>>> based on the obviously partial sequence in the earlier post, but if you
>>> say you didn't... then it's all down to duplication and finding why
>>> it's suddenly reverting to single mode on non-degraded mounts, which
>>> indeed /is/ a bug.
>>
>> Clearly I will have to retest.
>>
>> But even as rw,degraded, it doesn't matter, that'd still be a huge bug.
>> There's no possible way you'll convince me this is a user
>> misunderstanding. No where is this documented.
>>
>> I made the fs using mfks.btrfs -draid1 -mraid1. There is no way the fs,
>> under any circumstance, legitimately creates and uses any other profile
>> for any chunk type, ever. Let alone silently.
>
> If you're mounting degraded,rw, and you're down to a single device on a
> raid1, then once the existing chunks fill up, it /has/ to create single
> chunks, because it can't create them raid1 as there's not enough devices
> (a minimum of two devices are required to create raid1 chunks, since two
> copies are required and they can't be on the same device).
>
> And by mounting degraded,rw you've given it permission to create those
> single mode chunks if it has to, so it's not "silent", as you've
> explicitly mounted it degraded,rw, and single is what raid1 degrades to
> when there's only one device.

This is esoteric for mortal users (let alone without documentation)
that degraded,rw means single chunks will be made, and now new data is
no longer replicated once the bad device is replaced and volume
scrubbed.

There's an incongruency between the promise of "fault tolerance,
repair, and easy administration" and the esoteric reality. This is not
easy, this is a gotcha. I'll bet almost no users have any idea this is
how rw,degraded behaves and the risk it entails.



-- 
Chris Murphy
