Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1A93DD522
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484798; cv=none; b=MuFaX2l2IRFPj6grhvQppkcMJZ4yGLXHAt8lrk9fFcUs+D6TlwOGJTudhp3OJ2maP0PV1fohqqGehushjJHM/6FLXyslpxUPLiB8XJmDhxykgRKIJWGS0vWC+bmSLtBTF7o67M63TTeOVPBGhHj78upqjjTzss+tYPbczDXDnnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484798; c=relaxed/simple;
	bh=MokpD9HepXX8dM27xnqptcSpwA3CZ7fsGD+AzLYoPSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e6RAhJnknDeTFnRL2Yoys0Nng3RPj5HQxNSK5XUe1xlm92Cc2+px2v4gsY2hhpkMjg/LtkibbtAwyrFIgLgt+9bBKTVpHHHeNi5Q1C7YCruaFTyQmcdbDhcj7Fjs4gLt6edo4Wpugc1gN4cyfk6JoCtfDKS787x/fnsbSUe/Kbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8fAFqvn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8fAFqvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7025F1F000FF
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484796;
	bh=27aLuGp91Uyti5BzrexLrNlw4BDHdbUU8zXPfXmlnq0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q8fAFqvnWQLR8WeeK4N6lbguD0nGJwoOooPSEMJkiA6llAI4QctbUnkxrcD7io1uJ
	 F0LWvC+wZLmCKzqcM6MXzPiA2AQCYOgoR85PpQZAW59rapNWSeJh0awXYBxVS2F3Ez
	 87FgpPaeS7jEOfhf+BdcIFwakR2pPsS7XnJi2Q8PCcadLZvyCjLM1oNQPno3lY4XOD
	 dHTTiG+1h8J1FHjI5PphAuELKK+WNgVl5ngx67+XPGNPJxmIKanTLRiMwY9f8MjNdk
	 OJZ5A7qqWWzVwvubHQ2zGemf/MHpWSdqjh1GWUGfeObgMPz9MuU6YnngT6soqqleg0
	 vZtGGsBm6R/Lg==
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c2c08ff3f8so2271676b6e.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 08:06:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxchIwvBiWx70KNveI2QvttpdNs/DMUrnnpgN24Jc+9KbLuWwWg70OiTnpak5ZaPPzgARMj5kJe16Jc+Q==@vger.kernel.org
X-Gm-Message-State: AFuF++n0CZEr25w8tLSMJdGWqG6Pr07iPK1Nllnj5bM0/Sw7ygoAmra2
	cUtFFhf3BEkW/vtUMqwxF58KslGJ+9Nkw6kzvmG4aNYG7ugeOa1Bf2Jej5K7BrLfsNt7hOQRZ9O
	qiIhza3xAyLK1CJrz8KpwPgUk6LJri2c=
X-Received: by 2002:a05:6808:15a2:b0:4a3:fefb:899b with SMTP id
 5614622812f47-4c7b2dfaebamr5326613b6e.7.1789484795649; Tue, 15 Sep 2026
 08:06:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <83e3a8678c5eafb1cfcf10741a53b6e586cd72d8.1789408399.git.fdmanana@suse.com>
 <20260915214431.72728a7a.ddiss@suse.de>
In-Reply-To: <20260915214431.72728a7a.ddiss@suse.de>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 15 Sep 2026 16:05:58 +0100
X-Gmail-Original-Message-ID: <CAL3q7H40TjYdmh=3jJ7kz9vYE-cbgEMDmRwKM-Ddzju+3hGvOQ@mail.gmail.com>
X-Gm-Features: AcwNN1U-h-7Xh1evQP-bfS1VK5Tbg3jnyF6Z9bvSclyqPhPjchq0SP1uNwFpPLM
Message-ID: <CAL3q7H40TjYdmh=3jJ7kz9vYE-cbgEMDmRwKM-Ddzju+3hGvOQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test that we don't create pointless compressed
 inline extents
