From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] btrfs: Null terminate string in scan device ioctl
Date: Fri,  3 Jun 2011 19:34:07 +0200
Message-ID: <1307122447-25062-1-git-send-email-mbroz@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_one_device() directly uses vol->name
without additional checks so in the case of unterminated
string in ioctl it can access memory outside
of btrfs_ioctl_vol_args struct.

Always terminate name string (as the same as other users
do already).

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9b2e7e5..2bb1a99 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1148,6 +1148,8 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	if (IS_ERR(vol))
 		return PTR_ERR(vol);
 
+	vol->name[BTRFS_PATH_NAME_MAX] = '\0';
+
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:
 		ret = btrfs_scan_one_device(vol->name, FMODE_READ,
-- 
1.7.5.3

