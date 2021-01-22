Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757E8C433DB
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Jan 2021 15:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B3023A84
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Jan 2021 15:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbhAVP3d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 10:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbhAVP3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jan 2021 10:29:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A039523A84
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2021 15:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611329318;
        bh=vhy/3YRrRGI9CXR24Lm2QarD1d/496Zr4YdSunpRZC8=;
        h=From:To:Subject:Date:From;
        b=e75XzruZeSnHm6MFPt28elmF1RSlZyv8asBJbIRSvOZBxyPS8abCRqeKmxAADrHRf
         i55WljgzbJs1dA2RE/SKUiyGV0XWJPUjLoZfKQtJZ3nBVOnmripVR6KY0fqRARuODu
         hmCBLhZ+xHhe4LeFWr+8elkJhwVR3GRoR+TwE5pD156JWq51ScRWe+n8ASYHKwGDdl
         O0V6k4FBjEeNtkXuY1BMEUnD03I0N0yaLPom6O1n0+wAUvF5mYIPWGm0Lv5+ESU7SR
         zi9FNssLNrM6oC5d5hgrY6HkawszOA264xiuRzNZsEfwxWBadHY1Pm9xiWD4aHJNoJ
         BiEI1CZqVhnbA==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: a couple bug fixes for failures of log replay and mount
Date:   Fri, 22 Jan 2021 15:28:33 +0000
Message-Id: <cover.1611327201.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This small patchset fixes two bugs that lead to an -EINVAL failure during
log replay, causing the filesystem mount to fail. They are relatively new
regressions, one caused by the recent change to make space cache loading
asynchronous and the other caused by the refactoring that made tracking
pinned extents in the transaction instead of tracking them at fs_info.

Filipe Manana (2):
  btrfs: fix log replay failure due to race with space cache rebuild
  btrfs: fix log replay failure when space cache needs to be rebuilt

 fs/btrfs/block-group.c | 15 ++++++++++++---
 fs/btrfs/block-group.h |  3 ++-
 fs/btrfs/extent-tree.c | 15 +++++++++------
 3 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.28.0

