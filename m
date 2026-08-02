Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1791F2380;
	Sun,  2 Aug 2026 10:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785664932; cv=none; b=siUc1ikIFPlCOfUQGkoBS4Ki0uyPovsKVXmB0k7f/O9ryyo96QfN3MZfd2VV8jAE3fSx/y1PqEgJzo5ZaYLN6vkqj4GYU/rPGiy5LNHCCJfd+WozIKZAO2sMhDHpFUitv6K/ckh1ADnbW0c9pF66rLEaVoMO1tP8T2L4kP71e0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785664932; c=relaxed/simple;
	bh=1r6wMMqs0wLC5I3DwPhqdui1QguOAUmSRsw+MiOQ0UI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jgx3aYjtMpw0TLcmXALO0bVzUBomuHGwvRrKgtAOZ9Zth01NGOhfq3QJvwSKOszhaKmSQOgvlZ26e/93aVG7Ww4Ht2KXlT0M+BtcCACuPba6d17cR8zB5RT2fOHcz63NTZdivj8woTNn7ebz4COEjTXrOsxpvU0qjaCNOe5Yluc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d341c/vg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d341c/vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B7F1F000E9;
	Sun,  2 Aug 2026 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785664930;
	bh=6xLY+/gzaI2p32FqUFncbXzwcspctY8No06jdHaWzDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d341c/vgPwzbIzSQpiCIAUK2utsZSJMZa+V6rmuPVXCCifRDsYYj8nwpbiN91vRgR
	 8xIQLHkzCUaG4l7K+U0PF/9ZL+qLc+VyQnR6U0YzWV8Z9lmeB27pp759nr+lgiKAca
	 9BbG+cLXJJnx+YlI1hZqtsFOrmZ9pf4mgzH2CRKz8LzvMtVRDfBu6HWicUZFUSp1VL
	 uHzndyWSNAQOJMz8pdfkMYdPi9608C6aVr7AnN6b7WmCBdJZ09/Rq/095PdFwluD7m
	 T4o79AYXlAuSyi1mrawcVa1pe5ew8jif3tDnvBcQ7/q1VtGhqUiaNjySKBSVKw0pMO
	 U3XpkXaLHNtyQ==
Date: Sun, 2 Aug 2026 18:02:02 +0800
From: Zorro Lang <zlang@kernel.org>
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, 
	sunyangkai@fygo.io, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] btrfs: test POSIX ACL changes for RO btrfs property
Message-ID: <am8JhAnr7H1-Ovw9@zlang-mailbox>
Mail-Followup-To: Sun YangKai <sunk67188@gmail.com>, 
	linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, sunyangkai@fygo.io, 
	Filipe Manana <fdmanana@suse.com>
References: <20260709082500.17907-2-sunk67188@gmail.com>
 <20260722075347.26639-1-sunk67188@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722075347.26639-1-sunk67188@gmail.com>

On Wed, Jul 22, 2026 at 03:52:47PM +0800, Sun YangKai wrote:
> From: Sun YangKai <sunyangkai@fygo.io>
> 
> Test creation, modification and deletion of POSIX ACLs on a btrfs
> filesystem that has the read-only property set to true.
> 
> This exercises a bug fixed by the kernel patch with subject:
> "btrfs: check if root is readonly when setting posix acl"
> 
> Signed-off-by: Sun YangKai <sunyangkai@fygo.io>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> ---
> Changes since v2:
> 
> - updated commit message
> - proper format for fixed_by_kernel_commit
> - lower case variable name
> - handle mkfs failure
> 
> Suggested by Filipe Manana
> ---

