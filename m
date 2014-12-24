Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39101 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXHLo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 02:11:44 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id D86AC3EE16B
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 16:11:42 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id DCFAEAC03F7
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 16:11:41 +0900 (JST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 7F3F6E08004
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 16:11:41 +0900 (JST)
Received: from WIN-R1VKH1IH438.jp.fujitsu.com (unknown [10.124.102.85])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id 53B6318A
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Dec 2014 16:11:41 +0900 (JST)
Message-Id: <201412240710.AA00005@WIN-R1VKH1IH438.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 24 Dec 2014 16:10:52 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: doc: fix incorrect format of 'l' option in mkfs.btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The format of 'l' option in mkfs.btrfs.txt is wrong.
And, when the head of the character string is 65536, the following warning
is displayed.

    $ make
    Making all in Documentation
        [ASCII]  mkfs.btrfs.xml
    asciidoc: WARNING: mkfs.btrfs.xml.tmp1: line 67: list item index: expected 1 got 65536
        [XMLTO]  mkfs.btrfs.8
        [GZ]     mkfs.btrfs.8.gz
    rm mkfs.btrfs.8 mkfs.btrfs.xml

So, fix it.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 Documentation/mkfs.btrfs.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/mkfs.btrfs.txt b/Documentation/mkfs.btrfs.txt
index ba7e42b..01b615d 100644
--- a/Documentation/mkfs.btrfs.txt
+++ b/Documentation/mkfs.btrfs.txt
@@ -59,19 +59,18 @@ By default, mkfs.btrfs will not write to the device if it suspects that
 there is a filesystem or partition table on the device already.
 
 -n|--nodesize <size>
-+
+
 -l|--leafsize <size>::
 Specify the nodesize, the tree block size in which btrfs stores
 data. The default value is 16KB (16384) or the page size, whichever is
-bigger. Must be a multiple of the sectorsize, but not larger than
-65536. Leafsize always equals nodesize and the options are aliases.
+bigger. Must be a multiple of the sectorsize, but not larger than 65536.
+Leafsize always equals nodesize and the options are aliases.
 
 -L|--label <name>::
 Specify a label for the filesystem.
 +
 NOTE: <name> should be less than 256 characters.
 
-
 -m|--metadata <profile>::
 Specify how metadata must be spanned across the devices specified. Valid
 values are 'raid0', 'raid1', 'raid5', 'raid6', 'raid10', 'single' or 'dup'.
-- 
2.1.0

