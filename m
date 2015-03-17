Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39841 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932084AbbCQUiM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 16:38:12 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t2HKYEuB032555
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 13:38:12 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1t6tm688aw-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 13:38:12 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] Btrfs: just free dummy extent buffers
Date: Tue, 17 Mar 2015 16:38:01 -0400
Message-ID: <1426624683-3085-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1426624683-3085-1-git-send-email-jbacik@fb.com>
References: <1426624683-3085-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we fail during our sanity tests we could get NULL deref's because we unload
the module before the dummy extent buffers are free'd via RCU.  So check for
this case and just free the things directly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 29850d4..d13cead 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4968,6 +4968,12 @@ static int release_extent_buffer(struct extent_buffer *eb)
 
 		/* Should be safe to release our pages at this point */
 		btrfs_release_extent_buffer_page(eb);
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+		if (unlikely(test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags))) {
+			__free_extent_buffer(eb);
+			return 1;
+		}
+#endif
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
 		return 1;
 	}
-- 
1.8.3.1

