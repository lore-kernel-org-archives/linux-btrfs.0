Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624B0C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Feb 2021 23:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A23B64FB1
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Feb 2021 23:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhBDXXE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:23:04 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56841 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229977AbhBDXXC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Feb 2021 18:23:02 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 0051A5C00D2;
        Thu,  4 Feb 2021 18:21:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 04 Feb 2021 18:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=SdbaCXnJC+aWW0sM5n35VGQ32G
        labIuSas0db7LSwc4=; b=qQGf2euu3ouRATkorGNKvSRpEU9QgzkT42fycAZNKF
        h4q0z5yeLBMwwgV3E08dOtsnUAVRbxkL8YAcEyURmFQEaPEiigN/sUN4grJYo+ck
        ezM3FrDud1tu4sOCQFLzYl3EEAKYKANx1PtSBplKUfpm0TBnmKCwZ90SC3o9IPst
        IjOxZLLh33MTnvc7ug8M1fscxnMhb2aDEhGRF27UheR8k+1HndCB6pP4rCHA8a8/
        hlQBJuxb/Y+e8LKMRnyBEhQLaPaqEpm4Yc5BDz11Wma9EQyh3AErKSMKL2yeVT5X
        vk23O9DWLPxWhDntr67ruNskoTpssw1WUMTsp4d0Ce/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=SdbaCXnJC+aWW0sM5n35VGQ32GlabIuSas0db7LSwc4=; b=FW+SpB7N
        aC+TFSExn4jCa7/O41A7t13VtjS3M/fh3k7PB/bJb5i/e0phfPbvmUxznVsKZkLS
        uxlKGVIe5alrCqiOG4aqTX/lB0o9bcWInJCUfcdoi88GoD9scvL5cs2+59iVGINy
        3T3ZbkfodnKLc4UNoT76FELNaAtagNOHI4ijF198itnaO+tXmDZUg3g9OizDOjUc
        qS4nHgm6blfBnvm5ZjiWL/ZYhMmpoXXL1esAk2x/d9J7jCOO1W+9Eux865h58xmM
        nVK3M/aVHq2MynXwf9jdhf8yk8ok5mheimuEXZR9OD8qZFxyJlSkF46a7DJGDjf4
        XGnjtxCLDJwYWA==
X-ME-Sender: <xms:lIEcYFQWa_AuTmxACIhjLuA4HTKV3zskt3FMq09tUVOvycvZKWxHCw>
    <xme:lIEcYDDvPKLbvkjjdx9IdNCD1TyaBkqD8s7luG06GgkEw34kwj1ik6IvEKUuRRTzN
    xWTGzYl3rmhgSAxHvU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeehgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeeiue
    ffuedvieeujefhheeigfekvedujeejjeffvedvhedtudefiefhkeegueehleenucfkphep
    udeifedruddugedrudefvddrfeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:lIEcYF3kwbT26Ih9FHTS56FuqwZNlCd0pRLtcMWzTqjlwtL75o7DZQ>
    <xmx:lIEcYBXTdGQ0ldizFdvvLCRpxvypXNFSzb3T7N_d7iDSM3hqAL-91A>
    <xmx:lIEcYHldUmGnNtqLmFxGvFiFPJ-919tPAQIC4fx2NhH4UxYgBqVRDg>
    <xmx:lIEcYLhk7QXJBNg0YrHDRYkHXLqaUP1IUtiEWhgd4AMSuv9-kz0t2Q>
Received: from localhost (unknown [163.114.132.3])
        by mail.messagingengine.com (Postfix) with ESMTPA id B5A6D108005B;
        Thu,  4 Feb 2021 18:21:56 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/5] btrfs: fallback to buffered io for verity files
Date:   Thu,  4 Feb 2021 15:21:40 -0800
Message-Id: <f98c66cb463b336adf6f9f6aff9fa7282a488052.1612475783.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1612475783.git.boris@bur.io>
References: <cover.1612475783.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Reading the contents with direct IO would circumvent verity checks, so
fallback to buffered reads. For what it's worth, this is how ext4
handles it as well.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 6c08bca09d62..a4a2c9c9fcf0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3621,6 +3621,9 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
+	if (fsverity_active(inode))
+		return 0;
+
 	if (check_direct_read(btrfs_sb(inode->i_sb), to, iocb->ki_pos))
 		return 0;
 
-- 
2.24.1

