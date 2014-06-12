Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaFLFj4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 01:39:56 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5C5du1q006207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 01:39:56 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5C5dtML001107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 01:39:55 -0400
Message-ID: <53993D2E.8010400@redhat.com>
Date: Thu, 12 Jun 2014 00:39:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix use of uninit "ret" in end_extent_writepage()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If this condition in end_extent_writepage() is false:

	if (tree->ops && tree->ops->writepage_end_io_hook)

we will then test an uninitialized "ret" at:

	ret = ret < 0 ? ret : -EIO;

The test for ret is for the case where ->writepage_end_io_hook
failed, and we'd choose that ret as the error; but if
there is no ->writepage_end_io_hook, nothing sets ret.

Initializing ret to 0 should be sufficient; if
writepage_end_io_hook wasn't set, (!uptodate) means
non-zero err was passed in, so we choose -EIO in that case.

Signed-of-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. - feel free to double check that this is sufficient ;)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f25a909..20b73c4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2354,7 +2354,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
 	struct extent_io_tree *tree;
-	int ret;
+	int ret = 0;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 

