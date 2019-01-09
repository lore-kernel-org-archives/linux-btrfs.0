Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B231C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC24A20821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BA7yvTaw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfAIB2M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47044 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbfAIB1s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so5962317wrt.13;
        Tue, 08 Jan 2019 17:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+fxiSJPhdMuB3Qlg6jdQvJgtSVT/kM99QJbku0KX7FA=;
        b=BA7yvTawzFgwNTXvNLVAOqimwhpzaYZviswzvE8WZmiEdCnVncg+UXgUD3zOJFzu/z
         tUVol5JUgTantAEQI8IzL3ajhqWnhnWlEOZp1n8qx1DPeR7QKJitHHo+HkOHZLAsA1hs
         LRFDSWOlKWaA7qUQZ5WaJIPXTyF0SlQb7OWe3GhQuaey0rHKvEf7X2g5jiTyCTkU4uuA
         MiacS6E7r2JjNKNL/++Qu6vvBQXnLNrGLIIFzoYjyrHWXd5K3bFUj5eLDQBHzZJd2zMS
         ayfmuhUlBf1gAwPAyPVaSsWZCGK0awjBKkA1fVggUIqRe7FszKgtVk1y9xfF7IMnGomW
         9tJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+fxiSJPhdMuB3Qlg6jdQvJgtSVT/kM99QJbku0KX7FA=;
        b=rDRtr8/4Jo4pKWtvRWJvF/deU6YBr1SamgVAj0jWRJ27oGvy6Mh3AdXiQn4Wu49cw3
         c5Wlx3Yv0CnF65JkSM8pJtKXZ0JQXP2sn/HjAvrLCGImXBkyCw4BzuO8oziMOxdVYbEc
         1dmJeBtBONg+zks0KnezjeMEcTRxmIjaPXVSFrrJUHDpmzjLUgCvjnIRiBE11mN0Fe3C
         mlBj40LZ4oZfVxJPAQwcCTqEx0Qup5CQujde37T3Ab5NRnsqLw0UpRjGMB00kPakk+9j
         mJG8z5KZKSntNOc6pcU1fQ2slUHQK/eg+ka7lKukCw/vsgo6YFXNwnYRtseorbxzToLP
         DYkQ==
X-Gm-Message-State: AJcUukd+lml/M9BLqTnNEh9DjSPRcDTD52RQDst7vbgKsvKRB7EFqcH3
        akuR2kV8ulxjss7p3Frq+M0=
X-Google-Smtp-Source: ALg8bN6pbO5obcEP9u2t8EL47u0m02SBVEth+CuZymYuLKqM4GslC5VJ4PGPfa7mUkO9oVbL9aRKfQ==
X-Received: by 2002:adf:d089:: with SMTP id y9mr3173876wrh.22.1546997266546;
        Tue, 08 Jan 2019 17:27:46 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:46 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 16/19] btrfs: add encryption incompat flag to sysfs
Date:   Wed,  9 Jan 2019 01:26:58 +0000
Message-Id: <20190109012701.26441-16-mark@harmstone.com>
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
 fs/btrfs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..6bd70188ea62 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -191,6 +191,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extended_iref, EXTENDED_IREF);
 BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
+BTRFS_FEAT_ATTR_INCOMPAT(encryption, ENCRYPTION);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
@@ -205,6 +206,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(encryption),
 	NULL
 };
 
-- 
2.19.2

