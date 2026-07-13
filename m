Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D7E3D954C
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 09:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783934245; cv=none; b=A0Gxx1lHPwGMKYRiislKXZuBF7tokUQAQEjJ0oD23+LNxFRv/DCe969IX5LiWPLHPTGvGOXvRatzJJVKyPS/hkT6yI2dE/7C471nRls7Wh6TbZ6eyui4PARrcs4TGs611kGz3ZweKs+AKQejNPxrFMfjR1Qjs+c7I4IEFLhuMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783934245; c=relaxed/simple;
	bh=nGJVNWIGTlh3Ve2rtxXhO8Lwyjsbz0tmH8VzXSPm6zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p27U/3XA6EqgwIjoE3EAen/0PYAbUjH6gfxrwq0Khjgobcjl+UnJ6q8EKexOJ/Zrvnm8zV2p4Ms4hqUbLePwJgW66aEmGkob+SFC3snTJVTchO3fHWaVMqz3lIQ8hJ8kUx2K7qa8fbw7KhRkG6N4gPpjRpG2ObWTFHj+bWzv1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ojNH0b8s; arc=none smtp.client-ip=74.125.227.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ojNH0b8s"
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-383fd2d12f5so332993a91.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 02:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783934243; x=1784539043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YS9HSQYLWxfpBGl81FLqKvaHWT/gifA7Uzz1bJeYLjU=;
        b=ojNH0b8sYyIJR6EIfay50FOmQkM2jpj2qkVfWPxLUDO1SiN8qzHdD4kIQlKIYGdL/f
         mR4KVjUSl1XHgLX9zPSeMoVVnZGQCXxa5u+JoXhhZeh91035gJsUvbW4NiJ2mob//oMs
         7C6Fd5YKAK6WPSPKVRqxIo6YxAhZG34aOi0d7/va1T6dHSTYr0+xeg1vYYNC/+byr9Vo
         h5FgqZu1iayYJh2jpdE5FIiD94aBdsr0vD0IXu4d7uJ/NY+mQLtT/X/CPoxzYeDOtl7r
         /ovpGh4HkiNFlCBAz5bFmPHD33192JEex3FunOr5RAeFFqkuXueFaw+JaOI9ekurScgw
         r6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783934243; x=1784539043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YS9HSQYLWxfpBGl81FLqKvaHWT/gifA7Uzz1bJeYLjU=;
        b=N4YSblXcsALaIhaqM+A+ea1BoOqVVTuCeP66+TaAtrhmzRO8xIMaGSmlQQ46Ot4On1
         gxJN0sMUv8THNWU9dMvF2vqLnG5os5wVwZKzKCQYO1cSUG7lL3xWRHvj6y68z2p/gGzM
         qjpBkjVfOb3QEoR6G+H4cv7OTeTSn/UqihaxU+dSqxSyXLKus7KUQHlnCD1fIz0KgsYA
         QlFNeFuf24Y6FGnTZE6uJzdH3fYIoIKwPPPcaHisR7TlDRQF1XpaXa2j1fLTuGI6RZ1a
         1bOpsxZoHUwE1SWj6BiUdqUOF3AW3BFNKO3aS4fsoFxDw1wWyeNjmW1ivicwBPskLAFR
         cDug==
X-Gm-Message-State: AOJu0YwJDRm7Ice4SgtVlunspb6K1Uo8EnQTEz4dfHpdtBlRPdQ0BjLQ
	L4MgipCywHdrYt9sAwCvwVHl4u348RAW5lTx3FsEwCfxmpmCBJW0x+wfuudTx3ffDrilmQ==
X-Gm-Gg: AfdE7cny7bQ2u7nEgBYNo00KRIwf1cUuQiOvTeOeDamBhLcSiPUt2m0l+f3G1LyegNy
	bwUktQzXrWmQnIAde2OeGEOxlyHYk1NmXIslVWmC1H1JcGhMY4jMXhJWPCKJFMM4HCuMxCA2JLx
	Nj2awfazEYTUgCy2Vi8Xw993UGmp2xj92QIH0FJkeeae96UsHYw4Nmfsk6LNPRXfcsEbo9MTa68
	xHUauMM/XNpEJEx3qcOwuguCg3vWnIny1juekSjPnNyvLdx2ELhK35hcpW7v/3gd/QomFYfiTT2
	kDB4XnQmRu33JOHop1LLFAsThW5eHbg3oD68d/P3t1Z36zGwK7to/dgFXFGrIVUcm2XVZiNdDK/
	obQ/xX/OQd4U2P7S6rNsIM1L2oU58T7xJQzKNGPOYM4vCUX6jnBxpWq5OxKvoHUWNDClDuUnllE
	V6M3qoBHyECxOtC+lK/COTkryjXlEmKJL/nqus7F/G
X-Received: by 2002:a05:6a00:4b4e:b0:848:7e85:f210 with SMTP id d2e1a72fcca58-8488985ddf7mr5437136b3a.4.1783934242683;
        Mon, 13 Jul 2026 02:17:22 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b975a0sm13768349b3a.14.2026.07.13.02.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 02:17:22 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Sun YangKai <sunyangkai@fnnas.com>
