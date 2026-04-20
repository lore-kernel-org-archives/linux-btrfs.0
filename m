Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B7421884;
	Mon, 20 Apr 2026 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691655; cv=none; b=mSAkM8d70zyR1HkJPDF95cmNTpA8wUmX20tMfqdCC5PVV3Hrp34nJCUqJk0uDwE1jK+jPoNRqMUdeaEmVXm4I+Bd6YxihpJwP5lSQHFDZBlFm1vz/bpoeo4T1o8E9coazAYN88SzztT1azCc5n+x3F2pBx1xUJdgGRp4EwgQukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691655; c=relaxed/simple;
	bh=G7VJJaTaxr7b3XLIoxE7vwkM/LSUFkg0fMzL9nJqDP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BT/2sX+dGZTJAwvCyX22/DiqJXB+6kF5CkvFSWytn1Ws68JL+Y0vAEWnl50WcQi30YOzI3HO1lfmXw/H+WEN+b8gPwQVdPb3RgK0BYnhT7orJlZDobwXkpXdanEbY8iNdTZsiFBi9+L7OI6m5wnaqaQFWstD7V/Xz3D5e4ijjIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvQDJmOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvQDJmOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15766C19425;
	Mon, 20 Apr 2026 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691655;
	bh=G7VJJaTaxr7b3XLIoxE7vwkM/LSUFkg0fMzL9nJqDP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvQDJmOLvqamjunl7T5oerd2KkiFPgpxsDvZC9Y4qCQyWfacx99BVhrG8XC0is3k2
	 9yCHzf8l6WteltrHp2aIr8w+o+arXNMc3/GhSebeoMiPuCSz+CiudIVQuHkgYJalTY
	 x8q/GaS3FUBJF+Xgn6we9m+Qqf8t7Kgzo0QalMGwqEx7S7WVWSsJOzYRC8YcvNbIk8
	 ij77Q0ePXnbD+w1s+6rUy+LAWwxZkJV9h6vfKl2tU+jwZKhiPLA3UEMVDiQnXzhHnT
	 2XAjDZMBjBM13caFB+IYIylB3xzMvrJepvQWh6egrXrmmGp+AY0qR2lHDMGcsm6d/N
	 KDSrqwTa6VWxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Teng Liu <27rabbitlt@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] btrfs: replace BUG_ON() with error return in cache_save_setup()
Date: Mon, 20 Apr 2026 09:19:09 -0400
Message-ID: <20260420132314.1023554-155-sashal@kernel.org>
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

From: Teng Liu <27rabbitlt@gmail.com>

[ Upstream commit 30d537f723d6f37a8ddfb17fe668bb9808f5b49f ]

In cache_save_setup(), if create_free_space_inode() succeeds but the
subsequent lookup_free_space_inode() still fails on retry, the
BUG_ON(retries) will crash the kernel. This can happen due to I/O
errors or transient failures, not just programming bugs.

Replace the BUG_ON with proper error handling that returns the original
error code through the existing cleanup path. The callers already handle
this gracefully: disk_cache_state defaults to BTRFS_DC_ERROR, so the
space cache simply won't be written for that block group.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile the final
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: btrfs
- **Action verb**: "replace" (BUG_ON with error return)
- **Summary**: Replaces a kernel-crashing BUG_ON() with graceful error
  handling in cache_save_setup()

Record: [btrfs] [replace] [Remove BUG_ON(retries) in cache_save_setup(),
replace with error return]

### Step 1.2: Tags
- **Reviewed-by**: Qu Wenruo <wqu@suse.com> - prominent btrfs
  maintainer/reviewer
- **Signed-off-by**: Teng Liu <27rabbitlt@gmail.com> (author)
- **Signed-off-by**: David Sterba <dsterba@suse.com> (btrfs maintainer
  who merged it)
- No Fixes: tag (expected for candidates)
- No Cc: stable (expected)

Record: Reviewed by key btrfs developer Qu Wenruo. Merged by David
Sterba, the btrfs maintainer.

### Step 1.3: Commit Body
The bug: If `create_free_space_inode()` succeeds but the subsequent
`lookup_free_space_inode()` still fails on retry (due to I/O errors or
transient failures), `BUG_ON(retries)` crashes the kernel. The callers
already handle errors gracefully - `disk_cache_state` defaults to
`BTRFS_DC_ERROR`, so the space cache simply won't be written for that
block group.

Record: Bug = kernel crash (BUG_ON) on transient I/O failures. Symptom =
kernel panic. Root cause = BUG_ON used for a condition that can happen
due to I/O errors, not just programming bugs.

