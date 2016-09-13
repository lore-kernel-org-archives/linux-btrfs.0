Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24938 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757879AbcIMNir (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 09:38:47 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: add encryption support
Date: Tue, 13 Sep 2016 21:39:49 +0800
Message-Id: <1473773990-3071-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on v4.7.2

Depends on keyctl-utils and libscrypt packages.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Makefile.in       |   5 +-
 btrfs-list.c      |  23 +++
 cmds-filesystem.c |   4 +-
 cmds-restore.c    |  16 ++
 cmds-subvolume.c  | 101 +++++++++++-
 commands.h        |   1 +
 ctree.h           |   5 +-
 encrypt.c         | 455 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 encrypt.h         |  46 ++++++
 props.c           |   4 +
 utils.h           |   1 +
 11 files changed, 654 insertions(+), 7 deletions(-)
 create mode 100644 encrypt.c
 create mode 100644 encrypt.h

diff --git a/Makefile.in b/Makefile.in
index fd68b3eeeba7..6e857b763213 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -44,7 +44,8 @@ DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 BTRFSCONVERT_EXT2 = @BTRFSCONVERT_EXT2@
 
 EXTRA_CFLAGS :=
-EXTRA_LDFLAGS :=
+# asj fixme, remove path hardcode
+EXTRA_LDFLAGS := /usr/lib/libscrypt.so.0 /usr/lib/libkeyutils.so
 
 DEBUG_CFLAGS_DEFAULT = -O0 -U_FORTIFY_SOURCE -ggdb3
 DEBUG_CFLAGS_INTERNAL =
@@ -87,7 +88,7 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
 	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
 	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
-	  inode.o file.o find-root.o free-space-tree.o help.o
+	  inode.o file.o find-root.o free-space-tree.o help.o encrypt.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
 	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
diff --git a/btrfs-list.c b/btrfs-list.c
index 4e67fe28b9b5..34722731b652 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1923,3 +1923,26 @@ int wait_for_commit(int fd)
 		return ret;
 	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
 }
