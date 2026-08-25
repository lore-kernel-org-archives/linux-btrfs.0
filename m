Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4D333970F;
	Tue, 25 Aug 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673898; cv=none; b=cDd6veqldd29rlY3o/ldYHL6EgZM2HXMBuszDpKs1ZLSUdlmpIGmpJaL3Bj88N+VflC9CIfRD4eVVO/fQp3Udt3faOMIIsYCA9u2bwzKV+kTRb/kVa79EEiUAgK1heWk8hoLsFoVtxPEYrfFNAJxtTS9fLVZzXSn2pIPYnXu5Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673898; c=relaxed/simple;
	bh=hPsLAZ0Fsg2mrgN1Ey49I8t/NXXJ9qbvUkJbV95bTfA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=PpROFtWC9CeECueiok3vj1N74d7nPTda3bupKPj9pj7b3clF0wI2w3kVCSxY/rfXJoirRGHvLMn4hcWJblmW4A7nTCRWlxjyzVivOQNW/EjliB3gbKeQ1Imlyx4Oz/DcC5MYlZMAd5T+Mleyn1oB6lbAHzp5oPV/kG4lzkXXm98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6qiRNmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6qiRNmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F0F1F000E9;
	Tue, 25 Aug 2026 16:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673897;
	bh=vz7RUHTTFe1I1C/5WEAEd4dUPKbZQgl8ARSVPiYBcds=;
	h=From:Subject:Date:To:Cc;
	b=a6qiRNmC/v8h5ryfeJQ6eacpWKuxC85eR2rhYIqzV7/Fq/tkH9xs4meLrTrxlOLyz
	 mEozcFmnuSJGSBFJk/93XB80GAC1NBT0SWx3+hX2SXyTkYPj5+16/M7Q9gtGC3LKI/
	 uZQ0oWBvguoZiUtddo5SImKpOeQUkwSomIkZRywwwYEYDddIGHbVcza27/7T8dwkaO
	 BmyLiQusjUmROegAFjnYi1hZDggsoF4exFOXvihJssO9mdvTm/ugPR0GsDMOv1++gU
	 ONudpOee0kANnzzWlY8mgutKeIth8QXrScz1ZvHZYWE3nkD0ojExPFW7S3YWfv5pTe
	 5djsWPkdmBIgA==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v4 0/4] btrfs: handle -ENOMEM errors in some synchronous
 dirops without aborting
Date: Tue, 25 Aug 2026 12:04:16 -0400
Message-Id: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XM3w6CIByG4VtxHEfjj6J01H20Dgx+KKuggWM15
 72Hbq20w+/bnndEEYKFiA7FiAIkG613eZS7Aqm+dR1gq/NGjDBBalrhyxBMxOD8He5YNo1hSnF
 hjEaZPAIY+1xyp3PevY2DD6+lnuj8fkL1OpQoJlhpJRUBJipNjlcIDm57Hzo0lxL76oaUG82yL
 rVknNYEGkX/NP/RlG40n7VopeRGcQPVSk/T9AaPTWOHJQEAAA==
X-Change-ID: 20260715-btrfs-enomem-988f2cc36ffd
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4187; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=hPsLAZ0Fsg2mrgN1Ey49I8t/NXXJ9qbvUkJbV95bTfA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqjb0h5ez2qlzvO0cTX+Mzhuim2ALtRM1LkKHoK
 /wAXvf/G8uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCao29IQAKCRAADmhBGVaC
 FelsEACNu/RupJWZWIk1gOB+xvTBfVaaErCEuQGYDhbVCVKq6WPeF5X8CgkCAGzNNyDLkcwQhcv
 nQxpUamDcI3/XB57YAnXeq6l7emmdhqLX6VgYx5hcDHvcHdeHKwtyAzRH1UnmT9gzdBczr9SXwA
 FC+Axzsv4pH74YCDWt2V/uCIEL5xVRIqybJ6ivZ9V3q9Qv7Yc1Iy1Pq6gbsv8TyS/124FCzSpiK
 Os6wh8pLmYBUrvqghKTCpXUMXr3U3SIP6v+h95pc7+4hMAWJCDXnayK/GxkgpT5Q0iahR2BjrYn
 dwd8cnwMeN3DfyV1CFx55DLgE0tegT1ldm9JVrALtCnQOtsHzP0SZR+1R1MfudEuN+ZPrYR6VKp
 3+QnB76975vOeXHIa+WXCQkSDLZAE8KWs6x5goDJo0SI1PV/VXyVgQISeoU1nTCl5R0dkETL66k
 qa+umtQNqg0C8s+J3Rh67X4pdvRM56/YA1uj4ejoYY1mM0htIzpKLRQveexlyHhYEeNxdjrZvzA
 F7l+cbkP9Mqw5xrMAgGm4L/7DnYG31+u+V2wLIpgKwjpzymEPiSHygTXV5UXWZVAabGWi6uAD42
 TftZtUIE24APWABGjgbhzf9G9SUKAtB/0fOpKMqbW0Ro7MR9ytB3+/ec1UIp629X7uLexR9DUkK
 qc0fmB+zJpoNMTA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

This version is almost exactly the same as v3, but I've dropped the two
patches that change btrfs_insert_orphan_item() and
btrfs_del_orphan_item() to use stack allocations. We have no known
occurrences of those allocations failing, and I'm comfortable not
solving that problem until we know that it is one.

Original cover letter follows:

----------------------------8<-------------------------

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
Changes in v4:
- Drop patches that switch orphan handling to use stack btrfs_path allocations
- Link to v3: https://lore.kernel.org/r/20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org

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
Jeff Layton (4):
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
 fs/btrfs/transaction.c   |   2 +-
 fs/btrfs/tree-log.c      |   4 +-
 8 files changed, 197 insertions(+), 61 deletions(-)
---
base-commit: 09c66b64f93d6563e115fdae0ebee932d2fe352f
change-id: 20260715-btrfs-enomem-988f2cc36ffd

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

