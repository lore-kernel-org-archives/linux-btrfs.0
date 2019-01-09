Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D0AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4402420821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVbuHnMA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfAIB2U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34219 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729652AbfAIB1r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id j2so6042464wrw.1;
        Tue, 08 Jan 2019 17:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IZywItQ2oX/ZBjXbwHWNAbeG8HS0AjhKs6xoxmA33sY=;
        b=MVbuHnMA4TV1zIu2DJ2LKDBkaI0bLjX+Wjq1LClHRuI4FycM2v5cqfLn3pJmfoQ5/E
         bo7kKJm5RbS3ic3ruo/wydLD7Bsw2mqMPYo4W5rnxEAw1GFwK2OKcmkZIFLfTOpJh1fJ
         08BICt/etPXuJ2vaiQ3eLgnt/xn3LpLvqaCaHgdRqeL7k+lwIvrjx1J/wjGb6kaO1lMM
         +dQJ5vYnxf+qrXTbRGG1y2wgJUsSgHu9ttffr37vBaR/YdmJ0c0LlnERfo+60jS0c0Zs
         Emha7O4Od/mJKL2UfCezDUNxw6sex+Np1awMW3RmKw0zc/4tWkrGZppMY3w3WayZVF3d
         Pj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=IZywItQ2oX/ZBjXbwHWNAbeG8HS0AjhKs6xoxmA33sY=;
        b=Ez/yrhEI2Vl4wsDRZVA+s3DncBaI5UmVm9Y13Oqo1YPp3EqY8yxBdbIHRfuhfrg25+
         6yXHi57RB4KsKVtMAcY4c55sjqQ/N1TdUnbn+/7Gj7fAW0RES+Le6wBkMfISXvP9ba9b
         of/kIjm8wkb8eIq5D426Yg5irnKIVM+GN/sczEWR34jO3tHRTwCm8ia2dofqiDEXER36
         MCQVGWgFfsDRbKkbhXuecQNf+qj0BGEMHpcYz+uC7yvxX99mBzAFXsRSTbYVfjUnuA5x
         0iNjR5akBgiAeybJWmYbOyYUQH8KGmorxUdPg4inMqOydV3aIARPJN7HMfeWzAdGqhmi
         HjfA==
X-Gm-Message-State: AJcUuke7rqpNqeU+e8Oca3YQpTeDqRYqbhronM5Y3pHHWqGNIgaexCOE
        XMQm0BGLY105VvlJbZTMvKiLpzY2zRE=
X-Google-Smtp-Source: ALg8bN5lISVHkNlV1kKviRkIO36BMoVdptPwDNWf7kKDCpJVE0dN/XmqbSz/QbBYZj/JCp+3z15u7g==
X-Received: by 2002:adf:9dd2:: with SMTP id q18mr3129525wre.12.1546997265248;
        Tue, 08 Jan 2019 17:27:45 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:44 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 15/19] btrfs: allow writing compressed, encrypted, inline extents
Date:   Wed,  9 Jan 2019 01:26:57 +0000
Message-Id: <20190109012701.26441-15-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61481833f5e4..f8bc7174f7e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -219,6 +219,22 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 	if (compress_type != BTRFS_COMPRESS_NONE) {
 		struct page *cpage;
 		int i = 0;
+
+		if (enc_key) {
+			struct btrfs_file_extent_inline_enc *eienc;
+
+			eienc = (struct btrfs_file_extent_inline_enc *)ptr;
+
+			btrfs_set_file_extent_inline_enc_key_number(leaf,
+						eienc, enc_key->key_number);
+
+			write_eb_member(leaf, eienc,
+					struct btrfs_file_extent_inline_enc,
+					iv, iv);
+
+			ptr += sizeof(struct btrfs_file_extent_inline_enc);
+		}
+
 		while (compressed_size > 0) {
 			cpage = compressed_pages[i];
 			cur_size = min_t(unsigned long, compressed_size,
-- 
2.19.2

