Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36328 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KRTcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 14:32:22 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A485F7C06A4
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2013 12:32:21 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Anand Jain <Anand.Jain@oracle.com>, Gene Czarcinski <gene@czarc.net>,
        <linux-btrfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>
References: <528787FB.4040100@czarc.net> <528978AF.3020806@oracle.com>
In-Reply-To: <528978AF.3020806@oracle.com>
Message-ID: <20131118193206.5312.78304@localhost.localdomain>
Subject: Re: btrfs fi show
Date: Mon, 18 Nov 2013 14:32:06 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Anand Jain (2013-11-17 21:17:19)
> There is a fix for this (which David has integrated into the branch
> recently). This also needs the kernel side patch which is listed below.
> 
> [PATCH v4 1/3] btrfs-progs: mechanism to fetch fsinfo from btrfs-control
> [PATCH v4 2/3] btrfs-progs: fs show should handle if subvol(s) mounted
> 
> [PATCH v2] btrfs: add framework to read fs info from btrfs-control

Anand's updated patches are a better way to solve this, but until we get
the kernel feature in, I'm about to commit this patch:

>From 5aff090a3951e7d787b32bb5c49adfec65091385 Mon Sep 17 00:00:00 2001
From: Chris Mason <chris.mason@fusionio.com>
Date: Mon, 18 Nov 2013 14:18:08 -0500
Subject: [PATCH] btrfs filesystem show: skip duplicate fsids

If a given filesystem is mounted more than once, btrfs fi show will
print dups.  This adds a quick and dirty hash table of fsids it
has already printed and makes sure we don't print any fsid more than
once.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
---
 cmds-filesystem.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index aa361d6..1c1926b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -38,6 +38,74 @@
 #include "commands.h"
 #include "list_sort.h"
 
+
+/*
+ * for btrfs fi show, we maintain a hash of fsids we've already printed.
+ * This way we don't print dups if a given FS is mounted more than once.
+ */
+#define SEEN_FSID_HASH_SIZE 256
+
+struct seen_fsid {
+	u8 fsid[BTRFS_FSID_SIZE];
+	struct seen_fsid *next;
+};
+
+static struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
+
+static int add_seen_fsid(u8 *fsid)
+{
+	u8 hash = fsid[0];
+	int slot = hash % SEEN_FSID_HASH_SIZE;
+	struct seen_fsid *seen = seen_fsid_hash[slot];
+	struct seen_fsid *alloc;
+
+	if (!seen)
+		goto insert;
+
+	while (1) {
+		if (memcmp(seen->fsid, fsid, BTRFS_FSID_SIZE) == 0)
+			return -EEXIST;
+
+		if (!seen->next)
+			break;
+
+		seen = seen->next;
+	}
+
+insert:
+
+	alloc = malloc(sizeof(*alloc));
+	if (!alloc)
+		return -ENOMEM;
+
+	alloc->next = NULL;
+	memcpy(alloc->fsid, fsid, BTRFS_FSID_SIZE);
+
+	if (seen)
+		seen->next = alloc;
+	else
+		seen_fsid_hash[slot] = alloc;
+
+	return 0;
+}
+
+static void free_seen_fsid(void)
+{
+	int slot;
+	struct seen_fsid *seen;
+	struct seen_fsid *next;
+
+	for (slot = 0; slot < SEEN_FSID_HASH_SIZE; slot++) {
+		seen = seen_fsid_hash[slot];
+		while (seen) {
+			next = seen->next;
+			free(seen);
+			seen = next;
+		}
+		seen_fsid_hash[slot] = NULL;
+	}
+}
+
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
 	NULL
@@ -224,6 +292,9 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	u64 devs_found = 0;
 	u64 total;
 
+	if (add_seen_fsid(fs_devices->fsid))
+		return;
+
 	uuid_unparse(fs_devices->fsid, uuidbuf);
 	device = list_entry(fs_devices->devices.next, struct btrfs_device,
 			    dev_list);
@@ -274,6 +345,13 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	int i;
 	char uuidbuf[37];
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
+	int ret;
+
+	ret = add_seen_fsid(fs_info->fsid);
+	if (ret == -EEXIST)
+		return 0;
+	else if (ret)
+		return ret;
 
 	uuid_unparse(fs_info->fsid, uuidbuf);
 	printf("Label: %s  uuid: %s\n",
@@ -478,6 +556,7 @@ devs_only:
 
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
+	free_seen_fsid();
 	return 0;
 }
 
-- 
1.8.2

