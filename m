Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD28C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D17FF2146F
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="L6mImjkx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D17FF2146F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbeKUNQ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:16:58 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32811 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeKUNQ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:16:57 -0500
Received: by mail-pl1-f196.google.com with SMTP id z23so3213978plo.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 18:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=roGZa/MKql6l9BK2xvgfzkfB6UbYkloVfkrOARQfiPM=;
        b=L6mImjkxHwhkz5MgjbWQs1Bdl5HixsFOnS+PVuyYdbb//OsZhhZL3QReo/ycJEvUXf
         52is2GuKGOF4FkREwDqE4dLAEaf66a5SgW3MVhue7Gz0B+oPs9REvOFLjsDwT8q8xeB4
         h8koNaszwHNTBxst9A9uMusjxsS6Emb+qVfUzut83SW3eAWCF+fwMvVEd9Sm/Yikw+9o
         61tnzlt+5LxImfOeqsUGw8476I/uY+B1uoIvY6N7pduX92/zlRR4k5PiBWLph7kBQWp8
         UuGm+OSk9AOw165scmoA6lELO1w9oqPnDQQhdDm63WH2cTJPptto9Sv5VcpdoBf9nU9O
         k8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=roGZa/MKql6l9BK2xvgfzkfB6UbYkloVfkrOARQfiPM=;
        b=A0F15rDUFxVmeW1p5mkV2x/0VFnhuG3GW7rzLM8mqWBial0CI4cqG9LeWqiXSkemHK
         jlPP19Keg9lT2Qrmz3Kr/kEpKPFVk4Y7y9cayB3+5YBZy48jFxya3riXqUnyFeQox5fM
         GGIkvUk8elM01RY9khubnqzDFZcFW9992ng2t1SSXGGUmJX8vBYr/rWa83wBAop2fs2n
         NHwRH4xbphZ1o7Tyb5LZ37oKn1cP4apVqCxXND2i9x/G3fNuBcsGBfDoHkym+1MfbeSs
         HDOAbl/PXQ0WTIFhdfdD4kaS8lDQX3OhbRsV3HBRTghOdQLSbmNYrTyyEa/sXU0xnLxV
         gFSQ==
X-Gm-Message-State: AGRZ1gJynfdv1UhRfLUAmUUurOq3USuHXpQFCn+YqQ+J2bg3D4EJQBFR
        B+ySxuDAClFfGMrfs5kvIRLobA==
X-Google-Smtp-Source: AJdET5c3PaB5bn7Jr0K2IjCIQuZpxqik+trbni3tBVgegGEJxUc4B/4QOTzlnS97VODoqDX5Y+Tb5w==
X-Received: by 2002:a62:2ad6:: with SMTP id q205-v6mr4857372pfq.152.1542768275274;
        Tue, 20 Nov 2018 18:44:35 -0800 (PST)
Received: from fedora.fout.local (fs76eecbcd.tkyc008.ap.nuro.jp. [118.238.203.205])
        by smtp.gmail.com with ESMTPSA id l63-v6sm46356677pfb.75.2018.11.20.18.44.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Nov 2018 18:44:34 -0800 (PST)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 4/4] overlayfs: fix race between llseek SEEK_END and write
Date:   Wed, 21 Nov 2018 11:44:00 +0900
Message-Id: <20181121024400.4346-5-devel@etsukata.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Implement individual lock for SEEK_END for overlayfs which directly calls
generic_file_llseek_size().

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/overlayfs/file.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24..57bc6538eea8 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -146,10 +146,27 @@ static int ovl_release(struct inode *inode, struct file *file)
 static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *realinode = ovl_inode_real(file_inode(file));
+	loff_t ret;
 
-	return generic_file_llseek_size(file, offset, whence,
-					realinode->i_sb->s_maxbytes,
-					i_size_read(realinode));
+	switch (whence) {
+	default:
+		return generic_file_llseek_size(file, offset, whence,
+						realinode->i_sb->s_maxbytes,
+						i_size_read(realinode));
+	case SEEK_END:
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		/*
+		 * protects against inode size race with write so that llseek
+		 * doesn't see inode size being updated in individual fs write
+		 */
+		inode_lock(realinode);
+		ret = generic_file_llseek_size(file, offset, whence,
+					       realinode->i_sb->s_maxbytes,
+					       i_size_read(realinode));
+		inode_unlock(realinode);
+		return ret;
+	}
 }
 
 static void ovl_file_accessed(struct file *file)
-- 
2.19.1

