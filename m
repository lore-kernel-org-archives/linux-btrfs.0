Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ED0C433F5
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Apr 2022 07:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiDQHdc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Apr 2022 03:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiDQHdc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Apr 2022 03:33:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497DE19C05
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2022 00:30:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E5F381F37E
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2022 07:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650180655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=izyfywUx9PjRwflywgS7ZyJNZI9FIAAwliLONnHBw3w=;
        b=VKMDI1W9FUEbbMlJNBGRLefkMu+WkrOO3NlK8J9R914bI8nTZqUTYBhoAcJ7wBMi8a1EPV
        o64xzmywM3YxIb8I8N4TzNMTBkTQxr97vP1/xBXVL8aLhYX5esvZgo1ZHiO+NkA6Xp6pQr
        wkeUI3UfY8ysMMObGEAoHVW1qaWCwHA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A16013ACB
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2022 07:30:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id X65+GC7CW2JvVAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2022 07:30:54 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: fsck: fix false warning on sprouted filesystems
Date:   Sun, 17 Apr 2022 15:30:34 +0800
Message-Id: <cover.1650180472.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

During my attempt to utilize seed device at mkfs time, I found there
there is a small bug that btrfs check always reports devices size
related warning on the sprouted device.

It turns out we didn't iterate seed devices at all during btrfs check.

The first patch will fix the problem and enhance the warning output.
The second one will add a regression test for it.

Qu Wenruo (2):
  btrfs-progs: check: fix wrong total bytes check for seed device
  btrfs-progs: fsck-tests: check warning for seed and sprouted
    filesystems

 check/main.c                                  | 18 ++++---
 .../fsck-tests/057-seed-false-alerts/test.sh  | 51 +++++++++++++++++++
 2 files changed, 63 insertions(+), 6 deletions(-)
 create mode 100755 tests/fsck-tests/057-seed-false-alerts/test.sh

-- 
2.35.1

