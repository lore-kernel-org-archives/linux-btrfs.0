Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38785 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753280AbaBPTys convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 14:54:48 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53010EF9.60805@friedels.name>
Date: Sun, 16 Feb 2014 12:54:44 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com>
References: <52C7127F.3060902@friedels.name> <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com> <52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba> <52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name> <A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com> <52F73E2B.9080103@friedels.name> <837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com> <82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com> <53010EF9.60805@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 16, 2014, at 12:18 PM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Hi Chris,
> 
> thanks for your hint.
> >> No. You said you need to recreate the file system, and only have these two devices and therefore must remove one device. You can't achieve that with raid1 which requires minimum two devices.
>>> 
>>> -dconvert=single -mconvert=dup -sconvert=dup
>> 
>> Actually, I'm reminded with multiple devices that dup might not be possible. Instead you might have to using single for all of them. Then remove the device you want removed. And then do another conversion for just -mconvert=dup -sconvert=dup, and do not specify -dconvert. That way the single metadata profile is converted to duplicate.
> 
> I think it didn't work.
> 
> btrfs balance start  -dconvert=single -mconvert=single -sconvert=single --force /mnt/BTRFS/Video/
> After >10h:
> btrfs balance status /mnt/BTRFS/Video/
> No balance found on '/mnt/BTRFS/Video/'
> root@homeserver:~# btrfs fi df /mnt/BTRFS/Video/
> Data, RAID0: total=4.00GB, used=4.00GB
> Data: total=2.29TB, used=2.29TB
> System: total=32.00MB, used=256.00KB
> Metadata: total=4.00GB, used=2.57GB

It looks like everything is single except for 4GB of data which is still raid0. Weird. There should be a bunch of messages in dmesg during a normal/successful balance, and either something mentioned or missing might provide a clue why some chunks weren't converted. Unmounted, what do you get for btrfs check?

> 
> Do you have an idea what could be wrong?

No. I'd say it's a bug. 3.14rc3 should be out today, and might be worth a shot. Or btrfs-next. If you try again, you only need to convert the data profile.

Also, 10 hours to balance two disks at 2.3TB seems like a long time. I'm not sure if that's expected.

Chris Murphy

