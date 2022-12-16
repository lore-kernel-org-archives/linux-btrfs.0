Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA7C001B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Dec 2022 07:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiLPHH6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 02:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiLPHHe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2022 02:07:34 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EFF37F90;
        Thu, 15 Dec 2022 23:06:03 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 67A235C9DA;
        Fri, 16 Dec 2022 07:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1671174362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ChZseXvr8dKeUIqCbZUneKtIuE30AtRyew04hdrxDUU=;
        b=F7aeiFeRFrEZgpm1g0V+kGmxyUwR4lgOKlhgj/SS2kBUam+2maJfQU/VUjjVF46mgSxSr1
        wAf2sk8xriBDgIWWJ7Jhzd5yzKt5CimF1H4AbR8MGLCaCR9wyvvCpX2AXjHQMKX5aMySWv
        PKWJAmzsAHqFYAA69qWO7XMbJEUvK40=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 76DC5138F0;
        Fri, 16 Dec 2022 07:06:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VjxuD9kYnGOLBgAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 16 Dec 2022 07:06:01 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: report: add arch and kernel version info into testsuite attributes
Date:   Fri, 16 Dec 2022 15:05:43 +0800
Message-Id: <20221216070543.31638-1-wqu@suse.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Although "testcase" tags contain the "timestamp" element, for day-0
testing it can be hard to relate the timestamp to the tested kernel
version.

Thus this patch will add a "kernel" element to the "testcase" tag, to
indicate the kernel version we're running.
Paired with CONFIG_LOCALVERSION_AUTO=y config, it will easily show the
kernel commit we're testing.

Since we're here, also add a "arch" element, as there are more and more
aarch64 boards (From RK3399 to Apple M1) able to finish fstests in an
acceptable duration, we can no longer assume x86_64 as our only
platform.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/report | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/report b/common/report
index 4a747f8d..92586527 100644
--- a/common/report
+++ b/common/report
@@ -49,7 +49,7 @@ _xunit_make_section_report()
 		date_time=$(date +"%F %T")
 	fi
 	local stats="failures=\"$bad_count\" skipped=\"$notrun_count\" tests=\"$tests_count\" time=\"$sect_time\""
-	local hw_info="hostname=\"$HOST\" timestamp=\"${date_time/ /T}\" "
+	local hw_info="hostname=\"$HOST\" timestamp=\"${date_time/ /T}\" arch=\"$(uname -m)\" kernel=\"$(uname -r)\""
 	echo "<testsuite name=\"xfstests\" $stats  $hw_info >" >> $REPORT_DIR/result.xml
 
 	# Properties
-- 
2.38.0