### Step 1.4: Hidden Bug Fix Detection
This IS a bug fix - it prevents a kernel crash (BUG_ON → panic) from a
reachable error condition.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (fs/btrfs/block-group.c)
- **Lines**: +6 added, -1 removed (net +5 lines)
- **Function modified**: `cache_save_setup()`
- **Scope**: Single-file, surgical fix

### Step 2.2: Code Flow Change
**Before**: `BUG_ON(retries)` — if retries is non-zero (i.e., we already
tried once to create the inode and look it up again), the kernel
crashes.

**After**: If retries is non-zero, set `ret = PTR_ERR(inode)`, log an
error message, and `goto out_free` which flows through the existing
cleanup path. `dcs` remains `BTRFS_DC_ERROR` (its initial value), so
`block_group->disk_cache_state` will be set to `BTRFS_DC_ERROR`, and the
space cache simply won't be written for this block group.

### Step 2.3: Bug Mechanism
Category: **Logic/correctness fix** - replacing a crash assertion with
proper error handling. The BUG_ON asserts that a condition "cannot
happen," but it can happen due to I/O errors.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes. The `out_free` path already exists and
  handles exactly this case. The `dcs` variable defaults to
  `BTRFS_DC_ERROR`.
- **Minimal/surgical**: Yes, only 6 lines added replacing 1 line.
- **Regression risk**: Very low. The error path is well-established and
  callers check `disk_cache_state == BTRFS_DC_SETUP` before proceeding.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The BUG_ON(retries) line was in commit `77745c05115fc` (2019), which was
a code migration. The actual BUG_ON was introduced in commit
`0af3d00bad38d` ("Btrfs: create special free space cache inode") from
2010, present since **v2.6.37**. This bug has been in the kernel for ~16
years.

### Step 3.2: No Fixes: tag to follow (expected).

### Step 3.3: Related Changes
- `8ac7fad32b930` (Feb 2026): Removed a pointless WARN_ON() in the same
  function - shows the btrfs team is actively cleaning up this function.
- `719dc4b75561f`: Similar BUG_ON removal in
  `btrfs_remove_block_group()`
- Many other BUG_ON removal commits in btrfs history

### Step 3.4: Author
Teng Liu (27rabbitlt) appears to be a relatively new contributor.
However, the patch was **Reviewed-by Qu Wenruo** and **Signed-off-by
David Sterba** (the btrfs maintainer), giving it strong credibility.

### Step 3.5: Dependencies
None. This is a completely standalone fix - it only changes one
conditional in one function, using existing error paths.

## PHASE 4: MAILING LIST RESEARCH

The patch was submitted as v1 and v2 on 2026-03-28, found in the
lore/LKML archive mirror. The v2 was the applied version. Reviewed-by Qu
Wenruo confirms it was peer-reviewed by a senior btrfs developer.

Record: Patch went through v1 → v2 revision. Reviewed by senior btrfs
developer.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Function Modified
`cache_save_setup()` - a static function in `fs/btrfs/block-group.c`.

### Step 5.2: Callers
Three callers, all in the same file:
1. `btrfs_setup_space_cache()` (line 3490) - ignores return value
2. `btrfs_start_dirty_block_groups()` (line 3577) - ignores return
   value, checks `disk_cache_state`
3. `btrfs_write_dirty_block_groups()` (line 3729) - ignores return
   value, checks `disk_cache_state`

All callers check `cache->disk_cache_state == BTRFS_DC_SETUP` before
proceeding with cache write. When `cache_save_setup()` fails, `dcs`
stays at `BTRFS_DC_ERROR`, so the callers gracefully skip the cache
write.

### Step 5.3-5.4: Call Chain
These functions are called during **transaction commit**
(`btrfs_commit_transaction`), a core kernel path that runs frequently
during normal btrfs filesystem operations.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The BUG_ON(retries) was introduced in v2.6.37 (2010) and exists in **ALL
active stable trees** (5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, etc.). The
code hasn't changed around this specific line since it was written.

### Step 6.2: Backport Complications
The patch should apply cleanly to all stable trees. The surrounding code
is unchanged since 2019 (when it was migrated from extent-tree.c to
block-group.c). For trees older than 5.3 (before migration), the file
would be `extent-tree.c` instead.

### Step 6.3: No related fixes already in stable.

## PHASE 7: SUBSYSTEM CONTEXT

- **Subsystem**: btrfs (filesystem)
- **Criticality**: IMPORTANT - btrfs is a widely used filesystem
  (default in openSUSE, Fedora)
