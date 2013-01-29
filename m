Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:55499 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3A2GGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 01:06:49 -0500
Received: by mail-ob0-f202.google.com with SMTP id lz20so15002obb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 22:06:49 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 3/3] Add support for Btrfs ioctls: BTRFS_IOC_SPACE_INFO (filesystem df)
Date: Mon, 28 Jan 2013 22:06:38 -0800
Message-Id: <1359439598-4141-4-git-send-email-filbranden@google.com>
In-Reply-To: <1359439598-4141-1-git-send-email-filbranden@google.com>
References: <1359439598-4141-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds support for the BTRFS_IOC_SPACE_INFO (used by `btrfs filesystem df')
by parsing the struct passed by userspace to the kernel and interpreting the
output fields filled in by kernel code.

TODO: Some constants are defined in the C file because they're not currently
present in linux/btrfs.h, but they should be moved to that file in Btrfs source
code so that they can be used by userspace programs that need those constants.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 btrfs.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/btrfs.c b/btrfs.c
index a4895e4..799ae46 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -30,10 +30,130 @@
 
 #ifdef HAVE_LINUX_BTRFS_H
 #include <linux/btrfs.h>
+
+/* TODO: in btrfs source code, these are currently in ctree.h, must be moved to btrfs.h */
+#ifndef BTRFS_BLOCK_GROUP_DATA
+#define BTRFS_BLOCK_GROUP_DATA          (1ULL << 0)
+#define BTRFS_BLOCK_GROUP_SYSTEM        (1ULL << 1)
+#define BTRFS_BLOCK_GROUP_METADATA      (1ULL << 2)
+#define BTRFS_BLOCK_GROUP_RAID0         (1ULL << 3)
+#define BTRFS_BLOCK_GROUP_RAID1         (1ULL << 4)
+#define BTRFS_BLOCK_GROUP_DUP           (1ULL << 5)
+#define BTRFS_BLOCK_GROUP_RAID10        (1ULL << 6)
+#endif /* BTRFS_BLOCK_GROUP_DATA */
+
+static const struct xlat btrfs_space_info_flags[] = {
+	{BTRFS_BLOCK_GROUP_DATA,        "BTRFS_BLOCK_GROUP_DATA"},
+	{BTRFS_BLOCK_GROUP_SYSTEM,      "BTRFS_BLOCK_GROUP_SYSTEM"},
+	{BTRFS_BLOCK_GROUP_METADATA,    "BTRFS_BLOCK_GROUP_METADATA"},
+	{BTRFS_BLOCK_GROUP_RAID0,       "BTRFS_BLOCK_GROUP_RAID0"},
+	{BTRFS_BLOCK_GROUP_RAID1,       "BTRFS_BLOCK_GROUP_RAID1"},
+	{BTRFS_BLOCK_GROUP_DUP,         "BTRFS_BLOCK_GROUP_DUP"},
+	{BTRFS_BLOCK_GROUP_RAID10,      "BTRFS_BLOCK_GROUP_RAID10"},
+	{0, NULL}
+};
+
+static void
+print_space_info(struct btrfs_ioctl_space_info *si)
+{
+	__u64 flags;
+	int first;
+	const struct xlat *xl;
+
+	flags = si->flags;
+	tprintf("{flags=%#llx", flags);
+	first = 1;
+	for (xl = btrfs_space_info_flags; flags && xl->val; xl++) {
+		if (flags & xl->val) {
+			if (first)
+				tprints(" /* ");
+			else
+				tprints("|");
+			first = 0;
+			tprints(xl->str);
+			flags &= ~xl->val;
+		}
+	}
+	if (!first) {
+		/* flags were expanded at least once */
+		if (flags)
+			tprintf("|%#llx */", flags);
+		else
+			tprints(" */");
+	}
+	tprintf(", total_bytes=%llu, used_bytes=%llu}", si->total_bytes, si->used_bytes);
+}
+
+static void
+print_space_args_out(struct tcb *tcp, long arg)
+{
+	struct btrfs_ioctl_space_args sa, *sa_ptr;
+	__u64 i, total;
+	int truncated;
+	long sa_size;
+
+	if (syserror(tcp) || umove(tcp, arg, &sa) < 0)
+		return;
+
+	total = sa.total_spaces;
+	tprintf(", total_spaces=%llu", total);
+	if (total > sa.space_slots)
+		total = sa.space_slots;
+	if (total <= 0)
+		return;
+	/* if total > 10 then truncate it */
+	truncated = 0;
+	if (total > 10) {
+		total = 10;
+		truncated = 1;
+	}
+
+	sa_size = sizeof(struct btrfs_ioctl_space_args) + total * sizeof(struct btrfs_ioctl_space_info);
+	sa_ptr = malloc(sa_size);
+	if (!sa_ptr)
+		return;
+
+	if (umoven(tcp, arg, sa_size, (char *) sa_ptr) < 0)
+		goto out;
+
+	tprints(", spaces={");
+	for (i = 0L; i < total; i++) {
+		if (i)
+			tprints(", ");
+		tprintf("[%llu]=", i);
+		print_space_info(&sa_ptr->spaces[i]);
+	}
+	if (truncated)
+		tprints(", ...");
+	tprints("}");
+
+out:
+	free(sa_ptr);
+}
+
 #endif /* HAVE_LINUX_BTRFS_H */
 
 int
 btrfs_ioctl(struct tcb *tcp, long code, long arg)
 {
+#ifdef HAVE_LINUX_BTRFS_H
+	switch (code) {
+	case BTRFS_IOC_SPACE_INFO:
+		if (entering(tcp)) {
+			struct btrfs_ioctl_space_args sa;
+			if (umove(tcp, arg, &sa) < 0)
+				tprintf(", %#lx", arg);
+			else {
+				tprintf(", {space_slots=%llu", sa.space_slots);
+			}
+		}
+		if (exiting(tcp)) {
+			print_space_args_out(tcp, arg);
+			tprints("}");
+		}
+		return 1;
+	}
+#endif /* HAVE_LINUX_BTRFS_H */
+
 	return 0;
 }
-- 
1.7.11.7