+
+/*
+ * Fixme: A kind of workaround as of now, actual fix needs
+ * per subvol sync instead of entire FS.
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
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 76ea82edf23c..4a866c28420a 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -952,6 +952,8 @@ static int parse_compress_type(char *s)
 		return BTRFS_COMPRESS_ZLIB;
 	else if (strcmp(optarg, "lzo") == 0)
 		return BTRFS_COMPRESS_LZO;
+	else if (strcmp(optarg, "ctr(aes)") == 0)
+		return BTRFS_ENCRYPT_AES;
 	else {
 		error("unknown compression type %s", s);
 		exit(1);
@@ -964,7 +966,7 @@ static const char * const cmd_filesystem_defrag_usage[] = {
 	"",
 	"-v             be verbose",
 	"-r             defragment files recursively",
-	"-c[zlib,lzo]   compress the file while defragmenting",
+	"-c[zlib,lzo,ctr(aes)]  compress/encrypt the file while defragmenting if it wasn't",
 	"-f             flush data to disk immediately after defragmenting",
 	"-s start       defragment only from byte onward",
 	"-l len         defragment only up to len bytes",
diff --git a/cmds-restore.c b/cmds-restore.c
index b491f083b72b..bed0aba77740 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -155,6 +155,19 @@ static int decompress_lzo(struct btrfs_root *root, unsigned char *inbuf,
 	return 0;
 }
 
+static int decrypt_ctr_aes(struct btrfs_root *root, unsigned char *inbuf,
+			char *outbuf, u64 compress_len, u64 *decompress_len)
+{
+	/*
+	 * fixme: This is only for testing, which works only with
+	 * kernel option BTRFS_CRYPTO_TEST_BYDUMMYENC, where
+	 * ciphertext == plaintext
+	 */
+	memcpy(outbuf, inbuf, compress_len);
+	*decompress_len = compress_len;
+	return 0;
+}
+
 static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
 			u64 compress_len, u64 *decompress_len, int compress)
 {
@@ -165,6 +178,9 @@ static int decompress(struct btrfs_root *root, char *inbuf, char *outbuf,
 	case BTRFS_COMPRESS_LZO:
 		return decompress_lzo(root, (unsigned char *)inbuf, outbuf,
 					compress_len, decompress_len);
+	case BTRFS_ENCRYPT_AES:
+		return decrypt_ctr_aes(root, (unsigned char *)inbuf, outbuf,
+					compress_len, decompress_len);
 	default:
 		break;
 	}
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 5df7af56c7f8..452e71755d39 100644
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
@@ -36,6 +38,7 @@
 #include "commands.h"
 #include "utils.h"
 #include "btrfs-list.h"
+#include "encrypt.h"
 
 static int is_subvolume_cleaned(int fd, u64 subvolid)
 {
@@ -104,13 +107,14 @@ static const char * const subvolume_cmd_group_usage[] = {
 };
 
 static const char * const cmd_subvol_create_usage[] = {
-	"btrfs subvolume create [-i <qgroupid>] [<dest>/]<name>",
+	"btrfs subvolume create [-i <qgroupid>] [-e <cipher>] [<dest>/]<name>",
 	"Create a subvolume",
 	"Create a subvolume <name> in <dest>.  If <dest> is not given",
 	"subvolume <name> will be created in the current directory.",
 	"",
 	"-i <qgroupid>  add the newly created subvolume to a qgroup. This",
 	"               option can be given multiple times.",
+	"-e             enable encryption",
 	NULL
 };
 
@@ -125,9 +129,11 @@ static int cmd_subvol_create(int argc, char **argv)
 	char	*dst;
 	struct btrfs_qgroup_inherit *inherit = NULL;
 	DIR	*dirstream = NULL;
+	int	encrypt = 0;
+	char	*cipher_name = NULL;
 
 	while (1) {
-		int c = getopt(argc, argv, "c:i:v");
+		int c = getopt(argc, argv, "e:c:i:v");
 		if (c < 0)
 			break;
 
@@ -146,6 +152,16 @@ static int cmd_subvol_create(int argc, char **argv)
 				goto out;
 			}
 			break;
+		case 'e':
+			encrypt = 1;
+			if (!is_encryption_type_supported(optarg)) {
+				error("Unsupported cipher '%s', check '/proc/crypto'\n",
+					optarg);
+				retval = -EPROTONOSUPPORT;
+				goto out;
+			}
+			cipher_name = strdup(optarg);
+			break;
 		default:
 			usage(cmd_subvol_create_usage);
 		}
@@ -212,6 +228,13 @@ static int cmd_subvol_create(int argc, char **argv)
 		goto out;
 	}
 
+	if (encrypt) {
+		res = btrfs_set_subvol_encrypt(dst, cipher_name);
+		if (res)
+		warning("Subvol is created, but failed to enable encryption: %s\n",
+							strerror(-res));
+	}
+
 	retval = 0;	/* success */
 out:
 	close_file_or_dir(fddst, dirstream);
@@ -901,6 +924,9 @@ static int cmd_subvol_show(int argc, char **argv)
 	int fd = -1;
 	int ret = 1;
 	DIR *dirstream1 = NULL;
+	key_serial_t key_serial;
+	char key_algo[BTRFS_KEY_ALGO_MAX_LEN + 1];
+	char key_tag[BTRFS_KEY_TAG_MAX_LEN + 1];
 
 	clean_args_no_options(argc, argv, cmd_subvol_show_usage);
 
@@ -978,6 +1004,23 @@ static int cmd_subvol_show(int argc, char **argv)
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
@@ -1005,6 +1048,59 @@ out:
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
@@ -1272,6 +1368,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "find-new", cmd_subvol_find_new, cmd_subvol_find_new_usage,
 			NULL, 0 },
 		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
+		{ "encrypt", cmd_subvol_encrypt, cmd_subvol_encrypt_usage, NULL, 0 },
 		{ "sync", cmd_subvol_sync, cmd_subvol_sync_usage, NULL, 0 },
 		NULL_CMD_STRUCT
 	}
