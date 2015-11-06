Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33624 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030705AbbKFJDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 04:03:55 -0500
Received: by wijp11 with SMTP id p11so25885827wij.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 01:03:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
References: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
	<CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com>
Date: Fri, 6 Nov 2015 10:03:54 +0100
Message-ID: <CANznX5EE2YcnTc6-gsQ8R_2p1yt8GSJdRRsXtsEf7VW9Au+P+A@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
From: "Janos Toth F." <toth.f.janos@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created a fresh RAID-5 mode Btrfs on the same 3 disks (including the
faulty one which is still producing numerous random read errors) and
Btrfs now seems to work exactly as I would anticipate.

I copied some data and verified the checksum. The data is readable and
correct regardless of the constant warning messages in the kernel log
about the read errors on the single faulty HDD (the bad behavior is
confirmed by the SMART logs and I tested it in a different PC as
well...).

I also ran several scrubs and now it always finishes with X corrected
and 0 uncorrected errors. (The errors are supposedly corrected but the
faulty HDD keeps randomly corrupting the data...)
The last time I saw uncorrected errors during the scrub and not every
data was readable. Rather strange...

I ran 24 hours of Gimps/Prime95 Blend stresstest without errors on the
problematic machine.
Although I updated the firmware of the drives. (I found an IMPORTANT
update when I went there to download SeaTools, although there was no
change log to tell me why this was important). This might changed the
error handling behavior of the drive...?
