Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002C8397923
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788852910; cv=pass; b=uC5qlu4xgEF7rWLW2GI4Z+4xdAURmAX+K0XKrcTB5oa3PCJRu2hSFP6bfuoKoaU5/X7Ukfl+85bn7iOtY68au7k8QjdA6/rDizhxm880HzdIftJocjhLms2UTrgwTLWoEdezJqq+aPEKjW8W5cM61aZdfuQAKt/Tusqrya2Apr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788852910; c=relaxed/simple;
	bh=UCPp1LqpK0m8mlZA8z6ARZlMP5wcArltCxdUX6lyQgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QiGowvR5xGkBrmR2otM2bSJfnkXXxwIBkNUeWwWW1HUlBPE1UFoboErDYSG83x9Pz47j7Ui3Saunxblzk6hIZ1+sNClqMnn6w7fargBMAzLxBX8d75TuKWSSxbCqLghQ/UplMTBQGQbMK4aur4nGOGWxlIp4EoeimBjDQeU+3rk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DLRpbLil; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DLRpbLil"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47de0093c42so4131422f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 00:35:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788852907; cv=none;
        d=google.com; s=arc-20260327;
        b=qTwV+ahwFu2ydxr2OaDrqLFF9cPHE7vJaZzYOIU1W8m/QmtbulpGI35ARcsUuvcFMk
         FC1cHktjYRIDcWtuy+XkuVCet2YCbDs/1Zdqh9zsc1J/iQnHo9mXg1DPi4eixOPc7XUa
         jFClexAhJygSFgPyoGh09LJ57I3YlOETQGP3Nq+YiDH5ZnrKqe4RDdSLUQsUoKIV4AzG
         CqwdvmVcj4I7/MBKkr2aZUUYFCH5VK479ES6dhttzKuB5gyexnr85j9Oz9psbNRIu5Me
         d7Il2uAeXAeXpNvCcbdlrJWPNgihVUptA9Upzs1SaNchDj79mxWjOqRzEsDjccHg83zp
         nJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CPNmcQ+jWBnGfd8fcM32ms4TKIj947hRdHaTvxckQqU=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=Jd0Df/v2fx7IoxJBOFkT/JHUVykx9n62S3U1w1rzLSSnbthOZyKDiXUzeqCm35hcin
         5ybinWv1PqF6lfhgzH6eOq6bC5Jy90GDl+4TYJXO9xRF/nARTtBaGO6/+mKvqbGTOd67
         On+yo/DHPdFaG4zq49W75FSz79YnOBz7R2ULdt3luo1ShUWYnJiiR1Y150MSxOqjuogx
         p8sg7ARUPWe0kyA9Lt+eGxTcqraC+rxULBg9VzEytrZM75xdYAcop3PlaiElN7VhLeDi
         PbgjpSww38+LFaAj+lymIv3wJv2V1gexk/uXn0uEjlktVGf21fh89T+4RT7VDJDgaD5o
         D7uQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788852907; x=1789457707; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CPNmcQ+jWBnGfd8fcM32ms4TKIj947hRdHaTvxckQqU=;
        b=DLRpbLilLGD6tmDs0o6kTIPn683rt7RLSTamVJK/yM4b8jlTvvB+3Kej6trIrrCOyR
         vXqLkIeofKxkBR9L7pw5n4UhjvZM2uwFdkdCXX/PzIYi0d+Sq5oY60bxlu9gUjWv1UZQ
         syytZP9YGYY9qI0FYp/HS7Y42LQkd5zKS0Z3tkN/6kI1XcuupEn3zQLDOqb4sW2kqwN0
         op9aRMbImH1vCYwFs3b799zkPXmdrT2PjcYp8AkXNZ87nbIl+6rW97VpSPK9eCyzneo+
         vAVcfXqqZJbr5FXi6plNrj+hOfgg7jT01+653u6yMMQHxbx2Z+eG2R+p2cYEdNd+1Jh/
         HCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788852907; x=1789457707;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CPNmcQ+jWBnGfd8fcM32ms4TKIj947hRdHaTvxckQqU=;
        b=pGx8XaD6oR1xUBNBliFDjVGEVA5DzKwlX7D72bSb4Tm9hMe2V/S8GSl9eRh9isEE4L
         lxiCggFTA517h1SO043c5ADEsTAhtIO9jrfUHAOu/PBEmKO9V7YvqGI6iYUTqr6dSqGm
         MdYBGkdHxn7kBpqstBpFGXCe+F96dKn8r26FUjq7HrKGRL7/OxenMPkML+nnD/+OVZC6
         nHZBVkDbt5wmaIaPDLnwQ0S6z8oNOnLJdk79O7c+nAd5yn1n7u//BysGrydhBEaJasnT
         iVh/6lqt/SuBdixSAJCZZPRYxCZle8MKgarC1B/ywf+a0UpDzuV8ese2wHdJhEaOcba/
         gkvA==
