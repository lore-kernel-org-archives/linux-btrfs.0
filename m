Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEC43B5849;
	Tue, 17 Mar 2026 11:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747187; cv=none; b=k5rUbr1UGIaFKQ5jHDtdPqHcjsUNcep7LdhCTVfU4NuyBTx8I3075/QR+R+7AYg9XHrlBjXfZ6CvmPb/c/douR8WUt61IUSUYQNWiKAj1Rm9idzJ3mV4GzupvUpwqomXJLqtmNULtxz4tF8+k4lF0+XRak33e1+VjiadVJUXZuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747187; c=relaxed/simple;
	bh=vw9xWNLMb5E1H4DBUbQ9NSTgmyJekYYFisF6wqQJzHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN6XNVXZlziDmkD5rT5A2H3bZZghQM7o2Zit9Qkk+lJXdcVTyhtdB2gESRsHQIsvbHw/KGVgKp0mj9ZWkA884VxrIAYjrT9PzG9JpxvNt0jOpVrvvHeepNmjpWrq1CIhmchp/xBhtkq9F2eyLrbIxrzFe2j0Q/Iu1IegMCzqqvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izmHUE2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izmHUE2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5A8C2BCB0;
	Tue, 17 Mar 2026 11:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747187;
	bh=vw9xWNLMb5E1H4DBUbQ9NSTgmyJekYYFisF6wqQJzHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izmHUE2GATih2txoBzwkfUy8qDXqRrnVnCEeZTPUPoRxzHNbNci48K6ZHj+F2pEhr
	 CCjYnj6XX2ufCjontmLMdig2TPlj0Bavg6Ci8WyFHht1QhZI/OANhSiRNtinRSV7fc
	 eTv7rWxCcMk470nN+Vih+4IWlW8qw1EzgVaw5tLj5vKVQ1Vy1YCxK/mSSK3tvOI65o
	 nW/D/K94+Cqq5hiVISyKsLUkJdY30AYMUADAPYWnRPt5ZC9b3iWoJCOniYywcoG5o/
	 5PxBLzGnikFVyBakOR0CoOWlEiUARCQ4tzEw4CPX7kYKwt1WSnbwUnafzimkFzj1zc
	 vz9r+b0Yrz5MQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] btrfs: set BTRFS_ROOT_ORPHAN_CLEANUP during subvol create
Date: Tue, 17 Mar 2026 07:32:44 -0400
Message-ID: <20260317113249.117771-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Transfer-Encoding: 8bit

From: Boris Burkov <boris@bur.io>

[ Upstream commit 5131fa077f9bb386a1b901bf5b247041f0ec8f80 ]

We have recently observed a number of subvolumes with broken dentries.
ls-ing the parent dir looks like:

drwxrwxrwt 1 root root 16 Jan 23 16:49 .
drwxr-xr-x 1 root root 24 Jan 23 16:48 ..
d????????? ? ?    ?     ?            ? broken_subvol

and similarly stat-ing the file fails.

In this state, deleting the subvol fails with ENOENT, but attempting to
create a new file or subvol over it errors out with EEXIST and even
aborts the fs. Which leaves us a bit stuck.

dmesg contains a single notable error message reading:
"could not do orphan cleanup -2"

2 is ENOENT and the error comes from the failure handling path of
btrfs_orphan_cleanup(), with the stack leading back up to
btrfs_lookup().

btrfs_lookup
btrfs_lookup_dentry
btrfs_orphan_cleanup // prints that message and returns -ENOENT

After some detailed inspection of the internal state, it became clear
that:
- there are no orphan items for the subvol
- the subvol is otherwise healthy looking, it is not half-deleted or
  anything, there is no drop progress, etc.
- the subvol was created a while ago and does the meaningful first
  btrfs_orphan_cleanup() call that sets BTRFS_ROOT_ORPHAN_CLEANUP much
  later.
- after btrfs_orphan_cleanup() fails, btrfs_lookup_dentry() returns -ENOENT,
  which results in a negative dentry for the subvolume via
  d_splice_alias(NULL, dentry), leading to the observed behavior. The
  bug can be mitigated by dropping the dentry cache, at which point we
  can successfully delete the subvolume if we want.

i.e.,
btrfs_lookup()
  btrfs_lookup_dentry()
    if (!sb_rdonly(inode->vfs_inode)->vfs_inode)
    btrfs_orphan_cleanup(sub_root)
      test_and_set_bit(BTRFS_ROOT_ORPHAN_CLEANUP)
      btrfs_search_slot() // finds orphan item for inode N
      ...
      prints "could not do orphan cleanup -2"
  if (inode == ERR_PTR(-ENOENT))
    inode = NULL;
  return d_splice_alias(NULL, dentry) // NEGATIVE DENTRY for valid subvolume

