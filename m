Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C92C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 12:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A34A42084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 12:26:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A34A42084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbeJETYs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 15:24:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:57950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727558AbeJETYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 15:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F411AF01
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2018 12:26:18 +0000 (UTC)
Date:   Fri, 5 Oct 2018 07:26:15 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Remove unused variable mode in btrfs_mount
Message-ID: <20181005122615.da52bp6a6ie4jzzw@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Code cleanup.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e7f702761cb7..f7b8b7a6b86a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1661,14 +1661,10 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 {
 	struct vfsmount *mnt_root;
 	struct dentry *root;
-	fmode_t mode = FMODE_READ;
 	char *subvol_name = NULL;
 	u64 subvol_objectid = 0;
 	int error = 0;
 
-	if (!(flags & SB_RDONLY))
-		mode |= FMODE_WRITE;
-
 	error = btrfs_parse_subvol_options(data, &subvol_name,
 					&subvol_objectid);
 	if (error) {

-- 
Goldwyn
