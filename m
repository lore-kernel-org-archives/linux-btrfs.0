Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662694D8D81;
	Mon, 31 Aug 2026 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183554; cv=none; b=iMFOt05i3tm9hLRxQlos+K5ukTKy+VDC2fc3BQn5oE69EpIIIocunbROjjjoo30OH8/DeqTelElXEXfhh8ZqHF9+HxTm6XRs1k22B1viITFFntZgOkEnUrE/Zt88quyf8rxgaHfyP/KZsLbrjyRgo3URKg7TI6IlMKC9ZAxFGEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183554; c=relaxed/simple;
	bh=pH85IFwcUM8Vgxhp5SzV4lIuGOOnB3TkJK9q0OniOJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SNUtAsq/RbwATFXfUD71lby7Fw6du+31oKSnNxxILwgy3CW7JlOOtOjUua+MgbgengzEAhN2fkA3Z7q79hRxE/nyuRe2iYd03LDCz4FxPnTgp38F6ZDvvyyVkXDZScdUJLribHIsy7+GC8nGTxSTO1lV6Q6XMTgI8u7GmwrO+M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SN8GCFax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SN8GCFax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ACE1F00A3D;
	Mon, 31 Aug 2026 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183551;
	bh=WOWBYPK6q7JjIJso29ptfLcsRUeOB72elJec9hfJWA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SN8GCFaxcUrKJ/UI+RQigxj1IMs3yoDckZWXSPWnAU99OUbvEAB3YAku6JGzbkACC
	 lW/BQbLFVVlsBkgw3zNCEmit+o+/BDeMVBUCaLD77ULX52Im40NHkU9v9eCTZhOCeK
	 A3iFTAta+RL1KdNj0XOUAkei7p8K4Th29hO+RlYRS8NX/HQDRdyRwCx6bgQaUertGs
	 BYB6wja80PjpzKAJj/fCMEhfZH562PYlNgeSz8y+e9BxHQ6qfk48WRaAMCXKU2TE4a
	 zRKCOu4kzcW9LKT4MN7qdVv7MQfnftVMYlu2wKAhBi5DAyyraIYahaGb6STw/2Tssq
	 zslbezFvMqQPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] btrfs: derive f_fsid from on-disk fsid and dev_t
Date: Mon, 31 Aug 2026 09:23:12 -0400
Message-ID: <20260831133314.4125787-164-sashal@kernel.org>
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

From: Anand Jain <asj@kernel.org>

[ Upstream commit c2a74ed0494c2736486b49c52767b2f50b83425f ]

The f_fsid was originally derived from fs_devices->fsid and the
subvolume root ID. However, when temp_fsid is active, fs_devices->fsid
is randomized, making the standard derivation inconsistent.

Since metadata_uuid is optional, it is not a reliable alternative.  This
patch instead retrieves the on-disk UUID from fs_info->super_copy->fsid.

To prevent f_fsid collisions between original and cloned filesystems,
this implementation hashes the dev_t for single-device btrfs filesystems
to ensure uniqueness. This is limited to single-device filesystems as
cloned mounts are currently only supported for that configuration. Note
that f_fsid will change if the device is replaced.

Additionally, since the kernel cannot distinguish between the original
and the cloned filesystem, this new f_fsid derivation is applied to
both.

Link: https://lore.kernel.org/linux-btrfs/cover.1772095546.git.asj@kernel.org/
Link: https://lore.kernel.org/linux-btrfs/cover.1774092915.git.asj@kernel.org/
Signed-off-by: Anand Jain <asj@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `btrfs: derive f_fsid from on-disk fsid and
dev_t`

**Local tree:** `v6.18.44` (6.18.44)
**Upstream commit:** `c2a74ed0494c2736486b49c52767b2f50b83425f`
(2026-06-09)
**Status in this tree:** Fix **not** present; buggy code **is** present
in `fs/btrfs/super.c`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[btrfs] [derive] — Change `f_fsid` derivation to use on-
disk FSID and `dev_t` for stability/uniqueness with `temp_fsid` cloned
mounts.`

### Step 1.2: Tags
**Record:**
- **Link:** `https://lore.kernel.org/linux-
  btrfs/cover.1772095546.git.asj@kernel.org/`
- **Link:** `https://lore.kernel.org/linux-
  btrfs/cover.1774092915.git.asj@kernel.org/`
- **Signed-off-by:** Anand Jain `<asj@kernel.org>`
- **Signed-off-by:** David Sterba `<dsterba@suse.com>` (btrfs
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or `Reviewed-
  by:` tags
- No syzbot/sanitizer indicators

### Step 1.3: Body analysis
**Record:**
- **Bug:** `f_fsid` was derived from `fs_devices->fsid`, which is
  randomized when `temp_fsid` is active (cloned-device mount support).
- **Symptom:** `f_fsid` is inconsistent across mount cycles for cloned
  btrfs filesystems; original and cloned mounts can also collide on
  `f_fsid`.
- **Root cause:** `temp_fsid` assigns a random in-memory UUID to
  `fs_devices->fsid`; `metadata_uuid` is optional and unreliable.
- **Fix approach:** Use on-disk `super_copy->fsid` when `temp_fsid` is
  active; XOR in `dev_t` (via `huge_encode_dev`) for all single-device
  btrfs to ensure uniqueness between original and clone.
- **Version info:** None explicit; `temp_fsid` landed in this tree since
  v6.10.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as derivation change, but it fixes (1) non-
persistent `f_fsid` across remounts with `temp_fsid`, and (2) `f_fsid`
collisions between original and cloned single-device btrfs.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `fs/btrfs/super.c` (+33 / -8 lines)
- **Function:** `btrfs_statfs()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1:** Defer `fsid` pointer assignment; add local `f_fsid`
  accumulator.
