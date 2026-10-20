Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792500224;
	b=XHQMqblX6D5LjqrXEq4b9VaUqKkgOz4YV0haTpHIE/J6xmeq3Sfm1AImC9z0QKwQ3r50
	 QE2rhWNqeeSppfh5dsCha/3/ysAJArCh7khhspsPIujmonVhiqYtSiUTPrydUb4oFQ2R6
	 F12Rm8Q0e67JP4rHVoExJCaHI99aI5R9qGDblhgDSmZ2KH+Suhs6xYcS5QzuHxgUljQrX
	 xtJK3Rp9d5c8UdjIktj3sMb5Kn9gYw+43NIT0UKxqxJ519kcM7Q407ZEnogNc16srJL9C
	 ZOMe0YR8/ahjZQilwyStndbBVngdD6WJEfVvc6Id7uHYcIkRIwfmNoNaT0WNPfRet2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=uBuE6YbpoGf01aztAhtkRQwTBbPOMwzMmgWFgoU4Ai0=;
	b=g92420+ZpBDUYrIiVncoTukR5rS5D5OmGc5ETmLkpogMzTY8yWhaLW/W4+YhMwk+agTb
	 /iF3eQP+1AofxDt9cyggvq8VBNZm7vQuN8pmO+L5A5LRJAe+D28bC43rGx8841ll4DUp6
	 1NCBLGzjZV5+rqWD/8LoZn/Hd/c217+68xyNZL2FeB9YUDAxEi2gwcr4LX43+FOYx2onr
	 F/98F1+HDA8rEyx0k969yBOHWdNyZ5JQsDeU7WkL8k+aVQr8cV20i9m4kh2/MBYvsxHwm
	 Xzd9fWiH5iF+owhxLVglTbo2bRnC1euuL9nAP0f0gODyrFCFLj1rybLq8ae94lSx7ww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DKWyuPNY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F0606A322
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 12:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE9F0606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=DKWyuPNY
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1f403aca0so5707985e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 05:43:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792500222; cv=none;
        d=google.com; s=arc-20260327;
        b=pDw7Wq3grKSWW8Rcrp8GDsj92GgjGdKp2Ht4SZRhjN9pYiaDSPHTZ4mvywIJb04VTu
         LQCMcZJglGPeJ1ZrXxdI7Mo/8qtTiVF8Ln+gTR2oBRAQoyFA6VOrAjyxWPsGLeLgoIAw
         ZJs0z7G3oLOdOYMiFS5n8Cdevr81fOncGDh+Xju23aGlZyFTU/KvLxEQjMlxBIPRN8S+
         IaJpkgGLHvs18nuFTKXyrqWUpOC8Ips0T/NNO3CMFDP4QNqF4/tG0is5kctVYrNzFHeU
         eH01UteMnSKnQvPT+d4/uQT7HObBd1ILR7S0uYK/tjq4DOmPrkUrLPp+xczURWEAVFVf
         B+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=uBuE6YbpoGf01aztAhtkRQwTBbPOMwzMmgWFgoU4Ai0=;
        fh=DNhRoUogv4njemsTPAOB4Tb4wfg3Mu7IYlLDA9H4+4Y=;
        b=Q+JDeQEpPox2Pi9zT1oqF6CLtczkFuLpUoeE6uI7ThsgeDQ6x8qPXI36nBieFaoK5+
         xa/IL1Y/wFxB4vVCj3BCSeOrXy5FdBiHsBNcCiDegmZI/Ese7s3nwm3ZNsH2W7ZBNjgw
         zuZuSYe7GdJe4VOloD8qXlQBUcZkY7G+h/TkhREf1oh6iWIfKnqf6yJe0GmDfxPYFOjI
         VygUgR6Mns6CGITEw51YmosdzJfVyq1vkuSV+VZk0z9GktnE5fPw4aFx9/JsSmMsuezP
         Dn6e9YhPZJJe2PWbvNGl3dcEa69Kd1TkX5boBLCkDWSdslIBPg7Kt1xDthZMD9JMa6O3
         LO+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792500222; x=1793105022; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uBuE6YbpoGf01aztAhtkRQwTBbPOMwzMmgWFgoU4Ai0=;
        b=DKWyuPNYZM3zoBMq2qUaC/mU+ft8Elckc+qWQIF4zBMuEw0pVWeA7jKJ/VNMhT35pO
         GwzC32Pc8wZy4/o/lh/OrBIeO7Mbhu8556Dg7ddQwhJHOvoYodFDysQ4HpcAzII0xRv9
         lWHQmcZDqO9pBkTHgH0FOb0MoxwXeH4zWYGsddh5gx9nncWMVMnj2mR8WbHwFBERj7Qu
         qRkZ/Nmx3pN3Ut7UDVAd5wCLH/uVUH8CrowEnNG9W8vBb/ee9OibQmyLUAp7xrsewbeQ
         iOLRrjUweQyr91pjZ3xW+i6nN8epK8nD1Boebc/YW130wPyrioxOGReftrbWpwvJhiIF
         kRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792500222; x=1793105022;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=uBuE6YbpoGf01aztAhtkRQwTBbPOMwzMmgWFgoU4Ai0=;
        b=i2AHP471BLmiH+p5lbfGJ2XH3BLrKGL4GeUOHiB3XW+GKxjVmRL7tdFX4XGrG3a4wo
         tJzdIwztE37ZPtDMADFpjMgpCkT1jHeVx8cvQm6DSkSU8AlDLpZXpGhHISG5ntSzLYI4
         4+UbIhMr9/09BCwG+qb/EjSZQ38WCJAO0EycbyjdZHUSt0Za6BiUH4rgib6jYwrll5Ih
         zbqdd8bW0jT/35IEc/8ub5INo28oIyVgTzDgnfO3miNQ2U9lXHitsjh4yNYI7dz3UttD
         mPeQkFBCOaMXkkeu51rGz/CssnHdde2KnNkdoRltC3K9xHfhFVW8VLMDhy0h59/Qjt8o
         AfCQ==
