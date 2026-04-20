Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8F949251F;
	Mon, 20 Apr 2026 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691939; cv=none; b=AJethHcI5P6b+3OcODnWjPHZv56kZjp04AW11Y2KBR603H+pfjkKlpywZ8jxoXmwrQwYihwOb7n5rsaNEhS+gDqxF7hxXOf2TRYhNTDaE9oimMH5JBeRfuCU8eiSKJSfZ90L9o6eVbWA8jIGS9eQKiJWAAJ7woTKdlVX4P8Me6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691939; c=relaxed/simple;
	bh=1hpRm6P3DILHi717aovrrIVgA+crpsx39F/oA0NUir0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDuQjgHRGSiqFEkjn6mGojXiQJu37SulG8Y3AysPI1YLM9s0fuY82YiDrl4C/EMdAUIhflOikFyv6acZs2QLND+FSHLUwi3ADDABqFRk3CfAN7M05ESiwWBln58GXizrxqiONtydnM2oTYfZflWERtzI60F8ELvoWhhZFF3g1T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqluiPpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqluiPpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06618C2BCB7;
	Mon, 20 Apr 2026 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691938;
	bh=1hpRm6P3DILHi717aovrrIVgA+crpsx39F/oA0NUir0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqluiPpCGm5PFpFs/7wvT8bvWeSCRWx4zz3i3Kkex4fUOv/le5erw+8WSvc5Bfz1V
	 mnYZpWFMGWiWlW2bqVPvem8VaVong76lm7zr1ooGlVb8A6aAxj75Dgp6o/vyql75fQ
	 ijkeQYSEMHRnbkDie5L8iumV67GlrWUgdJYfij0aaTlu0+iTjWWzNXoluCCYr3kh+t
	 LLoNeycvvRGbTcUsYJfUjvWCJT9pLcpjGi89YJ+Eo2G6+8P4XBatd7rJkYBdVI7/Vb
	 hw7QsyuieRXLbHtFkV+SLCOMevxrxf48DyF+Ar5TUNYnfXTlQujSCm2Ho9x6FhpNdO
	 Hd0bDbnYQRdaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Grzedzicki <mge@meta.com>,
	Qu Wenruo <wqu@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] btrfs: fix silent IO error loss in encoded writes and zoned split
Date: Mon, 20 Apr 2026 09:21:14 -0400
Message-ID: <20260420132314.1023554-280-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Grzedzicki <mge@meta.com>

[ Upstream commit 3cd181cc46d36aa7bd4af85f14639d86a25beaec ]

can_finish_ordered_extent() and btrfs_finish_ordered_zoned() set
BTRFS_ORDERED_IOERR via bare set_bit(). Later,
btrfs_mark_ordered_extent_error() in btrfs_finish_one_ordered() uses
test_and_set_bit(), finds it already set, and skips
mapping_set_error(). The error is never recorded on the inode's
address_space, making it invisible to fsync. For encoded writes this
causes btrfs receive to silently produce files with zero-filled holes.

Fix: replace bare set_bit(BTRFS_ORDERED_IOERR) with
btrfs_mark_ordered_extent_error() which pairs test_and_set_bit() with
mapping_set_error(), guaranteeing the error is recorded exactly once.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: Michal Grzedzicki <mge@meta.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

# PHASE 1: COMMIT MESSAGE FORENSICS

## Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem prefix**: `btrfs`
- **Action verb**: "fix"
- **Summary**: Fix silent IO error loss in encoded writes and zoned
  split
- Record: [btrfs] [fix] [silent IO error loss in encoded writes and
  zoned split paths]

## Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Reviewed-by**: Qu Wenruo `<wqu@suse.com>` — well-known btrfs
  developer/maintainer
- **Reviewed-by**: Johannes Thumshirn `<johannes.thumshirn@wdc.com>` —
  prominent btrfs contributor
- **Reviewed-by**: Mark Harmstone `<mark@harmstone.com>` — btrfs
  developer
- **Signed-off-by**: Michal Grzedzicki `<mge@meta.com>` — author (Meta)
- **Signed-off-by**: David Sterba `<dsterba@suse.com>` — btrfs subsystem
  maintainer
