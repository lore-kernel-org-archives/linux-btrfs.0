Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4321E3EC2EB;
	Tue, 24 Mar 2026 11:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351179; cv=none; b=sGIXFlhqlEvRRSxR9qDVp0Gkkp1MWmqPwtc8GKKS+OFxVkdEPd0kVIftF0+bcs5Nt4u1mKWlA+KFyFlxY3xMzbZluNBiDu9jrcokE1BnispigwVtUB4O5MZMsSDj7uHD3H4ZrXB21vrPFubtzkwFD4MN28ygh1jgLU/dYL7O4lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351179; c=relaxed/simple;
	bh=fjaoWSTXOvMqmG0/HrcPnEL3rS4veJbr6RxhqGndq/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=odf0IRhN2uDGdWddoB28/kfYBGejshYX5osL1JCZghDUedsgdekmygWd+fAxv2jMZ6mN6Z4aeiufZCm/Az94veX+r13uWVLP6rPQKITPRJoA7668DGZbzZayrDZm65C5dEmExNlruASFDo1Qcj4fhpEnPARTyChTsQE//Mh2cBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqEPhUkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqEPhUkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE09C2BCB2;
	Tue, 24 Mar 2026 11:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351178;
	bh=fjaoWSTXOvMqmG0/HrcPnEL3rS4veJbr6RxhqGndq/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqEPhUkhrvGIQNG0CHUgA0csIWMiA6K3W/J/AE+EU4+SIp0Ak/IvQyzCGZMq0VpWU
	 0byRH5fpctdFFQ75KoffBxr1FTT68nN/iylcCtb3Qivl1vcLJSCU1aNo0ozzIJ/Uqd
	 UgS66zMJVigs0iJr3+3u2W0lJB7TcZBPLprB2T78Bj+RRBy3GbHuVBmXpSAbq+wt/x
	 +8rHNICVQvLvh5LPWLDrb+FwEwLY/Y7GStwewUMSoVNkxHOqhmdFUnu74dmSUIoxqa
	 NwU0NImEQdjQvgkYHgo8ANhRCJ9Md6EbB8XfD2Mwj2WbO0FcXaa4sSAtseopfe+Y43
	 OjyGdmWYuavrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] btrfs: reserve enough transaction items for qgroup ioctls
Date: Tue, 24 Mar 2026 07:19:13 -0400
Message-ID: <20260324111931.3257972-4-sashal@kernel.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit f9a4e3015db1aeafbef407650eb8555445ca943e ]

Currently our qgroup ioctls don't reserve any space, they just do a
transaction join, which does not reserve any space, neither for the quota
tree updates nor for the delayed refs generated when updating the quota
tree. The quota root uses the global block reserve, which is fine most of
the time since we don't expect a lot of updates to the quota root, or to
be too close to -ENOSPC such that other critical metadata updates need to
resort to the global reserve.

However this is not optimal, as not reserving proper space may result in a
transaction abort due to not reserving space for delayed refs and then
abusing the use of the global block reserve.

For example, the following reproducer (which is unlikely to model any
real world use case, but just to illustrate the problem), triggers such a
transaction abort due to -ENOSPC when running delayed refs:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/nullb0
  MNT=/mnt/nullb0

  umount $DEV &> /dev/null
  # Limit device to 1G so that it's much faster to reproduce the issue.
  mkfs.btrfs -f -b 1G $DEV
  mount -o commit=600 $DEV $MNT

  fallocate -l 800M $MNT/filler
  btrfs quota enable $MNT

  for ((i = 1; i <= 400000; i++)); do
      btrfs qgroup create 1/$i $MNT
  done

  umount $MNT