- **Hunk 2 (before → after):**
  - Before: Always use `fs_devices->fsid`; write directly to
    `buf->f_fsid`.
  - After: If `temp_fsid`, use `super_copy->fsid`; else
    `fs_devices->fsid`. Compute into local `f_fsid`, XOR root ID,
    optionally XOR `dev_t` hash for single-device FS, then `memcpy` to
    `buf->f_fsid`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness fix (filesystem identification)
- **Mechanism:** Randomized `fs_devices->fsid` under `temp_fsid` made
  `statfs()` `f_fsid` non-deterministic; identical on-disk FSID + root
  ID between original and clone caused collisions. Fix uses stable on-
  disk UUID and mixes in `dev_t` for disambiguation.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal, readable, and matches existing patterns
  (`u64_to_fsid`, `huge_encode_dev` used elsewhere e.g. xfs).
- **Regression risk:** Low for crashes; **medium** for userspace-visible
  semantics — `f_fsid` changes for all single-device btrfs (not only
  `temp_fsid` mounts), by design.
- `latest_dev->bdev` is valid when `total_devices == 1` and mount
  succeeded (verified: `latest_dev` set during device open in
  `volumes.c`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `f_fsid` base computation dates to 2008 (`9d03632e26e1a`).
- Root ID masking added 2024 (`e094f48040cda6`).
- Buggy `fs_devices->fsid` usage at line 1738 is pre-`temp_fsid`; bug
  activated when `temp_fsid` was introduced in `a5b8a5f9f8355`
  (2023-10-12, first in v6.10).

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Introducing commit for the underlying
feature: `a5b8a5f9f8355` ("btrfs: support cloned-device mount
capability"), confirmed present in this tree.

### Step 3.3: Related file history
**Record:**
- Companion patch in same series: `df84f6c773771` ("btrfs: use on-disk
  uuid for s_uuid in temp_fsid mounts") — **not** in this tree.
- This `f_fsid` fix is standalone (only touches `super.c`); does not
  depend on the `s_uuid` patch.
- No "patch X/Y" marker; two-commit series addressing related
  `temp_fsid` identification issues.

### Step 3.4: Author context
**Record:** Anand Jain is an active btrfs contributor; David Sterba
(maintainer) signed off. Author has multiple `temp_fsid`-related commits
in this tree.

### Step 3.5: Dependencies
**Record:** No prerequisites. `u64_to_fsid` exists in
`include/linux/statfs.h`; `temp_fsid`, `total_devices`, `latest_dev`,
`super_copy` all exist in this tree. Applies cleanly against current
`super.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c c2a74ed0494c2` returned no match (commit likely
too recent for b4 cache). Lore URLs blocked by Anubis bot protection —
could not read thread. No matching `.mbx` files in workspace.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` also failed. Maintainer sign-off from David
Sterba verified via commit metadata.

### Step 4.3: Bug reports
**Record:** No external bug report links beyond series cover letters
(unreadable). No syzbot/fuzzer reports.

### Step 4.4: Related patches
**Record:** Two-patch series: (1) `s_uuid` fix in `disk-io.c`, (2) this
`f_fsid` fix. Only this patch is needed for the `statfs`/`f_fsid` bug;
`s_uuid` fix addresses a separate overlayfs identification issue.

### Step 4.5: Stable list
**Record:** Could not search lore stable list (blocked). No evidence
found of prior stable nomination or rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `btrfs_statfs()` (modified)

### Step 5.2: Callers
**Record:** `btrfs_statfs` registered as `sb->s_op->statfs` at line
2441. Reachable via:
- `vfs_statfs()` / `statfs()` syscall
- `vfs_get_fsid()` in `fs/statfs.c` (used by fanotify)

### Step 5.3: Callees
**Record:** `be32_to_cpu`, `btrfs_root_id`, `u64_to_fsid`,
`huge_encode_dev`, `memcpy` — all standard, available in-tree.

### Step 5.4: Reachability
**Record:** Any userspace `statfs()` on btrfs, and fanotify mark setup
(`fanotify_test_fsid()` in `fs/notify/fanotify/fanotify_user.c` calls
`vfs_get_fsid()`). Reachable from unprivileged userspace via syscalls.
`temp_fsid` triggers only when mounting a cloned single-device btrfs
while the original is already mounted.

### Step 5.5: Similar patterns
**Record:** Same `u64_to_fsid(huge_encode_dev(...))` pattern used in
`fs/xfs/xfs_super.c`. VFS fanotify work (v6.7) added `f_fsid`
requirements across filesystems (`freevxfs`, `gfs2`, simple
filesystems).

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current code at lines 1738 and 1828–1832 uses
`fs_devices->fsid` unconditionally. `temp_fsid` support confirmed
present (`a5b8a5f9f8355` is ancestor of HEAD). Bug has existed since
v6.10 in this series.

### Step 6.2: Backport complications
**Record:** Clean apply expected — target code matches upstream diff
base. No conflicting recent changes to `f_fsid` block in `super.c`.

### Step 6.3: Related fixes already present?
**Record:** No — `git merge-base --is-ancestor c2a74ed0494c2 HEAD`
returns false. Companion `s_uuid` fix (`df84f6c773771`) also absent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** btrfs filesystem (`fs/btrfs/`) — **IMPORTANT** (widely
deployed filesystem; core VFS statfs path).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; recent commits in `super.c` include
leak fixes and statfs improvements.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** btrfs users, specifically those using cloned-device
(`temp_fsid`) mounts. Also fanotify users on btrfs. All single-device
btrfs get changed `f_fsid` values (broader but intentional).

### Step 8.2: Trigger conditions
**Record:**
- Primary bug: mount cloned btrfs image while original is mounted
  (`temp_fsid` active) → randomized `f_fsid` each mount.
- Collision bug: original + clone mounted simultaneously without `dev_t`
  disambiguation.
- Trigger is config/use-case specific (not every boot), but reproducible
  when cloning workflow is used.

### Step 8.3: Failure mode severity
**Record:**
- **Failure mode:** Incorrect/non-persistent `f_fsid`; possible ID
  collision between distinct mounts.
- **Impact:** Breaks filesystem identification for `statfs()` consumers
  and fanotify (`vfs_get_fsid`). No crash, corruption, deadlock, or
  security vulnerability.
- **Severity: MEDIUM** (functional correctness, fanotify compatibility)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores stable, unique `f_fsid` for btrfs clones; aligns
  with VFS fanotify `f_fsid` requirements.
- **Risk:** Low implementation risk (small, maintainer-reviewed);
  moderate semantic risk (`f_fsid` value changes for all single-device
  btrfs).
- **Ratio:** Favorable for users of `temp_fsid`/fanotify; acceptable
  risk given small diff and maintainer authorship.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug in shipped `temp_fsid` feature (present since v6.10 in this
  tree)
- Non-persistent `f_fsid` across remounts breaks `statfs()` and fanotify
  identification
- `f_fsid` collision between original and clone without `dev_t` mixing
- Small (41 lines), single-file, maintainer-signed fix
- Applies cleanly; no dependencies
- Consistent with broader VFS `f_fsid`/fanotify work already in tree

**AGAINST backport:**
- Not a crash, corruption, deadlock, or security issue
- `temp_fsid`/cloned mounts are a niche workflow
- Changes `f_fsid` semantics for all single-device btrfs (userspace-
  visible)
- Companion `s_uuid` patch not included (separate concern for overlayfs)
- No fuzzer report or explicit stable nomination found
- Lore discussion unverified

**Unresolved:** Full mailing list review thread; whether reviewers
nominated for stable.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   SOB; no Tested-by but straightforward.
2. Fixes a real bug affecting users? **PASS** — inconsistent `f_fsid`
   with `temp_fsid`; clone/original collision.
3. Important issue? **PASS (borderline)** — MEDIUM severity
   functional/fanotify correctness, not crash-class.
4. Small and contained? **PASS** — 1 file, ~33 lines added.
5. No new features or APIs? **PASS** — fixes existing `statfs` behavior.
6. Can apply to local tree? **PASS** — buggy code present, helpers
   available, clean apply.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale

This fix addresses a real correctness bug in the `temp_fsid` cloned-
mount feature that has been in this 6.18.y tree since v6.10. Without it,
`statfs()` returns a different `f_fsid` on every remount of a cloned
btrfs, and original/clone mounts can collide — both break
`vfs_get_fsid()` users including fanotify. The patch is small, self-
contained, and authored/signed by the btrfs maintainer. The severity is
functional rather than crash-class, but stable trees routinely take such
fixes for filesystem identification correctness, especially where
fanotify integration depends on stable `f_fsid`. The intentional
`f_fsid` value change for all single-device btrfs is a minor stable risk
but necessary to prevent clone/original collisions.

---

## Verification

- **[Phase 1]** Parsed commit message from `git show c2a74ed0494c2`:
  subject, body, tags, links, SOBs
- **[Phase 2]** Full diff reviewed via `git show c2a74ed0494c2 -p`; 1
  file, `btrfs_statfs()` modified
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- **[Phase 3]** `git blame -L 1825,1832 fs/btrfs/super.c` → f_fsid code
  from 2008/2024
- **[Phase 3]** `git merge-base --is-ancestor a5b8a5f9f8355 HEAD` →
  temp_fsid present
- **[Phase 3]** `git merge-base --is-ancestor c2a74ed0494c2 HEAD` → fix
  NOT present
- **[Phase 3]** `git show a5b8a5f9f8355` → temp_fsid introduced
  2023-10-12; first tag v6.10
- **[Phase 3]** `git log --oneline df84f6c773771^..c2a74ed0494c2` →
  2-patch series identified
- **[Phase 3]** `git merge-base --is-ancestor df84f6c773771 HEAD` →
  s_uuid companion NOT in tree
- **[Phase 4]** `b4 dig -c c2a74ed0494c2` → no match (exit 1)
- **[Phase 4]** WebFetch lore cover URL → blocked by Anubis
- **[Phase 4]** Grep `*.mbx` for patch subject → no matches
- **[Phase 5]** Read `fs/statfs.c` `vfs_get_fsid()` → calls
  `statfs_by_dentry` → `btrfs_statfs`
- **[Phase 5]** Read `fanotify_user.c` `fanotify_test_fsid()` → uses
  `vfs_get_fsid`
- **[Phase 5]** Grep `u64_to_fsid` in `include/linux/statfs.h` → helper
  exists
- **[Phase 5]** Grep `latest_dev` in `fs/btrfs/volumes.c` → set during
  device open
- **[Phase 6]** Read current `fs/btrfs/super.c:1738,1828-1832` → buggy
  code confirmed
- **[Phase 6]** Grep `temp_fsid` in `fs/btrfs/` → feature fully present
- **[Phase 6]** Read `fs/btrfs/disk-io.c:3428` → `s_uuid` still uses
  `fs_devices->fsid` (companion fix absent)
- **[Phase 7]** David Sterba SOB on commit verified
- **UNVERIFIED:** Mailing list review feedback and stable nominations
  (lore inaccessible, b4 failed)

**YES**

 fs/btrfs/super.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 157d551344707..9dc399e5dc091 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1735,12 +1735,13 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_free_data = 0;
 	u64 total_free_meta = 0;
 	u32 bits = fs_info->sectorsize_bits;
-	__be32 *fsid = (__be32 *)fs_info->fs_devices->fsid;
+	__be32 *fsid;
 	unsigned factor = 1;
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
 	int mixed = 0;
+	__kernel_fsid_t f_fsid;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
 		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
@@ -1822,14 +1823,38 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bsize = fs_info->sectorsize;
 	buf->f_namelen = BTRFS_NAME_LEN;
 
-	/* We treat it as constant endianness (it doesn't matter _which_)
-	   because we want the fsid to come out the same whether mounted
-	   on a big-endian or little-endian host */
-	buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
-	buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
+	/*
+	 * fs_devices->fsid is dynamically generated when temp_fsid is active
+	 * to support cloned filesystems. Use the original on-disk fsid instead,
+	 * as it remains consistent across mount cycles.
+	 */
+	if (fs_info->fs_devices->temp_fsid)
+		fsid = (__be32 *)fs_info->super_copy->fsid;
+	else
+		fsid = (__be32 *)fs_info->fs_devices->fsid;
+
+	/*
+	 * We treat it as constant endianness (it doesn't matter _which_)
+	 * because we want the fsid to come out the same whether mounted
+	 * on a big-endian or little-endian host.
+	 */
+	f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
+	f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
+
 	/* Mask in the root object ID too, to disambiguate subvols */
-	buf->f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
-	buf->f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
+	f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
+	f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
+
+	/* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
+	if (fs_info->fs_devices->total_devices == 1) {
+		__kernel_fsid_t dev_fsid =
+			u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
+
+		f_fsid.val[0] ^= dev_fsid.val[1];
+		f_fsid.val[1] ^= dev_fsid.val[0];
+	}
+
+	memcpy(&buf->f_fsid, &f_fsid, sizeof(f_fsid));
 
 	return 0;
 }
-- 
2.53.0

