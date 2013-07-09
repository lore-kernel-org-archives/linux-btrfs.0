Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3GIUYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 16:24:46 -0400
Date: Tue, 9 Jul 2013 13:24:43 -0700
From: Zach Brown <zab@redhat.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH V2 1/2] Btrfs-progs: make pretty_sizes() work less error
 prone
Message-ID: <20130709202443.GJ18717@lenny.home.zabbo.net>
References: <1373191092-4316-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373191092-4316-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> The original codes don't handle error gracefully and some places
> forget to free memory. We can allocate memory before calling pretty_sizes(),
> for example, we can use static memory allocation and we don't have to deal
> with memory allocation fails.

I agree that callers shouldn't have to know to free allocated memory.

But I think that we can do better and not have callers need to worry
about per-call string storage at all.

How about something like this?

- z

>From bea92d06d98827af30518aa800428c0b2a8be101 Mon Sep 17 00:00:00 2001
From: Zach Brown <zab@redhat.com>
Date: Tue, 9 Jul 2013 12:43:57 -0700
Subject: [PATCH] btrfs-progs: per-thread, per-call pretty buffer

We don't need callers to manage string storage for each pretty_sizes()
call.  We can use a macro to have per-thread and per-call static storage
so that pretty_sizes() can be used as many times as needed in printf()
arguments without requiring a bunch of supporting variables.

This lets us have a natural interface at the cost of requiring __thread
and TLS from gcc and a small amount of static storage.  This seems
better than the current code or doing something with illegible format
specifier macros.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-filesystem.c | 27 +++++++++------------------
 cmds-scrub.c      |  8 ++++----
 mkfs.c            |  4 +---
 utils.c           | 17 +++++++++--------
 utils.h           | 10 +++++++++-
 5 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..8d1c5c2 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -111,8 +111,6 @@ static int cmd_df(int argc, char **argv)
 
 	for (i = 0; i < sargs->total_spaces; i++) {
 		char description[80];
-		char *total_bytes;
-		char *used_bytes;
 		int written = 0;
 		u64 flags = sargs->spaces[i].flags;
 
@@ -155,10 +153,9 @@ static int cmd_df(int argc, char **argv)
 			written += 7;
 		}
 
-		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
-		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
-		printf("%s: total=%s, used=%s\n", description, total_bytes,
-		       used_bytes);
+		printf("%s: total=%s, used=%s\n", description,
+			pretty_sizes(sargs->spaces[i].total_bytes),
+			pretty_sizes(sargs->spaces[i].used_bytes));
 	}
 	close(fd);
 	free(sargs);
@@ -192,7 +189,6 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	char uuidbuf[37];
 	struct list_head *cur;
 	struct btrfs_device *device;
-	char *super_bytes_used;
 	u64 devs_found = 0;
 	u64 total;
 
@@ -204,25 +200,20 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	else
 		printf("Label: none ");
 
-	super_bytes_used = pretty_sizes(device->super_bytes_used);
 
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
-	       (unsigned long long)total, super_bytes_used);
-
-	free(super_bytes_used);
+	       (unsigned long long)total,
+	       pretty_sizes(device->super_bytes_used));
 
 	list_for_each(cur, &fs_devices->devices) {
-		char *total_bytes;
-		char *bytes_used;
 		device = list_entry(cur, struct btrfs_device, dev_list);
-		total_bytes = pretty_sizes(device->total_bytes);
-		bytes_used = pretty_sizes(device->bytes_used);
+
 		printf("\tdevid %4llu size %s used %s path %s\n",
 		       (unsigned long long)device->devid,
-		       total_bytes, bytes_used, device->name);
-		free(total_bytes);
-		free(bytes_used);
+		       pretty_sizes(device->total_bytes),
+		       pretty_sizes(device->bytes_used), device->name);
+
 		devs_found++;
 	}
 	if (devs_found < total) {
diff --git a/cmds-scrub.c b/cmds-scrub.c
index c0dc584..25f9ffd 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -139,7 +139,6 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
 {
 	u64 err_cnt;
 	u64 err_cnt2;
-	char *bytes;
 
 	err_cnt = p->read_errors +
 			p->csum_errors +
@@ -151,10 +150,11 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
 	if (p->malloc_errors)
 		printf("*** WARNING: memory allocation failed while scrubbing. "
 		       "results may be inaccurate\n");
-	bytes = pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed);
-	printf("\ttotal bytes scrubbed: %s with %llu errors\n", bytes,
+
+	printf("\ttotal bytes scrubbed: %s with %llu errors\n",
+		pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed),
 		max(err_cnt, err_cnt2));
-	free(bytes);
+
 	if (err_cnt || err_cnt2) {
 		printf("\terror details:");
 		PRINT_SCRUB_ERROR(p->read_errors, "read");
diff --git a/mkfs.c b/mkfs.c
index b412b7e..1a09d31 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1273,7 +1273,6 @@ int main(int ac, char **av)
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
-	char *pretty_buf;
 	struct btrfs_super_block *super;
 	u64 flags;
 	int dev_cnt = 0;
@@ -1525,8 +1524,7 @@ raid_groups:
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
-	free(pretty_buf);
+	    pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
diff --git a/utils.c b/utils.c
index 7b4cd74..2688eb8 100644
--- a/utils.c
+++ b/utils.c
@@ -1153,12 +1153,13 @@ out:
 
 static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
 			    "PB", "EB", "ZB", "YB"};
-char *pretty_sizes(u64 size)
+void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
 {
 	int num_divs = 0;
-        int pretty_len = 16;
 	float fraction;
-	char *pretty;
+
+	if (str_bytes == 0)
+		return;
 
 	if( size < 1024 ){
 		fraction = size;
@@ -1172,13 +1173,13 @@ char *pretty_sizes(u64 size)
 			num_divs ++;
 		}
 
-		if (num_divs >= ARRAY_SIZE(size_strs))
-			return NULL;
+		if (num_divs >= ARRAY_SIZE(size_strs)) {
+			str[0] = '\0';
+			return;
+		}
 		fraction = (float)last_size / 1024;
 	}
-	pretty = malloc(pretty_len);
-	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
-	return pretty;
+	snprintf(str, str_bytes, "%.2f%s", fraction, size_strs[num_divs]);
 }
 
 /*
diff --git a/utils.h b/utils.h
index 3c17e14..03e4aee 100644
--- a/utils.h
+++ b/utils.h
@@ -44,7 +44,15 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 			struct btrfs_fs_devices **fs_devices_mnt);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
-char *pretty_sizes(u64 size);
+
+void pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
+#define pretty_sizes(size) 					\
+	({							\
+		static __thread char _str[16];			\
+		pretty_size_snprintf(size, _str, sizeof(_str));	\
+		_str;						\
+	})
+
 int get_mountpt(char *dev, char *mntpt, size_t size);
 int btrfs_scan_block_devices(int run_ioctl);
 u64 parse_size(char *s);
-- 
1.7.11.7

