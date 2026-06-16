Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E8C344044;
	Tue, 16 Jun 2026 11:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610103; cv=none; b=fkmOqMkN0MzgecndIHR8v4NRpAl1CUts+tpy7PXUZKEEuGmlc5HnFhKarf6X18EkxucuHmQJlIurv5NNLrEcJg7TYQOj5p6Hp+KqkJUmVMALZ6rfPNZJoe1JPJuTWYpNmCZnmZuo88o1CH+Tfyibsdg6pt59z3wgUTpEgdhi4IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610103; c=relaxed/simple;
	bh=vl61eQEVAyqqCbJGRRrSwQqkgmw67a/sulgvyV5a2PQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f/A9ut01v9Mqt80jfjIeBwCwKm7/dgy3BGysrWE3bmxHtRpfthu4EuBL+O5oM4efnUu2iYkDMmeTDVgwh/JxOY8d9bwEQfQLy76babZdqPJ9sDAxgiA1n7lsu/lkT8f2gnvJ36vzQdLkxjqnZi+po9ettw05Fem6+7ypRLrTFwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iCJd89jw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iCJd89jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDF91F000E9;
	Tue, 16 Jun 2026 11:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781610101;
	bh=bmdfPB1py8Id4UZ+Bpb/V7U7OXh1ym2JVjoK0c7fSmI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iCJd89jw/6f0md+notOA7HfxPMHCV6TNAMHDISvBvN556BysYRjNv2EX6HJnEaML0
	 Nk6DpYVdxHcaiqkg5+aupMwM6y5bjVGosECMRC+GBKu+ROFp7GNC+AE4zedE1jRc4u
	 Ce0oFX0XxpPh4oONmjuNoNhVJYn7if0+vJwBE80I4z6cOX/LJ4d/4fHQBDPOfn77Ju
	 fih0grujr2fDrZaEzfhRqrzrAWBSYvIT5KX3XrwTl2Mea9sYwrlrB+YOSU+3e+6cgr
	 A71eOJtnARXi/FIgopa//QcYghUwAFv/KasIdK/JDUl2hMmPqd/KB52YdPjpzrX1n4
	 3VVxFxKT0K0iA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 13:41:11 +0200
Subject: [PATCH 2/7] btrfs: don't unwind a committed device on the seeding
 add error path
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-btrfs-preexisting-fixes-v1-2-c4abe2f6d4f0@kernel.org>
References: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
In-Reply-To: <20260616-work-btrfs-preexisting-fixes-v1-0-c4abe2f6d4f0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naota@elisp.net>, 
 linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>, 
 Stefan Behrens <sbehrens@giantdisaster.de>, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2430; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vl61eQEVAyqqCbJGRRrSwQqkgmw67a/sulgvyV5a2PQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZmmWls8zzPBnqpz5jv0nrzbr6OavUq8UkJC5bWqT2b
 G8OqDfuKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmAifMMN/fwWXNOay21/+WgVV
 HtKYqPo54rPv3Y87Hh34qh0XWLBJluF/Zk920JsWVa2vGw9WlP89tK67he3KMpYdmqEnpSz2Cvm
 zAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

When adding the first writable device to a seed filesystem,
btrfs_init_new_device() commits the transaction that makes the new
device a permanent member, then relocates the system chunks:

	ret = btrfs_commit_transaction(trans);
	if (seeding_dev) {
		...
		if (ret)			/* transaction commit */
			return ret;
		ret = btrfs_relocate_sys_chunks(fs_info);
		if (ret < 0)
			btrfs_handle_fs_error(fs_info, ret, ...);
		trans = btrfs_attach_transaction(root);
		if (IS_ERR(trans)) {
			if (PTR_ERR(trans) == -ENOENT)
				return 0;
			ret = PTR_ERR(trans);
			trans = NULL;
			goto error_sysfs;	/* frees a committed device */
		}

By this point the device is on disk and referenced by the in-memory
chunk maps (map->stripes[i].dev) set up by init_first_rw_device().  If
btrfs_attach_transaction() fails with anything other than -ENOENT, the
code jumps to error_sysfs, which unlinks the device from fs_devices,
rewinds the superblock accounting and frees it with btrfs_free_device().
The chunk maps are left pointing at freed memory, so a later
btrfs_map_block() dereferences a freed btrfs_device -- a use-after-free
that needs no concurrent reader.

It is reachable: a btrfs_relocate_sys_chunks() failure (e.g. -ENOMEM,
-EIO) calls btrfs_handle_fs_error(), which sets the filesystem error
state, so the following btrfs_attach_transaction() returns -EROFS
(!= -ENOENT) and takes the goto.

A successfully committed seeding device must not be torn down here.  Do
what the btrfs_commit_transaction() failure just above already does:
leave the device in place and return the error.

Fixes: 7132a262595a ("btrfs: error out if btrfs_attach_transaction() fails")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/volumes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9c4cd8bdda05..59817b5d3204 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3046,9 +3046,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 		if (IS_ERR(trans)) {
 			if (PTR_ERR(trans) == -ENOENT)
 				return 0;
-			ret = PTR_ERR(trans);
-			trans = NULL;
-			goto error_sysfs;
+			/* Device is a committed member now; don't tear it down. */
+			return PTR_ERR(trans);
 		}
 		ret = btrfs_commit_transaction(trans);
 	}

-- 
2.47.3

