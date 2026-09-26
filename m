Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BF135A39D
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 18:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446824; cv=none; b=oYXlLPhASK0RlMh2ZWfuwmRlbLSgigprAofEapdCrm0O+G40hogTgmkoT4iDyYa4jleHiHgWcJe3SQSbkrRPxF+yjFfxQxa2iGt4O3tY1/S5z3+JReQASgKffyNz3QO+o8ZafAAkavtadqHODgCnYwBgpyI65/TsVfHb1YUBijM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446824; c=relaxed/simple;
	bh=qcRZven7fbk8bbcPjKM4AwemBdb1kNhneVx6fJ2lXqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bT6YGV7qWm/6W7zA4mAoMOw8daA8fh26HpSkN5K7k39ZA/KDCzpewyrQFVbhtT63a4pdtUjex98IhSTMXHE93il2tTLV0fKt4FAwDCtKe67S1KRgZGqpHiLN/dEADISAmkk9M2uy5hQx81bs3wv8z4sf4QdpRuDvn4cufQaKG3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUxg/5ZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUxg/5ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C08D1F00893
	for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790446823;
	bh=ec/TtXuJAzOm0xQ+ButyxTkwd7z0F3Q0+9qjD7iQF1Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MUxg/5ZHlHxgbGqUJKywNBUxKl8dfhuW5vyPMbb8YY18zox02v2urOzekIHBHDdgU
	 UL69kaEKJ8evy10PZ8EwmJIRZuMWMhTBhU2UkZaef/4CTPgjlohNtGIg33rcraiL7a
	 jyjPkCH8omMcmefw+b9mKu/HxVh8k9LzTGIV4aGFAuWRnJzl8tnO5/nKWAyndxMoDv
	 ml4E3E5051GIUB+RYXRqmPo8sfS9Bix0uOtSvu3FjMagAMosE2Gg3JENMqQNKKGNZ4
	 JgZcx+RIuNFe2ZecOrwxgLxy1nXvJjHp1NxUkUDJ9rUY5P7iMqQw14lP26n8QaWz9W
	 fPtXDjaMYlBEw==
Received: by mail-ua2-f42.google.com with SMTP id a1e0cc1a2514c-986e0b83340so1089726241.2
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Sep 2026 11:20:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzl9hDd9hPKtt6AVWIYthSosCtXT/UfH9E53YPUxWQAkr0VxBQ9Pr4NjqzRC/a4odH8DcIYnLrcR2fFcg==@vger.kernel.org
X-Gm-Message-State: AFuF++l9mXM1otCL9Zu3z3Oq5zZ4EmO4BSa1O+aFvfReYHVY8zUukFVs
	sivlZW2tOIXT+HO0xKtQ5taGnMbgeNq+ta0rN68HSexXYLE1zC24/b1wNOyITMk5Bkz5kLTTsMY
	ivQNpc5kTlq0m9cAFqo6DSOTHHPG7cF0=
X-Received: by 2002:a05:6102:f0b:b0:7a2:2068:6e37 with SMTP id
 ada2fe7eead31-7af1cea8396mr3850242137.15.1790446822232; Sat, 26 Sep 2026
 11:20:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8916aea263bc59af6cfb1accacc2eaf78aaffe89.1790354960.git.fdmanana@suse.com>
 <7d2caec7b8ecd95ad63fcbbc7e1cc1c84ee50d7f.1790356355.git.fdmanana@suse.com> <a76bf043-e379-4e7a-883b-cd2bfc1a5c05@suse.com>
