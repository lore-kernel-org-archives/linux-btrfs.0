Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C337BA34
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 07:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776583962; cv=none; b=gQyrh3aGTprKLRWMgqQfgKV9yyLV5R/snJuOiHr3MOT6lju6O075ZcEZDBbPY/98t1ZkaDfVWLF6Ug/g3DwghAjlBI2z7f1bXIHmeKg9/jT+ksPfU4jvc7Y7zhacHMAc1uAkVlgWnacigdwtgufT+178zrRO3mA4NTsMrnNuVvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776583962; c=relaxed/simple;
	bh=3tFgH4aZpBPXSy1IqCDyyEjM/i/epvAl5TtYFUg84/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iLUtli1FBWpcqstCJ6lgLgx7UK90uWEO5I9RfLckXW2+PbwijhGyojj19Ycvnhg026fV40KcVonLIfn5nZPaeeJa/3zhbXbBfonEKujl9xzFz4TPXLD5LIW5DeOT73eR0vN2sEPlJDg4ElsBnAxa+am7IXmAg96AHfQFe8rC3Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ez209T/s; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ez209T/s"
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-35d9b4f93f0so361374a91.3
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 00:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776583960; x=1777188760; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=npT+H28EYaVcTpU3sV2g580nZpLNK+pMaq+XzZLp1fc=;
        b=Ez209T/sEBaizE7MFEzS8MDQrNfHzARFsOplmkaa0xttR1w0XPfibsHn4EX/HuEadT
         NCiOJ9LEDA1QOzsErn5y5mIGSmb4TkCRnWM1PBo1iTTkLc+nzGfPzvFEqNQSA813kb+J
         yNUjdGx06chT/ctjs1IbM8p9J9Kme8Z1oVtQodDF1L7Z7JLjg/g9UdMH/kZeBL7H1QLT
         IG9zsUVeW27b+S/wiuBN2xZERJKiXeCC73x6rNSHT8l+ftBaDe5XKI9CzcIpHje2LWWJ
         5O5gF/XWhK8k16H26Zf1e0uaDzYdledCmc+wokx77JUyrm4rP9LkMXcW/0rNKDwJ9Vbl
         HlAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776583960; x=1777188760;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npT+H28EYaVcTpU3sV2g580nZpLNK+pMaq+XzZLp1fc=;
        b=oADm2dIfAUqAZlhn3DTAJQt//sSqvJSNghOf5COaGGDahGbgeI8+Ql+YpS+B02fGx1
         uDVw+D0xuXZmiDVU2ykv2kzsLJn2/ofRfKUAT2IEaYxZulI+FQWA/BZsGfPcIgdl8/Sn
         8jfYRlRXujZuLxhqhSHi6hRXi51LZ+2mBzUqyy7UcisXHB+LbP8+zEilHHPdgsD0XZVB
         59cXrrClaDRdABvj+ujDE+Hi0fGZjveFi6cMi8AmYgM3FmhuM0n84z9hnwDThxSA4el3
         sciIdtpQqryojFfFFvshyX+U20SgCiWAxXTeAI+OCdJ+n9y4sLd5I3Vwni/sUwBsLYdk
         9AJA==
X-Forwarded-Encrypted: i=1; AFNElJ8bzSXC2/dczfDVxLXfREzltV8tHGYfccIiv1oFl2bAN1vgSkVy5KaN6bdqU6TUZS/ZHMdA43aqpjAG+w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2wc+hKG4rPlda+tF9g/hSW+nAWEV7p1lDFg6Ey1474QqdxvE5
	IkahEQED8u+DqoiNqQTNmDoWgN/ASGvvh2apVRxa45rX2Cf49lWA+tTo
X-Gm-Gg: AeBDievCk8RrfNZfPu/FPFBYDyfQNPuEHQL4LOqI7KtIpzy75EwDyqJFq+nR6TZ6dgB
	Gv6w4lldiNP056/K+/lwEBNvUPX7kjse8vfC61p61hUTglv4wMyyBuh2pmw+cPw/Ea5HcvD/7uf
	hhsDMRvnv317by3k5zKoRPM9ff2JdKt3jdf+kfnrFRuDWJqv0SRAkM4ryc4l8l9+OAYhhTqN0Ie
	jlDeVyqvW9JtBGOOnUHWwhATC1ZHSi+d6HKTuhIxGOiuD/pc0zeU8EdENKwjSzv+9fnXKXatM3x
	/Tdce6/gwJtYVESc+RU97MgZhqz7XRb0XnNUed+91HdRGbSNKizGULOzt0BgPl5kxDj7PzuDVZt
	+wwo6tIJHPOgG4Hnixifc5sqBVW/JsbErPndsnoH5F1QTxa3I27FYFm/bWI+8EvVghhC3ntubn8
	XGUsevZEx8M/JPQybMMAkadVzCP9xFLyP3e03fwPry3Lb6645F6KIwTtUGbHaob5t2VGy0jV3Vq
	8z1SCY3cjSYbMdn
X-Received: by 2002:a17:90b:4c8c:b0:35b:93d8:6ab9 with SMTP id 98e67ed59e1d1-36140465d7fmr5509884a91.3.1776583960419;
        Sun, 19 Apr 2026 00:32:40 -0700 (PDT)
