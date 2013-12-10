Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:36466 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3LJUbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:10 -0500
Received: by mail-vb0-f53.google.com with SMTP id o19so941491vbm.40
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 12:31:09 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 10 Dec 2013 22:31:09 +0200
Message-ID: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com>
Subject: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, if you want to protect your data against bit-rot on
a single device you must have 2 btrfs partitions and mount
them as Raid1. The requested option will save the user from
partitioning and will provide flexibility.

Yes, I know: This will not provide any safety againts hardware
failure. But it is not the purpose anyway.

The main purpose is to "Ensure Data Integrity" on:
a- Computers (ie. laptops) where hardware raid is not practical.
b- Backup sets (ie. usb drives) where hardware raid is an overkill.

Even if you have regular backups, without having
"Guaranteed Data Integrity" on all data sets, you will
lose some data on some day, somewhere.

See discussion at:
http://hardware.slashdot.org/story/13/12/10/178234/ask-slashdot-practical-bitrot-detection-for-backups


Now, the futuristic and OPTIONAL part for the sufficiently paranoid:
The number of duplicates may be parametric:

mkfs.btrfs -m dup 4 -d dup 3 ... (4 duplicates for metadata, 3
duplicates for data)

I kindly request your comments. (At least for "-d dup")

Regards,
Imran Geriskovan
