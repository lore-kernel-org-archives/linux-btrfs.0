Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1525A177C;
	Mon, 31 Aug 2026 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184323; cv=none; b=oXrLra3w8MwW6ibcAj4tZ9Q797IHQN5WrdlT7NPBARKPgwU+2nJNKlOVWqo5aS6NKxB4mIkqbb2Aa395QX7LK73dGEWymyo8fSum+8VB17gY7iNCtCC9jNDcfWVa7Ns+IVmCuCJnjmGbocQyz72DmEgrDtPrD0Xg3fRibGpeJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184323; c=relaxed/simple;
	bh=QxjxLciu3eroOLSQJpyh2YQdL0PpnVPxHhKtB5NNSQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4dSDv30NE5k5to7P5bKvwu9MqGtsiF1MOO+r3Fp7sbS3v3UUygsxbI0O3kAz04vJLLE8FLW8gS+L4Rm9dLLweLShSgpp30XRdDjA7MMxNJV+5ICQB2MYGTUZzQgk123daeqEy2TsZh3Msxz1BXUCvI68YCkMkftyTf7OWSY6u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjrtjMCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjrtjMCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116051F00ACA;
	Mon, 31 Aug 2026 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184321;
	bh=xHgyNT8y1eRlrnrTInjWC6nlqnRsgR93A/EkCNDspNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjrtjMCmtrR3OY+iSd3mV0iRiStsutCjpR4zH7hqwCG9wRFXFE3J1n9CP5N0oDhnn
	 YKpJxNC/KDJDHmyPbE7vfvcrtukI7I9qF3F36rA3OIUhMpCeY98FVyDp8GQiJt4qR/
	 NEBktqmA8vlbF/ruCleu0iKYzwNmNu+nDShuYoB2R5ql0058EHQ+1UAAR5hKv5Ktmi
	 fZ3yx2f4etXm3L7L/GVbasKSg9iiIMBjZyaHGsHW9/fZjnaxulR1VIdtGyHUetVooP
	 nQ4cJDG3W1fvrVRoEhyKXPRuVgjIfLK2vbSspzNhymkcHA9e2d0bV16Gy/R6pSjEW/
	 KiGsaVrrXwLUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
Date: Mon, 31 Aug 2026 09:30:51 -0400
Message-ID: <20260831133314.4125787-623-sashal@kernel.org>
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

[ Upstream commit df84f6c773771fa7b78fe06931709df1aca5907f ]

When mounting a cloned filesystem with a temporary fsuuid (temp_fsid),
layered modules like overlayfs require a persistent identifier.

While internal in-memory fs_devices->fsid must remain unique to
the kernel module, let s_uuid carry the original on-disk UUID.

