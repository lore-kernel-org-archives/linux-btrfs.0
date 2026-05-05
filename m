Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D85133D4E5;
	Tue,  5 May 2026 09:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974792; cv=none; b=K3gGgm0/EQJt38msTT8QfIi4VVeIsGNm0JpByqJuZcCussqBsbSyoinRh9bfPW6ICfWzY7DioLvtNvImT/yfUsi8dPODPxE4Zt5pbMYtIQ8BknLY8YkbkntEXMKW3s5KW9rSDNVaf4QKqWfaUtng8lB1Mu/k9126tSuPCrxsejo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974792; c=relaxed/simple;
	bh=npXGXSElGv0/CCSPcjyQqDyVD32Q27Z642847nGKpI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pe/E2tQkj252cA5RMCwPvFmTtqMLvWxRuhv4aPo57r0m4ElwDGW2Ln4voPrmMu2trZsV0HHsB+vbFUErgix7yN0go96NyTbdd9Dzj2vATfNhkJfGOWmtnuddvf1Sw2lfdE7yjH7BdLmOkiU5BjZDcKkjzZGr5gMie037TDeqpHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b9ExcSij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b9ExcSij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063A5C2BCB4;
	Tue,  5 May 2026 09:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974792;
	bh=npXGXSElGv0/CCSPcjyQqDyVD32Q27Z642847nGKpI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9ExcSijeMNXtZ2e0X2Hx/55hJqFHD8TyJC+9Zg1+YXwkNnHYd+kGRXQHrlyVX3Vr
	 63qtNHIx84ai9yimEFWHSdp0KGOpYAzyPqqfXwt13D27rX7PjrJlGNoE5ucLSWsYq2
	 g2VH1uvRwqDnXumSS/IodWLmPH5NY672QwxnaN40KaEcbVCjz764MsvBwik/iYHT5J
	 ppLPNPZxLEjh47wxgFDg70cB3GmwwPvOLXHDXrnFazPFIsCEoS9/JTm0UCNLAFGyaz
	 i/9A/LPGEaingUYqodbFqKbHYoYc5q6v6aUhd+gCOxQAcmoOpaiIHBujdyrySMHjkS
	 A+f1E4CKkDEsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: robbieko <robbieko@synology.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] btrfs: copy devid in btrfs_partially_delete_raid_extent()
Date: Tue,  5 May 2026 05:51:42 -0400
Message-ID: <20260505095149.512052-26-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: robbieko <robbieko@synology.com>

[ Upstream commit 513f8a52eed880ea525dbb139b2127bd9bb793f1 ]

When btrfs_partially_delete_raid_extent() rebuilds a truncated/shifted
stripe extent into newitem, the loop copies the physical address for
each stride but forgets to copy the devid. The resulting item written
back to the stripe tree has zeroed-out devids, corrupting the stripe
mapping.

Fix this by reading the devid with btrfs_raid_stride_devid() and
writing it into the new item with btrfs_set_stack_raid_stride_devid()
before copying the physical address.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: robbieko <robbieko@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem `btrfs`; action verb `copy`; claimed intent
is to preserve `devid` when `btrfs_partially_delete_raid_extent()`
rebuilds a truncated or shifted RAID stripe extent.

