Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58656 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859AbaLLPiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 10:38:11 -0500
Received: by mail-ig0-f173.google.com with SMTP id r2so1643301igi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:38:10 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 12 Dec 2014 09:38:10 -0600
Message-ID: <CAAe=sHV8-8BK9xj2n0mhh_URoAYUNWg-y8QVFv-Efh7StRtYag@mail.gmail.com>
Subject: btrfs fi df output "unknown"
From: "sys.syphus" <syssyphus@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

why would there be "unknown" data below? i have 2 btrfs arrays and
both have this going on. neither are active. any idea why and how to
make it go away?


Btrfs v3.12
btrfs fi df /media/btrfs
Data, RAID1: total=314.00GiB, used=313.55GiB
System, RAID1: total=32.00MiB, used=64.00KiB
Metadata, RAID1: total=1.00GiB, used=422.45MiB
unknown, single: total=144.00MiB, used=0.00
