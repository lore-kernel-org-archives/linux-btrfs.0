Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34730 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaH0Lp0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 07:45:26 -0400
Received: from merkaba.localnet (ppp-62-216-214-107.dynamic.mnet-online.de [62.216.214.107])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 08805AC
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 13:45:25 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: 3.17: Yay! New sizes in df -h
Date: Wed, 27 Aug 2014 13:45:24 +0200
Message-ID: <1940832.0FjNKhTY79@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Now I get this with 3.17-rc2:

merkaba:~> LANG=C df -hT / /home
Filesystem     Type   Size  Used Avail Use% Mounted on
/dev/dm-5      btrfs   30G   17G   23G  43% /
/dev/dm-0      btrfs  160G  129G   59G  69% /home


/: 17+23 = 40 GiB, compressed 10 GiB away with lzo?
/home: 59+129 = 188 GiB, compressed 28 GiB away with lzo?


This is BTRFS RAID 1 on Dual SSD:

merkaba:~> btrfs fi df /
Data, RAID1: total=25.00GiB, used=15.33GiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=677.33MiB
unknown, single: total=240.00MiB, used=0.00

merkaba:~> btrfs fi df /home
Data, RAID1: total=154.97GiB, used=125.70GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=5.00GiB, used=2.71GiB
unknown, single: total=512.00MiB, used=0.00

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