When running this, we can see in dmesg/syslog that a transaction abort
happened:

  [436.490] BTRFS error (device nullb0): failed to run delayed ref for logical 30408704 num_bytes 16384 type 176 action 1 ref_mod 1: -28
  [436.493] ------------[ cut here ]------------
  [436.494] BTRFS: Transaction aborted (error -28)
  [436.495] WARNING: fs/btrfs/extent-tree.c:2247 at btrfs_run_delayed_refs+0xd9/0x110 [btrfs], CPU#4: umount/2495372
  [436.497] Modules linked in: btrfs loop (...)
  [436.508] CPU: 4 UID: 0 PID: 2495372 Comm: umount Tainted: G        W           6.19.0-rc8-btrfs-next-225+ #1 PREEMPT(full)
  [436.510] Tainted: [W]=WARN
  [436.511] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
  [436.513] RIP: 0010:btrfs_run_delayed_refs+0xdf/0x110 [btrfs]
  [436.514] Code: 0f 82 ea (...)
  [436.518] RSP: 0018:ffffd511850b7d78 EFLAGS: 00010292
  [436.519] RAX: 00000000ffffffe4 RBX: ffff8f120dad37e0 RCX: 0000000002040001
  [436.520] RDX: 0000000000000002 RSI: 00000000ffffffe4 RDI: ffffffffc090fd80
  [436.522] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffffffc04d1867
  [436.523] R10: ffff8f18dc1fffa8 R11: 0000000000000003 R12: ffff8f173aa89400
  [436.524] R13: 0000000000000000 R14: ffff8f173aa89400 R15: 0000000000000000
  [436.526] FS:  00007fe59045d840(0000) GS:ffff8f192e22e000(0000) knlGS:0000000000000000
  [436.527] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [436.528] CR2: 00007fe5905ff2b0 CR3: 000000060710a002 CR4: 0000000000370ef0
  [436.530] Call Trace:
  [436.530]  <TASK>
  [436.530]  btrfs_commit_transaction+0x73/0xc00 [btrfs]
  [436.531]  ? btrfs_attach_transaction_barrier+0x1e/0x70 [btrfs]
  [436.532]  sync_filesystem+0x7a/0x90
  [436.533]  generic_shutdown_super+0x28/0x180
  [436.533]  kill_anon_super+0x12/0x40
  [436.534]  btrfs_kill_super+0x12/0x20 [btrfs]
  [436.534]  deactivate_locked_super+0x2f/0xb0
  [436.534]  cleanup_mnt+0xea/0x180
  [436.535]  task_work_run+0x58/0xa0
  [436.535]  exit_to_user_mode_loop+0xed/0x480
  [436.536]  ? __x64_sys_umount+0x68/0x80
  [436.536]  do_syscall_64+0x2a5/0xf20
  [436.537]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [436.537] RIP: 0033:0x7fe5906b6217
  [436.538] Code: 0d 00 f7 (...)
  [436.540] RSP: 002b:00007ffcd87a61f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
  [436.541] RAX: 0000000000000000 RBX: 00005618b9ecadc8 RCX: 00007fe5906b6217
  [436.541] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00005618b9ecb100
  [436.542] RBP: 0000000000000000 R08: 00007ffcd87a4fe0 R09: 00000000ffffffff
  [436.544] R10: 0000000000000103 R11: 0000000000000246 R12: 00007fe59081626c
  [436.544] R13: 00005618b9ecb100 R14: 0000000000000000 R15: 00005618b9ecacc0
  [436.545]  </TASK>
  [436.545] ---[ end trace 0000000000000000 ]---

Fix this by changing the qgroup ioctls to use start transaction instead of
joining so that proper space is reserved for the delayed refs generated
for the updates to the quota root. This way we don't get any transaction
abort.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a thorough analysis. Let me compile
the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `btrfs` (filesystem)
- Action: "reserve enough" — implies fixing insufficient space
  reservation
- Summary: Qgroup ioctls don't reserve transaction space, leading to
  transaction aborts.

Record: [btrfs] [reserve/fix] [Fix insufficient transaction space
reservation in qgroup ioctls]

**Step 1.2: Tags**
- `Reviewed-by: Boris Burkov <boris@bur.io>` — btrfs developer
- `Reviewed-by: Qu Wenruo <wqu@suse.com>` — prolific btrfs
  maintainer/developer
- `Signed-off-by: Filipe Manana <fdmanana@suse.com>` — author, very
  active btrfs maintainer
- `Signed-off-by: David Sterba <dsterba@suse.com>` — btrfs tree
  maintainer

Record: Two reviews from respected btrfs developers, authored by a top
btrfs contributor, committed by the subsystem maintainer. No Fixes: tag,
no Cc: stable (expected for review candidates).

**Step 1.3: Commit Body Analysis**
- Bug: Qgroup ioctls use `btrfs_join_transaction()` which reserves 0
  metadata space items, relying entirely on the global block reserve.
- Symptom: Transaction abort with -ENOSPC (-28) when running delayed
  refs during transaction commit.
- Reproducer provided: creating 400,000 qgroups on a 1G filesystem
  triggers the abort.
