Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B283EE1EC;
	Wed, 20 May 2026 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276041; cv=none; b=hqqJokkX11iUWrbcVOb0dNHAijLjUfApayRdvG2sZxSssXIk2EQcnQdwnZ3pwc8BlbokJ2fSIgeR4fN9ek/4Dnr0A9UStpbVUlTL8+cXyzJwui1vZWR5Jc/haFFdgpDEYMMePio94tjtbnj+qAo2+1FiGUVTll4YZaDO2nQqu2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276041; c=relaxed/simple;
	bh=R0CXG/sR2XzcTICPaASs4rIpFuUDTo6aKtSJf/5vWx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAYsAvOkieLE4KlkAC11N4tGOpTykOnh1YhAggtX5f2G4/kJEUmlbV8drqdHDETjXZKX44K/BhvUbF1sfc+873BiXHIijEr4PHVSnuiZeeCgvwCcsXuVN0NLse/PwVZN+zm16VpRmH20gji4Nag2Y7bJimX8NsNf3ytXKxuI9Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdE5gZrN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdE5gZrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703CE1F00894;
	Wed, 20 May 2026 11:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276039;
	bh=BasMEeDW6XPs7A/N3atABlk5j0/nIx2aBYDkA9++MyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdE5gZrNLjmPSdqojUnXV5QQ8ADfTnnDFVCzgSgidcLgPUbAEXXIdwPobi8m5aJ0f
	 LjV8ABsei4zGMVvmLq5B2bxw7XKMe6lFq1JfK4T3VF4bDOxYec8oYJ2R+h7uaxNelg
	 GXmoWOKj57wWk8Avt3dVmHTwVDNqdsn/Kc+ygUg6VAJs9fxuxGR9DeyEvH8UoRImoH
	 wOVKPjQfqtmzW7S9P0/U52ZHxb/rHJ/+yBytn+fKeGLismDnsxFKbv6cqFeS6+38/q
	 sSpolIzOJWp5aFmng42dhhFz3+pqVBa24oB24WWGOg2IvYfp8ILbuGLNpfNoSbISju
	 FIe+CC7bmZ2gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] btrfs: fix check_chunk_block_group_mappings() to iterate all chunk maps
Date: Wed, 20 May 2026 07:19:10 -0400
Message-ID: <20260520111944.3424570-38-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit fc51cba3ebae67f967120e27162e94cfb8594479 ]

[BUG]
A corrupted image with a chunk present in the chunk tree but whose
corresponding block group item is missing from the extent tree can be
mounted successfully, even though check_chunk_block_group_mappings()
is supposed to catch exactly this corruption at mount time.  Once
mounted, running btrfs balance with a usage filter (-dusage=N or
-dusage=min..max) triggers a null-ptr-deref:

  KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
    RIP: 0010:chunk_usage_filter fs/btrfs/volumes.c:3874 [inline]
    RIP: 0010:should_balance_chunk fs/btrfs/volumes.c:4018 [inline]
    RIP: 0010:__btrfs_balance fs/btrfs/volumes.c:4172 [inline]
    RIP: 0010:btrfs_balance+0x2024/0x42b0 fs/btrfs/volumes.c:4604

[CAUSE]
The crash occurs because __btrfs_balance() iterates the on-disk chunk
tree, finds the orphaned chunk, calls chunk_usage_filter() (or
chunk_usage_range_filter()), which queries the in-memory block group
cache via btrfs_lookup_block_group().  Since no block group was ever
inserted for this chunk, the lookup returns NULL, and the subsequent
dereference of cache->used crashes.

check_chunk_block_group_mappings() uses btrfs_find_chunk_map() to
iterate the in-memory chunk map (fs_info->mapping_tree):

  map = btrfs_find_chunk_map(fs_info, start, 1);

With @start = 0 and @length = 1, btrfs_find_chunk_map() looks for a
chunk map that *contains* the logical address 0. If no chunk contains
logical address 0, btrfs_find_chunk_map(fs_info, 0, 1) returns NULL
immediately and the loop breaks after the very first iteration,
having checked zero chunks. The entire verification function is therefore
a no-op, and the corrupted image passes the mount-time check undetected.

[FIX]
Replace the btrfs_find_chunk_map() based loop with a direct in-order
walk of fs_info->mapping_tree using rb_first_cached() + rb_next().
This guarantees that every chunk map in the tree is visited regardless
of the logical addresses involved.

