Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50993 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaARAQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:16:18 -0500
Received: by mail-ee0-f53.google.com with SMTP id t10so2411573eei.12
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 16:16:17 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id 4sm30848872eed.14.2014.01.17.16.16.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 17 Jan 2014 16:16:17 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/5] btrfs: search_ioctl rejects unused setted values
Date: Sat, 18 Jan 2014 01:15:50 +0100
Message-Id: <1390004153-4228-3-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390004153-4228-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1390004153-4228-1-git-send-email-Gerhard@Heift.Name>

To prevent unexpectet values in the unused fields of the search key fail early.
Otherwise future extensions would break the behavior of the search if current
implementations in userspace set them to values other than zero.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index be4c780..919d928 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1947,6 +1947,9 @@ static noinline int search_ioctl(struct inode *inode,
 	if (buf_size < sizeof(struct btrfs_ioctl_search_header))
 		return -EOVERFLOW;
 
+	if (sk->unused || sk->unused1 | sk->unused2 | sk->unused3 | sk->unused4)
+		return -EINVAL;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
1.8.5.3

