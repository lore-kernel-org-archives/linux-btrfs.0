Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F6AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE0320821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AJXFBaxq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfAIB1X (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37382 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfAIB1X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id s12so6030200wrt.4;
        Tue, 08 Jan 2019 17:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNfgMS2FdrskFCrIFoU6LVjG6ccUx2jxBmkA2wTD2OA=;
        b=AJXFBaxqgu+BiQoRLdRAHVLyRhUqUV5w247wKcdKgSAVBdE3RBkWZ+uJjLDB4Whz+h
         j6g8g8oe2HppWVr3co87LuGZuTdUC/8ypPKnuzLQbqOR94EjaHeUtQoVuEihPsXi5fQl
         4UeLaKJ1LVkeo9dbl8p2Y+gxdUaHmMn56rcpN8yEzi4RjlekLE2z+b4a3aNGAOTFCktK
         g2Yy9Yij2ZxFffEpaYLO53Vold3TiTGtLKWEc+9tilzQKd6wrpkq/QAM/0swrhYNKCKB
         M4XzmzmzxTzMarL3Kn1CoK5EPykoMz9SKipRKJsNgQqjHtDyqkjsrxPHmMcJ20VSAsbE
         F0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=dNfgMS2FdrskFCrIFoU6LVjG6ccUx2jxBmkA2wTD2OA=;
        b=Cx3Ky8HLmpDsMIVDZgN1rL8FYp57a9tl3shoa4B+td9LQD5NzBzVqTpYlCoZPSUjHx
         /iPG0SmFZDCqwEXzV0zDeOebK0F98/GnHferE3TeHwnUfJgFu4M/jWXfYTOGm6Y35Bbz
         KzeYb6dML2sUQsfud1HovW5WFHt5ln4PapfSjZ6V98rs5lphqpeMcIXfFkfa6ejhkKlv
         agMcUuMwZtFCoxCKFQWHtPi1JFY8RZXLxYyX4stRn7N9/HbVisFQd8fpmMTX1uWYl8nk
         ZSvHcRHZVN2L0k8tnScPIAnhCQQe82ew4dPuHPypV+5EBsyk+xr3SI8xRgVPjcE7NAvQ
         AgNw==
X-Gm-Message-State: AJcUukfYFVu8gRRio58agKIJxrDjgCfXVkqoYy4MKdjahPujepoZGHXE
        KnnwHnX/3EitDhW1McYnSHKvn6lIVBU=
X-Google-Smtp-Source: ALg8bN6YdTeXHcD5DO2i90brD3m9oD8xciAu5UxGifiTCay8fyDKsaELhLevapWA0S34M+N0gECMVQ==
X-Received: by 2002:adf:c505:: with SMTP id q5mr3131309wrf.84.1546997240640;
        Tue, 08 Jan 2019 17:27:20 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:20 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/19] btrfs: add encryption structs and constants
Date:   Wed,  9 Jan 2019 01:26:43 +0000
Message-Id: <20190109012701.26441-1-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a series of patches to add per-extent AES encryption to Btrfs. Unlike
previous attempts, this isn't implemented by adding a new compression type,
meaning that extents that are both encrypted and compressed should work fine.

It's implemented by adding a 8-byte key number and a 16-byte
randomized initialization vector to the end of the BTRFS_EXTENT_DATA_KEY (which
for inline extents means immediately before the encrypted data). The key number
is an index into the new key root, which stores the password hashes, with the
key number doubling as the salt. This means that (unlike, AIUI, ext4), there's
no chance that a file by can be decrypted using the wrong key.

The ioctl BTRFS_IOC_GET_KEY_SALT provides the key number for a given password,
or if not present adds a new key with a randomized number.

We use AES in counter mode, so that we can do random reads without having to
read the whole extent.

Some notes:

* At the moment COW is forced for encrypted extents, meaning that preallocation
and the nocow option don't have any effect.

* Direct IO is disabled for encrypted extents. Direct reading should be
possible, as you'd do the decryption after the bio returns. I'm not sure direct
writing is feasible though, as you'd either have to copy the buffer or change
the process's memory.

* Once a key is added by keyctl, it persists until the FS is unmounted. Ideally
we'd like it to be removed when unlinked or revoked.

* We don't use fscrypt - I understand that the XTS mode that it operates in
means that sectors are keyed to their logical address, which would break
balancing.

* Sending still dumps unencrypted data, and won't work on encrypted
files without the key. We could change this, but it raises the possibility that
the same password could correspond to multiple keys.

* These patches assume that the number of keys in the key tree will be small -
in particular, the ioctl walks the tree testing the hashes. There's no way to
remove keys from the key tree; I think we'd probably want btrfs-check to warn
about unused keys, something like that. We could use reference counting, but
that would mean writing to the key tree whenever an encrypted extent is created
or removed.

