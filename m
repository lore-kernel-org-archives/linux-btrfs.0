Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649279;
	b=Cgb01EPWNGYRetX+snK6CLuJsijNppr++tk0Hpn3aO8x6H/RDcjiXgslS0S/K1saM2B3
	 LXX+wHPAYKbqZ25FJoJx9n8UGc6EZV1XwLwdjsmCrMmGRbXIpPtPxlfgEx7YMJOKK0WhS
	 fd9BEHX6/jYCc0cEomQWLP06Cb7r3H1cHDVxx/DBtEAGNp2eeM7FgMUcMW03GXpznJPgB
	 UCufcSmmTBvAMNmk+lTsr6E8K/r/TJMODO6wanCwebydBTwh1B5ZAEdf4UtEDNrKMN+4h
	 luBDaa/hvG1VtUDFU5lYYR16yl9Tbb/qMnVnefyU+0MLR/GxMPSkiC+GXHqK6sjePGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649279;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=HFJn1PL/jxdEzelKuDssI+0/P8V2rbdDkMUinCE0W38=;
	b=gvD4ctChmW3uXRDMLxNdHWr6w2/7GmPaltEekx+Wh6PGz6ohDLdV3eQy9vTZeQPquwfs
	 87v9NYA2B6u1o4prO4u+MdlIKZX97S8ShGkJAUp+8rY1+Z24mwpIKeb3cdYom+MIFXF3a
	 f4s9+FLKTm2Crq/yAc2IBpHUUpZP9BZ/Yf0FN8OKdUZH/aXI376rJhcm2fZrOQUbcZzb+
	 AFNhXiumq3k35HRXzkXsgDFboTA/VRAAGMy9N7BfFclJWoNY/A3RVSpe9cQKrMCjaakjf
	 fcEp+IlcKphrHIe7cwYZxblB7WMYZ3bOKfFoT+9SsijawwE34vqX/wud3d2B7NTLRDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YmqsWRTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E224F606D81D
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 19:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YmqsWRTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16F51F00A18
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 19:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793649278;
	bh=HFJn1PL/jxdEzelKuDssI+0/P8V2rbdDkMUinCE0W38=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YmqsWRTw9le8+qqgAVGSVkIHsbYgqF/eHvuKMWaHyo/ctUzDbuDAn0WX6WKiHVy/q
	 GeorTHrKSU7Z6XZqsORRL7eOTquSs2x7iUkePrFcLoLrA620+u8sn31j2pJo6o3V1C
	 EB1shPZIXHY6q4fPEl00Ho293lPUnW3w0Dx/saVrg50gl0FRk4mIWjQ+cBB1ytIquv
	 IdH7f/53rchwyCaxghpqv7Rdf6lhs/muLoGDWuLFsmPDwnrpiDLUcfH7TSvG8uAZUo
	 gwCD3KWYwYlyTIaemZhyceXivTJgV12zkcBruoArPFjIo1uCyUmhTdezibPYMetDEd
	 g1ZRnZhENU7LA==
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-98c8cbdb9daso619314241.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 11:54:38 -0800 (PST)
X-Gm-Message-State: APuU4Z88tcGO0JY1sXJVaRjm6ywrmmC17SuMKTS/nqN8h/BiFDJWSBQP
	wdjzQaZX46i7YcWNQc72UEEuCkA8ioOF+UIwF1f3RotzJlF/mKa+nFVAZMV1p7E92D4QuEaFWLN
	MC5N0swMaSP6iDbU0bH8wwUxzS47gXyI=
X-Received: by 2002:a05:6102:3707:b0:7c2:799c:9031 with SMTP id
 ada2fe7eead31-7d072d11c63mr3672265137.30.1793649277884; Mon, 02 Nov 2026
 11:54:37 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793611601.git.wqu@suse.com> <33be0954dbdf0c1abe580d422ad6bbfa6025b191.1793611601.git.wqu@suse.com>