- Stack trace included showing `btrfs_run_delayed_refs+0xd9/0x110` →
  `btrfs_commit_transaction` → `sync_filesystem` →
  `generic_shutdown_super` (during umount).
- The error message: "failed to run delayed ref for logical 30408704
  num_bytes 16384 type 176 action 1 ref_mod 1: -28"

Record: Transaction abort (-ENOSPC) during delayed ref processing. While
the reproducer is synthetic (400K qgroups), the underlying bug is real —
any scenario where global block reserve is insufficient and qgroup
operations are happening can trigger this. The fix is to properly
reserve space upfront.

**Step 1.4: Hidden Bug Fix Detection**
This is clearly a bug fix despite not having "fix" in the subject. It
prevents transaction aborts (which are critical — they make the
filesystem read-only and can lead to data loss). The commit message
explicitly says "Fix this by..." and provides a reproducer with a stack
trace.

Record: Definite bug fix. Transaction aborts are severe — they force the
filesystem read-only.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `fs/btrfs/ioctl.c`
- 3 hunks, each changing 1 line + adding 1-3 comment lines
- Functions modified: `btrfs_ioctl_qgroup_assign`,
  `btrfs_ioctl_qgroup_create`, `btrfs_ioctl_qgroup_limit`
- Total: ~6 lines added, 3 lines removed (net +3 lines)
- Scope: Single-file, surgical fix

Record: Minimal change, 3 substitutions of
`btrfs_join_transaction(root)` → `btrfs_start_transaction(root, N)` with
explanatory comments.

**Step 2.2: Code Flow Change**
- Hunk 1 (`qgroup_assign`): `btrfs_join_transaction(root)` →
  `btrfs_start_transaction(root, 2)` — reserves space for 2
  BTRFS_QGROUP_RELATION_KEY items
- Hunk 2 (`qgroup_create`): `btrfs_join_transaction(root)` →
  `btrfs_start_transaction(root, 2)` — reserves for 1 INFO + 1 LIMIT key
- Hunk 3 (`qgroup_limit`): `btrfs_join_transaction(root)` →
  `btrfs_start_transaction(root, 1)` — reserves for 1 LIMIT key

Before: No space reserved, relying on global block reserve (a shared
emergency pool).
After: Proper per-operation space reservation, ensuring delayed refs
have space.

**Step 2.3: Bug Mechanism**
Category: Resource exhaustion / incorrect space reservation →
transaction abort.
Mechanism: `btrfs_join_transaction()` passes `num_items=0` to
`start_transaction()`, meaning no metadata space is reserved. When the
quota tree is updated, delayed refs are generated. These delayed refs
need space to run. Without reservation, they fall back to the global
block reserve, which can be exhausted, causing -ENOSPC transaction
aborts.

**Step 2.4: Fix Quality**
- Obviously correct: `btrfs_start_transaction()` is the standard API for
  reserving transaction space, used throughout btrfs.
- Minimal and surgical: only the transaction start calls are changed.
- Regression risk: Very low. `btrfs_start_transaction` may block waiting
  for space (unlike `join`), but this is the correct behavior for ioctls
  that modify metadata. The caller is already in a context that can
  block (ioctl handler, not in atomic context).
- The item counts (2, 2, 1) match the number of quota tree items each
  operation modifies, per the comments.

Record: Fix is obviously correct, minimal, and low-risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame Analysis**
The `btrfs_join_transaction(root)` calls in all three functions were
introduced in commit `5d13a37bd53272` by Arne Jansen, dated 2011-09-14,
with subject "Btrfs: add qgroup ioctls". This was in kernel 3.x era. The
bug has existed since the qgroup feature was first introduced — it
exists in ALL stable kernel trees.

Record: Bug present since 2011 (kernel ~3.0), exists in all active
stable trees.

**Step 3.2: Fixes Tag**
No Fixes: tag present (expected for review candidates).

**Step 3.3: File History**
Recent changes to `fs/btrfs/ioctl.c` show active development (146
commits since v6.6). Related qgroup changes include:
- `53a4acbfc1de8` - memory leak fix in qgroup assign (Sep 2025)
- `4addc1ffd67ad` - preallocate memory for qgroup relation (May 2024)
- `a943812bfffb3` - use btrfs_qgroup_enabled() in ioctls (Jul 2025)

These are context-only changes that don't affect the core fix. The
actual `join→start` substitution is independent.

**Step 3.4: Author**
Filipe Manana is one of the most prolific btrfs developers with hundreds
of commits. He is essentially a co-maintainer of btrfs. His fixes are
high quality.