No lock is taken around the traversal. This function is called during
mount from btrfs_read_block_groups(), which is invoked from open_ctree()
before any background threads (cleaner, transaction kthread, etc.) are
started. There are therefore no concurrent writers that could modify
mapping_tree at this point. An analogous lockless direct traversal of
mapping_tree already exists in fill_dummy_bgs() in the same file.

Since we walk the rb-tree directly via rb_entry() without going through
btrfs_find_chunk_map(), no reference is taken on each map entry, so the
btrfs_free_chunk_map() calls are also removed.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record: Subsystem is `btrfs`; action verb is `fix`; claimed intent is to
make `check_chunk_block_group_mappings()` actually visit all chunk maps.

Record: Tags found in the committed version: `Signed-off-by: ZhengYuan
Huang <gality369@gmail.com>`, `Reviewed-by: David Sterba
<dsterba@suse.com>`, `Signed-off-by: David Sterba <dsterba@suse.com>`.
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable@vger.kernel.org` tag was present.

Record: The commit describes a real mount-time corruption validation
bug: a chunk can exist in the chunk tree while the matching block group
item is missing from the extent tree. Because the verifier may check
zero chunks, the corrupted filesystem can mount, and later `btrfs
balance -dusage=...` can hit a NULL dereference in
`chunk_usage_filter()` / `chunk_usage_range_filter()`.

Record: This is not hidden cleanup. It is an explicit NULL-deref /
corruption-detection fix.

## Phase 2: Diff Analysis
Record: One file changed: `fs/btrfs/block-group.c`, 8 insertions and 15
deletions in the committed object. Modified function:
`check_chunk_block_group_mappings()`. Scope: single-file surgical fix.

Record: Before, the function started at logical address 0 and repeatedly
called `btrfs_find_chunk_map(fs_info, start, 1)`. If no chunk
intersected `[0,1)`, the first lookup returned NULL and the loop exited
without checking any chunk. After, it walks `fs_info->mapping_tree`
directly with `rb_first_cached()` and `rb_next()`.

Record: Bug category is logic/correctness with memory-safety
consequence. The broken verifier allows filesystem corruption through
mount; later balance can dereference a NULL block group pointer.

Record: Fix quality is good: small, direct, reviewed by the btrfs
maintainer, and it removes `btrfs_free_chunk_map()` calls because direct
`rb_entry()` traversal does not acquire chunk-map references. Regression
risk is low; the main concern is lockless traversal, but code and commit
context verify this runs during mount before cleaner/transaction
kthreads start.

## Phase 3: Git History Investigation
Record: `git blame` on the pre-fix function shows the verifier loop
originated from `4358d9635a16` (`btrfs: migrate the block group
read/creation code`), first contained in `v5.4-rc1`. Later chunk-map
conversion came from `7dc66abb5a47` in `v6.8-rc1`.

Record: No `Fixes:` tag is present, so there was no Fixes target to
follow.

Record: Recent `fs/btrfs/block-group.c` history shows normal btrfs
churn, but no prior fix for `check_chunk_block_group_mappings()` except
this commit. `git log --grep=check_chunk_block_group_mappings
origin/master` found only `fc51cba3ebae`.

Record: Author history in `fs/btrfs` shows ZhengYuan Huang has other
btrfs fixes; the patch was reviewed and committed by David Sterba, who
is listed in `MAINTAINERS` as a btrfs maintainer.

Record: The commit was submitted as patch 4/4, but the final mainline
history contains this verifier fix independently. The earlier balance
hardening patches were not found in `origin/master`; this patch still
has standalone value because it prevents the corrupted state from
passing mount.

## Phase 4: Mailing List And External Research
Record: `b4 dig -c fc51cba3ebae...` found the original lore submission:
`https://patch.msgid.link/20260325004339.2323838-5-gality369@gmail.com`.

Record: `b4 dig -a` found v2 and v3 series. v3 is the committed/latest
revision found by `b4`.

Record: `b4 dig -w` showed the patch was sent to David Sterba, Chris
Mason, Ilya Dryomov, `linux-btrfs`, and `linux-kernel`.

Record: Direct `WebFetch` of lore was blocked by Anubis, so I used `b4`
mbox content and Patchew. The v3 mbox includes David Sterba saying he
added the fixes to `for-next`; the committed patch has his `Reviewed-
by`.

