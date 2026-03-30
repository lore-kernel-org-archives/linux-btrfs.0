Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E653D0916;
	Mon, 30 Mar 2026 12:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874328; cv=none; b=IPx99bZ6YK3NRCcNB6Ra8WxMPCMSBCHQMey5GAzbAHAfUQ8CW8cmMji/mrKXgU81aFvqm2SoASCoaw4hd9JCdJNb3UuHivXZKy64f3JT1FmIkZ/tLmU6J/V0jUKql42xM+/LGSpvzZa3go30EtqS+IglONZh2Rud3N7SESIzV6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874328; c=relaxed/simple;
	bh=7XdtASUNy0X+9mhBuXcMBQWiuQRIcc0MoWkQaPynTgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXHhVljU0u19offxL+02o3i0e2AkgflsEr1KJV2kaInBPUwtQQa4S2wkraNcV32EskxVeh6fgKBMqSczKR3+FLw4bbkImjKSNOVgPFhBnmRzcHNT4mT52kdQ7MuoyEiUtR4LMtItJOhNyhsrVFcLghYoArGD5WvtM9eg9JkAuTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FuLGgCIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FuLGgCIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F47C2BCB3;
	Mon, 30 Mar 2026 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874327;
	bh=7XdtASUNy0X+9mhBuXcMBQWiuQRIcc0MoWkQaPynTgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuLGgCIXZlWpgIfUj3gERd9K8KatAyzEXJOJ6H7B7uwpCg9phF64XRl9jo11ebgWg
	 SRt62iALu7cLvGzGUoZUW83VNISElIT5k97742VaN8BUvFBGs2o9ip/qMftR+JbBVk
	 pEpFjDVayRMiZ49aU4SBihBqqUauJa2oztrzQOdgoNmQPisYRI4K8GbEGoZgvs26bZ
	 zjuFaHo1TEoxeivzzX3diEGWpTK8uHQ3FfmhvDqh1WNEkFd9shr0hBKVhY/mRXpoZq
	 uPAlZwhhQnOxkm5DrwLTMp2d1FX6u0gQEIqVEDlEJyddkBmg8mckrcmtDJw6Nu639r
	 bMCdDa4eXayUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Boris Burkov <boris@bur.io>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()
Date: Mon, 30 Mar 2026 08:38:16 -0400
Message-ID: <20260330123842.756154-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Upstream commit a85b46db143fda5869e7d8df8f258ccef5fa1719 ]

If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
super block and fsid assignment will lead to a crash.

Use file_inode(file)->i_sb to always get btrfs_sb.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the evidence. Here is the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [btrfs: tracepoints] [get correct / fix] [Fix incorrect
superblock derivation in the `btrfs_sync_file` trace event when
overlayfs is stacked on btrfs]

**Step 1.2: Tags**
- Reviewed-by: Boris Burkov <boris@bur.io> (btrfs developer/reviewer)
- Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com> (author, active
  btrfs contributor)
- Signed-off-by: David Sterba <dsterba@suse.com> (btrfs co-maintainer,
  committer)
- No Fixes: tag (expected for commits under manual review)
- No Reported-by:, Tested-by:, Link:, or Cc: stable tags

Record: Reviewed by btrfs developer, committed by btrfs maintainer. No
Fixes: or Cc: stable (expected for manually reviewed candidates).

**Step 1.3: Commit Body**
Record: Bug: when overlayfs is used on top of btrfs, `dentry->d_sb` in
the tracepoint resolves to the overlay superblock, not btrfs'. The
`btrfs_sb()` inline function then treats the overlay's `s_fs_info` as
`struct btrfs_fs_info *`, and `TP_fast_assign_fsid` dereferences
`fs_info->fs_devices->fsid`—accessing completely invalid memory.
Symptom: kernel crash. Fix: use `file_inode(file)->i_sb` to always get
the btrfs superblock.

**Step 1.4: Hidden Bug Fix**
Record: Not hidden—this is an explicit crash fix. The commit message
directly states "will lead to a crash."

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file changed: `include/trace/events/btrfs.h`. Approximately 6
lines added, 4 removed within the `TP_fast_assign` block of
`TRACE_EVENT(btrfs_sync_file)`. Single-file, surgical fix.

**Step 2.2: Code Flow Change**

Before:
```c
const struct dentry *dentry = file->f_path.dentry;
const struct inode *inode = d_inode(dentry);
TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
__entry->parent = btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
```

After:
```c
struct dentry *dentry = file_dentry(file);
struct inode *inode = file_inode(file);
struct dentry *parent = dget_parent(dentry);
struct inode *parent_inode = d_inode(parent);
dput(parent);
TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
__entry->parent = btrfs_ino(BTRFS_I(parent_inode));
```