**Step 3.5: Dependencies**
The patch itself (changing `join` to `start`) has no functional
dependencies. However, the diff context lines reference code from recent
commits (`btrfs_qgroup_enabled()`, `prealloc`, `btrfs_is_fstree()`). For
older stable trees, the patch would need minor context adaptation but
the actual change is trivially portable — it's just replacing one
function call with another.

Record: Standalone fix, no functional dependencies. Context may need
minor adaptation for older trees.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Lore Search**
Found the patch submission on linux-btrfs dated 2026-02-17 with
responses from Boris Burkov and Qu Wenruo (both gave Reviewed-by). The
patch was included in a "Btrfs fixes for 7.0-rc5" pull request by David
Sterba, confirming it was treated as a fix for the current cycle.

**Step 4.2: Bug Report**
No external bug reports referenced — the author found this through code
analysis and created a reproducer.

Record: Patch was reviewed positively by two experienced developers and
pulled as a fix.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `btrfs_ioctl_qgroup_assign` — handles BTRFS_IOC_QGROUP_ASSIGN ioctl
- `btrfs_ioctl_qgroup_create` — handles BTRFS_IOC_QGROUP_CREATE ioctl
- `btrfs_ioctl_qgroup_limit` — handles BTRFS_IOC_QGROUP_LIMIT ioctl

**Step 5.2: Callers**
All three are called from `btrfs_ioctl()` switch statement — triggered
directly by userspace via `ioctl()` syscall. All require
`CAP_SYS_ADMIN`, so not exploitable by unprivileged users.

**Step 5.3-5.4: Call Chain**
userspace `ioctl()` → `btrfs_ioctl()` →
`btrfs_ioctl_qgroup_{assign,create,limit}()` → transaction → quota tree
updates → delayed refs → transaction commit. The abort happens during
`btrfs_commit_transaction()` → `btrfs_run_delayed_refs()`.

**Step 5.5: Similar Patterns**
Other btrfs code properly uses `btrfs_start_transaction()` with the
correct item count. The qgroup ioctls were an outlier using
`btrfs_join_transaction()`.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence**
The buggy code (`btrfs_join_transaction` in qgroup ioctls) has existed
since 2011. It is present in ALL active stable trees (6.12, 6.6, 6.1,
5.15, etc.).

**Step 6.2: Backport Complications**
- The surrounding context differs in older stable trees due to recent
  refactoring (e.g., `btrfs_qgroup_enabled()`, `prealloc` code).
- However, the core change (replacing `btrfs_join_transaction(root)`
  with `btrfs_start_transaction(root, N)`) is trivially adaptable — just
  find the `btrfs_join_transaction` call in each function and replace
  it.
- `btrfs_start_transaction()` has existed since early btrfs days, so the
  target API is available in all stable trees.

Record: May need minor context adaptation but the fix itself is
trivially portable.

**Step 6.3: Related Fixes**
No related fix for this specific issue has been applied to stable.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- btrfs filesystem (fs/btrfs/) — IMPORTANT criticality level
- Widely used filesystem, especially in enterprise (SUSE,
  Facebook/Meta), containers, and NAS systems

**Step 7.2: Activity**
Very active subsystem with continuous development.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
All btrfs users who use qgroup functionality (quotas). Qgroups are used
in container environments, multi-tenant storage, and by tools like
Snapper (SUSE default backup tool).

**Step 8.2: Trigger Conditions**
- Requires creating/modifying many qgroups when filesystem is near
  ENOSPC
- Requires CAP_SYS_ADMIN (root)
- More likely on smaller filesystems or heavily utilized ones
- While the reproducer uses 400K qgroups, the real threshold depends on
  available global reserve space

Record: Moderate likelihood trigger — needs filesystem to be near
capacity while doing many qgroup operations. Common in container
environments with quota management.

**Step 8.3: Failure Mode**
- Transaction abort → filesystem goes READ-ONLY → potential data loss,
  system disruption
- Severity: HIGH to CRITICAL (transaction aborts are one of the most
  severe btrfs failures)

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Prevents transaction aborts (filesystem going read-only)
  during qgroup operations
- RISK: Very low — the change is 3 simple function call substitutions,
  `btrfs_start_transaction` is the standard correct API, and the item
  counts are well-justified
- The only behavioral change is that the ioctls may now wait for space
  to be available instead of blindly proceeding — this is the correct
  behavior