Subject: [PATCH] btrfs: test POSIX ACL changes for RO btrfs property
Date: Mon, 13 Jul 2026 17:06:45 +0800
Message-ID: <20260713091659.4981-1-sunk67188@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709082500.17907-2-sunk67188@gmail.com>
References: <20260709082500.17907-2-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sun YangKai <sunyangkai@fnnas.com>

Test creation, modification and deletion of POSIX ACLs for a btrfs
filesystem which has the read-only property set to true.

Re-test the same after the read-only property is set to false.

This complements btrfs/275, which covers the generic ->setxattr path.
POSIX ACLs are set and removed through the ->set_acl inode operation
(btrfs_set_acl), which is a separate code path that is not covered by
the RO check added for security xattrs in commit b51111271b03 ("btrfs:
check if root is readonly while setting security xattr").  As a result,
ACLs could still be modified on a read-only subvolume, bypassing the RO
protection that applies to every other xattr.

The test exercises the set, get and remove cycle of an access ACL on a
regular file, and expects all modifications to fail with EROFS while the
subvolume is read-only.

Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
---
 tests/btrfs/353     | 97 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/353.out | 39 ++++++++++++++++++
 2 files changed, 136 insertions(+)
 create mode 100755 tests/btrfs/353
 create mode 100644 tests/btrfs/353.out

diff --git a/tests/btrfs/353 b/tests/btrfs/353
new file mode 100755
index 00000000..60059d4a
--- /dev/null
+++ b/tests/btrfs/353
@@ -0,0 +1,97 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 YOUR NAME HERE. All Rights Reserved.
+#
+# FS QA Test No. 353
+#
+# Test that POSIX ACLs cannot be changed once a btrfs subvolume has the
+# read-only property set.
+#
+# Setting or removing a POSIX ACL goes through the ->set_acl inode
+# operation, which is a different code path from the generic ->setxattr
+# one covered by btrfs/275.  It used to be allowed on a read-only
+# subvolume and thus bypassed the RO protection.  Such modifications must
+# fail with EROFS, just like any other xattr.
+#
+. ./common/preamble
+_begin_fstest auto quick acl attr
+
+. ./common/filter
+. ./common/attr
+
+# TODO: fill in the kernel commit hash that fixes the ->set_acl path once
+# it is merged.
+# _fixed_by_kernel_commit <HASH> \
+#	"btrfs: check if root is readonly when setting posix acl"
+
+_require_acls
+_require_btrfs_command "property"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+FILENAME=$SCRATCH_MNT/foo
+
+set_acl()
+{
+	local perm=$1
+
+	# Use -n so setfacl does not recalculate the mask, keeping the
+	# golden output deterministic regardless of the named user's
+	# permissions.
+	setfacl -n -m u:$acl2:$perm,m::rwx $FILENAME 2>&1 | _filter_scratch
+}
+
+get_acl()
+{
+	getfacl --absolute-names -n $FILENAME | _filter_scratch | _getfacl_filter_id
+}
+
+del_acl()
+{
+	setfacl -b $FILENAME 2>&1 | _filter_scratch
+}
+
+_acl_setup_ids
+
+# Create a test file.
+echo "hello world" > $FILENAME
+
+# Set an initial ACL while the subvolume is writable.
+set_acl rwx
+
+# Attempt to change the ACL once the subvolume is read-only.  This must
+# fail with EROFS.
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT ro true
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT ro
+
+set_acl r--
+
+# The ACL must not have changed.
+get_acl
+
+# Attempt to remove the ACL from the read-only subvolume.  This must
+# fail with EROFS as well.
+del_acl
+
+# The ACL must still be present.
+get_acl
+
+# Make the subvolume writable again.
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT ro false
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT ro
+
+# Now changing the ACL must succeed.
+set_acl r--
+
+get_acl
+
+# And removing it must succeed too.
+del_acl
+
+# Check the ACL is really gone.
+get_acl
+
+status=0
+exit
diff --git a/tests/btrfs/353.out b/tests/btrfs/353.out
new file mode 100644
index 00000000..66f4a0e5
--- /dev/null
+++ b/tests/btrfs/353.out
@@ -0,0 +1,39 @@
+QA output created by 353
+ro=true
+setfacl: SCRATCH_MNT/foo: Read-only file system
+# file: SCRATCH_MNT/foo
+# owner: 0
+# group: 0
+user::rw-
+user:id2:rwx
+group::r--
+mask::rwx
+other::r--
+
+setfacl: SCRATCH_MNT/foo: Read-only file system
+# file: SCRATCH_MNT/foo
+# owner: 0
+# group: 0
+user::rw-
+user:id2:rwx
+group::r--
+mask::rwx
+other::r--
+
+ro=false
+# file: SCRATCH_MNT/foo
+# owner: 0
+# group: 0
+user::rw-
+user:id2:r--
+group::r--
+mask::rwx
+other::r--
+
+# file: SCRATCH_MNT/foo
+# owner: 0
+# group: 0
+user::rw-
+group::r--
+other::r--
+
-- 
2.54.0

