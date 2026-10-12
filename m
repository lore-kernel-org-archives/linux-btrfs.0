Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F234718E9;
	Mon, 12 Oct 2026 12:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808291; cv=none; b=fMX5qxMJ5EmBe/QowG+hv9dQ7A6c5UVyZy0OXD/Emq5M6YEsKrLOsFGDXpQzaUaawajPKJdeoWmc2p6LI08J55/SGNewarT9P5MBrm3eoPcJiE4rINtl+L7Xvbo2wPVadtZ5FZgA2Pgq/W70AyzIIOnF6T4pZqSGPDce3Xq1UTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808291; c=relaxed/simple;
	bh=8imTZspBcZVNOShIGzS+8PI2WJIj0e0sbWFzNBy0P5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R2Z3aM76GjrrQ0+jSNGhWIhEpivhRSGcru3ZRjt1VxGxr66TlswwWnA43GinOHjPy+ZD0uyIyxP4sCEDdgi0ua+PfcJtkm0vzOSS1VCUyMChEV7P4yrVBJk4uO9tnqk1oHDqpD9zS5hSnFWG2dhh+v8CmsuLbCFaS6bVU1/xmbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdASA4A7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdASA4A7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C5A1F0089C;
	Mon, 12 Oct 2026 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791808289;
	bh=6KTn4fVORnTWbEPt0NhgdNA7kdks57WEZP007BcNqP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GdASA4A7+f/lHTiE1nrern0heFM9Nj93uo3zhRBwEkjRrMFEZ8izRxD0QnYagNPNA
	 GpqIznz6lhN4dN/KsVbIfjvh2pqiFQ5V2vJnJm6YE+VmahdengVh70o/ra5dUzyjPJ
	 YSW6wgbLKtC1rEegsgUC1G8/OEA+WIP5tWV3/M8hvl2kJ7cRuZfD7jS6a3haYkqibS
	 Mzzrbk+dEI9YZhGop3ueT68dzp2SFgMJEU4X8mMsG5EqjXbiPZpI5faLOgR8TzLuRA
	 +Vu/uxlEF0WBfds8usLmiuLIUPe9Pw6o68j5hFSdK18hKYwtr9bdUzQ5W4I/gu9CyX
	 sok+poChvcQPw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 14:31:18 +0200
Subject: [PATCH 1/2] selftests/filesystems: add a test for freezing a
 shared block device
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-super-dev_hash-v1-1-305cf71cd334@kernel.org>
References: <20261012-work-super-dev_hash-v1-0-305cf71cd334@kernel.org>
In-Reply-To: <20261012-work-super-dev_hash-v1-0-305cf71cd334@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=16184; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8imTZspBcZVNOShIGzS+8PI2WJIj0e0sbWFzNBy0P5A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSduSydse9pPNskGZaOedGLz1rds3px9pCS+6/kNxu1d
 dri7va/7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIyyKG/wndSxU+KRxW60v8
 1jH7+i7dgNxp7IH358hejn7/8Oa14hpGhjn/1dc8nC3U1h1ZP7c071G++9OvQTOKJ1/n+el69dK
 JiWwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

erofs claims its blob devices with the filesystem type as the holder so
several erofs superblocks can share one. Merge two images from a common
layer and a layer of their own, put the common layer on device-mapper,
mount both and check that:

- a suspend freezes each of them exactly once

- the resume thaws both

- once one of them is unmounted only the other one is frozen

- BLKFLSBUF and ustat() on the shared device work

- mounts that come and go while the device is suspended and resumed
  leave nothing frozen behind

mkfs.erofs builds the images, the test is skipped without it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/filesystems/freeze/.gitignore        |   1 +
 .../testing/selftests/filesystems/freeze/Makefile  |   2 +-
 tools/testing/selftests/filesystems/freeze/config  |   1 +
 .../filesystems/freeze/shared_bdev_test.c          | 479 +++++++++++++++++++++
 4 files changed, 482 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/freeze/.gitignore b/tools/testing/selftests/filesystems/freeze/.gitignore
