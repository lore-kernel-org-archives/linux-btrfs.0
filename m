Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9533C532
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776693649; cv=none; b=tjBTY8di0FEtBLFMEtru5o/rT6akGbwYMVdvIxKkVvMP9AtqcVRo7q6XiCXRgsG6/jjaz6DtbOY+h853f4lOC3pQjyYUc5nv7mmFthoD3ZNT8fYkKMlVGulvPf4QyppoGyyaHqjswyEGCsPCHYkf62T8GayFknL/6Md8qruj4AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776693649; c=relaxed/simple;
	bh=HZ9Hq8U7K8cZXYyq9tHXh7SuORtQQ7CXDALwl0gs7Ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n7qkMyaMbERmFG+JCDNKfJjyi/hAIodfg4Iy8P/t9LtxWWCsT1cbwXeq9drHZX0T0nozJV+zqid6VWhBcQQ/WQT1bbUPAoTxXDDs6EaHSs50f7fgf+kbzVG5g+FetizRT5lfXcO5tZbiwcug4e0/HiJWKMxjUBqLGsejOebH8Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKdYC/yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKdYC/yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE005C2BCB4
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693648;
	bh=HZ9Hq8U7K8cZXYyq9tHXh7SuORtQQ7CXDALwl0gs7Ro=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZKdYC/ynXLR9eUkGaZglTEtDBAL0TicQkOOxg9UDePpa2F+iVakoG24m6gcs5gzVO
	 Jog5EeOxOqs0gaeLH1AeUopkoUgAAKHRoMtLC5vJE5qUcdCM5bya3qYkN6c2aT5can
	 M3bo8+75mF5+Wal2/lvg0ZmXLH7KA1B2AxdBDw0q7iob0rs7Bqs7EUWvCXM9S/Zhsn
	 MuB+BEI/7XYokJOeaiqcFG7fApjrVrQmyidbPkLYjK4NtMcd1ww/hF8eSK5DCJcaEu
	 yExcxpSnt486tStxpxj+KmvJ4AKuj2tXN5qbY/8IbAIZQhcZRSt/mnXwVLQbOOapO4
	 Oxa+VzRbogibQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b941762394aso420360466b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 07:00:48 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx2usTraKaPhAyNENvQ+6ZZBl/KDihT95taoGNbSDVG0T6ZiI3s
	Qxt3GysvMNUe8LJyJc7r1jU3YBiM+MBFGqvl3Uqf/gAJq1LoI75D1bFXC0wTuGbOI4TAtHDv96e
	yaKkSOfIgbllLOAGBkxQXdJ4BvQpFITc=
X-Received: by 2002:a17:907:742:b0:b96:e593:fd1e with SMTP id
 a640c23a62f3a-ba415bae09cmr688679366b.0.1776693647179; Mon, 20 Apr 2026
 07:00:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776278490.git.fdmanana@suse.com> <ef130a3bd2f994d615e9b7dc8b17132b6c3a7fc1.1776278490.git.fdmanana@suse.com>
 <1c71bc46-9135-4063-9c76-0db94643b671@gmail.com>
