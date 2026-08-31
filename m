Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF5C486E41;
	Mon, 31 Aug 2026 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183490; cv=none; b=tCDmPpccAMfSuWNEBe6JEWhf+yxed05akpDVLRHcklNnJJzWhCsKYXlT+P6nWNGpY0Hg+EetBvRTNWOvTILoA/zcPei9VCawhAW17S00JYb+Q/ShwLWhClql+PJdb0vGufzKhQ2anYL6TwbSKC+Szcj5F31TevMdEMDRxamDxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183490; c=relaxed/simple;
	bh=UgXanXeCjUy+m/9uz1O9zt8v+tJsfeXUsXlMlpEBSuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYVOTWP0ixiePT+I4bvbvx1coYvtHCX8XJ1rxvkMaBT9luDThawEeGdvKJLgOcDLePtmXw2+1fCy7/6x4YhIVFchxQ4r4suRAMj67tmnrpgq1aiSYI5CxO1NfYGdI2MYalKD4YWreNNjvEmyAFijQLjL3NAIMVo7IkEsU2eNqC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPRTlttx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPRTlttx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304F01F00A3D;
	Mon, 31 Aug 2026 13:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183488;
	bh=7Z/M7hSsn7FlB3oYSo7G4ENB8eNrhml8RP7eak5WlIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPRTlttxWKQjR2C9vX3XuHvnFQaPDz/4LAEQ2t3wZX7iwRF35Hxf/taNrHYJeb5Ew
	 YmWpjZZWdtT3J4xQfWCltq4VU96J9RLrtyoQmUzOqVf7ONzvAjX+IRW3zc9DmSEryH
	 9r4CdKOdGR13wRciaG0BTIoYOrM9xshPmEEsnEbc5edIg2c7PlqyfRavHgsvVwD2nE
	 a61bkzUnkZoIOo4alwxlxh8mGneEsKLuHiIn1O5OBwbVGqFNGf3QBMtUOu7Xsni+wF
	 XFcz+Zbf6V5ZuhyGCklrFip8GenA4qeFXeZq/wpUiqF5qU9tO4KAwkkQxxNZYz8sUj
	 mk7iYEs7P7U1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Chen <davechen@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()
Date: Mon, 31 Aug 2026 09:22:34 -0400
Message-ID: <20260831133314.4125787-126-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chen <davechen@synology.com>

[ Upstream commit 9411aafdf352b8d72668732af5a37dcb27383e25 ]

btrfs_getattr() unconditionally reads BTRFS_I(inode)->new_delalloc_bytes
and adds it (sector-aligned) to stat->blocks for every inode type.
However, new_delalloc_bytes lives in a union with last_dir_index_offset:

    union {
        u64 new_delalloc_bytes;     /* files only */
        u64 last_dir_index_offset;  /* directories only */
    };

For a directory inode this memory holds last_dir_index_offset, which is
set during directory logging (e.g. flush_dir_items_batch()) to the
offset of the last logged BTRFS_DIR_INDEX_KEY.  That offset grows with
the number of entries ever created in the directory (dir indexes are
monotonic and never reused), so it can be arbitrarily large.

As a result, after a directory has been logged (e.g. via an fsync that
triggers directory logging), btrfs_getattr() reports inflated st_blocks
for that directory.  The inflation is purely in-core and disappears
after the inode is evicted and reloaded (btrfs_alloc_inode() zeroes the
union), e.g. after a remount.

Reproducer (on a btrfs filesystem):

    D=/mnt/btrfs/d
    mkdir -p $D
    for i in $(seq 1 20000); do touch $D/f$i; done
    sync                      # commit, push dir index high
    touch $D/trigger          # dirty the dir in a new transaction
    xfs_io -c fsync $D        # log the directory -> sets last_dir_index_offset
    stat -c '%b' $D           # st_blocks is now inflated (e.g. 40)
    # umount + mount -> st_blocks drops back to the correct value

The evict path already knows this union is type-dependent and guards the
corresponding WARN_ON with !S_ISDIR() in btrfs_destroy_inode(); only
btrfs_getattr() was missing the equivalent check.

