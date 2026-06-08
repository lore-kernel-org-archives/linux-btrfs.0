Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CA53546F2
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917336; cv=none; b=ZyHjiaQfBMLmeM0+JYrEm4Dklf5S08sGOo1MgExco/lCcQn+DMcKbdAtyxLJQiRYDiqWEZSoI4EMoneqJQ416SvxJOlJKWXitt4hDFPOJeOLp17sWHf8XB3xlgLEvPNs68Kc9f6FfnKSmEw7MxfalNNbTVXmKEjkb/VeDHn8/G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917336; c=relaxed/simple;
	bh=6C4vf6/4eJnFLgUknBfwGqxMCeXJz13ApUu8OTMzxvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=apFCR50tNgP7IOigy/YPJEUGfxOcgejmwpqO/K8rq98tkFU64IoxH95N+lvHNQCrV52z0d+Pb8k0zlJbx11K4WafzgR1/PufTN8EpL1m5uBtjk4nR8Y+XI+OAeJcmAhAN0i1xsQm/ijCD+8+IEwWCCrYUPlKdsqlGJxcKnC/Ox0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EqaLzd0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EqaLzd0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0E81F00898
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917335;
	bh=2w12NF8MfSTYvghNfM3bvkVu+GohbriHOUO2f+1dcZ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EqaLzd0Zd4u8SHlwTnQb4ZMHI2Ur+cYmTebdKBdsA4wMRxsI/i2PsgyHG7ZbxICwY
	 Njld5GEA8KwVdSLWLkjG5/I9Iy3z/eb1ABiZJWtsVrfzxDvhl+IaXzAGT2YJxg/5BS
	 eqrV6LGqT+NnpLp7CCkzDu8PfcJhR7ko6UOu0UKxARruH+/offIyFlXT774M7pUmnO
	 iN0U0dzIli/oVlVxKBWa2DHxKKd7wM+OH0MLY5zt4+1z0vM4wna1WXxBIgBgB+OhXE
	 z3FGEv2JYYkz8UqExxlmLaychEMqo0kpXzPUgBk4A4T2qyOx2VHpcYVhAvXwL+4UCu
	 ccZ589zCuoGvw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bf84a2b2077so33734666b.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 04:15:35 -0700 (PDT)
X-Gm-Message-State: AOJu0YzcBDstcgvl03fvKG6AIp9lCbIxiMQ1RVETB4JLwQzy0mLaDS98
	oMOoHvQbe2Gz0zfFevO3pnFdX+LUvUW7ERifP7pSfBoUyFbCnbd9YLQXBjCd/7N0XiCbQ3U8i9k
	yXST4FIorR8aRhqUbs3uijlf2Urbh4QQ=
X-Received: by 2002:a17:907:c08c:b0:bd5:151d:2d31 with SMTP id
 a640c23a62f3a-bf3715535d5mr721174966b.13.1780917333782; Mon, 08 Jun 2026
 04:15:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e0be9c192cf8896a7f02ae23880f8e4921102129.1780912039.git.wqu@suse.com>
In-Reply-To: <e0be9c192cf8896a7f02ae23880f8e4921102129.1780912039.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 8 Jun 2026 12:14:56 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4SXDUCsKrLK27GwT0itbSd_aozt5A2TvVR5e34gZD51w@mail.gmail.com>
X-Gm-Features: AVVi8CdrzbCXYbSxRa2KRM4SpGf04e7oxa9jCLUj3H2I0hv9RRxIgLg_BCyjLJs
Message-ID: <CAL3q7H4SXDUCsKrLK27GwT0itbSd_aozt5A2TvVR5e34gZD51w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: do not overwrite NODATASUM flag when removing
 NODATACOW flag
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 10:49=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
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
> The direct cause is that after "chattr +S", the btrfs inode will lost its

will lost -> will lose

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
> [FIX]
> Do not remove NODATASUM flag when FS_NOCOW_FL is not set.
>
> However this will introduce a problem related to "chattr +C" then
> "chattr -C" on zero sized files.
>
> Previously such operations will revert to inode flags 0, but now it will
> revert to inode flags NODATASUM.
> This is due to the fact that we have no way to change NODATASUM flag but
> only through mount options.
>
> I know this is not ideal, but at least "chattr +S" removing unrelated
> flags looks more serious and more like a bug.
>
> So here I'm fine to slightly change the behavior of "chattr -C".

I'm not sure what's best here or how common this use case is and I
wonder how it might affect users.
I agree it's better to not remove the nodatasum flag, the only concern
is if it affects existing user workflows.
I can only guess it's very rare.

>
> Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file vi=
a ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ioctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d4981d2a42d7..74849a4208b5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -336,8 +336,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>                  */
>                 if (S_ISREG(inode->vfs_inode.i_mode)) {
>                         if (inode->vfs_inode.i_size =3D=3D 0)
> -                               inode_flags &=3D ~(BTRFS_INODE_NODATACOW =
|
> -                                                BTRFS_INODE_NODATASUM);
> +                               inode_flags &=3D ~BTRFS_INODE_NODATACOW;
>                 } else {
>                         inode_flags &=3D ~BTRFS_INODE_NODATACOW;
>                 }

This can now be simplified:

if (!S_ISREG(inode->vfs_inode.i_mode) || inode->vfs_inode.i_size =3D=3D 0)
    inode_flags &=3D ~BTRFS_INODE_NODATACOW;

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> --
> 2.54.0
>
>
