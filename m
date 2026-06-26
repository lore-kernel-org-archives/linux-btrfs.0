Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ACA3E9580
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 09:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782465547; cv=none; b=iNCwfp7tBpK/xtlLkb43mymZqqrryzXjmD4DBLk8NW3qxQsUNG2ohCNZj6IkkDnTGw8oIiWrCrsjgkpzon0nX00PJzVZnPcCxOnkb0xPopDyd+No8oeQT1qPHniKHYLcQqQlgk1Dh4G1zVWE9kY8iVXTn0Is5Dbdf/5Mc37ygFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782465547; c=relaxed/simple;
	bh=9FvKR3YKwcy6RfeMPZS2wBRDFTrQ+9mPrYtv7sY0bbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7XYBj+bXX66wPd3KBIto0qWpLS3bdika87ZJFmoj3HmSsswABzlSKFkph4b87BwUNNrzFoX1FcY+9Y4b2c0Y0rhOd94KP0PP1E2DcxvtaiNtey1MJSlusqkmIpc4G3TpMGlvntjKy6M2JMlhcdk8c/3HmMdQqxScD5HKPYykgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AOzyCG2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AOzyCG2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566BE1F00A3D
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465544;
	bh=I1mrac9Rb/hFAyy93lcMBdTqI/olzfSlN7qDPPNkkWg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AOzyCG2Rx43klqm06lStMP7Dl4lu8mV4BAM6YfSVy9ZPsX87mcp5aunt1Ajl3F8QL
	 ozpsd+zid1wGDXgW/435b4FQjkDij0YMPj6/48zbo4JfJB8/RXflpyjU3ZT+bx2IE6
	 /psFujofXKmFmguf/fTiUYzx26+wVc34GFNbP+v89BueuzMsP2V0JNUilTJOaJ5LxV
	 m2xkMfxWTelFtowUKPyoB7fhe7xOVYrTCmqwW/BmXAmi3HKXg6ruoaQFGqzYROYUYL
	 QE3i72O+EV9IdCmWSRmhdCd7UCCxlEHDJRxaJ0vB3addpvZ9XrjdOrtjoDxAGNkdd7
	 3fGzrdq7wwWgA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1217010b7cso74728066b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 02:19:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YyY3hKI6zW7AtQW2xmIBldp2Lgwcg33HAoWQ/36uVsG79JY5Vj2
	Upvaj/LAHEIz6mbZdba3fYFUXDv9Mhr/jc36OY0PjWSLHSDsw2OC7dIWG/qpEiyiTn0+a/rw+JY
	2mx89cXzVGdaoRMYldaVBa7r1ejdykBg=
X-Received: by 2002:a17:907:724e:b0:c07:2c22:a6fe with SMTP id
 a640c23a62f3a-c1205f178c3mr398528366b.47.1782465543033; Fri, 26 Jun 2026
 02:19:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626064524.2288234-1-davechen@synology.com>
In-Reply-To: <20260626064524.2288234-1-davechen@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 26 Jun 2026 10:18:25 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6kcDvYfi5T7N1Rf9=_aCdT8oDafW2w_QS2U3nmhMRZPw@mail.gmail.com>
X-Gm-Features: AVVi8CcP7vjCt4HbFWIBcba9JZmS2GV1doa6S6T7bBS2bSUlABC5ompxLf7EMr8
Message-ID: <CAL3q7H6kcDvYfi5T7N1Rf9=_aCdT8oDafW2w_QS2U3nmhMRZPw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: only account delalloc bytes for regular file
 inodes in btrfs_getattr()
To: Dave Chen <davechen@synology.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, cccheng@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 7:52=E2=80=AFAM Dave Chen <davechen@synology.com> w=
rote:
>
> btrfs_getattr() unconditionally reads BTRFS_I(inode)->new_delalloc_bytes
> and adds it (sector-aligned) to stat->blocks for every inode type.
> However, new_delalloc_bytes lives in a union with last_dir_index_offset:
>
>     union {
>         u64 new_delalloc_bytes;     /* files only */
>         u64 last_dir_index_offset;  /* directories only */
>     };
>
> For a directory inode this memory holds last_dir_index_offset, which is
> set during directory logging (e.g. flush_dir_items_batch()) to the
> offset of the last logged BTRFS_DIR_INDEX_KEY.  That offset grows with
> the number of entries ever created in the directory (dir indexes are
> monotonic and never reused), so it can be arbitrarily large.
>
> As a result, after a directory has been logged (e.g. via an fsync that
> triggers directory logging), btrfs_getattr() reports inflated st_blocks
> for that directory.  The inflation is purely in-core and disappears
> after the inode is evicted and reloaded (btrfs_alloc_inode() zeroes the
> union), e.g. after a remount.
>
> Reproducer (on a btrfs filesystem):
>
>     D=3D/mnt/btrfs/d
>     mkdir -p $D
>     for i in $(seq 1 20000); do touch $D/f$i; done
>     sync                      # commit, push dir index high
>     touch $D/trigger          # dirty the dir in a new transaction
>     xfs_io -c fsync $D        # log the directory -> sets last_dir_index_=
offset
>     stat -c '%b' $D           # st_blocks is now inflated (e.g. 40)
>     # umount + mount -> st_blocks drops back to the correct value
>
> The evict path already knows this union is type-dependent and guards the
> corresponding WARN_ON with !S_ISDIR() in btrfs_destroy_inode(); only
> btrfs_getattr() was missing the equivalent check.
>
> Only read new_delalloc_bytes for regular files, which are the only
> inodes that ever set it.
>
> Signed-off-by: Dave Chen <davechen@synology.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Will add it soon to github's for-next branch, thanks.

> ---
>  fs/btrfs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 272598f6ae77..b446c3014b24 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8068,7 +8068,8 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
>         stat->result_mask |=3D STATX_SUBVOL;
>
>         spin_lock(&BTRFS_I(inode)->lock);
> -       delalloc_bytes =3D BTRFS_I(inode)->new_delalloc_bytes;
> +       delalloc_bytes =3D S_ISREG(inode->i_mode) ?
> +                        BTRFS_I(inode)->new_delalloc_bytes : 0;
>         inode_bytes =3D inode_get_bytes(inode);
>         spin_unlock(&BTRFS_I(inode)->lock);
>         stat->blocks =3D (ALIGN(inode_bytes, blocksize) +
> --
> 2.43.0
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>
