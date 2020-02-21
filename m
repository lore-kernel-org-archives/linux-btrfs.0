Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AF7C35647
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 11:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC7E24672
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582283105;
	bh=ijiD+El6vHjfgIkG5vQ9jbeamFo0VbLm+45gjLRsk3o=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=iYQZIunCYg7Q4/khZgbPNaAjBB/C6IVS3H5Fu7Q0VE2bNCO6HBrTLOA8XyCT1jSaL
	 rjafHcA4e+tAZ3bUtTmtNbcwPPGwgXus+U1TiPGzVhUY7vrN2apmGe7a5LsFBEl6xQ
	 HC/lNPyuqYQGrfth5/q9QDkZUQ2nbKFCPwwZU0mw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgBULFE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 06:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgBULFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 06:05:04 -0500
Received: from debian5.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474492073A;
        Fri, 21 Feb 2020 11:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582283104;
        bh=ijiD+El6vHjfgIkG5vQ9jbeamFo0VbLm+45gjLRsk3o=;
        h=From:To:Cc:Subject:Date:From;
        b=roGAahRTLWrnds6uvA1dLuw05dxshIB3k2oUTgtJfMYIa6HuMbYZJwrLq4xPfrQLO
         sDrIb0JNOQvzlpdF1qhmlgqi4VNlF6PUvVBI33dYbzokTydxhpQL916kEwhOm4NanX
         9Bx23xghLffbUUy/MNj29CYx78nlTvjVpkR6SsE0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2 0/3] Add full support for cloning inline extents
Date:   Fri, 21 Feb 2020 11:04:51 +0000
Message-Id: <20200221110450.2636543-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This patchset adds support for currently unsupported cases of reflink
operations that cover a file range that has inline extents, more details
on why/how in patch 4/4.

It also starts by moving all the reflink code out of ioctl.c into a new
file named reflink.c (like xfs does) since this code is quite significant
in size and has grown over the years.

V2: Removed third patch from the previous patchset version. Since the full
    page ends up getting written, it's not necessary to read it before
    writing to it in case it's not uptodate. The final patch, which is
    now patch number 3, ends up being simpler as well.

Filipe Manana (3):
  Btrfs: move all reflink implementation code into its own file
  Btrfs: simplify inline extent handling when doing reflinks
  Btrfs: implement full reflink support for inline extents

 fs/btrfs/Makefile  |   2 +-
 fs/btrfs/ctree.h   |   2 +
 fs/btrfs/ioctl.c   | 733 ------------------------------------------
 fs/btrfs/reflink.c | 783 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 786 insertions(+), 734 deletions(-)
 create mode 100644 fs/btrfs/reflink.c

-- 
2.25.0

