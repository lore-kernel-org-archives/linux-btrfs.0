Return-Path: <SRS0=9BDA=W2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B870DC3A59B
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 919A623427
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfH3Oow (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 10:44:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:41200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727135AbfH3Oow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Aug 2019 10:44:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 879CDB008;
        Fri, 30 Aug 2019 14:44:51 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanup backref_in_log and its callers
Date:   Fri, 30 Aug 2019 17:44:46 +0300
Message-Id: <20190830144449.23882-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series cleans up backref_in_log and its callers. Patch 1 removes the 
opencoding of btrfs_find_name_in_backref which greatly simplifies backref_in_log
itself. 

Patch 2 properly propagates error values of the internal functions to
backref_in_log's callers and also fixes, where necessary, callers to cope with 
those ret values. 

Patch 3 continues in the spirit of the previous patch, in that it open codes 
name_in_log_ref so that the caller can properly handle backref_in_log retvals. 

Nikolay Borisov (3):
  btrfs: Don't opencode btrfs_find_name_in_backref in backref_in_log
  btrfs: Properly handle backref_in_log retval
  btrfs: Open-code name_in_log_ref in replay_one_name

 fs/btrfs/tree-log.c | 113 +++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 69 deletions(-)

-- 
2.17.1

