Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A59AC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4772E2084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731829AbeLQIgG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 03:36:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:56808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbeLQIgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 03:36:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2CA5AC3A
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 08:36:04 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Misc cleanups of btrfs_get_extent
Date:   Mon, 17 Dec 2018 10:35:58 +0200
Message-Id: <20181217083602.10166-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is a series that hopefully makes the code a bit more obvious. First patch 
gives a variable a more appropraite name, since it's going to be used only for 
holding an extent type and not the type of a found item. 

Patch 2 simply consolidated separate 'if' statements that check the retval of
the same function into a single 'if() {} else if () {}' statement. IMO this is 
cleaner.

Patch 3 massages the abhorrent code that deals with btrfs_lookup_file_extent
retval. It groups everything in a coherent 'if() {} else if () {} else {}' 
construct and now it's obvious under what conditions specific code is executed. 

Finally, Patch 4 removes the not_found_em labelin the same function.

Nikolay Borisov (4):
  btrfs: Rename found_type to extent_type
  btrfs: Consolidate retval checking of core btree functions
  btrfs: Refactor retval handling of btrfs_lookup_file_extent in
    btrfs_get_extent
  btrfs: Remove not_found_em label from btrfs_get_extent

 fs/btrfs/inode.c | 67 ++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

-- 
2.17.1