Step 1.2 Record: tags present are `Reviewed-by: Johannes Thumshirn
<johannes.thumshirn@wdc.com>`, `Signed-off-by: robbieko
<robbieko@synology.com>`, `Reviewed-by: David Sterba
<dsterba@suse.com>`, `Signed-off-by: David Sterba <dsterba@suse.com>`.
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc:
stable@vger.kernel.org` tag was present. David Sterba is listed as a
Btrfs maintainer in `MAINTAINERS`.

Step 1.3 Record: the body says the function rebuilds a stripe extent
into `newitem`, copies each stride’s physical address, but forgets to
copy each stride’s device id. Because `newitem` is allocated with
`kzalloc()`, omitted devid fields become zero. The described failure
mode is corrupted stripe mapping. No explicit affected kernel version is
stated.

Step 1.4 Record: this is not hidden behind cleanup wording; it is a
direct correctness fix for persistent Btrfs RAID stripe tree metadata.

## Phase 2: Diff Analysis

Step 2.1 Record: one file changed, `fs/btrfs/raid-stripe-tree.c`, with 3
insertions in `btrfs_partially_delete_raid_extent()`. Scope is a single-
file surgical fix.

Step 2.2 Record: before, the copy loop populated only
`newitem->strides[i].physical`; after, it reads `devid` from the old
stride using `btrfs_raid_stride_devid()` and stores it in the stack item
with `btrfs_set_stack_raid_stride_devid()` before copying the physical
address. The affected path is partial deletion/truncation/shift of RAID
stripe extents.

Step 2.3 Record: bug category is filesystem metadata correctness/data
corruption. Mechanism: `kzalloc()` zeroes the rebuilt item, and the old
code only writes the physical address, leaving device ids as zero. Later
lookup code in `btrfs_get_raid_extent_offset()` searches for a stride
whose stored devid matches `stripe->dev->devid`; zeroed devids can fail
that match and return `-ENODATA`.

Step 2.4 Record: the fix is obviously local and correct: it copies the
missing field from the old item to the rebuilt item. Regression risk is
very low: it adds no new behavior, no locking, no API changes, and
preserves existing physical-address handling.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` on the pre-fix function showed the rebuild-
and-reinsert logic came from `dc14ba10781bd` and the partial-delete
function originated from `6aea95ee31889`. The specific zeroed-devid bug
was introduced by `dc14ba10781bd`, first contained in `v6.14-rc1`.

Step 3.2 Record: no `Fixes:` tag exists. I manually inspected
`dc14ba10781bd`; it replaced in-place key modification with allocation
of a new item and copied only physical addresses, omitting devids. That
commit fixed a prior kernel BUG but introduced this missing-field copy.

Step 3.3 Record: recent file history shows this patch is part of a
cluster of RAID stripe tree deletion fixes: search boundary fixes,
`btrfs_previous_item()` min-objectid fix, ASSERT-to-error handling,
stale leaf pointer handling, and return-value checking. This commit is
standalone; it does not depend on later patches, though the related
patches may be independently worth stable review.

Step 3.4 Record: author `robbieko` has multiple related Btrfs fixes in
the same file around the same time. Committer/reviewer David Sterba is a
Btrfs maintainer per `MAINTAINERS`.

