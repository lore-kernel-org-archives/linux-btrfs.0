From: Prasad Joshi <prasadjoshi124@gmail.com>
Subject: [PATCH] btrfs-progs: Corrected return values from btrfsctl.c
Date: Sat, 17 Oct 2009 14:52:19 +0530
Message-ID: <fe291c8c0910170222l55e8794fr7ff23f80a2cd835a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfsctl.c should return 0 if ioctl succeeds

Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
---
diff --git a/btrfsctl.c b/btrfsctl.c
index 66c4e89..d602fc4 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -232,8 +232,8 @@ int main(int ac, char **av)
        }
        printf("%s\n", BTRFS_BUILD_VERSION);
        if (ret)
-               exit(0);
-       else
                exit(1);
+       else
+               exit(0);
 }
--
v0.19-3
