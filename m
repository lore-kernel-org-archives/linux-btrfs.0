Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230E246D086;
	Tue,  4 Aug 2026 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858291; cv=none; b=B+oD8AfIm3cbzE4IoDupr+YwHGnVNOF7MsZeu5W23DDtSxwBYsrZrMTXAS+YDBcrqhA+k+gxQ/13hoTnvGFh2d6be3iUE1q1t54q3FW1dpo6EOyn1MR5qieGA+Cf09PdJSrnWg/VXhk4cPQw4B6ZibWM5h87qrqG7b6xhOD1f1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858291; c=relaxed/simple;
	bh=D54yM+jasmjvXOKoq+HQlm+2ksqa0q2umTkTpDW8tSs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=t/WdinrdI15iu6BrX1WpAX7c5Z2VrdY24XNLyfTh3WqE1m+L4pE4DVEZ+7ohnJDXLU/4mu85L7+0EvV4L6Zis5vFm+/iGpgCoJPdnCxQ+wfj+F0yHY8zhVT7YN/iHIE3TVj0f8s3m3U2bqztahf1vwHZHTnbbR0EaqEtiDQCklY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMRWagUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMRWagUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F11E1F000E9;
	Tue,  4 Aug 2026 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785858288;
	bh=ztHV4QhhS1PSKMOYibULQYPXxpXa1XWHERuIvhYzsmw=;
	h=From:Subject:Date:To:Cc;
	b=AMRWagUbBaTkDUMdo61A6kkq8dddi/HX3hAb01nlWLp/luh7Vg2m2w6UX8Cr9eGWE
	 mOHJIz7Yx7USgFso0Pya15V8iAobAvodNdUie03c1yNkjM50PVZwUqiqJKd7pkBnZk
	 5DhCjm7i8XMVxVodtUoMST0JvQg+13uS9PtFcxog9kdZlUSJCrAERu/6T2jAsPnxdF
	 cvRNgS5Ibl+b06/ChFpW/rHoL08LAbfpjAj//wY7kWKxsTMz1Yx5iHquSZOHGQjSf8
	 9VE9xsFc2QV10rqr9ixCdM8QugnKUb6NrI3UuCU+uv9kQtA9d/RIvhw1dAHa7Fkd3e
	 qW7p77L8675kw==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 0/5] btrfs: handle -ENOMEM errors in some synchronous
 dirops without aborting
Date: Tue, 04 Aug 2026 11:44:32 -0400
Message-Id: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/1XMQQrCMBCF4auUWRtJIk1bV95DutDJpA3apExKU
 Ervbiy4cPk/eN8KidhTgnO1AlP2ycdQQh8qwPEWBhLelgYttZGNqsV9YZcEhTjRJLq2dRrxZJy
 zUC4zk/Ovnbv2pUeflsjvXc/qu/6g5h/KSkiBFjuUpE1t5eVBHOh5jDxAv23bB0b5lE6pAAAA
X-Change-ID: 20260715-btrfs-enomem-988f2cc36ffd
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2673; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=D54yM+jasmjvXOKoq+HQlm+2ksqa0q2umTkTpDW8tSs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqcgjqLOhO56baKcF1GdZJtEDqF1H5vMgq5kI2U
 AtfZVnWwFOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCanII6gAKCRAADmhBGVaC
 FUzrD/wK2sFgXEsmSGw3CGOMO6e6CGsSCnsjJ4VlhhNGXJdNX4vpHZXDMUsSunWLmyd3T3Q07kK
 Zzk1Dsi6zyPrGOO4DuRzIncrbB9g8V27Z4GDt9vnZBzLaC1TXxCB/P8AHkJVyowpAdW2cySsef/
 LcpM7Wz4OJOPwnZPhVbJpA9+Q+vNnNHsoaDe6AEyoveGGkTeTNTZwkuTvOJk8tYwqxIoLNKWGe8
 3KY56IMaAe7ncNH1Y5h8b8D1GRJhFHqDALBlUV1Zw8HbzyMetVv43dIZp2RlKeZ8APJMhG3DdZm
 qq8b3v21M1+prRrq/Qt0QbF+4KKIzTSlM4G+UnaoAE4HgcRk+KmpL8RXsweBmUit0CCGDjZdYXa
 9/kHbMMYY4iBszJ3V/j1FbUbn4U57FN4P8+eVsl+/x7Cyq2e64ZjkfmMw/oU/Jx6jPNM2xpcGrI
 95b5omVjpB3gAGMqVNLiepLGPpt+FqKHJk/WeZRFPYowY1XWcOzVdegegm+5GjVayyEq081LGsU
 RT/08lOujY3uUnY8GSyD7lFmNRIWkL40ytsvWeX1mErJIn7U4rjdQzW4UKWvsotbqHIVUMnyZ4G
 7PYsyDc7k/uEWgikvcox73iIsTAJc/HazaAvHSHKqOK6oIjPkN+Nj7zAEfx1ML5JhaGz+0EUGlN
 8H8mZMptOrft81Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

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
Changes in v2:
- Use an on-stack btrfs_path in btrfs_insert_orphan_item() so the ENOMEM
  recovery does not itself fail on a path allocation.
- Simplify the recovery in btrfs_create_new_inode() to rely on
  btrfs_orphan_add()'s internal abort instead of aborting twice.
- Add ALLOW_ERROR_INJECTION() on btrfs_prealloc_delayed_dir_index() and a
  new fstest (btrfs/341) to exercise the ENOMEM path.
- Link to v1: https://lore.kernel.org/r/20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org

---
Jeff Layton (5):
      btrfs: use an on-stack path in btrfs_insert_orphan_item()
      btrfs: split btrfs_insert_delayed_dir_index() into prealloc and commit phases
      btrfs: pre-allocate delayed dir index before btree modification
      btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting
      btrfs: pre-allocate delayed dir index for non-overwrite rename

 fs/btrfs/btrfs_inode.h   |  4 ++-
 fs/btrfs/delayed-inode.c | 90 +++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/delayed-inode.h | 22 +++++++++---
 fs/btrfs/dir-item.c      | 30 ++++++++++++----
 fs/btrfs/dir-item.h      |  5 +--
 fs/btrfs/inode.c         | 57 ++++++++++++++++++++++++------
 fs/btrfs/orphan.c        | 11 +++---
 fs/btrfs/transaction.c   |  2 +-
 fs/btrfs/tree-log.c      |  4 +--
 9 files changed, 168 insertions(+), 57 deletions(-)
---
base-commit: 76a2100a0e8d81636586449024e7558656300481
change-id: 20260715-btrfs-enomem-988f2cc36ffd

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