Record: Patchew v2 discussion records David Sterba saying block group
lookup checks make sense in general, and the author clarified the bug is
reproducible with a crafted filesystem image and normal syscalls, not
only fuzzing. No NAKs were found. No stable-specific discussion was
found by web search.

## Phase 5: Code Semantic Analysis
Record: Modified function: `check_chunk_block_group_mappings()`.

Record: Caller trace verified: `open_ctree()` calls
`btrfs_read_block_groups()`, which calls
`check_chunk_block_group_mappings()`. In `disk-io.c`,
`btrfs_read_block_groups()` occurs before the cleaner and transaction
kthreads are started.

Record: Crash path verified: `BTRFS_IOC_BALANCE_V2` reaches
`btrfs_ioctl_balance()`, then `btrfs_balance()`, `__btrfs_balance()`,
`should_balance_chunk()`, then usage filters. Current code dereferences
`cache->used` immediately after `btrfs_lookup_block_group()`.

Record: Key callees: `rb_first_cached()`, `rb_next()`, `rb_entry()`,
`btrfs_lookup_block_group()`, `btrfs_put_block_group()`, and error
reporting via `btrfs_err()`.

Record: Similar safe direct mapping-tree traversal already exists in
`fill_dummy_bgs()` in the same file, and other mapping-tree traversal
code exists elsewhere with appropriate locking/context.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Record: Buggy code exists in stable branches. `stable/linux-6.8.y`
through `stable/linux-6.19.y` contain the `btrfs_find_chunk_map(fs_info,
start, 1)` pattern. `stable/linux-5.4.y`, `5.10.y`, `5.15.y`, `6.1.y`,
`6.6.y`, and `6.7.y` contain the older analogous
`lookup_extent_mapping(map_tree, start, 1)` pattern.

Record: The upstream patch applies cleanly to the current `7.0` tree
with `git apply --check`.

Record: Older pre-`6.8` stable trees likely need an adjusted backport
because they use `extent_map` / `map_lookup` rather than `struct
btrfs_chunk_map`. The bug mechanism is still verified there by the
strict intersection semantics in `extent_map.c`.

Record: I found no related stable branch commit already fixing this
issue by subject/grep.

## Phase 7: Subsystem And Maintainer Context
Record: Subsystem is btrfs filesystem code under `fs/btrfs/`.
Criticality is IMPORTANT to CORE-for-users-of-btrfs because filesystem
corruption handling and kernel crashes are involved.

Record: Subsystem is actively maintained; recent `origin/master --
fs/btrfs` history shows many btrfs fixes. David Sterba is listed as a
btrfs maintainer and reviewed/committed this fix.

## Phase 8: Impact And Risk Assessment
Record: Affected users are btrfs users with a corrupted or crafted
filesystem image containing a chunk without a corresponding block group
item.

Record: Trigger is mount of that corrupted image followed by balance
with usage filters for the crash path; the patched behavior rejects the
inconsistency at mount time with `-EUCLEAN`. Patchew discussion says it
is reproducible with crafted filesystem image plus normal syscalls.
Balance ioctl requires `CAP_SYS_ADMIN`, verified in
`btrfs_ioctl_balance()`.

Record: Failure mode is HIGH/CRITICAL: KASAN NULL pointer dereference in
filesystem balance code, i.e. kernel crash/oops risk, and the underlying
issue is missed filesystem corruption detection.

Record: Benefit is high: prevents corrupted btrfs images from mounting
silently and avoids a later NULL dereference. Risk is low for `6.8+`
style trees: one contained verifier loop change during mount. Risk is
medium-low for older trees only because the backport needs translation
to the older extent-map data structure.

## Phase 9: Final Synthesis
Record: Evidence for backporting: real NULL-deref crash path, crafted-
image reproducibility, filesystem corruption detection failure, small
one-function fix, maintainer review, code present across stable trees,
and clean apply to current `7.0` tree.

Record: Evidence against backporting: no `Fixes:`/`Cc: stable` tag;
older stable trees need adjusted backports; the exact patch is not
directly applicable to pre-`6.8` extent-map code. These do not outweigh
the bug severity.

Record: Stable rules checklist: obviously correct and reviewed: yes;
fixes real user-visible bug: yes; important issue: yes, NULL deref and
missed corruption detection; small and contained: yes; no new
feature/API: yes; stable application: clean for current `7.0`, likely
straightforward for `6.8+`, adjusted backport needed for older trees.