* Filenames aren't encrypted at present; I considered this a different enough
problem to save for another patchset, given that this one's already quite
hefty. I'm not sure if we could use fscrypt for this either, as btrfs allows
for multiple inodes with the same number, and it would be a security flaw to
duplicate IVs.

I've attached a quick-and-dirty userspace program demonstrating the ioctl:

#include <linux/btrfs.h>
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <keyutils.h>
#include <sys/xattr.h>

static int getpw(char **pw)
{
	struct termios t, orig_t;
	size_t sz;
	int nread;

	if (tcgetattr(fileno(stdin), &t) != 0)
		return errno;

	orig_t = t;
	t.c_lflag &= ~ECHO;
	if (tcsetattr(fileno(stdin), TCSAFLUSH, &t) != 0)
		return errno;

	nread = getline(pw, &sz, stdin);
	if (nread > 0 && (*pw)[nread - 1] == '\n')
		(*pw)[nread - 1] = 0; /* remove trailing newline */

	tcsetattr(fileno(stdin), TCSAFLUSH, &orig_t);

	return 0;
}

static int add_btrfs_key(__u64 salt, char *pw)
{
	key_serial_t key;
	char name[20];

	sprintf(name, "btrfs:%016llx", salt);

	/*
	 * In pratice, you would want a type of "logon" here, so that
	 * the key can't be read from userspace.
	 */

	key = add_key("user", name, pw, strlen(pw), KEY_SPEC_USER_KEYRING);
	if (key == -1)
		return errno;

	printf("Added key %u to keyring\n", key);

	return 0;
}

int main(int argc, char *argv[])
{
	int fd, ret;
	char *pw = NULL;
	struct btrfs_ioctl_get_key_salt_args args;
	char keyhex[17];

	if (argc < 2) {
		fprintf(stderr, "Usage: btrfscrypt <directory>\n");
		return 0;
	}

	/* Prompt for password */

	printf("Password: ");

	ret = getpw(&pw);

	printf("\n");

	if (ret) {
		fprintf(stderr, "getpw returned %i\n", ret);
		return ret;
	}

	fd = open(argv[1], 0);
	if (fd < 0) {
		fprintf(stderr, "open returned %i\n", fd);
		goto end;
	}

	strcpy(args.password, pw);

	/* Get salt */

	ret = ioctl(fd, BTRFS_IOC_GET_KEY_SALT, &args);
	if (ret) {
		fprintf(stderr, "ioctl returned %i\n", ret);
		goto end2;
	}

	printf("BTRFS_IOC_GET_KEY_SALT returned salt %llx\n", args.salt);

	ret = add_btrfs_key(args.salt, pw);
	if (ret) {
		fprintf(stderr, "add_btrfs_key returned %i\n", ret);
		goto end2;
	}

	/* Set xattr */

	sprintf(keyhex, "%016llx", args.salt);

	ret = setxattr(argv[1], "btrfs.key", keyhex, strlen(keyhex), 0);
	if (ret) {
		fprintf(stderr, "setxattr returned %i\n", ret);
		goto end2;
	}

	ret = 0;

end2:
	close(fd);

end:
	free(pw);

	return ret;
}


Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 include/uapi/linux/btrfs.h      |  1 +
 include/uapi/linux/btrfs_tree.h | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..6c785d5cfb4b 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -269,6 +269,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_ENCRYPTION	(1ULL << 10)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..40acca24c69f 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -48,6 +48,9 @@
 /* tracks free space in block groups. */
 #define BTRFS_FREE_SPACE_TREE_OBJECTID 10ULL
 
+/* stores encryption keys */
+#define BTRFS_KEY_TREE_OBJECTID 11ULL
+
 /* device stats in the device tree */
 #define BTRFS_DEV_STATS_OBJECTID 0ULL
 
@@ -141,6 +144,11 @@
  */
 #define BTRFS_ROOT_ITEM_KEY	132
 
+/*
+ * encryption key, consisting of the hashed password
+ */
+#define BTRFS_ENCRYPTION_KEY	133
+
 /*
  * root backrefs tie subvols and snapshots to the directory entries that
  * reference them
@@ -789,6 +797,19 @@ struct btrfs_file_extent_item {
 
 } __attribute__ ((__packed__));
 
+#define BTRFS_ENCRYPTION_BLOCK_LENGTH 16
+
+struct btrfs_file_extent_item_enc {
+	struct btrfs_file_extent_item extent_item;
+	__le64 key_number;
+	__u8 iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+} __attribute__ ((__packed__));
+
+struct btrfs_file_extent_inline_enc {
+	__le64 key_number;
+	u8 iv[BTRFS_ENCRYPTION_BLOCK_LENGTH];
+} __attribute__ ((__packed__));
+
 struct btrfs_csum_item {
 	__u8 csum;
 } __attribute__ ((__packed__));
-- 
2.19.2