btrfs_orphan_cleanup() does test_and_set_bit(BTRFS_ROOT_ORPHAN_CLEANUP)
on the root when it runs, so it cannot run more than once on a given
root, so something else must run concurrently. However, the obvious
routes to deleting an orphan when nlinks goes to 0 should not be able to
run without first doing a lookup into the subvolume, which should run
btrfs_orphan_cleanup() and set the bit.

The final important observation is that create_subvol() calls
d_instantiate_new() but does not set BTRFS_ROOT_ORPHAN_CLEANUP, so if
the dentry cache gets dropped, the next lookup into the subvolume will
make a real call into btrfs_orphan_cleanup() for the first time. This
opens up the possibility of concurrently deleting the inode/orphan items
but most typical evict() paths will be holding a reference on the parent
dentry (child dentry holds parent->d_lockref.count via dget in
d_alloc(), released in __dentry_kill()) and prevent the parent from
being removed from the dentry cache.

The one exception is delayed iputs. Ordered extent creation calls
igrab() on the inode. If the file is unlinked and closed while those
refs are held, iput() in __dentry_kill() decrements i_count but does
not trigger eviction (i_count > 0). The child dentry is freed and the
subvol dentry's d_lockref.count drops to 0, making it evictable while
the inode is still alive.

Since there are two races (the race between writeback and unlink and
the race between lookup and delayed iputs), and there are too many moving
parts, the following three diagrams show the complete picture.
(Only the second and third are races)

Phase 1:
Create Subvol in dentry cache without BTRFS_ROOT_ORPHAN_CLEANUP set

btrfs_mksubvol()
  lookup_one_len()
    __lookup_slow()
      d_alloc_parallel()
        __d_alloc() // d_lockref.count = 1
  create_subvol(dentry)
    // doesn't touch the bit..
    d_instantiate_new(dentry, inode) // dentry in cache with d_lockref.count == 1

Phase 2:
Create a delayed iput for a file in the subvol but leave the subvol in
state where its dentry can be evicted (d_lockref.count == 0)

T1 (task)                    T2 (writeback)                   T3 (OE workqueue)

write() // dirty pages
                              btrfs_writepages()
                                btrfs_run_delalloc_range()
                                  cow_file_range()
                                    btrfs_alloc_ordered_extent()
                                      igrab() // i_count: 1 -> 2
btrfs_unlink_inode()
  btrfs_orphan_add()
close()
  __fput()
    dput()
      finish_dput()
        __dentry_kill()
          dentry_unlink_inode()
            iput() // 2 -> 1
          --parent->d_lockref.count // 1 -> 0; evictable
                                                                finish_ordered_fn()
                                                                  btrfs_finish_ordered_io()
                                                                    btrfs_put_ordered_extent()
                                                                      btrfs_add_delayed_iput()

Phase 3:
Once the delayed iput is pending and the subvol dentry is evictable,
the shrinker can free it, causing the next lookup to go through
btrfs_lookup() and call btrfs_orphan_cleanup() for the first time.
If the cleaner kthread processes the delayed iput concurrently, the
two race:

  T1 (shrinker)              T2 (cleaner kthread)                          T3 (lookup)

  super_cache_scan()
    prune_dcache_sb()
      __dentry_kill()
      // subvol dentry freed
                              btrfs_run_delayed_iputs()
                                iput()  // i_count -> 0
                                  evict()  // sets I_FREEING
                                    btrfs_evict_inode()
                                      // truncation loop
                                                                            btrfs_lookup()
                                                                              btrfs_lookup_dentry()
                                                                                btrfs_orphan_cleanup()
                                                                                  // first call (bit never set)
                                                                                  btrfs_iget()
                                                                                    // blocks on I_FREEING

                                      btrfs_orphan_del()
                                      // inode freed
                                                                                    // returns -ENOENT
                                                                                  btrfs_del_orphan_item()
                                                                                    // -ENOENT
                                                                                // "could not do orphan cleanup -2"
                                                                            d_splice_alias(NULL, dentry)
                                                                            // negative dentry for valid subvol

The most straightforward fix is to ensure the invariant that a dentry
for a subvolume can exist if and only if that subvolume has
BTRFS_ROOT_ORPHAN_CLEANUP set on its root (and is known to have no
orphans or ran btrfs_orphan_cleanup()).

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information I need to make a thorough assessment. Let
me compile my analysis.

## Analysis

### 1. Commit Message Analysis

The commit describes a **real-world bug** with significant user impact:
- Subvolumes become inaccessible ("broken dentries") showing `d?????????
  ? ? ? ? ? broken_subvol`
- Cannot delete the broken subvolume (ENOENT) or create anything over it
  (EEXIST, which **aborts the filesystem**)
- The error message "could not do orphan cleanup -2" is observed in
  dmesg
- The author provides an extremely detailed 3-phase race analysis with
  exact code paths

### 2. Code Change Analysis

The fix is a **single `set_bit()` call** added before
`d_instantiate_new()`:

```c
set_bit(BTRFS_ROOT_ORPHAN_CLEANUP, &new_root->state);
```

