Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B6EC433EF
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Apr 2022 02:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbiDNCNf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 22:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiDNCNe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Apr 2022 22:13:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE8B49CB1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Apr 2022 19:11:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1491121123
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2022 02:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649902270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=2cED4GlBlf1GCv9m4iuPx6/wfq4cKetmOuDyl/vstXk=;
        b=GWsuyAuuL/qZFCHG5dYePyh+YZ0+GFL6dFLg8YkrcpGjTQeipEM+z7psIu+65OtBgDe3UX
        X+R5bGOKuOzPVJoZSKUM/TuKPUXNI3iv5AeV0ggExtrY003uLIptgk5UdSMe28jJdcsjy1
        XyqayorpLRQPkuYZ1Q1OIkRZ68NQC6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649902270;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=2cED4GlBlf1GCv9m4iuPx6/wfq4cKetmOuDyl/vstXk=;
        b=PLjyiP35vdYWbwY/Zi+lVOo2sr4ASbIeo8vSv0eJ2vWrbBASPysV+5WKm1J5QAIT17Pp4W
        oYCKDfqHOkc0w+AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6BFA2134D9
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2022 02:11:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JobiEb2CV2KGewAAMHmgww
        (envelope-from <rgoldwyn@suse.de>)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2022 02:11:09 +0000
Date:   Wed, 13 Apr 2022 21:11:07 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Do not pass compressed_bio to submit_compressed_bio()
Message-ID: <20220414020917.llk3mbnsp34bspyc@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Parameter struct compressed_bio is not used by the function
submit_compressed_bio(). Remove it.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/compression.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index be476f094300..8cd6bb1c142e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -425,7 +425,6 @@ static void end_compressed_bio_write(struct bio *bio)
 }
 
 static blk_status_t submit_compressed_bio(struct btrfs_fs_info *fs_info,
-					  struct compressed_bio *cb,
 					  struct bio *bio, int mirror_num)
 {
 	blk_status_t ret;
@@ -599,7 +598,7 @@ blk_status_t btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 					goto finish_cb;
 			}
 
-			ret = submit_compressed_bio(fs_info, cb, bio, 0);
+			ret = submit_compressed_bio(fs_info, bio, 0);
 			if (ret)
 				goto finish_cb;
 			bio = NULL;
@@ -941,7 +940,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 						  fs_info->sectorsize);
 			sums += fs_info->csum_size * nr_sectors;
 
-			ret = submit_compressed_bio(fs_info, cb, comp_bio, mirror_num);
+			ret = submit_compressed_bio(fs_info, comp_bio, mirror_num);
 			if (ret)
 				goto finish_cb;
 			comp_bio = NULL;
-- 
2.35.1