To: David Disseldorp <ddiss@suse.de>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 12:45=E2=80=AFPM David Disseldorp <ddiss@suse.de> w=
rote:
>
> On Mon, 14 Sep 2026 18:54:23 +0100, fdmanana@kernel.org wrote:
>
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Verify that we don't create compressed inline extents when the compress=
ed
> > data size is not smaller than the uncompressed data size.
> >
> > This exercises a regression introduced in kernel 7.1 and that is fixed =
by
> > the following patch:
> >
> >   "btrfs: fix creation of compressed inline extents that don't save spa=
ce"
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Looks good and works for me:
> Reviewed-by: David Disseldorp <ddiss@suse.de>
>
> A couple of minor nits below...
>
> > ---
> >  tests/btrfs/354     | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/354.out |  2 ++
> >  2 files changed, 46 insertions(+)
> >  create mode 100755 tests/btrfs/354
> >  create mode 100644 tests/btrfs/354.out
> >
> > diff --git a/tests/btrfs/354 b/tests/btrfs/354
> > new file mode 100755
> > index 00000000..801dc587
> > --- /dev/null
> > +++ b/tests/btrfs/354
> > @@ -0,0 +1,44 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> > +#
> > +# FS QA Test 354
> > +#
> > +# Verify that we don't create compressed inline extents when the compr=
essed
> > +# data size is not smaller than the uncompressed data size.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick compress
> > +
> > +. ./common/filter
> > +
> > +_fixed_by_kernel_commit xxxxxxxxxxxx \
> > +     "btrfs: fix creation of compressed inline extents that don't save=
 space"
> > +
> > +_require_scratch
> > +_require_btrfs_command inspect-internal dump-tree
> > +
> > +algo_list=3D($(_btrfs_compression_algos))
> > +for algo in ${algo_list[@]}; do
> > +     _scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
> > +     _scratch_mount "-o compress=3D$algo"
> > +
> > +     echo 'a file with test content' > $SCRATCH_MNT/foobar
> > +     _scratch_unmount
> > +     _check_scratch_fs
> > +
> > +     extent_size=3D$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 =
$SCRATCH_DEV | \
> > +           grep 'inline extent' | \
> > +           $AWK_PROG '{ for (i =3D 1; i < NF; i++) if ($i ~ /^size$/) =
print $(i + 1) }')
> > +     ram_size=3D$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SC=
RATCH_DEV | \
> > +                grep 'inline extent' | \
> > +                $AWK_PROG '{ for (i =3D 1; i < NF; i++) if ($i ~ /^ram=
_bytes$/) print $(i + 1) }')
> > +
> > +     if [ "$extent_size" -gt "$ram_size" ]; then
> > +             echo "inline extent size ($extent_size) greater than ram_=
size ($ram_size) for algo $algo"
> > +     fi
>
> It might be a little nicer to avoid multiple dumps and do the check in
> awk. The following works for me, feel free to squash in...

Integrated in v2, thanks.

>
> diff --git a/tests/btrfs/354 b/tests/btrfs/354
> index 801dc587..e744b945 100755
> --- a/tests/btrfs/354
> +++ b/tests/btrfs/354
> @@ -27,18 +27,20 @@ for algo in ${algo_list[@]}; do
>         _scratch_unmount
>         _check_scratch_fs
>
> -       extent_size=3D$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 =
$SCRATCH_DEV | \
> -             grep 'inline extent' | \
> -             $AWK_PROG '{ for (i =3D 1; i < NF; i++) if ($i ~ /^size$/) =
print $(i + 1) }')
> -       ram_size=3D$($BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SC=
RATCH_DEV | \
> -                  grep 'inline extent' | \
> -                  $AWK_PROG '{ for (i =3D 1; i < NF; i++) if ($i ~ /^ram=
_bytes$/) print $(i + 1) }')
> -
> -       if [ "$extent_size" -gt "$ram_size" ]; then
> -               echo "inline extent size ($extent_size) greater than ram_=
size ($ram_size) for algo $algo"
> -       fi
> +       $BTRFS_UTIL_PROG inspect-internal dump-tree -t 5 $SCRATCH_DEV | \
> +               tee -a $seqres.full | \
> +               $AWK_PROG -v algo=3D"$algo" '
> +                       /inline extent/ {
> +                               for (i =3D 1; i < NF; i++) {
> +                                       if ($i ~ /^size$/)
> +                                               extent_size =3D $(i + 1)
> +                                       if ($i ~ /^ram_bytes$/)
> +                                               ram_size =3D $(i + 1)
> +                               }
> +                               if (extent_size > ram_size)
> +                                       printf "inline extent size (%d) g=
reater than ram_size (%d) for algo %s\n", extent_size, ram_size, algo
> +                       }'
>
> > +done
> > +
> > +# success, all done
>
> Delete the line above, as we get here on failure too.
>
> > +echo "Silence is golden"
> > +_exit 0
> > diff --git a/tests/btrfs/354.out b/tests/btrfs/354.out
> > new file mode 100644
> > index 00000000..8bc7ecf6
> > --- /dev/null
> > +++ b/tests/btrfs/354.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 354
> > +Silence is golden
>
