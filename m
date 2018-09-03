Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64813 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbeICHSc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 03:18:32 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 099984B5CBE6
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Sep 2018 11:00:20 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: docs: update document about option -R of btrfs-scrub
Date: Mon, 3 Sep 2018 11:07:07 +0800
Message-ID: <20180903030707.3542-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The option '-R' of btrfs-scrub was documented by mistake as
'print raw statistics per-device instead of a summary'.

Here change it to 'raw print mode, print full data instead of
summary' which it works actually.

Fixes: 162257574a56 ("btrfs-progs: docs: update btrfs-scrub")
Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-scrub.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index d2d206275c36..4c49269e2f36 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -69,7 +69,7 @@ be quiet, omit error messages and statistics
 run in read-only mode, do not attempt to correct anything, can be run on a read-only
 filesystem
 -R::::
-print raw statistics per-device instead of a summary
+raw print mode, print full data instead of summary
 -c <ioprio_class>::::
 set IO priority class (see `ionice`(1) manpage)
 -n <ioprio_classdata>::::
-- 
2.18.0
