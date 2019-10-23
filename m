Return-Path: <SRS0=avBk=YQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFADCA9EB9
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 22:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858F120679
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 22:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571871231;
	bh=3lmGO28fmMb7jKPSDKtwrupwbX0i0o41QIcI16F92NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
	 References:List-ID:From;
	b=h7LKudok2f7c06GfXznW/jKLjb6HawzvSsWNb3/m86fgiM4H5XdCzXEWf3tZqPI0R
	 rGuqqImElAzYZvX+plX+it0+QcH4Xj0ZzmiZEH8MB3aDgdHC1+mWXyU6Rj37nx0qac
	 mRy4CXIKrbWgpr29xvl5JV3uqoUrUFDWSnkPwtK4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436959AbfJWWxt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 18:53:49 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44124 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436955AbfJWWxp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Oct 2019 18:53:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id u22so21478218qkk.11
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2019 15:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XO4Ox7XwanpnSyySncP2wM4YQIRvjcojjj71WaQ79eY=;
        b=eMRYehiwYEpp6oyoThxq2h85dmPTCTYC9ueCsorNt5Ce+RngTGcZm1GdQLcieZiciV
         5CQC5uaARnVfi8S4lWCwixhtYqGaLHLYrQRLZINNeSbhLPYfWzvcIw3Ky4fQOOjUd2gJ
         tFteHbWLwRi3wLq84Go/PmMsn2YZKOIPL0bfRDxr7zNNXOEXxwilmEL9LWOlwATKqQuN
         O1715CgfMlY6BasHnhCGSpEwXSDPVOQWhZKnImlUUoJrFQYtS/Y5Ghv3wAQVZoZJ13hH
         UcV56wdizo9uQ9fXQMOlHc8OoHqhS7tjgbU1LQjWsXbutPBrCDYeBuTv96YIacyG/9za
         kNpg==
X-Gm-Message-State: APjAAAUDjESGllzXWWRwK5itDgusS/3tc6J3OD72XoasAc7R3SUQ0Nye
        uQG8j5tzvEHod7Fp6eE4tdr+XbH0
X-Google-Smtp-Source: APXvYqyGaIsb7JhjYnq/5q/oqBZgqNK3bWm0Q4Kze5UdUrxZti49LktidxKbRMZCcqm4i15CIUsSdw==
X-Received: by 2002:ae9:f108:: with SMTP id k8mr10148090qkg.78.1571871224781;
        Wed, 23 Oct 2019 15:53:44 -0700 (PDT)
Received: from dennisz-mbp.thefacebook.com ([163.114.130.128])
        by smtp.gmail.com with ESMTPSA id j4sm11767542qkf.116.2019.10.23.15.53.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 15:53:44 -0700 (PDT)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 22/22] btrfs: make smaller extents more likely to go into bitmaps
Date:   Wed, 23 Oct 2019 18:53:16 -0400
Message-Id: <8f693ad39ca51e6fa80b78647c2df6f769593da8.1571865775.git.dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <cover.1571865774.git.dennis@kernel.org>
References: <cover.1571865774.git.dennis@kernel.org>
In-Reply-To: <cover.1571865774.git.dennis@kernel.org>
References: <cover.1571865774.git.dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It's less than ideal for small extents to eat into our extent budget, so
force extents <= 32KB into the bitmaps save for the first handful.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/free-space-cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4a769003414c..940e40c1712d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2104,8 +2104,8 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 		 * of cache left then go ahead an dadd them, no sense in adding
 		 * the overhead of a bitmap if we don't have to.
 		 */
-		if (info->bytes <= fs_info->sectorsize * 4) {
-			if (ctl->free_extents * 2 <= ctl->extents_thresh)
+		if (info->bytes <= fs_info->sectorsize * 8) {
+			if (ctl->free_extents * 3 <= ctl->extents_thresh)
 				return false;
 		} else {
 			return false;
-- 
2.17.1