Signed-off-by: Anand Jain <asj@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[btrfs] [use] use on-disk uuid for s_uuid in temp_fsid
  mounts` — fixes incorrect `sb->s_uuid` assignment when btrfs’s in-
  memory `temp_fsid` feature is active.

**Step 1.2 — Tags**
- Record: `Signed-off-by: Anand Jain <asj@kernel.org>`, `Signed-off-by:
  David Sterba <dsterba@suse.com>`
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, `Reviewed-
  by:`, or `Link:` tags (expected for manual review candidates).
- Notable: David Sterba (btrfs maintainer) signed off.

**Step 1.3 — Body analysis**
- Record: **Bug**: When mounting a cloned btrfs image with `temp_fsid`,
  `sb->s_uuid` was set from the random in-memory `fs_devices->fsid`, not
  the on-disk UUID. **Symptom**: Layered filesystems (overlayfs) that
  rely on a persistent `s_uuid` break — remounting the same image fails
  origin verification. **Root cause**: `temp_fsid` intentionally
  randomizes `fs_devices->fsid` for kernel uniqueness, but that value
  was incorrectly propagated to `sb->s_uuid`. **Fix**: For `temp_fsid`
  mounts, copy the on-disk UUID from `super_copy->fsid` into
  `sb->s_uuid`.

**Step 1.4 — Hidden bug fix?**
- Record: Yes. Despite not using “fix” in the subject, this is a
  functional correctness bug in how btrfs exposes filesystem identity to
  the VFS and overlayfs.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record: `fs/btrfs/disk-io.c`: +10 / −1 lines. Function:
  `open_ctree()`. Scope: single-file surgical fix.

**Step 2.2 — Code flow change**
- Record:
  - **Before**: `memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, ...)`
    always — for `temp_fsid`, this is a per-mount random UUID.
  - **After**: If `temp_fsid`, use `fs_info->super_copy->fsid` (on-
    disk); otherwise unchanged behavior.
  - **Path**: Normal mount path in `open_ctree()`, after `super_copy` is
    populated (line 3344) and before chunk root read.

**Step 2.3 — Bug mechanism**
- Record: **Logic/correctness fix**. `sb->s_uuid` must reflect
  persistent filesystem identity; `fs_devices->fsid` is intentionally
  volatile under `temp_fsid`. Wrong identifier exposed to VFS consumers.

**Step 2.4 — Fix quality**
- Record: Obviously correct — `super_copy` is already populated and
  validated at this point. Minimal change, no API changes. Low
  regression risk; non-`temp_fsid` path unchanged.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: `memcpy(&sb->s_uuid, ...)` introduced by Nikolay Borisov
  (2018-10-30, commit `de37aa513105f8`). `temp_fsid` introduced by Anand
  Jain in `a5b8a5f9f8355` (“btrfs: support cloned-device mount
  capability”, merged Oct 2023, first in **v6.7**). Bug present since
  v6.7 whenever both features coexist.

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related history**
- Record: Part of v3 series `[PATCH v3 0/2] fix s_uuid and f_fsid
  consistency for cloned filesystems`. Companion patch 2/2
  (`c2a74ed0494c2`) fixes `f_fsid` in `btrfs_statfs()` — separate
  concern (statfs/fanotify/ima). This commit (patch 1/2) is standalone
  for the `s_uuid`/overlayfs issue.

**Step 3.4 — Author context**
- Record: Anand Jain is an active btrfs contributor; David Sterba
  (maintainer) reviewed and signed off.

**Step 3.5 — Dependencies**
- Record: Requires `temp_fsid` support (present since v6.7). Requires
  `fs_info->super_copy` (long-standing). No other commits needed for
  this hunk. `git apply --check` on the patch against 6.18.44 succeeds.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: b4 dig found `[PATCH v3 1/2]` at https://patch.msgid.link/b4b5
  637ca4137d71eba368e37c67abcf60df0cab.1777281686.git.asj@kernel.org
- Series: v1 → v2 → v3 (latest applied version).

**Step 4.2 — Reviewers**
- Record: CC’d to `linux-btrfs@vger.kernel.org`, `dsterba@suse.com`.
  David Sterba replied on patch 2/2 with changelog corrections (May
  2026).

**Step 4.3 — Bug report**
- Record: Cover letter references André Almeida’s overlayfs report:
  https://lore.kernel.org/linux-
  btrfs/20251014015707.129013-1-andrealmeid@igalia.com
- **Reproduction** (verified from mbox): `mkfs.btrfs`, clone image,
  mount twice, use overlayfs with `index=on` — second mount of same
  image fails because btrfs assigns a new random `temp_fsid` UUID each
  mount while overlayfs stores/compares `s_uuid` in `overlay.origin`.
- **dmesg**: `"failed to verify upper root origin"`
- Christoph Hellwig: “Please fix btrfs to not change uuids, as that
  completely defeats the point of uuids.”

**Step 4.4 — Series context**
- Record: Patch 2/2 (`c2a74ed0494c2`) addresses `f_fsid` via statfs for
  fanotify/ima — not required for this commit’s overlayfs `s_uuid` fix
  but addresses related instability.

**Step 4.5 — Stable discussion**
- Record: No explicit `Cc: stable` found in thread. Not a negative
  signal.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Modified functions**
- Record: `open_ctree()` in `fs/btrfs/disk-io.c`.

**Step 5.2 — Callers**
- Record: `open_ctree()` is called during btrfs mount
  (`btrfs_fill_super` / `btrfs_get_tree`). Every btrfs mount goes
  through this path.

**Step 5.3 — Key callees at change site**
- Record: Uses already-populated `fs_info->super_copy` and
  `fs_info->fs_devices->temp_fsid`. No new allocations or locks.

**Step 5.4 — Reachability**
- Record: Triggered by any user mounting a cloned btrfs device while
  another instance with the same on-disk UUID is already registered —
  exactly the `temp_fsid` use case (since v6.7). Unprivileged users can
  trigger via mount namespaces / loop devices.

**Step 5.5 — Similar patterns**
- Record: Patch 2/2 applies the same `super_copy->fsid` principle to
  `btrfs_statfs()` `f_fsid`. The `temp_fsid` design in `volumes.h`
  documents that in-memory `fsid` is random while `metadata_uuid ==
  sb->fsid`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
- Record: **Yes.** Tree is `v6.18.44` (`stable/linux-6.18.y`). Line 3428
  in `disk-io.c` still has the buggy unconditional `memcpy`. `temp_fsid`
  feature confirmed present (`git merge-base --is-ancestor a5b8a5f9f8355
  HEAD` → yes, since v6.7).

**Step 6.2 — Backport complications**
- Record: **Clean apply.** `git show df84f6c773771 -- fs/btrfs/disk-io.c
  | git apply --check` succeeds on current HEAD. No conflicting recent
  churn at this location.

**Step 6.3 — Related fixes already present?**
- Record: **No.** Neither `df84f6c773771` (this commit) nor
  `c2a74ed0494c2` (companion f_fsid fix) are ancestors of HEAD.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `fs/btrfs` — IMPORTANT (widely deployed filesystem, container
  rootfs stacks).

**Step 7.2 — Activity**
- Record: btrfs actively maintained in 6.18.y; `temp_fsid` is a shipped
  feature since 6.7.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users combining btrfs cloned-device mounts (`temp_fsid`) with
  overlayfs `index=on` (common in container/OCI immutable-root
  workflows).

**Step 8.2 — Trigger conditions**
- Record: Mount same btrfs clone image twice; use overlayfs with
  `index=on` on second mount. Reproducible, documented. Not timing-
  dependent.

**Step 8.3 — Failure mode severity**
- Record: **Mount failure** — overlayfs refuses to mount with `"failed
  to verify upper root origin"`. Breaks remount of unchanged images.
  Severity: **MEDIUM** (functional breakage, not
  crash/corruption/security, but breaks a real documented workflow).

