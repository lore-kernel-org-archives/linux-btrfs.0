Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D0939DBF2
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424292; cv=pass; b=eyK4y73tDgpzXQRvWIjnEM0hEVljB8akvELhM1FuP7VrBd9oNlV3rAflcmpav7gYga3Fsu6nOIJfle8azwgVYTyL/m8DRx+AMJB1CugkgT7ONDMuS1aWbMqVyzxvsvJ7Z0bAgfOOO2H8D+aK0vKuVtkuHEvdxBIXvZi+NU84T3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424292; c=relaxed/simple;
	bh=mskav7sFlheYV6q45tolJOjxiiujrlBg5LN6Xl4W8kY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hh7+G40Wrarvb/TlIeUhttsxxydfX/e0u8nJ73OCdsiqOrE3QIbNs+8XC60FQRG09UHSeEXFwA/AhhlCZfHxDi83xUXXyrW7iU8SLXBRi3L+5jPZ50yY58tu0KAO3SukRnRdxeCyA4qEc1uCIvo1AC0YSHWDGidpfr+ZjwGQFHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KnnIOe3+; arc=pass smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnnIOe3+"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-393ba0616aaso37928641fa.2
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 07:44:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778424289; cv=none;
        d=google.com; s=arc-20240605;
        b=HQL86hM2nec509JNYvhf9yKaRM2arbpA9tMiamx2CHUVTGY8Mb1Zb35n0uDmHRVJFI
         SvcyHOE74h1PTYpM+59muCIKWPyHJq5LBS2WtXn/0V+IhGTx73Zb/H+q4eebxuiYLYAb
         NhLApdHNyJm5JMSmthgwmOBE+wYSCpTqmHCO3s092hLMZpsfT8JG1zMgU5CT9qeYHJbH
         UpCcUlwek2aeCWxr4b28gpLiOeUx+2HH3snGAY+91Uj/w/ReZFWGYaxr06S6v5IKfe8G
         USuUW70uvA96JebeGCB8H0lzyYB9dI0D+/NJpPRFk5Al+gYrEy1z+s5I8AQpfdZ6pO+v
         AEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+z9dq4MdKDwl6PRAHOilg3mkYJKufrb25miiAwXy46E=;
        fh=LogI6ssdZz3RIQfU00nAF6ADXPfowqKzgMaGJ5kvAUk=;
        b=J2fWpqTZNeNi0WQkkhfJSVi32W7xigV23QQf7+/gxGSAlbQ5TIp6xfFQRoWNdpTAq0
         lB3DEGxyATT+RCafeEcustnUcawdCGfBrhtGpzle2uxUtEvt2H03pYpCYNPTuHxqWiLn
         QPAr2eIl2AjYssswD/eLNcsD1oxIoUNuEzuYyVSiDyj3P3yvLCmZZqoGfgFIS08GnDvl
         mZ6GRKInfIGGmr7AyTdosyNJHyoe+nGunXtEh1i7/SDmC5G80cxzFNPrbqBC92bH2H/N
         qh9uojEj27Q9/UBD0CRMZVxiszPBY39cfaCd2k5ip76RkhdtHtc4yRlcIF3j8Dvmaqx7
         5Jyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778424289; x=1779029089; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+z9dq4MdKDwl6PRAHOilg3mkYJKufrb25miiAwXy46E=;
        b=KnnIOe3+gw5rsmaYXemFxbRoOQSr3SNjKkNIrleUwmLc8bxBs3b2iH2uuAhkcMueso
         9xZJz91eGC57C5WFVkj4SWmOJHyWcUbwsQSrmivWVRbm2RQ8l6bvtz2vXQen8Zmo4kUF
         csTUu2EHOipR/gFzRjRRfr5AYoevg3hojByOxbIfLiq5PZglmrkGR32nxXTHEx9zixDA
         Jr5uYGtCOg3G3Rce5k1ZjEgHMh7sL8V5mydTXbLSS7mBYOkf2dVJhM+d/LOUjq+lq8/q
         NURduXCKdqOx0VJUohNqBZ66dg/90vdDkTiXP77JiFojkbMLD2i5/B4MXBVEWgwnljV5
         +6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778424289; x=1779029089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+z9dq4MdKDwl6PRAHOilg3mkYJKufrb25miiAwXy46E=;
        b=WbPoPjR3J8A5z5dgy5ooZgaG6vaxWRB0gVxdOQOP6xWtwq4NGcAQyv2FeP++dm4hld
         6we6xEqHjNK+hqdlQpKFYGkKcOALoXlHmAayDNC4N4ys8G9LjxeF8dyB40isnU4DjG5r
         4fw6hxoGM1uNnbsnlNrdsYrHLg7Jf8YoUYoAIexnyNNfK0m4G+YE4GmqBR4RyJeSf7ru
         rZxM+FX0S3riJEOiVbltX0FhUT1z0Qu2E6cDOKynYmwjW2wX9pSZGlcu44xq6IavN6/F
         lSDUkXxmDFiBx0pFM594e7zIaqwkQUF7oRRWvW4mhz/v8nCrWqIKbM3FpQMcJ/YAutX1
         VK1g==
