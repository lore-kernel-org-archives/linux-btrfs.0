From: Giuseppe Scrivano <gscrivano@gnu.org>
Subject: [PATCH] documentation: update the ioctl numbers list
Date: Wed, 26 Aug 2009 12:17:36 +0200
Message-ID: <87my5mnakf.fsf@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

shouldn't the ioctl number used by the BTRFS file system be mentioned in
the documentation ioctl numbers list?

Cheers,
Giuseppe


>From 8cc465afd0bcfcb8930593af667f12a9ee096d01 Mon Sep 17 00:00:00 2001
From: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Wed, 26 Aug 2009 11:33:49 +0200
Subject: [PATCH] documentation: update the ioctl numbers list

Mention the ioctl number used by BTRFS.
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 1f779a2..fe91e3e 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -177,6 +177,7 @@ Code	Seq#	Include File		Comments
 					<http://www.proximity.com.au/~brian/winradio/>
 0x90	00	drivers/cdrom/sbpcd.h
 0x93	60-7F	linux/auto_fs.h
+0x94	01-0E	fs/btrfs/ioctl.h	BTRFS
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
 0xA0	all	linux/sdp/sdp.h		Industrial Device Project
-- 
1.6.3.3
