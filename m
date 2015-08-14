Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35612 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbbHNPLS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 11:11:18 -0400
Received: by vkfi73 with SMTP id i73so31155377vkf.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 08:11:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201508142212.50580.russell@coker.com.au>
References: <201508142212.50580.russell@coker.com.au>
Date: Fri, 14 Aug 2015 09:11:17 -0600
Message-ID: <CAJCQCtSrCC+GVwD39j3qM=5xg1KkhnXOi=xaBKpwM=PbYXWHyg@mail.gmail.com>
Subject: Re: can we make balance delete missing devices?
From: Chris Murphy <lists@colorremedies.com>
To: Russell Coker <russell@coker.com.au>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 6:12 AM, Russell Coker <russell@coker.com.au> wrote:
> [ 2918.502237] BTRFS info (device loop1): disk space caching is enabled
> [ 2918.503213] BTRFS: failed to read chunk tree on loop1
> [ 2918.540082] BTRFS: open_ctree failed
>
> I just had a test RAID-1 filesystem with a missing device.  I mounted it with
> the degraded option and added a new device.  I balanced it (to make it do
> RAID-1 again) and thought everything was good.  Then when I tried to mount it
> again it gave errors such as the above (not sure why).  Then I tried wiping
> /dev/loop1 and it refused to mount entirely due to having 2 missing devices.
>
> Obviously it was my mistake to not remove the missing device, and wiping
> /dev/loop1 was a bad idea.  Failing to remove a missing device seems likely to
> be a common mistake.  Could we make the balance operation automatically delete
> the missing device?  I can't imagine a situation in which a balance would be
> desired but deleting the missing device wouldn't be desired.

I think this is specious because balance doesn't at all convey a
missing device will be silently dropped. If a device is missing and
balancing is a bad idea, then balance should probably fail rather than
automatically delete missing.

The proper way to avoid this is to use btrfs replace start. Maybe it's
just an old habit that needs purging, device add + device delete +
balance, this is the exact use case replace was meant to address.


-- 
Chris Murphy
