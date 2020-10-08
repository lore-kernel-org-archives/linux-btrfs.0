Return-Path: <SRS0=iNTY=DP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED54AC43467
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Oct 2020 12:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8654B2184D
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Oct 2020 12:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JSqccFvN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgJHMYd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 08:24:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:59472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgJHMYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Oct 2020 08:24:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602159872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VsKiDOy15gk+0DatZwDQFDkl5zcquNNJJzJzvhaFqBE=;
        b=JSqccFvNAkkiI+c+JIUWbCIze9lkihauOGp+fPGM6Up2BnqsokfcUAZXV0mhHFf3r9J/LH
        h7cyasHBHbeud8kc8vip5RCOAa75vK3+x8ZWYTdAxswZVWao2dJHS2vVlDVe5Nuh8gP3Hd
        pY/gqvt2kquRf3F6XY4ONQDsssrI93A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 79784AF0F;
        Thu,  8 Oct 2020 12:24:32 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Small QOI fixes for transaction_kthread
Date:   Thu,  8 Oct 2020 15:24:26 +0300
Message-Id: <20201008122430.93433-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following 4 patches make transaction_kthread code slitghly more user friendly.
Namely, patch 1 convert from open-coded multiplicaiton by HZ to using
msecs_to_jiffies helper. Patch 2 relies on the observation that the running
transaction is obtained under trans_lock so an extra check can be removed.
Patch 3/4 could possibly be squashed into 1 but the net effect is that the code
is more intuitive when sleeping in case a lower interval than commit_trans has
elapsed.


This has survived full xfstest run.

Nikolay Borisov (4):
  btrfs: Use helpers to convert from seconds to jiffies in
    transaction_kthread
  btrfs: Remove redundant check
  btrfs: Record delta directly in transaction_kthread
  btrfs: Be smarter when sleeping in transaction_kthread

 fs/btrfs/disk-io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--
2.17.1

