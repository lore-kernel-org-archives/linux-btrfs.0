Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40569 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbLNI7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 03:59:11 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: still kworker at 100% cpu in all of device size allocated with chunks situations with write load
Date: Mon, 14 Dec 2015 09:59:09 +0100
Message-ID: <36270119.ZeTm4UPz2S@merkaba>
In-Reply-To: <566E827A.2020604@cn.fujitsu.com>
References: <8336788.myI8ELqtIK@merkaba> <5373860.W0QrVGf34G@merkaba> <566E827A.2020604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu.

I reply to the journal fs things in a mail with a different subject.

Am Montag, 14. Dezember 2015, 16:48:58 CET schrieb Qu Wenruo:
> Martin Steigerwald wrote on 2015/12/14 09:18 +0100:
> > Am Montag, 14. Dezember 2015, 10:08:16 CET schrieb Qu Wenruo:
> >> Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
[…]
> >> GlobalReserve is just a reserved space *INSIDE* metadata for some corner
> >> case. So its profile is always single.
> >> 
> >> The real problem is, how we represent it in btrfs-progs.
> >> 
> >> If it output like below, I think you won't complain about it more:
> >>   > merkaba:~> btrfs fi df /
> >>   > Data, RAID1: total=27.98GiB, used=24.07GiB
> >>   > System, RAID1: total=19.00MiB, used=16.00KiB
> >>   > Metadata, RAID1: total=2.00GiB, used=728.80MiB
> >> 
> >> Or
> >> 
> >>   > merkaba:~> btrfs fi df /
> >>   > Data, RAID1: total=27.98GiB, used=24.07GiB
> >>   > System, RAID1: total=19.00MiB, used=16.00KiB
> >>   > Metadata, RAID1: total=2.00GiB, used=(536.80 + 192.00)MiB
> >>   > 
> >>   >  \ GlobalReserve: total=192.00MiB, used=0.00B
> > 
> > Oh, the global reserve is *inside* the existing metadata chunks? Thats
> > interesting. I didn´t know that.
> 
> And I have already submit btrfs-progs patch to change the default output
> of 'fi df'.
> 
> Hopes to solve the problem.

Nice. Thank you. It clarifies it quite a bit. I always wondered why its 
single. On which device does it allocate it in a RAID 1? Also can the data 
stored in there temporarily be recreated in case of loosing a device? In case 
that not, BTRFS would not guarantee that one device of a RAID 1 can fail at 
all times.

Ciao,
-- 
Martin
