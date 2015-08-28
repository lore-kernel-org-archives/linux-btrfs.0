Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881AbbH1Bmr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 21:42:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] fstests: template: Add seqres.full cleanup
Date: Fri, 28 Aug 2015 09:40:43 +0800
Message-ID: <1440726043-17566-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add cleanup for seqres.full for new test case template, as sometimes
new testcase may forgot to cleanup seqres.full.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 new | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/new b/new
index c734bdc..ab2af69 100755
--- a/new
+++ b/new
@@ -200,6 +200,9 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 
+# remove previous \$seqres.full before test
+rm -f \$seqres.full
+
 # real QA test starts here
 
 # Modify as appropriate.
-- 
1.8.3.1

