Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:52260 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdIEFuL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 01:50:11 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 92C72AC00E5
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Sep 2017 14:50:07 +0900 (JST)
Received: from g01jpexchyt35.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id B3F27584301
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Sep 2017 14:50:06 +0900 (JST)
Subject: [PATCH 2/2] btrfs-progs: test: fix name generation not to contain
 trailing spaces
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <64ab304a-6b5f-d2ac-3b74-90952371404e@jp.fujitsu.com>
Message-ID: <c27eb6e9-4a07-12c5-acd6-76229b2a7103@jp.fujitsu.com>
Date: Tue, 5 Sep 2017 14:50:03 +0900
MIME-Version: 1.0
In-Reply-To: <64ab304a-6b5f-d2ac-3b74-90952371404e@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First patch causes test-convert fails.  This is because
generate_dataset() creates a name containing trailing spaces for
"slow_symlink" type, and cause getfacl error in convert_test_perm().
(This is not noticed since original run_check_stdout() throws away the
error.)

Fix this by use space for delimiter for cut.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 tests/common | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/common b/tests/common
index b7d3436..2647aa6 100644
--- a/tests/common
+++ b/tests/common
@@ -509,7 +509,7 @@ generate_dataset() {
 			;;
 
 		slow_symlink)
-			long_filename=`date +%s | sha256sum | cut -f1 -d'-'`
+			long_filename=`date +%s | sha256sum | cut -f1 -d ' '`
 			run_check $SUDO_HELPER touch "$dirpath/$long_filename"
 			for num in $(seq 1 "$DATASET_SIZE"); do
 				run_check $SUDO_HELPER ln -s "$dirpath/$long_filename" "$dirpath/slow_slink.$num"
-- 
2.9.5

