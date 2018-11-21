Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2FDC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A77DC21104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="OUz7eIz3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A77DC21104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbeKUNQr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:16:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35875 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbeKUNQr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:16:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id y6-v6so3201950plt.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 18:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o4bI2dtYrGOAUpbYMucH7yfA9XmsvLCuXCvEpdFsK7M=;
        b=OUz7eIz3RPAgFBe6iyTWlhqJq25rEkkQVokaXHn0D+mWM70F4kZjqQb2dqZy/lxugF
         jhXK2tF+Ck1TZMK7HFEXlfsxy+TYrcAmWieaccXdwSL7Rn/lJSscu65AEK9sYJEnMIuv
         UwDqVIhtaPMh3TtwSzBeCav8boZZdXg6u8utPUG5KK1OigOrSYuVqABYmkPOG5Sn+buN
         gSNVF45TxTIih6RiIxRZ/bxhwezWW73wNZ+THeTWJvvHHPspV16Yj1aTqvcM9DCusLYf
         VJ49Vs0dnuc3w3wqB4cS16AjH2DMrAVL99EkyUI3N5YgT60U+jdD5mmU4anM4SXCEwtH
         E1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o4bI2dtYrGOAUpbYMucH7yfA9XmsvLCuXCvEpdFsK7M=;
        b=lOMAOuWYBGuQm+XJbgHFG1P7SCzxKoh/4CnhbVSjybUa2EzGMPMymJPyPCZtvD5Qfx
         3/wVZ+bRd6m1ddTxtIr4akn1NEOFj9e75lZFCb1FlMqN2OON5BCBf6JV697oJPjIbDxf
         52BMoBhl78qdSr+uqTcFZu9eHTJVvuAAO7xNKKCoKraAqYyTCqfrYj7yLyInv+rpfkkC
         Q/h+x1nl+py92EbWC4oOC28nqMp0P+XGJLYccFicNMmKLWNBYWihJnXUO1rbi+HzY/Ao
         UPqbXUMRhiVIdfzef9cnNs1dWuhbxLjXvQcCxTwnK5mAAo99t1abRrewvOlKYrbeMEpI
         pt1Q==
X-Gm-Message-State: AA+aEWZOepWURjyZA9oHiwJYqwFeizQU88X1pEnLt7TfXcDkqK175ZzT
        w5UbWioUj4+zaJB66zdywAVL5g==
X-Google-Smtp-Source: AFSGD/We3KVL/NQp518ltKarCdUcQa3Qe0SZqlTIBGxQcTgQjhTgsXupL+rS4fNnjpR9PsQxYBpHfQ==
X-Received: by 2002:a63:df50:: with SMTP id h16mr4319304pgj.421.1542768264717;
        Tue, 20 Nov 2018 18:44:24 -0800 (PST)
Received: from fedora.fout.local (fs76eecbcd.tkyc008.ap.nuro.jp. [118.238.203.205])
        by smtp.gmail.com with ESMTPSA id l63-v6sm46356677pfb.75.2018.11.20.18.44.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Nov 2018 18:44:24 -0800 (PST)
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
Subject: [PATCH v1 2/4] ext4: fix race between llseek SEEK_END and write
Date:   Wed, 21 Nov 2018 11:43:58 +0900
Message-Id: <20181121024400.4346-3-devel@etsukata.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Implement individual lock for SEEK_END for ext4 which directly calls
generic_file_llseek_size().

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/ext4/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 69d65d49837b..6479f3066043 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -477,6 +477,16 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	default:
 		return generic_file_llseek_size(file, offset, whence,
 						maxbytes, i_size_read(inode));
+	case SEEK_END:
+		/*
+		 * protects against inode size race with write so that llseek
+		 * doesn't see inode size being updated in generic_perform_write
+		 */
+		inode_lock_shared(inode);
+		offset = generic_file_llseek_size(file, offset, whence,
+						  maxbytes, i_size_read(inode));
+		inode_unlock_shared(inode);
+		return offset;
 	case SEEK_HOLE:
 		inode_lock_shared(inode);
 		offset = iomap_seek_hole(inode, offset, &ext4_iomap_ops);
-- 
2.19.1

