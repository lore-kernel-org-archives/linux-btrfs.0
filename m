From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs-map-logical: segfaults when no output file is given
Date: Mon, 14 Mar 2011 12:57:49 +0100
Message-ID: <1300103869-12180-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

when no output file is given, info_file stays NULL and the following
fprintf segfaults. Default to stdout.
---
 btrfs-map-logical.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..aa4b5b5 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -175,6 +175,7 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
+	info_file = stdout;
 	if (output_file) {
 		if (strcmp(output_file, "-") == 0) {
 			out_fd = 1;
-- 
1.7.3.4

