Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49180 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaESSMM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 14:12:12 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so8344933wgh.20
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 11:12:11 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: ensure readers see new data after a clone operation
Date: Mon, 19 May 2014 20:11:53 +0100
Message-Id: <1400526713-27660-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1400240833-7197-1-git-send-email-fdmanana@gmail.com>
References: <1400240833-7197-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were cleaning the clone target file range from the page cache before
we did replace the file extent items in the fs tree. This was racy,
as right after cleaning the relevant range from the page cache and before
replacing the file extent items, a read against that range could be
performed by another task and populate again the page cache with stale
data (stale after the cloning finishes). This would result in reads after
the clone operation successfully finishes to get old data (and potentially
for a very long time). Therefore evict the pages after replacing the file
extent items, so that subsequent reads will always get the new data.

Similarly, we were prone to races while cloning the file extent items
because we weren't locking the target range and wait for any existing
ordered extents against that range to complete. It was possible that
after cloning the extent items, a write operation that was performed
before the clone operation and overlaps the same range, would end up
undoing all or part of the work the clone operation did (a worker task
running inode.c:btrfs_finish_ordered_io). Therefore lock the target
range in the io tree, wait for all pending ordered extents against that
range to finish and then safely perform the cloning.

The issue of reading stale data after the clone operation is easy to
reproduce by running the following C program in a loop until it exits
with return value 1.

 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
 #include <pthread.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <assert.h>
 #include <asm/types.h>
 #include <linux/ioctl.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/ioctl.h>

 #define SRC_FILE "/mnt/sdd/foo"
 #define DST_FILE "/mnt/sdd/bar"
 #define FILE_SIZE (16 * 1024)
 #define PATTERN_SRC 'X'
 #define PATTERN_DST 'Y'

struct btrfs_ioctl_clone_range_args {
	__s64 src_fd;
	__u64 src_offset, src_length;
	__u64 dest_offset;
};

 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
				   struct btrfs_ioctl_clone_range_args)

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static int clone_done = 0;
static int reader_ready = 0;
static int stale_data = 0;

static void *reader_loop(void *arg)
{
	char buf[4096], want_buf[4096];

	memset(want_buf, PATTERN_SRC, 4096);
	pthread_mutex_lock(&mutex);
	reader_ready = 1;
	pthread_mutex_unlock(&mutex);

	while (1) {
		int done, fd, ret;

		fd = open(DST_FILE, O_RDONLY);
		assert(fd != -1);

		pthread_mutex_lock(&mutex);
		done = clone_done;
		pthread_mutex_unlock(&mutex);

		ret = read(fd, buf, 4096);
		assert(ret == 4096);
		close(fd);

		if (done) {
			ret = memcmp(buf, want_buf, 4096);
			if (ret == 0) {
				printf("Found new content\n");
			} else {
				printf("Found old content\n");
				pthread_mutex_lock(&mutex);
				stale_data = 1;
				pthread_mutex_unlock(&mutex);
			}
			break;
		}
	}
	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_t reader;
	int ret, i, fd;
	struct btrfs_ioctl_clone_range_args clone_args;
	int fd1, fd2;

	ret = remove(SRC_FILE);
	if (ret == -1 && errno != ENOENT) {
		fprintf(stderr, "Error deleting src file: %s\n", strerror(errno));
		return 1;
	}
	ret = remove(DST_FILE);
	if (ret == -1 && errno != ENOENT) {
		fprintf(stderr, "Error deleting dst file: %s\n", strerror(errno));
		return 1;
	}

	fd = open(SRC_FILE, O_CREAT | O_WRONLY | O_TRUNC, S_IRWXU);
	assert(fd != -1);
	for (i = 0; i < FILE_SIZE; i++) {
		char c = PATTERN_SRC;
		ret = write(fd, &c, 1);
		assert(ret == 1);
	}
	close(fd);
	fd = open(DST_FILE, O_CREAT | O_WRONLY | O_TRUNC, S_IRWXU);
	assert(fd != -1);
	for (i = 0; i < FILE_SIZE; i++) {
		char c = PATTERN_DST;
		ret = write(fd, &c, 1);
		assert(ret == 1);
	}
	close(fd);

	ret = pthread_create(&reader, NULL, reader_loop, NULL);
	assert(ret == 0);
	while (1) {
		int r;
		pthread_mutex_lock(&mutex);
		r = reader_ready;
		pthread_mutex_unlock(&mutex);
		if (r) break;
	}

	fd1 = open(SRC_FILE, O_RDONLY);
	if (fd1 < 0) {
		fprintf(stderr, "Error open src file: %s\n", strerror(errno));
		return 1;
	}
	fd2 = open(DST_FILE, O_RDWR);
	if (fd2 < 0) {
		fprintf(stderr, "Error open dst file: %s\n", strerror(errno));
		return 1;
	}
	clone_args.src_fd = fd1;
	clone_args.src_offset = 0;
	clone_args.src_length = 4096;
	clone_args.dest_offset = 0;
	ret = ioctl(fd2, BTRFS_IOC_CLONE_RANGE, &clone_args);
	assert(ret == 0);
	close(fd1);
	close(fd2);

	pthread_mutex_lock(&mutex);
	clone_done = 1;
	pthread_mutex_unlock(&mutex);
	ret = pthread_join(reader, NULL);
	assert(ret == 0);

	pthread_mutex_lock(&mutex);
	ret = stale_data ? 1 : 0;
	pthread_mutex_unlock(&mutex);
	return ret;
}

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Protect against ongoing writes by locking the target range in
    the io tree and wait for any existing ordered extents for that
    range to finish before starting the clone operation.

 fs/btrfs/ioctl.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fba7a00..12a60ef 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3410,15 +3410,37 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			goto out_unlock;
 	}
 
-	/* truncate page cache pages from target inode range */
-	truncate_inode_pages_range(&inode->i_data, destoff,
-				   PAGE_CACHE_ALIGN(destoff + len) - 1);
-
-	lock_extent_range(src, off, len);
+	/*
+	 * Lock the target range too. Right after we replace the file extent
+	 * items in the fs tree (which now point to the cloned data), we might
+	 * have a worker replace them with extent items relative to a write
+	 * operation that was issued before this clone operation (i.e. confront
+	 * with inode.c:btrfs_finish_ordered_io).
+	 */
+	if (same_inode) {
+		lock_extent_range(src, min_t(u64, off, destoff),
+				  max_t(u64, off + len, destoff + len));
+	} else {
+		lock_extent_range(src, off, len);
+		lock_extent_range(inode, destoff, len);
+	}
 
 	ret = btrfs_clone(src, inode, off, olen, len, destoff);
 
-	unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
+	if (same_inode) {
+		unlock_extent(&BTRFS_I(src)->io_tree, min_t(u64, off, destoff),
+			      max_t(u64, off + len, destoff + len) - 1);
+	} else {
+		unlock_extent(&BTRFS_I(src)->io_tree, off, off + len - 1);
+		unlock_extent(&BTRFS_I(inode)->io_tree, destoff,
+			      destoff + len - 1);
+	}
+	/*
+	 * Truncate page cache pages so that future reads will see the cloned
+	 * data immediately and not the previous data.
+	 */
+	truncate_inode_pages_range(&inode->i_data, destoff,
+				   PAGE_CACHE_ALIGN(destoff + len) - 1);
 out_unlock:
 	if (!same_inode) {
 		if (inode < src) {
-- 
1.9.1

