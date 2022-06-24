Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AFF1C43334
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jun 2022 08:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiFXIB2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 04:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXIB2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jun 2022 04:01:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608706B8C1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2022 01:01:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1B1F61F8D1;
        Fri, 24 Jun 2022 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656057686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=B+5xL5CVtEyyR2TAuLr6QfoLSMKaymOKnyl73DEF/2E=;
        b=OrkxPGT+n5Ifs0GXGuaaZhQm7jx3cdTxJZV7x7smFrvhgOTUpeEX/ZEvQ30+MO0+hDKRGO
        PTRdoi5yKYaEaV8LLm+iL97fydAYaE2XjyPT7onoNF8+eRHkDje/XM7jmOylFAwKmvgpRv
        6Y6tm7Jd+V2JQMQGhlwiGTQFzTuC8oU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D411713ACA;
        Fri, 24 Jun 2022 08:01:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id f+D+MFVvtWLmXAAAMHmgww
        (envelope-from <nborisov@suse.com>); Fri, 24 Jun 2022 08:01:25 +0000
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Cleanup 2 sysfs flags
Date:   Fri, 24 Jun 2022 11:01:21 +0300
Message-Id: <20220624080123.1521917-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This series removes MIXED_BACKREF/BIG_METADATA sysfs files. While discussing
flags with David it transpired that those 2 have been merged for quite some time
and practically all modern (created in the last 9 years) filesystem will have
them set. They are not opt-in so let's use this fact to simplify our list of
sysfs flags.

Nikolay Borisov (2):
  btrfs: remove MIXED_BACKREF sysfs file
  btrfs: remove BIG_METADATA syfs file

 fs/btrfs/sysfs.c | 4 ----
 1 file changed, 4 deletions(-)

--
2.25.1

