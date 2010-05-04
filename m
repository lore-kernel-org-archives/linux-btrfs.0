From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 2/2] Fix version.sh to work with dash
Date: Tue, 4 May 2010 10:33:07 -0700
Message-ID: <j2i93cdabd21005041033qe369ff0dw788cbba0ac981187@mail.gmail.com>
References: <20100504161201.3720.37609.stgit@localhost.localdomain>
	 <20100504161207.3720.32821.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100504161207.3720.32821.stgit@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patch, I will resend a fixed one.

On Tue, May 4, 2010 at 9:12 AM, Mike Fedyk <mfedyk@mikefedyk.com> wrote=
:
>
> ---
>
> =C2=A0fs/btrfs/version.h =C2=A0| =C2=A0 =C2=A06 +++---
> =C2=A0fs/btrfs/version.sh | =C2=A0 16 ++++++++--------
> =C2=A02 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/version.h b/fs/btrfs/version.h
> index 9bf3946..12f7e5c 100644
> --- a/fs/btrfs/version.h
> +++ b/fs/btrfs/version.h
> @@ -1,4 +1,4 @@
> -#ifndef __BTRFS_VERSION_H
> -#define __BTRFS_VERSION_H
> -#define BTRFS_BUILD_VERSION "Btrfs"
> +#ifndef __BUILD_VERSION
> +#define __BUILD_VERSION
> +#define BTRFS_BUILD_VERSION "Btrfs 2010-05-04_08:46:49_-0700_ea1dcb3=
-dirty"
> =C2=A0#endif
> diff --git a/fs/btrfs/version.sh b/fs/btrfs/version.sh
> index a4576f2..0733eef 100755
> --- a/fs/btrfs/version.sh
> +++ b/fs/btrfs/version.sh
> @@ -1,4 +1,4 @@
> -#!/bin/bash
> +#!/bin/dash
> =C2=A0#
> =C2=A0# determine-version -- report a useful version for releases
> =C2=A0#
> @@ -8,10 +8,10 @@
>
> =C2=A0v=3D"v0.16"
>
> -which git &> /dev/null
> -if [ $? =3D=3D 0 ]; then
> - =C2=A0 =C2=A0git branch >& /dev/null
> - =C2=A0 =C2=A0if [ $? =3D=3D 0 ]; then
> +which git 2>&1 > /dev/null
> +if [ $? -eq 0 ]; then
> + =C2=A0 =C2=A0git branch 2>&1 > /dev/null
> + =C2=A0 =C2=A0if [ $? -eq 0 ]; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0v=3D"`git show=
 --format=3D'%ci_%h'|head -n 1|sed 's/[^a-z0-9_-:]/_/ig'`"
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# Are there un=
committed changes?
> @@ -19,7 +19,7 @@ if [ $? =3D=3D 0 ]; then
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if git diff-in=
dex --name-only HEAD | \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
grep -v "^scripts/package" \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
| read dummy; then
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v=3D=
"$v"-dirty
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 v=3D=
"${v}-dirty"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi
> =C2=A0 =C2=A0 fi
> =C2=A0fi
> @@ -29,9 +29,9 @@ echo "#define __BUILD_VERSION" >> .build-version.h
> =C2=A0echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-versi=
on.h
> =C2=A0echo "#endif" >> .build-version.h
>
> -diff -q version.h .build-version.h >& /dev/null
> +diff -q version.h .build-version.h 2>&1 > /dev/null
>
> -if [ $? =3D=3D 0 ]; then
> +if [ $? -eq 0 ]; then
> =C2=A0 =C2=A0 rm .build-version.h
> =C2=A0 =C2=A0 exit 0
> =C2=A0fi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
