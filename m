From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH 4/5] Test the additional ioctl.
Date: Mon, 25 Apr 2011 15:48:00 +0200
Message-ID: <1303739282-1675-5-git-send-email-philipp.andreas@gmail.com>
References: <1303733730-sup-9388@think>
 <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	chris.mason@oracle.com, dcrmorgado@gmail.com, lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 ioctl-test.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ioctl-test.c b/ioctl-test.c
index 7cf3bc2..1c27d61 100644
--- a/ioctl-test.c
+++ b/ioctl-test.c
@@ -22,6 +22,7 @@ unsigned long ioctls[] = {
 	BTRFS_IOC_INO_LOOKUP,
 	BTRFS_IOC_DEFAULT_SUBVOL,
 	BTRFS_IOC_SPACE_INFO,
+	BTRFS_IOC_SNAP_CREATE_V2,
 	0 };
 
 int main(int ac, char **av)
-- 
1.7.4.1