This version is good to me, if no more review points form btrfs list, I'll
merge it.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/btrfs/353     | 95 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/353.out | 39 +++++++++++++++++++
>  2 files changed, 134 insertions(+)
>  create mode 100755 tests/btrfs/353
>  create mode 100644 tests/btrfs/353.out
> 
> diff --git a/tests/btrfs/353 b/tests/btrfs/353
> new file mode 100755
> index 00000000..63ba4681
> --- /dev/null
> +++ b/tests/btrfs/353
> @@ -0,0 +1,95 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 Fygo OS. All Rights Reserved.
> +#
> +# FS QA Test No. 353
> +#
> +# Test that POSIX ACLs cannot be changed once a btrfs subvolume has the
> +# read-only property set.
> +#
> +# Setting or removing a POSIX ACL goes through the ->set_acl inode
> +# operation, which is a different code path from the generic ->setxattr
> +# one covered by btrfs/275.  It used to be allowed on a read-only
> +# subvolume and thus bypassed the RO protection.  Such modifications must
> +# fail with EROFS, just like any other xattr.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick acl attr
> +
> +. ./common/filter
> +. ./common/attr
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: check if root is readonly when setting posix acl"
> +
> +_require_acls
> +_require_btrfs_command "property"
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +filename=$SCRATCH_MNT/foo
> +
> +set_acl()
> +{
> +	local perm=$1
> +
> +	# Use -n so setfacl does not recalculate the mask, keeping the
> +	# golden output deterministic regardless of the named user's
> +	# permissions.
> +	setfacl -n -m u:$acl2:$perm,m::rwx $filename 2>&1 | _filter_scratch
> +}
> +
> +get_acl()
> +{
> +	getfacl --absolute-names -n $filename | _filter_scratch | _getfacl_filter_id
> +}
> +
> +del_acl()
> +{
> +	setfacl -b $filename 2>&1 | _filter_scratch
> +}
> +
> +_acl_setup_ids
> +
> +# Create a test file.
> +echo "hello world" > $filename
> +
> +# Set an initial ACL while the subvolume is writable.
> +set_acl rwx
> +
> +# Attempt to change the ACL once the subvolume is read-only.  This must
> +# fail with EROFS.
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT ro true
> +$BTRFS_UTIL_PROG property get $SCRATCH_MNT ro
> +
> +set_acl r--
> +
> +# The ACL must not have changed.
> +get_acl
> +
> +# Attempt to remove the ACL from the read-only subvolume.  This must
> +# fail with EROFS as well.
> +del_acl
> +
> +# The ACL must still be present.
> +get_acl
> +
> +# Make the subvolume writable again.
> +$BTRFS_UTIL_PROG property set $SCRATCH_MNT ro false
> +$BTRFS_UTIL_PROG property get $SCRATCH_MNT ro
> +
> +# Now changing the ACL must succeed.
> +set_acl r--
> +
> +get_acl
> +
> +# And removing it must succeed too.
> +del_acl
> +
> +# Check the ACL is really gone.
> +get_acl
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/353.out b/tests/btrfs/353.out
> new file mode 100644
> index 00000000..66f4a0e5
> --- /dev/null
> +++ b/tests/btrfs/353.out
> @@ -0,0 +1,39 @@
> +QA output created by 353
> +ro=true
> +setfacl: SCRATCH_MNT/foo: Read-only file system
> +# file: SCRATCH_MNT/foo
> +# owner: 0
> +# group: 0
> +user::rw-
> +user:id2:rwx
> +group::r--
> +mask::rwx
> +other::r--
> +
> +setfacl: SCRATCH_MNT/foo: Read-only file system
> +# file: SCRATCH_MNT/foo
> +# owner: 0
> +# group: 0
> +user::rw-
> +user:id2:rwx
> +group::r--
> +mask::rwx
> +other::r--
> +
> +ro=false
> +# file: SCRATCH_MNT/foo
> +# owner: 0
> +# group: 0
> +user::rw-
> +user:id2:r--
> +group::r--
> +mask::rwx
> +other::r--
> +
> +# file: SCRATCH_MNT/foo
> +# owner: 0
> +# group: 0
> +user::rw-
> +group::r--
> +other::r--
> +
> -- 
> 2.54.0
> 
> 
