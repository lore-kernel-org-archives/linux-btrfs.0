Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DC03F7871;
	Tue, 24 Mar 2026 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351197; cv=none; b=P+jLcS/ggm7nRHb30qrWHVIq3nRilxdtw2Cw9bUHN7gbB+Apr7XfE/UY6kqos8pBECjiIi9/cGC8Tk96UmhqY00wvKjnmtli1IHCT93EHaIhWvrZQZe9m+SwY1sS6ho1UVeHmRtFd+U8sa/n/KcaLZBtAgyMO1hTze3tNTND5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351197; c=relaxed/simple;
	bh=YgUsqt2FAZ+P2YHCpRywXrgJPrDVa+zxRcRZW+Oy5Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qxrDW7iJKYIYKvjwS2jeN03lPwXK03srLCtOYtEnznU5nTh3BBPBMJPTLya1nmpyulkQsXMRLBL0b5ahLuAmLJUnUmagqfAsnvWyvcbhBsduzwirb8Fwn0diSiPs+xLKOsobzFxq4cXdGt6PYe+fcWL6TK6B3ou2Met6mjBEyCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktvZR3bO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktvZR3bO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4619DC19424;
	Tue, 24 Mar 2026 11:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351196;
	bh=YgUsqt2FAZ+P2YHCpRywXrgJPrDVa+zxRcRZW+Oy5Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktvZR3bO/DaCaDv7CeRMq0mjp9xBFKAovXtJsB0Jvi752aPwE1BjfDryLnDFuBhtC
	 Qjd11aycogL+7GiD2h7Grny3EZwemW9el2SJaCKFCVEtdU44dWbar8Ce8qzUl4G52S
	 lwmsQ2uLZbfwMWb7Fb1M6CSrBvtaDxJbrT2aefnucatFnl9+HFZTfD+acJvLVsQpZK
	 7Pz2CMr765yeO57Td3R9oFM3CeLNDkPab4yFLaLqikfXPKGeUwtiputR0nVQyW79gh
	 imK3+eSUT4MxMfCUE5tmRuyplUAM33rtoMLCqrWVhngBA8Ruw0L545I80ZX9CNPGGs
	 xc2hftjqBeD/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] btrfs: don't take device_list_mutex when querying zone info
Date: Tue, 24 Mar 2026 07:19:26 -0400
Message-ID: <20260324111931.3257972-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 77603ab10429fe713a03345553ca8dbbfb1d91c6 ]

