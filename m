Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685412E1E9
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909526; cv=none; b=suN/3u7O2+OLl0SF5iXBSyAupJacmQJHA7A3fVSgb9AQ/wTTirxaSFjtw7jDUIPOrcFZzn8jUAnjAP/rA+5SS7Iv8LgXDG2GMgZCQzwxcpWYE7EiGkvdVwYQxL/q1AwKbogeNxAQQh9XCu1hJQrlR2iaNZZzIAgmW8V5/ur6lD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909526; c=relaxed/simple;
	bh=m83WbC9C/4aRjWZ9QMpyuriy5IAAbf3U0ONz66+vFqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofYQTYbPGCeppw7uUvip/J1jMbX68citBdbmhwY1A/AGOr4DjYVsRaBcuy7o6J9TmWWrbMbTc80Rk25QSUExyxHADsSbDZPiLF+MdoCoyHJFE9GvwAxzXtiKG5Qbdp0pVmOSAz2GXTjXdQheQuc46Qou1aWwMCHTfN6ks9QfAgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoorl/cS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoorl/cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416DBC2BCB8
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777909526;
	bh=m83WbC9C/4aRjWZ9QMpyuriy5IAAbf3U0ONz66+vFqc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eoorl/cShpI6bouzhxCB/eq/lqHfUGIkQ9froGJeYaErwYAIdKKRf9l9xQcJlZc5x
	 XBNTxvZDWlXzUzS6vkHkbnTeFyTXz0p48Iz3jeOUtYCTjAi3uZMKLyriMMXAzgcohr
	 iwnZBykiIdFB6kikT4fOh+ObIDJwp+TCq9GpDme/V8kmdjSjsuCnAMZzPO21jmoHvA
	 nRFeOmDlVZEI3hGg8fb9bOnH7Ts70n0+/jqBEdOabH3mkJfln3XUCDdd4l8XDypAv4
	 LYuPeoGOYvo2TBqVRh3bE/mF3VnGohr3oWWgk/rxeh6eOwgCQcKircNa1oEg1lDesq
	 YU+miiMQGUSIw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67c566cb519so2894687a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 08:45:26 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy3dlg2iX8gLbFvYDStFecMd9k00iMZuSd3DQM9p+Lhf6EdBZJf
	7eENdCC57va7FlE/S5HB2EICKjamIzg1ddi7bNihMvfjO1ZasanoisVo487aktQONoztXR+qPvT
	ED/jEge2igiay6k8pX+bxJRNQa0+PvOA=
X-Received: by 2002:a17:907:1c1c:b0:bb2:71a9:37d7 with SMTP id
 a640c23a62f3a-bbffe1c6e28mr537317866b.39.1777909524731; Mon, 04 May 2026
 08:45:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501024310.193220-1-robbieko@synology.com>
In-Reply-To: <20260501024310.193220-1-robbieko@synology.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 4 May 2026 16:44:47 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6FKaZM+u6a=P7OWetgY5QcCE6GtfFZo8=bEDFtBDrzHg@mail.gmail.com>
X-Gm-Features: AVHnY4KlT91dKUy59A1aEjZMDXOAAHvTitXAbbAgeJlEj-n682Tm3Q13sGkm8Mk
Message-ID: <CAL3q7H6FKaZM+u6a=P7OWetgY5QcCE6GtfFZo8=bEDFtBDrzHg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix incorrect i_size after remount caused by
 KEEP_SIZE prealloc gap
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 3:44=E2=80=AFAM robbieko <robbieko@synology.com> wro=
te:
>
> From: Robbie Ko <robbieko@synology.com>
>
> When fallocate() with FALLOC_FL_KEEP_SIZE preallocates an extent past the
> current i_size, the file_extent_tree of the inode is updated to cover
> that range. However, on the next mount, btrfs_read_locked_inode() only
> re-populates file_extent_tree with [0, round_up(i_size, sectorsize)),
> losing the marks that belonged to the KEEP_SIZE prealloc extent beyond
> i_size.
>
> Later, when a non-KEEP_SIZE fallocate() extends i_size into / past that
> old prealloc extent, the reservation loop in btrfs_fallocate() skips
> already-prealloc segments and does not call into the path that marks the
> file_extent_tree, so a gap remains inside the file_extent_tree across
> [old_aligned_i_size, start_of_new_alloc). Then __btrfs_prealloc_file_rang=
e()
> calls btrfs_inode_safe_disk_i_size_write(), which uses
> find_contiguous_extent_bit() starting at offset 0 to derive disk_i_size.
> The walk stops at the gap, so disk_i_size ends up smaller than i_size and
> gets persisted. After the next mount, the file shows the wrong (smaller)
> size.
>
> The following reproducer triggers the problem:
>
>   $ cat test.sh
>   MNT=3D/mnt/test
>   DEV=3D/dev/loop1
>
>   mkdir -p $MNT
>   mkfs.btrfs -f -O ^no-holes $DEV
>   mount $DEV $MNT
>
>   touch $MNT/file1
>   # KEEP_SIZE prealloc beyond i_size (i_size stays 0)
>   fallocate -n -o 1604991 -l 865536 $MNT/file1