Received: from ?IPV6:2408:8239:502:5512:180c:86b4:d220:939b? ([151.241.129.36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36140feea38sm6904200a91.6.2026.04.19.00.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2026 00:32:40 -0700 (PDT)
Message-ID: <1c71bc46-9135-4063-9c76-0db94643b671@gmail.com>
Date: Sun, 19 Apr 2026 15:32:37 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] btrfs: reduce size of struct btrfs_block_group
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1776278490.git.fdmanana@suse.com>
 <ef130a3bd2f994d615e9b7dc8b17132b6c3a7fc1.1776278490.git.fdmanana@suse.com>
Content-Language: en-US
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <ef130a3bd2f994d615e9b7dc8b17132b6c3a7fc1.1776278490.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>    struct btrfs_block_group {
>          struct btrfs_fs_info *     fs_info;              /*     0     8 */
>          struct btrfs_inode *       inode;                /*     8     8 */
>          spinlock_t                 lock __attribute__((__aligned__(4))); /*    16     4 */
>          unsigned int               ro;                   /*    20     4 */
>          u64                        start;                /*    24     8 */
>          u64                        length;               /*    32     8 */
>          u64                        pinned;               /*    40     8 */
>          u64                        reserved;             /*    48     8 */
>          u64                        used;                 /*    56     8 */
>          /* --- cacheline 1 boundary (64 bytes) --- */
>          u64                        delalloc_bytes;       /*    64     8 */
>          u64                        bytes_super;          /*    72     8 */
>          u64                        flags;                /*    80     8 */
>          u64                        cache_generation;     /*    88     8 */
>          u64                        global_root_id;       /*    96     8 */
>          u64                        remap_bytes;          /*   104     8 */
>          u32                        identity_remap_count; /*   112     4 */
>          u32                        last_identity_remap_count; /*   116     4 */
>          u64                        last_used;            /*   120     8 */
>          /* --- cacheline 2 boundary (128 bytes) --- */
>          u64                        last_remap_bytes;     /*   128     8 */
>          u64                        last_flags;           /*   136     8 */
>          u32                        bitmap_high_thresh;   /*   144     4 */
>          u32                        bitmap_low_thresh;    /*   148     4 */
>          struct rw_semaphore        data_rwsem __attribute__((__aligned__(8))); /*   152    40 */
>          /* --- cacheline 3 boundary (192 bytes) --- */
>          long unsigned int          full_stripe_len;      /*   192     8 */
>          long unsigned int          runtime_flags;        /*   200     8 */
>          int                        disk_cache_state;     /*   208     4 */
This seems always used as enum btrfs_disk_cache_state
>          int                        cached;               /*   212     4 */
This seems always used as enum btrfs_caching_type

Maybe we could change them to use the more proper type in this patch 
series for better type safety and self documenting.

Thanks,
Sun YangKai
>          struct btrfs_caching_control * caching_ctl;      /*   216     8 */
>          struct btrfs_space_info *  space_info;           /*   224     8 */
>          struct btrfs_free_space_ctl * free_space_ctl;    /*   232     8 */
>          struct rb_node             cache_node __attribute__((__aligned__(8))); /*   240    24 */
>          /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
>          struct list_head           list;                 /*   264    16 */
>          refcount_t                 refs __attribute__((__aligned__(4))); /*   280     4 */
>          atomic_t                   frozen __attribute__((__aligned__(4))); /*   284     4 */
>          struct list_head           cluster_list;         /*   288    16 */
>          struct list_head           bg_list;              /*   304    16 */
>          /* --- cacheline 5 boundary (320 bytes) --- */
>          struct list_head           ro_list;              /*   320    16 */
>          struct list_head           discard_list;         /*   336    16 */
>          int                        discard_index;        /*   352     4 */
>          enum btrfs_discard_state   discard_state;        /*   356     4 */
>          u64                        discard_eligible_time; /*   360     8 */
>          u64                        discard_cursor;       /*   368     8 */
>          struct list_head           dirty_list;           /*   376    16 */
>          /* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
>          struct list_head           io_list;              /*   392    16 */
>          struct btrfs_io_ctl        io_ctl;               /*   408    72 */
>          /* --- cacheline 7 boundary (448 bytes) was 32 bytes ago --- */
>          atomic_t                   reservations __attribute__((__aligned__(4))); /*   480     4 */
>          atomic_t                   nocow_writers __attribute__((__aligned__(4))); /*   484     4 */
>          struct mutex               free_space_lock __attribute__((__aligned__(8))); /*   488    32 */
>          /* --- cacheline 8 boundary (512 bytes) was 8 bytes ago --- */
>          bool                       using_free_space_bitmaps; /*   520     1 */
>          bool                       using_free_space_bitmaps_cached; /*   521     1 */
> 
>          /* XXX 2 bytes hole, try to pack */
>          /* Bitfield combined with previous fields */
> 
>          static enum btrfs_block_group_size_class size_class; /*     0: 0  0 */
>          int                        swap_extents;         /*   524     4 */
>          u64                        alloc_offset;         /*   528     8 */
>          u64                        zone_unusable;        /*   536     8 */
>          u64                        zone_capacity;        /*   544     8 */
>          u64                        meta_write_pointer;   /*   552     8 */
>          struct btrfs_chunk_map *   physical_map;         /*   560     8 */
>          struct list_head           active_bg_list;       /*   568    16 */
>          /* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
>          struct work_struct         zone_finish_work;     /*   584    32 */
>          struct extent_buffer *     last_eb;              /*   616     8 */
>          u64                        reclaim_mark;         /*   624     8 */
> 
>          /* size: 632, cachelines: 10, members: 60, static members: 1 */
>          /* sum members: 630, holes: 1, sum holes: 2 */
>          /* sum bitfield members: 8 bits (1 bytes) */
>          /* forced alignments: 8 */
>          /* last cacheline: 56 bytes */
> 
>          /* BRAIN FART ALERT! 632 bytes != 630 (member bytes) + 8 (member bits) + 2 (byte holes) + 0 (bit holes), diff = -8 bits */
>    } __attribute__((__aligned__(8)));
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/block-group.h | 33 ++++++++++++++++-----------------
>   1 file changed, 16 insertions(+), 17 deletions(-)


