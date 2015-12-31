Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36326 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbbLaVWT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 16:22:19 -0500
Received: by mail-ig0-f173.google.com with SMTP id ph11so202171745igc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 13:22:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$b2d51$f981c36c$54145fc4$c0b07bc0@cox.net>
References: <47770e1d8a804d31994eebaf733adf55@nex-exchng-01-v.bcn.nexica.com>
	<20151231115153.GW1586@carfax.org.uk>
	<pan$b2d51$f981c36c$54145fc4$c0b07bc0@cox.net>
Date: Thu, 31 Dec 2015 14:22:19 -0700
Message-ID: <CAJCQCtRUvWJUqr4pypChv5c3WbwxvbgNWXxVYituM+dMfSry+w@mail.gmail.com>
Subject: Re: RAID10 question
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 6:31 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> Additionally, if you're going to put btrfs on mdraid, then you may wish
> to consider reversing the above, doing raid01, which while ordinarily
> discouraged in favor of raid10, has some things going for it when the top
> level is btrfs, that raid10 doesn't.

Yes, although it's a fine line how to create such a large volume of so
many drives. If you use many drives per raid0, when there is a failure
it takes a long time to rebuild. If you use few drives per raid0, fast
rebuild, but the exposure/risk with a 2nd failure is higher. e.g. two
extremes:

12x raid0 "bank A"     and 12x raid0 "bank B"

If one drive dies, an entire bank is gone, and it's a long rebuild,
but if a 2nd drive dies, nearly 50/50 chance it dies in the same
already dead bank.

2x raid0 "bank A"  and 2x raid0 "bank C" and .... through "bank L"

If one drive dies in bank A, then A is gone, short rebuild time, but
if a 2nd drive dies, almost certainly it will not be the 2nd bank A
drive, meaning it's in another bank and that means the whole array is
mortally wounded. Depending on what's missing and what needs to be
accessed, it might work OK for seconds, minutes, or hours, and then
totally implode. There's no way to predict it in advance.

Anyway, I'd sooner go with 3x raid5, or 6x raid6, and then pool them
with glusterfs. Even with a single node using replication only for the
separate raid5 bricks is more reliable than a 24x raid10 no matter
md+xfs or btrfs. That makes it effectively a raid 51. And if half the
storage is put on another node, now you have power supply and some
network redundancy too.

-- 
Chris Murphy