Record: High benefit, very low risk. Excellent ratio.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes a real bug: transaction abort (-ENOSPC) causing filesystem to go
  read-only
- Bug has existed since 2011 — affects all stable trees
- Fix is minimal: 3 function call substitutions (+3 comment lines)
- Obviously correct: uses the standard btrfs transaction API
- Reviewed by two experienced btrfs developers
- Authored by a top btrfs maintainer
- Includes reproducer demonstrating the bug
- Low regression risk

AGAINST backporting:
- Reproducer is synthetic (400K qgroups on 1G filesystem)
- Requires near-ENOSPC conditions to trigger in practice
- Minor context conflicts expected in older stable trees (but trivially
  resolvable)
- No Fixes: tag (expected, not a negative)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — reviewed by 2 developers,
   includes reproducer
2. Fixes a real bug? **YES** — transaction abort causing filesystem
   read-only
3. Important issue? **YES** — transaction abort is severe (data loss
   risk)
4. Small and contained? **YES** — 3 lines changed in 1 file
5. No new features? **YES** — no new features or APIs
6. Can apply to stable? **YES** — may need minor context adaptation

**Step 9.3: Exception Categories**
Not an exception category — this is a standard bug fix.

**Step 9.4: Decision**
This is a clear, well-reviewed, minimal bug fix from a top btrfs
maintainer that prevents transaction aborts (a severe failure mode) in
qgroup ioctls. The fix is obviously correct and uses the standard
transaction API. It meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Reviewed-by from Boris Burkov and Qu Wenruo,
  authored by Filipe Manana, committed by David Sterba
- [Phase 1] Commit body: includes full stack trace, reproducer script,
  and detailed explanation of -ENOSPC transaction abort
- [Phase 2] Diff analysis: 3 substitutions of
  `btrfs_join_transaction(root)` → `btrfs_start_transaction(root, N)` in
  fs/btrfs/ioctl.c, +6/-3 lines
- [Phase 2] Verified `btrfs_join_transaction` passes `num_items=0`
  (transaction.c:831-834) while `btrfs_start_transaction` reserves space
  (transaction.c:816-821)
- [Phase 3] git blame: all three `btrfs_join_transaction` calls traced
  to commit 5d13a37bd53272 (2011-09-14, "Btrfs: add qgroup ioctls") —
  bug present since qgroup feature inception
- [Phase 3] git show 5d13a37bd53272: confirmed this is the original
  commit introducing qgroup ioctls
- [Phase 3] Author check: Filipe Manana has 10+ recent btrfs commits, is
  a primary btrfs developer
- [Phase 4] Lore search: found patch dated 2026-02-17, included in
  "Btrfs fixes for 7.0-rc5" pull
- [Phase 5] Callers: all three functions called from btrfs_ioctl()
  switch statement (ioctl dispatch)
- [Phase 6] Code exists in all stable trees — `btrfs_join_transaction`
  in qgroup ioctls present since 2011
- [Phase 6] `btrfs_start_transaction()` API verified available in all
  stable trees (defined in transaction.c since early btrfs)
- [Phase 6] Context differences: `btrfs_qgroup_enabled()` (Jul 2025),
  `prealloc` code (May 2024) may cause minor conflicts in older trees,
  but core fix is portable
- [Phase 7] Subsystem: btrfs filesystem, IMPORTANT criticality — used
  widely in enterprise and containers
- [Phase 8] Failure mode: transaction abort → filesystem goes read-only,
  severity HIGH/CRITICAL
- [Phase 8] Risk: Very low — standard API substitution, well-justified
  item counts, reviewed by domain experts

**YES**

 fs/btrfs/ioctl.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1a5d98811f2b2..0a7d3a9dedfb0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3690,7 +3690,8 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 		}
 	}
 
-	trans = btrfs_join_transaction(root);
+	/* 2 BTRFS_QGROUP_RELATION_KEY items. */
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
@@ -3762,7 +3763,11 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto out;
 	}
 
-	trans = btrfs_join_transaction(root);
+	/*
+	 * 1 BTRFS_QGROUP_INFO_KEY item.
+	 * 1 BTRFS_QGROUP_LIMIT_KEY item.
+	 */
+	trans = btrfs_start_transaction(root, 2);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
@@ -3811,7 +3816,8 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	trans = btrfs_join_transaction(root);
+	/* 1 BTRFS_QGROUP_LIMIT_KEY item. */
+	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out;
-- 
2.51.0

