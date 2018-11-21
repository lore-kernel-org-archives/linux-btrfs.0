Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE991C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A320A21104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="MctSODym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A320A21104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbeKUNQw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:16:52 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42895 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbeKUNQw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:16:52 -0500
Received: by mail-pl1-f193.google.com with SMTP id x21-v6so3191368pln.9
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 18:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S98AfvktK5ubznf+7tPpcMB3RtXLxMLR6IfafpV0zKk=;
        b=MctSODymScBuzbx1+dDPa9v56o9gD57nrquuXfOeQULzH/WJok3qX9EIWI+17fyejf
         YGsOHW4U2G6Yytw8c7Iv2R+VtTD5N5f/MwzSZNA9qEW+aSE6w4JPtK93hGbg0WrkRohl
         +onbDDlihN0knzxF/xksLrmLUBiY4tbJe9NYa5zVV9bV382Rrs8kPaXuged6X3RWPeQq
         qrYJYF46HStnFlSV6NZFg3j9MvOCqang4naUmtcFpb1D4+7khtbHqv9cQoCSuNyT4NYC
         NkSro/Q/8IQg9hVNLBwuR/FTr+us0+JiZEMDMV3YxifKQN5761JeTqE4KK8obgf0Ft2f
         q++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S98AfvktK5ubznf+7tPpcMB3RtXLxMLR6IfafpV0zKk=;
        b=Edm+qboyhPEtIBVAxC/fdytZt7gcwiFUF7J0imn+UaktUbh+65ZANk1qLaHnCiWUZE
         BBR3X+mOw/cdF9Y96mpbjJqSrsPxNHy/Hn6tJSE2EoWGCfGHjIjGFGO6hy10dn06yh3V
         +9dYcO2rZO+36+ymRdiUqfreB0W3c4xjRvrzY9bZKON0yUbnajzAW7yofJKRqS3dfM17
         k8CU40cszF6qV5SRWsH/7PvclE6vvDeOu58klfdBRhxLDNsbwj/rqeZ4y5oPgCx1tfnI
         OoM6x3tbgCP6Foop/cy3q41I8PEMi1vVLrq4HcrCe34zDNtxeoNEu+SJ9LLlF1l3OmyJ
         TClQ==
X-Gm-Message-State: AA+aEWaAGAjMwKbhWVINAi24RiWc83u/91kXOMipQyw7MXIfWv4M0HBz
        DHM3waMG/Cf4GR27hzk07NCnuw==
X-Google-Smtp-Source: AFSGD/XiiUFmvgYaucgphQWKiIX3V6pLpVlSIfA+n1TJa6RGP1bQ1zL6qQB1pi6O4YiOq/9A4vsZ/A==
X-Received: by 2002:a17:902:a70b:: with SMTP id w11mr4857981plq.84.1542768269956;
        Tue, 20 Nov 2018 18:44:29 -0800 (PST)
Received: from fedora.fout.local (fs76eecbcd.tkyc008.ap.nuro.jp. [118.238.203.205])
        by smtp.gmail.com with ESMTPSA id l63-v6sm46356677pfb.75.2018.11.20.18.44.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Nov 2018 18:44:29 -0800 (PST)
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
Subject: [PATCH v1 3/4] f2fs: fix race between llseek SEEK_END and write
Date:   Wed, 21 Nov 2018 11:43:59 +0900
Message-Id: <20181121024400.4346-4-devel@etsukata.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch itself seems to be just a cleanup but with the
commit b25bd1d9fd87 ("vfs: fix race between llseek SEEK_END and write")
it fixes race.

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/f2fs/file.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 88b124677189..14a923607eff 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -447,15 +447,11 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 
 static loff_t f2fs_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *inode = file->f_mapping->host;
-	loff_t maxbytes = inode->i_sb->s_maxbytes;
-
 	switch (whence) {
 	case SEEK_SET:
 	case SEEK_CUR:
 	case SEEK_END:
-		return generic_file_llseek_size(file, offset, whence,
-						maxbytes, i_size_read(inode));
+		return generic_file_llseek(file, offset, whence);
 	case SEEK_DATA:
 	case SEEK_HOLE:
 		if (offset < 0)
-- 
2.19.1

