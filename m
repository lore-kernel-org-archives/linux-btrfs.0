Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93EA48097D;
	Mon, 31 Aug 2026 13:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183473; cv=none; b=N+lLTD4Zr6wd6dgEkaYQQmkAFmmKl/b//10Lvvb/ebd9wDG6/LKXM8Vyc2zxmwoiVq8lY6TdLtVuCIfW6GiQxdoxOOofiVA94MgY0Qbq3QgxwosJOJZCOMYQcvR7NLqjN5nXQ4YvkQslzlabCtPvh0sIshm2CGETRWx4vY8Rbns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183473; c=relaxed/simple;
	bh=CvxJHnhTWoAUtAg0rQR2WVJiXfeJU2g35eJV30BlNfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RsKOZJfllZQtjLp10b6fNXnLr+UoPUn1PBJfq9QTdon+/ZBE6KG9A7gpnsXrB6pmRntU6XL8BYZaPAExvkmdZDca5kValtGiGYtOB2XzxqV2Iv/HfAVsUQorFAyx10BW8dCqGc3NjCEs9RTcWlXjzy7n5W92yCF/bq2AL7U5aIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBp2TPw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBp2TPw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5B61F000E9;
	Mon, 31 Aug 2026 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183471;
	bh=NbkJLc5yKsQTfh8mXKJSXEgZlmQll3of1/16UaM16rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBp2TPw3ZQxBA+k1xFKkoa0IPkUBYQFczSyxjwYpFUmBH97r+57U1+Xpcjr43GJpw
	 naRuKlpTmgU0iud5U47Gn8WQ8U+hMp4h0oYZv1zhOsMlMg+N2FSC6x5vxGWRi0BD/B
	 laPSg+ERuJSlBN3HPh+T5wjJfYpULb9hUHR5yEbHT7k2dt/ZHpL1INKYxgiCHoP/pH
	 qv42QegFY2feF2eBq8TY0EyvaEAvwRzLHlLARNTqHV6krnIADi0nZs8eO7NwOJclES
	 /ILq1OSUomFZ75KFTlrul4bo7wQAC8eGk+u4/4C6bs6uL0fEvLOTUnSm1Dczz/7jsA
	 A/AMaRqfcBX9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] btrfs: tree-checker: validate INODE_REF's namelen
Date: Mon, 31 Aug 2026 09:22:24 -0400
Message-ID: <20260831133314.4125787-116-sashal@kernel.org>
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
Content-Transfer-Encoding: quoted-printable

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 3dc22abc21f5892406c09202fa2627196cc96967 ]

[BUG]
A crafted btrfs image can trigger the following crash:

  BUG: unable to handle page fault for address: ffffd1dc42884000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  CPU: 9 UID: 0 PID: 1034 Comm: poc Not tainted 7.1.0-rc4-custom+ #383 PREE=
MPT(full)  46af0a92938a63be7132e0dfd71e62327c51d5c2
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/20=
22
  RIP: 0010:memcpy+0xc/0x10
  Call Trace:
   <TASK>
   read_extent_buffer+0xe4/0x100 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f=
92a8f]
   btrfs_get_name+0x15e/0x1e0 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f92a=
8f]
   reconnect_path+0x165/0x390
   exportfs_decode_fh_raw+0x337/0x400
   ? drop_caches_sysctl_handler+0xb0/0xb0
   </TASK>
  ---[ end trace 0000000000000000 ]---
  RIP: 0010:memcpy+0xc/0x10
  Kernel panic - not syncing: Fatal exception

[CAUSE]
TThe crafted image has the following corrupted INODE_REF item:

         item 9 key (258 INODE_REF 257) itemoff 11544 itemsize 4106
         	index 2 namelen 4096 name: d\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000

The itemsize matches the namelen, but the namelen is 4096, way larger
than normal name length limit (BTRFS_NAME_LEN, 255).

Meanwhile the memory of the @name is only 255 byte sized, this will cause
out-of-boundary access, and cause the above crash.

[FIX]
Add extra namelen verification for INODE_REF, just like what we have
done in ROOT_REF checks.

Now the crafted image can be rejected gracefully:

 BTRFS critical (device dm-2): corrupt leaf: root=3D5 block=3D30572544 slot=
=3D14 ino=3D259, invalid inode ref name length, has 4096 expect [1, 255]
 BTRFS error (device dm-2): read time tree block corruption detected on log=
