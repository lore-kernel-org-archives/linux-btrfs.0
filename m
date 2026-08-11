Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B052437646C;
	Tue, 11 Aug 2026 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472111; cv=none; b=daADdxK4fX/9UAumgAJWBN5SYoVNdlWSEuBYieV1MCz1T/5dJ+0+it+vjQZ4PY6pmGOC6K3eMN7mMYtE8lkf7gS4wn7m7mPfRXUTpsHBrHBBQq9eT9qZw1rxmwSi96L7RAN7gz0U9CwWr5FSSMQzOTPTR1nUSfcZFzHBinbU3ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472111; c=relaxed/simple;
	bh=lJ1jwk8dHFftzNzRk1UUSsYMc9VYKcAC6ZoHBNiINDQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Ew52uBDy/b3CXyjCoNuitjB2hAHkmykcabhACQmpqYrskYdA/MLcJqGD+xwEezsxYdL51VzM/cb1TWNS5UjrI0cuIpSXrjO6us0HswhQ7Sa1WKGbep+ssobj8cnl4r6eANNIW2RhofLVbbcfKgnybv1OGJyoyjdFLijlZACFCPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc2E58DM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc2E58DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366551F000E9;
	Tue, 11 Aug 2026 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472108;
	bh=IYQQ6LTf4E78uH4FiglbB2mRqthR1OKb9Hhx/4sf3rk=;
	h=From:Subject:Date:To:Cc;
	b=Kc2E58DMhoqmb2Md05+lU1+hgi0NEWOZpJqE2zg+I7U78SBwO7YYXrAAuNMJYeLOd
	 kE+cmMl7Mqy2XrU2oxACU4sX58QvOJ+fdC6O+frX1vaRYiUcPkDNva/q8wi/sdxDji
	 whr8Srv/fDAo52byaFARvfBZuK/B8T96JyT44FswcW/6b+mq7A1UBYuKxu5CDe3jYQ
	 saOBIblQrWiJv+anZ3PKi6F4cLfMQC3OHXX9VHhs9tOuTIlBrQi9rFnGdbUZGBrGeZ
	 v8w5QycaXTyKWxAMg7UinF7sI/fwcGKfdVXYM0R0YRPYwXt5hbqZESfw+Q3WrpNE93
	 3e+t6BPJW5x6w==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 0/6] btrfs: handle -ENOMEM errors in some synchronous
 dirops without aborting
Date: Tue, 11 Aug 2026 14:14:53 -0400
Message-Id: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MSwrCMBSF4a2UOzaSpK/UkfsQB5rctEFN5KYEp
 XTvpgWROjwH/m+CiOQwwqGYgDC56ILPo9wVoIeL75E5kzdILhveippdR7KRoQ8PfLBOKSu1Lht
 rDeTkSWjda+VO57wHF8dA71VPYnm/ULuFkmCcaaM7zVE2teHHG5LH+z5QD4uU5K9WvPqrZa4r0
 8lStByVFpt6nucPVZFIeucAAAA=
X-Change-ID: 20260715-btrfs-enomem-988f2cc36ffd
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3975; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=lJ1jwk8dHFftzNzRk1UUSsYMc9VYKcAC6ZoHBNiINDQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqe2althwVMRmSSj5m0DqwysLT97OuO7a5a/wBV
 47t11JRsjKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCantmpQAKCRAADmhBGVaC
 FU5LD/0WNfJXXFS3phmfL9bIZh6ApdZh1sDZen7DzlV+6NgMamq+dVw36WogUJM4VUkOkBlz9Mm
 RoAm+fvO+hNyw2aTRdIeF5BlWRqjB5lEER4IfhkudZ/sHpj6h5/YXpcEBRQfubI7fPhDQG7+K3g
 gj9LYhB9KDxWRTRyIOaYDIiXSqNLy+G+LjHqggMnPPPZEP0e3rkhm3zluFddB0LkCl6wL/pzQyV
 /cPn204P7RsaA3GOAZx/kkKkCgn7BSGaPkQC0xeaMRnu4SMcYD5Q/MMKOe+Q6/hGxBOs3a31AdO
 nS/QTMXfmJvBbwjvaEEj8Yo+ihXaDyE2PS5AACmnac6FTg3rqnwd8blrFszFOzviaxYHHSq50Vb
 e+K0+/L2Ni0LMDOzRrj3jdol+cIkDTbVWdPCaD301iJLAR34V9/2dIiBoeZN2J9JkQTCuORTiWE
 cpporrTqvXpr2zv9550qlpUR3RlhJtsxbVet2baC9CllA05yFQ2v+jz5Zt3VV64fmbRRIZn9aJK
 ZZ8pMTTUjPFeZQY3gEG2C21xNrUtNZg/IkZDwkTspfSBw8AsbEYFWDTE4S/vgPOVV5+Li+SwD2K
 77/w+uYh86XcM1jMRo14/JlX2MzvzAQ8chjX7oN1KBWS+s/01CQyj5Nq/whEqg0e0g0I0F9i8j0
 3F/MzVI2+8QH3sw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

