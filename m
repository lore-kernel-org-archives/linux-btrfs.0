Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289E051A747
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 17:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789628; cv=pass; b=OpOJBQBU46qzu8hDLj5/QQhqR7QEwDlAXN/bG84A4F1NKndouxMQ/+ha/7EQ7mCL3f9Ireda3NvYBpauNzxFnPcoWYKzSmkYUr2dGhpVcg0BeKXGDiHuVRIXom3KLb510G14GUfG15KjJ33/YltjGaEUW5Hsi0QB2rsNJKsQRTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789628; c=relaxed/simple;
	bh=f+eP9eg1LSm0z4XawwkxflBfTSrP6g+K4kFzr9Xfpbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LHSpO2NJqJaxcbH53yVoH/zu5fvnxYCEzwcxb/VYs64WHGhl1siuLcN2MpcTeRnsPKRSbp2dB4zPwh6IrS7XYDPBNMPco7BmVSed36WP5PhRI7WMV5DqhXr12xhArrn5pfqbMZuk7uAW9c5VLxkhT6q+g+ZZaj6s71CDM6ifsgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OQKVc2mx; arc=pass smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OQKVc2mx"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b00a0ac65so623350f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 10:33:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790789625; cv=none;
        d=google.com; s=arc-20260327;
        b=SBqgimpzn35v7Jauj8rPZYC2/6LyXQWbvrAG3Av9I/wTuQWKb1e6WeG0qf81xfGNb0
         Eik0/dBNT1/1EtjWUqV4cYwC7cVi2q45j8scKzSi263ww0UJMSmK3JmE5xZ5hcbHv4EF
         OFdrH4PjwnFat6I3nbxiX0IUjq4GpiMuGwPc5brQH8AfbITf4HP7TwgVbsA1NjWYdglK
         0NLcDuIajTkm2H/lQq6HMQ9QYX3ZH0EXCO/anlSB91RkToIWfRgZQodsLb1Wyy8j3kQA
         Ipq0RxlI54+66k4Yfdadbk9P9NZsMXqOXdFHU0GBaRsafAQPYMrkNziBU4hy2gO09yF6
         JaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WxXwNRvrrHD//OC3rgwnpm5uifEc6/akA6lCXtxMkuk=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=VANluYnecvTVwtXgfwjBs6D3lIy0ET+sIM4OG3ZSVsL67pc26vmQGA+LxK4PQMDToi
         LD8+246m9C69oL+r5AzUMjvGsyZnvUU6o5YsUkjIbQmq64uZ3y8AkVE/AZALbVvhPEEH
         5/+YEJ4tboPR82bNpqxqTnYQmREuTlot/P1tHF+b09c+5Qqr/wCT7U4cI9TEo/XuQxv1
         1QRKYA8JD4TzzJR3AJ21rMHHNyN8O1vYR0fEiqrhFqZ1qg6TGasH6qwUnswsCqYcM1b/
         O31JicC2LfLaGQrXMrACWps+yKotD6XYSWyuH5XNVnHvL9DaI8yx7Q0uDyKw0Tm7lq6d
         dEBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790789625; x=1791394425; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WxXwNRvrrHD//OC3rgwnpm5uifEc6/akA6lCXtxMkuk=;
        b=OQKVc2mxujHmU9pes425tNVYeY3e/7LRxyiUzGpO+1DEJRM9hGz6vKYBvUX9xVsLze
         VHaY5qoFsSxQKeN2NS/crSuU53QH5OXNe0z/puFhJy1yU4ninZnPF5LVMT9/n7JHhKxR
         EWmdLmnIzAZjlaiPjlNozJpBSpxmhASvZ9Zd3bns0IzeDanD8zEjHDYiPCr+IYSU3qwh
         qFOl29e0M+8FIsnGEqBVSDw1eBmkC+zIgCJjLFjpaSxnUGlyDVCKxmzyIJnSFfROoYba
         nOUDUJwItnjy3Bmg01bMnUg3ZCwUMCW86srXF0eC4v5JUl31z3hYBbuqJiBxPBcNdA8Q
         Gpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790789625; x=1791394425;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WxXwNRvrrHD//OC3rgwnpm5uifEc6/akA6lCXtxMkuk=;
        b=t5LQaLKyLfuR7MMCLoB0rgmzUf+QpudBrUux2yFwAYWC1SbNK3Z0hn1oai4h+YJ/xR
         uiuKe9W5I4GzAkuRf4rsrqJHI2PqeB4jGuuQMFrQneTCyy0J+9s82hYHrmnITV+JhEjK
         2MJktoACsovyRfGmhdZYs1M5ZeDrCZv85nsGBut4iNttFX2v5rihStBGjCFU3sXijYLS
         xJqP6tA/Mrs978cH+ZsUm8gp48joV3nlG2NcPtvKL4338wiNqgRBONrNmzEGaV45ZWsn
         rsGgeHki/H5WwSMraIs9zKwgRyc7sR/nhGJr159xF6nN9UzP1FQBH/zKrlFzXMBuQH5z
         sovg==
