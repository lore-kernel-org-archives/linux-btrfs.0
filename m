Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41745 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2HEKzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2012 06:55:50 -0400
Received: from merkaba.localnet (ppp-93-104-157-132.dynamic.mnet-online.de [93.104.157.132])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EE19C1D9
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Aug 2012 12:55:48 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: filesystem show still has stale filesystem
Date: Sun, 5 Aug 2012 12:55:48 +0200
References: <CAJtBfr9mX-T8+-nGAvkinaO3yEw20zjRdab=4vjukwZTj0nR7w@mail.gmail.com> (sfid-20120805_125303_144829_D3718806)
In-Reply-To: <CAJtBfr9mX-T8+-nGAvkinaO3yEw20zjRdab=4vjukwZTj0nR7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208051255.48466.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 5. August 2012 schrieb Florian Lindner:
> Hello,

Hi Florian,

> I was playing with btrfs and accidentally formatted the disk directly
> (/dev/sdb instead of sdb1). Since then I rewrote the GPT partition
> table, recreated the partition and ran btrfs device scan. Still, btrfs
> filesystem show prints:
> 
> root@horus /mnt # btrfs fi sh --all-devices
> failed to read /dev/sr0: No medium found
> Label: 'test'  uuid: ffab72f2-eff1-4ac8-a694-d56dd84fda24
>         Total devices 1 FS bytes used 28.00KB
>         devid    1 size 2.73TB used 2.04GB path /dev/sdb
> 
> Label: 'home'  uuid: c465d715-098a-4d0d-bebc-6aa51f4cb349
>         Total devices 1 FS bytes used 28.00KB
>         devid    1 size 2.73TB used 2.04GB path /dev/sdb1

wipefs shows and removes filesystem signatures. No need to dd.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