In-Reply-To: <a76bf043-e379-4e7a-883b-cd2bfc1a5c05@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Sat, 26 Sep 2026 19:19:46 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6NE1VyYffJj5rdZGdmU2FQz5i_wv7oF8ZhQqRq8eOuXQ@mail.gmail.com>
X-Gm-Features: AclHuK_irgqd8-GiBwguKOya8rhYJlGfPwLojBwY4iAxduYC831CpNxS4lZSteI
Message-ID: <CAL3q7H6NE1VyYffJj5rdZGdmU2FQz5i_wv7oF8ZhQqRq8eOuXQ@mail.gmail.com>
Subject: Re: [PATCH v2] generic: test replacing a xattr with a larger value
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Zorro Lang <zlang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 6:58=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/9/26 02:46, fdmanana@kernel.org =E5=86=99=E9=81=93:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Test that replacing a xattr's value with a larger value works. This is =
a
> > test that exercises a specific scenario on btrfs where two xattrs are
> > stored in the same item, and for that to happen their names must result
> > in the same crc32c hash.
> >
> > This was recently fixed by the following patch:
> >
> >    "btrfs: fix xattr replace when multiple xattrs are packed in the sam=
e item"
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Missing the "---" line, which makes b4 include the digest and changelog.

Looks like I may have accidentally deleted it.
Maybe Zorro can add it when he picks the patch.

Thanks.

>
> Otherwise looks good to me.
>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
>
> Thanks,
> Qu
>
> >
> > V2: Fix missing _ on _fixed_by_fs_commit call.
> >
> >   tests/generic/806     | 43 ++++++++++++++++++++++++++++++++++++++++++=
+
> >   tests/generic/806.out | 11 +++++++++++
> >   2 files changed, 54 insertions(+)
> >   create mode 100755 tests/generic/806
> >   create mode 100644 tests/generic/806.out
> >
> > diff --git a/tests/generic/806 b/tests/generic/806
> > new file mode 100755
> > index 00000000..1fcf0145
> > --- /dev/null
> > +++ b/tests/generic/806
> > @@ -0,0 +1,43 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > +#
> > +# FS QA Test 806
> > +#
> > +# Test replacing a xattr's value with a larger value.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick metadata attr
> > +
> > +. ./common/filter
> > +. ./common/attr
> > +
> > +_require_scratch
> > +_require_attrs
> > +
> > +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> > +   "btrfs: fix xattr replace when multiple xattrs are packed in the sa=
me item"
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> > +_scratch_mount
> > +
> > +touch $SCRATCH_MNT/testfile
> > +
> > +# Add two xattrs that, on btrfs, have the same hash (crc32c) for their=
 name
> > +# and therefore are packed into the same btrfs_dir_item.
> > +$SETFATTR_PROG -n user.foobar -v 123 $SCRATCH_MNT/testfile
> > +$SETFATTR_PROG -n user.WvG1c1Td -v qwerty $SCRATCH_MNT/testfile
> > +
> > +# Verify the xattrs are present.
> > +echo "xattrs before:"
> > +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scra=
tch
> > +
> > +# Now replace the value of the foobar xattr with a significantly large=
r value.
> > +$SETFATTR_PROG -n user.foobar -v abcdefghijklmnopqrstuvwxyz $SCRATCH_M=
NT/testfile
> > +
> > +# Check the xattrs have the expected values.
> > +echo "xattrs after:"
> > +_getfattr --absolute-names --dump $SCRATCH_MNT/testfile | _filter_scra=
tch
> > +
> > +# success, all done
> > +_exit 0
> > diff --git a/tests/generic/806.out b/tests/generic/806.out
> > new file mode 100644
> > index 00000000..620a953e
> > --- /dev/null
> > +++ b/tests/generic/806.out
> > @@ -0,0 +1,11 @@
> > +QA output created by 806
> > +xattrs before:
> > +# file: SCRATCH_MNT/testfile
> > +user.WvG1c1Td=3D"qwerty"
> > +user.foobar=3D"123"
> > +
> > +xattrs after:
> > +# file: SCRATCH_MNT/testfile
> > +user.WvG1c1Td=3D"qwerty"
> > +user.foobar=3D"abcdefghijklmnopqrstuvwxyz"
> > +
>
