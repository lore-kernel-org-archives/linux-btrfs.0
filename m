Return-Path: <SRS0=dRQQ=6M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FF7C83001
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 495A8205C9
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgD1PLL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:11:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:56162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgD1PLL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Apr 2020 11:11:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE4AAAF82;
        Tue, 28 Apr 2020 15:11:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5F251DA8C9; Tue, 28 Apr 2020 17:10:25 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Update errno messages
Date:   Tue, 28 Apr 2020 17:10:25 +0200
Message-Id: <cover.1588086487.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a errno -> string decoder that's used to print verbose messages,
some of the codes that can be found in the wild have been missing in the
table.

David Sterba (2):
  btrfs: sort error decoder entries
  btrfs: add more codes to decoder table

 fs/btrfs/super.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.25.0