index 28f1fe73f19b..2f60f71c3d03 100644
--- a/tools/testing/selftests/filesystems/freeze/.gitignore
+++ b/tools/testing/selftests/filesystems/freeze/.gitignore
@@ -2,3 +2,4 @@
 quotactl_test
 bdev_freeze_test
 bdev_thaw_test
+shared_bdev_test
diff --git a/tools/testing/selftests/filesystems/freeze/Makefile b/tools/testing/selftests/filesystems/freeze/Makefile
index acd246e1b14b..a2b956286b15 100644
--- a/tools/testing/selftests/filesystems/freeze/Makefile
+++ b/tools/testing/selftests/filesystems/freeze/Makefile
@@ -3,6 +3,6 @@ CFLAGS += -Wall -O2 -g $(KHDR_INCLUDES)
 LOCAL_HDRS += loop_util.h
 
 TEST_GEN_PROGS := quotactl_test
-TEST_GEN_PROGS += bdev_freeze_test bdev_thaw_test
+TEST_GEN_PROGS += bdev_freeze_test bdev_thaw_test shared_bdev_test
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/freeze/config b/tools/testing/selftests/filesystems/freeze/config
index d03720cda9a9..28e568e5d670 100644
--- a/tools/testing/selftests/filesystems/freeze/config
+++ b/tools/testing/selftests/filesystems/freeze/config
@@ -1,6 +1,7 @@
 CONFIG_BLK_DEV_DM=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_DEBUG_FS=y
+CONFIG_EROFS_FS=y
 CONFIG_EXT4_FS=y
 CONFIG_FAIL_MAKE_REQUEST=y
 CONFIG_FAULT_INJECTION=y