Three independent improvements:
1. **Critical crash fix**: `file->f_path.dentry->d_sb` → `inode->i_sb`
   for the fsid assignment
2. **Correctness**: `file->f_path.dentry` → `file_dentry(file)` and
   `d_inode(dentry)` → `file_inode(file)` (overlay-safe helpers)
3. **Safety**: parent dentry now accessed via `dget_parent()`/`dput()`
   (proper reference counting)

Record: Single hunk, tracepoint-only path, three small correctness
improvements.

**Step 2.3: Bug Mechanism**
Verified:
- `btrfs_sb(sb)` returns `sb->s_fs_info` (`fs/btrfs/super.h` line 21–24)
- `TP_fast_assign_fsid(fs_info)` does `memcpy(__entry->fsid,
  fs_info->fs_devices->fsid, BTRFS_FSID_SIZE)` (line 163–170)
- Overlayfs stores `struct ovl_fs *` in `sb->s_fs_info`
  (`fs/overlayfs/ovl_entry.h` line 115–121)
- When overlay sb is passed to `btrfs_sb()`, the returned pointer is not
  a `btrfs_fs_info`; dereferencing `->fs_devices->fsid` accesses invalid
  memory → crash

Record: [Type confusion via wrong superblock] [overlay's `s_fs_info`
interpreted as `btrfs_fs_info *`, then invalid dereference of
`fs_devices->fsid`]

**Step 2.4: Fix Quality**
Record: Obviously correct—this is the only btrfs tracepoint using
`file->f_path.dentry->d_sb`; all others already use `inode->i_sb`. Fix
aligns this tracepoint with the established pattern. Very low regression
risk: changes only tracepoint data assignment code.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Verified via `git blame -L 771,779`:
- The buggy fsid line
  (`TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb))`)
  introduced in commit `bc074524e123de` (Jeff Mahoney, 2016-06-09,
  "btrfs: prefix fsid to all trace events")
- `git describe --contains bc074524e123de` → `v4.8-rc1~38^2~1^2~12`
- Bug has been present since **v4.8-rc1** — all currently active stable
  trees are affected

Record: [Bug introduced in bc074524e123de, first in v4.8-rc1, present
since 2016 in all active stable trees]

**Step 3.2: Fixes Tag**
Record: No Fixes: tag present. The implicit target is bc074524e123de.