ical 30572544 mirror 2

Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/linux-btrfs/aik0hEV6ehKx6Ldv@Air.local/
Acked-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
[ Rebase, add a Link: tag, add an simple cause analyze ]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[btrfs: tree-checker] [validate] validate INODE_REF's
namelen =E2=80=94 add missing name-length bounds check in btrfs tree-checke=
r for
INODE_REF items`

### Step 1.2: Commit Message Tags
**Record:**
- **Reported-by:** Xiang Mei `<xmei5@asu.edu>` =E2=80=94 real reporter with=
 PoC
- **Link:** https://lore.kernel.org/linux-
  btrfs/aik0hEV6ehKx6Ldv@Air.local/
- **Acked-by:** Weiming Shi `<bestswngs@gmail.com>`
- **Signed-off-by:** Weiming Shi, Qu Wenruo, David Sterba
- **Reviewed-by:** David Sterba `<dsterba@suse.com>` (btrfs maintainer)
- No Fixes:, Cc: stable, or syzbot tags
- Notable: maintainer review; concrete crash reproducer in message body

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Crafted btrfs image with `INODE_REF` item where
  `namelen=3D4096` but item fits in leaf (`itemsize=3D4106`). Tree-checker
  passes the within-item bounds check, but downstream code copies the
  name into a ~255-byte buffer.
- **Symptom:** Kernel page fault in `memcpy` via `read_extent_buffer` =E2=
=86=92
  `btrfs_get_name` =E2=86=92 `reconnect_path` =E2=86=92 `exportfs_decode_fh=
_raw`; fatal
  exception / panic.
- **Root cause:** `check_inode_ref()` validates `ptr + sizeof(*iref) +
  namelen <=3D end` but does not enforce `namelen <=3D BTRFS_NAME_LEN`
  (255). `btrfs_get_name()` uses a `NAME_MAX+1` (~256 byte) stack
  buffer.
- **Fix result:** Corrupt image rejected at read time with `-EUCLEAN`
  and clear error message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised =E2=80=94 this is an explicit bug fix. It closes a
validation gap analogous to existing `check_dir_item()` name-length
checks (lines 602=E2=80=93606 in `tree-checker.c`).

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `fs/btrfs/tree-checker.c` only (+6 lines)
- **Function:** `check_inode_ref()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** After reading `namelen`, only checked that `sizeof(*iref)
  + namelen` fits within the item boundary.
- **After:** Rejects `namelen =3D=3D 0` or `namelen > BTRFS_NAME_LEN` before
  the boundary check.
- **Path affected:** Read-time leaf validation for every
  `BTRFS_INODE_REF_KEY` item (`disk-io.c` =E2=86=92 `btrfs_check_leaf()`).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds write (memory safety)
- **Mechanism:** `struct btrfs_inode_ref` is 10 bytes packed (`index` +
  `name_len`). With `namelen=3D4096` and `itemsize=3D4106`, `10 + 4096 =3D
  4106` passes the item-boundary check. Later, `btrfs_get_name()` in
  `export.c` calls `read_extent_buffer(leaf, name, name_ptr, name_len)`
  into a `NAME_MAX+1` buffer (`expfs.c:445`), causing OOB access and
  kernel panic.

### Step 2.4: Fix Quality
**Record:** Obviously correct; mirrors the existing `check_dir_item()`
pattern. Minimal, no API changes. Very low regression risk =E2=80=94 only
rejects already-invalid metadata.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `check_inode_ref()` introduced in `71bf92a9b8777` (Aug 2019,
Qu Wenruo). The namelen boundary check has been missing since
introduction. Overflow check refined in `c7c01a4a2524b3` (David Sterba,
Nov 2020). Bug present in this tree since at least v4.x-era checker
addition.

### Step 3.2: Fixes: Tag
**Record:** N/A =E2=80=94 no Fixes: tag. Underlying gap dates to original
`check_inode_ref()` commit.

### Step 3.3: Related File History
**Record:** Recent `tree-checker.c` commits include similar validation
fixes (`e92c2941204de` bounds check in `check_inode_extref`,
`96fa515e70f3e` inode ref size typo). Standalone fix; not part of a
multi-patch series in the message.

### Step 3.4: Author Context
**Record:** Qu Wenruo is a regular btrfs contributor; David Sterba is
btrfs maintainer. Weiming Shi authored the fix with maintainer
ack/review.

### Step 3.5: Dependencies
**Record:** No prerequisites. `BTRFS_NAME_LEN`, `check_inode_ref()`, and
`inode_ref_err()` all exist in this tree. Fix applies cleanly after line
1784 in local `tree-checker.c`.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Lore URL from commit message blocked (403/Anubis). `b4
shazam 'validate INODE_REF namelen'` found no match. Full technical
details available from commit message (stack trace, corrupt item dump,
before/after behavior).

### Step 4.2: Reviewers
**Record:** David Sterba Reviewed-by + Signed-off-by confirms maintainer
review. UNVERIFIED: full CC list from `b4 dig -w` (could not run
successfully for this commit hash).

