Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E060F3F1678
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528222; cv=none; b=kxAETnwIxLyEIAmtpEJP7rCU+G8ViRveoGZCNpSoSWm98fNc1CsU+NcYbm1jpCR8AL3CTDNPCga/Ou8+zrzQByoBT1EnSi9SLshV3q9CdZfk9+C0R2plzLZ0LQXTOw2jtLBRypDJZqzrmcFnlv0GJMz0+OVlhKpblppvwfipaHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528222; c=relaxed/simple;
	bh=QV3CFVypNc0rJzXut/HILXegUDl4fMliOsxdGznOTww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOUXe4lfwkHFOicOQ/CBJ1BA5ndia6s2FJNsbuRfcbJrIHf0s3WFdiyPGRj4vIEvKfaKBZH7tQ5teH8qXynNl3OzHTAME6bu2ALL+v8LrLrn189O3MYqjwxKHS700budkZLHeGzCZGKnufSPMuQDTWXZx9x8cdlzUBzh2RY7Zm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l1C4n/nK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l1C4n/nK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F9C1F00A3A
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 12:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781528221;
	bh=UqVKdaRVb55eVepprGj5RX9/8HWSrCh7kU5xdbytrjg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l1C4n/nK1NheRaxPZyBoEznAbIikwILjqi+Q5AECd6Lsmg7TcavO9eOSQFfGpqJ8M
	 16Wx9jkdXdddYvGx7LUWyg/qgVuCnY+xxGwkZEMxCpEsSUfkJhY7IzNUoe3mDH66dN
	 PP7MJtn0KqAEI9sFFEEb8melPDrbjZPQKWy7X1begSdnK8Srn5KABfBrXPNyReuM/V
	 Uh+CNjYz+ZSL4BuSXlhCuEc7jGNG19H3MflqzRc6aNN4OQmA5MzY/6L3SZ5RBnHGbz
	 ZQxa9v+eWpUFOl3Z9oQ5frNmX3Vh7T+A1TToCx8mVzS+ihgGAO4/Wex9EOpm88tPRs
	 /DB7xib7XjkkA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-beb7f26ed62so385052066b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 05:57:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8nRufet8MovBJS6h/XGGv4+HDRLvbNaSsfZ8xnycvll2tmRZQs9UP2VHF/eg8CIj3mSybaQ1QedjArOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyG88hpEV660jNleN4ZmVgRv/BhYQ1TewUOOrIUlI2ZZnOMv5p2
	mk8KRgaICGimrytc4DGaU9+28BykkuIzYuEQjJqQhzElwwNnSUs7wkSPGXTsbP1P0cBBDfIMFd0
	Z+doa3F/S5YdzF2LdE3w7rS6J8VEUDEk=
X-Received: by 2002:a17:907:7b91:b0:bf1:1df7:3e50 with SMTP id
 a640c23a62f3a-bfe27b20a09mr661433366b.3.1781528220404; Mon, 15 Jun 2026
 05:57:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ai_0QHRa0y-_d72k@stanley.mountain>
In-Reply-To: <ai_0QHRa0y-_d72k@stanley.mountain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 15 Jun 2026 13:56:22 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7h-JKNLrdjbHHACvQpyCGbCwQiHr1p_GNxqvmp+QH3bw@mail.gmail.com>
X-Gm-Features: AVVi8Cf0sJNCVQN92azwnbRNrFothAnjDJFa7Ign59jFjSJD8DtchngR9XHE8GY
Message-ID: <CAL3q7H7h-JKNLrdjbHHACvQpyCGbCwQiHr1p_GNxqvmp+QH3bw@mail.gmail.com>
Subject: Re: [bug report] btrfs: fix corrupt read due to bad offset of a
 compressed extent map