**Step 8.4 — Risk-benefit**
- Record: **Benefit**: HIGH for affected btrfs+overlayfs users (restores
  expected remount behavior). **Risk**: VERY LOW (10 lines, conditional
  on `temp_fsid`, non-temp path unchanged). **Ratio**: Favorable.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backport:
- Real, documented bug (André Almeida RFC, Oct 2025) with reproduction
  script
- Maintainer-signed fix (David Sterba)
- Small, surgical, applies cleanly to 6.18.44
- Bug exists in this tree since `temp_fsid` landed (v6.7)
- Directly fixes overlayfs `s_uuid` comparison in `ovl_decode_real_fh()`
  / origin verification
- btrfs maintainer community agreed btrfs should expose stable UUIDs

AGAINST backport:
- Not a crash, data corruption, or security issue — functional mount
  failure only
- Part of 2-patch series (patch 2/2 for `f_fsid`/statfs is separate;
  ideally backported too but not a prerequisite for this fix)
- Affects a specific feature combination (btrfs clone + overlayfs index)

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is clear; maintainer
   SOB; applies cleanly.
2. Fixes a real bug affecting users? **PASS** — documented overlayfs
   remount failure.
3. Important issue? **PASS (MEDIUM)** — mount failure breaking overlayfs
   `index=on` with btrfs clones; not crash/corruption but real user
   impact.
4. Small and contained? **PASS** — 10 lines, one file, one function.
5. No new features or APIs? **PASS** — corrects existing `s_uuid`
   semantics.
6. Can apply to local tree? **PASS** — verified clean apply.

**Step 9.3 — Exception categories**
- Record: None (not device ID, quirk, DT, build, or docs). Standard bug
  fix.