Only read new_delalloc_bytes for regular files, which are the only
inodes that ever set it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: btrfs: only account delalloc bytes for
regular file inodes in btrfs_getattr()

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[btrfs]` `[fix implicit]` — only account delalloc bytes for
regular file inodes in `btrfs_getattr()`.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Filipe Manana `<fdmanana@suse.com>` (btrfs
  maintainer)
- **Signed-off-by:** Dave Chen `<davechen@synology.com>` (author)
- **Signed-off-by:** Filipe Manana `<fdmanana@suse.com>`
- **Signed-off-by:** David Sterba `<dsterba@suse.com>` (btrfs
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable tags
- Notable: dual btrfs maintainer sign-off; no syzbot/fuzzer report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `btrfs_getattr()` always reads
  `BTRFS_I(inode)->new_delalloc_bytes`, but that field shares a union
  with `last_dir_index_offset` (directories only).
- **Symptom:** After directory logging (e.g. `fsync` on a dirty
  directory), `stat()` reports inflated `st_blocks` for that directory.
  Value scales with number of directory entries ever created.
- **Failure mode:** Incorrect userspace-visible block count; purely in-
  core; resets after inode eviction/remount (`btrfs_alloc_inode()`
  zeroes the union).
- **Root cause:** Union member read without inode-type check;
  `btrfs_destroy_inode()` already guards the equivalent `WARN_ON` with
  `!S_ISDIR()`.
- **Reproducer:** Provided in commit message (20,000 files in a
  directory, sync, fsync, `stat -c '%b'`).

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit correctness fix for wrong
`st_blocks` reporting, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `fs/btrfs/inode.c` (+2/-1 lines)
- **Function:** `btrfs_getattr()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes` for
  every inode type.
- **After:** `delalloc_bytes = S_ISREG(inode->i_mode) ?
  BTRFS_I(inode)->new_delalloc_bytes : 0`
- **Path affected:** Normal `stat`/`statx` path for all btrfs inodes;
  bug manifests on directories after logging.

### Step 2.3: Bug mechanism
**Record:** **Logic / union misuse correctness bug.**
`new_delalloc_bytes` and `last_dir_index_offset` occupy the same union
memory. Directory logging (`flush_dir_items_batch()` in `tree-log.c`)
writes `last_dir_index_offset`; `btrfs_getattr()` misinterprets it as
pending delalloc bytes and inflates `stat->blocks`.

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors the existing `!S_ISDIR()` guard
in `btrfs_destroy_inode()`. Minimal change. No new locks or API changes.
Regression risk: very low (directories/symlinks/special files never
legitimately set `new_delalloc_bytes`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lines 8173–8178 blame to `5d324e5159d9e` (2025-11-28 merge).
Shallow clone limits deeper history; cannot pinpoint the exact
introducing commit beyond confirming the buggy pattern is present in
this tree.

### Step 3.2: Fixes: tag
**Record:** Not applicable — no Fixes: tag in commit message.

### Step 3.3: File history
**Record:** Recent `fs/btrfs/inode.c` changes are unrelated (bool types,
IO failure fix, folio removal, delalloc bit handling). No prior fix for
this issue found in this tree. Fix commit itself is **not** present
locally.

### Step 3.4: Author context
**Record:** Dave Chen has at least one other btrfs commit in this tree
(`39f196f64bd38` — metadata accounting type fix). btrfs maintainers
reviewed and signed off.

### Step 3.5: Dependencies
**Record:** Standalone — requires only `S_ISREG()` and existing union
layout. No series dependencies. Union and `btrfs_getattr()` delalloc
accounting both exist in v6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig` on related commit `0912b98151eea` succeeded (found
unrelated patch thread). Direct `b4 dig -c` on the fix commit hash was
unavailable (commit not in local tree). Lore.kernel.org fetch blocked by
bot protection. **Could not retrieve the fix patch's original lore
thread.**

### Step 4.2: Reviewers
**Record:** Filipe Manana (Reviewed-by + SOB) and David Sterba (SOB) —
both btrfs subsystem maintainers.

### Step 4.3: Bug report
**Record:** No external bug report links. Reproducer is self-contained
in the commit message.

