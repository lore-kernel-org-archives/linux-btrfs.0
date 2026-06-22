Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37A428CF6F
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127065; cv=none; b=Y3s3TAi39uWFSVFpYxfs7e+Hzk5uymUrhMflkmmBw99YnYJ2QdP7wbCiVZlwbVrfwwGXBHDdtvbIE5mV+TgtwM026/aM8xsOxfsC2R4wPOPcQxxaSr1h7uTcPXqcXd5586OBYyvtHZPsWicVQOmpwYhBFAZddikoN5QkrlkOqnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127065; c=relaxed/simple;
	bh=xZrtQEYt6uymOnNUibpxOty+rS1r9TgoeDjS7J2yunA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FEWDiykWCZ6M+LUw4lAECDu1PmIIYnmzsY4DecDJxS/RHsQvuK9AF+DfbBt/zbYrbiL8dQkwi+VgTgrjgVXfeKvdrrxCdayZ0h97oAPAh/HU5fvT2ELynAfnWVMTGKJA+f/+MdUOEUIV64PD77Xk0E3h5GOdOPhe95besk6DDzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQiS/Ubf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQiS/Ubf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719BC1F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782127064;
	bh=QqyQ1UBuYaE1pXJapSxoK5S1w4akpptluKJt9DzYT+o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IQiS/UbfezmippQFboRlJ0s5vFoz2O/iZhD4yiXX3rcBVLW9NpGPBzqAXXbH9R34h
	 mR/qoHriVLwbdDiuuetvRXaeONOomI9yRApBVK8o4srVbcuyb2grxm3/6/y15UiyVz
	 hrYT8oTT8Z16s2w3Ekb/fa+UlQOeW8dbcVJgnYJi/4SNzdhGs2CBZCgDGbD4V2pzyV
	 LIcF6QlataoNLJMAPdFv653jH9wcdGhkks4N2xqt69s6k8WxyR72AYox7Z9oF2JLIP
	 1p4WhlipbTDnIUyQAP1KxL4aHRJbLDN3Mpz5IKMvoElpWdkh0ddFoPveBR0Ygi11ys
	 d6h5yhQ3e+shw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c0e124d2a21so129537066b.2
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 04:17:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YwO9zWBb3wc1VYIsFcr3TBEP9cW9V4kRJ4HJFNj4uxw4tnc/Tfq
	ZXVoZwttWsu3sRpQe+yo0VdnqP/SNmkQ6d7blwT8Q/tGvgBznAtqvqr1SlCTf2C/EHv0u7TIIKB
	brH8SAIibWm0eaNkCaCIAxeoTUmOwKRY=
X-Received: by 2002:a17:906:c108:b0:c0e:9f25:dfb7 with SMTP id
 a640c23a62f3a-c0e9f266c91mr184857666b.22.1782127063155; Mon, 22 Jun 2026
 04:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782022263.git.wqu@suse.com> <9206a06ed48a4dc40d50909dddf3daa9b17965eb.1782022263.git.wqu@suse.com>
In-Reply-To: <9206a06ed48a4dc40d50909dddf3daa9b17965eb.1782022263.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 22 Jun 2026 12:17:05 +0100
X-Gmail-Original-Message-ID: <CAL3q7H43PTL7AfGz4nNWTOYX4pHgUKYo+c5+R_=qpUOkj_R_eA@mail.gmail.com>
X-Gm-Features: AVVi8CfZD0zD3DiDPvaBFcyzUoRaWaRULBNPo2McxiELTgziKweN7Ad5m2lW3r8
Message-ID: <CAL3q7H43PTL7AfGz4nNWTOYX4pHgUKYo+c5+R_=qpUOkj_R_eA@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: do not try compression for data reloc inodes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 21, 2026 at 7:13=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
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
> However the relocation path is just dirtying the data reloc inode
> cluster by cluster. It's possible to have a single block, not adjacent
> to any other data extents.
>
> Then relocation will dirty the first block of the data reloc inode, then
> memory pressure forces the data reloc inode to be written back.
>
> In that case, since the syzbot has forced compression, we try to
> compress the first block and if it can be compressed and inlined, an
> inlined extent will be created.

If it were that simple, users would have encountered it and reported
it, and fstests would have triggered this (we have several balance +
fsstress + compression tests).

Something is missing here.
A very important detail, which is not mentioned here at all, is that
relocation works by preallocating extents (see
prealloc_file_extent_cluster()) before dirtying pages/folios.

This means that flushing delalloc of the data reloc inode should
always go into the nocow path.

Even if the nocow path would fallback into cow, which should never
happen for a data reloc inode, we never try to compress and inline the
fallback path - fallback_to_cow() -> cow_file_range() ->
cow_one_range() - nothing here attempts inline extents (or
compression).

What you are describing would be easy to convert into an fstests test case.

Flushing delalloc of the data reloc inode should never reach
btrfs_inode_can_compress() - if we end up there, then the problem is
somewhere else.

Thanks.

>
> Then the check in get_new_location() will check the file offset, without
> checking if the file extent is inlined or not, resulting the above
> failure.
>
> [FIX]
> Do not allow compression for data reloc inodes in the first place.
>
> Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001.G=
AE@google.com/
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
