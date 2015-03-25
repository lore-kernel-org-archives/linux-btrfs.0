Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:40615 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbCYEUZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 00:20:25 -0400
In-Reply-To: <20150322173849.GG31762@carfax.org.uk>
References: <CAAkAgPhF5GF5tq0Pck-dju-m7qf62LV8FobUHS2z6ibMwwUn2g@mail.gmail.com> <20150322173849.GG31762@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: btrfs fstrim status (RAID5)
From: Russell Coker <russell@coker.com.au>
Date: Wed, 25 Mar 2015 15:20:13 +1100
To: Hugo Mills <hugo@carfax.org.uk>, scruffters <scruffters@gmail.com>
CC: linux-btrfs@vger.kernel.org
Message-ID: <B16BDB3D-9548-4B95-9F9D-E32885AD327E@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Debian/Wheezy userspace can't be expected to work as well as desired with a 3.19 kernel.

Wheezy with BTRFS single or RAID1-1 works reasonably well as long as you have lots of free space, balance it regularly, and configure it not to resume a balance on reboot.

Debian/Jessie works well with BTRFS single or RAID-1 without any issues. But don't use RAID 5/6. Jessie userspace should work well with 3.19 and 4.0 kernels.

On March 23, 2015 4:38:49 AM GMT+11:00, Hugo Mills <hugo@carfax.org.uk> wrote:
>On Sun, Mar 22, 2015 at 05:30:59PM +0000, scruffters wrote:
>> Hello list,
>> 
>> I wondered if anybody could advise on the status of using fstrim with
>> BTRFS. The motivation for me is to finally try using SSD's in a R5
>> style configuration with some way of running maintenance overnight to
>> maintain performance...
>[snip]
>> My kernel is 3.2.0-4 (Debian Wheezy).
>
>   Then you shouldn't use btrfs RAID-5 at all, and probably shouldn't
>be using btrfs.
>
>   For parity RAID, 3.19 or later is what you should be using, as it
>supports recovery and rebuild. You can get those kernels from the
>Debian experimental repo. If you're not using parity RAID, then the
>last few kernels have been OK, but keeping up with the latest version
>is still a reasonably good idea.
>
>   Hugo.

-- 
Sent from my Samsung Galaxy Note 3 with K-9 Mail.