### Step 4.4: Related patches
**Record:** Standalone one-commit fix; not part of a series.

### Step 4.5: Stable list history
**Record:** Not searched successfully (lore blocked). No Cc: stable in
commit message.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `btrfs_getattr()` modified.

### Step 5.2: Callers
**Record:** `btrfs_getattr` is registered as `.getattr` in:
- `btrfs_dir_inode_operations` (line 10597)
- `btrfs_file_inode_operations` (line 10658)
- `btrfs_special_inode_operations` (line 10670)
- `btrfs_symlink_inode_operations` (line 10680)

All inode types go through this function on `stat`/`statx`/`fstatat`.

### Step 5.3: Callees
**Record:** `generic_fillattr()`, `inode_get_bytes()`, spin lock on
`BTRFS_I(inode)->lock`, block alignment math for `stat->blocks`.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** via `stat()`, `fstat()`, `statx()`,
`ls -l`, `du`, and any tool reading `st_blocks`. Trigger requires btrfs
+ directory with logged entries + `fsync` — realistic on production
btrfs systems with large directories.

### Step 5.5: Similar patterns
**Record:** `btrfs_destroy_inode()` at lines 8045–8048 already uses `if
(!S_ISDIR(...))` before checking `new_delalloc_bytes`.
`btrfs_alloc_inode()` at lines 7967–7968 documents the union and zeroes
it. `btrfs_inode.h` lines 241–254 document per-type union usage. Only
`btrfs_getattr()` was missing the type guard.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current code at line 8174:

```8173:8178:fs/btrfs/inode.c
        spin_lock(&BTRFS_I(inode)->lock);
        delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
        inode_bytes = inode_get_bytes(inode);
        spin_unlock(&BTRFS_I(inode)->lock);
        stat->blocks = (ALIGN(inode_bytes, blocksize) +
                        ALIGN(delalloc_bytes, blocksize)) >>
SECTOR_SHIFT;
```

Union definition confirmed in `btrfs_inode.h` lines 241–254.
`last_dir_index_offset` is set in `tree-log.c` line 4090 during
`flush_dir_items_batch()`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — context matches the provided diff
exactly. No conflicting recent changes in this hunk.

### Step 6.3: Related fixes already present?
**Record:** **No** — `git grep` finds no `S_ISREG` guard around
`new_delalloc_bytes` in `btrfs_getattr()`. Fix commit not in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **fs/btrfs** — IMPORTANT. btrfs is widely deployed (servers,
NAS appliances, desktops). `stat` correctness affects monitoring, quota
tools, and backup software.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple recent fixes in `inode.c` in
this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** btrfs users who `stat`/`du` directories that have undergone
directory logging (common after `fsync` on directories with many
entries). Config-specific: `CONFIG_BTRFS_FS=y/m`.

### Step 8.2: Trigger conditions
**Record:** Directory with many entries → transaction commit → dirty
directory → `fsync` triggers directory logging → `last_dir_index_offset`
set → subsequent `stat` inflates `st_blocks`. Unprivileged users with
directory read access can trigger `stat`; `fsync` requires write access.
Not a race — deterministic logic bug.

### Step 8.3: Failure mode severity
**Record:** **Incorrect `st_blocks` reporting** — **MEDIUM**. No kernel
crash, corruption, deadlock, or security impact. User-visible wrong
disk-usage data. Self-corrects on remount/inode eviction. Can mislead
`du`, monitoring, and capacity planning tools.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — corrects real, reproducible stat data on a
  widely used filesystem
- **Risk:** VERY LOW — 2-line type guard matching existing in-tree
  pattern
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible bug with clear mechanism (union misuse)
- User-visible incorrect `st_blocks` on normal btrfs operations
- Obviously correct fix, reviewed by btrfs maintainers
- Tiny, self-contained, no dependencies
- Buggy code confirmed present in v6.18.44; fix not yet applied
- Consistent with existing `!S_ISDIR()` guard in `btrfs_destroy_inode()`

**AGAINST backport:**
- No crash, corruption, security, or deadlock
- In-core only; self-heals on remount
- Does not affect on-disk state or actual space allocation
- `st_blocks` for directories is often less critical than for files