X-Gm-Message-State: AFq9FYJGvy6gD2vakvZ3/AwhBYn/DiT43mvA/DG4ZJjipAumCzv1lJjy
	omIYmNLfl1+dbQrIq1yT0BlV9ghNFw5Gf8H58iMkOsTgPX4IQQytNWuEjF74t6TP7Ithj5MGE93
	kk2cD3hgqU4PNBXH4stKxiiBi5gF7/F+1v/9KFoLGHg==
X-Gm-Gg: AYBFou145Gu1Z47223JXm/wmpBHQm7g9cCZ5aLKo3QoeK6qnaWIoVuS75lNFFcz2+5z
	4YBoSc4CDRJCnE7XlyrVNdYzG0OOdrULk4H3n11aH4Ftiy2t4y5ZH+Hxv5JtIyiCpP9lH11kv2X
	wWHSP2kOU2g5vomkCsoKJyPpSEZcsnu7UBXXTQ58vbxWEYTDnYLYMwHZ2tuHC9IK1XF3kpO2xPz
	Po3AtwCIIwXtghIFlgxg8haqQoKQfRLyH4SSyVcFo4N4L0QnmpRFAKIf6BEneb7c3+mp2qWPpg5
	RQjclr7F44VKpbdhrJEc7k3R2vG6tqj8PpudM03B0hiU+9ppz53YCfHrGhlxbAujar+4INSc+K0
	UvSbEDWLAcWTl/lsJFW7isCsU84pm3bnKLCzb3DCLFXy6h0zJ2wJr
X-Received: by 2002:a05:600c:4e8a:b0:4a1:cedc:ab51 with SMTP id
 5b1f17b1804b1-4a1d76315d7mr247170255e9.35.1792500222015; Tue, 20 Oct 2026
 05:43:42 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com> <20261002073715.2191177-4-johannes.thumshirn@wdc.com>
