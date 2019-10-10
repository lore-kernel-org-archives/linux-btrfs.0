Return-Path: <SRS0=z0ck=YD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA914C4360C
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 15:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8079206A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 15:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbfJJPGv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 11:06:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:53032 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfJJPGu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Oct 2019 11:06:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B40E0B039;
        Thu, 10 Oct 2019 15:06:49 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanups in mount path
Date:   Thu, 10 Oct 2019 18:06:44 +0300
Message-Id: <20191010150647.20940-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following the misunderstanding around the 2nd argument of free_root_pointers it
became apparent that the relevant code in open_ctre is not entirely clear. That's
mainly due it being split among 2 labels, emulating a loop. This series 
cleans that up by factoring it out in a discrete function, init_root_trees in 
patch 1 and then subsequent patches implement  minor cleanups that became 
apparent while working with the code. 

This has survived full xfstest run. 

Nikolay Borisov (3):
  btrfs: Factor out tree roots initialization during mount
  btrfs: Don't use objectid_mutex during mount
  btrfs: Jump to correct label on init_root_trees failure

 fs/btrfs/disk-io.c | 138 +++++++++++++++++++++++++--------------------
 1 file changed, 78 insertions(+), 60 deletions(-)

-- 
2.17.1

