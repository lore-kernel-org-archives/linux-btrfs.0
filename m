Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68AA473C6F
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 07:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.0
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706847; cv=none; b=TTgNEBY1DskzKLz7hEuuYEK2jK/CgEc4xlKT99s7L/o/bwcIEF9X2KKHxT0Pd5Je2lA/9kNSgOtilp+DXaZzFX1NLRiOwN3g217UpNLWU5nBfA5lTAjJLlKj7FAWcWEK58y2EMvbbfs/TfV9UNcqmQQOepVZSRkUbETQ4kraXLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706847; c=relaxed/simple;
	bh=MkToleb4m4yaknKq0Uc8sDAa4xfNpQq5blY+pjjsrEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdtaL/1Pdix0vIQUDotwIObxbvsWO8N2+kxOqezv++DWcGszG6hTXqw94AET5uhVdq8sLI/1ZWdPsj1e3t/faQM700KXgrSPaerUGCh4/5Vdzg8LiD/JcKVafFp6HlCpjEGJuWQBKwxhaWWChGgHr9ATFUl4q4F49yXJOFZVvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VkicAtYE; arc=none smtp.client-ip=74.125.228.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkicAtYE"
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-ca7629af841so923067a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 00:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784706845; x=1785311645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fHpq4U7Pw0q+oym15ESSwLw0QA8PC+uoXnzHIagJCUY=;
        b=VkicAtYE4DWIhDo/3Q7/hxGjcE2t9VUolpD69pMyihxBWJEFXTPKNR8xzopITGNHYg
         u5tykE6XV4GbWAENFKn+MBzv1u3DN/NMjWviT2jpBxaB/+LG5LhGalPf3fJzgl1dB0bY
         x1Tt8kBchDS6CvUs2XM7X8m96VuttSu6Tki8RRhmYHa8g66PNKagEKsIx3KUAI2NxA7S
         xoqa3TcXL56Rzsho4UXx+Mxz/bt2QgJuK5+fCqb7xI9aSYwYp5rUgxNB7B7QmFDiLxAM
         r9uyoVoAvemebLQ+6dmi+oJIgynwx164ncjW83bJj7c+4edXW9a2ZoAnJbJ1EOZ5VGCA
         IjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784706845; x=1785311645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fHpq4U7Pw0q+oym15ESSwLw0QA8PC+uoXnzHIagJCUY=;
        b=Wriv9W8yIFSSjPTRAoc6vlgm//qnzKIJXR8xCVgm6yvjbqTBydTZi1b3g5XwyBx4vn
         NZS8wHRep6KvpjT/rRjLomDc15t8cYkEXPUU2IZpJAGCimvtLzXI//PmyyPpg6/g/dOe
         pyWzhy2a5hXqNNUrYzFggN4XChgCsgJ6gaxdBJ9epX1jTiTDOM/TM6zmH3b8OnjFikxW
         D8xfvdvbxK7qsqfjIpvc/D+AkLJO6wjk8v4Y48AdxNu6tIlyw2xXiuppVeVCS/kRwG8x
         CjvztGwega4CsqN/jGWhtzyYdm2T6wUWlpJTnYcHgfsPvdkq/hmcJr6SOQPnQ1yHXLrI
         V04Q==
X-Gm-Message-State: AOJu0YySQeF+gvbKZoHYiY5X4+w9pOXqmhgY4QRProElFVdFWFG/wS7J
	jRYnZ27Z2T3zWR6vi16rLyptuqhRq97Z6M72sI0/o5SdKLuSTdU/bfYALnw9Xr3CkkEOtQ==
X-Gm-Gg: AR+sD12SLDU+GpiIX1K79IVupkYw038sCnCQo5WW2taObewaKJ5ylpSI4kCsODLm/XR
	dmUnZbCa0CYu32r6pkzxAiB21mvARSyRzLTdne7bYL/tJF7O0YOLNLLtg9ky7CWcIdtgyoaqA9q
	TEV/l8Ia0H7KCriv+jF71LeKnoLhZwIvSM4JXDtNpkkzxbYemzboSEBRl9mZmgujiXr4DfXx+Kz
	E6n+edSOqs3thy6jxtqL8eCqFLn+I9fu/ImR9/Sp52OSNsCO1JYWMH7VAxRECNoUAbXJ+uAzXZp
	x/pUf2X4GZdA6+oFCPO99uyndxYKVGu2CUQSVBKhX135KdQc3ldx1vqPUDG3VKsDQ9baQXJXs8S
	IhzdutLp0o4u16vQs0QT4pGjQWJKSRtVNmjbPqG1Vf6e1uZP3KB4s1B671tCvMwwmDbL/kS0Z3Y
	sCpMeheJmPzJt1g8IYApae8CoQuGGi7prNHxqewSOI
X-Received: by 2002:a17:90b:3b42:b0:383:5a16:bd67 with SMTP id 98e67ed59e1d1-38ea4b4b6c5mr1899036a91.4.1784706845060;
        Wed, 22 Jul 2026 00:54:05 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e9208f6bdsm2892856a91.5.2026.07.22.00.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 00:54:04 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Cc: sunyangkai@fygo.io,
	Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] btrfs: test POSIX ACL changes for RO btrfs property
Date: Wed, 22 Jul 2026 15:52:47 +0800
Message-ID: <20260722075347.26639-1-sunk67188@gmail.com>
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

From: Sun YangKai <sunyangkai@fygo.io>

Test creation, modification and deletion of POSIX ACLs on a btrfs
filesystem that has the read-only property set to true.

This exercises a bug fixed by the kernel patch with subject:
"btrfs: check if root is readonly when setting posix acl"

Signed-off-by: Sun YangKai <sunyangkai@fygo.io>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
Changes since v2:

- updated commit message
- proper format for fixed_by_kernel_commit
- lower case variable name
- handle mkfs failure

Suggested by Filipe Manana
---
 tests/btrfs/353     | 95 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/353.out | 39 +++++++++++++++++++
 2 files changed, 134 insertions(+)
 create mode 100755 tests/btrfs/353
 create mode 100644 tests/btrfs/353.out

diff --git a/tests/btrfs/353 b/tests/btrfs/353
new file mode 100755
index 00000000..63ba4681
--- /dev/null
+++ b/tests/btrfs/353
@@ -0,0 +1,95 @@
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
+_fixed_by_kernel_commit xxxxxxxxxxxx \
+	"btrfs: check if root is readonly when setting posix acl"
+
+_require_acls
+_require_btrfs_command "property"
+_require_scratch
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+filename=$SCRATCH_MNT/foo
+
+set_acl()
+{
+	local perm=$1
+
+	# Use -n so setfacl does not recalculate the mask, keeping the
+	# golden output deterministic regardless of the named user's
+	# permissions.
+	setfacl -n -m u:$acl2:$perm,m::rwx $filename 2>&1 | _filter_scratch
+}
+
+get_acl()
+{
+	getfacl --absolute-names -n $filename | _filter_scratch | _getfacl_filter_id
+}
+
+del_acl()
+{
+	setfacl -b $filename 2>&1 | _filter_scratch
+}
+
+_acl_setup_ids
+
+# Create a test file.
+echo "hello world" > $filename
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

