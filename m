Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F1A3438BB
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 11:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781005121; cv=none; b=h5Ny3ScIYisAhtimN3teCLM4KS8s8b7AlPjeQP2hvyDq27iGl/AzCm6NX1OQsEwz2S7PVZ4fdXna30eSkGcADvFtIP7S6vh85Z8k7xIdck9UGzKd832UXE3DHqJ5U3GKYd+wRdHepmqoeDko13/DrH7j3A/XTqCROlMdSqUzXUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781005121; c=relaxed/simple;
	bh=GVWSBR+SsvE//CeK2L/gom+2kHZseVhicW5nj0zjD7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ochrq5Z5Bz5BgzxkVRUyQrZMphRL9sfwpcrQ/rFJmOxJpBFuiRiTp4oBI8jeMPqXGLq1SVM1m02iPNnjj9dbIRxl3Df32ExP+qLvTx6VVoLs5wWZhBxY0WQ/RV10Y3WJ+xA9EVqC2B1jUYhgxL4p7s2oYkNwhk827JGNQ1hCoBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYXHgkk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYXHgkk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4593C1F00899
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781005120;
	bh=TUjmQFRN6GGBdwsR8vhK28iBS9rOE7wp/q/oKXbZSLo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EYXHgkk4k3jGon6MWKN8qDd0Uujk4oRgZXjdDxR/+1L5UxFsJMdO47SEjbbq8Zgfu
	 nCPcogFY2yfiSdOtYVSvlxqcKn9xeXpaDyDUP68CaBJeYBIksVLs4G77AhErRm7UMv
	 NM/Tt8ZPuHGqgrehQK5e9ihsBNqtK+eSSX9mbJvm/U5fSehXKYwqlYBTiho2LI/UH1
	 SRORFvUSTk4l2XEccMdn5rdVcV5sCZ6XDU9ZBm4yZ0rz6d6vtI1+vNZtk2irMw5ihL
	 FCl3xe5RQKr8KkkPf/8TIAMriRJPtbNK8OtZ9cf1/AFR1MFrv8v2ByNNmHpnoWqli8
	 sXhC0RhyiGr6Q==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec4639953dso980448566b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 04:38:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz7oGPlfF52QF1QO38RYZk/8tiSJP+wS6KhlX/7RJ/xQ9SlxMFP
	jvLSYzOJz+JsjzTbG+BiHRJkn16Pd2sw1xgcPe/iVoDTTwnB37Me3At7oMBLf2eDlMRueY+liZr
	D7z6TPiUF1GI5tuKeJCiDhgA+LKh1tIA=
X-Received: by 2002:a17:907:d91:b0:bed:fc51:cbbd with SMTP id
 a640c23a62f3a-bf938e24b52mr132515166b.30.1781005118733; Tue, 09 Jun 2026
 04:38:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5ab8c8dba417f4d558c6849130b3072a6b2b3574.1780960338.git.wqu@suse.com>
