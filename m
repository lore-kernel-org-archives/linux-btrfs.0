Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732C91DED42;
	Fri, 25 Sep 2026 20:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790366759; cv=none; b=dpSqZZKEQtsnrIThHPS7g3KP9X7+WIW658QAD2nxwSME2n+jDC6lONNOTB5HpE4bi1UpZd4uv1c5630P2ahNzP7g7YXg4YTyfVv+h+ViH2WuJd/dOh657dv4rTob2ec+SGXyO15ZwgFM0EDKEcp2qVGmnGC7NUBZ5bsyCAPP16s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790366759; c=relaxed/simple;
	bh=l3ThGiJMgb9rhho1E3w4d7JnOgAw3D/u44OfMM7zZkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UxB/iQ68BVf53wlQlxLmPmLWB3X0LLVKie7ioE0vNpgCridccGuIB9f+yov9n713CY2lN/m9J/AydlYV7Vtlqmtywlq7XUxPrHpinOvKz8U7LUtff5F4j3a07U51W/mNbea8QEqX+8b+RhqFJm5k76FoPyFNyr3keVbQYCeSqxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWYZEVPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWYZEVPP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 135FE1F000FF;
	Fri, 25 Sep 2026 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790366758;
	bh=fp0fe0FsrKQjjUZo12CazaHcaNLawPYrmwzj2EW6jsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cWYZEVPPSijyH/82gHfO7Rua92G4qyWpQrj8amr+cjrpVzjyZlhUap6SdwUOgXMpJ
	 rEH1/tUZuTmZsjp1ss1ne3cxno1LMhuHruZJ4jEantwp7R86hIogkrca/XuT5U8VJX
	 MGZfz63OPX7BWc7wHQhN/efWhO4syfKex4asquzq6X6rMwORsF745h8cSO7SV7dRmx
	 +p8C3+chBqgEKxiMHQ/q7uSMjA8U5ff2VgShokcK9FlvCbnwoXp6WjtOtj7vWGfnpd
	 uiFuNT/gp3zB4nZbwmGuKhZvHmMyPn984sLtfzzYMCT3pp1X7GGUsqdPE+WFb+UAuI
	 2IwaRIFNvygBw==
Date: Fri, 25 Sep 2026 13:05:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: test replacing a xattr with a larger value
Message-ID: <20260925200557.GP6253@frogsfrogsfrogs>
References: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
 <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com>

On Fri, Sep 25, 2026 at 06:16:36PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that replacing a xattr's value with a larger value works. This is a
> test that exercises a specific scenario on btrfs where two xattrs are
> stored in the same item, and for that to happen their names must result
> in the same crc32c hash.
> 
> This was recently fixed by the following patch:
> 
>   "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> V2: Fix missing _ on _fixed_by_fs_commit call.
> 
>  tests/generic/806     | 43 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/806.out | 11 +++++++++++
>  2 files changed, 54 insertions(+)
>  create mode 100755 tests/generic/806
>  create mode 100644 tests/generic/806.out
> 
> diff --git a/tests/generic/806 b/tests/generic/806
> new file mode 100755
> index 00000000..1fcf0145
> --- /dev/null
> +++ b/tests/generic/806
> @@ -0,0 +1,43 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 806
> +#
> +# Test replacing a xattr's value with a larger value.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metadata attr
> +
> +. ./common/filter
> +. ./common/attr
> +
> +_require_scratch
> +_require_attrs
> +
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +   "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
> +
> +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +touch $SCRATCH_MNT/testfile
> +
> +# Add two xattrs that, on btrfs, have the same hash (crc32c) for their name
> +# and therefore are packed into the same btrfs_dir_item.
> +$SETFATTR_PROG -n user.foobar -v 123 $SCRATCH_MNT/testfile
> +$SETFATTR_PROG -n user.WvG1c1Td -v qwerty $SCRATCH_MNT/testfile

Heh, glad there's a test for this sort of collision thing. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +# Verify the xattrs are present.
> +echo "xattrs before:"
> +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
> +
> +# Now replace the value of the foobar xattr with a significantly larger value.
> +$SETFATTR_PROG -n user.foobar -v abcdefghijklmnopqrstuvwxyz $SCRATCH_MNT/testfile
> +
> +# Check the xattrs have the expected values.
> +echo "xattrs after:"
> +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
> +
> +# success, all done
> +_exit 0
> diff --git a/tests/generic/806.out b/tests/generic/806.out
> new file mode 100644
> index 00000000..620a953e
> --- /dev/null
> +++ b/tests/generic/806.out
> @@ -0,0 +1,11 @@
> +QA output created by 806
> +xattrs before:
> +# file: SCRATCH_MNT/testfile
> +user.WvG1c1Td="qwerty"
> +user.foobar="123"
> +
> +xattrs after:
> +# file: SCRATCH_MNT/testfile
> +user.WvG1c1Td="qwerty"
> +user.foobar="abcdefghijklmnopqrstuvwxyz"
> +
> -- 
> 2.47.2
> 
> 