- **Path**: Space cache management during transaction commit - a **core
  btrfs operation**

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All btrfs users with space_cache v1 enabled (the default for many
configs) are affected.

### Step 8.2: Trigger Conditions
The BUG_ON triggers when:
1. A block group's free space cache needs to be written
2. The free space inode doesn't exist, so btrfs creates one
3. On retry lookup, the inode still can't be found (I/O error, transient
   failure)

This can be triggered by I/O errors on the disk, which are real-world
events, especially on aging or failing hardware.

### Step 8.3: Failure Mode
**CRITICAL** - BUG_ON causes a kernel panic, crashing the system.
Without this fix, a transient I/O error during space cache setup causes
a full system crash instead of gracefully skipping the cache write.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: VERY HIGH - prevents kernel panic on I/O errors during
  normal filesystem operation
- **Risk**: VERY LOW - 6-line change using existing error paths,
  reviewed by btrfs maintainers
- **Ratio**: Strongly favorable for backporting

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Prevents kernel panic (BUG_ON → crash) on a reachable error condition
- Tiny, surgical fix (+6/-1 lines) in a single file
- Uses existing, well-tested error handling paths
- Bug present since v2.6.37 (2010) — affects ALL stable trees
- Reviewed by Qu Wenruo (senior btrfs developer), merged by David Sterba
  (btrfs maintainer)
- No dependencies on other patches
- Callers already handle the error gracefully
- btrfs is a widely-used filesystem
- Pattern consistent with other BUG_ON removals in btrfs that have gone
  to stable

**AGAINST backporting:**
- No reported syzbot trigger or specific user crash report cited
- The trigger condition (I/O error between create and lookup) may be
  uncommon

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - trivial change, reviewed by
   maintainer
2. Fixes a real bug? **YES** - kernel panic on I/O error
3. Important issue? **YES** - kernel crash (CRITICAL severity)
4. Small and contained? **YES** - 6 lines, single file
5. No new features or APIs? **YES** - purely error handling
6. Can apply to stable? **YES** - code unchanged since 2010

### Step 9.3: Exception Categories
Not needed - this qualifies as a straightforward bug fix.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Qu Wenruo, SOB David Sterba (btrfs
  maintainer)
- [Phase 2] Diff analysis: +6/-1 lines replacing BUG_ON(retries) with
  error return + log message, uses existing `out_free` cleanup path
- [Phase 3] git blame: BUG_ON(retries) introduced in commit
  `0af3d00bad38d` (v2.6.37-rc1, 2010), migrated in `77745c05115fc`
  (2019)
- [Phase 3] git describe: confirmed original commit is in v2.6.37-rc1,
  present in all stable trees
- [Phase 3] Related commits: `8ac7fad32b930` removed WARN_ON in same
  function (Feb 2026), `719dc4b75561f` similar BUG_ON removal in btrfs
- [Phase 4] Found v1 and v2 patch submissions on lore mirror
  (2026-03-28), v2 is the applied version
- [Phase 5] Verified callers: 3 call sites in same file, all ignore
  return value and check `disk_cache_state == BTRFS_DC_SETUP` — error
  case is handled gracefully
- [Phase 5] Verified `dcs` defaults to `BTRFS_DC_ERROR` (line 3316),
  confirmed `out_free` path preserves this default
- [Phase 6] Code exists unchanged in all active stable trees (verified
  via git log v6.6.. and git log v6.1..)
- [Phase 6] Patch should apply cleanly (code hasn't changed since 2019
  migration)
- [Phase 8] Failure mode: BUG_ON → kernel panic during transaction
  commit, severity CRITICAL
- UNVERIFIED: Could not fetch full lore.kernel.org discussion due to bot
  protection; relied on web search confirmation of review

The fix is small, surgical, obviously correct, prevents a kernel crash,
uses existing error paths, and was reviewed and merged by the btrfs
maintainers. It meets all stable kernel criteria.

**YES**

 fs/btrfs/block-group.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c0d17a369bda5..ccabcad1a3fc3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3343,7 +3343,13 @@ static int cache_save_setup(struct btrfs_block_group *block_group,
 	}
 
 	if (IS_ERR(inode)) {
-		BUG_ON(retries);
+		if (retries) {
+			ret = PTR_ERR(inode);
+			btrfs_err(fs_info,
+				  "failed to lookup free space inode after creation for block group %llu: %d",
+				  block_group->start, ret);
+			goto out_free;
+		}
 		retries++;
 
 		if (block_group->ro)
-- 
2.53.0

