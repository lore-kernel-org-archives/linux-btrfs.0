Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F300CC4338F
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Aug 2021 16:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF09610CB
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Aug 2021 16:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhHRQnn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:43:43 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57726 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhHRQnm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Aug 2021 12:43:42 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9B0F42007E;
        Wed, 18 Aug 2021 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629304986; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=V+fK4Or0OG8CNKxNx0lyexklE+4+IBDmwYCcSkzG0x0=;
        b=lwRfV/KeJLg3RLHl2ejsNKRFznaOlZNU6MYezc5FmJf1atFI3KufeCRWtC4cvpJRBfoz3l
        9hWF6E0RioilTEQONbdl/flyAnerybAmZt5ueIyqriRuW+wRz30NTqRYIssaZFgnPiAAiP
        D9l02fGqqcbbE5xlFcA/sBqF/mAlqpg=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 93089A3B91;
        Wed, 18 Aug 2021 16:43:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 552FEDA72C; Wed, 18 Aug 2021 18:40:08 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for v5.14-rc7
Date:   Wed, 18 Aug 2021 18:40:07 +0200
Message-Id: <cover.1629303887.git.dsterba@suse.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

one more fix for cross-rename, adding a missing check for directory and
subvolume, this could lead to a crash.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 7280305eb57dd32735f795ed4ee679bf9854f9d0:

  btrfs: calculate number of eb pages properly in csum_tree_block (2021-07-29 13:01:04 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.14-rc6-tag

for you to fetch changes up to 3f79f6f6247c83f448c8026c3ee16d4636ef8d4f:

  btrfs: prevent rename2 from exchanging a subvol with a directory from different parents (2021-08-16 13:33:23 +0200)

----------------------------------------------------------------
NeilBrown (1):
      btrfs: prevent rename2 from exchanging a subvol with a directory from different parents

 fs/btrfs/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)
