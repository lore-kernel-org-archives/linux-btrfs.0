Return-Path: <SRS0=f83N=ZT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF68C432C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 03:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A24CB207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 03:46:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2lS68aQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfK0Dqq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 22:46:46 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:41949 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfK0Dqq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 22:46:46 -0500
Received: by mail-qv1-f66.google.com with SMTP id g18so8302002qvp.8
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2019 19:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ie1Mmq6bkhhGUodc+14AGNGGozOUuEPpYBIIbKdsrPM=;
        b=K2lS68aQbVyknx6XVM759mlEpa4OvQtsipK4i03VPtNiK/iO+I/MFFw+uNMXBwIgpq
         jE7YsSgng0wxflqYD9a1fnbNNiDIIpK+HVJktfEPv4arnNT+caFiXRwcQBlOurMnqfhm
         8dcpcGpB7meG0ZnSMCYYHxwLeryjjZ+A+Iv0uwPZxPQlSvsSV8PAXCOpWkoduq2nLRyp
         z8zkuN72TJWJNUDkkuMXKlHONnB5oFEFfb9pkyHcpPP8PSxBlO5FnW99ndEeIzBxdGHj
         uvGRSWlXVCY7eKzWfpZlX3CYNeWPccId/ozp0CPZpiBC7AVYEV94xFfjZT4gkds6DOYM
         2NPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ie1Mmq6bkhhGUodc+14AGNGGozOUuEPpYBIIbKdsrPM=;
        b=dzOhu7cdyOaodXD6POiGDYHXQU5MG3y5cczZv003GXJMKdESaTR6ZR35O5dN+DhxaF
         iYmjfQ3blQmxwckV2XDpgAE7vGTEycxbeMtpcvtWnYl+n8sZ3ZcXuLG+8u3Sv/mUQmpt
         dzOVlF6F+Nax48iOhjCp/XaZ5y4Jb9ptkKeUaQEfdmOYs0tew/e47eyX+mOLxOscF6/g
         MihKcsFOX7lBqLVTTZi6Q92CMpbvuheuXAjab1IrCPWH3JBeeeYkbdf1XOcHoDbTvPbw
         fQQJRHM9k0KU2h3R2tlTjGUJzrbuk5+cl+sBGgXtbcIBPeTu3Rdr7hz1TvWtOy+OqVax
         3WcA==
X-Gm-Message-State: APjAAAXoYQQHBk3Z0MekBn0tpQahQe/86d9WKsKhwz2o0HIW5fIL/OGb
        TY72QCsF+BfZUQKWxHnUQq8=
X-Google-Smtp-Source: APXvYqzXd8o9WEKsecp66q5EbRg7V4chYJC2eTI6rtlGOl3LqNa2qFOpp+WVkVW2frlSTWf0QC59MA==
X-Received: by 2002:a0c:e7c7:: with SMTP id c7mr2684253qvo.11.1574826405261;
        Tue, 26 Nov 2019 19:46:45 -0800 (PST)
Received: from hephaestus.prv.suse.net ([186.212.48.108])
        by smtp.gmail.com with ESMTPSA id m186sm6326787qkc.39.2019.11.26.19.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 19:46:44 -0800 (PST)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org,
        anand.jain@oracle.com, wqu@suse.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH] btrfs-progs: qgroup: Check for ENOTCONN error on create/assign/limit
Date:   Wed, 27 Nov 2019 00:48:51 -0300
Message-Id: <20191127034851.13482-1-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

Current btrfs code returns ENOTCONN when the user tries to create a
qgroup on a subvolume without quota enabled. In order to present a
meaningful message to the user, we now handle ENOTCONN showing
the message "quota not enabled".

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 This patch survived a full btrfs-progs tests run

 cmds/qgroup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/cmds/qgroup.c b/cmds/qgroup.c
index ba81052a..6bfb4949 100644
--- a/cmds/qgroup.c
+++ b/cmds/qgroup.c
@@ -98,7 +98,9 @@ static int _cmd_qgroup_assign(const struct cmd_struct *cmd, int assign,
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
 	if (ret < 0) {
-		error("unable to assign quota group: %m");
+		error("unable to assign quota group: %s",
+				errno == ENOTCONN ? "quota not enabled"
+						: strerror(errno));
 		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
@@ -152,8 +154,10 @@ static int _cmd_qgroup_create(int create, int argc, char **argv)
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_CREATE, &args);
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		error("unable to %s quota group: %m",
-			create ? "create":"destroy");
+		error("unable to %s quota group: %s",
+			create ? "create":"destroy",
+				errno == ENOTCONN ? "quota not enabled"
+						: strerror(errno));
 		return 1;
 	}
 	return 0;
@@ -447,7 +451,10 @@ static int cmd_qgroup_limit(const struct cmd_struct *cmd, int argc, char **argv)
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_LIMIT, &args);
 	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
-		error("unable to limit requested quota group: %m");
+		error("unable to limit requested quota group: %s",
+				errno == ENOTCONN ? "quota not enabled"
+						: strerror(errno));
+
 		return 1;
 	}
 	return 0;
-- 
2.23.0

