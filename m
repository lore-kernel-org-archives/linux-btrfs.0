Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC30C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81C7C208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81C7C208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbeK0N3q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:29:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:58570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728333AbeK0N3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:29:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51802AF5A
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 02:33:28 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] btrfs-progs: misc-tests/021: Do extra btrfs check before mounting
Date:   Tue, 27 Nov 2018 10:33:15 +0800
Message-Id: <20181127023315.28176-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127023315.28176-1-wqu@suse.com>
References: <20181127023315.28176-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Test case misc/021 is testing if we could mount a single disk btrfs
image recovered from multi disk fs.

The problem is, current kernel has extra check for block group, chunk
and dev extent.
This means any image can't pass btrfs check for chunk tree will not
mount.

So do extra btrfs check before mount, this will also help us to locate
the problem in btrfs-image easier.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/misc-tests/021-image-multi-devices/test.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/misc-tests/021-image-multi-devices/test.sh b/tests/misc-tests/021-image-multi-devices/test.sh
index 5430847f4e2f..26beae6e4b85 100755
--- a/tests/misc-tests/021-image-multi-devices/test.sh
+++ b/tests/misc-tests/021-image-multi-devices/test.sh
@@ -37,6 +37,9 @@ run_check $SUDO_HELPER wipefs -a "$loop2"
 
 run_check $SUDO_HELPER "$TOP/btrfs-image" -r "$IMAGE" "$loop1"
 
+# Run check to make sure there is nothing wrong for the recovered image
+run_check "$TOP/btrfs" check "$loop1"
+
 run_check $SUDO_HELPER mount "$loop1" "$TEST_MNT"
 new_md5=$(run_check_stdout md5sum "$TEST_MNT/foobar" | cut -d ' ' -f 1)
 run_check $SUDO_HELPER umount "$TEST_MNT"
-- 
2.19.2

