Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D833B969
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935992; cv=none; b=NnrFxr8zapMzNjXGh+yF1LYN/2z3rtqdmHTcU1GWLtUEt6j542AxT/xDwDeE0/LTmtLPUfACHJQAofD/FYMKHREMAU3kmwChdqmZSjvPklHEA56X8EkCJ+Pln7m/HdQMCyzGKfkWJx9y3GSgimft34V4EOWQmjDsLtQGv00A858=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935992; c=relaxed/simple;
	bh=j1OujOAkhmdEz9wIazkkKYKxu5okbrWlVFw8M3oM23g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnODUn/R5BlWOFmi8+p75y33NugpUFh9fYUaN08UBQGJ3pVR0LC6UqHme/QxW2O2SNVr+TwV1wfztlVcwzSpWkWykH1NiJvK/P8esZp3MvvH9kD1Q4+jKcUba6Kv1FzL1VlGnOTLbXmTFLZ/qe7+QD4BaQWAlk0ToIWUYx3oH8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gws5VJq+; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gws5VJq+"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2cc80c24be6so5020585ad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 02:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783935990; x=1784540790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=93sI+IwfvRptO+HYoHBUpfJ+E/bC1rcpl579TmR5Dzo=;
        b=Gws5VJq+ZPknmtwZclxnKSOYMFs9X0Up84ZOk4b83HWVXy8dc0gTy71Kkkt3lFjK+A
         XAhjUaEYt21KnBQ+SqtkJ9skOgMVVhyhWHsuAULX0XaBARs2FaxSmIx5skWtVpGSPP3Z
         5BZSyn+0XUd/A2SzO/MGDAM/FuULxzisRFB96PVCpDnj77LjqgpCC7zYDceIeuOjQe1i
         ibCsLMQcemuGOj28aJLTc/UUyQrbf1SOrVrDvDXlQvKTS8xFyo+wUfJUXyYSPmxJIiKG
         9BBJZzkzh7sfP+eHZBcUIRIR+SFwZHmEqAemjqRqjpH8CnuYI4EkvLdKzTRgwP/OqQNa
         8u2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783935990; x=1784540790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=93sI+IwfvRptO+HYoHBUpfJ+E/bC1rcpl579TmR5Dzo=;
        b=f6xGGrp+YUHqiXIUmE7Y11w3hs6FdGEHnMSyNPwyQxgltK134QV/rfAzwsuondDznw
         g1GVMJHd/Zv7oyBgholmphg1nvx8Q4BJ8AZ5nGWagXyrd1yewIggHTi8kTFQM4K5tIbD
         snm0SfE0FSRv7EQes4/jZl4nU5/KIPeF+f49TMW445knIteyvSK7bJpjUf6PhE3kAM+J
         XYbJsaZ+d/KiCnkHAY1MR0La4Swv/3TZdVybctdMlkw3OLEGvMAUii/rjmZN7nPDejpo
         cfoh9Wz49WbwmTHivHgJaYya2WWmuN5EI3sbZjM6HH5t3skKkiog4wEFwsIBME3vfFr6
         AdXA==
X-Gm-Message-State: AOJu0YxxFHchR8F+gRDS8FPHYnmFbtdwoi4w5R9igLBtIpz4rPiaM0gp
	offpPqNS6FWTZ4JiVmpNFHDb3W/lesbFeivfICiDuKK3kX1GNSD9C6m+0m6EIji/aK83Gw==
X-Gm-Gg: AfdE7cl7X2/mpt1iT0OO8WGh+9LWEkPlEe0FNJT7FVodnzJUUeo3r/kqUleKhx/XOS3
	fZ1rADhzlbfqnBGVXRVb7EtIf8YhfV5kfkPvKL27LXxqTHGYsw5AktvWq+zYn/KWycLTWfu+Cwk
	UGe7hjvz2WImWOCfIv9BW4FVb+fWxupHzv/pcQ4V0KL4oAJSnw/bZCNP5/mZONqLkmN0fNg2aOP
	NWU2tKXzEZg/7jQ6M0ZKmhJJxDpOPUKDm0iN/F7hol3GORRCVqDdkFTsbVFTPMsUy0TTQ1bpwij
	9JYWPaAevyM2rwLsnYeNcJUNNpZiLphA6H+536buU/IUD13cVZg/bVNam4F4mTCaX4/wQeoZHFk
	agjAkvgxvBfws4sx1T59F0496Ya8bWq3pCb0EaV7XbW3GG34ocYieh6BetBDIofDbPU57p7shmS
	fcHaVLhK1GEqMH8ytfI0oUJpyoNE1oXtXIyTFePy0A
X-Received: by 2002:a17:90b:2dc1:b0:37f:e7e7:ad1 with SMTP id 98e67ed59e1d1-38dc7c0eb95mr6214329a91.5.1783935990320;
        Mon, 13 Jul 2026 02:46:30 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a5574ca88sm6167713a91.7.2026.07.13.02.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 02:46:29 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: Sun YangKai <sunyangkai@fnnas.com>
Subject: [PATCH v2] btrfs: test POSIX ACL changes for RO btrfs property
Date: Mon, 13 Jul 2026 17:44:45 +0800
Message-ID: <20260713094611.19703-1-sunk67188@gmail.com>
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

Test creation, modification and deletion of POSIX ACLs on a btrfs
filesystem that has the read-only property set to true, and re-test the
same after the property is cleared.

Commit 353c2ea735e4 ("btrfs: remove redundant readonly root check in
btrfs_setxattr_trans") removed the read-only root check from
btrfs_setxattr_trans() under the assumption that none of its callers can
run on a read-only root.  That assumption does not hold for the ->set_acl
path: btrfs_set_acl() -> __btrfs_set_acl() reaches
btrfs_setxattr_trans() directly, bypassing the handler-level read-only
checks that were later (re)added by commit b51111271b03 ("btrfs: check
if root is readonly while setting security xattr").  As a result, ACLs
could still be set or removed on a read-only subvolume, bypassing the RO
protection that applies to every other xattr.

The restoring kernel fix adds the read-only check directly to
btrfs_set_acl().  This test complements btrfs/275, which covers the
generic ->setxattr path.

The test exercises the set, get and remove cycle of an access ACL on a
regular file, and expects all modifications to fail with EROFS while the
subvolume is read-only, then succeed once it is writable again.

Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
---
Changes from v1:

- fix copywrite header
- better wording for commit message

Sorry for bothering.

---
 tests/btrfs/353     | 97 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/353.out | 39 ++++++++++++++++++
 2 files changed, 136 insertions(+)
 create mode 100755 tests/btrfs/353
 create mode 100644 tests/btrfs/353.out

diff --git a/tests/btrfs/353 b/tests/btrfs/353
new file mode 100755
index 00000000..586f722a
--- /dev/null
+++ b/tests/btrfs/353
@@ -0,0 +1,97 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 Fygo OS. All Rights Reserved.
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

