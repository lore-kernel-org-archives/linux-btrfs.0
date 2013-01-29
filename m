Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51204 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3A2GZH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:25:07 -0500
Message-ID: <51076B0C.2060602@oracle.com>
Date: Tue, 29 Jan 2013 14:24:12 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 1/2] btrfs-progs: refactor check_label()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <51076B08.2040709@oracle.com>

Refactor check_label().

Make it be static at first, this is a preparation step since we'll remove
btrfslabel.[c|h] and move those functions at them to utils.[c|h], we can do
pre-checking against the input label string with it.

Also, fix the input lable length verfication from BTRFS_LABEL_SIZE to
BTRFS_LABEL_SIZE - 1.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
CC: Gene Czarcinski <gene@czarc.net>
---
 utils.c |    8 ++++++--
 utils.h |    1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index d59bca3..034da8f 100644
--- a/utils.c
+++ b/utils.c
@@ -1122,17 +1122,21 @@ char *pretty_sizes(u64 size)
       -1    if the label is too long
       -2    if the label contains an invalid character
  */
-int check_label(char *input)
+static int check_label(char *input)
 {
        int i;
        int len = strlen(input);
 
-       if (len > BTRFS_LABEL_SIZE) {
+       if (len > BTRFS_LABEL_SIZE - 1) {
+		fprintf(stderr, "ERROR: Label %s is too long (max %d)\n",
+			input, BTRFS_LABEL_SIZE - 1);
                return -1;
        }
 
        for (i = 0; i < len; i++) {
                if (input[i] == '/' || input[i] == '\\') {
+			fprintf(stderr, "ERROR: Label %s contains invalid "
+				"characters\n", input);
                        return -2;
                }
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