### Step 4.3: Bug Report
**Record:** Reported-by Xiang Mei with reproducible PoC. Crash:
supervisor write page fault in `memcpy` during NFS exportfs reconnect
path. Severity: kernel panic.

### Step 4.4: Related Patches
**Record:** Commit references ROOT_REF checks as precedent; no
`check_root_ref` or ROOT_BACKREF name-length validation found in this
tree's `tree-checker.c`. The analogous existing pattern is
`check_dir_item()` at lines 602=E2=80=93606. `check_inode_extref()` has the=
 same
gap (no `BTRFS_NAME_LEN` check) but is out of scope for this commit.

### Step 4.5: Stable List History
**Record:** UNVERIFIED =E2=80=94 could not search lore stable list due to a=
ccess
restrictions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `check_inode_ref()` (modified); downstream vulnerable
consumer `btrfs_get_name()` in `export.c`.

### Step 5.2: Callers
**Record:**
- `check_inode_ref()` called from `check_leaf_item()` for
  `BTRFS_INODE_REF_KEY` =E2=86=92 `__btrfs_check_leaf()` =E2=86=92 `btrfs_c=
heck_leaf()`
- `btrfs_check_leaf()` called on **read** in `disk-io.c:457` (=E2=80=9Cread=
 time
  tree block corruption detected=E2=80=9D)
- `btrfs_get_name()` registered as `export_operations.get_name` in
  `btrfs_export_ops`; invoked from `exportfs_decode_fh_raw()` =E2=86=92
  `reconnect_path()` with `char nbuf[NAME_MAX+1]`

### Step 5.3: Callees
**Record:** `btrfs_inode_ref_name_len()`, `inode_ref_err()`, standard
extent_buffer helpers.

### Step 5.4: Reachability
**Record:** Trigger requires mounting/accessing a btrfs image with
corrupt `INODE_REF` metadata and hitting the NFS exportfs reconnect
path. Mounting crafted images typically needs `CAP_SYS_ADMIN`, but the
panic is still a real robustness/security issue for NFS servers
exporting btrfs and for any admin mounting untrusted images. Tree-
checker fix protects all consumers at block-read time.

### Step 5.5: Similar Patterns
**Record:** `check_dir_item()` validates `name_len > BTRFS_NAME_LEN`
(lines 602=E2=80=93606). `check_inode_ref()` and `check_inode_extref()` lack
equivalent checks =E2=80=94 this commit closes the INODE_REF gap.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is `v6.18.44` (`VERSION=3D6,
PATCHLEVEL=3D18, SUBLEVEL=3D44`). `check_inode_ref()` at lines 1783=E2=80=
=931790
reads `namelen` and only checks item-boundary fit =E2=80=94 no `BTRFS_NAME_=
LEN`
validation. Fix string `"invalid inode ref name length"` not present
(grep confirms fix not yet applied).

### Step 6.2: Backport Complications
**Record:** Clean apply expected =E2=80=94 6 lines inserted in one function=
. No
structural conflicts observed.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found. Related precedent: `e92c2941204de`
(inode extref bounds check fix, different bug).

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** **btrfs filesystem** =E2=80=94 IMPORTANT. Affects metadata inte=
grity
validation and NFS export path.

### Step 7.2: Subsystem Activity
**Record:** `tree-checker.c` actively maintained; multiple checker fixes
in recent history on this branch.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** btrfs users, especially those with NFS exports
(`CONFIG_NFS_SERVER`). Also any path reading corrupt `INODE_REF` items
that assumed checker enforced name-length limits.

### Step 8.2: Trigger Conditions
**Record:** Corrupt/malicious btrfs image with `namelen > 255` but
within item bounds; block read succeeds checker; exportfs reconnect
calls `btrfs_get_name()`. Uncommon in practice but trivially craftable
(PoC provided).

### Step 8.3: Failure Mode Severity
**Record:** Kernel page fault =E2=86=92 panic. **Severity: CRITICAL** (syst=
em
crash). Potential denial-of-service via crafted filesystem image.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH =E2=80=94 prevents kernel panic; rejects corruption
  gracefully at read time
- **Risk:** VERY LOW =E2=80=94 6-line validation matching existing dir_item
  pattern
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible kernel panic on crafted btrfs image
- Missing validation gap since 2019
- Small, surgical, maintainer-reviewed fix
- Matches established tree-checker validation patterns
- Buggy code confirmed present in local 6.18.44 tree
- Fixes corruption handling at read time (defense in depth)

**AGAINST backport:**
- Crash path specifically involves NFS exportfs reconnect (narrower than
  generic mount)
- Requires ability to mount/access corrupt btrfs (usually root)
- `check_inode_extref()` has similar gap (not addressed here =E2=80=94 sepa=
rate
  issue)

