Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5CA44CAC1;
	Mon, 31 Aug 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183728; cv=none; b=kyPLLSBmbBRYNDMjkVWR4JpVnoZvsIZXL4D9H5YSBdjtx2yjz2lM3RA4LEXmNnx7ZVo3GnNRTooSZUiq67RurTHw0wOSYOdO4TYRulK5tPSh5URiDmRIpsGqDEx10ibmqsVTMUrj4AKGOoR5cXLATVtikykN0ERczmgN38poNzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183728; c=relaxed/simple;
	bh=5at3IeaA6cfwORKOfKAMKjh1/u2q4qG0jAbKukIT8+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjZof4pEA9JmtBWm6Pg52cPy3hRA82VkQ/AdY4cJb9wq7Zy4Z+9JEIXc9pgS40QHCOozeHkcRd0eCGJ7TtAY2yNsqWm65pcYQTOCtHr9vEvKd7L2Tm5I8skReXFLqVo3c3lKva/OXMkHUipoEH1e2MmcJgGNZzg6PJV2eSiBdJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNkSYdRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNkSYdRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2561F00A3F;
	Mon, 31 Aug 2026 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183725;
	bh=IToJlCIicRLqVSVtwjTCz3NLfo/8wcoja9GnonmpK/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNkSYdRfBny5glVuqGKyA0yJ6h8iQERkS2um+MSyxqdK463hg40ZC1P0mMwWJctrj
	 urF/ldR4O7sry7LmXUUl8eCbL18yWxkgdXiBH3QrkG+suQyGCqNm7iizCcUYT7j3Hx
	 ipYPIGZW3fvA3J8IIYvzUabLmdn8+dfdm0Xryk4Cd2yid9v91+n7YXcLtq/M/bk+wm
	 1sMi7mOqd5Ye+BDauoa9ia660uB0icSpvko+64rUpfpt2ub/lNd6aUh9dp7ME/A8VM
	 Cihth77BhyBR/EhGCmAcODwZ4PTh/I9va8HD/jXM4Squu4cWMnkmBfWbaeBlJGgjxK
	 RZZdPFR/aq6Xg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Cen <rollkingzzc@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] btrfs: tree-checker: validate names in ROOT_REF and ROOT_BACKREF
Date: Mon, 31 Aug 2026 09:24:55 -0400
Message-ID: <20260831133314.4125787-267-sashal@kernel.org>
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

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit 0af37c217edf15fa21dac1c40822086df356c6bb ]

ROOT_REF and ROOT_BACKREF items contain a struct btrfs_root_ref followed
by the subvolume name. Several readers assume that this layout is already
valid and then use the on-disk name length directly. A corrupted item can
therefore make those readers address bytes outside the item, and
BTRFS_IOC_GET_SUBVOL_INFO can copy too many bytes into its fixed-size UAPI
name buffer.

Validate ROOT_REF and ROOT_BACKREF items in tree-checker before any reader
uses them. Reject records that do not contain a non-empty name, whose
name_len does not exactly describe the remaining item payload, or whose
name exceeds BTRFS_NAME_LEN.

For BTRFS_IOC_GET_SUBVOL_INFO, copy only the validated on-disk name_len
instead of deriving the copy length from the item size. The ioctl result is
zeroed when allocated. That leaves the existing trailing zero byte
untouched.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: btrfs: tree-checker: validate names in
ROOT_REF and ROOT_BACKREF

