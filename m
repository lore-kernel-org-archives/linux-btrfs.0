Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33453 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbcAAPvh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 10:51:37 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so114640459wmf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 07:51:36 -0800 (PST)
Received: from orione.localnet (183.Red-83-50-202.dynamicIP.rima-tde.net. [83.50.202.183])
        by smtp.gmail.com with ESMTPSA id w17sm32374686wmw.15.2016.01.01.07.51.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 01 Jan 2016 07:51:35 -0800 (PST)
From: =?ISO-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs send / receive freeze system?
Date: Fri, 01 Jan 2016 15:51:33 +0000
Message-ID: <2876879.yKrnxB0p8M@orione>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone.
It's a few weeks that I converted my root partition into btrfs with three sub-
volumes named boot,root,home. I'm booting with /boot on subvol.

I'm using btrfs send and receive to make backup of the three snapshotted 
subvolumes on a second btrfs formatted drive with three commands like this: 

btrfs send /btrfs-root/snap-root/ | gzip > $BKFOLDER/root.dump.gz

Sometimes, let say once a week, the system completely freeze (mouse keyboard) 
during the send, only solution was the reset button. The freeze happened on 
different place every time. Last time happened at 80% of the home send for 
example.

The freeze also happened during a send/receive from an external e-sata drive 
(to copy some mp3 using send instead of rsync) to the same internal drive 
where the backup are also made.

The system always run and was stable with XFS/xfsdump.

Kernel is 4.3.3, btrfs progs are 4.3.1, system is Arch Linux 64 bit, Ram 8Gb 
Mainboard Asus striker extreme Nvidia 680i, 8 years old.

After the crash nothing is shown in the systemd log, it simply freeze.

Thanks, regards,
Mario