X-Gm-Message-State: AFuF++mq5L+obxtuvazoOn8x0QBwXr7axxsgLsfDxX60ysEkWDm0rd2z
	DAkEQDFjUAKZkdTOLMuM7jYIZAgNuTzvkqbyDHgwD077HU9JqAoVvIuLdmbrfr7Bx6D7ejaqPAV
	esPn0ACmYnMYaSJEKKd743sydIwlQ+PqoeEQJ1T4SuLhH3uw6jMzyXiERaw==
X-Gm-Gg: AYBFou2g4GVQq+rf94LyBdN12cKMMohCf1iAb4vBWkQKEvY7Nhtz+5k/V8DwGvS9yLZ
	hwPybkIJTGDVXDfHBHaA1SRk7RZ/jQHpwWyxMUEhPm4eIcQVvUQv89i4quDw5d7XvCkqPb7kBbC
	SDXtTRcUPifn6P+YOdw/z+/jmZYuzdiSeAMgLOTrZZzktPgmivCjbPFBC6LK4DM5LlVr4COOWEi
	bDTJ9lbWq/No4zvEwp/1b4Vi+58APs5Bepr2ISrT6YFD3sqJ899SnGXSY0YeIL1W5lBKUeBMwg+
	OkvniSUYmBOM+ryok14gFSFDDMD3TsJ9hJOPF7Pr1k2ag9zK7NEMfdXELPMaPeKK/eXfm63Q7f2
	d5HiRnd+hWQdqquDHkvgWLGR7mw8hRfnIU8KSd/OWDQ==
X-Received: by 2002:a05:6000:4694:b0:485:81fd:734c with SMTP id
 ffacd0b85a97d-485872c3dd5mr21621043f8f.24.1788852906815; Tue, 08 Sep 2026
 00:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1788851649.git.wqu@suse.com> <9cb5eed5ce0d396bad3f7fdd3d305f091bb434da.1788851649.git.wqu@suse.com>
In-Reply-To: <9cb5eed5ce0d396bad3f7fdd3d305f091bb434da.1788851649.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 8 Sep 2026 09:34:55 +0200
X-Gm-Features: AcwNN1Ucb2m1Hp2LJJXt8W4rVNW3T2G-KyaW7vxjtNK2OqjlHhXnHE5zUEFoqIM
Message-ID: <CAPjX3FcSj0OYqvO2f8CsTsX0oK4Pe=niAn-hCFYE8o49SVxVWg@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: use kvmalloc() for uncompress_inline()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 09:27, Qu Wenruo <wqu@suse.com> wrote:
> Although btrfs doesn't support inlined extents larger than PAGE_SIZE
> for bs > ps cases, it's still possible for the experimental bs > ps
> support to mount a btrfs created on a system with a much larger page size,
> thus can still hit an inlined extent that is way larger than the current
> page size.
>
> E.g. a compressed inline extent which has 32K compressed size, is created
> on 64K page sized arm64 with 64K sectorsize, then mounted on x86_64 with
> the experimental bs > ps support.
>
> In that case, when reading the compressed inline extent, we need to
> allocate a buffer that is the same size as the compressed inline extent
> (32K).
>
> That kmalloc() call will request physically contiguous memory for that
> 32K allocation, and if the system has a very fragmented memory space,
> such allocation can fail.
>
> But there is really no reason that we require such buffer to be
> physically contiguous, so change it to kvmalloc() to reduce the chance
> of allocation failure for bs > ps cases.
>
> And for all bs <= ps cases, the kvmalloc() call will just be fulfilled by
> kmalloc() so this will not bring any change to the most common cases.
> Only bs > ps will get the benefit of less memory allocation failure.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 59e92908c6c5..a85a7c561cf8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7133,7 +7133,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>         compress_type = btrfs_file_extent_compression(leaf, item);
>         max_size = btrfs_file_extent_ram_bytes(leaf, item);
>         inline_size = btrfs_file_extent_inline_item_len(leaf, path->slots[0]);
> -       tmp = kmalloc(inline_size, GFP_NOFS);
> +       tmp = kvmalloc(inline_size, GFP_NOFS);
>         if (!tmp)
>                 return -ENOMEM;
>         ptr = btrfs_file_extent_inline_start(item);
> @@ -7154,7 +7154,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>
>         if (max_size < blocksize)
>                 folio_zero_range(folio, max_size, blocksize - max_size);
> -       kfree(tmp);
> +       kvfree(tmp);
>         return ret;
>  }
>
> --
> 2.55.0
>
>
