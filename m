Return-Path: <SRS0=15Oe=Z7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5365AC43603
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 17:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36E88207FD
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Dec 2019 17:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLIRb2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Dec 2019 12:31:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:37012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbfLIRb2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Dec 2019 12:31:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B497BABB1;
        Mon,  9 Dec 2019 17:31:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A9504DA783; Mon,  9 Dec 2019 18:31:18 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs kconfig update for 5.5-rc2
Date:   Mon,  9 Dec 2019 18:31:12 +0100
Message-Id: <cover.1575911345.git.dsterba@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

this is a separate pull request based on 5.5-rc1 that adds config
dependency integrating the crypto code and btrfs support for blake2b
(added in this dev cycle, via different trees). Without it the option
has to be selected manually. Please pull, thanks.

The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.5-rc1-kconfig

for you to fetch changes up to 78f926f72e43e4b974f69688593a9b682089e82a:

  btrfs: add Kconfig dependency for BLAKE2B (2019-12-09 17:56:06 +0100)

----------------------------------------------------------------
David Sterba (1):
      btrfs: add Kconfig dependency for BLAKE2B

 fs/btrfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)
