Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:33421 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbcADRAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 12:00:48 -0500
Received: by mail-yk0-f195.google.com with SMTP id y10so13385008ykf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jan 2016 09:00:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 4 Jan 2016 18:00:47 +0100
Message-ID: <CAHJqNbyXUfzscHteqrQtxJdYKToDNv7_Hw9tVpPuNJYwe=NHxw@mail.gmail.com>
Subject: Purposely using btrfs RAID1 in degraded mode ?
From: Alphazo <alphazo@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

My picture library today lies on an external hard drive that I sync on
a regular basis with a couple of servers and other external drives.
I'm interested by the on-the-fly checksum brought by btrfs and would
like to get your opinion on the following unusual use case that I have
tested:
- Create a btrfs with the two drives with RAID1
- When at home I can work with the two drives connected so I can enjoy
the self-healing feature if a bit goes mad so I only backup perfect
copies to my backup servers.
- When not at home I only bring one external drive and manually mount
it in degraded mode so I can continue working on my pictures while
still having checksum error detection (but not correction).
- When coming back home I can plug-back the seconde drive and initiate
a scrub or balance to get the second drive duplicated.

I have tested the above use case with a couple of USB flash drive and
even used btrfs over dm-crypt partitions and it seemed to work fine
but I wanted to get some advices from the community if this is really
a bad practice that should not be used on the long run. Is there any
limitation/risk to read/write to/from a degraded filesystem knowing it
will be re-synced later?

Thanks
alphazo

PS: I have also investigated the RAID1 on a single drive with two
partitions but I cannot afford the half capacity resulting from that
approach.