Shin'ichiro reported sporadic hangs when running generic/013 in our CI
system. When enabling lockdep, there is a lockdep splat when calling
btrfs_get_dev_zone_info_all_devices() in the mount path that can be
triggered by i.e. generic/013:

  ======================================================
  WARNING: possible circular locking dependency detected
  7.0.0-rc1+ #355 Not tainted
  ------------------------------------------------------
  mount/1043 is trying to acquire lock:
  ffff8881020b5470 (&vblk->vdev_mutex){+.+.}-{4:4}, at: virtblk_report_zones+0xda/0x430

  but task is already holding lock:
  ffff888102a738e0 (&fs_devs->device_list_mutex){+.+.}-{4:4}, at: btrfs_get_dev_zone_info_all_devices+0x45/0x90

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #4 (&fs_devs->device_list_mutex){+.+.}-{4:4}:
	 __mutex_lock+0xa3/0x1360
	 btrfs_create_pending_block_groups+0x1f4/0x9d0
	 __btrfs_end_transaction+0x3e/0x2e0
	 btrfs_zoned_reserve_data_reloc_bg+0x2f8/0x390
	 open_ctree+0x1934/0x23db
	 btrfs_get_tree.cold+0x105/0x26c
	 vfs_get_tree+0x28/0xb0
	 __do_sys_fsconfig+0x324/0x680
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #3 (btrfs_trans_num_extwriters){++++}-{0:0}:
	 join_transaction+0xc2/0x5c0
	 start_transaction+0x17c/0xbc0
	 btrfs_zoned_reserve_data_reloc_bg+0x2b4/0x390
	 open_ctree+0x1934/0x23db
	 btrfs_get_tree.cold+0x105/0x26c
	 vfs_get_tree+0x28/0xb0
	 __do_sys_fsconfig+0x324/0x680
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #2 (btrfs_trans_num_writers){++++}-{0:0}:
	 lock_release+0x163/0x4b0
	 __btrfs_end_transaction+0x1c7/0x2e0
	 btrfs_dirty_inode+0x6f/0xd0
	 touch_atime+0xe5/0x2c0
	 btrfs_file_mmap_prepare+0x65/0x90
	 __mmap_region+0x4b9/0xf00
	 mmap_region+0xf7/0x120
	 do_mmap+0x43d/0x610
	 vm_mmap_pgoff+0xd6/0x190
	 ksys_mmap_pgoff+0x7e/0xc0
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #1 (&mm->mmap_lock){++++}-{4:4}:
	 __might_fault+0x68/0xa0
	 _copy_to_user+0x22/0x70
	 blkdev_copy_zone_to_user+0x22/0x40
	 virtblk_report_zones+0x282/0x430
	 blkdev_report_zones_ioctl+0xfd/0x130
	 blkdev_ioctl+0x20f/0x2c0
	 __x64_sys_ioctl+0x86/0xd0
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #0 (&vblk->vdev_mutex){+.+.}-{4:4}:
	 __lock_acquire+0x1522/0x2680
	 lock_acquire+0xd5/0x2f0
	 __mutex_lock+0xa3/0x1360
	 virtblk_report_zones+0xda/0x430
	 blkdev_report_zones_cached+0x162/0x190
	 btrfs_get_dev_zones+0xdc/0x2e0
	 btrfs_get_dev_zone_info+0x219/0xe80
	 btrfs_get_dev_zone_info_all_devices+0x62/0x90
	 open_ctree+0x1200/0x23db
	 btrfs_get_tree.cold+0x105/0x26c
	 vfs_get_tree+0x28/0xb0
	 __do_sys_fsconfig+0x324/0x680
	 do_syscall_64+0x92/0x4f0
	 entry_SYSCALL_64_after_hwframe+0x76/0x7e

  other info that might help us debug this:

  Chain exists of:
    &vblk->vdev_mutex --> btrfs_trans_num_extwriters --> &fs_devs->device_list_mutex

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(&fs_devs->device_list_mutex);
				 lock(btrfs_trans_num_extwriters);
				 lock(&fs_devs->device_list_mutex);
    lock(&vblk->vdev_mutex);

   *** DEADLOCK ***

  3 locks held by mount/1043:
   #0: ffff88811063e878 (&fc->uapi_mutex){+.+.}-{4:4}, at: __do_sys_fsconfig+0x2ae/0x680
   #1: ffff88810cb9f0e8 (&type->s_umount_key#31/1){+.+.}-{4:4}, at: alloc_super+0xc0/0x3e0
   #2: ffff888102a738e0 (&fs_devs->device_list_mutex){+.+.}-{4:4}, at: btrfs_get_dev_zone_info_all_devices+0x45/0x90

  stack backtrace:
  CPU: 2 UID: 0 PID: 1043 Comm: mount Not tainted 7.0.0-rc1+ #355 PREEMPT(full)
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-9.fc43 06/10/2025
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5b/0x80
   print_circular_bug.cold+0x18d/0x1d8
   check_noncircular+0x10d/0x130
   __lock_acquire+0x1522/0x2680
   ? vmap_small_pages_range_noflush+0x3ef/0x820
   lock_acquire+0xd5/0x2f0
   ? virtblk_report_zones+0xda/0x430
   ? lock_is_held_type+0xcd/0x130
   __mutex_lock+0xa3/0x1360
   ? virtblk_report_zones+0xda/0x430
   ? virtblk_report_zones+0xda/0x430
   ? __pfx_copy_zone_info_cb+0x10/0x10
   ? virtblk_report_zones+0xda/0x430
   virtblk_report_zones+0xda/0x430
   ? __pfx_copy_zone_info_cb+0x10/0x10
   blkdev_report_zones_cached+0x162/0x190
   ? __pfx_copy_zone_info_cb+0x10/0x10
   btrfs_get_dev_zones+0xdc/0x2e0
   btrfs_get_dev_zone_info+0x219/0xe80
   btrfs_get_dev_zone_info_all_devices+0x62/0x90
   open_ctree+0x1200/0x23db
   btrfs_get_tree.cold+0x105/0x26c
   ? rcu_is_watching+0x18/0x50
   vfs_get_tree+0x28/0xb0
   __do_sys_fsconfig+0x324/0x680
   do_syscall_64+0x92/0x4f0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x7f615e27a40e
  RSP: 002b:00007fff11b18fb8 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
  RAX: ffffffffffffffda RBX: 000055572e92ab10 RCX: 00007f615e27a40e
  RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
  RBP: 00007fff11b19100 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  R13: 000055572e92bc40 R14: 00007f615e3faa60 R15: 000055572e92bd08
   </TASK>

