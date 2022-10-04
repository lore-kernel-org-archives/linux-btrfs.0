Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022ECC433FE
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Oct 2022 07:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJDHoD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 03:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDHoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Oct 2022 03:44:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED5F41520
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Oct 2022 00:43:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BB38D219BD
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Oct 2022 07:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664869437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fE9SnVtF0FusBDMpN+53e2t8M4p39oE2j+OxyNE4AZ4=;
        b=EnTVIBEv59tMHFbKLxjCRZ0rGTpZumDKeRxJQWZYPeP+P9Szql9345HLdFAFaotF4hCXl/
        84DxfrMzkTEuVlHjeBReGhrMIFaYr62o/JosXMj/7D7EHITzVIrJPHQJTN/lNGKXJ/o5Tr
        /48wZslEjobn1QItEUYE1oB9uv8MSQA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 15505139EF
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Oct 2022 07:43:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CsWiMzzkO2PxOQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Oct 2022 07:43:56 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: mkfs: --rootdir related fixes
Date:   Tue,  4 Oct 2022 15:43:37 +0800
Message-Id: <cover.1664869157.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I don't know if it's recent kernel tmpfs change or something else, but
I'm consistently get ino number smaller than 256 from my /tmp directory.

This behavior change exposed a new problem in mkfs.btrfs --rootdir, that
if some ino number (in the source directory, not in btrfs) is smaller
than 256, it can screw up the backref code.

As backref code is utilizing @owner to determine if a backref is data or
metadata.

And inode number smaller than 256 will make backref code to treat a data
backref as tree backref, and cause corruption.

Thankfully this should not happen that easily, only when --rootdir
points to a newly created fs.

Qu Wenruo (2):
  btrfs-progs: properly initialized extent generation for
    __btrfs_record_file_extent()
  btrfs-progs: avoid fs corruption if rootdir contains ino smaller than
    BTRFS_FIRST_FREE_OBJECTID

 kernel-shared/extent-tree.c | 8 +++++++-
 mkfs/rootdir.c              | 8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.37.3

