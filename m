Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:58154 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753480AbaA0MEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 07:04:40 -0500
Received: from [79.135.116.105] (helo=[192.168.0.190])
	by lon-b.elastichosts.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.72)
	(envelope-from <alin.dobre@elastichosts.com>)
	id 1W7kbH-0004CY-Hc
	for linux-btrfs@vger.kernel.org; Mon, 27 Jan 2014 11:43:35 +0000
Message-ID: <52E64665.5020109@elastichosts.com>
Date: Mon, 27 Jan 2014 11:43:33 +0000
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Monitoring for disk failures
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

I am trying to create a very simple script that would alert in case of
disk failures from a RAID Btrfs.

Digging into the code, I have noticed that the "btrfs fi sh" command
should display a warning if there is a missing disk. However, testing in
a Qemu, I used "drive_del" via QMP to remove a "live" SCSI drive,
already mounted as part of a RAID10 array, the "fi sh" command still
gave no indication that the drive is missing. Then, I tried removing a
scsi disk from the host via "echo 1 >/sys/block/sdX/device/delete" to
actually make the kernel SCSI host forget about it, and "fi sh" still
doesn't show anything.

I have tested using btrfs-progs v3.12 and kernel 3.13.0.

Do you guys know what's wrong with the setup explained above or do you
have any indication on how to detect if there is a failing disk, part of
a Btrfs RAID?

Cheers,
Alin.
