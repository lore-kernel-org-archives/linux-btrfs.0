Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51168 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2JQNx7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 09:53:59 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so5097142lbo.19
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 06:53:58 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Oct 2012 15:53:58 +0200
Message-ID: <CAOcd+r1qVe4C84LOxEnfMJzVtZx-yEDic2bWyVwqYuMyaDNnXA@mail.gmail.com>
Subject: [PATCH] btrfs-progs: Receive: preserve ownership for symlinks, by
 using 'lchown'
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, chris.mason@fusionio.com,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>

diff --git a/cmds-receive.c b/cmds-receive.c
index 6b7cf12..a6a6a5b 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -731,7 +731,7 @@ static int process_chown(const char *path, u64
uid, u64 gid, void *user)
 		fprintf(stderr, "chown %s - uid=%llu, gid=%llu\n", path,
 				uid, gid);

-	ret = chown(full_path, uid, gid);
+	ret = lchown(full_path, uid, gid);
 	if (ret < 0) {
 		ret = -errno;
 		fprintf(stderr, "ERROR: chown %s failed. %s\n",