diff --git a/tools/testing/selftests/filesystems/freeze/shared_bdev_test.c b/tools/testing/selftests/filesystems/freeze/shared_bdev_test.c
new file mode 100644
index 000000000000..0ee352268a97
--- /dev/null
+++ b/tools/testing/selftests/filesystems/freeze/shared_bdev_test.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Freezing a block device that several superblocks share.
+ *
+ * erofs claims its blob devices with the filesystem type as the holder, so
+ * several erofs superblocks can share a blob. Merge two images from a common
+ * layer and a layer of their own, put the common layer on a device-mapper
+ * device and mount both. A suspend of that device has to freeze each of the
+ * two superblocks exactly once and the resume has to thaw both, also while
+ * mounts of one of them come and go. erofs is read-only, so the freezes and
+ * thaws don't write to the suspended device.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <ftw.h>
+#include <linux/dm-ioctl.h>
+#include <linux/fs.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/sysmacros.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+#include "loop_util.h"
+
+#define NR_CHURN 100
+
+enum { M12, M13, L1, L2, L3, NR_IMGS };
+
+static const char *const img_names[NR_IMGS] = { "m12", "m13", "l1", "l2", "l3" };
+
+FIXTURE(shared_bdev) {
+	char dir[64];
+	char a[96];
+	char b[96];
+	char dm[96];
+	char name[32];
+	char src_a[32];
+	char src_b[32];
+	char opts_a[256];
+	char opts_b[256];
+	int loop[NR_IMGS];
+	int fd_a;
+	int fd_b;
+	dev_t dmdev;
+	bool dm_created;
+	bool suspended;
+	bool mounted_a;
+	bool mounted_b;
+};
+
+static int dm_ioctl(unsigned long cmd, const char *name, uint32_t flags, dev_t *dev)
+{
+	struct dm_ioctl dmi = {
+		.version = { DM_VERSION_MAJOR, 0, 0 },
+		.data_size = sizeof(dmi),
+		.data_start = sizeof(dmi),
+		.flags = flags,
+	};
+	int fd, ret = 0;
+
+	strncpy(dmi.name, name, sizeof(dmi.name) - 1);
+	fd = open("/dev/mapper/control", O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	if (ioctl(fd, cmd, &dmi))
+		ret = -errno;
+	else if (dev)
+		*dev = makedev((dmi.dev >> 8) & 0xfff,
+			       (dmi.dev & 0xff) | ((dmi.dev >> 12) & 0xfff00));
+	close(fd);
+	return ret;
+}
+
+/* Create @name as a linear mapping of all of @backing and make it live. */
+static int dm_create_linear(const char *name, dev_t backing, uint64_t sectors,
+			    dev_t *dev)
+{
+	struct {
+		struct dm_ioctl dmi;
+		struct dm_target_spec spec;
+		char params[64];
+	} __attribute__((aligned(8))) t = {};
+	int fd, ret;
+
+	ret = dm_ioctl(DM_DEV_CREATE, name, 0, NULL);
+	if (ret)
+		return ret;
+
+	t.dmi.version[0] = DM_VERSION_MAJOR;
+	t.dmi.data_size = sizeof(t);
+	t.dmi.data_start = sizeof(t.dmi);
+	t.dmi.target_count = 1;
+	strncpy(t.dmi.name, name, sizeof(t.dmi.name) - 1);
+	t.spec.length = sectors;
+	strcpy(t.spec.target_type, "linear");
+	snprintf(t.params, sizeof(t.params), "%u:%u 0", major(backing), minor(backing));
+
+	fd = open("/dev/mapper/control", O_RDWR | O_CLOEXEC);
+	if (fd >= 0) {
+		ret = ioctl(fd, DM_TABLE_LOAD, &t) ? -errno : 0;
+		close(fd);
+	} else {
+		ret = -errno;
+	}
+	/* Resuming makes the loaded table live. */
+	if (!ret)
+		ret = dm_ioctl(DM_DEV_SUSPEND, name, 0, dev);
+	if (ret)
+		dm_ioctl(DM_DEV_REMOVE, name, 0, NULL);
+	return ret;
+}
+
+static int suspend(FIXTURE_DATA(shared_bdev) *self)
+{
+	int ret = dm_ioctl(DM_DEV_SUSPEND, self->name, DM_SUSPEND_FLAG, NULL);
+
+	if (!ret)
+		self->suspended = true;
+	return ret;
+}
+
+static int resume(FIXTURE_DATA(shared_bdev) *self)
+{
+	int ret = dm_ioctl(DM_DEV_SUSPEND, self->name, 0, NULL);
+
+	if (!ret)
+		self->suspended = false;
+	return ret;
+}
+
+/* Drop one freeze with FITHAW; EINVAL if the superblock isn't frozen. */
+static bool fithaw(int fd)
+{
+	return !ioctl(fd, FITHAW, 0);
+}
+
+static int write_file(const char *path, const char *val)
+{
+	ssize_t len = strlen(val);
+	int fd, ret = 0;
+
+	fd = open(path, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
+	if (fd < 0)
+		return -1;
+	if (write(fd, val, len) != len)
+		ret = -1;
+	close(fd);
+	return ret;
+}
+
+static int check_file(const char *path, const char *val)
+{
+	char buf[32] = {};
+	int fd;
+
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	if (read(fd, buf, sizeof(buf) - 1) < 0)
+		buf[0] = '\0';
+	close(fd);
+	return strcmp(buf, val) ? -1 : 0;
+}
+
+static int rm_one(const char *path, const struct stat *st, int type, struct FTW *ftw)
+{
+	return remove(path);
+}
+
+static int mount_b(FIXTURE_DATA(shared_bdev) *self)
+{
+	int ret = mount(self->src_b, self->b, "erofs", MS_RDONLY, self->opts_b);
+
+	if (!ret)
+		self->mounted_b = true;
+	return ret;
+}
+
+static void shared_bdev_cleanup(FIXTURE_DATA(shared_bdev) *self)
+{
+	if (self->suspended)
+		resume(self);
+	if (self->fd_a >= 0)
+		close(self->fd_a);
+	if (self->fd_b >= 0)
+		close(self->fd_b);
+	if (self->mounted_a)
+		umount2(self->a, MNT_DETACH);
+	umount2(self->b, MNT_DETACH);
+	if (self->dm_created)
+		dm_ioctl(DM_DEV_REMOVE, self->name, 0, NULL);
+	for (int i = 0; i < NR_IMGS; i++) {
+		if (self->loop[i] >= 0)
+			loop_clear(self->loop[i]);
+	}
+	nftw(self->dir, rm_one, 16, FTW_DEPTH | FTW_PHYS);
+}
+
+/* Two layers of their own, a common one, and two images merged from them. */
+static int make_images(const char *dir)
+{
+	static const char *const files[][2] = {
+		{ "src-l1/d1/f1", "one\n" },
+		{ "src-l2/f2", "two\n" },
+		{ "src-l3/f3", "three\n" },
+	};
+	char path[160], cmd[512];
+
+	for (int i = 0; i < 3; i++) {
+		snprintf(path, sizeof(path), "%s/src-l%d", dir, i + 1);
+		if (mkdir(path, 0755))
+			return -1;
+	}
+	snprintf(path, sizeof(path), "%s/src-l1/d1", dir);
+	if (mkdir(path, 0755))
+		return -1;
+	for (int i = 0; i < 3; i++) {
+		snprintf(path, sizeof(path), "%s/%s", dir, files[i][0]);
+		if (write_file(path, files[i][1]))
+			return -1;
+	}
+
+	/* Chunk-based layers can be referenced by the merged images. */
+	snprintf(cmd, sizeof(cmd),
+		 "cd %s && (for l in l1 l2 l3; do "
+		 "mkfs.erofs --chunksize=4096 -Enoinline_data $l src-$l || exit 1; done && "
+		 "mkfs.erofs m12 l1 l2 && mkfs.erofs m13 l1 l3) >/dev/null 2>&1", dir);
+	return system(cmd) ? -1 : 0;
+}
+
+FIXTURE_SETUP(shared_bdev)
+{
+	struct stat img, lst, st;
+	char path[160], dev[32];
+	int fd;
+
+	for (int i = 0; i < NR_IMGS; i++)
+		self->loop[i] = -1;
+	self->fd_a = -1;
+	self->fd_b = -1;
+	self->dm_created = false;
+	self->suspended = false;
+	self->mounted_a = false;
+	self->mounted_b = false;
+
+	if (geteuid() != 0)
+		SKIP(return, "test requires CAP_SYS_ADMIN");
+	if (access("/dev/loop-control", R_OK | W_OK))
+		SKIP(return, "test requires loop devices");
+	if (access("/dev/mapper/control", R_OK | W_OK))
+		SKIP(return, "test requires device-mapper");
+
+	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
+	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
+
+	snprintf(self->dir, sizeof(self->dir), "/tmp/shared_bdev.XXXXXX");
+	ASSERT_NE(mkdtemp(self->dir), NULL);
+	snprintf(self->a, sizeof(self->a), "%s/a", self->dir);
+	snprintf(self->b, sizeof(self->b), "%s/b", self->dir);
+	snprintf(self->name, sizeof(self->name), "shared_bdev_%d", getpid());
+	/* The harness doesn't run the teardown when the setup fails. */
+	ASSERT_EQ(mkdir(self->a, 0700), 0)
+		shared_bdev_cleanup(self);
+	ASSERT_EQ(mkdir(self->b, 0700), 0)
+		shared_bdev_cleanup(self);
+
+	if (make_images(self->dir)) {
+		shared_bdev_cleanup(self);
+		SKIP(return, "mkfs.erofs failed, is missing or can't merge images");
+	}
+
+	for (int i = 0; i < NR_IMGS; i++) {
+		snprintf(path, sizeof(path), "%s/%s", self->dir, img_names[i]);
+		fd = open(path, O_RDWR | O_CLOEXEC);
+		ASSERT_GE(fd, 0)
+			shared_bdev_cleanup(self);
+		self->loop[i] = loop_bind(fd);
+		if (i == L1) {
+			ASSERT_EQ(fstat(fd, &img), 0)
+				shared_bdev_cleanup(self);
+		}
+		close(fd);
+		ASSERT_GE(self->loop[i], 0)
+			shared_bdev_cleanup(self);
+	}
+
+	/* The common layer goes on a device-mapper device. */
+	snprintf(dev, sizeof(dev), "/dev/loop%d", self->loop[L1]);
+	ASSERT_EQ(stat(dev, &lst), 0)
+		shared_bdev_cleanup(self);
+	ASSERT_EQ(dm_create_linear(self->name, lst.st_rdev, img.st_size >> 9, &self->dmdev), 0)
+		shared_bdev_cleanup(self);
+	self->dm_created = true;
+	snprintf(self->dm, sizeof(self->dm), "/dev/dm-%u", minor(self->dmdev));
+	if (stat(self->dm, &st) || st.st_rdev != self->dmdev) {
+		snprintf(self->dm, sizeof(self->dm), "%s/dm", self->dir);
+		ASSERT_EQ(mknod(self->dm, S_IFBLK | 0600, self->dmdev), 0)
+			shared_bdev_cleanup(self);
+	}
+
+	snprintf(self->src_a, sizeof(self->src_a), "/dev/loop%d", self->loop[M12]);
+	snprintf(self->src_b, sizeof(self->src_b), "/dev/loop%d", self->loop[M13]);
+	snprintf(self->opts_a, sizeof(self->opts_a), "device=%s,device=/dev/loop%d",
+		 self->dm, self->loop[L2]);
+	snprintf(self->opts_b, sizeof(self->opts_b), "device=%s,device=/dev/loop%d",
+		 self->dm, self->loop[L3]);
+
+	if (mount(self->src_a, self->a, "erofs", MS_RDONLY, self->opts_a)) {
+		if (errno == ENODEV) {
+			shared_bdev_cleanup(self);
+			SKIP(return, "kernel lacks erofs");
+		}
+		ASSERT_EQ(errno, 0)
+			shared_bdev_cleanup(self);
+	}
+	self->mounted_a = true;
+	ASSERT_EQ(mount_b(self), 0)
+		shared_bdev_cleanup(self);
+
+	/* Both read through the shared blob. */
+	snprintf(path, sizeof(path), "%s/d1/f1", self->a);
+	ASSERT_EQ(check_file(path, "one\n"), 0)
+		shared_bdev_cleanup(self);
+	snprintf(path, sizeof(path), "%s/f2", self->a);
+	ASSERT_EQ(check_file(path, "two\n"), 0)
+		shared_bdev_cleanup(self);
+	snprintf(path, sizeof(path), "%s/d1/f1", self->b);
+	ASSERT_EQ(check_file(path, "one\n"), 0)
+		shared_bdev_cleanup(self);
+	snprintf(path, sizeof(path), "%s/f3", self->b);
+	ASSERT_EQ(check_file(path, "three\n"), 0)
+		shared_bdev_cleanup(self);
+
+	self->fd_a = open(self->a, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_GE(self->fd_a, 0)
+		shared_bdev_cleanup(self);
+	self->fd_b = open(self->b, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	ASSERT_GE(self->fd_b, 0)
+		shared_bdev_cleanup(self);
+}
+
+FIXTURE_TEARDOWN(shared_bdev)
+{
+	shared_bdev_cleanup(self);
+}
+
+TEST_F(shared_bdev, suspend_freezes_each_once)
+{
+	ASSERT_EQ(suspend(self), 0);
+
+	/* One FITHAW drops each freeze, a second one finds nothing frozen. */
+	ASSERT_TRUE(fithaw(self->fd_a));
+	ASSERT_FALSE(fithaw(self->fd_a));
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_TRUE(fithaw(self->fd_b));
+	ASSERT_FALSE(fithaw(self->fd_b));
+	ASSERT_EQ(errno, EINVAL);
+
+	/* The resume finds nothing left to thaw and still thaws the device. */
+	ASSERT_EQ(resume(self), 0);
+	ASSERT_EQ(suspend(self), 0);
+	ASSERT_EQ(resume(self), 0);
+}
+
+TEST_F(shared_bdev, resume_thaws_all)
+{
+	ASSERT_EQ(suspend(self), 0);
+	ASSERT_EQ(resume(self), 0);
+
+	ASSERT_FALSE(fithaw(self->fd_a));
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_FALSE(fithaw(self->fd_b));
+	ASSERT_EQ(errno, EINVAL);
+}
+
+TEST_F(shared_bdev, unmounted_sharer)
+{
+	close(self->fd_b);
+	self->fd_b = -1;
+	ASSERT_EQ(umount2(self->b, 0), 0);
+	self->mounted_b = false;
+
+	/* Only the remaining superblock is frozen, once. */
+	ASSERT_EQ(suspend(self), 0);
+	ASSERT_TRUE(fithaw(self->fd_a));
+	ASSERT_FALSE(fithaw(self->fd_a));
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(resume(self), 0);
+
+	/* The blob can be claimed again. */
+	ASSERT_EQ(mount_b(self), 0);
+}
+
+TEST_F(shared_bdev, flushbuf)
+{
+	int fd = open(self->dm, O_RDONLY | O_CLOEXEC);
+
+	ASSERT_GE(fd, 0);
+	/* BLKFLSBUF syncs every superblock that uses the device. */
+	ASSERT_EQ(ioctl(fd, BLKFLSBUF, 0), 0);
+	close(fd);
+}
+
+#ifdef __NR_ustat
+/* struct ustat is not exported through UAPI, mirror include/linux/types.h. */
+struct ustat_buf {
+	int		f_tfree;
+	unsigned long	f_tinode;
+	char		f_fname[6];
+	char		f_fpack[6];
+	char		pad[64];
+};
+
+TEST_F(shared_bdev, ustat)
+{
+	struct ustat_buf buf;
+
+	/* ustat() stops at the first superblock it can lock... */
+	ASSERT_EQ(syscall(__NR_ustat, (unsigned int)self->dmdev, &buf), 0);
+
+	/* ...and the walks after it still reach both. */
+	ASSERT_EQ(suspend(self), 0);
+	ASSERT_TRUE(fithaw(self->fd_a));
+	ASSERT_TRUE(fithaw(self->fd_b));
+	ASSERT_EQ(resume(self), 0);
+}
+#endif
+
+TEST_F(shared_bdev, churn)
+{
+	int status;
+	pid_t pid;
+
+	close(self->fd_b);
+	self->fd_b = -1;
+	ASSERT_EQ(umount2(self->b, 0), 0);
+	self->mounted_b = false;
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		/* A mount while the device is frozen is refused with EBUSY. */
+		for (int i = 0; i < NR_CHURN; i++) {
+			if (!mount(self->src_b, self->b, "erofs", MS_RDONLY, self->opts_b)) {
+				if (umount2(self->b, 0))
+					_exit(1);
+			} else if (errno != EBUSY) {
+				_exit(2);
+			}
+		}
+		_exit(0);
+	}
+
+	for (int i = 0; i < NR_CHURN; i++) {
+		ASSERT_EQ(suspend(self), 0);
+		ASSERT_EQ(resume(self), 0);
+	}
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+
+	/* Nothing is left frozen and the blob can be claimed again. */
+	ASSERT_FALSE(fithaw(self->fd_a));
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mount_b(self), 0);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0

