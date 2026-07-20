Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C6D43634F
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784564228; cv=none; b=JKEgEqQb/IdYr5iyjWHaPc5UFG7VvVHMo5BbH1lPXFjAu6hSMDcnGWa/rQbKY7vk+AwEU+EGNCwwgdhz6RpQQ9wQB0otDchtVK+IQ+E73dnQHHtB67NQKGdFKamNoVSpEsV6xbHRAGzR02UnsvMi++rXlXyY50I0OlppsNfZAp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784564228; c=relaxed/simple;
	bh=gySmcKEmKDjp9sXqAJiUHlPC0ZvxE9FrirfJFiy3gxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tj+ym3jYVG3caqtLal9lCpeoUN4gYDCx8hl037ZNulRR41FzV1xA8i5YdZPXdIeBBA2L6nzkm5dc83ex2ZmOB5Hv1VsUTLYC2bRNOPxvRxuwfPBJ41xhoa1lY1xUsG18fqZ0T1IS7LPjVqwPA80kvYpP6MmBP6hBMRsX08rCZEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrSJEzCk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrSJEzCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9D81F00A3F
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784564225;
	bh=E5YD8BvJI2JZQdTG9hV5u3LRLEAdZb3qQHKLNz9wZCY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZrSJEzCk7AK95QYw/yBud2JxD53GcJgKxK6Bj3C06er+NFJFyxirzTiBapH2hFTt+
	 exJ3MTNmIVNTFrkP7GrDChS8Nu91gejNLQYiKLeXy7HcCb0CXCBKbu3rwdVDaHJf/z
	 A1eKRXOcXEnyqQEsoN0yOrVnTr+39hsvQmxzBoj11lbL4/9P6L1Fq47HAv1iZh8w3Z
	 EomOIX1lAjxHDMvZNpgjANKUlZjheW/A6xZKqLFFhIo7fVDySUX0j7sQdneilerj3g
	 sKA+qE1fHN9kBjZZ+s3o/Gw3Agnudo+NjgDJQc64109hZtx/3PVrqiCEztKDGwEN7K
	 FNf/Szm8gS/yg==
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-73b909fbb6bso6394196137.2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:17:05 -0700 (PDT)
X-Gm-Message-State: AOJu0YyZ3fIGY0KKTpYNx9LChXmh3z864ewX58hrYyjWq82AKMTgO5xB
	m65w45phkwrVYbf+MBCPqd1D+0iv0T4LPn5rCIUXH0wtzBlAhTRgUSn3gSVXiWSAzN3XD+zGBQz
	aar1eigJ3o0wh3tmxzEFa1KKkqs3HdSQ=
X-Received: by 2002:a05:6102:161e:b0:726:8813:2085 with SMTP id
 ada2fe7eead31-74753625ab4mr4612966137.13.1784564224936; Mon, 20 Jul 2026
 09:17:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709082500.17907-2-sunk67188@gmail.com> <20260713094611.19703-1-sunk67188@gmail.com>
In-Reply-To: <20260713094611.19703-1-sunk67188@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 20 Jul 2026 17:16:27 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7WBKk70cRmURvwx5O+hHouFH-Dt_6W3pJmsR85ODP4sw@mail.gmail.com>
X-Gm-Features: AUfX_mzwUhgRXiOcDv6dAzmaJCuUaWIi9bRP_zb3pYsmgL5od0JCZDhdyWUqKys
Message-ID: <CAL3q7H7WBKk70cRmURvwx5O+hHouFH-Dt_6W3pJmsR85ODP4sw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: test POSIX ACL changes for RO btrfs property
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, 
	Sun YangKai <sunyangkai@fnnas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 10:50=E2=80=AFAM Sun YangKai <sunk67188@gmail.com> =
