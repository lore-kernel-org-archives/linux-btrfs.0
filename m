From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: check slash in deleting subvolumes.
Date: Thu, 24 Dec 2009 12:04:20 +0900
Message-ID: <4B32DA34.7030101@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

For now, btrfsctl does not check whether subvolume name contains slash
or not. If someone specify subvolume with trailing slash (in case
using shell completion), ioctl returns with EINVAL and this error
may confuse some careless users like me. So, this patch adds check
slashes in subvolume name in deletion same as snapshot/subvolume
creating. But considering shell completion, this fix allows trailing
slash.

Regards,
taruisi

Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 btrfsctl.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/btrfsctl.c
===================================================================
--- a/btrfsctl.c	2009-12-24 11:40:15.000000000 +0900
+++ b/btrfsctl.c	2009-12-24 11:38:51.000000000 +0900
@@ -266,6 +266,7 @@ int main(int ac, char **av)
 	unsigned long command = 0;
 	int len;
 	char *fullpath;
+	char *pos;

 	if (ac == 2 && strcmp(av[1], "-a") == 0) {
 		fprintf(stderr, "Scanning for Btrfs filesystems\n");
@@ -332,6 +333,16 @@ int main(int ac, char **av)
 			command = BTRFS_IOC_SNAP_DESTROY;
 			name = av[i + 1];
 			len = strlen(name);
+			pos = strchr(name, '/');
+			if (pos) {
+				if (*(pos + 1) == '\0')
+					*(pos) = '\0';
+				else {
+					fprintf(stderr,
+						"error: / not allowed in names\n");
+					exit(1);
+				}
+			}
 			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
 				fprintf(stderr, "-D size too long\n");
 				exit(1);

