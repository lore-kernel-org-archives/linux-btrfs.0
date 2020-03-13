Return-Path: <SRS0=6pDE=46=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96387C10DCE
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 15:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 747DA20724
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Mar 2020 15:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgCMPXY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Mar 2020 11:23:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:42164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbgCMPXY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Mar 2020 11:23:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31188AD39;
        Fri, 13 Mar 2020 15:23:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Removal of BTRFS_SUBVOL_CREATE_ASYNC support
Date:   Fri, 13 Mar 2020 17:23:17 +0200
Message-Id: <20200313152320.22723-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Having deprecated this feature in 5.4 now it's time to actually delete it.

First patch removes the user-visible support. The other 2 remove unneeded
arguments and code.

Nikolay Borisov (3):
  btrfs: Remove BTRFS_SUBVOL_CREATE_ASYNC support
  btrfs: Remove transid argument from btrfs_ioctl_snap_create_transid
  btrfs: Remove async_transid
    btrfs_mksubvol/create_subvol/create_snapshot

 fs/btrfs/ioctl.c           | 73 +++++++++-----------------------------
 include/uapi/linux/btrfs.h |  7 ++--
 2 files changed, 18 insertions(+), 62 deletions(-)

--
2.17.1