**Bug mechanism:** `create_subvol()` creates a new subvolume and calls
`d_instantiate_new()` but never sets `BTRFS_ROOT_ORPHAN_CLEANUP`. This
means the first lookup into the subvolume (if the dentry cache gets
invalidated) will call `btrfs_orphan_cleanup()` for real. A race between
this cleanup and delayed iputs can cause `btrfs_orphan_cleanup()` to
fail with `-ENOENT`, which cascades through `btrfs_lookup_dentry()`
creating a negative dentry for a valid subvolume.

**Comparison with snapshot creation:** The `create_snapshot()` path at
`fs/btrfs/ioctl.c:787` explicitly calls
`btrfs_orphan_cleanup(pending_snapshot->snap)` (which sets the bit
internally), so snapshots don't have this issue. Subvolume creation was
missing this protection.

**Why the fix is correct:** A newly created subvolume has zero orphan
items, so orphan cleanup is unnecessary. Setting the bit early tells
future lookups "cleanup already done" which is semantically correct
since there's nothing to clean up. This matches the invariant: a dentry
exists for a subvolume iff that subvolume has
`BTRFS_ROOT_ORPHAN_CLEANUP` set.

### 3. Classification

This is a **race condition fix** that prevents:
- Filesystem corruption (broken dentries for valid subvolumes)
- Filesystem abort (EEXIST when trying to create over the broken dentry)
- Data unavailability (unable to access or delete the subvolume)

### 4. Scope and Risk Assessment

- **Lines changed:** 7 (1 code line + 6 comment lines)
- **Files changed:** 1 (`fs/btrfs/ioctl.c`)
- **Risk:** Extremely low. Setting a single bit on a newly created root
  that has no orphans is completely safe. It's semantically correct and
  matches what `btrfs_orphan_cleanup()` would do anyway (set the bit and
  find nothing to clean).
- **Could it break something?** No. The bit only prevents redundant
  `btrfs_orphan_cleanup()` calls on a root that has no orphans.

### 5. User Impact

- **Severity:** HIGH - filesystem abort, data unavailability
- **Who is affected:** Any btrfs user creating subvolumes, particularly
  with concurrent writes and dentry cache pressure
- **Reproducer:** The race requires specific timing (delayed iputs +
  dentry cache eviction + concurrent lookup) but has been "observed a
  number of" times in the wild
- **Reviewed-by:** Filipe Manana (prominent btrfs developer/reviewer)

### 6. Stable Suitability

- **Obviously correct:** Yes - a new subvolume has no orphans, so
  marking it "cleaned" is correct
- **Fixes a real bug:** Yes - broken subvolume access, filesystem abort
- **Small and contained:** Yes - 1 line of actual code change in 1 file
- **No new features:** Correct - this just sets a state bit earlier
- **No new APIs:** Correct

### Verification

- Verified `BTRFS_ROOT_ORPHAN_CLEANUP` is defined at
  `fs/btrfs/ctree.h:143` as a bit in root state
- Verified `btrfs_orphan_cleanup()` at `fs/btrfs/inode.c:3649` uses
  `test_and_set_bit(BTRFS_ROOT_ORPHAN_CLEANUP)` as a guard - confirming
  the bit prevents re-execution
- Verified `btrfs_lookup_dentry()` at `fs/btrfs/inode.c:6040-6047` calls
  `btrfs_orphan_cleanup(sub_root)` on lookup and returns error if it
  fails (creating negative dentry via d_splice_alias)
- Verified `create_subvol()` at `fs/btrfs/ioctl.c:675` calls
  `d_instantiate_new()` without setting the bit (the bug)
- Verified `create_snapshot()` at `fs/btrfs/ioctl.c:787` does call
  `btrfs_orphan_cleanup()` (which sets the bit) before dentry lookup -
  confirming snapshots are already protected
- Verified the fix location at line 675 of ioctl.c is the correct place
  to add `set_bit()` (right before `d_instantiate_new`)
- Verified the bit is only set in one other place (`inode.c:3649` inside
  `btrfs_orphan_cleanup` itself)

This is a textbook stable backport candidate: a small, obviously
correct, well-reviewed fix for a real race condition that causes
filesystem abort and data unavailability. The fix is a single
`set_bit()` with no dependencies on other commits.

**YES**

 fs/btrfs/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c9284ce6c6e78..f7e063e8332a2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -672,6 +672,13 @@ static noinline int create_subvol(struct mnt_idmap *idmap,
 		goto out;
 	}
 
+	/*
+	 * Subvolumes have orphans cleaned on first dentry lookup. A new
+	 * subvolume cannot have any orphans, so we should set the bit before we
+	 * add the subvolume dentry to the dentry cache, so that it is in the
+	 * same state as a subvolume after first lookup.
+	 */
+	set_bit(BTRFS_ROOT_ORPHAN_CLEANUP, &new_root->state);
 	d_instantiate_new(dentry, new_inode_args.inode);
 	new_inode_args.inode = NULL;
 
-- 
2.51.0

