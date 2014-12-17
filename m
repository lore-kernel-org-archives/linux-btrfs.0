Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58393 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaLQUND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:13:03 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so17018186wiw.7
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:13:02 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 8/8] Add -v and -q switches in the mkfs.btrfs man page
Date: Wed, 17 Dec 2014 21:14:12 +0100
Message-Id: <1418847252-14184-9-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add -v and -q switches to the mkfs.btrfs man page. These information
will be printed by a next patch in the summary.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/mkfs.btrfs.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
index ba7e42b..67b546a 100644
--- a/Documentation/mkfs.btrfs.txt
+++ b/Documentation/mkfs.btrfs.txt
@@ -21,9 +21,11 @@ $$[-s|--sectorsize <sectorsize>]$$
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
@@ -120,6 +122,12 @@ the system.
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

