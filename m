Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:31071 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbcA1IBB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 03:01:01 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6A5C3AC013E
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 17:00:57 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id 56037124
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 17:00:57 +0900 (JST)
Message-Id: <201601280800.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 28 Jan 2016 17:00:24 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: doc: fix typo of some documents
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some typos are corrected.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 Documentation/btrfs-check.asciidoc | 4 ++--
 Documentation/mkfs.btrfs.asciidoc  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index a929862..327a45d 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -24,7 +24,7 @@ OPTIONS
 -------
 -s|--super <superblock>::
 use <superblock>th superblock copy, valid values are 0 up to 2 if the
-respective superblock offset is within the fileystem
+respective superblock offset is within the filesystem
 --repair::
 try to repair the filesystem
 --init-csum-tree::
@@ -32,7 +32,7 @@ create a new CRC tree and recalculate all checksums
 --init-extent-tree::
 create a new extent tree
 --check-data-csum::
-verify checkums of data blocks
+verify checksums of data blocks
 -p|--progress::
 indicate progress at various checking phases
 --qgroup-report::
diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 0b145c7..82bb756 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -78,7 +78,7 @@ where the space is reserved for the other block group type, is not available for
 allocation and can lead to ENOSPC state.
 +
 The recommended size for the mixed mode is for filesystems less than 1GiB. The
-soft recommendation is to use it for filesystems smaller than 5GiB. Thie mixed
+soft recommendation is to use it for filesystems smaller than 5GiB. The mixed
 mode may lead to degraded performance on larger filesystems, but is otherwise
 usable, even on multiple devices.
 +
-- 
2.6.4
