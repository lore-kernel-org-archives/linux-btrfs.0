Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5C1C7618E
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Apr 2023 15:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjDUPVp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 11:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjDUPVo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2023 11:21:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6CF126;
        Fri, 21 Apr 2023 08:21:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 015C61FDDC;
        Fri, 21 Apr 2023 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1682090502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bdiIvQPwKmYoGHMpDHx6EM7WPu+/IERO4BhzE+MyWl4=;
        b=lzEMZVy25bS0Kv5H2ArHMqkQlkMGvS2C6Os7GX1bgx5qYDlGMSC0KTCsj/IsacnhiEmKOp
        lfP2CSjsftmHYWbfk9P2/h7Nn7i5slOM7MGZcnefIu7kD54n6VOWP3H5ciFzs9qDegsc85
        oZH9jXW5AtmZ49CLzK4HGIwq2UD9Ypc=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id DD8DE2C141;
        Fri, 21 Apr 2023 15:21:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 42ED9DAB4F; Fri, 21 Apr 2023 17:21:32 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     torvalds@linux-foundation.org
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: [GIT PULL] Btrfs fixes for 6.3-rc8
Date:   Fri, 21 Apr 2023 17:21:31 +0200
Message-Id: <cover.1682088075.git.dsterba@suse.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

two patches fixing the problem with aync discard. The default settings
had a low IOPS limit and processing a large batch to discard would take
a long time. On laptops this can cause increased power consumption due
to disk activity. As async discard has been on by default since 6.2 this
likely affects a lot of users.

Please pull, thanks.

- increase the default IOPS limit 10x which reportedly helped

- setting the sysfs IOPS value to 0 now does not throttle anymore
  allowing the discards to be processed at full speed, previously there
  was an arbitrary 6 hour target for processing the pending batch

----------------------------------------------------------------
The following changes since commit 68d99ab0e9221ef54506f827576c5a914680eeaf:

  btrfs: fix fast csum implementation detection (2023-04-06 16:34:13 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-6.3-rc7-tag

for you to fetch changes up to ef9cddfe57d86aac6b509b550136395669159b30:

  btrfs: reinterpret async discard iops_limit=0 as no delay (2023-04-21 00:28:23 +0200)

----------------------------------------------------------------
Boris Burkov (2):
      btrfs: set default discard iops_limit to 1000
      btrfs: reinterpret async discard iops_limit=0 as no delay

 fs/btrfs/discard.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)
