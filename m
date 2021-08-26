Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D3AC432BE
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Aug 2021 06:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3969B610CA
	for <linux-btrfs@archiver.kernel.org>; Thu, 26 Aug 2021 06:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbhHZGl2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 02:41:28 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54336 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhHZGl1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Aug 2021 02:41:27 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EAA2D20163
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Aug 2021 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629960039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=uA7tHx0ogbbiZRjbL0HsI47OMYPVLfoZzs9SjB0N2Jw=;
        b=izaCGQGVrOMbliRm9JIzVbqSq7GxX+rbY2QeC80OQN3x9AXOcO539a3HhG9Cfe3scwjeYw
        cGW8XeUd0E8gaGt6Hd7zHiCs4sTnh5b+QEHkvtwilSo4GY9ePyvZ3fXMucDWifEjcYi8nM
        WVjjCPdyEAO2osd07mITow8Jc4xu9T4=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 1C49113895
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Aug 2021 06:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id s3tWMmY3J2E+cgAAGKfGzw
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Aug 2021 06:40:38 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: check: enhance the csum mismatch error message
Date:   Thu, 26 Aug 2021 14:40:33 +0800
Message-Id: <20210826064036.21660-1-wqu@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset will change the csum mismatch error message for data csum
mismatch, from the old almost meaningless output:

  [5/7] checking csums against data
  mirror 1 bytenr 13631488 csum 19 expected csum 152 <<<
  ERROR: errors found in csum tree

To a more human readable output:

  [5/7] checking csums against data
  mirror 1 bytenr 13631488 csum 0x13fec125 expected csum 0x98757625
  ERROR: errors found in csum tree

Qu Wenruo (3):
  btrfs-progs: move btrfs_format_csum() to common/utils.[ch]
  btrfs-progs: slightly enhance btrfs_format_csum()
  btrfs-progs: check: output proper csum values for --check-data-csum

 check/main.c            | 13 ++++++++++---
 common/utils.c          | 16 ++++++++++++++++
 common/utils.h          |  4 ++++
 kernel-shared/disk-io.c | 19 ++-----------------
 4 files changed, 32 insertions(+), 20 deletions(-)

-- 
2.32.0

