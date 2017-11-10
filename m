Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-3.smtp-out.eu-west-1.amazonses.com ([54.240.4.3]:38630 "EHLO
        a4-3.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751186AbdKJWSs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 17:18:48 -0500
Subject: Re: how to run balance successfully (No space left on device)?
To: Chris Murphy <lists@colorremedies.com>,
        Tomasz Chmielewski <mangoo@wpkg.org>
Cc: E V <eliventer@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
 <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
 <64e4c4c4341f5880349a02cf57eb3ff7@wpkg.org>
 <CAJtFHUQ34uyt-iAQKuQ-WqXMrCqxsPeqFc5LvYmZHrz+Rxs66A@mail.gmail.com>
 <011ae8c4281f0f8799d48189f540a302@wpkg.org>
 <CAJCQCtS3kR0xeKCpMdk9mivJ+8JyToPVoKMmUUX2sp2-L1PpfA@mail.gmail.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015fa8038e3c-374ecd8e-6532-4fe5-b954-8956c0346e61-000000@eu-west-1.amazonses.com>
Date: Fri, 10 Nov 2017 22:18:46 +0000
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS3kR0xeKCpMdk9mivJ+8JyToPVoKMmUUX2sp2-L1PpfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10.11.2017 22:51 Chris Murphy wrote:
>> Combined with evidence that "No space left on device" during balance can
>> lead to various file corruption (we've witnessed it with MySQL), I'd day
>> btrfs balance is a dangerous operation and decision to use it should be
>> considered very thoroughly.
> I've never heard of this. Balance is COW at the chunk level. The old
> chunk is not dereferenced until it's written in the new location
> correctly. Corruption during balance shouldn't be possible so if you
> have a reproducer, the devs need to know about it.

I didn't say anything before, because I could not reproduce the problem.
I had (I guess) a corruption caused by balance as well. It had ENOSPC in
spite of enough free space (4.9.x), which made me balance it regularly
to keep unallocated space around. Corruption occured probably after or
shortly before power reset during a balance -- no skip_balance specified
so it continued directly after mount -- data was moved relatively fast
after the mount operation (copy file then delete old file). I think
space_cache=v2 was active at the time. I'm of course not completely sure
it was btrfs's fault and as usual not all the conditions may be
relevant. Could also be instead an upper layer error (Hyper-V storage),
memory issue or an application error.

Regards,
Martin Raiber

