Return-Path: <SRS0=f83N=ZT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011D4C43141
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65512075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfK0EoL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 23:44:11 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48386 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfK0EoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 23:44:10 -0500
X-Envelope-Mail-From: zblaxell@waya.furryterror.org
X-Envelope-Mail-From: zblaxell@waya.furryterror.org
Received: from waya.furryterror.org (waya.vpn7.hungrycats.org [10.132.226.63])
        by james.kirk.hungrycats.org (Postfix) with ESMTP id BA27E4F8A76;
        Tue, 26 Nov 2019 23:37:44 -0500 (EST)
Received: from zblaxell by waya.furryterror.org with local (Exim 4.92)
        (envelope-from <zblaxell@waya.furryterror.org>)
        id 1iZp5E-0003PD-Bl; Tue, 26 Nov 2019 23:37:44 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs-progs: ioctl-test: add LOGICAL_INO_V2
Date:   Tue, 26 Nov 2019 22:55:04 -0500
Message-Id: <20191127035509.15011-2-ce3g8jdj@umail.furryterror.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127035509.15011-1-ce3g8jdj@umail.furryterror.org>
References: <20191127035509.15011-1-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Same as LOGICAL_INO, except a different magic number.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 ioctl-test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ioctl-test.c b/ioctl-test.c
index 65d584be..a79a13b0 100644
--- a/ioctl-test.c
+++ b/ioctl-test.c
@@ -82,7 +82,8 @@
 	ONE(BTRFS_IOC_GET_FEATURES)		\
 	ONE(BTRFS_IOC_SET_FEATURES)		\
 	ONE(BTRFS_IOC_GET_SUPPORTED_FEATURES)	\
-	ONE(BTRFS_IOC_RM_DEV_V2)
+	ONE(BTRFS_IOC_RM_DEV_V2)		\
+	ONE(BTRFS_IOC_LOGICAL_INO_V2)
 
 #define LIST					\
 	LIST_BASE				\
@@ -160,6 +161,7 @@ static struct ioctl_number expected_list[] = {
 	{ BTRFS_IOC_SET_FEATURES,                   0x0040309439 },
 	{ BTRFS_IOC_GET_SUPPORTED_FEATURES,         0x0080489439 },
 	{ BTRFS_IOC_RM_DEV_V2,                      0x005000943a },
+	{ BTRFS_IOC_LOGICAL_INO_V2,                 0x00c038943b },
 };
 
 static struct btrfs_ioctl_vol_args used_vol_args __attribute__((used));
-- 
2.20.1