X-Gm-Message-State: AOJu0YxIGkNFpxsF9QpoXzr63aR0x8yFdjyMPDtWP1YmrpoXqt9Lww+0
	joWVpuPbZ9pIK6oc/xPGAkYH1ld3jdg73E89kO9+agjFzCpWQfyGezWkbefK67biOGyyhV2pP0b
	msJUxsJp0olQu/tOc+nqEkyi+mh1ZbBk=
X-Gm-Gg: Acq92OGUEVUBNjoa3WTQX/u1oTJCrO6xTQQB2OZOjM9G+zKc/pTw2eC5/4R4nphMaQG
	wutYKNB5xYSU/Bjgw5N/bryJzycq3k0ThilJizJ9YuX5EAdxxoZhSFhTdQURTL+FNd5pfq4TnC7
	wMh7iasag+8pEnazHCj0R2U9pYJFN9C+m2r6Wjw08LHrtV7K2FHo2sgQYDeoB5jUjP2XSvnuE75
	rLnZ1rrXPGUI5T4Qk9g6ZNpvHzMiD21v0vonjQnXuNWBVREKmLKBDLhSGiU8WAx5SOrS7QuTGMc
	9bJIhUBqirtzlIxovSY=
X-Received: by 2002:a05:651c:146b:b0:38a:3208:8cc4 with SMTP id
 38308e7fff4ca-393c420a160mr76927411fa.25.1778424288303; Sun, 10 May 2026
 07:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260510074943.2644334-1-rollkingzzc@gmail.com> <20260510144211.3722703-1-rollkingzzc@gmail.com>
In-Reply-To: <20260510144211.3722703-1-rollkingzzc@gmail.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Sun, 10 May 2026 22:44:36 +0800
X-Gm-Features: AVHnY4LK3TzcXvpSFGgM4VRrxuSoNdnGgVLJiWcFbFgwYoleGVwWqKKofI-vNVY
Message-ID: <CAB7XQsH+5VksYga6FJHnCBh8au7W4_ifUx56+an_Oo3beWvjVA@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, zerocling0077@gmail.com, 2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm so sorry, I sent the wrong message.

Best regards,
Zhang Cen