In-Reply-To: <5ab8c8dba417f4d558c6849130b3072a6b2b3574.1780960338.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 9 Jun 2026 12:38:01 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6PAubAM3tRoKaCbH4MtuCV4mkD=va3Vz1zSuzmkStWrg@mail.gmail.com>
X-Gm-Features: AVVi8CfGLS-Nz-FxAikvrGPYLm8yZhNnlOpoTNWENHjLFboqDg5JkXtCYVG2qSM
Message-ID: <CAL3q7H6PAubAM3tRoKaCbH4MtuCV4mkD=va3Vz1zSuzmkStWrg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: do not overwrite NODATASUM flag when removing
 NODATACOW flag
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 12:14=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [TEST FAILURE]
> The test case generic/628 will fail if MOUNT_OPTIONS is set to "-o
> nodatasum":
>
>  FSTYP         -- btrfs
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.1.0-rc4-custom+ #383 SMP PREEMP=
T_DYNAMIC Sat May 30 07:35:42 ACST 2026
>  MKFS_OPTIONS  -- -O bgt -K /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>
>  generic/628  1s ... - output mismatch (see /home/adam/xfstests/results//=
generic/628.out.bad)
>     --- tests/generic/628.out   2022-05-11 11:25:30.816666664 +0930
>     +++ /home/adam/xfstests/results//generic/628.out.bad        2026-06-0=
8 18:56:49.878542927 +0930
>     @@ -8,8 +8,9 @@
>      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
>      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
>      test reflink flag not set iflag
>     +XFS_IOC_CLONE: Invalid argument
>      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
>     -310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
>     +d41d8cd98f00b204e9800998ecf8427e  SCRATCH_MNT/b
>     ...
>
> [CAUSE]
> The direct cause is that after "chattr +S", the btrfs inode will lose its
> NODATASUM flag inherited from the mount option. E.g:
>
>  # mkfs.btrfs -f $dev
>  # mount $dev $mnt -o nodatasum
>  # touch $mnt/foobar
>  # sync
>  # btrfs ins dump-tree -t 5 $dev | grep "(257 INODE_ITEM 0) itemoff" -A 3
>         item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
>                 generation 9 transid 9 size 0 nbytes 0
>                 block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>                 sequence 1 flags 0x1(NODATASUM)
>                                      ^^^^^^^^^ Proper NODATASUM flag
>
>  # chattr +S $mnt/foobar
>  # sync
>  # btrfs ins dump-tree -t 5 $dev | grep "(257 INODE_ITEM 0) itemoff" -A 3
>         item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
>                 generation 9 transid 10 size 0 nbytes 0
>                 block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
>                 sequence 2 flags 0x20(SYNC)
>                                       ^^^^ Only the new SYNC flag
>
> This makes the inode to drop the old NODATASUM flag, meanwhile the new
> reflink destination will still inherit the NODATASUM flag.
> The mismatching NODATASUM flags will cause the reflink to fail.
>
> The root cause is that, inside btrfs_fileattr_set() if no FS_NOCOW_FL is
> set, we remove both NODATASUM and NODATACOW flag.
>
> However we should not touch NODATASUM flag, as data COW doesn't require
> checksum.
> Only NODATACOW implies NODATASUM, but DATACOW doesn't imply DATASUM.
>
> The deeper problems are:
>
> - Fileattr API is too binary
>   It either clears or sets a flag, there is no "do not change" option.
>   So that why "chattr +S" implies "chattr -C", and is forcing us to
>   change NODATACOW along with NODATASUM flag.
>
> - No way to change NODATASUM through fileattr API
>   In fact NODATASUM can only be modified through mount option.
>
> The deeper problems are much harder to attack.
>
> [FIX]
> Remove NODATACOW flag when FS_NOCOW_FL is not set, but only remove
> NODATASUM if "nodatasum" mount option is not set.
>
> This allows the existing "chattr +C" then "chattr -C" to remove
> both NODATACOW and NODATASUM flags on a default mount.
>
> But for a mount with "nodatasum" option, the NODATASUM inode flag will
> persist through either "chattr +C" and "chattr -C".
>
> Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file vi=
a ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
> Changelog:
> v2:
> - Respect the current mount option when setting DATACOW flag
>   Since there is no way to set/clear NODATASUM flag other than mount
>   option, it's better to respect the current mount option so that
>   NODATASUM is not always left unexpectedly.
> ---
>  fs/btrfs/ioctl.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d4981d2a42d7..8e3f51551dfe 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -331,14 +331,20 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>                         inode_flags |=3D BTRFS_INODE_NODATACOW;
>                 }
>         } else {
> -               /*
> -                * Revert back under same assumptions as above
> -                */
> -               if (S_ISREG(inode->vfs_inode.i_mode)) {
> -                       if (inode->vfs_inode.i_size =3D=3D 0)
> -                               inode_flags &=3D ~(BTRFS_INODE_NODATACOW =
|
> -                                                BTRFS_INODE_NODATASUM);
> -               } else {
> +               /* We can only change NODATACOW for zero-sized regular fi=
le. */
> +               if (S_ISREG(inode->vfs_inode.i_mode) && (inode->vfs_inode=
.i_size =3D=3D 0)) {
> +                       inode_flags &=3D ~BTRFS_INODE_NODATACOW;
> +                       /*
> +                        * There is no way to change NODATASUM flag throu=
gh fileattr API.
> +                        * If we unconditionally keep the current NODATAS=
UM flag,
> +                        * chattr +C then chattr -C will keep the NODATAS=
UM flag, and
> +                        * no way to remove that flag.
> +                        *
> +                        * So respect the current mount option for NODATA=
SUM flag.
> +                        */
> +                       if (!btrfs_test_opt(fs_info, NODATASUM))
> +                               inode_flags &=3D ~BTRFS_INODE_NODATASUM;
> +               } else if (!S_ISREG(inode->vfs_inode.i_mode)) {
>                         inode_flags &=3D ~BTRFS_INODE_NODATACOW;
>                 }
>         }
> --
> 2.54.0
>
>