X-Gm-Message-State: AFq9FYLNMjpc/EHe2BJVsuj2ziDnfBf1UzdqcE77j/JEWyvAC8jgHtdV
	FsgUtQdiMayE6DL6d6taC9OWyJMeaCikWqNStUTyL2bS4w73qncaqcsAIEt/VbRRrlDHyJcpsuk
	WuG3muiZEiubwEQEmAynYupeeIWgOLddgj0BgOxXlkn4xOVzH0E5O3w8=
X-Gm-Gg: AYBFou3z1PB14Pl4YX/Fs+JDOcnPrbz7mgT18g6b7P7PKfDgUZdQubDUNay+cW4j83U
	n1kcfQzVPdTrG2jV2s8VebwDC9/DZFPAqPnyPLTOMlkhFyva8zDqvzVSpAt1alBVmk66Iy26m2/
	105m1ciouTBzX9A8b0iLYj99tSewPdfamzxgpGOZANNAjmTd8XO5FGSmHkMVK2o8y4x35wswTQj
	LM/gNXAHP/9KvgkV7K3oZLT/XTELF+xv2iaZCvXBScbPddQOki/4UemSJvjmfnaJrZ5QHZTP9Po
	37SszJGDN1cGSAWKihyF4YGQRROdqDzHVhsMLE6iyY1/JOveDXJJecrf1MZ3Kx2P26ie3MhVQBk
	PiOT18R+qU6/W9HYg8xB/hq524CzmLaym3UTa3XCyMzI+O4qk8qR6
X-Received: by 2002:a05:6000:4387:b0:48a:efc9:2428 with SMTP id
 ffacd0b85a97d-48b0250b16dmr5059670f8f.33.1790789625237; Wed, 30 Sep 2026
 10:33:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d424b06da106d3e4bc54416eca428701647e8f08.1790781569.git.fdmanana@suse.com>
In-Reply-To: <d424b06da106d3e4bc54416eca428701647e8f08.1790781569.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 30 Sep 2026 19:33:33 +0200
X-Gm-Features: AclHuK-FCQc3S1ZtN50ZF5_0Qr_urW1fylEq13tohpcJuEV4veWA5zYsa7WKHbI
Message-ID: <CAPjX3Fc-PEuwwOCoHS2q-Nz8wwfi3=P0jB=oQPdyaXJgGTCZ-A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix off-by-one end offset check in report_setget_bounds()
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Sept 2026 at 17:20, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> The addressable range with an extent buffer goes from byte 0 to byte
> eb->len - 1, so if a byte address matches eb->len, it's already beyond
> the addressable range and we should log that it's bad start address
> and not end address.
>
> Fixes: 234fdd2815ce ("btrfs: remove redundant check in up check_setget_bounds")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

I agree, looks good to me.

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/accessors.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/accessors.c b/fs/btrfs/accessors.c
> index 1248aa2535d3..d63ac6eb92de 100644
> --- a/fs/btrfs/accessors.c
> +++ b/fs/btrfs/accessors.c
> @@ -16,7 +16,7 @@ static void __cold report_setget_bounds(const struct extent_buffer *eb,
>
>         btrfs_warn(eb->fs_info,
>                    "bad eb member %s: ptr 0x%lx start %llu member offset %lu size %d",
> -                  (member_offset > eb->len ? "start" : "end"),
> +                  (member_offset >= eb->len ? "start" : "end"),
>                    (unsigned long)ptr, eb->start, member_offset, size);
>  }
>
> --
> 2.47.2
>
>
