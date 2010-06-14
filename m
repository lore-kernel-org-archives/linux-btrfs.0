From: Erik Jensen <erikjensen@laurelwoodart.com>
Subject: Unable to remove failing drive from storage pool
Date: Mon, 14 Jun 2010 14:19:42 -0700
Message-ID: <AANLkTikqJdO2CWNtxd59L5Y1Ct0s3zv1lhoi41TKKcfS@mail.gmail.com>
References: <AANLkTinQ-7szZ_Qfdvfq-lAQL3Y_JjJB3GHC3L0iv8e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinQ-7szZ_Qfdvfq-lAQL3Y_JjJB3GHC3L0iv8e6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I currently have a btrfs filesystem set up across three drives.
Unfortunately, one is failing and is returning read errors.=A0 I tried
to remove the drive from the pool using btrfs-vol -r, but the process
seems to hang when a read error is encountered.=A0 At this point, disk
activity stops and no further progress is made, with the drive
remaining in the pool.

I would like to be able to remove the drive from the pool, retaining
as much data as possible.=A0 (It's just TV recordings, so a little
corruption shouldn't be too much of a problem).

I am using version 2.6.32 of the kernel.

The relevant part of the dmesg output: http://fpaste.org/jnz8/

The part of the kernel state that seemed like they might be relevant:
http://fpaste.org/0KKR/
btrfs-vol is towards the bottom.=A0 The entire state dump didn't fit in
my dmesg buffer so there might be something missing.

Thanks,
Erik Jensen
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