- No Fixes: tag, no Cc: stable — expected for candidate review
- No Reported-by — likely found via code review/testing at Meta
- Record: 3 Reviewed-by from expert btrfs devs, signed off by subsystem
  maintainer.

## Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes a clear, precise bug mechanism:
1. `can_finish_ordered_extent()` and `btrfs_finish_ordered_zoned()` set
   `BTRFS_ORDERED_IOERR` via bare `set_bit()`.
2. Later, `btrfs_mark_ordered_extent_error()` in
   `btrfs_finish_one_ordered()` uses `test_and_set_bit()`, finds the bit
   already set, and **skips** `mapping_set_error()`.
3. The IO error is never recorded on the inode's address_space, making
   it invisible to `fsync`.
4. For encoded writes, `btrfs receive` silently produces files with
   zero-filled holes.

- **Failure mode**: Silent data corruption (zero-filled holes instead of
  actual data)
- **Root cause**: bare `set_bit()` pre-empts the `test_and_set_bit()` in
  the helper that actually records the error
- Record: [Silent data loss bug] [fsync misses IO errors] [Encoded write
  files get zero-filled holes] [Author clearly explains the root cause
  mechanism]

## Step 1.4: DETECT HIDDEN BUG FIXES
This is an explicit bug fix, not hidden. The subject and body directly
describe a data integrity bug.
Record: [Not a hidden fix — explicitly described as a data loss fix]

---

# PHASE 2: DIFF ANALYSIS - LINE BY LINE

## Step 2.1: INVENTORY THE CHANGES
- `fs/btrfs/ordered-data.c`: 1 line changed (line 388)
- `fs/btrfs/zoned.c`: 1 line changed (line 2139)
- Total: 2 lines changed, 0 lines added/removed net
- Functions modified: `can_finish_ordered_extent()`,
  `btrfs_finish_ordered_zoned()`
- Record: [2 files, 2 lines changed, single-file-equivalent surgical
  fix]

## Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1** (`ordered-data.c:388`):
- Before: `set_bit(BTRFS_ORDERED_IOERR, &ordered->flags)` — sets flag
  only
- After: `btrfs_mark_ordered_extent_error(ordered)` — sets flag AND
  calls `mapping_set_error()`

**Hunk 2** (`zoned.c:2139`):
- Before: `set_bit(BTRFS_ORDERED_IOERR, &ordered->flags)` — sets flag
  only
- After: `btrfs_mark_ordered_extent_error(ordered)` — sets flag AND
  calls `mapping_set_error()`
- Record: [Both hunks: bare set_bit → helper that also records error on
  mapping]

## Step 2.3: IDENTIFY THE BUG MECHANISM
**Category**: Logic / correctness bug → silent data corruption

The bug is a race between setting the error flag and recording the
error:
1. `can_finish_ordered_extent()` uses bare `set_bit()` to set
   `BTRFS_ORDERED_IOERR`
2. `btrfs_finish_one_ordered()` (line 3363) later calls
   `btrfs_mark_ordered_extent_error()`
3. `btrfs_mark_ordered_extent_error()` does `if (!test_and_set_bit(...))
   mapping_set_error()`
4. Since the bit was already set by step 1, step 3 thinks the error was
   already recorded and skips `mapping_set_error()`
5. But the `mapping_set_error()` was NEVER called — the bare `set_bit()`
   didn't do it

Record: [Logic/correctness bug] [test_and_set_bit finds bit already set,
skips recording error to mapping]

## Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct**: YES. The helper function
  `btrfs_mark_ordered_extent_error()` at line 336-340 does exactly
  what's needed:

```336:340:fs/btrfs/ordered-data.c
void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent
*ordered)
{
        if (!test_and_set_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
                mapping_set_error(ordered->inode->vfs_inode.i_mapping,
-EIO);
}
```

