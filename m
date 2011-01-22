From: Maximilian Mehnert <maximilian.mehnert@gmx.de>
Subject: [PATCH] Add -v option to btrfsctl to control verbosity: Be quiet
 unless requested.
Date: Sat, 22 Jan 2011 12:59:22 +0100
Message-ID: <4D3AC69A.2080302@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

---
  btrfsctl.c |   10 ++++++++--
  1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..156ed62 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -106,6 +106,7 @@ int main(int ac, char **av)
  	char *pos;
  	char *fullpath;
  	u64 objectid = 0;
+	int verbose = 0;
   	if (ac == 2 && strcmp(av[1], "-a") == 0) {
  		fprintf(stderr, "Scanning for Btrfs filesystems\n");
@@ -217,6 +218,9 @@ int main(int ac, char **av)
  				}
  			}
  		}
+		else if (strcmp(av[i], "-v") == 0) {
+			verbose = 1;
+		}
  	}
  	if (command == 0) {
  		fprintf(stderr, "no valid commands given\n");
@@ -254,11 +258,13 @@ int main(int ac, char **av)
  		exit(1);
  	}
  	if (ret == 0) {
-		printf("operation complete\n");
+		if (verbose) printf("operation complete\n");
  	} else {
  		printf("ioctl failed with error %d\n", ret);
  	}
-	printf("%s\n", BTRFS_BUILD_VERSION);
+	if (verbose) {
+		printf("%s\n", BTRFS_BUILD_VERSION);
+	}
  	if (ret)
  		exit(1);
  -- 1.7.2.3