In-Reply-To: <1c71bc46-9135-4063-9c76-0db94643b671@gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 20 Apr 2026 15:00:09 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6GYZXakNr14bn8JCrYczMgbb839eRW7ydEewzaM2D=Yw@mail.gmail.com>
X-Gm-Features: AQROBzC_WZpPZrCSTHCu43UIIeCgwkcqP17jKbsWIUuCOoNX_S21jLkWRsSHJxU
Message-ID: <CAL3q7H6GYZXakNr14bn8JCrYczMgbb839eRW7ydEewzaM2D=Yw@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] btrfs: reduce size of struct btrfs_block_group
To: Sun YangKai <sunk67188@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 8:32=E2=80=AFAM Sun YangKai <sunk67188@gmail.com> w=
rote:
>
> >    struct btrfs_block_group {
> >          struct btrfs_fs_info *     fs_info;              /*     0     =
8 */
> >          struct btrfs_inode *       inode;                /*     8     =
8 */
> >          spinlock_t                 lock __attribute__((__aligned__(4))=
); /*    16     4 */
> >          unsigned int               ro;                   /*    20     =
4 */
> >          u64                        start;                /*    24     =
8 */
> >          u64                        length;               /*    32     =
8 */
> >          u64                        pinned;               /*    40     =
8 */
> >          u64                        reserved;             /*    48     =
8 */
> >          u64                        used;                 /*    56     =
8 */
> >          /* --- cacheline 1 boundary (64 bytes) --- */
> >          u64                        delalloc_bytes;       /*    64     =
8 */
> >          u64                        bytes_super;          /*    72     =
8 */
> >          u64                        flags;                /*    80     =
8 */
> >          u64                        cache_generation;     /*    88     =
8 */
> >          u64                        global_root_id;       /*    96     =
8 */
> >          u64                        remap_bytes;          /*   104     =
8 */
> >          u32                        identity_remap_count; /*   112     =
4 */
> >          u32                        last_identity_remap_count; /*   116=
     4 */
> >          u64                        last_used;            /*   120     =
8 */
> >          /* --- cacheline 2 boundary (128 bytes) --- */
> >          u64                        last_remap_bytes;     /*   128     =
8 */
> >          u64                        last_flags;           /*   136     =
8 */
> >          u32                        bitmap_high_thresh;   /*   144     =
4 */
> >          u32                        bitmap_low_thresh;    /*   148     =
4 */
> >          struct rw_semaphore        data_rwsem __attribute__((__aligned=
__(8))); /*   152    40 */
> >          /* --- cacheline 3 boundary (192 bytes) --- */
> >          long unsigned int          full_stripe_len;      /*   192     =
8 */
> >          long unsigned int          runtime_flags;        /*   200     =
8 */
> >          int                        disk_cache_state;     /*   208     =
4 */
> This seems always used as enum btrfs_disk_cache_state
> >          int                        cached;               /*   212     =
4 */
> This seems always used as enum btrfs_caching_type
>
> Maybe we could change them to use the more proper type in this patch
> series for better type safety and self documenting.

Yes, it's better to use the enums for more clarity.

I'm sure the structure has many areas for improvement, but the goal
here was just to eliminate holes.

I've sent a patch to change the ints to enums, thanks.

>
> Thanks,
> Sun YangKai
> >          struct btrfs_caching_control * caching_ctl;      /*   216     =
8 */
> >          struct btrfs_space_info *  space_info;           /*   224     =
8 */
> >          struct btrfs_free_space_ctl * free_space_ctl;    /*   232     =
8 */
> >          struct rb_node             cache_node __attribute__((__aligned=
__(8))); /*   240    24 */
> >          /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> >          struct list_head           list;                 /*   264    1=
6 */
> >          refcount_t                 refs __attribute__((__aligned__(4))=
); /*   280     4 */
> >          atomic_t                   frozen __attribute__((__aligned__(4=
))); /*   284     4 */
> >          struct list_head           cluster_list;         /*   288    1=
6 */
> >          struct list_head           bg_list;              /*   304    1=
6 */
> >          /* --- cacheline 5 boundary (320 bytes) --- */
> >          struct list_head           ro_list;              /*   320    1=
6 */
> >          struct list_head           discard_list;         /*   336    1=
6 */
> >          int                        discard_index;        /*   352     =
4 */
> >          enum btrfs_discard_state   discard_state;        /*   356     =
4 */
> >          u64                        discard_eligible_time; /*   360    =
 8 */
> >          u64                        discard_cursor;       /*   368     =
8 */
> >          struct list_head           dirty_list;           /*   376    1=
6 */
> >          /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
> >          struct list_head           io_list;              /*   392    1=
6 */
> >          struct btrfs_io_ctl        io_ctl;               /*   408    7=
2 */
> >          /* --- cacheline 7 boundary (448 bytes) was 32 bytes ago --- *=
/
> >          atomic_t                   reservations __attribute__((__align=
ed__(4))); /*   480     4 */
> >          atomic_t                   nocow_writers __attribute__((__alig=
ned__(4))); /*   484     4 */
> >          struct mutex               free_space_lock __attribute__((__al=
igned__(8))); /*   488    32 */
> >          /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
> >          bool                       using_free_space_bitmaps; /*   520 =
    1 */
> >          bool                       using_free_space_bitmaps_cached; /*=
   521     1 */
> >
> >          /* XXX 2 bytes hole, try to pack */
> >          /* Bitfield combined with previous fields */
> >
> >          static enum btrfs_block_group_size_class size_class; /*     0:=
 0  0 */
> >          int                        swap_extents;         /*   524     =
4 */
> >          u64                        alloc_offset;         /*   528     =
8 */
> >          u64                        zone_unusable;        /*   536     =
8 */
> >          u64                        zone_capacity;        /*   544     =
8 */
> >          u64                        meta_write_pointer;   /*   552     =
8 */
> >          struct btrfs_chunk_map *   physical_map;         /*   560     =
8 */
> >          struct list_head           active_bg_list;       /*   568    1=
6 */
> >          /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> >          struct work_struct         zone_finish_work;     /*   584    3=
2 */
> >          struct extent_buffer *     last_eb;              /*   616     =
8 */
> >          u64                        reclaim_mark;         /*   624     =
8 */
> >
> >          /* size: 632, cachelines: 10, members: 60, static members: 1 *=
/
> >          /* sum members: 630, holes: 1, sum holes: 2 */
> >          /* sum bitfield members: 8 bits (1 bytes) */
> >          /* forced alignments: 8 */
> >          /* last cacheline: 56 bytes */
> >
> >          /* BRAIN FART ALERT! 632 bytes !=3D 630 (member bytes) + 8 (me=
mber bits) + 2 (byte holes) + 0 (bit holes), diff =3D -8 bits */
> >    } __attribute__((__aligned__(8)));
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >   fs/btrfs/block-group.h | 33 ++++++++++++++++-----------------
> >   1 file changed, 16 insertions(+), 17 deletions(-)
>
>
