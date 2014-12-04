Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58040 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaLDNx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 08:53:26 -0500
Received: by mail-qc0-f171.google.com with SMTP id r5so12623150qcx.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 05:53:25 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Thu, 4 Dec 2014 19:23:05 +0530
Message-ID: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com>
Subject: System/single + Metadata/single as leftover cruft of mkfs?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I observe that whenever I create a BtrFS instance using mkfs.btrfs,
there is always the leftover cruft of two System/Metadata-Single
allocation profiles:

btrfs fi df /run/media/samjnaa/BRIHATII/
Data, single: total=460.01GiB, used=458.47GiB
System, DUP: total=8.00MiB, used=80.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.50GiB, used=736.86MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=256.00MiB, used=0.00B

Doing btrfs balance eventually removes these (but since I forgot to do
it *before* copying 400+ G of data to the drive it's still running)
but I don't understand why these have to be created in the first
place? (I just used SuSE Tumbleweed's default mkfs.btrfs without any
-m or -d options.)

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
