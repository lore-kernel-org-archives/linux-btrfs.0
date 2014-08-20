Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20331 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbaHTOtc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 10:49:32 -0400
Message-ID: <53F4B555.7060403@fb.com>
Date: Wed, 20 Aug 2014 10:48:53 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <miaox@cn.fujitsu.com>, <dsterba@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <lkp@01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Abhay Sachan <lkp.abhay@gmail.com>
Subject: [PATCH] Btrfs: fix filemap_flush call in btrfs_file_release
References: <20140816075233.GA26842@localhost> <20140819115820.GA21418@localhost> <20140819142348.GU1553@twin.jikos.cz> <53F36601.5020609@fb.com> <53F47E07.3080807@cn.fujitsu.com>
In-Reply-To: <53F47E07.3080807@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


We should only be flushing on close if the file was flagged as needing
it during truncate.  I broke this with my ordered data vs transaction
commit deadlock fix.

Thanks to Miao Xie for catching this.

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f15c13f..36861b7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1840,7 +1840,15 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->private_data)
 		btrfs_ioctl_trans_end(filp);
-	filemap_flush(inode->i_mapping);
+	/*
+	 * ordered_data_close is set by settattr when we are about to truncate
+	 * a file from a non-zero size to a zero size.  This tries to
+	 * flush down new bytes that may have been written if the
+	 * application were using truncate to replace a file in place.
+	 */
+	if (test_and_clear_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+			       &BTRFS_I(inode)->runtime_flags))
+			filemap_flush(inode->i_mapping);
 	return 0;
 }
 
