Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3054C6377C
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 15:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90B336120E
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 15:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbhGTO7a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 10:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240241AbhGTOYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jul 2021 10:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F26760FDA
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jul 2021 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626793525;
        bh=PRwx6Lp7GxP7P0/m3KxyjhI8B47cmJ+6pEhisaZ4jP4=;
        h=From:To:Subject:Date:From;
        b=I4lWG0ybmqwMSQPs4TbtbUKBoRFDSa52s1z9YAwN8SIbXcnJctNFr+3JEekcXUMA7
         p/WKL0L1z7j14+0uvR9wI0hn+D2+R6M67vyMYXYQEz2mnrNn0Sm23zdzYiEuu4kRBG
         NB70fS3jNrQJcvNh0O6XD2ijyuf3yxEmjBrTpGubztlT936i8PC2TzXqR0gMvWVihu
         s/pFa3dNjc0VKlpg1rA/OAxCqFjJuOofs0iKpDIL5NK81+cDau3JwqD5yMchq3X9F5
         1G981MQqg/A2Av415+w576bEO/5ady8lIOD/5sr7KIgH1RsvmCYLrnnUi7m6r0QVsJ
         4nXxnyhGP2Kng==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: make the batch insertion of dir index keys more efficient
Date:   Tue, 20 Jul 2021 16:05:21 +0100
Message-Id: <cover.1626791739.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The first patch makes the batch insertion of dir index keys (delayed items)
more efficient. The second patch is a cleanup, but only applies cleanly after
the first patch.

Filipe Manana (2):
  btrfs: improve the batch insertion of delayed items
  btrfs: stop doing GFP_KERNEL memory allocations in the ref verify tool

 fs/btrfs/delayed-inode.c | 218 ++++++++++++++-------------------------
 fs/btrfs/ref-verify.c    |  10 +-
 2 files changed, 81 insertions(+), 147 deletions(-)

-- 
2.30.2