- **Minimal/surgical**: YES. 2 lines, identical transformation pattern.
- **Regression risk**: Essentially zero. The helper does a superset of
  what the bare `set_bit()` did: same flag setting + additional error
  recording. The `test_and_set_bit()` ensures `mapping_set_error()` is
  called at most once.
- Record: [Obviously correct, minimal, zero regression risk]

---

# PHASE 3: GIT HISTORY INVESTIGATION

## Step 3.1: BLAME THE CHANGED LINES
- **ordered-data.c:388**: Introduced by commit `53df25869a5659`
  (Christoph Hellwig, 2023-05-31) — "btrfs: factor out a
  can_finish_ordered_extent helper". Present since v6.5.
- **zoned.c:2139**: Introduced by commit `71df088c1cc090` (Christoph
  Hellwig, 2023-05-24) — "btrfs: defer splitting of ordered extents
  until I/O completion". Present since v6.5.
- **Helper function** (`btrfs_mark_ordered_extent_error()`): Introduced
  by commit `aa5ccf29173acf` (Josef Bacik, 2024-04-03) — "btrfs: handle
  errors in btrfs_reloc_clone_csums properly". Present since v6.10.

Record: [Buggy code introduced in v6.5 by refactoring commits; helper
exists from v6.10]

## Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present — expected. The commits that introduced the bare
`set_bit()` calls (`53df25869a5659` and `71df088c1cc090`) are the
implicit "fixes targets."
Record: [Implicit fixes: 53df25869a5659 and 71df088c1cc090, both in
v6.5+]

## Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent ordered-data.c changes are refactoring (folio conversion, lock
relaxation). No conflicting changes to the `can_finish_ordered_extent()`
function in this area. The fix is self-contained.
Record: [No conflicting recent changes; fix is standalone]

## Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Michal Grzedzicki from Meta. Other commits in this tree are in SCSI.
This appears to be a cross-subsystem contributor who found the bug
likely through `btrfs receive` usage at Meta.
Record: [Author is from Meta, likely found bug through production btrfs
receive usage]

## Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The helper `btrfs_mark_ordered_extent_error()` already exists in the 7.0
tree (and all trees since v6.10). The fix has NO dependencies for v6.10+
trees. For v6.6-v6.9, the helper would need to be backported first.
Record: [No dependencies for 7.0 tree; for older stable trees, helper
(aa5ccf29173acf) may be needed]

---

# PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

## Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
b4 dig did not find a match (commit not yet in mainline at time of
search). Web search also did not locate the specific patch thread. This
is likely a recently submitted patch that was accepted into David
Sterba's btrfs tree but not yet pushed to mainline.
Record: [Could not locate lore discussion — likely very recent
submission]

## Step 4.2: CHECK WHO REVIEWED THE PATCH
Three Reviewed-by tags from Qu Wenruo, Johannes Thumshirn, and Mark
Harmstone — three core btrfs developers. David Sterba (btrfs maintainer)
signed off, indicating it passed through the official btrfs tree.
Record: [Reviewed by 3 expert btrfs developers; signed off by
maintainer]

## Step 4.3-4.5: SEARCH FOR BUG REPORT / RELATED PATCHES / STABLE
HISTORY
No external bug report found. The commit message specifically mentions
`btrfs receive` producing files with zero-filled holes, suggesting this
was found in a production environment at Meta.
Record: [Likely production-found bug at Meta; no external reports found]

---

# PHASE 5: CODE SEMANTIC ANALYSIS

## Step 5.1: IDENTIFY KEY FUNCTIONS
- `can_finish_ordered_extent()` — processes ordered extent completion
- `btrfs_finish_ordered_zoned()` — handles zoned write completion
- `btrfs_mark_ordered_extent_error()` — the helper being used as the fix

## Step 5.2: TRACE CALLERS
`can_finish_ordered_extent()` is called by:
- `btrfs_finish_ordered_extent()` — called from IO completion paths (bio
  endio)
- `btrfs_mark_ordered_io_finished()` — called from writeback paths

`btrfs_finish_ordered_zoned()` is called by:
- `btrfs_finish_ordered_io()` — the main ordered extent completion
  function