**Local tree:** `v6.18.44` (Linux 6.18.44)
**Commit under review:** `0af37c217edf1` (on `master`, **not** in this
tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[btrfs: tree-checker]` `[validate]` — Add validation of
subvolume names embedded in ROOT_REF and ROOT_BACKREF tree items.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** Qu Wenruo `<wqu@suse.com>`, David Sterba
  `<dsterba@suse.com>`
- **Acked-by:** — absent
- **Link:** — absent
- **Cc: stable:** — absent (expected)
- **Signed-off-by:** Zhang Cen `<rollkingzzc@gmail.com>`, David Sterba
  `<dsterba@suse.com>` (ignore pipeline-added SOBs)

Notable: reviewed by two btrfs maintainers; no syzbot report, but the
commit message describes a concrete memory-safety failure mode.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** ROOT_REF/ROOT_BACKREF items store `struct btrfs_root_ref`
  followed by a variable-length name. Readers trust on-disk `name_len`
  and item layout without validation.
- **Symptom:** Corrupted items cause readers to access bytes outside the
  item; `BTRFS_IOC_GET_SUBVOL_INFO` can copy more than 256 bytes into
  its fixed-size UAPI name buffer.
- **Root cause:** Tree-checker validates INODE_REF and ROOT_ITEM but not
  ROOT_REF/ROOT_BACKREF; ioctl derives copy length from total item size
  instead of validated `name_len`.
- **Version info:** None in commit message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit memory-safety /
corruption-handling fix, not cleanup. The ioctl change is defense-in-
depth on top of tree-checker validation.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- `fs/btrfs/tree-checker.c`: +35 lines — new `check_root_ref()`, two new
  switch cases
- `fs/btrfs/ioctl.c`: +6/−6 lines — `btrfs_ioctl_get_subvol_info()`
- **Functions modified:** `check_root_ref()` (new), `check_leaf_item()`,
  `btrfs_ioctl_get_subvol_info()`
- **Scope:** Single-subsystem, surgical, 2 files, ~40 lines net

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

**Hunk 1 — `tree-checker.c`:**
- **Before:** ROOT_REF/ROOT_BACKREF items fell through
  `check_leaf_item()` with no item-specific validation.
- **After:** `check_root_ref()` rejects items where:
  - `item_size <= sizeof(*rref)` (no non-empty name)
  - `name_len > BTRFS_NAME_LEN` (255)
  - `item_size != sizeof(*rref) + name_len` (layout mismatch)
- **Path affected:** Every leaf block read from disk via
  `btrfs_check_leaf()`.

**Hunk 2 — `ioctl.c`:**
- **Before:** `item_len = btrfs_item_size(...) - sizeof(struct
  btrfs_root_ref)`; copy `item_len` bytes into `subvol_info->name[256]`.
- **After:** Copy `btrfs_root_ref_name_len(leaf, rref)` bytes instead.
- **Path affected:** `BTRFS_IOC_GET_SUBVOL_INFO` ioctl on non-top-level
  subvolumes.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** On-disk `name_len` is `__le16` (up to 65535).
  `check_inode_ref()` validates inode refs but ROOT_REF/ROOT_BACKREF had
  no equivalent. In ioctl, `item_len` derived from item size can exceed
  `BTRFS_VOL_NAME_MAX + 1` (256). `read_extent_buffer()` bounds-checks
  the *source* extent-buffer range, not the *destination* buffer size —
  so a 300-byte copy into a 256-byte `name[]` overflows kernel memory.
  Other readers (`send.c`, `export.c`, `super.c`) use
  `btrfs_root_ref_name_len()` directly and can similarly misbehave on
  corrupt metadata.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- Fix mirrors the existing `check_inode_ref()` pattern — obviously
  correct.
- Minimal, no API changes, no refactoring.
- Tree-checker fix protects all consumers at block-read time; ioctl fix
  adds per-call-site safety.
- **Regression risk:** Very low. Valid filesystems always have
  consistent ROOT_REF layout; only corrupt/malicious metadata is
  rejected (returns `-EUCLEAN`/`-EIO` at read time).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Vulnerable ioctl code introduced in `b64ec075bded2` (2018-05-21):
  "btrfs: Add unprivileged ioctl which returns subvolume information"
- `item_len` derivation changed in `3212fa14e77291` (2021-10-21)
- Bug present since 2018 in this tree; ROOT_REF validation gap existed
  since tree-checker was introduced (`check_inode_ref` added 2019 in
  `71bf92a9b8777`, but never extended to ROOT_REF)

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag present — N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Related on master (not in this tree): `3dc22abc21f58` — "btrfs: tree-
  checker: validate INODE_REF's namelen" (adds `namelen >
  BTRFS_NAME_LEN` to `check_inode_ref`)
- This commit is **standalone** — does not depend on `3dc22abc21f58`
- Part of a review series (v1–v4 on linux-btrfs); committed version is
  the final v4 form

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Zhang Cen is a btrfs contributor; David Sterba (committer)
is btrfs maintainer. Patch went through maintainer review cycle.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. `git apply --check` on `0af37c217edf1`
succeeds cleanly against this tree's `ioctl.c` and `tree-checker.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- `b4 dig -c 0af37c217edf1` returned empty (likely too recent for b4
  cache)
- Found via spinics: [PATCH v4] at https://www.spinics.net/lists/linux-
  btrfs/msg165221.html
- Series revisions: v1–v4 exist; committed version matches v4
- Reviewed-by tags from Qu Wenruo and David Sterba in final patch

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC'd to `linux-btrfs@xxxxxxxxxxxxxxx`; reviewed by Qu Wenruo
and David Sterba (subsystem maintainers). `b4 dig -w` returned empty.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report or syzbot link. Bug identified
through code analysis of metadata validation gaps (consistent with other
btrfs tree-checker hardening patches).

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Related but separate: INODE_REF namelen cap
(`3dc22abc21f58`) addresses the same class of bug for a different item
type. Not a prerequisite for this patch.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** No stable-list discussion found. Not a negative signal per
review instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `check_root_ref()`, `check_leaf_item()`,
`btrfs_ioctl_get_subvol_info()`

### Step 5.2: TRACE CALLERS
**Record:**
- `check_leaf_item()` → `__btrfs_check_leaf()` → `btrfs_check_leaf()` →
  called from `read_extent_buffer_pages()` in `disk-io.c:457` on every
  metadata leaf read
- `btrfs_ioctl_get_subvol_info()` → `btrfs_ioctl()` case
  `BTRFS_IOC_GET_SUBVOL_INFO` (`ioctl.c:5361`)

### Step 5.3: TRACE CALLEES
**Record:** `btrfs_root_ref_name_len()`, `btrfs_item_size()`,
`read_extent_buffer()`, `generic_err()`, `copy_to_user()`

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
1. Mount/access btrfs filesystem with corrupt ROOT_BACKREF metadata
2. Block read triggers `btrfs_check_leaf()` — currently passes corrupt
   ROOT_REF items
3. User opens inode on subvolume, calls `BTRFS_IOC_GET_SUBVOL_INFO`
4. Kernel copies `item_len` bytes into 256-byte `name[]` → **kernel
   buffer overflow**
5. **Userspace reachable:** yes, via ioctl on accessible inode (ioctl
   introduced as "unprivileged")

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Same vulnerability class as `check_inode_ref()` (validates
item size vs embedded name length). `send.c:2493`, `export.c:282`,
`super.c:847` all read `btrfs_root_ref_name_len()` without local bounds
checks — tree-checker fix protects all of them centrally.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Vulnerable ioctl code at `ioctl.c:2129–2134`:

```2129:2134:fs/btrfs/ioctl.c
                        item_off = btrfs_item_ptr_offset(leaf, slot)
                                        + sizeof(struct btrfs_root_ref);
                        item_len = btrfs_item_size(leaf, slot)
     - sizeof(struct btrfs_root_ref);
                        read_extent_buffer(leaf, subvol_info->name,
                                           item_off, item_len);
```

`check_root_ref` does not exist; `check_leaf_item()` has no cases for
`BTRFS_ROOT_REF_KEY` / `BTRFS_ROOT_BACKREF_KEY`. Commit `0af37c217edf1`
is **not** an ancestor of HEAD.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** `git apply --check` passes cleanly. ioctl.c uses
`kzalloc`/`kfree` here (not mainline's `AUTO_KFREE`/`kzalloc_obj`), but
the patch hunks align with this tree's code.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** `3dc22abc21f58` (INODE_REF namelen cap) is **not** in this
tree. No duplicate ROOT_REF validation fix present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **btrfs filesystem** — **IMPORTANT** (widely deployed;
metadata corruption handling and ioctl safety affect data integrity and
kernel memory safety).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained; tree-checker receives regular hardening
patches in this tree (e.g., root drop_level validation, error-message
fixes in recent history).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of btrfs with `CONFIG_BTRFS_FS=y/m`. Any system
mounting a btrfs volume (including corrupted or attacker-crafted images)
where ROOT_REF/ROOT_BACKREF items are read.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- Corrupt/malicious ROOT_REF or ROOT_BACKREF metadata (item size ≠
  header + name_len, or name_len > 255)
- Filesystem mounted and metadata block read into cache
- ioctl or other reader consumes the item
- **Likelihood:** Low for organic bitrot with checksums, but realistic
  for crafted images; ioctl path is directly triggerable
- **Unprivileged trigger:** Partially — mounting requires
  `CAP_SYS_ADMIN`, but `BTRFS_IOC_GET_SUBVOL_INFO` is available to users
  with access to inodes on the mount

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- Kernel buffer overflow in `btrfs_ioctl_get_subvol_info()` (256-byte
  destination, unbounded source length)
- Out-of-bounds reads in other ROOT_REF consumers on corrupt metadata
- **Severity: HIGH** (kernel memory corruption; potential crash or worse
  depending on layout)

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents kernel memory corruption on corrupt
  metadata; hardens a gap left open since tree-checker was introduced
- **Risk:** VERY LOW — ~40 lines, follows established `check_inode_ref`
  pattern, reviewed by maintainers, applies cleanly
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real memory-safety bug with kernel buffer overflow in ioctl path
- Affects long-standing code (since 2018)
- Small, surgical, maintainer-reviewed
- Applies cleanly to v6.18.44
- Tree-checker fix protects all ROOT_REF readers, not just ioctl
- Consistent with stable btrfs tree-checker hardening pattern

**AGAINST backport:**
- No syzbot/user crash report (theoretical on well-checksummed
  filesystems)
- Related INODE_REF namelen cap (`3dc22abc21f58`) is a separate follow-
  up, not included here

**UNRESOLVED:**
- No explicit stable nomination found in mailing list (not required)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mirrors `check_inode_ref`;
   reviewed by Qu Wenruo and David Sterba
2. Fixes a real bug? **PASS** — kernel buffer overflow on corrupt
   ROOT_REF metadata
3. Important issue? **PASS** — memory corruption / potential crash (HIGH
   severity)
4. Small and contained? **PASS** — 2 files, ~40 lines
5. No new features or APIs? **PASS** — validation only, no UAPI changes
6. Can apply to local tree? **PASS** — `git apply --check` succeeds

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** Not a device-ID/quirk/DT/build/doc exception — standard bug-
fix category.

### Step 9.4: DECISION RATIONALE
This tree (6.18.44) contains the vulnerable ioctl code and lacks
ROOT_REF/ROOT_BACKREF validation in tree-checker. The fix is small,
maintainer-reviewed, prevents kernel memory corruption on corrupt btrfs
metadata, and applies cleanly. It meets all stable kernel criteria.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no syzbot/Fixes tags;
  Reviewed-by from Qu Wenruo and David Sterba
- **[Phase 2]** Analyzed diff: 2 files, ~40 lines; buffer overflow
  mechanism confirmed in ioctl path
- **[Phase 3]** `git describe HEAD`: v6.18.44; `git blame
  ioctl.c:2129-2134`: introduced 2018; `git merge-base --is-ancestor
  0af37c217edf1 HEAD`: fix NOT present; `git apply --check`: PASS
- **[Phase 4]** `b4 dig -c 0af37c217edf1`: empty; WebFetch spinics
  msg165221: found v4 patch thread; no stable nomination found
- **[Phase 5]** Traced callers: `btrfs_check_leaf` at `disk-io.c:457`;
  ioctl at `ioctl.c:5361`; `read_extent_buffer` only bounds-checks
  source (`extent_io.c:3938-3947`)
- **[Phase 6]** Buggy code confirmed at `ioctl.c:2129-2134`; no
  `check_root_ref` in tree; patch applies cleanly
- **[Phase 7]** Subsystem: btrfs, IMPORTANT criticality
- **[Phase 8]** Failure mode: kernel buffer overflow, HIGH severity;
  benefit HIGH, risk VERY LOW
- **[Phase 9]** All 6 stable rules PASS

**YES****Verdict: YES** — backport to this tree (v6.18.44).

The commit fixes a real memory-safety bug: corrupt
`ROOT_REF`/`ROOT_BACKREF` metadata isn’t validated by tree-checker, and
`BTRFS_IOC_GET_SUBVOL_INFO` can copy more than 256 bytes into its fixed
`name[]` buffer (kernel overflow). The fix adds `check_root_ref()`
(mirroring existing `check_inode_ref()` logic) and tightens the ioctl
copy length. It’s small (~40 lines), maintainer-reviewed, applies
cleanly here, and the vulnerable code is present in this tree.

 fs/btrfs/ioctl.c        | 11 +++++------
 fs/btrfs/tree-checker.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2f1c5f5e2e725..3197f61d612b4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2046,7 +2046,6 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 	struct btrfs_root_ref *rref;
 	struct extent_buffer *leaf;
 	unsigned long item_off;
-	unsigned long item_len;
 	int slot;
 	int ret = 0;
 
@@ -2121,17 +2120,17 @@ static int btrfs_ioctl_get_subvol_info(struct inode *inode, void __user *argp)
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid == subvol_info->treeid &&
 		    key.type == BTRFS_ROOT_BACKREF_KEY) {
+			u16 name_len;
+
 			subvol_info->parent_id = key.offset;
 
 			rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+			name_len = btrfs_root_ref_name_len(leaf, rref);
 			subvol_info->dirid = btrfs_root_ref_dirid(leaf, rref);
 
-			item_off = btrfs_item_ptr_offset(leaf, slot)
-					+ sizeof(struct btrfs_root_ref);
-			item_len = btrfs_item_size(leaf, slot)
-					- sizeof(struct btrfs_root_ref);
+			item_off = btrfs_item_ptr_offset(leaf, slot) + sizeof(*rref);
 			read_extent_buffer(leaf, subvol_info->name,
-					   item_off, item_len);
+					   item_off, name_len);
 		} else {
 			ret = -ENOENT;
 			goto out;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index db7402836340a..97be0c1ed22f7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1288,6 +1288,37 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	return 0;
 }
 