**Unresolved:**
- Exact commit that introduced the bug (shallow clone)
- Lore discussion thread (site blocked)
- No user/distro bug reports found

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainers
   reviewed; reproducer provided
2. Fixes a real bug affecting users? **PASS** — wrong `st_blocks` after
   `fsync` on large directories
3. Important issue? **PASS (borderline)** — not crash/corruption, but a
   real user-visible "oh, that's not good" stat bug per `stable-kernel-
   rules.rst`
4. Small and contained? **PASS** — 3 lines in one function
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   expected

### Step 9.3: Exception categories
**Record:** Not applicable (not device ID, quirk, DT, build, or docs
fix).

### Step 9.4: Decision rationale

For **Linux 6.18.44**, the bug exists: `btrfs_getattr()` reads a file-
only union member for directory inodes, producing inflated `st_blocks`
after directory logging. This is a genuine btrfs correctness bug
reachable through normal `fsync` + `stat` operations. While not a crash
or corruption issue, it produces wrong userspace-visible data on a major
filesystem — exactly the kind of contained logic fix stable trees accept
when maintainers have reviewed it. The fix is trivial, matches an
existing in-tree pattern, and carries negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed commit message: subsystem=btrfs, tags=Reviewed-by
  Filipe Manana, SOBs from author + maintainers
- **[Phase 2]** Diff: 1 file, `btrfs_getattr()`, +2/-1, union misuse fix
- **[Phase 3]** `git describe HEAD`: v6.18.44; shallow repo (11944
  commits)
- **[Phase 3]** `git blame -L 8173,8174 fs/btrfs/inode.c`: buggy line
  present, dates to 2025-11-28 merge
- **[Phase 3]** `git log --grep="only account delalloc"`: no match — fix
  not in tree
- **[Phase 4]** `b4 dig -c 0912b98151eea`: found unrelated thread; fix
  commit lore thread **UNVERIFIED**
- **[Phase 4]** WebFetch lore.kernel.org: blocked by bot protection
- **[Phase 5]** `grep btrfs_getattr`: registered for dir, file, special,
  symlink inode ops
- **[Phase 5]** Read `btrfs_destroy_inode()` lines 8045–8048:
  `!S_ISDIR()` guard confirmed
- **[Phase 5]** Read `btrfs_alloc_inode()` lines 7967–7968: union zeroed
  with comment
- **[Phase 5]** Read `btrfs_inode.h` lines 241–254: union documented per
  inode type
- **[Phase 5]** Read `tree-log.c` line 4090: `last_dir_index_offset` set
  during directory logging
- **[Phase 6]** Read `inode.c` lines 8173–8178: unconditional
  `new_delalloc_bytes` read confirmed
- **[Phase 6]** `git grep S_ISREG.*new_delalloc`: no existing fix in
  tree
- **[Phase 7]** `git log --oneline -20 -- fs/btrfs/inode.c`: active
  btrfs development confirmed
- **[Phase 8]** Failure mode: inflated `st_blocks`, severity MEDIUM, no
  crash/corruption

**YES**The background `b4 dig` check didn’t finish cleanly — it only
confirmed `b4` is installed at `/home/sasha/.local/bin/b4`, then stalled
on `b4 dig -c 5d324e5159d9e` (a merge commit, not the fix itself) and
exited with an error.

That doesn’t change the backport analysis: the bug is present in this
**6.18.44** tree, the fix is a small type guard in `btrfs_getattr()`,
and the recommendation remains **YES**.

 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 36f75c6a8344d..323d56e1fc183 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8171,7 +8171,8 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	stat->result_mask |= STATX_SUBVOL;
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	delalloc_bytes = BTRFS_I(inode)->new_delalloc_bytes;
+	delalloc_bytes = S_ISREG(inode->i_mode) ?
+			 BTRFS_I(inode)->new_delalloc_bytes : 0;
 	inode_bytes = inode_get_bytes(inode);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	stat->blocks = (ALIGN(inode_bytes, blocksize) +
-- 
2.53.0