Step 3.5 Record: no prerequisite commit beyond the buggy rebuild-and-
reinsert implementation was identified for affected trees. The patch
applies cleanly to the current `v7.0.3` stable worktree with `git apply
--check`.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c 513f8a52eed88` found the original submission
at `https://patch.msgid.link/20260413065249.2320122-2-
robbieko@synology.com`. `b4 dig -a` showed only v1. WebFetch of lore was
blocked by Anubis, so I used `b4 dig -m` and read the mbox locally. The
thread includes David Sterba saying the series was added to for-next. No
NAK was found in the fetched thread.

Step 4.2 Record: `b4 dig -w` showed original recipients were `robbieko`
and `linux-btrfs@vger.kernel.org`. The mbox showed Johannes Thumshirn
replied and asked for tests for the series conditions; the committed
patch later carries his `Reviewed-by`.

Step 4.3 Record: no external bug report, syzbot report, or bugzilla link
was present. The cover letter and patch text both describe corrupted
stripe mappings.

Step 4.4 Record: this is patch 1/6 in a series titled `btrfs: fix
multiple bugs in raid-stripe-tree deletion path`. The other five patches
address separate bugs in the same deletion path. Patch 1 is not a
preparatory change; it fixes a complete missing-field copy on its own.

Step 4.5 Record: WebFetch search of lore stable was blocked by Anubis.
Local stable branch inspection found no equivalent devid-copy fix in
`stable/linux-7.0.y`.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified function is
`btrfs_partially_delete_raid_extent()`.

Step 5.2 Record: callers are the three partial-deletion cases in
`btrfs_delete_raid_extent()`: hole punch splitting a stripe extent,
front truncation, and tail truncation. `btrfs_delete_raid_extent()` is
called from Btrfs extent free accounting for data extents.

Step 5.3 Record: relevant callees are `kzalloc()`,
`btrfs_raid_stride_devid()`, `btrfs_set_stack_raid_stride_devid()`,
`btrfs_raid_stride_physical()`,
`btrfs_set_stack_raid_stride_physical()`, `btrfs_del_item()`, and
`btrfs_insert_item()`.

Step 5.4 Record: reachability is through Btrfs data extent
deletion/freeing and transaction paths. Lookup impact is through read
mapping: `btrfs_map_block()` calls `set_io_stripe()`, which calls
`btrfs_get_raid_extent_offset()` for reads when RAID stripe tree updates
are needed. If the zeroed devid does not match the real device id,
lookup returns `-ENODATA`.

Step 5.5 Record: similar correct pattern exists in
`btrfs_insert_one_raid_extent()`, which stores both devid and physical
address for each stride. The broken partial-delete rebuild copied only
physical address.

## Phase 6: Cross-Referencing And Stable Tree Analysis

Step 6.1 Record: latest checked tags show `v6.12.85` has the file but
not the affected partial-delete rebuild code; `v6.15.11`, `v6.16.12`,
`v6.17.13`, `v6.18.26`, `v6.19.14`, and `v7.0.3` contain the buggy loop
with physical copy but no devid copy. `v6.6` has no `fs/btrfs/raid-
stripe-tree.c`.

Step 6.2 Record: expected backport difficulty is low for affected trees.
The patch applies cleanly to current `v7.0.3`; older affected trees
before the `AUTO_KFREE` cleanup still have the same loop and should need
at most context adjustment.

Step 6.3 Record: no equivalent devid-copy fix was found in
`stable/linux-7.0.y`; current stable code still lacks
`btrfs_set_stack_raid_stride_devid(&newitem->strides[i], devid)`.

## Phase 7: Subsystem And Maintainer Context

Step 7.1 Record: subsystem is Btrfs filesystem code under `fs/btrfs`.
Criticality is IMPORTANT: it is filesystem metadata and I/O mapping, but
gated to filesystems using the RAID stripe tree incompat feature.

Step 7.2 Record: subsystem activity is high; file history shows many
recent RAID stripe tree deletion fixes. This does not reduce stable
suitability because the affected buggy code is already present in
several stable tags.

## Phase 8: Impact And Risk Assessment

Step 8.1 Record: affected users are Btrfs users with `RAID_STRIPE_TREE`
enabled and data profiles supported by
`btrfs_need_stripe_tree_update()`.

Step 8.2 Record: trigger is partial deletion of RAID stripe extents,
such as data extent freeing/truncation/hole-related deletion paths.
User-triggerability depends on having an affected Btrfs RAID stripe tree
filesystem; the exact unprivileged trigger was not separately reproduced
here.

Step 8.3 Record: failure mode is corrupted RAID stripe mapping metadata
with zeroed devids. Verified read-side code relies on devid matching and
returns `-ENODATA` when no matching devid is found. Severity is HIGH to
CRITICAL for affected filesystems because it can persistently break
logical-to-physical mapping.

Step 8.4 Record: benefit is high for affected Btrfs RST users because it
prevents persistent mapping corruption. Risk is very low because the
change is 3 lines, local, and copies an existing field without changing
control flow.

## Phase 9: Final Synthesis

Step 9.1 Record: evidence for backporting: real filesystem metadata
corruption, tiny surgical fix, reviewed by Btrfs developers including
maintainer David Sterba, affects current stable trees with the buggy
rebuild loop, and applies cleanly to `v7.0.3`. Evidence against: affects
only the RAID stripe tree feature, and no `Tested-by` or external bug
report was present. Unresolved: I did not runtime-test a reproducer, and
lore WebFetch was blocked, though b4 retrieved the thread mbox.

Step 9.2 Stable rules checklist:
1. Obviously correct and tested: obviously correct by inspection; no
   explicit `Tested-by`.
2. Fixes a real bug: yes, missing copied devid causes zeroed devids in
   rebuilt stripe items.
3. Important issue: yes, filesystem mapping corruption.
4. Small and contained: yes, 3 inserted lines in one function.
5. No new features or APIs: yes.
6. Can apply to stable trees: yes for `v7.0.3`; likely clean or minor
   context for affected `v6.15+` stable trees.

Step 9.3 Record: no special exception category is needed; this is a
normal filesystem corruption fix.

Step 9.4 Decision: backport to stable trees that contain the rebuild-
and-reinsert version of `btrfs_partially_delete_raid_extent()` without
the devid copy, notably checked affected tags `v6.15.11` through
`v7.0.3`. Do not apply to trees where the affected code is absent, such
as checked `v6.12.85` and `v6.6`.

## Verification

- [Phase 1] Parsed commit `513f8a52eed88` with `git show
  --pretty=fuller`; confirmed subject, body, tags, and 3-line diff.
- [Phase 1] Checked `MAINTAINERS` with `rg`; confirmed David Sterba is a
  Btrfs maintainer.
- [Phase 2] Read `fs/btrfs/raid-stripe-tree.c`; confirmed `kzalloc()`
  allocation, old physical-only copy, and read-side devid matching.
- [Phase 3] Ran `git blame 513f8a52eed88^` on the changed function;
  identified relevant history from `6aea95ee31889`, `dc14ba10781bd`, and
  cleanup commits.
- [Phase 3] Ran `git show dc14ba10781bd`; confirmed the buggy new-item
  rebuild was introduced there and first appears in `v6.14-rc1`.
- [Phase 3] Ran recent file and author logs; confirmed related same-file
  fixes and that this patch is standalone.
- [Phase 4] Ran `b4 dig -c`, `-a`, `-w`, and `-m`; found the lore
  thread, single v1, original recipients, series context, and maintainer
  acceptance into for-next.
- [Phase 4] WebFetch lore and stable search were blocked by Anubis; b4
  mbox provided the usable mailing-list content.
- [Phase 5] Used `rg` and file reads to trace callers:
  `btrfs_delete_raid_extent()` from extent free accounting, and read
  mapping through `btrfs_map_block()`/`set_io_stripe()`/`btrfs_get_raid_
  extent_offset()`.
- [Phase 6] Checked stable tags with `git show <tag>:fs/btrfs/raid-
  stripe-tree.c`; confirmed affected code in `v6.15.11`, `v6.16.12`,
  `v6.17.13`, `v6.18.26`, `v6.19.14`, and `v7.0.3`, absent affected code
  in `v6.12.85`, and no file in `v6.6`.
- [Phase 6] Ran `git apply --check` for the upstream patch against
  current `v7.0.3`; it applies cleanly.
- [Phase 8] Verified failure mechanism in code: zeroed devids fail the
  `devid != stripe->dev->devid` match and lead to `-ENODATA`.

**YES**

 fs/btrfs/raid-stripe-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index a2e9ac2d97988..5909ad35a1b07 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -45,8 +45,11 @@ static int btrfs_partially_delete_raid_extent(struct btrfs_trans_handle *trans,
 
 	for (int i = 0; i < btrfs_num_raid_stripes(item_size); i++) {
 		struct btrfs_raid_stride *stride = &extent->strides[i];
+		u64 devid;
 		u64 phys;
 
+		devid = btrfs_raid_stride_devid(leaf, stride);
+		btrfs_set_stack_raid_stride_devid(&newitem->strides[i], devid);
 		phys = btrfs_raid_stride_physical(leaf, stride) + frontpad;
 		btrfs_set_stack_raid_stride_physical(&newitem->strides[i], phys);
 	}
-- 
2.53.0

