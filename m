Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49908 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755999AbcLUHiw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 02:38:52 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/2] btrfs: btrfs_defrag_root() doesn't support any option
Date: Wed, 21 Dec 2016 15:42:07 +0800
Message-Id: <20161221074208.32597-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Both BTRFS_IOC_DEFRAG and BTRFS_IOC_DEFRAG_RANGE call the same
function- btrfs_ioctl_defrag(), however BTRFS_IOC_DEFRAG does
not support any argument, so check that and return not supported
if provided. This has valid impact at the user end, in the cli below
  btrfs filesystem defrag -clzo /btrfs
the -c option (or similarly other) is only applicable to the file
defrag, which is either provided in the argument or when used along
with the -r option, however as of now the above cli does not report
any error. This patch will fix it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7acbd2cf6192..bd1bb7fcea8a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2608,6 +2608,10 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			ret = -EPERM;
 			goto out;
 		}
+		if (argp) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
 		ret = btrfs_defrag_root(root);
 		if (ret)
 			goto out;
-- 
2.10.0

