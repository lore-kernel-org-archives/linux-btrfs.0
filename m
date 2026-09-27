Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C6137DE8D;
	Sun, 27 Sep 2026 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790509451; cv=none; b=ixuC7R4OeFYNK386yZD56Mdczj5wmPqHEOlnB7r45zovtLAH3YRy5ZktT248KcfgUPKAKIHozYdOhdD7as9nkrN3h57uAn14lHKfRZOlcZldsPOA8SVBOJOTt57ilhAb1C9OK5GXxqbXD7cpv2/NPvnLwuBKJvvfC3Vm+V/6vdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790509451; c=relaxed/simple;
	bh=grUnnrpmj7P9ZpajDjsdApm2vvg4P64KbcC5aWOOfwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCEtF4u9qMl8W1Pm1sBvJtZqc+pNNNzH1jnpn9ehSfRX/y+mndM1zPBRfJa+DIFc7wgeT0dYm7BodDiRtz+Nbgh+gCrXByBO9LQYA16fDQDdqFCPAH7mpHGMRhGOSijWzWO1GDSrSkGJMstz0VT6plzvRGbCy1LrgsmVYuGXy78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flh7eVne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flh7eVne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98B41F000FF;
	Sun, 27 Sep 2026 11:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790509449;
	bh=PVsqUaDCBkcMKFA40RfomO9m0tbOmNe96AwQlkrcTtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=flh7eVnebxc79LLOSveyzXkyvyBULs0qiuZQwclNVi/Zt8aRx4qlpsfch2TTRtsFA
	 BY+1/xD42ZD/dHKo+gtoQv79geH20Dbch4dI1NhCnA7MFO/WUne30BYmnWIdKjk3DP
	 d5ZaZUdeZyLBEbqJ1sVDMl/Vz1IM1oPIrSRFz1cyF/p8XulDFVs+8t0mItJKl7DOcS
	 lqmG2Lscev9sYyhm4+jbEM/2ZnuIsg5rfYT2qRLD7z8fTMi2w2OxNTmtWY0CB6Y8z1
	 mZpxzB/A8F5YvGE5BvP7DhFkBpO0w4z48mCtZoqbo4eaeGeNCvE/DJGtbU9CMB4Ogh
	 OhXa8FSsKdK8g==
Date: Sun, 27 Sep 2026 19:44:02 +0800
From: Zorro Lang <zlang@kernel.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: test replacing a xattr with a larger value
Message-ID: <arkBaZIY8xt0iSgI@zlang-mailbox>
Mail-Followup-To: Filipe Manana <fdmanana@kernel.org>, 
	Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
 <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com>
 <a76bf043-e379-4e7a-883b-cd2bfc1a5c05@suse.com>
 <CAL3q7H6NE1VyYffJj5rdZGdmU2FQz5i_wv7oF8ZhQqRq8eOuXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H6NE1VyYffJj5rdZGdmU2FQz5i_wv7oF8ZhQqRq8eOuXQ@mail.gmail.com>

On Sat, Sep 26, 2026 at 07:19:46PM +0100, Filipe Manana wrote:
> On Sat, Sep 26, 2026 at 6:58 AM Qu Wenruo <wqu@suse.com> wrote:
> >
> >
> >
> > 在 2026/9/26 02:46, fdmanana@kernel.org 写道:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Test that replacing a xattr's value with a larger value works. This is a
> > > test that exercises a specific scenario on btrfs where two xattrs are
> > > stored in the same item, and for that to happen their names must result
> > > in the same crc32c hash.
> > >
> > > This was recently fixed by the following patch:
> > >
> > >    "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >
> > Missing the "---" line, which makes b4 include the digest and changelog.
> 
> Looks like I may have accidentally deleted it.
> Maybe Zorro can add it when he picks the patch.

Sure, done!

> 
> Thanks.
> 
> >
> > Otherwise looks good to me.
> >
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> >
> > Thanks,
> > Qu
> >
> > >
> > > V2: Fix missing _ on _fixed_by_fs_commit call.
> > >
> > >   tests/generic/806     | 43 +++++++++++++++++++++++++++++++++++++++++++
> > >   tests/generic/806.out | 11 +++++++++++
> > >   2 files changed, 54 insertions(+)
> > >   create mode 100755 tests/generic/806
> > >   create mode 100644 tests/generic/806.out
> > >
> > > diff --git a/tests/generic/806 b/tests/generic/806
> > > new file mode 100755
> > > index 00000000..1fcf0145
> > > --- /dev/null
> > > +++ b/tests/generic/806
> > > @@ -0,0 +1,43 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 806
> > > +#
> > > +# Test replacing a xattr's value with a larger value.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick metadata attr
> > > +
> > > +. ./common/filter
> > > +. ./common/attr
> > > +
> > > +_require_scratch
> > > +_require_attrs
> > > +
> > > +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> > > +   "btrfs: fix xattr replace when multiple xattrs are packed in the same item"
> > > +
> > > +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> > > +_scratch_mount
> > > +
> > > +touch $SCRATCH_MNT/testfile
> > > +
> > > +# Add two xattrs that, on btrfs, have the same hash (crc32c) for their name
> > > +# and therefore are packed into the same btrfs_dir_item.
> > > +$SETFATTR_PROG -n user.foobar -v 123 $SCRATCH_MNT/testfile
> > > +$SETFATTR_PROG -n user.WvG1c1Td -v qwerty $SCRATCH_MNT/testfile
> > > +
> > > +# Verify the xattrs are present.
> > > +echo "xattrs before:"
> > > +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
> > > +
> > > +# Now replace the value of the foobar xattr with a significantly larger value.
> > > +$SETFATTR_PROG -n user.foobar -v abcdefghijklmnopqrstuvwxyz $SCRATCH_MNT/testfile
> > > +
> > > +# Check the xattrs have the expected values.
> > > +echo "xattrs after:"
> > > +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scratch
> > > +
> > > +# success, all done
> > > +_exit 0
> > > diff --git a/tests/generic/806.out b/tests/generic/806.out
> > > new file mode 100644
> > > index 00000000..620a953e
> > > --- /dev/null
> > > +++ b/tests/generic/806.out
> > > @@ -0,0 +1,11 @@
> > > +QA output created by 806
> > > +xattrs before:
> > > +# file: SCRATCH_MNT/testfile
> > > +user.WvG1c1Td="qwerty"
> > > +user.foobar="123"
> > > +
> > > +xattrs after:
> > > +# file: SCRATCH_MNT/testfile
> > > +user.WvG1c1Td="qwerty"
> > > +user.foobar="abcdefghijklmnopqrstuvwxyz"
> > > +
> >
