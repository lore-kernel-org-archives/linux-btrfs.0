Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32237 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbcCAQIq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:08:46 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [RFC PATCH 2/2] btrfs-progs: Encryption: add encrypt sub cli
Date: Wed,  2 Mar 2016 00:08:12 +0800
Message-Id: <1456848492-4814-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*** Warning: Experimental cli and codes ***

This is the btrfs-progs part of btrfs encryption. The branch
is based on btrfs-progs v4.4.1.

Depends on keyctl-utils and libscrypt packages.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Makefile.in      |   5 +-
 btrfs-list.c     |  33 +++++
 cmds-subvolume.c | 107 ++++++++++++++--
 commands.h       |   1 +
 encrypt.c        | 383 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 encrypt.h        |  33 +++++
 props.c          |   3 +
 subvolume.h      |   2 +
 8 files changed, 551 insertions(+), 16 deletions(-)
 create mode 100644 encrypt.c
 create mode 100644 encrypt.h

diff --git a/Makefile.in b/Makefile.in
index 6faf94dedf90..9c77461b76c6 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -34,7 +34,7 @@ DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
 DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 
 EXTRA_CFLAGS :=
-EXTRA_LDFLAGS :=
+EXTRA_LDFLAGS := /usr/lib/libscrypt.so.0 /usr/lib/libkeyutils.so
 
 # Common build flags
 CFLAGS = @CFLAGS@ \
@@ -70,7 +70,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o free-space-tree.o help.o subvolume.o
+	  inode.o file.o find-root.o free-space-tree.o help.o subvolume.o \
+	  encrypt.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/btrfs-list.c b/btrfs-list.c
index 2da54bf706f3..feffddd9c2cf 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1912,3 +1912,36 @@ int btrfs_list_get_path_rootid(int fd, u64 *treeid)
 	*treeid = args.treeid;
 	return 0;
 }
+
+int wait_for_commit(int fd)
+{
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
+	if (ret < 0)
+		return ret;
+	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
+}
+
+/*
+ * A kind of workaround as of now, fixme to a per subvol only sync
+ * instead of entire FS.
+ */
+int wait_for_commit_subvol(char *subvol)
+{
+	int fd;
+	int ret;
+	DIR *ds;
+
+	fd = open_file_or_dir3(subvol, &ds, O_RDWR);
+	if (fd == -1) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open '%s' failed: %s\n",
+					subvol, strerror(-ret));
+		return ret;
+	}
+
+	ret = wait_for_commit(fd);
+	close_file_or_dir(fd, ds);
+	return ret;
+}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f9953ab7adb7..02a26778ccd2 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -27,6 +27,8 @@
 #include <getopt.h>
 #include <uuid/uuid.h>
 #include <linux/magic.h>
+#include <keyutils.h>
+#include <fcntl.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
@@ -38,6 +40,7 @@
 #include "btrfs-list.h"
 #include "utils.h"
 #include "subvolume.h"
+#include "encrypt.h"
 
 static int is_subvolume_cleaned(int fd, u64 subvolid)
 {
@@ -113,6 +116,8 @@ static const char * const cmd_subvol_create_usage[] = {
 	"",
 	"-i <qgroupid>  add the newly created subvolume to a qgroup. This",
 	"               option can be given multiple times.",
+	"-e <type>      encrypt file data in this subvol with <type>",
+	"               as of now only 'aes' type is supported",
 	NULL
 };
 
@@ -127,10 +132,11 @@ static int cmd_subvol_create(int argc, char **argv)
 	char	*dst;
 	struct btrfs_qgroup_inherit *inherit = NULL;
 	DIR	*dirstream = NULL;
+	int	encrypt = 0;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "c:i:v");
+		int c = getopt(argc, argv, "ec:i:v");
 		if (c < 0)
 			break;
 
@@ -149,6 +155,10 @@ static int cmd_subvol_create(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'e':
+			encrypt = 1;
+			/* as of now no optarg just use default encrypt type AES*/
+			break;
 		default:
 			usage(cmd_subvol_create_usage);
 		}