This version fixes some issues Qu pointed out in review of v2. I did end
up adopting his suggestion to allocate the prealloc container as well,
which makes the API cleaner. Original cover letter follows:

We've had a (relatively small) number of ENOMEM btrfs aborts occur in
synchronous directory morphing codepaths. It's not terribly common, but
there are a few places where an memory allocation failure results in an
abort.

This patchset reworks the code to do the allocations up front, before the
point where we'd have to abort the fs if it fails.

This does not cover all potential cases where this can currently occur:

In particular, a rename that overwrites the target can still abort the
fs if a memory allocation fails. Fixing that is substantially more work,
unfortunately.

This also doesn't cover orphaning a new inode on failure (which can
trigger new memory allocations), so this series is designed to work in
conjunction with with Boris' GFP_NOFAIL series [1].

AFAICT, these are ancient problems, dating back at least to ~2011. I
didn't bother adding Fixes: tags.

AI disclosure: I made heavy use of an LLM in this patchset, from
drafting the initial series to helping test it.

[1] https://lore.kernel.org/linux-btrfs/cover.1784673567.git.boris@bur.io/

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v3:
- btrfs_prealloc_delayed_dir_index() now allocates and returns the
  btrfs_dir_index_prealloc instead of filling in a caller-provided on-stack
  struct, so a NULL pointer means "no prealloc" and callers no longer need
  to use prealloc->item as an is-allocated flag (as suggested by Qu).
- Fix a leak of a caller-supplied prealloc in btrfs_insert_dir_item() when
  btrfs_alloc_path() fails; all error exits now go through a single
  out_free_prealloc label (Qu Wenruo).
- Move the dir index name memcpy into btrfs_prealloc_delayed_dir_index()
  instead of duplicating it at the call sites (Qu Wenruo).
- New patch to use an on-stack path in btrfs_del_orphan_item().
- btrfs_create_new_inode(): persist nlink=0 with btrfs_update_inode() after
  orphaning the new inode. Otherwise orphan cleanup sees nlink > 0, drops
  the orphan item and leaks the inode.
- Pick up Reviewed-by tags from Qu Wenruo.
- Link to v2: https://lore.kernel.org/r/20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org

Changes in v2:
- Use an on-stack btrfs_path in btrfs_insert_orphan_item() so the ENOMEM
  recovery does not itself fail on a path allocation.
- Simplify the recovery in btrfs_create_new_inode() to rely on
  btrfs_orphan_add()'s internal abort instead of aborting twice.
- Add ALLOW_ERROR_INJECTION() on btrfs_prealloc_delayed_dir_index() and a
  new fstest (btrfs/351) to exercise the ENOMEM path.
- Link to v1: https://lore.kernel.org/r/20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org

---
Jeff Layton (6):
      btrfs: use an on-stack path in btrfs_insert_orphan_item()
      btrfs: use an on-stack path in btrfs_del_orphan_item()
      btrfs: split btrfs_insert_delayed_dir_index() into prealloc and commit phases
      btrfs: pre-allocate delayed dir index before btree modification
      btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting
      btrfs: pre-allocate delayed dir index for non-overwrite rename

 fs/btrfs/btrfs_inode.h   |   4 +-
 fs/btrfs/delayed-inode.c | 115 ++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/delayed-inode.h |  22 ++++++---
 fs/btrfs/dir-item.c      |  42 +++++++++++------
 fs/btrfs/dir-item.h      |   5 ++-
 fs/btrfs/inode.c         |  64 +++++++++++++++++++++-----
 fs/btrfs/orphan.c        |  36 +++++++--------
 fs/btrfs/transaction.c   |   2 +-
 fs/btrfs/tree-log.c      |   4 +-
 9 files changed, 215 insertions(+), 79 deletions(-)
---
base-commit: 76d8783d4c196f4ac990b97ee9f56d2e6797e173
change-id: 20260715-btrfs-enomem-988f2cc36ffd

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

