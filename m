Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793773392;
	b=x2ZX45PBFsX9k5QNzp+K3OHUfw+y500nAKt6GIBjdWRjO2CmMLgLPIftBeF6aR/nktJS
	 or1eAbM5V/z20QgOsm/KPbSo/lWPGif5bYTmZNiVKI1wu08oOyuB1tH8Ax9e4BShyfhRr
	 ovAPugBOFTMreOEoEQ5U0pdAaWJ0CXFDyAVFrHEhDyTYR6PeheAkbS2NLHO8YLYVuHIzv
	 uIiF+9Gm7vK1EB0wbYaUIu2dc0aMe9ORYXiZCUHTazg3qGlE1XeXCBzLQL8tCTCbaxQjO
	 g+cafG2ofBVS6y3reVvaCncx8vneRvrPz32XK8bAdtZutpMvPUywsqXUMWUpKVn0Rxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793773392;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=TkkipuRHglZISv6QaoBuPAhIdxbeLfpVHPZho14mPmc=;
	b=pWDA5Fg2JisSa5D2ZDFjKaUzIBnMkxV4NHkQLdAjn+sd+QmWu06k17WyXc7R+XAMus6O
	 OOOexff/HkWlTGS8yLZF869PyKP4KSQt1Airs6hg8+/u/XZ34ke8turXL/BNesYAGL8JC
	 qn4Vlu5/aOSLwoddWtfHt3oNzilld8YpylxPkxBrNFC+bubFhuUryKxToD9C9uqe/yYKR
	 r1R3JT/qYWzzn6ZBTmlCQ5isfw+W6D8v3lwuwjRPCy5BsA/UF5dPIR1d2zJM/gHc3WXpc
	 /ilMF6djjVdhFrXm5MVxUnZRs9iWjbE9kkRg3Haq28/HIpnJKe5iqpymn9J8cNO/NSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2VubMzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A6606A31B;
	Wed,  4 Nov 2026 06:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2VubMzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133311F000C1;
	Wed,  4 Nov 2026 06:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773392;
	bh=TkkipuRHglZISv6QaoBuPAhIdxbeLfpVHPZho14mPmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U2VubMzBHP31traQIhNFFT0l0qiClH5gOATHqqOSepw/Gs3iNfW+Jp1/uIKFS3HVy
	 7TOzAzk1G4AnxTvT+YhXEWwQeDtj6mEdOOTM1YxQ2yuNOF4VUqBl994mKVQ7L20WLv
	 MxjZ2J50AHca2Ne+vza00XMqbgtilaWO0b5fIhQ8bKl7WakzbHQMoA5khJFlfIGYZx
	 zo22DTba6miSpBOCW02MD2nPqke1YsdEd2yd7Lx31b4gROL3hDDhrRkBm98hxY/z7c
	 UjUVPhgVDrEqo71a2h9jpeJ80nmG8lFp3tcUIHJNiaRaY8mca7lJaQvSK3Y1DV3rmH
	 lR9CxBa9L2pNQ==
Date: Wed, 4 Nov 2026 14:23:04 +0800
From: Zorro Lang <zlang@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: test compression attribute on filesystems mounted
 with nodatacow
Message-ID: <aurOsMiyb2pP43eH@zlang-mailbox>
Mail-Followup-To: fdmanana@kernel.org, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <19d06a11c66590ec2a053781c79bf00e39361a70.1793648537.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d06a11c66590ec2a053781c79bf00e39361a70.1793648537.git.fdmanana@suse.com>

On Mon, Nov 02, 2026 at 07:57:17PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we mount a filesystem with "-o nodatacow", set the
> compression attribute on a directory and then create a file under it, the
> file should inherit compression and setting an additional attribute (like
> +A, write append mode) should work.
> 
> This exercises a bug fixed by the following kernel patch:
> 
>   btrfs: dont propagate nodatacow mount option on files with inherited compression
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

This test case is simple and good enough,

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/btrfs/364     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/364.out |  5 +++++
>  2 files changed, 50 insertions(+)
>  create mode 100755 tests/btrfs/364
>  create mode 100644 tests/btrfs/364.out
> 
> diff --git a/tests/btrfs/364 b/tests/btrfs/364
> new file mode 100755
> index 00000000..d59e1cab
> --- /dev/null
> +++ b/tests/btrfs/364
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 364
> +#
> +# Test that if we mount a filesystem with "-o nodatacow", set the compression
> +# attribute on a directory and then create a file under it, the file should
> +# inherit compression and setting an additional attribute (like +A, write append
> +# mode) should work.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick compress fiemap
> +
> +. ./common/filter
> +. ./common/punch # for _filter_fiemap_flags
> +
> +_require_xfs_io_command "fiemap"
> +_require_chattr c
> +_require_chattr A

I'll squash these two lines into one when merging (as David mentioned).

> +_require_scratch
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: dont propagate nodatacow mount option on files with inherited compression"
> +
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount "-o nodatacow"
> +
> +# Create a directory with the compression attribute, so that all files created
> +# under it inherit the compression attribute.
> +mkdir $SCRATCH_MNT/dir
> +$CHATTR_PROG +c $SCRATCH_MNT/dir
> +
> +# Now create a file with some data inside the directory.
> +$XFS_IO_PROG -f -c "pwrite 0 128K" $SCRATCH_MNT/dir/foo | _filter_xfs_io
> +
> +# Now try to make the file append only, it should work.
> +$CHATTR_PROG +A $SCRATCH_MNT/dir/foo
> +
> +# A fiemap should report an encoded extent, which means it's compressed.
> +echo "Fiemap output:"
> +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/dir/foo | _filter_fiemap_flags 1
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/btrfs/364.out b/tests/btrfs/364.out
> new file mode 100644
> index 00000000..205d5ca2
> --- /dev/null
> +++ b/tests/btrfs/364.out
> @@ -0,0 +1,5 @@
> +QA output created by 364
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Fiemap output:
> +0: [0..255]: encoded|last
> -- 
> 2.53.0
> 
> 
