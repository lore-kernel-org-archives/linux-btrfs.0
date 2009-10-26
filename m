From: David Nicol <davidnicol@gmail.com>
Subject: little fixme in btrfsctl.c [PATCH]
Date: Mon, 26 Oct 2009 15:06:32 -0500
Message-ID: <934f64a20910261306mfd60a3fvb8dcf92dc892cabd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

diff --git a/btrfsctl.c b/btrfsctl.c
index 66c4e89..3ab0c26 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -144,7 +144,7 @@ int main(int ac, char **av)
                        len = strlen(name);
                        if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
                                fprintf(stderr,
-                                    "snapshot name zero length or too long\n");
+                                    "subvolume name zero length or
too long\n");
                                exit(1);
                        }
                        if (strchr(name, '/')) {