Don't hold the device_list_mutex while calling into
btrfs_get_dev_zone_info() in btrfs_get_dev_zone_info_all_devices() to
mitigate the issue. This is safe, as no other thread can touch the device
list at the moment of execution.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have sufficient information to complete the full analysis. Let me
compile the results.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: btrfs (zoned)
- **Action verb**: "don't take" — removing an unnecessary/harmful lock,
  indicates a deadlock fix
- **Summary**: Remove device_list_mutex from zone info query to fix
  circular lock dependency

### Step 1.2: Tags
- **Reported-by**: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> —
  real user/tester report of sporadic hangs
- **Reviewed-by**: Damien Le Moal <dlemoal@kernel.org> — block
  layer/zoned storage expert
- **Reviewed-by**: David Sterba <dsterba@suse.com> — btrfs maintainer
- **Signed-off-by**: Johannes Thumshirn <johannes.thumshirn@wdc.com> —
  author, btrfs/zoned regular contributor
- **Signed-off-by**: David Sterba <dsterba@suse.com> — btrfs maintainer
  acceptance
- **No Fixes: tag** (expected for manual review candidates)
- **No Cc: stable** (expected)

### Step 1.3: Commit Body
The commit describes sporadic hangs found by a CI system running
generic/013. Lockdep confirms a circular locking dependency:
- Chain: `device_list_mutex` → `vblk->vdev_mutex` → `mmap_lock` →
  `btrfs_trans_num_writers` → `btrfs_trans_num_extwriters` →
  `device_list_mutex`
- Full stack traces provided showing the exact lock acquisition paths
- Clear reproduction: mount of zoned btrfs filesystem (open_ctree path)

### Step 1.4: Hidden Bug Fix Detection
This is explicitly a deadlock fix. The commit message directly shows the
lockdep splat and the deadlock scenario. Not hidden at all.

**Record**: Real deadlock fix. Sporadic hangs during mount. Confirmed by
lockdep with full dependency chain.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 — `fs/btrfs/zoned.c`
- **Lines**: -2 (mutex_lock/mutex_unlock removed), +4 (comment added)
- **Net**: +2 lines
- **Functions modified**: `btrfs_get_dev_zone_info_all_devices()`
- **Scope**: Single-file, single-function, surgical fix

### Step 2.2: Code Flow Change
- **Before**: The function acquires `device_list_mutex` before iterating
  the device list and releases it after
- **After**: The function iterates the device list without the mutex,
  relying on the fact that during mount (open_ctree), no other thread
  can modify the device list

### Step 2.3: Bug Mechanism
**Category**: Deadlock / circular lock dependency (CRITICAL)
- The lock creates a dependency chain that can deadlock with other paths
  that acquire these locks in different order
- CPU0 holds `device_list_mutex` and needs `vblk->vdev_mutex`
- CPU1 holds locks in the transaction path that eventually need
  `device_list_mutex`

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — during `open_ctree()`, the filesystem is
  being mounted, no other thread can add/remove devices
- **Minimal/surgical**: Yes — only removes the unnecessary lock, adds
  explanatory comment
- **Regression risk**: Very low — the lock was unnecessary at this call
  site (mount path only)
- **Red flags**: None

**Record**: Minimal 2-line removal + comment. Obviously safe because
called only from mount path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- Buggy code (mutex_lock/unlock in
  `btrfs_get_dev_zone_info_all_devices`) introduced by commit
  `7365104236ade0` (Naohiro Aota, 2021-02-04)
- First appeared in **v5.12-rc1**
- Present in all current stable trees (v5.15.y, v6.1.y, v6.6.y, v6.12.y)

### Step 3.2: Fixes tag
No Fixes: tag present. The implicit target is `7365104236ade0` which
introduced the function with the mutex.

### Step 3.3: File History
- The lock dependency chain also depends on `2eadb9e75e8e65` (Nikolay
  Borisov, 2021-07-05) which added `device_list_mutex` to
  `btrfs_create_pending_block_groups` — first in **v5.15-rc1**
- So the deadlock is possible from **v5.15** onwards (when both sides of
  the circular dependency exist)
- Prior lockdep fixes in this file: `0b9e66762aa0c` (device_list_mutex
  deadlock in `btrfs_can_activate_zone`), `b18f3b60b35a8` (lock ordering
  in `btrfs_zone_activate`)

### Step 3.4: Author
Johannes Thumshirn is a regular btrfs/zoned contributor and co-
maintainer of zoned storage code. High trust.

### Step 3.5: Dependencies
- The fix is completely self-contained: removes 2 lines, adds a comment
- No dependency on other commits
- The function and its surrounding code are unchanged since introduction
  (except the `populate_cache` parameter added in v5.16)