diff --git a/commands.h b/commands.h
index 94229c112bc0..ece721da37a1 100644
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
diff --git a/ctree.h b/ctree.h
index 1d153ec5c784..67ed34bbb28a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -656,8 +656,9 @@ typedef enum {
 	BTRFS_COMPRESS_NONE  = 0,
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
-	BTRFS_COMPRESS_TYPES = 2,
-	BTRFS_COMPRESS_LAST  = 3,
+	BTRFS_ENCRYPT_AES    = 3,
+	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_LAST  = 4,
 } btrfs_compression_type;
 
 /* we don't understand any encryption methods right now */
diff --git a/encrypt.c b/encrypt.c
new file mode 100644
index 000000000000..2ceeb5b395b2
--- /dev/null
+++ b/encrypt.c
@@ -0,0 +1,455 @@
+/*
+ * Copyright (C) 2016 Oracle.  All rights reserved.
+ * Author: Anand Jain (anand.jain@oracle.com)
+ *
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
+int get_key(char *keytag, key_serial_t *keyserial)
+{
+	size_t sz;
+	int retry;
+	int retry_again;
+	char pass_try1[100];
+	char pass_try2[100];
+	unsigned char pass_key[16];
+	size_t in_sz;
+	char *pass;
+	const unsigned char iv[100] = {"btrfs"};
+	int ret = 0;
+	int not_same = 0;
+
+	retry_again = 3;
+again:
+	pass = pass_try1;
+	in_sz = sizeof(pass_try1);
+	retry = 4;
+
+	while (--retry > 0) {
+		sz = __get_pass("Passphrase: ", &pass, &in_sz);
+		if (!sz || sz == 1) {
+			printf("\n");
+			error(" Password can not be empty, pls try again");
+			continue;
+		}
+		break;
+	}
+	if (retry == 0)
+		return -ECANCELED;
+
+	pass = pass_try2;
+	in_sz = sizeof(pass_try1);
+
+	printf("\n");
+	sz = __get_pass("Again passphrase: ", &pass, &in_sz);
+	printf("\n");
+	not_same = strncmp(pass_try1, pass_try2, sz);
+	if (not_same) {
+		error("Password does not match\n");
+		if (! --retry_again)
+			return -ECANCELED;
+		goto again;
+	}
+
+	ret = libscrypt_scrypt((uint8_t *)pass_try1, sz, iv, sizeof(iv),
+				SCRYPT_N, SCRYPT_r, SCRYPT_p, pass_key, 16);
+	if (ret) {
+		error("scrypt failed, cannot derive passphrase: %d\n", ret);
+		return -EFAULT;
+	}
+
+	*keyserial = add_key(BTRFS_CRYPTO_KEY_TYPE, keytag, pass_key,
+				BTRFS_CRYPTO_KEY_SIZE, KEY_SPEC_USER_KEYRING);
+	if (*keyserial == -1) {
+		ret = -errno;
+		return ret;
+	}
+
+	return 0;
+}
+
+static void generate_keytag(char *keytag, char *subvol)
+{
+	struct root_info get_ri;
+	char uuidparse[BTRFS_UUID_UNPARSED_SIZE];
+
+	get_subvol_info(subvol, &get_ri);
+	uuid_unparse(get_ri.uuid, uuidparse);
+	uuidparse[8] = '\0';
+	sprintf(keytag, "btrfs:%s", uuidparse);
+}
+
+void prefix_cipher_name(char *keystr,
+			const char *encrypt_type, char *keytag)
+{
+	int sz = BTRFS_KEY_ALGO_TAG_MAX_LEN + 1;
+
+	snprintf(keystr, sz, "%s@%s", encrypt_type, keytag);
+}
+
+int is_encryption_type_supported(const char *type)
+{
+	FILE *f;
+	char tmp[512];
+	const char *known_str = "name         : ";
+	int klen = 15;
+
+	if (strlen(type) > BTRFS_KEY_ALGO_MAX_LEN)
+		return -EINVAL;
+
+	if ((f = fopen("/proc/crypto", "r")) == NULL) {
+		error("Failed to open '/proc/crypto': %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	while (fgets(tmp, sizeof(tmp), f) != NULL) {
+		if (!strncmp(known_str, tmp, klen)) {
+			if (!strncmp(tmp+klen, type, strlen(type) )) {
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * This probably should be as a property, however the property interface
+ * needs redesign, so as of now its part of subvolume create
+ */
+static int handle_prop_encrypt(enum prop_object_type type, const char *object,
+			const char *name, const char *value, char *value_out)
+{
+	int ret;
+	ssize_t sret;
+	int fd = -1;
+	DIR *dirstream = NULL;
+	char buf[BTRFS_KEY_ALGO_TAG_MAX_LEN];
+	char *xattr_name = NULL;
+	int open_flags = value ? O_RDWR : O_RDONLY;
+	char keytag[BTRFS_KEY_TAG_MAX_LEN + 1] = {0};
+	char *subvol_object = strdup(object);
+	key_serial_t keyserial;
+	char keystr[BTRFS_KEY_ALGO_TAG_MAX_LEN];
+	memset(keystr, '\0', BTRFS_KEY_ALGO_TAG_MAX_LEN);
+
+	ret = 0;
+	fd = open_file_or_dir3(object, &dirstream, open_flags);
+	if (fd == -1) {
+		ret = -errno;
+		error("open %s failed. %s\n", object, strerror(-ret));
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
+	if (value_out) {
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
+
+		strncpy(value_out, buf, BTRFS_KEY_ALGO_TAG_MAX_LEN);
+
+		goto out;
+	}
+
+	if (value && !is_encryption_type_supported(value)) {
+		error("Cipher '%s' is not supported\n", value);
+		ret = -EPROTONOSUPPORT;
+		goto out;
+	}
+
+	generate_keytag(keytag, subvol_object);
+	ret = get_key(keytag, &keyserial);
+	if (ret) {
+		error("Failed to create a key: %s\n",
+					strerror(-ret));
+		goto out;
+	}
+
+	prefix_cipher_name(keystr, value, keytag);
+
+	sret = fsetxattr(fd, xattr_name, keystr, strlen(keystr), 0);
+	if (sret) {
+		ret = -errno;
+		error("failed to set attribute '%s' to '%s' : %s\n",
+				xattr_name, keystr, strerror(-ret));
+		keyctl(KEYCTL_REVOKE, keyserial);
+		goto out;
+	}
+
+out:
+	kfree(subvol_object);
+	kfree(xattr_name);
+	if (fd >= 0)
+		close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
+int prop_encrypt(enum prop_object_type type, const char *object,
+				const char *name, const char *value)
+{
+	int ret;
+
+	if (value) {
+		ret = handle_prop_encrypt(type, object, name, value, NULL);
+	} else {
+		char val_out[256] = {0};
+		ret = handle_prop_encrypt(type, object, name, NULL, val_out);
+		if (!ret)
+			fprintf(stdout, "%s\n", val_out);
+	}
+	return ret;
+}
+
+int btrfs_set_subvol_encrypt(char *subvol, char *cipher_name)
+{
+	int ret;
+
+	ret = handle_prop_encrypt(prop_object_subvol, subvol,
+					"encrypt", cipher_name, NULL);
+
+	return ret;
+}
+
+int btrfs_get_subvol_encrypt(char *subvol, char *value_out)
+{
+	int ret;
+
+	ret = handle_prop_encrypt(prop_object_subvol, subvol,
+					"encrypt", NULL, value_out);
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
+		error("non encrypted subvolume %s: %s\n",
+						subvol, strerror(-ret));
+		error( "use 'btrfs subvolume create -e 'cipher' <subvol>'\
+					to create an encrypted subvolume\n");
+		#endif
+		return ret;
+	}
+
+	ret = split_key_alog_tag(key_algo_tag, strlen(key_algo_tag),
+						key_algo, key_tag);
+	if (ret) {
+		error("failed to parse key_tag in %s: %d\n",
+			key_algo_tag, ret);
+		return ret;
+	}
+
+	*key_serial = request_key(BTRFS_CRYPTO_KEY_TYPE, key_tag, NULL, 0);
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
+	char key_algo[BTRFS_KEY_ALGO_MAX_LEN + 1] = "";
+	char key_tag[BTRFS_KEY_TAG_MAX_LEN + 1] = "";
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
+		error("%s\n", strerror(-ret));
+		return ret;
+	}
+
+	if (keyserial == -1) {
+		pr[0] = '\0';
+
+		wait_for_commit_subvol(subvol);
+
+		ret = btrfs_set_subvol_encrypt(subvol, key_algo);
+		if (ret) {
+			error("key set failed: %s\n", strerror(-ret));
+			return ret;
+		}
+	}
+
+	fprintf(stdout,
+		"key for '%s' has %s logged in with keytag '%s'\n",
+		subvol, pr, key_tag);
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
diff --git a/encrypt.h b/encrypt.h
new file mode 100644
index 000000000000..6dbbd1e34d00
--- /dev/null
+++ b/encrypt.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2016 Oracle.  All rights reserved.
+ * Author: Anand Jain (anand.jain@oracle.com)
+ *
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
+#define BTRFS_CRYPTO_KEY_TYPE_LOGON	1
+#if BTRFS_CRYPTO_KEY_TYPE_LOGON
+#define BTRFS_CRYPTO_KEY_TYPE "logon"
+#else
+#define BTRFS_CRYPTO_KEY_TYPE "user"
+#endif
+
+#define BTRFS_CRYPTO_KEY_SIZE		16
+#define	BTRFS_KEY_TAG_MAX_LEN		16
+#define	BTRFS_KEY_ALGO_MAX_LEN		16
+#define BTRFS_KEY_ALGO_TAG_MAX_LEN	(BTRFS_KEY_TAG_MAX_LEN + BTRFS_KEY_ALGO_MAX_LEN)
+
+void btrfs_create_keytag(char *keytag, char *subvol);
+void btrfs_create_encrypt_keytag_tuplet(char *keystr,
+			const char *encrypt_type, char *keytag);
+int btrfs_set_subvol_encrypt(char *subvol, char *val_in);
+int btrfs_get_subvol_encrypt(char *subvol, char *val_out);
+int prop_encrypt(enum prop_object_type type, const char *object,
+			const char *name, const char *value);
+int ask_key_for_keytag(char *keytag, key_serial_t *keyserial);
+int btrfs_subvol_key_info(char *subvol, char *key_algo, char *key_tag,
+						key_serial_t *key_serial);
+int cmd_encrypt_login(int argc, char **argv);
+int cmd_encrypt_logout(int argc, char **argv);
+int is_encryption_type_supported(const char *type);
+int btrfs_set_subvol_encrypt(char *subvol, char *cipher_name);
diff --git a/props.c b/props.c
index a7e3e96bc92e..c08c71944d01 100644
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
@@ -190,5 +192,7 @@ const struct prop_handler prop_handlers[] = {
 	 prop_object_dev | prop_object_root, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, prop_compression},
+	{"encrypt", "set/get encrypt property value", 0,
+	prop_object_subvol, prop_encrypt},
 	{NULL, NULL, 0, 0, NULL}
 };
diff --git a/utils.h b/utils.h
index 729e50a113a2..dcc911f9a615 100644
--- a/utils.h
+++ b/utils.h
@@ -226,6 +226,7 @@ int test_isdir(const char *path);
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
 int get_subvol_info(const char *fullpath, struct root_info *get_ri);
 int wait_for_commit(int fd);
+int wait_for_commit_subvol(char *subvol);
 
 /*
  * Btrfs minimum size calculation is complicated, it should include at least:
-- 
2.7.0

