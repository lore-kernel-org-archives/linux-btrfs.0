Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF601C04EBA
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77E9820989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 05:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77E9820989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jp.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbeK0Q2T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 11:28:19 -0500
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:62548 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbeK0Q2T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 11:28:19 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [192.168.231.132]) by mgwkm03.jp.fujitsu.com with smtp
         id 01eb_8a3d_2e1293e3_8c3c_43cd_b112_811dd67470e7;
        Tue, 27 Nov 2018 14:20:24 +0900
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id ED2EFAC00C1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 14:20:24 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 1B3AF46E6C0;
        Tue, 27 Nov 2018 14:20:24 +0900 (JST)
Received: from luna3.soft.fujitsu.com (10.124.196.199) by
 g01jpexchyt37.g01.fujitsu.local (10.128.193.67) with Microsoft SMTP Server id
 14.3.352.0; Tue, 27 Nov 2018 14:20:23 +0900
From:   Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>
Subject: [PATCH 7/8] btrfs-progs: test: Add helper function to check if test user exists
Date:   Tue, 27 Nov 2018 14:24:48 +0900
Message-ID: <452bdc64251360e5e31209d19ea84921152f4517.1543294426.git.misono.tomohiro@jp.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: disable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add helper function to check that if user 'nobody' exists or not.
Note that 'nobody' should not have root privileges as it will be used
to test the behavior of non-privileged user.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 tests/common | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tests/common b/tests/common
index 1575ae38..16693ca7 100644
--- a/tests/common
+++ b/tests/common
@@ -314,6 +314,16 @@ check_global_prereq()
 	fi
 }
 
+check_testuser()
+{
+	id -u nobody > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_not_run "Need to add user \"nobody\""
+	fi
+	# Note that nobody should not have root privileges
+	# otherwise test may not run as expected
+}
+
 check_image()
 {
 	local image
-- 
2.19.1