**Step 9.4 — Decision rationale**

This commit fixes a real functional regression introduced when btrfs’s
`temp_fsid` feature (present in 6.18.y since v6.7) started exposing a
per-mount random UUID via `sb->s_uuid`. Overlayfs with `index=on` stores
and later verifies that UUID; remounting the same btrfs clone image
fails with `"failed to verify upper root origin"`. The fix is minimal,
maintainer-approved, and applies cleanly to the 6.18.44 tree. While not
a crash or corruption issue, it restores correct behavior for a
supported btrfs+overlayfs combination that btrfs maintainers explicitly
addressed.

Note: The companion commit `c2a74ed0494c2` (f_fsid/statfs stability)
addresses a related but separate symptom and should be evaluated
independently.

---

## Verification

- [Phase 1] `git show df84f6c773771`: parsed commit message and tags
- [Phase 2] Diff: 10 insertions, 1 deletion in `open_ctree()`;
  conditional on `temp_fsid`
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame` line 3428:
  `de37aa513105f8` (2018); `temp_fsid` from `a5b8a5f9f8355` (v6.7)
- [Phase 3] `git merge-base --is-ancestor a5b8a5f9f8355 HEAD`: temp_fsid
  IS in 6.18.y
- [Phase 3] `git merge-base --is-ancestor df84f6c773771 HEAD`: patch NOT
  in tree
- [Phase 3] `git show df84f6c773771 -- fs/btrfs/disk-io.c | git apply
  --check`: clean apply
- [Phase 4] `b4 dig -c df84f6c773771`: found v3 series at
  lore.kernel.org
- [Phase 4] `b4 dig -c df84f6c773771 -a`: v1/v2/v3 revisions; patch 1/2
  of 2-patch series
- [Phase 4] `b4 dig -c df84f6c773771 -w`: CC linux-btrfs,
  dsterba@suse.com
- [Phase 4] curl lore mbox for overlayfs RFC: confirmed reproduction and
  `"failed to verify upper root origin"` failure mode
- [Phase 4] Cover letter: references Christoph Hellwig “fix btrfs to not
  change uuids”
- [Phase 5] `grep s_uuid fs/overlayfs/`: overlayfs uses
  `mnt->mnt_sb->s_uuid` in `ovl_decode_real_fh()` (namei.c:176) and
  copy_up.c:424
- [Phase 5] `open_ctree()` called on every btrfs mount
- [Phase 6] Current `disk-io.c:3428`: buggy code confirmed present
- [Phase 6] `super_copy` populated at line 3344, before s_uuid
  assignment at 3428
- [Phase 8] Failure mode: overlayfs mount refusal on remount, severity
  MEDIUM

**YES**The background searches finished and matched what the full
analysis used:

- **Commit identified:** `df84f6c773771` — *btrfs: use on-disk uuid for
  s_uuid in temp_fsid mounts*
- **On master, not in 6.18.44:** neither this commit nor its series mate
  are in the current stable tree
- **Companion patch:** `c2a74ed0494c2` — *btrfs: derive f_fsid from on-
  disk fsid and dev_t* (patch 2/2; separate `statfs`/`f_fsid` fix)

**Verdict for 6.18.y: YES** — small, maintainer-signed fix for overlayfs
`index=on` remount failures with btrfs cloned mounts; applies cleanly.
Consider evaluating patch 2/2 separately for `statfs`/`f_fsid`
stability.

 fs/btrfs/disk-io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 655eed981078b..1664b22961ee0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3425,7 +3425,16 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/* Update the values for the current filesystem. */
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
-	memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
+	/*
+	 * When temp_fsid is active, fs_devices->fsid is assigned a random UUID
+	 * at mount. This inconsistent UUID causes issues for layered filesystems
+	 * like OverlayFS. Since metadata_uuid may or may not be set, provide the
+	 * on-disk UUID directly from the super_copy.
+	 */
+	if (fs_info->fs_devices->temp_fsid)
+		memcpy(&sb->s_uuid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+	else
+		memcpy(&sb->s_uuid, fs_info->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
-- 
2.53.0

