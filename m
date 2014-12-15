Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65129 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLOUCz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:02:55 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so10298588wiv.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 12:02:54 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/7] Add -v and -o switches
Date: Mon, 15 Dec 2014 21:03:00 +0100
Message-Id: <1418673780-22000-8-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add -v and -o switches to the mkfs.btrfs man page.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/mkfs.btrfs.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
index ba7e42b..8ecb1a6 100644
--- a/Documentation/mkfs.btrfs.txt
+++ b/Documentation/mkfs.btrfs.txt
@@ -17,13 +17,16 @@ $$[-l|--leafsize <leafsize>]$$
 $$[-L|--label <label>]$$
 $$[-m|--metadata <metadata profile>]$$
 $$[-M|--mixed]$$
+$$[-q|--quiet]$$
 $$[-s|--sectorsize <sectorsize>]$$
 $$[-r|--rootdir <rootdir>]$$
 $$[-K|--nodiscard]$$
 $$[-O|--features <feature1>[,<feature2>...]]$$
+$$[-q|--quiet]$$
 $$[-U|--uuid <UUID>]$$
 $$[-h]$$
 $$[-V|--version]$$
+$$[-v|--verbose]$$
 $$<device> [<device>...]$$
 
 DESCRIPTION
@@ -120,6 +123,12 @@ the system.
 -V|--version::
 Print the *mkfs.btrfs* version and exit.
 
+-v|--verbose::
+Increase the verbosity of the command.
+
+-q|--quiet::
+Print only the errors.
+
 -h::
 Print help.
 
-- 
2.1.3

