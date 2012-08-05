Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33922 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2HEK4O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2012 06:56:14 -0400
To: linux-btrfs@vger.kernel.org, Florian Lindner <mailinglists@xgm.de>
Subject: Re: filesystem show still has stale filesystem
From: Martin Steigerwald <Martin@lichtvoll.de>
Date: Sun, 5 Aug 2012 12:56:13 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208051256.13695.Martin@lichtvoll.de>
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