So to make the test more readable and easier to understand, we can use
more round values, easier to grok.

E.g.

fallocate -n -o 4M -l 4M $MNT/file1


>   umount $MNT
>   mount $DEV $MNT
>
>   # non-KEEP_SIZE fallocate that overlaps the previous prealloc tail
>   # and extends past it
>   fallocate -o 2381098 -l 624426 $MNT/file1

And here:

fallocate -o 7M -l 2M $MNT/file1


>   ls -l $MNT/file1

Then here

ls -lh ...

>   umount $MNT
>   mount $DEV $MNT
>   ls -l $MNT/file1

Same here:

ls -lh ...

>   umount $MNT
>
> Running the reproducer gives the following result:
>
>   $ ./test.sh
>   (...)
>   -rw-r--r-- 1 root root 3005524 ... /mnt/test/file1
>   -rw-r--r-- 1 root root 2379776 ... /mnt/test/file1

And here we get:

-rw-rw-r-- 1 root root 9.0M May  4 16:35 /mnt/sdi/file1
-rw-rw-r-- 1 root root 7.0M May  4 16:35 /mnt/sdi/file1

See, much easier to grok.

>
> The size before the second mount is correct (3005524), but after the
> remount it drops to 2379776, which is round_down(2381098, 4096), i.e.
> the start of the gap inside file_extent_tree aligned down to sectorsize.
>
> Fix this in __btrfs_prealloc_file_range() by marking the entire range
> [round_down(old_i_size, sectorsize), round_up(new_i_size, sectorsize))
> in file_extent_tree before updating i_size and calling
> btrfs_inode_safe_disk_i_size_write(). This ensures the contiguous bit
> search starting from 0 is not truncated by a stale gap left behind by a
> previous KEEP_SIZE prealloc that was not restored on inode load.
>
> The fix has no effect when the NO_HOLES feature is enabled because
> btrfs_inode_safe_disk_i_size_write() and btrfs_inode_set_file_extent_rang=
e()
> both take the fast path that directly tracks disk_i_size without consulti=
ng

A couple lines exceed the 75 characters limit.

> file_extent_tree.
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>

I've updated the changelog to use those more readable values instead,
fixed the line lengths, added a Fixes tag, and pushed it to the github
for-next.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Also, do you plan on sending a test case for fstests?
Having a test in the change log alone does not prevent regressions...

Thanks.

> ---
>  fs/btrfs/inode.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 906d5c21ebc4..c39a0ce24224 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9299,10 +9299,38 @@ static int __btrfs_prealloc_file_range(struct ino=
de *inode, int mode,
>                 if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>                     (actual_len > inode->i_size) &&
>                     (cur_offset > inode->i_size)) {
> +                       u64 range_start, range_end;
> +
>                         if (cur_offset > actual_len)
>                                 i_size =3D actual_len;
>                         else
>                                 i_size =3D cur_offset;
> +
> +                       /*
> +                        * Make sure the file_extent_tree covers the enti=
re
> +                        * range [old_i_size, new_i_size) before we updat=
e
> +                        * disk_i_size. Without this, a previous KEEP_SIZ=
E
> +                        * prealloc that extended past i_size (and was lo=
st
> +                        * across umount/mount because file_extent_tree i=
s
> +                        * only populated up to round_up(i_size) on inode
> +                        * load) can leave a gap inside this range. That =
gap
> +                        * would cause btrfs_inode_safe_disk_i_size_write=
()
> +                        * (via find_contiguous_extent_bit() starting at =
0)
> +                        * to truncate disk_i_size to the start of the ga=
p,
> +                        * making the persisted size smaller than i_size.
> +                        */
> +                       range_start =3D round_down(inode->i_size,
> +                                                fs_info->sectorsize);
> +                       range_end =3D round_up(i_size, fs_info->sectorsiz=
e);
> +                       ret =3D btrfs_inode_set_file_extent_range(BTRFS_I=
(inode),
> +                                       range_start, range_end - range_st=
art);
> +                       if (ret) {
> +                               btrfs_abort_transaction(trans, ret);
> +                               if (own_trans)
> +                                       btrfs_end_transaction(trans);
> +                               break;
> +                       }
> +
>                         i_size_write(inode, i_size);
>                         btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode)=
, 0);
>                 }
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