Record: Exception category: none. This is a normal bug fix, not a device
ID, quirk, DT, build, or documentation-only patch.

## Verification
- [Phase 1] `git show --format=fuller --stat fc51cba3ebae...`: confirmed
  commit message, tags, author, reviewer, and one-file diff.
- [Phase 2] `git show --no-ext-diff fc51cba3ebae... -- fs/btrfs/block-
  group.c`: confirmed the loop replacement and removal of
  `btrfs_free_chunk_map()` calls.
- [Phase 3] `git blame -L ... fc51cba3ebae^ -- fs/btrfs/block-group.c`:
  identified `4358d9635a16` as the original verifier-loop source and
  `7dc66abb5a47` as later chunk-map conversion.
- [Phase 3] `git show 4358d9635a16` and `git describe --contains`:
  confirmed first appearance around `v5.4-rc1`.
- [Phase 3] `git log --grep=check_chunk_block_group_mappings
  origin/master`: found no prior related fix except this commit.
- [Phase 4] `b4 dig -c`, `-a`, `-w`, and `-m`: found v3 lore submission,
  v2/v3 revision history, recipients, and maintainer response.
- [Phase 4] Patchew v2 fetch: confirmed David Sterba review discussion
  and author statement that crafted images plus normal syscalls
  reproduce the issue.
- [Phase 5] `rg`/file reads in `disk-io.c`, `block-group.c`,
  `volumes.c`, and `ioctl.c`: verified mount-time call path and balance
  NULL-deref path.
- [Phase 6] `git grep` on stable branches: confirmed the buggy lookup
  pattern in `6.8.y` through `6.19.y` and analogous extent-map pattern
  in older stable branches.
- [Phase 6] `git apply --check` against the current tree: confirmed
  clean application to the current `7.0` checkout.
- [Phase 7] `MAINTAINERS`: confirmed David Sterba as btrfs maintainer.
- UNVERIFIED: I did not run a runtime reproducer or mount a crafted
  btrfs image.
- UNVERIFIED: I did not prove exact clean application to every older
  stable branch; pre-`6.8` trees require an adjusted extent-map
  backport.

The technical merit is strong: this is a small, reviewed btrfs
corruption-detection fix that prevents a real NULL-deref crash path and
should be backported, with adjusted backports for older extent-map based
stable trees.

**YES**

 fs/btrfs/block-group.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c0d17a369bda5..acb55b6f1e550 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2374,29 +2374,25 @@ static struct btrfs_block_group *btrfs_create_block_group(
  */
 static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 {
-	u64 start = 0;
+	struct rb_node *node;
 	int ret = 0;
 
-	while (1) {
+	/*
+	 * This is called during mount from btrfs_read_block_groups(), before
+	 * any background threads are started, so no concurrent writers can
+	 * modify the mapping_tree. No lock is needed here.
+	 */
+	for (node = rb_first_cached(&fs_info->mapping_tree); node; node = rb_next(node)) {
 		struct btrfs_chunk_map *map;
 		struct btrfs_block_group *bg;
 
-		/*
-		 * btrfs_find_chunk_map() will return the first chunk map
-		 * intersecting the range, so setting @length to 1 is enough to
-		 * get the first chunk.
-		 */
-		map = btrfs_find_chunk_map(fs_info, start, 1);
-		if (!map)
-			break;
-
+		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
 		bg = btrfs_lookup_block_group(fs_info, map->start);
 		if (unlikely(!bg)) {
 			btrfs_err(fs_info,
 	"chunk start=%llu len=%llu doesn't have corresponding block group",
 				     map->start, map->chunk_len);
 			ret = -EUCLEAN;
-			btrfs_free_chunk_map(map);
 			break;
 		}
 		if (unlikely(bg->start != map->start || bg->length != map->chunk_len ||
@@ -2409,12 +2405,9 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 				bg->start, bg->length,
 				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
 			ret = -EUCLEAN;
-			btrfs_free_chunk_map(map);
 			btrfs_put_block_group(bg);
 			break;
 		}
-		start = map->start + map->chunk_len;
-		btrfs_free_chunk_map(map);
 		btrfs_put_block_group(bg);
 	}
 	return ret;
-- 
2.53.0

