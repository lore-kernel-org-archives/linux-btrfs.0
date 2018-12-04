Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6D6C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3EE9206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3EE9206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbeLDPMV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:12:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:59508 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726042AbeLDPMV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 10:12:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80642AE3E
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 15:12:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B5431DAC39; Tue,  4 Dec 2018 16:11:59 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fdmanana@suse.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Scrub allocations vs reclaim fix
Date:   Tue,  4 Dec 2018 16:11:54 +0100
Message-Id: <cover.1543935982.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've instrumented the scrub alloctions to check for the GFP_NOFS context
and whether the device_list_mutex is not held. This caught one
allocation, and I've used the instrumented code to verify that Filipe's
scrub/reclaim fix is correct.

There are some debugging helpers need that live in the generic code so
I'm posting only results. The patches are in branch dev/locks-not-held
in my devel repos.

David Sterba (2):
  btrfs: scrub: pass fs_info to scrub_setup_ctx
  btrfs: scrub: move scrub_setup_ctx allocation out of device_list_mutex

 fs/btrfs/scrub.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

-- 
2.19.1

