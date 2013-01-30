Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51198 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3Idl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 03:33:41 -0500
Message-ID: <5108DAAB.10401@oracle.com>
Date: Wed, 30 Jan 2013 16:32:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH v2 1/2] btrfs-progs: refactor check_label()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Refactor check_label().

- Make it be static at first, this is a preparation step since we'll remove
btrfslabel.[c|h] and move those functions from there to utils.[c|h], we can
do pre-checking against the input label string with it.
- Fix the label length check up from BTRFS_LABEL_SIZE to BTRFS_LABEL_SIZE - 1.
- Kill the check of label contains an invalid character, see below commits for detail:
  79e0e445fc2365e47fc7f060d5a4445d37e184b8
  btrfs-progs: kill check for /'s in labels.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
CC: Gene Czarcinski <gene@czarc.net>

---
 utils.c |   14 ++++----------
 utils.h |    1 -
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/utils.c b/utils.c
index d59bca3..9dc688a 100644
--- a/utils.c
+++ b/utils.c
@@ -1120,23 +1120,17 @@ char *pretty_sizes(u64 size)
  * Returns:
        0    if everything is safe and usable
       -1    if the label is too long
-      -2    if the label contains an invalid character
  */
-int check_label(char *input)
+static int check_label(const char *input)
 {
-       int i;
        int len = strlen(input);
 
-       if (len > BTRFS_LABEL_SIZE) {
+       if (len > BTRFS_LABEL_SIZE - 1) {
+		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
+			input, BTRFS_LABEL_SIZE - 1);
                return -1;
        }
 
-       for (i = 0; i < len; i++) {
-               if (input[i] == '/' || input[i] == '\\') {
-                       return -2;
-               }
-       }
-
        return 0;
 }
 
diff --git a/utils.h b/utils.h
index 8750f28..a0b782b 100644
--- a/utils.h
+++ b/utils.h
@@ -42,7 +42,6 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
-int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
-- 
1.7.9.5
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
