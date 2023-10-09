Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14359E95A8E
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Oct 2023 03:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345027AbjJIDeg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 8 Oct 2023 23:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbjJIDef (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2023 23:34:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA50BA3
        for <linux-btrfs@vger.kernel.org>; Sun,  8 Oct 2023 20:34:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 164E01F390
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Oct 2023 03:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1696822470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=bl1azLppfu822aps1BzMOLLN4zYEgFmUFIKg3bBLRXc=;
        b=Ts839/hOvQKVTUtdPtEbwnz0XsZeqoyf1Ywq93mdTdKUOL2bDWRznJuCLOJqiWVnrvYbLm
        jWVyUxWBCiTfQTAV3h7/S5q4DyY3wYmk0yuQqrp5vAWkSwaxnD+DGTu5G6TO6waluvqi6U
        pi/mrKDReabpJ3byyOBmGOK6Sg9ivOE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D65B8138F1
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Oct 2023 03:34:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yKqYHcR0I2X8PQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Oct 2023 03:34:28 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: make sure "mkfs --rootdir" copies the xattr for the rootdir
Date:   Mon,  9 Oct 2023 14:04:07 +1030
Message-ID: <cover.1696822345.git.wqu@suse.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We got a bug report that "mkfs.btrfs --rootdir" copies all the xattr but
the xattr of the source directory.

It turns out that we only do the regular xattr copy for all the child
inodes, not the source directory itself.

Fix it and create a test case for it.

Qu Wenruo (2):
  btrfs-progs: mkfs/rootdir: add the missing xattr for the rootdir inode
  btrfs-progs: tests/mkfs: make sure rootdir got its xattr copied

 mkfs/rootdir.c                             |  8 +++++
 tests/mkfs-tests/027-rootdir-xattr/test.sh | 40 ++++++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100755 tests/mkfs-tests/027-rootdir-xattr/test.sh

--
2.42.0