**Step 3.3: File History**
Verified via `git log --oneline -20 -- include/trace/events/btrfs.h`:
- Related prior fix: `f157dd661339f` ("btrfs: fix NULL dereference on
  root when tracing inode eviction") — a different tracepoint crash fix
  in the same file
- Historical related fix: `de17e793b104d` ("btrfs: fix crash/invalid
  memory access on fsync when using overlayfs") — this fixed the **core
  `btrfs_sync_file()` function** for the same overlayfs class of bug,
  but did NOT fix the tracepoint. The current commit completes that
  work.
- The historical commit includes a full oops trace showing the exact
  crash scenario

Record: [Standalone fix. Historical `de17e793b104d` fixed the fsync
function itself but left the tracepoint buggy. This commit completes
that fix.]

**Step 3.4: Author**
Verified: Goldwyn Rodrigues has 10+ btrfs commits including folio
conversions and core btrfs work. David Sterba is a listed btrfs
maintainer.
Record: [Author is established btrfs contributor from SUSE; committed by
btrfs maintainer]

**Step 3.5: Dependencies**
Verified: `file_dentry()`, `file_inode()`, `dget_parent()`, `dput()` all
exist in v5.15, v6.1, v6.6 stable trees.
Record: [No dependencies. All required helper APIs confirmed present in
stable trees.]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Lore Search**
Record: lore.kernel.org returned Anubis anti-bot challenge — exact patch
thread not verified.

**Step 4.2: Bug Report**
Verified: The historical commit `de17e793b104d` includes a full kernel
oops trace from `btrfs_sync_file` when using overlayfs. This establishes
that overlayfs+btrfs fsync crashes are a known, real-world class of bug.
The current tracepoint fix addresses the remaining instance of the same
pattern.
Record: [Real-world crash reports documented in historical commit
de17e793b104d with full stack trace]

**Step 4.3–4.4: Related Patches / Stable History**
Record: Could not verify lore threads. No evidence of prior stable
selection for this specific tracepoint fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
Record: `TRACE_EVENT(btrfs_sync_file)` — specifically its
`TP_fast_assign` block

**Step 5.2: Callers**
Verified: `trace_btrfs_sync_file(file, datasync)` called from exactly
one place: `fs/btrfs/file.c:1578` inside `btrfs_sync_file()`.

**Step 5.3–5.4: Call Chain / Reachability**
Verified complete path:
- `fsync(2)` / `fdatasync(2)` → `do_fsync()` → `vfs_fsync()` →
  `vfs_fsync_range()` → `btrfs_sync_file()` → `trace_btrfs_sync_file()`
- Overlayfs path: `ovl_fsync()` (line 441 of `fs/overlayfs/file.c`) →
  `vfs_fsync_range(upperfile, ...)` → `btrfs_sync_file()` →
  `trace_btrfs_sync_file()`
- The tracepoint body executes only when the `btrfs_sync_file`
  tracepoint is enabled (static key gated)

Record: [Directly reachable from userspace fsync() syscall. Overlayfs
path confirmed via ovl_fsync(). Tracepoint gated by static key.]

**Step 5.5: Similar Patterns**
Verified: `TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb))`
appears only once in the entire file — this tracepoint. All other btrfs
tracepoints use `inode->i_sb` or receive `fs_info` directly. This is the
sole inconsistent instance.
Record: [Only tracepoint with this bug pattern; all others already
correct]

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Presence in Stable Trees**
Verified via `git cat-file -p`:
- v5.15: buggy line at line 701 ✓
- v6.1: buggy line at line 766 ✓
- v6.6: buggy line at line 795 ✓

Record: [All active stable trees (v5.15, v6.1, v6.6) contain the exact
buggy line]

**Step 6.2: Backport Complications**
Record: Clean apply expected for recent stable trees — same code
structure, same APIs available. Minor line number offsets only.

**Step 6.3: Duplicate Fixes**
Record: No alternative fix for this tracepoint found in any stable tree.
The historical `de17e793b104d` fixed only the function, not the
tracepoint.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
Record: btrfs filesystem tracepoints — IMPORTANT subsystem. btrfs is
widely used, especially with overlayfs in container environments
(Docker, Podman).

**Step 7.2: Activity**
Record: Active — `include/trace/events/btrfs.h` has seen 20+ recent
commits including other tracepoint crash fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Record: Users running overlayfs on top of btrfs with btrfs tracepoints
enabled. This includes container workloads and debugging/tracing
scenarios on production systems.

**Step 8.2: Trigger Conditions**
Record: Enable `btrfs_sync_file` tracepoint (or all btrfs events) + use
overlayfs on btrfs + any `fsync()`/`fdatasync()` call. Deterministic
when conditions met — not a race.

**Step 8.3: Failure Mode**
Record: Kernel crash / oops from invalid memory access in tracepoint
assignment. Severity: **CRITICAL** when triggered (system crash,
potential data loss from incomplete fsync).

**Step 8.4: Risk-Benefit**
- BENEFIT: HIGH — prevents a deterministic kernel crash in a real,
  userspace-triggerable path
- RISK: VERY LOW — ~10 lines changed in a single tracepoint, using
  established VFS helpers consistent with all other btrfs tracepoints
Record: [Benefit: HIGH, Risk: VERY LOW, Ratio: Excellent for
backporting]

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes a real kernel crash (type confusion → invalid memory access →
  oops)
- Small, surgical fix: ~10 lines in 1 file, 1 tracepoint
- Obviously correct: aligns with how all other btrfs tracepoints handle
  the superblock
- Bug class verified real via historical commit `de17e793b104d` with
  full crash stack trace
- Reviewed by btrfs developer, committed by btrfs maintainer
- Bug present in ALL active stable trees (v5.15, v6.1, v6.6) — confirmed
- All required helper APIs exist in stable trees — confirmed
- No dependencies on other commits
- Overlayfs call path verified to reach the buggy code

AGAINST backporting:
- Tracepoint must be enabled to trigger (narrower population than core
  path bugs)
- No Tested-by: tag

UNRESOLVED:
- Exact lore.kernel.org patch discussion thread (blocked by Anubis)
- Whether unprivileged users can enable this tracepoint
- `git apply --check` not run against stable branches (but same code
  confirmed present)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — consistent with all other
   btrfs tracepoints; maintainer-reviewed
2. Fixes a real bug? **YES** — kernel crash with overlayfs+btrfs+tracing
3. Important issue? **YES** — kernel oops (CRITICAL)
4. Small and contained? **YES** — ~10 lines, single tracepoint
5. No new features/APIs? **YES** — pure bug fix
6. Applies to stable? **YES** — buggy code and required APIs confirmed
   in v5.15/v6.1/v6.6

**Step 9.3: Exception Categories**
Record: Not applicable. This is a standard bug fix, not a device
ID/quirk/DT exception.

**Step 9.4: Decision**
The fix addresses a real, deterministic kernel crash caused by type
confusion when overlayfs is stacked on btrfs. The crash mechanism is
fully verified: `btrfs_sb()` interprets overlay's `s_fs_info` (an
`ovl_fs *`) as `btrfs_fs_info *`, then `TP_fast_assign_fsid`
dereferences `fs_info->fs_devices->fsid` — accessing garbage memory. The
fix is small, obviously correct, consistent with all other btrfs
tracepoints, and has no dependencies. The bug exists in all active
stable trees. The only limiting factor is that tracepoints must be
enabled, but stable kernels are regularly used with tracing enabled for
support and debugging, and a crash in that scenario is unacceptable.

---

## Verification

- [Phase 1] Parsed tags from commit message: Reviewed-by Boris Burkov,
  SOB from David Sterba (btrfs maintainer), SOB from Goldwyn Rodrigues
  (author). No Fixes:, Reported-by:, Link:, Cc: stable.
- [Phase 2] Read `include/trace/events/btrfs.h` lines 163–170: confirmed
  `TP_fast_assign_fsid` does `memcpy(__entry->fsid,
  fs_info->fs_devices->fsid, BTRFS_FSID_SIZE)`
- [Phase 2] Read `include/trace/events/btrfs.h` lines 771–779: confirmed
  pre-fix code uses `file->f_path.dentry->d_sb`
- [Phase 2] Grep confirmed `btrfs_sb()` returns `sb->s_fs_info` in
  `fs/btrfs/super.h` lines 21–24
- [Phase 2] Read `fs/overlayfs/ovl_entry.h` lines 115–121: confirmed
  `OVL_FS(sb)` casts `sb->s_fs_info` to `struct ovl_fs *` — type
  confusion verified
- [Phase 2] Grep confirmed the buggy
  `TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb))` is the ONLY
  such pattern in btrfs.h
- [Phase 3] `git blame -L 771,779`: buggy fsid line from
  `bc074524e123de` (Jeff Mahoney, 2016)
- [Phase 3] `git describe --contains bc074524e123de`:
  `v4.8-rc1~38^2~1^2~12` — bug present since v4.8
- [Phase 3] `git show de17e793b104d`: confirmed historical
  overlayfs+btrfs fsync crash with full kernel oops trace; that fix
  addressed only `btrfs_sync_file()`, NOT the tracepoint
- [Phase 3] `git log --oneline --author="Goldwyn Rodrigues" -10 --
  fs/btrfs`: confirmed active btrfs contributor
- [Phase 4] lore.kernel.org: blocked by Anubis — patch thread UNVERIFIED
- [Phase 5] Grep: `trace_btrfs_sync_file` called from exactly
  `fs/btrfs/file.c:1578`
- [Phase 5] Read `fs/overlayfs/file.c` lines 441–464: confirmed
  `ovl_fsync()` → `vfs_fsync_range(upperfile)` call path
- [Phase 6] `git cat-file -p v5.15:include/trace/events/btrfs.h`: buggy
  line at line 701 ✓
- [Phase 6] `git cat-file -p v6.1:include/trace/events/btrfs.h`: buggy
  line at line 766 ✓
- [Phase 6] `git cat-file -p v6.6:include/trace/events/btrfs.h`: buggy
  line at line 795 ✓
- [Phase 6] Verified `file_inode`, `file_dentry`, `dget_parent` present
  in v5.15, v6.1, v6.6 via `git cat-file` grep
- [Phase 8] Failure mode: kernel oops from invalid memory access in
  tracepoint assignment, severity CRITICAL
- UNVERIFIED: Exact lore patch discussion (Anubis blocked); privilege
  requirements for tracepoint enablement; `git apply --check` on stable
  branches

**YES**

 include/trace/events/btrfs.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 125bdc166bfed..0864700f76e0a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -769,12 +769,15 @@ TRACE_EVENT(btrfs_sync_file,
 	),
 
 	TP_fast_assign(
-		const struct dentry *dentry = file->f_path.dentry;
-		const struct inode *inode = d_inode(dentry);
+		struct dentry *dentry = file_dentry(file);
+		struct inode *inode = file_inode(file);
+		struct dentry *parent = dget_parent(dentry);
+		struct inode *parent_inode = d_inode(parent);
 
-		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
+		dput(parent);
+		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
-		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
+		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
 		__entry->datasync	= datasync;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
 	),
-- 
2.53.0