@@ -215,6 +225,10 @@ static int cmd_subvol_create(int argc, char **argv)
 		goto out;
 	}
 
+	if (encrypt && btrfs_set_subvol_encrypt(dst))
+		fprintf(stderr,
+			"Failed to set encrypt flag, try using property command\n");
+
 	retval = 0;	/* success */
 out:
 	close_file_or_dir(fddst, dirstream);
@@ -225,16 +239,6 @@ out:
 	return retval;
 }
 
-static int wait_for_commit(int fd)
-{
-	int ret;
-
-	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
-	if (ret < 0)
-		return ret;
-	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
-}
-
 static const char * const cmd_subvol_delete_usage[] = {
 	"btrfs subvolume delete [options] <subvolume> [<subvolume>...]",
 	"Delete subvolume(s)",
@@ -911,6 +915,9 @@ static int cmd_subvol_show(int argc, char **argv)
 	int fd = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL;
+	key_serial_t key_serial;
+	char key_algo[BTRFS_KEY_ALGO_MAX_LEN + 1];
+	char key_tag[BTRFS_KEY_TAG_MAX_LEN + 1];
 
 	clean_args_no_options(argc, argv, cmd_subvol_show_usage);
 
@@ -921,7 +928,7 @@ static int cmd_subvol_show(int argc, char **argv)
 	if (!fullpath) {
 		error("cannot find real path for '%s': %s",
 			argv[optind], strerror(errno));
-		goto out;
+		return ret;
 	}
 
 	ret = btrfs_get_subvol_info(fullpath, &get_ri);
@@ -931,6 +938,7 @@ static int cmd_subvol_show(int argc, char **argv)
 							fullpath, strerror(ret)):
 			fprintf(stderr, "Failed to get subvol info %s: %d\n",
 							fullpath, ret);
+		free(fullpath);
 		return ret;
 	}
 
@@ -976,6 +984,23 @@ static int cmd_subvol_show(int argc, char **argv)
 	else
 		printf("\tFlags: \t\t\t-\n");
 
+	key_serial = 0;
+	memset(key_algo, '\0', BTRFS_KEY_ALGO_MAX_LEN + 1);
+	memset(key_tag, '\0', BTRFS_KEY_TAG_MAX_LEN + 1);
+
+	ret = btrfs_subvol_key_info(fullpath, key_algo, key_tag, &key_serial);
+	if (strlen(key_tag)) {
+		char key_state[256] = {0};
+		if (key_serial == -1)
+			snprintf(key_state, 256, "(%s)", strerror(-ret));
+		else
+			snprintf(key_state, 256, "(%d)", key_serial);
+
+		printf("\tEncryption: \t\t%s@%s %s\n", key_algo, key_tag, key_state);
+	} else {
+		printf("\tEncryption: \t\t%s\n", "none");
+	}
+
 	/* print the snapshots of the given subvol if any*/
 	printf("\tSnapshot(s):\n");
 	filter_set = btrfs_list_alloc_filter_set();
@@ -990,19 +1015,72 @@ static int cmd_subvol_show(int argc, char **argv)
 	}
 	btrfs_list_subvols_print(fd, filter_set, NULL, BTRFS_LIST_LAYOUT_RAW,
 			1, raw_prefix);
+	btrfs_list_free_filter_set(filter_set);
+	close_file_or_dir(fd, dirstream1);
 
 out:
 	/* clean up */
 	free(get_ri.path);
 	free(get_ri.name);
 	free(get_ri.full_path);
-	btrfs_list_free_filter_set(filter_set);
 
-	close_file_or_dir(fd, dirstream1);
 	free(fullpath);
 	return !!ret;
 }
 