Zhang Cen <rollkingzzc@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8810=E6=97=
=A5=E5=91=A8=E6=97=A5 22:42=E5=86=99=E9=81=93=EF=BC=9A
>
> btrfs_load_free_space_tree() reads FREE_SPACE_INFO once and then chooses
> the bitmap or extent loader for all following free-space records until th=
e
> next FREE_SPACE_INFO item. Those loaders currently enforce the selected
> record type only with ASSERT().
>
> On production builds without CONFIG_BTRFS_ASSERT, a malformed free-space
> tree can therefore be decoded in the wrong mode. An EXTENT item can reach
> btrfs_free_space_test_bit() as bitmap data, while a BITMAP item can be
> added as a full free extent. The latter corrupts the in-memory free-space
> cache and the former can read beyond the item payload.
>
> Validate every post-info key before decoding it. Reject keys whose type
> does not match the mode selected by FREE_SPACE_INFO, and reject keys
> whose range extends past the block group, returning -EUCLEAN instead of
> feeding the wrong record type to the bitmap or extent decoder.
>
> Also reject zero-length FREE_SPACE_EXTENT items in tree-checker, matching
> the existing FREE_SPACE_BITMAP zero-length check. This keeps the loader
> range check simple and prevents a zero-length extent item from being a
> valid on-disk free-space record.
>
> Sanitizer validation reported:
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN NOPTI
> Call trace:
>   assert_eb_folio_uptodate() (fs/btrfs/extent_io.c:4134)
>   extent_buffer_test_bit() (?:?)
>   btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518)
>   srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
>   __entry_text_end() (?:?)
>   __asan_memcpy() (mm/kasan/shadow.c:103)
>   read_extent_buffer() (?:?)
>   load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1548)
>   btrfs_get_32() (fs/btrfs/free-space-tree.c:?)
>   btrfs_set_16() (fs/btrfs/free-space-tree.c:?)
>   kmem_cache_alloc_noprof() (?:?)
>   btrfs_load_free_space_tree() (fs/btrfs/free-space-tree.c:1685)
>   load_free_space_tree_for_test() (?:?)
>   rcu_disable_urgency_upon_qs() (kernel/rcu/tree.c:721)
>   vprintk_emit() (?:?)
>   __up_write() (kernel/locking/rwsem.c:1401)
>   clone_commit_root_for_test() (?:?)
>   test_extent_as_bitmap_mode_mismatch() (?:?)
>   kmem_cache_free() (?:?)
>   btrfs_free_path() (fs/btrfs/free-space-tree.c:1449)
>   __add_block_group_free_space() (fs/btrfs/free-space-tree.c:20)
>   run_test() (?:?)
>   do_raw_spin_unlock() (?:?)
>   btrfs_test_free_space_tree() (fs/btrfs/tests/free-space-tree-tests.c:54=
7)
>   btrfs_test_qgroups() (fs/btrfs/tests/qgroup-tests.c:462)
>   btrfs_run_sanity_tests() (fs/btrfs/free-space-tree.c:?)
>   init_btrfs_fs() (fs/btrfs/super.c:2690)
>   do_one_initcall() (init/main.c:1382)
>   __kasan_kmalloc() (?:?)
>   rcu_is_watching() (?:?)
>   do_initcalls() (init/main.c:1457)
>   kernel_init_freeable() (init/main.c:1674)
>   kernel_init() (init/main.c:1584)
>   ret_from_fork() (?:?)
>   __switch_to() (?:?)
>   ret_from_fork_asm() (?:?)
>
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
>
> ---
> From ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7 Mon Sep 17 00:00:00 2001
> Message-ID: <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.roll=
kingzzc@gmail.com>
> In-Reply-To: <20260510074943.2644334-1-rollkingzzc@gmail.com>
> References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
> From: Zhang Cen <rollkingzzc@gmail.com>
> Date: Sun, 10 May 2026 16:51:00 +0800
> Subject: [PATCH v2] btrfs: free-space-tree: reject mismatched extent and
>  bitmap items
> To: Chris Mason <clm@fb.com>,
>     David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org,
>     linux-kernel@vger.kernel.org,
>     Qu Wenruo <wqu@suse.com>,
>     zerocling0077@gmail.com,
>     2045gemini@gmail.com,
>     Zhang Cen <rollkingzzc@gmail.com>
>
> btrfs_load_free_space_tree() reads FREE_SPACE_INFO once and then chooses
> the bitmap or extent loader for all following free-space records until th=
e
> next FREE_SPACE_INFO item. Those loaders currently enforce the selected
> record type only with ASSERT().
>
> On production builds without CONFIG_BTRFS_ASSERT, a malformed free-space
> tree can therefore be decoded in the wrong mode. An EXTENT item can reach
> btrfs_free_space_test_bit() as bitmap data, while a BITMAP item can be
> added as a full free extent. The latter corrupts the in-memory free-space
> cache and the former can read beyond the item payload.
>
> Validate every post-info key before decoding it. Reject keys whose type
> does not match the mode selected by FREE_SPACE_INFO, and reject keys
> whose range extends past the block group, returning -EUCLEAN instead of
> feeding the wrong record type to the bitmap or extent decoder.
>
> Also reject zero-length FREE_SPACE_EXTENT items in tree-checker, matching
> the existing FREE_SPACE_BITMAP zero-length check. This keeps the loader
> range check simple and prevents a zero-length extent item from being a
> valid on-disk free-space record.
>
> A malformed extent-as-bitmap record was observed as a KASAN fault in
> extent_buffer_test_bit() (fs/btrfs/extent_io.c:4313), reached through
> btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518) from
> load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1603).
>
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
> Changes since v1:
> - Use unlikely() on validate_free_space_key() failure checks.
> - Replace the loader range check with key->objectid + key->offset > end.
> - Reject zero-length free-space extent items in tree-checker.
>
>  fs/btrfs/free-space-tree.c | 37 ++++++++++++++++++++++++++++++++-----
>  fs/btrfs/tree-checker.c    |  4 ++++
>  2 files changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 472b3060e5ac..c1af70761919 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1545,6 +1545,30 @@ int btrfs_remove_block_group_free_space(struct btr=
fs_trans_handle *trans,
>         return 0;
>  }
>
> +static int validate_free_space_key(struct btrfs_block_group *block_group=
,
> +                                  const struct btrfs_key *key,
> +                                  u8 expected_type)
> +{
> +       const u64 end =3D btrfs_block_group_end(block_group);
> +
> +       if (unlikely(key->type !=3D expected_type)) {
> +               btrfs_err(block_group->fs_info,
> +                         "block group %llu has unexpected free space key=
 type %u, expected %u",
> +                         block_group->start, key->type, expected_type);
> +               return -EUCLEAN;
> +       }
> +
> +       if (unlikely(key->objectid + key->offset > end)) {
> +               btrfs_err(block_group->fs_info,
> +                         "block group %llu has invalid free space key (%=
llu %u %llu)",
> +                         block_group->start, key->objectid, key->type,
> +                         key->offset);
> +               return -EUCLEAN;
> +       }
> +
> +       return 0;
> +}
> +
>  static int load_free_space_bitmaps(struct btrfs_caching_control *caching=
_ctl,
>                                    struct btrfs_path *path,
>                                    u32 expected_extent_count)
> @@ -1576,8 +1600,10 @@ static int load_free_space_bitmaps(struct btrfs_ca=
ching_control *caching_ctl,
>                 if (key.type =3D=3D BTRFS_FREE_SPACE_INFO_KEY)
>                         break;
>
> -               ASSERT(key.type =3D=3D BTRFS_FREE_SPACE_BITMAP_KEY);
> -               ASSERT(key.objectid < end && key.objectid + key.offset <=
=3D end);
> +               ret =3D validate_free_space_key(block_group, &key,
> +                                             BTRFS_FREE_SPACE_BITMAP_KEY=
);
> +               if (unlikely(ret))
> +                       return ret;
>
>                 offset =3D key.objectid;
>                 while (offset < key.objectid + key.offset) {
> @@ -1633,7 +1659,6 @@ static int load_free_space_extents(struct btrfs_cac=
hing_control *caching_ctl,
>         struct btrfs_fs_info *fs_info =3D block_group->fs_info;
>         struct btrfs_root *root;
>         struct btrfs_key key;
> -       const u64 end =3D btrfs_block_group_end(block_group);
>         u64 total_found =3D 0;
>         u32 extent_count =3D 0;
>         int ret;
> @@ -1654,8 +1679,10 @@ static int load_free_space_extents(struct btrfs_ca=
ching_control *caching_ctl,
>                 if (key.type =3D=3D BTRFS_FREE_SPACE_INFO_KEY)
>                         break;
>
> -               ASSERT(key.type =3D=3D BTRFS_FREE_SPACE_EXTENT_KEY);
> -               ASSERT(key.objectid < end && key.objectid + key.offset <=
=3D end);
> +               ret =3D validate_free_space_key(block_group, &key,
> +                                             BTRFS_FREE_SPACE_EXTENT_KEY=
);
> +               if (unlikely(ret))
> +                       return ret;
>
>                 ret =3D btrfs_add_new_free_space(block_group, key.objecti=
d,
>                                                key.objectid + key.offset,
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1f15d0793a9c..ec24ffb6641d 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2129,6 +2129,10 @@ static int check_free_space_extent(struct extent_b=
uffer *leaf, struct btrfs_key
>                             blocksize, BTRFS_KEY_FMT_VALUE(key));
>                 return -EUCLEAN;
>         }
> +       if (unlikely(key->offset =3D=3D 0)) {
> +               generic_err(leaf, slot, "free space extent length is 0");
> +               return -EUCLEAN;
> +       }
>         if (unlikely(btrfs_item_size(leaf, slot) !=3D 0)) {
>                 generic_err(leaf, slot,
>                             "invalid item size for free space info, has %=
u expect 0",
> --
> 2.43.0