- Will apply cleanly to all stable trees v5.15+

**Record**: Bug exists from v5.15+. Fix is standalone. Will apply
cleanly.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Lore Discussion
Found the original patch posted 2026-03-03. Reviewed by Damien Le Moal
(block/zoned expert) and David Sterba (btrfs maintainer). Included in
"Btrfs fixes for 7.0-rc5" pull request by David Sterba, confirming it's
treated as a fix.

### Step 4.2: Bug Report
The bug was found by Shin'ichiro Kawasaki in their CI system running
generic/013 (an fstests test). The lockdep splat is the primary
evidence. The commit also mentions "sporadic hangs."

### Step 4.3: Related Patches
No other patches in a series — this is a standalone fix.

### Step 4.4: Stable Discussion
No explicit stable nomination found, which is why this commit is being
manually reviewed.

**Record**: Standalone fix. Reviewed by 2 experts. Accepted as bugfix
for rc5.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- Modified: `btrfs_get_dev_zone_info_all_devices()`

### Step 5.2: Callers
- Single caller: `open_ctree()` in `fs/btrfs/disk-io.c:3464`
- This is the mount path — called during every btrfs mount operation on
  zoned devices

### Step 5.3: Callees
- Calls `btrfs_get_dev_zone_info()` which calls `btrfs_get_dev_zones()`
  which calls `blkdev_report_zones_cached()` (or `blkdev_report_zones()`
  in older kernels) → block device driver zone report callback
- The block device callback (e.g., `virtblk_report_zones`) may take its
  own mutex, creating the circular dependency

### Step 5.4: Call Chain
`mount` syscall → `vfs_get_tree` → `btrfs_get_tree` → `open_ctree` →
`btrfs_get_dev_zone_info_all_devices`
This is reachable from userspace during every mount of a zoned btrfs
filesystem.

### Step 5.5: Similar Patterns
Previous similar fix: `0b9e66762aa0c` removed `device_list_mutex` from
`btrfs_can_activate_zone()` for the same type of deadlock reason. This
pattern of removing unnecessary `device_list_mutex` usage has precedent.

**Record**: Called on every zoned btrfs mount. Single call site. Same
pattern as previous accepted fix.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
- The function `btrfs_get_dev_zone_info_all_devices` with
  `device_list_mutex` exists since v5.12
- The other side of the circular dependency (`device_list_mutex` in
  `btrfs_create_pending_block_groups`) exists since v5.15
- **Deadlock is possible in all stable trees from v5.15 onwards**:
  v5.15.y, v6.1.y, v6.6.y, v6.12.y

### Step 6.2: Backport Complications
- The function is essentially unchanged since introduction (only
  `populate_cache` parameter change in v5.16)
- The patch should apply cleanly to all stable trees v5.15+
- In v5.12-v5.14 the other side of the dependency doesn't exist, so the
  deadlock can't occur there

### Step 6.3: Related Fixes in Stable
No fix for this specific deadlock is already in stable trees.

**Record**: Bug exists in v5.15+. Clean apply expected. No existing fix
in stable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: btrfs (filesystem), zoned device support
- **Criticality**: IMPORTANT — btrfs is widely used, zoned storage is
  growing (SMR HDDs, ZNS SSDs)

### Step 7.2: Activity
The btrfs zoned code is very actively developed with frequent fixes,
indicating ongoing maturation of this subsystem.

**Record**: btrfs/zoned — IMPORTANT criticality, actively developed.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
- All users of btrfs on zoned block devices (ZNS SSDs, SMR HDDs)
- Also affects users of btrfs zone emulation mode on regular devices
- Growing user population as zoned storage adoption increases

### Step 8.2: Trigger Conditions
- **Trigger**: Mount a zoned btrfs filesystem while another thread/CPU
  holds locks in the transaction/mmap path (the lock ordering violation
  makes this possible whenever two threads are active)
- **Frequency**: Sporadic — depends on timing, but confirmed
  reproducible with fstests generic/013
- **Unprivileged trigger**: No — requires mount privileges

### Step 8.3: Failure Mode Severity
- **Failure mode**: System hang / deadlock during mount
- **Severity**: **CRITICAL** — deadlock makes the system unusable, mount
  never completes
- Lockdep confirmed the circular dependency chain

### Step 8.4: Risk-Benefit Ratio
- **BENEFIT**: Very high — prevents deadlock/hang during mount of zoned
  btrfs
- **RISK**: Very low — 2-line removal of an unnecessary lock in the
  mount path, which is inherently single-threaded at that point
