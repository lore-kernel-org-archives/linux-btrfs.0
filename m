Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA64192EF;
	Mon, 12 Oct 2026 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808288; cv=none; b=U8gh8AbBwU5e5uRf76niru1qD8vB44WGKhPcUznG8mvpGWl04FmpFcFiAMj+owKeC15S/e0EAy4h9wR8TtSmiZGofVQHlIXR408lA7SBNZigoQ3SsWsleVKRFImycgjoA3ZHPBlHCIXSLNV4q0y6GCVR6l22BJQGKXyn6692344=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808288; c=relaxed/simple;
	bh=5WQpWQFleIU6+QOHkyfm1SbeoNQnx50RCFkTSUn7zz0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=A18+Ck+l8Tt2H4t/QzCflAqrOMlP4iNCMbgM7tSAY85W3Y3NAvddunn5idY2XCMW12AoEohhiHfluoLI2eDdbLAcG8MLVkO5n2zPQv1YBVrlw22A3VrpXrS+nONyXAVenqDx8+R3iNQ18/50zoDsVeayTMQw0Yh6K6k8YRl/cy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEdqz1QX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEdqz1QX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D831F0089B;
	Mon, 12 Oct 2026 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791808287;
	bh=0yD5QSGq1xDwsCZlKmoLmhXguUQHWTYL3a8DS+c2uKo=;
	h=From:Subject:Date:To:Cc;
	b=WEdqz1QXx6jBIm7UjWc5bbypPv8dRzs3e67t3UjymBJrgTVaWLBEMFtOF1GWzpst0
	 hkfvDLq30qPw9cehTtoTmTeP1uVVH7xMnFaTiqXf3nV4VkXaqDGQXI1134zDdO+6TJ
	 CQ2OS794EM6SI+0HtiCBze3MmFLb2AvfDZ8XZS0+LFa2rf6s08MphgEyT1nrxFqMYj
	 mds1nBxRfcWJy6LS+I7amYD1nQH4j/iZqhn915Bh6Zf9X5ntD8aENAcmGRFHt7chxi
	 Qyjmjiqp275pzXUbjCwzOHly8WO6YXasda0qgCGu8FkV/Nbwymsz2BhXN/6qk3HRKE
	 S2ibVeB+hAIhQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] super: convert to a plain hashtable
Date: Mon, 12 Oct 2026 14:31:17 +0200
Message-Id: <20261012-work-super-dev_hash-v1-0-305cf71cd334@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM2wrDIBAFfyXscxVNSnr5lVCKmk21BQ27TVoI+
 feqfZzDmdmAkQIyXJsNCNfAIcUM+tCA8yY+UIQxM7Sq7bXSWnwSvQQvM5IYcb17w15gp6bTpev
 1UZ0hmzPhFL61Otz+zIt9onuXVHlYwygsmeh8mUpU1qisonSJEPb9BwUWFS+fAAAA
X-Change-ID: 20261011-work-super-dev_hash-e30f79361408
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2215; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5WQpWQFleIU6+QOHkyfm1SbeoNQnx50RCFkTSUn7zz0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSduSydU8Ma7dLLI/L5rB8XZwADd06WzVKLmjsC/vsuL
 RfQEhfsKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMgrQUaG9dLf3Zd5mnttPv11
 5/U69eZHx4TffxNUOJDc2fnyX4NGNMNfGdtfNjlJ7UnbPUpWnrn7h2X/gbzeGXPCF6aslznuMTm
 CHwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

This sits on top of the superblock fixes for v7.3.

Convert the rhltable to a plain hashtable under a spinlock. The walks
keep their place with a cursor entry in the chain. A claim is unhashed
the moment it's dropped and a walk that finds a superblock that isn't
born yet waits for it to be born or to die and looks again. Since
hashing can't fail anymore the entry for the superblock's own s_dev is
embedded in struct super_block and the preallocation in alloc_super()
goes away. This all simplifies things quite a lot.

It also fixes a btrfs bug where fs_bdev_freeze() ended up freezing a
btrfs filesystem through a stale member that open_ctree() had already
released while the freeze was waiting for SB_BORN. The resume doesn't
find a holder for that device anymore so the filesystem stays frozen
for good.

The selftest freezes a device that several erofs superblocks share.
That's the one case where a device legitimately carries claims from more
than one superblock and it checks that a suspend freezes each of them
exactly once and that mounts coming and going under a suspended device
leave nothing frozen behind.

I modeled the table in TLA+ and checked the real list code with CBMC.
Both agree with the design.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (2):
      selftests/filesystems: add a test for freezing a shared block device
      super: convert to plain hashtable

 block/bdev.c                                       |   2 +-
 fs/internal.h                                      |   1 -
 fs/namespace.c                                     |   2 -
 fs/super.c                                         | 332 ++++++--------
 include/linux/fs/super_types.h                     |  11 +-
 .../selftests/filesystems/freeze/.gitignore        |   1 +
 .../testing/selftests/filesystems/freeze/Makefile  |   2 +-
 tools/testing/selftests/filesystems/freeze/config  |   1 +
 .../filesystems/freeze/shared_bdev_test.c          | 479 +++++++++++++++++++++
 9 files changed, 627 insertions(+), 204 deletions(-)
---
base-commit: 16efce55f70b6093dbe53bffb8e79fb0e08a95b6
change-id: 20261011-work-super-dev_hash-e30f79361408

