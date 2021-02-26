Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479BFC433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Feb 2021 15:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7E3264EED
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Feb 2021 15:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhBZPRr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 10:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhBZPRq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Feb 2021 10:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5B7F64EE7
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2021 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614352625;
        bh=W/0CKMqaGb4JA1N+vxnmbfb4H23VOmUB+dEABBp9q2E=;
        h=From:To:Subject:Date:From;
        b=eLHm4+P+lMyah0Vn3l+JW7yCwhU1hx+0upMymZ01Lg7c5B2nUK6gisUEJiHz5rgUs
         fEqZIKU180jc6faANEICAs1E3Q+MnFUI2oSMDMRrqQ9ObM+zx3Z3SveS/OvU9NP893
         2S9JD5x4D3e97MwVWXLBJz+gnTGMcaeFUnSajh/WD6C9qCnvJx4uNf6x7BAKC1nVX4
         2+Y+1qEMWJeXJH2sxR0W7z0Aao0Xb0P8z0qEYR2PpPwE4N4MFplMgvkH2LjDZkB5W7
         SI6nYo/5aMyQFYx853Ri6rvrLNsrhRdHMqmSYMJVjjUajHELkLEBYZ8kzbp5/eTidL
         ITMV2hMxeCOzw==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: add btree read ahead for send operations
Date:   Fri, 26 Feb 2021 15:17:00 +0000
Message-Id: <cover.1614351671.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This patchset adds btree read ahead for full and incremental send operations,
which results in some nice speedups. Test and results are mentioned in the
change log of each patch.

Filipe Manana (2):
  btrfs: add btree read ahead for full send operations
  btrfs: add btree read ahead for incremental send operations

 fs/btrfs/send.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

-- 
2.28.0

