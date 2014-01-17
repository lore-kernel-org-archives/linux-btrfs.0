Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm14-vm1.bullet.mail.ird.yahoo.com ([77.238.189.91]:48518 "EHLO
	nm14-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaAQSkF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 13:40:05 -0500
Message-ID: <1389983615.90027.YahooMailNeo@web172606.mail.ir2.yahoo.com>
Date: Fri, 17 Jan 2014 18:33:35 +0000 (GMT)
From: "valleysmail-lol5@yahoo.de" <valleysmail-lol5@yahoo.de>
Reply-To: "valleysmail-lol5@yahoo.de" <valleysmail-lol5@yahoo.de>
Subject: drawbacks of non-ECC RAM
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I'd like to know if there are drawbacks in using btrfs with non-ECC RAM instead of using ext4 with non-ECC RAM. I know that some features of btrfs may rely on ECC RAM but is the chance of data corruption or even a damaged filesystem higher than when i use ext4 instead of btrfs?
I want to know this because i would like to use the snapshot feature of btrfs and ext4 does not support that. I will not use btrfs for fixing silent data corruption nor for using RAID like features or encryption. ZFS however checks files in the background (even if i don't want) and if it thinks there is an error it will fix it and i cannot disable this feature. So errors in RAM may corrupt my files or even more.


If you have some information regarding this topic or some good links i would be very happy! =)

