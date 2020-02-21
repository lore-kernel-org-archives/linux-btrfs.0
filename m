Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698A5C35646
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4693724650
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgBUNCd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:02:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:39916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgBUNCd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 08:02:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1DB7BAF43;
        Fri, 21 Feb 2020 13:02:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 77EAEDA70E; Fri, 21 Feb 2020 14:02:13 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Clean up supported flags for ioctls
Date:   Fri, 21 Feb 2020 14:02:12 +0100
Message-Id: <cover.1582289899.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The subvolume args passed as the vol_args_v2 should be separated by the
ioctl using them, add that for existing ioctls. The upcoming subvolume
deletion-by-id will add new flags, so this should be considered
preparatory patchset.

David Sterba (3):
  btrfs: define support masks for ioctl volume args v2
  btrfs: use ioctl args support mask for subvolume create/delete
  btrfs: use ioctl args support mask for device delete

 fs/btrfs/ioctl.c           |  7 ++-----
 include/uapi/linux/btrfs.h | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.25.0