In-Reply-To: <20261002073715.2191177-4-johannes.thumshirn@wdc.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 20 Oct 2026 14:43:30 +0200
X-Gm-Features: AclHuK9pZysaaT_P9IDRxZNCvMLXoOx3_gpjkvG_BtKuz2NTdVBJTlQEbvune8o
Message-ID: <CAPjX3FcGedb5oap18m7wvKRvaR=wcUJVUVazg0_--RN-9SqzDw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] btrfs: zoned: requeue block group if zone reset
 bails out
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Oct 2026 at 09:41, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
> btrfs_reset_unused_block_groups() drops the block-group from
> fs_info->unused_bgs before performing the work that can actually fail,
> the actual submission of a REQ_OP_ZONE_RESET.
>
> Every failed operation after this leaves the block-group dangling,
> physically reset, but the in-memory structures aren't and it is not
> requeued to be reset on fs_info->unused_bgs.
>
> Instead of bailing out, re-add this block-group to fs_info->unused_bgs
> list.
>
> Fixes: 453a73c3069a ("btrfs: zoned: reclaim unused zone by zone resetting")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 261e7991c1d1..96d3957db87f 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3137,6 +3137,8 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>  {
>         struct btrfs_fs_info *fs_info = space_info->fs_info;
>         const sector_t zone_size_sectors = fs_info->zone_size >> SECTOR_SHIFT;
> +       LIST_HEAD(retry_list);
> +       int ret = 0;
>
>         if (!btrfs_is_zoned(fs_info))
>                 return 0;
> @@ -3178,11 +3180,10 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>                 }
>                 if (!found) {
>                         spin_unlock(&fs_info->unused_bgs_lock);
> -                       return 0;
> +                       goto out;
>                 }
>
>                 list_del_init(&bg->bg_list);
> -               btrfs_put_block_group(bg);
>                 spin_unlock(&fs_info->unused_bgs_lock);
>
>                 /*
> @@ -3196,7 +3197,6 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>                 for (int i = 0; i < map->num_stripes; i++) {
>                         struct btrfs_io_stripe *stripe = &map->stripes[i];
>                         unsigned int nofs_flags;
> -                       int ret;
>
>                         nofs_flags = memalloc_nofs_save();
>                         ret = blkdev_zone_mgmt(stripe->dev->bdev, REQ_OP_ZONE_RESET,
> @@ -3206,7 +3206,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>
>                         if (ret) {
>                                 up_read(&fs_info->dev_replace.rwsem);
> -                               return ret;
> +                               goto requeue;
>                         }
>                 }
>                 up_read(&fs_info->dev_replace.rwsem);
> @@ -3217,7 +3217,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>                 if (bg->ro) {
>                         spin_unlock(&bg->lock);
>                         spin_unlock(&space_info->lock);
> -                       continue;
> +                       goto requeue;
>                 }
>
>                 reclaimed = bg->alloc_offset;
> @@ -3246,12 +3246,30 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>                 btrfs_return_free_space(space_info, reclaimed);
>                 spin_unlock(&space_info->lock);
>
> +               btrfs_put_block_group(bg);
> +
>                 if (num_bytes <= reclaimed)
>                         break;
>                 num_bytes -= reclaimed;
> +               continue;
> +
> +requeue:
> +               spin_lock(&fs_info->unused_bgs_lock);
> +               list_add_tail(&bg->bg_list, &retry_list);
> +               spin_unlock(&fs_info->unused_bgs_lock);

No need for the lock here, you're adding to a private list on the stack.

> +               if (ret)
> +                       goto out;
>         }
>
> -       return 0;
> +out:
> +       if (!list_empty(&retry_list)) {
> +               spin_lock(&fs_info->unused_bgs_lock);
> +               list_splice_tail(&retry_list, &fs_info->unused_bgs);

So you're picking from the head but putting back on the tail, right?

--nX

> +               spin_unlock(&fs_info->unused_bgs_lock);
> +       }
> +
> +       return ret;
>  }
>
>  void btrfs_show_zoned_stats(struct btrfs_fs_info *fs_info, struct seq_file *seq)
> --
> 2.55.0
>
>
