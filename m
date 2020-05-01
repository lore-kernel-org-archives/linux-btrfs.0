Return-Path: <SRS0=UUkT=6P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0E4C47254
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 23:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6365208DB
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 23:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588376665;
	bh=HsGz60nfWw6vsHt4t5wHnBYIijGvDBsVNptCbEJHGcU=;
	h=From:To:Subject:Date:List-ID:From;
	b=xAlnc4WJd6YV9mcH2RIPtx34PP3zmic4AKU+mPaINqgIgzxpjoxzJh/WpVWYHrRu3
	 FaVo2KvZG1Z8AvOU/ZCGuv5QN+y66WyAlEWPhHquqmoCMgkymAxbam+dZvTp+Ydog/
	 ZA1zCCtNk1Qny/AV90Q8P0hpEG5eWk1bwCTWgvrg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgEAXoZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 May 2020 19:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgEAXoY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 May 2020 19:44:24 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51BCC2184D
        for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2020 23:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588376664;
        bh=HsGz60nfWw6vsHt4t5wHnBYIijGvDBsVNptCbEJHGcU=;
        h=From:To:Subject:Date:From;
        b=zc66qp15uWnmebbeqAjed5Lp3SSZ3P8wwjHeuyXJCGsLdi+rWK7SxoUJHyI0wVoJS
         BB3TPSb4QZEtCGaiAvmfnnj7hWOfj/hMeQF7GB2yVPFcEW2riNd0/8f/uqXXlYTXde
         0OgMlAvvMGZOsnOARy7U22dkwjCQKZMnAPT48ptI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] MAINTAINERS: btrfs: fix git repo URL
Date:   Fri,  1 May 2020 16:44:17 -0700
Message-Id: <20200501234417.52402-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The git repo listed for btrfs hasn't been updated in over a year.
List the current one instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9271068bde639b..1afa64544a8c6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3653,7 +3653,7 @@ M:	David Sterba <dsterba@suse.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
 Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.rst
 F:	fs/btrfs/
-- 
2.26.2

