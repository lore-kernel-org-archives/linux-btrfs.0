Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A093CFF56
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782211332; cv=none; b=r0g+S2MQBKd2ZNFIisi17YFdTfkPsaKugk256iBTJsWPX4Td6UbvgK5g/n5t+dK24jtKTEeeKtP9srtJUz+0k1p3s+UQbLUMF526FRzY9mAgGRQpB9ctf0/ayGBIa1Pd32I/HaGkLDwr9K+hnJWhlk9v6oIe8kmBsABUa+aLHUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782211332; c=relaxed/simple;
	bh=7ZCS+nAf9DzWaGovhhLRooaMeMhWFa/fjNG1lrvH+eU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MO7Q1MFiRUz5yLS8bOnGppOzj8KTBqxoLjzkB6l0oL811nVaQjQdTqM10Gae0kUQtZX5rtfXqAeSDvvTwWAMnQZdz7jpDcamqeQP2F79AUgM/L/GC47oq3nThpa8fUf7NDIVhaEeaV/Ly3Waf96psMLUezr8T/gKvcQ+rDbszZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anhOIvsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anhOIvsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015D31F000E9
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 10:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782211331;
	bh=o9DCNxsxP2zCzqd8I8S0j3nNfEC5TwHFVfZu6CxNHo8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=anhOIvsHPaiIvd0EtrT/m3h8tYbGHx3lqFdFRYs/DRdEx95B73wBDZVlHaoHRN+4w
	 dLsX7XNiwaI3ObYrCwh7UlNuYYwpi0iIQc8VPq11p3oHDM7EZvpxDYC7ITTPRHbigl
	 1V1hayHZ5bJq74yOwCKuoy89SeVX913Rog0A++luEsamxJW8DlMqqUjUOyTbS0xX1s
	 9OaWxrfO5xOn/1xmgUw7Q0VR/P7wHPlERpDcYpSLH4g/KqZTfUNGHr40g42HYdP8EZ
	 2IXbwluhWJttklJyTTJMNXmnJhCkdywucbL1NXnly50urJu3r1QfifaVKxo475nTy6
	 HIdtOnn/WoxXg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c0115a3794bso983584566b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 03:42:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YxUWZewNExc5MMLvbBySeTjX3QzNfDPZ0dRdr8zRPFEf4Y/Gfye
	WD8otovG3pFRbOSlYB86mSfvrGFvOF3Dh9YTP2CUIA8g1+ELsEWZYXRNu3ijs16W9/gXDgJZkvo
	5st4zUL8px0cYJBLORQ8KRtPMbjQ/LrI=
X-Received: by 2002:a17:907:c498:b0:bf3:230c:4c64 with SMTP id
 a640c23a62f3a-c108e00aa7bmr106683866b.16.1782211329690; Tue, 23 Jun 2026
 03:42:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782168847.git.wqu@suse.com> <4191bde54303559d0065213f7970ec1ad9790e02.1782168847.git.wqu@suse.com>
In-Reply-To: <4191bde54303559d0065213f7970ec1ad9790e02.1782168847.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 23 Jun 2026 11:41:32 +0100
X-Gmail-Original-Message-ID: <CAL3q7H70Wmq4WZJ4dbQ0stNFbs3XuTd9pk0qNHTQQ0y0-4u54Q@mail.gmail.com>
X-Gm-Features: AVVi8CfeH3YsPW9rjhjtXwO_WaSNdFvy5Jih0qTqc80c2uPgre1ZwGH-xZsBr5I
Message-ID: <CAL3q7H70Wmq4WZJ4dbQ0stNFbs3XuTd9pk0qNHTQQ0y0-4u54Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs: do not try compression for data reloc inodes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 11:56=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> There is a syzbot report that the check inside get_new_location()
> triggered:
>
>  BTRFS info (device loop0): found 31 extents, stage: move data extents
>  BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space =
1676 owner 18446744073709551607
>         item 0 key (256 INODE_ITEM 0) itemoff 3835 itemsize 160
>                 inode generation 5 transid 0 size 0 nbytes 0
>                 block group 0 mode 40755 links 1 uid 0 gid 0
>                 rdev 0 sequence 0 flags 0x0
>                 atime 1669132761.0
>                 ctime 1669132761.0
>                 mtime 1669132761.0
>                 otime 0.0
>         item 1 key (256 INODE_REF 256) itemoff 3823 itemsize 12
>                 index 0 name_len 2
>         item 2 key (258 INODE_ITEM 0) itemoff 3663 itemsize 160
>                 inode generation 1 transid 16 size 733184 nbytes 106496
>                 block group 0 mode 100600 links 0 uid 0 gid 0
>                 rdev 0 sequence 24 flags 0x18
>         item 3 key (258 EXTENT_DATA 0) itemoff 3595 itemsize 68
>                 generation 16 type 0
>                 inline extent data size 47 ram_bytes 4096 compression 1
>  [...]
>         item 27 key (18446744073709551611 ORPHAN_ITEM 258) itemoff 2376 i=
temsize 0
>  BTRFS error (device loop0): unexpected non-zero offset in file extent it=
em for data reloc inode 258 key offset 0 offset 9277520992061368337
>  ------------[ cut here ]------------
>  btrfs_abort_should_print_stack(__error)
>
> [CAUSE]
> The above dump tree shows the first file extent item is inlined, which
> should make no sense for data reloc inodes, as such inodes are just
> representing where the data extents are in the relocation destination chu=
nk.
>
> However the relocation path is just preallocate space for each block,

"is just preallocate" is weird, more like "preallocates"

> then dirty them, cluster by cluster.
> It's possible to have a single block at the beginning of the block
> group, and no other block in the same cluster.
>
> Then relocation will preallocate a file extent for that block, dirty the =
first block.
> Then memory pressure forces the data reloc inode to be written back, befo=
re
> any other blocks being dirtied/allocated.
>
> Finally commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedi=
cated
> delalloc helper") changed the timing of delalloc, before that commit we

This isn't about changing the timing but rather changing the order of
the rule set for inline/compression/nocow.
Saying timing is confusing.

> always try NOCOW first, so that dirtied block will be written back into
> the preallocated space.
>
> But with that commit, we always try inline first, and since compression
> is forced, we try compressing the first block, and then inline the
> compressed data, resulting in the above inlined file extent in data
> reloc tree.
>
> Then the check in get_new_location() will check the file offset, without
> checking if the file extent is inlined or not, resulting the above
> failure.
>
> [FIX]
> Do not allow compression for data reloc inodes in the first place.

I would add an explanation here about why disallowing compression
prevents the inline extent, as this is non-obvious and involves a
convoluted path.

So adding this new check in btrfs_inode_can_compress() makes
run_delalloc_inline() skip the compression `if` statement. Then, when
it calls can_cow_file_range_inline() that returns false because the
data size is >=3D sector size, causing run_delalloc_inline() to return
1, signaling to the caller, btrfs_run_delalloc_range(), it cannot
inline and must follow the nocow path.

Thanks.

>
> Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001.G=
AE@google.com/
> Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated de=
lalloc helper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/btrfs_inode.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index d5d81f9546c3..fff72f6cc1e8 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -476,6 +476,8 @@ static inline bool btrfs_inode_can_compress(const str=
uct btrfs_inode *inode)
>         if (inode->flags & BTRFS_INODE_NODATACOW ||
>             inode->flags & BTRFS_INODE_NODATASUM)
>                 return false;
> +       if (btrfs_root_id(inode->root) =3D=3D BTRFS_DATA_RELOC_TREE_OBJEC=
TID)
> +               return false;
>         return true;
>  }
>
> --
> 2.54.0
>
>