wrote:
>
> From: Sun YangKai <sunyangkai@fnnas.com>
>
> Test creation, modification and deletion of POSIX ACLs on a btrfs
> filesystem that has the read-only property set to true, and re-test the
> same after the property is cleared.
>
> Commit 353c2ea735e4 ("btrfs: remove redundant readonly root check in
> btrfs_setxattr_trans") removed the read-only root check from
> btrfs_setxattr_trans() under the assumption that none of its callers can
> run on a read-only root.  That assumption does not hold for the ->set_acl
> path: btrfs_set_acl() -> __btrfs_set_acl() reaches
> btrfs_setxattr_trans() directly, bypassing the handler-level read-only
> checks that were later (re)added by commit b51111271b03 ("btrfs: check
> if root is readonly while setting security xattr").  As a result, ACLs
> could still be set or removed on a read-only subvolume, bypassing the RO
> protection that applies to every other xattr.

You don't need to explain this in a test case, those are details for
the kernel patch...

Just say what the test does and that it exercises a bug fixed by a
kernel patch that has the subject:

     "btrfs: check if root is readonly when setting posix acl"

>
> The restoring kernel fix adds the read-only check directly to
> btrfs_set_acl().  This test complements btrfs/275, which covers the
> generic ->setxattr path.
>
> The test exercises the set, get and remove cycle of an access ACL on a
> regular file, and expects all modifications to fail with EROFS while the
> subvolume is read-only, then succeed once it is writable again.
>
> Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
> ---
> Changes from v1:
>
> - fix copywrite header
> - better wording for commit message
>
> Sorry for bothering.
>
> ---
>  tests/btrfs/353     | 97 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/353.out | 39 ++++++++++++++++++
>  2 files changed, 136 insertions(+)
>  create mode 100755 tests/btrfs/353
>  create mode 100644 tests/btrfs/353.out
>
> diff --git a/tests/btrfs/353 b/tests/btrfs/353
> new file mode 100755
> index 00000000..586f722a
> --- /dev/null
> +++ b/tests/btrfs/353
> @@ -0,0 +1,97 @@
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
> +# subvolume and thus bypassed the RO protection.  Such modifications mus=
t
> +# fail with EROFS, just like any other xattr.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick acl attr
> +
> +. ./common/filter
> +. ./common/attr
> +
> +# TODO: fill in the kernel commit hash that fixes the ->set_acl path onc=
e
> +# it is merged.
> +# _fixed_by_kernel_commit <HASH> \
> +#      "btrfs: check if root is readonly when setting posix acl"

That's not how we handle patches not yet in Linus' tree.
First don't comment it, second use xxxxxxxxxxxx for the hash.
Like this:

_fixed_by_kernel_commit xxxxxxxxxxxx \
     "btrfs: check if root is readonly when setting posix acl"

We normally find and update tests that need the hash by greping with
something like:  egrep -ri 'commit xxxxx' tests/



> +
> +_require_acls
> +_require_btrfs_command "property"
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full 2>&1

Nowadays we have the practice of also adding:   || _fail "mkfs failed"

> +_scratch_mount
> +
> +FILENAME=3D$SCRATCH_MNT/foo

Don't use upper case variable names.

With that fixed:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.


> +
> +set_acl()
> +{
> +       local perm=3D$1
> +
> +       # Use -n so setfacl does not recalculate the mask, keeping the
> +       # golden output deterministic regardless of the named user's
> +       # permissions.
> +       setfacl -n -m u:$acl2:$perm,m::rwx $FILENAME 2>&1 | _filter_scrat=
ch
> +}
> +
> +get_acl()
> +{
> +       getfacl --absolute-names -n $FILENAME | _filter_scratch | _getfac=
l_filter_id
> +}
> +
> +del_acl()
> +{
> +       setfacl -b $FILENAME 2>&1 | _filter_scratch
> +}
> +
> +_acl_setup_ids
> +
> +# Create a test file.
> +echo "hello world" > $FILENAME
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
> +status=3D0
> +exit
> diff --git a/tests/btrfs/353.out b/tests/btrfs/353.out
> new file mode 100644
> index 00000000..66f4a0e5
> --- /dev/null
> +++ b/tests/btrfs/353.out
> @@ -0,0 +1,39 @@
> +QA output created by 353
> +ro=3Dtrue
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
> +ro=3Dfalse
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
