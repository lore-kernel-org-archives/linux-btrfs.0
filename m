Return-Path: <SRS0=z0ck=YD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29090C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 14:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06B7621835
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 14:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfJJOsn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 10:48:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:38094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfJJOsn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Oct 2019 10:48:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B8EBACD7;
        Thu, 10 Oct 2019 14:48:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 47200DA7E3; Thu, 10 Oct 2019 16:48:55 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 5.4-rc3
Date:   Thu, 10 Oct 2019 16:48:51 +0200
Message-Id: <cover.1570718349.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

a few more stabitly fixes, one build warning fix.

Changes:

- fix inode allocation under NOFS context

- fix leak in fiemap due to concurrent append writes

- fix log-root tree updates

- fix balance convert of single profile on 32bit architectures

- silence false positive warning on old GCCs (code moved in rc1)

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit d4e204948fe3e0dc8e1fbf3f8f3290c9c2823be3:

  btrfs: qgroup: Fix reserved data space leak if we have multiple reserve calls (2019-09-27 15:24:34 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-5.4-rc2-tag

for you to fetch changes up to 431d39887d6273d6d84edf3c2eab09f4200e788a:

  btrfs: silence maybe-uninitialized warning in clone_range (2019-10-08 13:14:55 +0200)

----------------------------------------------------------------
Austin Kim (1):
      btrfs: silence maybe-uninitialized warning in clone_range

Filipe Manana (1):
      Btrfs: fix memory leak due to concurrent append writes with fiemap

Josef Bacik (3):
      btrfs: fix incorrect updating of log root tree
      btrfs: allocate new inode in NOFS context
      btrfs: fix uninitialized ret in ref-verify

Zygo Blaxell (1):
      btrfs: fix balance convert to single on 32-bit host CPUs

 fs/btrfs/file.c       | 13 ++++++++++++-
 fs/btrfs/inode.c      |  3 +++
 fs/btrfs/ref-verify.c |  2 +-
 fs/btrfs/send.c       |  2 +-
 fs/btrfs/tree-log.c   | 36 +++++++++++++++++++++++++++---------
 fs/btrfs/volumes.c    |  6 +++++-
 6 files changed, 49 insertions(+), 13 deletions(-)
