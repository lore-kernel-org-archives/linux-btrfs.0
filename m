Return-Path: <SRS0=6xoG=3L=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF212C33CB6
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jan 2020 12:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A599224684
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jan 2020 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579695762;
	bh=nQLtEDRbYssgJSvrupPb0Kxq4dvjvnEOmbuGYmIf6Tw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=wUWeSyhj5vPPf8662DHFw3CjUBVhUAdxMPTmHe64txVlVOvhZWqMsfMIRjlFkK7bt
	 i6kCFJs3k+tQhuTNWIweX6ESvrqlctTw06w/VwgNb6gZ4hEixKM5UrNb4tPIit6QXK
	 Cp9q0OsrZmcqZZhfGx/q0g5+Ll7FpKe8msK/0nc0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAVMWm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 07:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbgAVMWl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jan 2020 07:22:41 -0500
Received: from debian5.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8045C24655;
        Wed, 22 Jan 2020 12:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579695761;
        bh=nQLtEDRbYssgJSvrupPb0Kxq4dvjvnEOmbuGYmIf6Tw=;
        h=From:To:Cc:Subject:Date:From;
        b=OtP+WUdsujqOWjcRcWqyLvgXvdljurDEXl2EzIjoUiHIrHzaixiCGe5bx5biHYEjB
         9rG9XyVcOHoBAe3cPtdidO1fQsfRWEGDAO8gFMXsVFc41NIeLsnJe/xQ96FEHpWZKI
         G/gXkq52xPuW1a17sWsNYraV9mX1dqNHFifuRvE8=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: remove test btrfs/130 from the dangerous group
Date:   Wed, 22 Jan 2020 12:22:33 +0000
Message-Id: <20200122122233.1931-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

As of the linux kernel commit fd0ddbe2509568 ("Btrfs: send, skip
backreference walking for extents with many references"), the test is no
longer dangerous and it's fast (takes 1 to 2 seconds on a modest vm with
a debug kernel). Therefore remove it from the dangerous group and add it
to the auto and quick groups as well.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/group | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/group b/tests/btrfs/group
index d7eeb45d..8a69f940 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -132,7 +132,7 @@
 127 auto quick send
 128 auto quick send
 129 auto quick send
-130 clone send dangerous
+130 auto quick clone send
 131 auto quick
 132 auto enospc
 133 auto quick send
-- 
2.11.0

