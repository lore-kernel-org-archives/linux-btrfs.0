Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41034 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaA0N3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 08:29:02 -0500
Received: by mail-ee0-f41.google.com with SMTP id e49so2283719eek.28
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 05:29:01 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id o13sm42495353eex.19.2014.01.27.05.28.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 27 Jan 2014 05:28:58 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv2 2/6] btrfs: search_ioctl rejects unused setted values
Date: Mon, 27 Jan 2014 14:28:28 +0100
Message-Id: <1390829312-814-3-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

