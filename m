Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38397 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLZOUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Dec 2014 09:20:44 -0500
Received: from merkaba.localnet (ppp-88-217-104-169.dynamic.mnet-online.de [88.217.104.169])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id A294DB9
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Dec 2014 15:19:59 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Fri, 26 Dec 2014 15:20:42 +0100
Message-ID: <3207071.8ytD2jQS28@merkaba>
In-Reply-To: <3738341.y7uRQFcLJH@merkaba>
References: <3738341.y7uRQFcLJH@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 26. Dezember 2014, 14:37:36 schrieben Sie:
> It currently is here:
> 
> merkaba:~> btrfs balance status /home
> Balance on '/home' is running
> 32 out of about 164 chunks balanced (53 considered),  80% left
> 
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=154.97GiB, used=142.10GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=3.33GiB
> GlobalReserve, single: total=512.00MiB, used=254.31MiB

Now I got this:

merkaba:~> btrfs balance start /home           

ERROR: error during balancing '/home' - No space left on device
There may be more info in syslog - try dmesg | tail
merkaba:~#1> dmesg | tail
[ 4260.276416] BTRFS info (device dm-3): relocating block group 151418568704 
flags 17
[ 4274.683349] BTRFS info (device dm-3): found 25089 extents
[ 4295.836590] BTRFS info (device dm-3): found 25089 extents
[ 4296.026778] BTRFS info (device dm-3): relocating block group 150344826880 
flags 17
[ 4312.732021] BTRFS info (device dm-3): found 59388 extents
[ 4326.398261] BTRFS info (device dm-3): found 59388 extents
[ 4326.813205] BTRFS info (device dm-3): relocating block group 149271085056 
flags 17
[ 4347.346540] BTRFS info (device dm-3): found 104739 extents
[ 4357.160098] BTRFS info (device dm-3): found 104739 extents
[ 4359.304646] BTRFS info (device dm-3): 20 enospc errors during balance

And I wonder about:

> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599
> 
84C7N�����r��y����b�X��ǧv�^�)޺{.n�+����{�n�߲)����w*jg��������ݢj/���z�ޖ��2
> �ޙ����&�)ߡ�a�����G���h��j:+v���w��٥


These random chars are not supposed to be there: I better run scrub straight 
after this balance.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