To: Dan Carpenter <error27@gmail.com>
Cc: Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 1:47=E2=80=AFPM Dan Carpenter <error27@gmail.com> w=
rote:
>
> Hello Filipe Manana,
>
> Commit de9f46cb0044 ("btrfs: fix corrupt read due to bad offset of a
> compressed extent map") from Jul 11, 2024 (linux-next), leads to the
> following Smatch static checker warning:
>
>         fs/btrfs/tests/extent-map-tests.c:979 test_case_8()
>         error: dereferencing freed memory 'em' (line 973 btrfs_free_exten=
t_map())
>
> fs/btrfs/tests/extent-map-tests.c
>     912 static int test_case_8(struct btrfs_fs_info *fs_info, struct btrf=
s_inode *inode)
>     913 {
>     914         struct extent_map_tree *em_tree =3D &inode->extent_tree;
>     915         struct extent_map *em;
>     916         int ret;
>     917         int ret2;
>     918
>     919         em =3D btrfs_alloc_extent_map();
>     920         if (!em) {
>     921                 test_std_err(TEST_ALLOC_EXTENT_MAP);
>     922                 return -ENOMEM;
>     923         }
>     924
>     925         /* Compressed extent for the file range [120K, 128K). */
>     926         em->start =3D SZ_1K * 120;
>     927         em->len =3D SZ_8K;
>     928         em->disk_num_bytes =3D SZ_4K;
>     929         em->ram_bytes =3D SZ_8K;
>     930         em->flags |=3D EXTENT_FLAG_COMPRESS_ZLIB;
>     931         write_lock(&em_tree->lock);
>     932         ret =3D btrfs_add_extent_mapping(inode, &em, em->start, e=
m->len);
>     933         write_unlock(&em_tree->lock);
>     934         btrfs_free_extent_map(em);
>     935         if (ret < 0) {
>     936                 test_err("couldn't add extent map for range [120K=
, 128K)");
>     937                 goto out;
>     938         }
>     939
>     940         em =3D btrfs_alloc_extent_map();
>     941         if (!em) {
>     942                 test_std_err(TEST_ALLOC_EXTENT_MAP);
>     943                 ret =3D -ENOMEM;
>     944                 goto out;
>     945         }
>     946
>     947         /*
>     948          * Compressed extent for the file range [108K, 144K), whi=
ch overlaps
>     949          * with the [120K, 128K) we previously inserted.
>     950          */
>     951         em->start =3D SZ_1K * 108;
>     952         em->len =3D SZ_1K * 36;
>     953         em->disk_num_bytes =3D SZ_4K;
>     954         em->ram_bytes =3D SZ_1K * 36;
>     955         em->flags |=3D EXTENT_FLAG_COMPRESS_ZLIB;
>     956
>     957         /*
>     958          * Try to add the extent map but with a search range of [=
140K, 144K),
>     959          * this should succeed and adjust the extent map to the r=
ange
>     960          * [128K, 144K), with a length of 16K and an offset of 20=
K.
>     961          *
>     962          * This simulates a scenario where in the subvolume tree =
of an inode we
>     963          * have a compressed file extent item for the range [108K=
, 144K) and we
>     964          * have an overlapping compressed extent map for the rang=
e [120K, 128K),
>     965          * which was created by an encoded write, but its ordered=
 extent was not
>     966          * yet completed, so the subvolume tree doesn't have yet =
the file extent
>     967          * item for that range - we only have the extent map in t=
he inode's
>     968          * extent map tree.
>     969          */
>     970         write_lock(&em_tree->lock);
>     971         ret =3D btrfs_add_extent_mapping(inode, &em, SZ_1K * 140,=
 SZ_4K);
>     972         write_unlock(&em_tree->lock);
>     973         btrfs_free_extent_map(em);
>
> This looks like btrfs_free_extent_map() frees "em".

Nop, false alarm.
And that's because btrfs_add_extent_mapping() will increase the ref
count of the extent map if it returns success (one ref for the tree).
So until the extent map is removed from the tree, we can use the em
after calling btrfs_free_extent_map().

Thanks.

>
>     974         if (ret < 0) {
>     975                 test_err("couldn't add extent map for range [108K=
, 144K)");
>     976                 goto out;
>     977         }
>     978
> --> 979         if (em->start !=3D SZ_128K) {
>                     ^^^^^^^^^
>
>     980                 test_err("unexpected extent map start %llu (shoul=
d be 128K)", em->start);
>                                                                          =
             ^^^^^^^^^
>     981                 ret =3D -EINVAL;
>     982                 goto out;
>     983         }
>     984         if (em->len !=3D SZ_16K) {
>                     ^^^^^^^
>
>     985                 test_err("unexpected extent map length %llu (shou=
ld be 16K)", em->len);
>                                                                          =
             ^^^^^^^
>     986                 ret =3D -EINVAL;
>     987                 goto out;
>     988         }
>     989         if (em->offset !=3D SZ_1K * 20) {
>                     ^^^^^^^^^^
>     990                 test_err("unexpected extent map offset %llu (shou=
ld be 20K)", em->offset);
>                                                                          =
             ^^^^^^^^^^
>     991                 ret =3D -EINVAL;
>     992                 goto out;
>     993         }
>     994 out:
>     995         ret2 =3D free_extent_map_tree(inode);
>     996         if (ret =3D=3D 0)
>     997                 ret =3D ret2;
>     998
>     999         return ret;
>     1000 }
>
> This email is a free service from the Smatch-CI project [smatch.sf.net].
>
> regards,
> dan carpenter
>