**UNRESOLVED:**
- Full lore thread / stable nomination discussion (access blocked)
- Whether ROOT_REF checker mentioned in commit exists elsewhere in
  mainline (not found in this tree)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** =E2=80=94 PoC before/after; maint=
ainer
   reviewed
2. Fixes a real bug? **PASS** =E2=80=94 OOB write =E2=86=92 kernel panic
3. Important issue? **PASS** =E2=80=94 CRITICAL (kernel panic)
4. Small and contained? **PASS** =E2=80=94 6 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** =E2=80=94 code exists, clean apply exp=
ected

### Step 9.3: Exception Categories
**Record:** N/A =E2=80=94 standard bug fix, not a quirk/ID/DT exception.

### Step 9.4: Decision Rationale

This commit closes a real validation hole in btrfs's tree-checker. A
crafted `INODE_REF` with `namelen=3D4096` passes the existing within-item
bounds check (`sizeof(*iref)` is 10 bytes, so `10 + 4096 =3D 4106` fits a
4106-byte item) but violates `BTRFS_NAME_LEN` (255). Downstream,
`btrfs_get_name()` copies into a `NAME_MAX+1` buffer, causing a kernel
panic. The fix is minimal, follows the existing `check_dir_item()`
pattern, is reviewed by the btrfs maintainer, and the vulnerable code is
present in this 6.18.44 tree without the fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; found Reported-by, Link,
  Reviewed-by David Sterba
- **[Phase 2]** Diff: +6 lines in `check_inode_ref()` adding `namelen =3D=3D
  0 || namelen > BTRFS_NAME_LEN` check
- **[Phase 3]** `git describe HEAD`: `v6.18.44`; blame shows
  `check_inode_ref` from `71bf92a9b8777` (2019)
- **[Phase 3]** `git log --oneline -20 -- fs/btrfs/tree-checker.c`:
  related checker fixes confirmed
- **[Phase 4]** Lore fetch blocked (403/Anubis); `b4 shazam` no match =E2=
=80=94
  UNVERIFIED for thread discussion
- **[Phase 5]** `grep btrfs_inode_ref_name_len`: multiple consumers;
  `export.c:287-290` vulnerable path confirmed
- **[Phase 5]** `expfs.c:445`: `char nbuf[NAME_MAX+1]` confirms small
  destination buffer
- **[Phase 5]** `include/uapi/linux/btrfs_tree.h:22`: `BTRFS_NAME_LEN
  255`
- **[Phase 5]** `include/uapi/linux/btrfs_tree.h:852-856`: `struct
  btrfs_inode_ref` is 10 bytes packed
- **[Phase 5]** `disk-io.c:457-465`: tree-checker runs at read time
- **[Phase 5]** `tree-checker.c:602-606`: `check_dir_item()` already
  validates name length =E2=80=94 precedent confirmed
- **[Phase 6]** `grep 'invalid inode ref name length'`: no matches =E2=80=
=94 fix
  not in tree
- **[Phase 6]** Read `check_inode_ref()` at lines 1752=E2=80=931799: buggy =
code
  confirmed present
- **[Phase 8]** Failure mode: OOB write =E2=86=92 page fault =E2=86=92 pani=
c, severity
  CRITICAL

**YES****Backport analysis: `btrfs: tree-checker: validate INODE_REF's
namelen`**

For the local **6.18.44** tree, this should be backported.

`check_inode_ref()` only verified that the name fits inside the item,
not that `namelen <=3D BTRFS_NAME_LEN` (255). A crafted image with
`namelen=3D4096` in a 4106-byte item passes the checker but later triggers
an out-of-bounds write in `btrfs_get_name()` during NFS exportfs
reconnect, causing a kernel panic.

The fix is small (6 lines), matches the existing `check_dir_item()`
pattern, is reviewed by btrfs maintainer David Sterba, and the
vulnerable code is present in this tree without the fix.

**YES**

 fs/btrfs/tree-checker.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c7e0e5fb6402d..13b711992a1c8 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1840,6 +1840,12 @@ static int check_inode_ref(struct extent_buffer *lea=
f,
=20
 		iref =3D (struct btrfs_inode_ref *)ptr;
 		namelen =3D btrfs_inode_ref_name_len(leaf, iref);
+		if (unlikely(namelen =3D=3D 0 || namelen > BTRFS_NAME_LEN)) {
+			inode_ref_err(leaf, slot,
+				"invalid inode ref name length, has %u expect [1, %u]",
+				namelen, BTRFS_NAME_LEN);
+			return -EUCLEAN;
+		}
 		if (unlikely(ptr + sizeof(*iref) + namelen > end)) {
 			inode_ref_err(leaf, slot,
 				"inode ref overflow, ptr %lu end %lu namelen %u",
--=20
2.53.0