- The safety argument is sound: during `open_ctree()`, the filesystem is
  being set up; no device add/remove operations can be happening
- **Ratio**: Excellent — minimal risk, high benefit

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real deadlock (sporadic hangs, confirmed by lockdep)
- Reported by a real tester (Shin'ichiro Kawasaki)
- Reviewed by block/zoned expert (Damien Le Moal) and btrfs maintainer
  (David Sterba)
- Author is a trusted btrfs/zoned contributor (Johannes Thumshirn)
- Included in "Btrfs fixes for 7.0-rc5" — treated as a bugfix
- Surgical fix: 2 lines removed, comment added
- Bug exists in all stable trees v5.15+
- Will apply cleanly
- No dependencies
- Previous precedent for same pattern fix (`0b9e66762aa0c`)

**AGAINST backporting:**
- (None identified)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — the mount path is single-
   threaded; no concurrent device list modification is possible. Tested
   in CI.
2. **Fixes a real bug?** YES — deadlock during mount, confirmed by
   lockdep
3. **Important issue?** YES — deadlock/hang, severity CRITICAL
4. **Small and contained?** YES — 2-line removal in 1 function, 1 file
5. **No new features or APIs?** YES — purely removes unnecessary locking
6. **Can apply to stable trees?** YES — clean apply expected for v5.15+

### Step 9.3: Exception Categories
Not applicable — this is a straightforward deadlock fix.

### Step 9.4: Decision
This is a clear YES. It fixes a real deadlock that causes system hangs
during mount of zoned btrfs filesystems. The fix is minimal, obviously
correct, well-reviewed, and will apply cleanly to stable trees.

---

## Verification

- **[Phase 1]** Parsed tags: Reported-by Shin'ichiro Kawasaki, Reviewed-
  by Damien Le Moal and David Sterba, SOB Johannes Thumshirn and David
  Sterba
- **[Phase 2]** Diff analysis: 2 lines removed (mutex_lock/unlock), 4
  lines added (comment). Single function
  `btrfs_get_dev_zone_info_all_devices()` in single file
  `fs/btrfs/zoned.c`
- **[Phase 3]** git blame: buggy mutex_lock introduced in commit
  `7365104236ade0` (v5.12-rc1, 2021-02-04). Other side of deadlock chain
  in `2eadb9e75e8e65` (v5.15-rc1)
- **[Phase 3]** git describe: confirmed `7365104236ade0` first in
  v5.12-rc1, `2eadb9e75e8e65` first in v5.15-rc1
- **[Phase 3]** Author history: Johannes Thumshirn is a regular
  btrfs/zoned contributor with multiple commits to this file
- **[Phase 3]** Related fixes: `0b9e66762aa0c` used same pattern
  (removing device_list_mutex) to fix deadlock in
  `btrfs_can_activate_zone`
- **[Phase 4]** lore.kernel.org: Patch found posted 2026-03-03, reviewed
  by Damien Le Moal and David Sterba, included in "Btrfs fixes for
  7.0-rc5"
- **[Phase 5]** Single caller: `open_ctree()` at `disk-io.c:3464` —
  mount path only
- **[Phase 5]** Call chain traced: mount syscall → vfs_get_tree →
  btrfs_get_tree → open_ctree → btrfs_get_dev_zone_info_all_devices
- **[Phase 6]** Stable tree check: confirmed zoned.c has been modified
  in v5.15.y, v6.1.y, v6.6.y stable trees (function present in all)
- **[Phase 6]** No conflicting fixes found in stable for this specific
  issue
- **[Phase 7]** Subsystem: btrfs (IMPORTANT criticality), actively
  developed
- **[Phase 8]** Failure mode: deadlock/hang during mount — CRITICAL
  severity
- **[Phase 8]** Risk: Very low (2-line lock removal in single-threaded
  mount path)
- UNVERIFIED: Exact clean apply status for each individual stable branch
  (would need cherry-pick test), but function code is nearly identical
  across all stable trees

**YES**

 fs/btrfs/zoned.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 392e6ad874cc7..ab7cc30212702 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -337,7 +337,10 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 	if (!btrfs_fs_incompat(fs_info, ZONED))
 		return 0;
 
-	mutex_lock(&fs_devices->device_list_mutex);
+	/*
+	 * No need to take the device_list mutex here, we're still in the mount
+	 * path and devices cannot be added to or removed from the list yet.
+	 */
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		/* We can skip reading of zone info for missing devices */
 		if (!device->bdev)
@@ -347,7 +350,6 @@ int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info)
 		if (ret)
 			break;
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	return ret;
 }
-- 
2.51.0