These are core IO completion paths — every data write goes through them.
Record: [Core IO completion path; called for every write operation]

## Step 5.3-5.4: TRACE CALLEES AND CALL CHAIN
The encoded write path is: `btrfs_do_encoded_write()` →
`btrfs_submit_compressed_write()` → bio completion →
`end_bbio_compressed_write()` → `btrfs_finish_ordered_extent()` →
`can_finish_ordered_extent()`. This is the path that `btrfs receive`
uses.
Record: [btrfs receive → encoded write → bio completion → buggy
function]

## Step 5.5: SEARCH FOR SIMILAR PATTERNS
The third `set_bit(BTRFS_ORDERED_IOERR)` in `disk-io.c:4598` is in
`btrfs_destroy_ordered_extents()`, a cleanup path during filesystem
abort/unmount. This is intentionally different — during umount there's
no fsync concern, so bare `set_bit()` is acceptable there.
Record: [disk-io.c case is in cleanup path, doesn't need the fix]

---

# PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

## Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
- Buggy `set_bit()` calls: present since v6.5
- Helper function: present since v6.10
- For 7.0 tree: both the buggy code AND the helper exist. Fix applies
  directly.
- For v6.12.y, v6.6.y: buggy code exists; v6.12 has the helper, v6.6
  does not.
Record: [Bug exists in 7.0 tree; fix applies cleanly]

## Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The fix is a trivial 2-line substitution. No contextual conflicts
expected for 7.0.
Record: [Clean apply expected for 7.0]

## Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No related fixes found in this tree for this specific issue.
Record: [No existing fix in stable]

---

# PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

## Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- **Subsystem**: fs/btrfs — filesystem
- **Criticality**: IMPORTANT — btrfs is widely used, and data integrity
  is its primary value proposition
Record: [btrfs filesystem, IMPORTANT criticality]

## Step 7.2: ASSESS SUBSYSTEM ACTIVITY
The btrfs subsystem is very actively developed (48+ commits since v6.6
in ordered-data.c alone).
Record: [Very active subsystem]

---

# PHASE 8: IMPACT AND RISK ASSESSMENT

## Step 8.1: DETERMINE WHO IS AFFECTED
- All btrfs users who encounter IO errors during:
  1. Encoded writes (`btrfs receive` with stream v2/v3)
  2. Zoned device writes where ordered extent splitting fails
Record: [btrfs receive users, zoned device users]

## Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Encoded writes**: Any IO error during `btrfs receive` (e.g., disk
  error, corruption)
- **Zoned split**: Memory allocation failure during zoned ordered extent
  splitting
- These are not obscure conditions — disk errors happen, and memory
  pressure with `btrfs receive` on large datasets is common in
  production
Record: [IO error during btrfs receive or zoned write; realistic trigger
conditions]

## Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- **Silent data corruption**: Files produced by `btrfs receive` have
  zero-filled holes where data should be
- `fsync` returns success because `mapping_set_error()` was never called
- User believes data is safely written when it is not
- **Severity: CRITICAL** — silent data loss is the worst possible
  outcome for a filesystem
Record: [Silent data loss; fsync returns success with corrupted data;
CRITICAL]

## Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT**: Very high — prevents silent data corruption for `btrfs
  receive` users
- **RISK**: Very low — 2-line change, replacing bare `set_bit()` with
  existing helper that does strictly more, obviously correct
Record: [Very high benefit, very low risk — strongly favorable ratio]

---

# PHASE 9: FINAL SYNTHESIS

## Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes silent data corruption (the most critical bug category for
  filesystems)
- Extremely small and surgical (2 lines)
- Uses existing well-tested helper function
- Obviously correct by code inspection
- 3 Reviewed-by from expert btrfs developers
- Signed off by btrfs subsystem maintainer (David Sterba)
- Bug affects `btrfs receive` — a critical data migration/backup tool
- All needed infrastructure (the helper) already exists in the 7.0 tree
- Zero regression risk

**Evidence AGAINST backporting:**
- None identified

**Unresolved questions:**
- Could not access lore.kernel.org to read full patch discussion (Anubis
  bot protection)
- Could not find the commit in mainline (likely very recently merged or
  in-flight to next merge window)

## Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — trivial substitution of bare
   `set_bit()` with existing helper; 3 reviews
2. **Fixes a real bug?** YES — silent data loss in `btrfs receive`
3. **Important issue?** YES — data corruption (CRITICAL severity)
4. **Small and contained?** YES — 2 lines, 2 files
5. **No new features or APIs?** YES — uses existing helper
6. **Can apply to stable trees?** YES — clean apply for 7.0 (helper
   exists)

## Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category — this is a standard bug fix, and a strong
one.

## Step 9.4: DECISION
This is a textbook stable backport candidate: a tiny, obviously correct
fix for silent data corruption in a widely used filesystem feature
(`btrfs receive`). It uses existing infrastructure, has been thoroughly
reviewed, and carries essentially zero regression risk.

---

# Verification

- [Phase 1] Parsed tags: 3 Reviewed-by (Qu Wenruo, Johannes Thumshirn,
  Mark Harmstone), 2 Signed-off-by (author + David Sterba maintainer)
- [Phase 2] Diff analysis: 2 lines changed —
  `set_bit(BTRFS_ORDERED_IOERR)` → `btrfs_mark_ordered_extent_error()`
  in two locations
- [Phase 2] Verified `btrfs_mark_ordered_extent_error()` at line 336-340
  does `test_and_set_bit() + mapping_set_error()` — confirmed exact
  mechanism described in commit message
- [Phase 2] Verified `btrfs_finish_one_ordered()` at inode.c:3363 calls
  `btrfs_mark_ordered_extent_error()` which finds bit already set and
  skips `mapping_set_error()` — confirmed the "double-set" bug path
- [Phase 3] git blame: `ordered-data.c:388` introduced by 53df25869a5659
  (Christoph Hellwig, v6.5)
- [Phase 3] git blame: `zoned.c:2139` introduced by 71df088c1cc090
  (Christoph Hellwig, v6.5)
- [Phase 3] git show aa5ccf29173acf: confirmed
  `btrfs_mark_ordered_extent_error()` introduced in v6.10 by Josef Bacik
- [Phase 3] git merge-base: confirmed helper exists in v6.10+, buggy
  code in v6.5+
- [Phase 4] b4 dig: no match found (likely very recent patch not yet
  indexed)
- [Phase 4] UNVERIFIED: Could not access lore.kernel.org discussion due
  to bot protection
- [Phase 5] Traced call chain: `btrfs_do_encoded_write()` → bio
  completion → `btrfs_finish_ordered_extent()` →
  `can_finish_ordered_extent()` — confirmed encoded writes reach buggy
  code
- [Phase 5] Verified disk-io.c:4598 `set_bit()` is in
  `btrfs_destroy_ordered_extents()` (cleanup path) — correctly not fixed
- [Phase 5] Verified 3 remaining bare `set_bit(BTRFS_ORDERED_IOERR)`
  calls: 2 fixed by this commit, 1 in cleanup path (acceptable)
- [Phase 6] Confirmed buggy code exists in 7.0 tree (read both files
  directly)
- [Phase 6] Confirmed fix applies cleanly — helper exists, code context
  matches
- [Phase 8] Failure mode: silent data loss (zero-filled holes) —
  CRITICAL severity

**YES**

 fs/btrfs/ordered-data.c | 2 +-
 fs/btrfs/zoned.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5df02c707aee6..b65c1f1e2956e 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -385,7 +385,7 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	}
 
 	if (!uptodate)
-		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
+		btrfs_mark_ordered_extent_error(ordered);
 
 	if (ordered->bytes_left)
 		return false;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0cd7fd3fcfa3a..d728c3bafc092 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2136,7 +2136,7 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
 			continue;
 		}
 		if (!btrfs_zoned_split_ordered(ordered, logical, len)) {
-			set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
+			btrfs_mark_ordered_extent_error(ordered);
 			btrfs_err(fs_info, "failed to split ordered extent");
 			goto out;
 		}
-- 
2.53.0