In-Reply-To: <33be0954dbdf0c1abe580d422ad6bbfa6025b191.1793611601.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 2 Nov 2026 19:54:01 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5-kP4Ccb-bMux_Xtf-dXBE3fTD=mQMFpNZDGOc9QpGuQ@mail.gmail.com>
X-Gm-Features: AclHuK_UAqXd9jtoZ9lK8KgYhVBMi3BZ4QD6vpr9e_vptqsMlEiq8eOipRhUJag
Message-ID: <CAL3q7H5-kP4Ccb-bMux_Xtf-dXBE3fTD=mQMFpNZDGOc9QpGuQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: reject subvolume ids that do not fit into
 unsigned long
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 9:34=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> fs_roots_radix is indexed by unsigned long, so on 32-bit systems the
> subvolume id is silently truncated to 32 bits, e.g:
>
>   Subvolume 257 (0x101) and subvolume 4294967553 (0x100000101) will have
>   the same index (0x101) on 32-bit systems.
>
> Although this should be very rare, as btrfs can reuse deleted
> subvolume ids, and there are other limits like anon_dev preventing us
> from so many subvolumes.
>
> But it's still better to address such problems, since 32 bit systems are
> still widely supported by the kernel.
>
> Address such rare problem by:
>
> - Add btrfs_check_subvolid() to btrfs_insert_fs_root()
>   So that all subvolumes inserted into the fs radix tree are ensured to
>   be no larger than ULONG_MAX.
>
>   If there is a high subvolumeid, it will show an error message.
>
> - Do not search the radix tree if subvolid is is too larger
>   It's possible to pass reloc tree into btrfs_lookup_fs_root() through
>   backref walk.
>
>   And it can be very common during qgroup operations. So we don't want
>   to flood the dmesg with error messages.
>   Just silently reject such search silently, and searching tree reloc
>   tree inside btrfs_lookup_fs_root() will return nothing anyway.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c | 13 +++++++++++++
>  fs/btrfs/disk-io.h | 19 +++++++++++++++++++
>  fs/btrfs/ioctl.c   |  2 +-
>  3 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c47ac4eff28d..ed7ccda6da80 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1129,6 +1129,15 @@ static struct btrfs_root *btrfs_lookup_fs_root(str=
uct btrfs_fs_info *fs_info,
>  {
>         struct btrfs_root *root;
>
> +#if BITS_PER_LONG =3D=3D 32
> +       /*
> +        * Roots with ids above ULONG_MAX are never inserted into the rad=
ix
> +        * tree, and a truncated index may hit an unrelated root.
> +        */
> +       if (root_id > ULONG_MAX)
> +               return NULL;
> +#endif
> +
>         spin_lock(&fs_info->fs_roots_radix_lock);
>         root =3D radix_tree_lookup(&fs_info->fs_roots_radix,
>                                  (unsigned long)root_id);
> @@ -1181,6 +1190,10 @@ int btrfs_insert_fs_root(struct btrfs_fs_info *fs_=
info,
>  {
>         int ret;
>
> +       ret =3D btrfs_check_subvolid(fs_info, btrfs_root_id(root));
> +       if (ret)
> +               return ret;
> +
>         ret =3D radix_tree_preload(GFP_NOFS);
>         if (ret)
>                 return ret;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index d721e58a69f3..2f0f7bbdfbae 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -105,6 +105,25 @@ static inline struct btrfs_root *btrfs_grab_root(str=
uct btrfs_root *root)
>         return NULL;
>  }
>
> +/*
> + * fs_roots_radix is indexed by unsigned long, so on 32-bit systems a su=
bvolume
> + * id above ULONG_MAX is truncated, and can conflict with other subvolum=
es.
> + * Such subvolumes are not supported.
> + */
> +static inline int btrfs_check_subvolid(const struct btrfs_fs_info *fs_in=
fo,
> +                                      u64 subvolid)
> +{
> +#if BITS_PER_LONG =3D=3D 32
> +       if (unlikely(subvolid > ULONG_MAX)) {
> +               btrfs_err_rl(fs_info,
> +       "subvolume id %llu is too large for 32-bit systems, max supported=
 id is %lu",
> +                            subvolid, ULONG_MAX);
> +               return -EOVERFLOW;
> +       }
> +#endif
> +       return 0;
> +}
> +
>  void btrfs_put_root(struct btrfs_root *root);
>  void btrfs_mark_buffer_dirty(struct btrfs_trans_handle *trans,
>                              struct extent_buffer *buf);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 215e3220df7f..a7948e2a056c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5126,7 +5126,7 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_=
info *fs_info, void __user *a
>         }
>
>         /* 32bit limitation: fs_roots_radix key is not wide enough. */
> -       if (sizeof(unsigned long) !=3D sizeof(u64) && args.subvolid > U32=
_MAX)
> +       if (btrfs_check_subvolid(fs_info, args.subvolid))
>                 return -EOVERFLOW;

Technically we should return exactly what btrfs_check_subvoldid() returns.
Right now the only error it can return happens to be what we have
hardcoded here, so there's no problem.
But it would be cleaner to do this:

ret =3D btrfs_check_subvolid();
if (ret)
    return ret;

Anyway:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.
>
>         while (1) {
> --
> 2.56.0
>
>
