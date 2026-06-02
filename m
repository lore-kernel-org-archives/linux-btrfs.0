Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF20360751;
	Tue,  2 Jun 2026 02:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780368394; cv=none; b=NybaTVroXcbLSpZ0IRC3e17bHMjcrSpmi8LMlyiVFR9d5wgVOJiKe2CuRr0wURY/iZv+OMjxBwS5fLI8lHBhygzqM+WBD3bDYtJodxHdEzMrMn79MKmisBEYjxO9VQQRGZN/iW/MWJ0e2UvjXnwmLGbdlZGOA2BieLheagHePhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780368394; c=relaxed/simple;
	bh=JORkjKhi0XmWyPFgsHONLoVoZJBiAIJztJbRsi+f338=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lzY+TDskhsoDuAAP2vWK/QCpPTs2yFnQSZYO0nRV1IVQM1r7p5SxmSEyTSDwmvaOc2R9EEt/aYJIkyRjIZz5AKAyNrZJxw8qFKjcASb/8/Vo3JUxCEV0zPkgvF3aFUGtgesoEPhn5piafp9GopCuWZOuIedMTMewI8Wte0fWtVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F79KQEcu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F79KQEcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC641F00893;
	Tue,  2 Jun 2026 02:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780368393;
	bh=HUh3Tk2tPlmaZ0Q7uDxjEXlapcS05ZZciYnB6bp9/zo=;
	h=From:Date:Subject:To:Cc;
	b=F79KQEcujWaVxphse7wbHNGjReInOulObT4J5gjhwqZy+61I8lcRt3Y1932jDEw78
	 A2uCEUcGkwjGui5c9DeiWe7M4aUeT/v+b/+vNgXw0mgZ6qiAoU2I3mu/P0BaZDw9JB
	 ZSVU8FHzONS9agLkgbU0E6dsrSE2Z+U+Sh1beH7sr5FYO7Qruu8E98POtwiLwWerwO
	 IuS8aQuUQAIBmOIHaclf/ZpMH1TCtst8GdYcnT/cMPfIFrjw0SxTeiqWUn9SENExeW
	 hVAssD4KoqejuI7nNeedB/NpOURB0mDT7HifP10gKwHu6TDViw64pXvtIvWdH6YnVD
	 lBHUUiAexHWPw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 01 Jun 2026 19:46:26 -0700
Subject: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in
 btrfs_init_workqueues()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXNQQ6CMBCF4auQWTtJS4CoVzEu2jKt46LADIgJ4
 e4UXX7Jy/82UBImhXu1gdCHlYdcYC8VhJfLiZD7YqhN3ZnOWPSzRMXIX1wnXJ1kzgmnJMMyopA
 Gl/HWtLZ39tq00UMJjUJl/zt5PP/Wxb8pzGcZ9v0AATn8O4YAAAA=
X-Change-ID: 20260601-btrfs-fix-wq-warning-qgroup-rescan-9451da1845fb
To: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>
Cc: Marco Crivellari <marco.crivellari@suse.com>, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1784; i=nathan@kernel.org;
 h=from:subject:message-id; bh=JORkjKhi0XmWyPFgsHONLoVoZJBiAIJztJbRsi+f338=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFlyLuxesyZr5xTvitg5q8WoQI9Jl1stpzrwzhyfxjbNl
 ZP28DB2lLIwiHExyIopslQ/Vj1uaDjnLOONU5Ng5rAygQxh4OIUgIl8nsfwi/n/460tvDWv09We
 /7V/yLp+DdvSgyrH5gbb3728fdZaoRSG/1WP+VK3lzl9PpDzJ+iHaP3eJd95Zu+NLIm/vysjp+d
 RPTcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit 21c05ca88a54 ("workqueue: Add warnings and ensure one among
WQ_PERCPU or WQ_UNBOUND is present"), there is a warning from the
btrfs-qgroup-rescan workqueue at run time:

  workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.

WQ_PERCPU is included in ordered_flags after commit 69635d7f4b34 ("fs:
WQ_PERCPU added to alloc_workqueue users") and WQ_UNBOUND is set in
alloc_ordered_workqueue(), which btrfs_alloc_ordered_workqueue() calls.

Drop WQ_PERCPU from ordered_flags, as alloc_ordered_workqueue() notes
that only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful.

Fixes: 69635d7f4b34 ("fs: WQ_PERCPU added to alloc_workqueue users")
Fixes: 21c05ca88a54 ("workqueue: Add warnings and ensure one among WQ_PERCPU or WQ_UNBOUND is present")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
This should go in via the workqueue tree that adds the warning.
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a11be02eeb9..f2a3b0705486 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1928,7 +1928,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 {
 	u32 max_active = fs_info->thread_pool_size;
 	unsigned int flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND;
-	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_PERCPU;
+	unsigned int ordered_flags = WQ_MEM_RECLAIM | WQ_FREEZABLE;
 
 	fs_info->workers =
 		btrfs_alloc_workqueue(fs_info, "worker", flags, max_active, 16);

---
base-commit: 21c05ca88a548ca1353cbef189c97d4f03b90692
change-id: 20260601-btrfs-fix-wq-warning-qgroup-rescan-9451da1845fb

Best regards,
--  
Cheers,
Nathan