+static const char * const cmd_subvol_encrypt_usage[] = {
+	"btrfs subvolume encrypt <option> <subvol-path>",
+	"Encryption key login / logout",
+	"-k|--key <in|out>     Key login or logout",
+	NULL
+};
+
+static int cmd_subvol_encrypt(int argc, char **argv)
+{
+	int ret;
+	int login;
+	optind = 1;
+
+	login = 1;
+	while (1) {
+		int c;
+		static const struct option long_options[] = {
+			{ "key", required_argument, NULL, 'k'},
+			{ NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long(argc, argv, "k:", long_options, NULL);
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'k':
+			if (!strcmp("in", optarg))
+				login = 1;
+			else if (!strcmp("out", optarg))
+				login = 0;
+			else
+				usage(cmd_subvol_encrypt_usage);
+			break;
+		default:
+			usage(cmd_subvol_encrypt_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_subvol_encrypt_usage);
+
+	if (login)
+		ret = cmd_encrypt_login(argc - 1, &argv[1]);
+	else
+		ret = cmd_encrypt_logout(argc - 1, &argv[1]);
+
+	if (ret == -EAGAIN)
+		usage(cmd_subvol_encrypt_usage);
+
+	return ret;
+}
+
 static const char * const cmd_subvol_sync_usage[] = {
 	"btrfs subvolume sync <path> [<subvol-id>...]",
 	"Wait until given subvolume(s) are completely removed from the filesystem.",
@@ -1270,6 +1348,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "find-new", cmd_subvol_find_new, cmd_subvol_find_new_usage,
 			NULL, 0 },
 		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
+		{ "encrypt", cmd_subvol_encrypt, cmd_subvol_encrypt_usage, NULL, 0 },
 		{ "sync", cmd_subvol_sync, cmd_subvol_sync_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
diff --git a/commands.h b/commands.h
index 2da093bf81a3..3199424bbe77 100644
--- a/commands.h
+++ b/commands.h
@@ -88,6 +88,7 @@ extern const struct cmd_group subvolume_cmd_group;
 extern const struct cmd_group filesystem_cmd_group;
 extern const struct cmd_group balance_cmd_group;
 extern const struct cmd_group device_cmd_group;
+extern const struct cmd_group encrypt_cmd_group;
 extern const struct cmd_group scrub_cmd_group;
 extern const struct cmd_group inspect_cmd_group;
 extern const struct cmd_group property_cmd_group;
diff --git a/encrypt.c b/encrypt.c
new file mode 100644
index 000000000000..a88fa00ba39c
--- /dev/null
+++ b/encrypt.c
@@ -0,0 +1,383 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/xattr.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <uuid/uuid.h>
+#include <keyutils.h>
+#include <libscrypt.h>
+#include <termios.h>
+#include <keyutils.h>
+
+#include "ctree.h"
+#include "commands.h"
+#include "utils.h"
+#include "props.h"
+#include "encrypt.h"
+#include "subvolume.h"
+
+#ifndef XATTR_BTRFS_PREFIX
+#define XATTR_BTRFS_PREFIX     "btrfs."
+#define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
+#endif
+
+/*
+ * Defined as synonyms in attr/xattr.h
+ */
+#ifndef ENOATTR
+#define ENOATTR ENODATA
+#endif
+
+ssize_t __get_pass(char *prompt, char **lineptr, size_t *n)
+{
+	struct termios old, new;
+	int nread;
+
+	fprintf(stderr, "%s", prompt);
+	fflush(stderr);
+
+	/* Turn echoing off and fail if we can’t. */
+	if (tcgetattr(fileno(stdin), &old) != 0)
+		return -1;
+
+	new = old;
+	new.c_lflag &= ~ECHO;
+	if (tcsetattr(fileno(stdin), TCSAFLUSH, &new) != 0)
+		return -1;
+
+	/* Read the password. */
+	nread = getline(lineptr, n, stdin);
+
+	/* Restore terminal. */
+	tcsetattr(fileno(stdin), TCSAFLUSH, &old);
+
+	return nread;
+}
+
+/*
+ * If key is set, returns its key_serial, otherwise -1
+ */
+int ask_key_for_keytag(char *keytag, key_serial_t *keyserial)
+{
+	size_t sz;
+	int retry;
+	char pass_try1[100];
+	unsigned char pass_key[16];
+	size_t tmp_sz;
+	char *pass = pass_try1;
+	const unsigned char salt[100] = {"btrfs"};
+	int ret = 0;
+
+	tmp_sz = sizeof(pass_try1);
+	retry = 4;
+	while (--retry > 0) {
+		sz = __get_pass("Paraphrase: ", &pass, &tmp_sz);
+		if (!sz || sz == 1) {
+			fprintf(stderr, " Password can not be empty, pls try again\n");
+			continue;
+		}
+		break;
+	}
+	if (retry == 0)
+		return -ECANCELED;
+
+	printf("\n");
+	if (libscrypt_scrypt((uint8_t *)pass_try1, sz, salt, sizeof(salt),
+					SCRYPT_N, SCRYPT_r, SCRYPT_p, pass_key, 16)) {
+		fprintf(stderr, "scrypt failed: cannot derive passphrase\n");
+		return -EFAULT;
+	}
+
+	*keyserial = add_key("user", keytag, pass_key, 16, KEY_SPEC_USER_KEYRING);
+	if (*keyserial == -1) {
+		ret = -errno;
+		return ret;
+	}
+
+	return 0;
+}
+
+void btrfs_create_keytag(char *keytag, char *subvol)
+{
+	key_serial_t keyserial;
+	struct root_info get_ri;
+	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
+
+	btrfs_get_subvol_info(subvol, &get_ri);
+	uuid_unparse(get_ri.uuid, uuidparse);
+	uuidparse[8] = '\0';
+	sprintf(keytag, "btrfs:%s", uuidparse);
+
+	ask_key_for_keytag(keytag, &keyserial);
+}
+
+void btrfs_create_encrypt_keytag_tuplet(char *keystr,
+			const char *encrypt_type, char *keytag)
+{
+	int len;
+
+	len = snprintf(keystr, 256, "%s@%s", encrypt_type, keytag);
+	keystr[len] = '\0';
+}
+
+/*
+ * This probably should be as a property, however the property interface
+ * needs redesign, so as of now its part of subvolume create
+ */
+static int __prop_encrypt(enum prop_object_type type, const char *object,
+			const char *name, const char *value, char *value_out)
+{
+	int ret;
+	ssize_t sret;
+	int fd = -1;
+	DIR *dirstream = NULL;
+	char buf[BTRFS_KEY_ALGO_TAG_MAX_LEN];
+	char *xattr_name = NULL;
+	int open_flags = value ? O_RDWR : O_RDONLY;
+	char keytag[16] = {0};
+	char *tmp_object = strdup(object);
+
+	ret = 0;
+	fd = open_file_or_dir3(object, &dirstream, open_flags);
+	if (fd == -1) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+						object, strerror(-ret));
+		goto out;
+	}
+
+	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name) + 1);
+	if (!xattr_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
+	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
+	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
+
+	if (value) {
+		char keystr[BTRFS_KEY_ALGO_TAG_MAX_LEN];
+		memset(keystr, '\0', BTRFS_KEY_ALGO_TAG_MAX_LEN);
+
+		if (strlen(value)) {
+			btrfs_create_keytag(keytag, tmp_object);
+			btrfs_create_encrypt_keytag_tuplet(keystr, value, keytag);
+		}
+		sret = fsetxattr(fd, xattr_name, keystr, strlen(keystr), 0);
+		if (sret) {
+			ret = -errno;
+			goto out;
+		}
+	} else {
+		sret = fgetxattr(fd, xattr_name, buf, BTRFS_KEY_ALGO_TAG_MAX_LEN);
+		ret = -errno;
+		if (sret < 0 && errno == ENOATTR)
+			goto out;
+
+		if (sret < 0)
+			goto out;
+
+		ret = 0;
+		buf[sret] = '\0';
+		if (value_out)
+			strncpy(value_out, buf, BTRFS_KEY_ALGO_TAG_MAX_LEN);
+	}
+
+out:
+	kfree(tmp_object);
+	kfree(xattr_name);
+	if (fd >= 0)
+		close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
+int prop_encrypt(enum prop_object_type type, const char *object,
+			const char *name, const char *value)
+{
+	if (value) {
+		fprintf(stderr, "Property set is not allowed at this time\n");
+		return 0;
+	}
+	return 	__prop_encrypt(type, object, name, value, NULL);
+}
+
+int btrfs_set_subvol_encrypt(char *subvol)
+{
+	int ret;
+
+	ret = __prop_encrypt(prop_object_subvol, subvol, "encrypt", "aes", NULL);
+
+	return ret;
+}
+
+int btrfs_get_subvol_encrypt(char *subvol, char *value_out)
+{
+	int ret;
+
+	ret = __prop_encrypt(prop_object_subvol, subvol, "encrypt", NULL, value_out);
+
+	return ret;
+}
+
+static int split_key_alog_tag(const char *val, size_t len,
+                                        char *keyalgo, char *keytag)
+{
+	char *tmp;
+	char *tmp1;
+	char *tmp2;
+
+	tmp1 = tmp = strdup(val);
+	tmp[len] = '\0';
+
+	tmp2 = strsep(&tmp, "@");
+	if (!tmp2) {
+		kfree(tmp1);
+		return -EINVAL;
+	}
+
+	if (strlen(tmp2) > BTRFS_KEY_ALGO_MAX_LEN ||
+		strlen(tmp) > BTRFS_KEY_TAG_MAX_LEN) {
+		kfree(tmp1);
+		return -EINVAL;
+	}
+
+	if (keyalgo)
+		strcpy(keyalgo, tmp2);
+	if (keytag)
+		strcpy(keytag, tmp);
+
+	kfree(tmp1);
+	return 0;
+}
+
+int btrfs_subvol_key_info(char *subvol, char *key_algo, char *key_tag,
+						key_serial_t *key_serial)
+{
+	int ret;
+	char key_algo_tag[BTRFS_KEY_ALGO_TAG_MAX_LEN];
+
+	ret = btrfs_get_subvol_encrypt(subvol, key_algo_tag);
+	if (ret) {
+		#if 0
+		fprintf(stderr, "ERROR: non encrypted subvolume %s: %s\n",
+						subvol, strerror(-ret));
+		fprintf(stderr,
+			"       use 'btrfs subvolume create -e <subvol>' to create an encrypted subvolume\n");
+		#endif
+		return ret;
+	}
+
+	ret = split_key_alog_tag(key_algo_tag, strlen(key_algo_tag), key_algo, key_tag);
+	if (ret) {
+		fprintf(stderr, "ERROR: failed to parse key_tag in %s: %d\n",
+			key_algo_tag, ret);
+		return ret;
+	}
+
+	*key_serial = request_key("user", key_tag, NULL, 0);
+	if (*key_serial == -1) {
+		ret = -errno;
+		if (ret == -ENOKEY || ret == -EKEYEXPIRED || ret == -EKEYREVOKED)
+			ret = -ENOKEY;
+		return ret;
+	}
+
+	return 0;
+}
+
+int cmd_encrypt_login(int argc, char **argv)
+{
+	int ret;
+	char pr[10];
+	char *subvol;
+	key_serial_t keyserial;
+	char key_algo[BTRFS_KEY_ALGO_MAX_LEN + 1];
+	char key_tag[BTRFS_KEY_TAG_MAX_LEN + 1];
+
+	ret = 0;
+	keyserial = 0;
+	strcpy(pr, "already");
+
+#if 0
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_encrypt_login_usage);
+#endif
+
+	subvol = argv[argc - 1];
+
+	ret = btrfs_subvol_key_info(subvol, key_algo, key_tag, &keyserial);
+	if (ret && ret != -ENOKEY) {
+		fprintf(stderr, "ERROR: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	if (keyserial == -1) {
+		strcpy(pr, "");
+
+		wait_for_commit_subvol(subvol);
+		ret = ask_key_for_keytag(key_tag, &keyserial);
+		if (ret) {
+			fprintf(stderr, "ERROR: key add failed: %s\n", strerror(-ret));
+			return ret;
+		}
+	}
+
+	fprintf(stderr,
+		"key for '%s' has %s logged in with keytag '%s' keyserial '%d'\n",
+		subvol, pr, key_tag, keyserial);
+
+	return 0;
+}
+
+int cmd_encrypt_logout(int argc, char **argv)
+{
+	int ret;
+	char *subvol;
+	key_serial_t keyserial;
+	char key_tag[BTRFS_KEY_TAG_MAX_LEN + 1];
+	char key_algo[BTRFS_KEY_ALGO_MAX_LEN + 1];
+
+#if 0
+	if (check_argc_exact(argc - optind, 1))
+		usage(cmd_encrypt_login_usage);
+#endif
+
+	subvol = argv[argc - 1];
+
+	ret = btrfs_subvol_key_info(subvol, key_algo, key_tag, &keyserial);
+	if (ret) {
+		fprintf(stderr, "ERROR: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	/*
+	 * Bit loosely coupled as of now, fixme
+	 * ask kernel to revoke, but user could use keyctl in the userspace
+	 * not too sure if using this
+	 *    down_write_nested(&btrfs_subvol_key->sem, 1)
+	 * in the kernel so that user spce can't revoke is a good idea.
+	 */
+	wait_for_commit_subvol(subvol);
+	keyctl(KEYCTL_REVOKE, keyserial);
+	return 0;
+}
+
diff --git a/encrypt.h b/encrypt.h
new file mode 100644
index 000000000000..070e02c77bf7
--- /dev/null
+++ b/encrypt.h
@@ -0,0 +1,33 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+#include "props.h"
+
+#define	BTRFS_KEY_TAG_MAX_LEN		16
+#define	BTRFS_KEY_ALGO_MAX_LEN		16
+#define BTRFS_KEY_ALGO_TAG_MAX_LEN	(BTRFS_KEY_TAG_MAX_LEN + BTRFS_KEY_ALGO_MAX_LEN)
+
+void btrfs_create_keytag(char *keytag, char *subvol);
+void btrfs_create_encrypt_keytag_tuplet(char *keystr,
+			const char *encrypt_type, char *keytag);
+int btrfs_set_subvol_encrypt(char *subvol);
+int btrfs_get_subvol_encrypt(char *subvol, char *val_out);
+int prop_encrypt(enum prop_object_type type, const char *object,
+			const char *name, const char *value);
+int ask_key_for_keytag(char *keytag, key_serial_t *keyserial);
+int btrfs_subvol_key_info(char *subvol, char *key_algo, char *key_tag,
+						key_serial_t *key_serial);
+int cmd_encrypt_login(int argc, char **argv);
+int cmd_encrypt_logout(int argc, char **argv);
diff --git a/props.c b/props.c
index 5b7493240b09..2b6e81fbd541 100644
--- a/props.c
+++ b/props.c
@@ -20,11 +20,13 @@
 #include <sys/xattr.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <keyutils.h>
 
 #include "ctree.h"
 #include "commands.h"
 #include "utils.h"
 #include "props.h"
+#include "encrypt.h"
 
 #define XATTR_BTRFS_PREFIX     "btrfs."
 #define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
@@ -194,5 +196,6 @@ const struct prop_handler prop_handlers[] = {
 	 prop_object_dev | prop_object_root, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, prop_compression},
+	{"encrypt", "read encrypt property value", 0, prop_object_inode, prop_encrypt},
 	{NULL, NULL, 0, 0, NULL}
 };
diff --git a/subvolume.h b/subvolume.h
index ceacf603e01c..92ca7cd28912 100644
--- a/subvolume.h
+++ b/subvolume.h
@@ -18,3 +18,5 @@
 int btrfs_get_subvol_info(char *fullpath, struct root_info *get_ri);
 int test_issubvolume(const char *path);
 char *get_subvol_name(char *mnt, char *full_path);
+int wait_for_commit(int fd);
+int wait_for_commit_subvol(char *subvol);
-- 
2.7.0

