Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:40185 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab2LCHeL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Dec 2012 02:34:11 -0500
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Subject: 64KB "boot sector" gap
Message-Id: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
Date: Mon, 3 Dec 2012 00:34:06 -0700
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When creating a btrfs volume with mkfs.btrfs, I'm noticing that the first 64KB are completely blank. Is this gap expressly intended for installing a boot manager/loader? e.g. GRUB 2 allows installation of boot.img + core.img into a btrfs formatted partition, without using block lists (the --force flag). It appears to produce a bootable system.

However, the man page says -A, --alloc-start specifies the offset to the start of the file system, and that the default is zero. If the default is zero, the file system starts immediately, which implies those 64KB of zero aren't actually intended for a boot loader.

In all three of these examples:
mkfs.btrfs /dev/sda1
mkfs.btrfs -A 5000 /dev/sda1
mkfs.btrfs -A 50000 /dev/sda1

I get the same results for:
hexdump -C /dev/sda1

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00010000  66 0d 21 28 00 00 00 00  00 00 00 00 00 00 00 00  |f.!(….........|

The file system appears to start at the same point in all cases. I zero'd the first 500MB of the partition in between each mkfs attempt.

What am I misunderstanding, or is this a bug?


Chris Murphy