+static int check_root_ref(struct extent_buffer *leaf, struct btrfs_key *key, int slot)
+{
+	struct btrfs_root_ref *rref;
+	u32 item_size = btrfs_item_size(leaf, slot);
+	u32 name_len;
+
+	if (unlikely(item_size <= sizeof(*rref))) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect > %zu",
+			    key->type, item_size, sizeof(*rref));
+		return -EUCLEAN;
+	}
+
+	rref = btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
+	name_len = btrfs_root_ref_name_len(leaf, rref);
+	if (unlikely(name_len > BTRFS_NAME_LEN)) {
+		generic_err(leaf, slot,
+			    "root ref name too long for key type %u, have %u max %u",
+			    key->type, name_len, BTRFS_NAME_LEN);
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size != sizeof(*rref) + name_len)) {
+		generic_err(leaf, slot,
+			    "invalid root ref item size for key type %u, have %u expect %zu",
+			    key->type, item_size, sizeof(*rref) + name_len);
+		return -EUCLEAN;
+	}
+
+	return 0;
+}
+
 __printf(3,4)
 __cold
 static void extent_err(const struct extent_buffer *eb, int slot,
@@ -1965,6 +1996,10 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_ROOT_ITEM_KEY:
 		ret = check_root_item(leaf, key, slot);
 		break;
+	case BTRFS_ROOT_REF_KEY:
+	case BTRFS_ROOT_BACKREF_KEY:
+		ret = check_root_ref(leaf, key, slot);
+		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
 		ret = check_extent_item(leaf, key, slot, prev_key);
-- 
2.53.0

