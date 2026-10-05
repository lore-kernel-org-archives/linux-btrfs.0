Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4494BD11E
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212635; cv=pass; b=BLyRV9BbZEVDnchugA6Fak8q9YN9/8c3s4sBgJw5njJ6bVwiKAAfaQzGWDVHNl3oIeMZngGBIKo5Yv2zOpKM+xOYHxgLQsREWgxQ0RFeRiQPM77FdW3uVnEtcFyFUUN/WpxSuzvNEDaxjXuXVUd91GOMLujTmE6VfMp6SKPYhXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212635; c=relaxed/simple;
	bh=yD8XQbbTyLm97cGlb8syX/uEVsQ4jH73YIwLTqUPi94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AeAcZ24+nLMn6SCz/ojjrjNiuezGVOe05B1nHlkK1lYNRAKEX61fXKP4yQj/6Zfc3B3tkqYbAxhUDT5JCLmrl/YXUEkvOH1eC1oIvlpkftzD/zq1AiHqtfuEmmurPBnV2TCSQS3yS9fAGOTdF3Ju7BHNAIeEMnEd7jsSM/vRh6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=az50O2RZ; arc=pass smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="az50O2RZ"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b01c4f4daso1518983f8f.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 08:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791212632; cv=none;
        d=google.com; s=arc-20260327;
        b=hnsJWpVgIzPTzUMidTCaCL50/U+E39ReyLsnj8Bc8/uEz2YUQI8B5tD5XHrc/VNq7R
         UMiOUe4F9dqnrWZptxWMxH6WmVuNIV7Y5ISGyu9yaXtfAubS6cGr8XQp3m0xXrNjTJCp
         CVxDMXzhYuQ2jp7is45J+Y4lXzqt1F5TSVIMbn7h6IzuC6dARHOXb2rp2zM/XpMui769
         YRiFy5Vtv84ev7oVebCcMeZ/cwHZ5+SXpSy0jGl9Y/GNVDBsdybOgZHkk8ek7cE+cepq
         HqXwZqAK9MdCF68ojzNRGczYB8Z4tHusu3958qGrW01uHSULbag2ITlaLIG9HBxC99jO
         D07A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Y4mcSPKMZKNcM3gx2xMdSCseJ8ZaFqzZAMH//ExjYCc=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=GbaeAp0BYkV0XOjgwod5d+w4gmXQCS7cwSHbDntPshK7s1+CdU1Eeu5ES0gwtqpHO/
         +zXa5NeLebB+zMS0++jHP+0taRHc7VNIoYrmhg8WBKtRlXJjGuoXdq6EOZ1csH5BI2hn
         NRTqyewtSbGmhc/wInBL+VJVlzccoago6De6Ju66X4x+EBLblrmqZ6iZ9EvIZayFi3xr
         zY52mqt9K/rb281v81m+zOcykH2/Of20ERvi0KmL77+cjFPRU8323GzrcpSq47irhVsy
         ksufyuY+3Jtjh+z8ukbzyg6l4JceqEvDB6GnuOU0b108E59rQGg/GmYe2+Ud2Oa6zfYX
         sAtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791212632; x=1791817432; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4mcSPKMZKNcM3gx2xMdSCseJ8ZaFqzZAMH//ExjYCc=;
        b=az50O2RZcvVm3bTvI2193UKzmzfCUFTtben+DR2YPEYKEoypoPniyFWWXvSRZKpvM+
         M8Kavxt8igYC+4zlUuWlc9dv1rMKiaM9pVOo87OOgQWi/W02GlJsU3EbdFNCyMRrH+un
         pDKsIjyaHNvFf8TSszwLxB/XeEC2cEEgqQXzy9HmDeuApL71D+E4m7zDjsX1l5RuJdQ8
         LGtZSpdYsuLA+CVvAkxtjnfAEQ4L/LTk3bfVzTExs7img6YG4pKnU12n5jBfPiaoAh+r
         qMnIge6y8oa+yVu375BVBdIGQO1RY7rQibL6T/BUuRO90UGKXy7SrQV/hyx0QQNoERP6
         GhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212632; x=1791817432;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Y4mcSPKMZKNcM3gx2xMdSCseJ8ZaFqzZAMH//ExjYCc=;
        b=Ml6nDa55rAAXwK2QEDnLtzfYdyCecfqJiDq7v9n0lLGWcxsodeO0k91WGaD4WbQ+xQ
         YWf2ONKgQe7L4noa5DakqgjN+HAePyMhskQHTD2N3xnRNv0M+q8FOmNgYwGyUeONV3Nj
         gKC2nl602362rr0PFY+8eg8EOf0Au0E1rfPrn/2ako5vaib363483XGK70gMX3D7jHEQ
         nNZF78RvZLKFtfAxyDSltSJs37qt5UYfdxy74Y660jOda8bOKoddoLidOTTrgK38larw
         jMSRxYIPnJiEUGGivAHoo6LLC5RmHi6hLtx3wpZWfG3lwscNxlww+y/Q+1n43DbuZmS4
         FAYA==
X-Gm-Message-State: AFq9FYINZHUXXizZDka4mdtpOjUwm9rKJCcM0izKrY0iwgT72Ae5HfPi
	f0s5lQFJtVvo5S692Eiw2ta6clgNMS5z5HaTXABaBih2kd0hEu+o34F/tdRoDdXuyu4fLiPDVLX
	5yiT1ckFsreHhPbVLKrXS8Sn07gSXZ/C09xfhL34U3w==
X-Gm-Gg: AYBFou1p4nVVcXYgdyDYk5BMCcjZ61IOBUnqBQav+8QJ36ekRifMAGNVOuOhYTZ43IY
	Mi6Hg4Uur+WTZW48iVDMasVhI2kCUXenbGPE7IqMuI4am0TcUE9gkLvJm9wb6UQeEEHdaIXbXWF
	NHJ8vWeZUkjqFIgrLUk3XHTgB2yfvImtRogaon3GhJjECkmsVRbgmNaikfLUCzh3gNXqH2hwpDV
	AFuqxjquen33infD/l8tbZ2WD880UeBzH6Ld6QjbhFZCs1VOdq51Z120P56+v6nyCkkO5r9MJpe
	dPjheKnLsPd0jHsj/9lKGA4SX/yjoJlWVOyr2qVe7zYIoiy+Aph9+4ofw2bZed34rveEcWu/Dxp
	AU4h/qBAutC9YAcc1zjqn+Ku+moGWxi/Xi39e94SNUJil1lanYv6y
X-Received: by 2002:a05:6000:2dc6:b0:488:8ad2:e169 with SMTP id
 ffacd0b85a97d-48b1274ae04mr22553617f8f.56.1791212632111; Mon, 05 Oct 2026
 08:03:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7345c87bc7ec38c7d71aff8ae0542ad177b3dce2.1791203029.git.fdmanana@suse.com>
In-Reply-To: <7345c87bc7ec38c7d71aff8ae0542ad177b3dce2.1791203029.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 5 Oct 2026 17:03:40 +0200
X-Gm-Features: AclHuK_IWvso9VyUOUk6tgs10R9cDhIM2I30PLUtGMRKzrg9cgYVpdMWCztJLW8
Message-ID: <CAPjX3Fdp4niu6BNUAJCcvmNfyOZaDiZRrro7-wEmhE7jvuZsnQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: use READ_ONCE() to read the chunk size from the
 data space_info
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 5 Oct 2026 at 14:26, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> The chunk size of a space_info is always updated with WRITE_ONCE() (see
> btrfs_update_space_info_chunk_size()), so when reading it in
> calc_effective_data_chunk_size() we should use READ_ONCE() to prevent
> load tearing. We are already using READ_ONCE() in every other function
> that accesses the chunk size of a space_info.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Daniel Vacek <neelx@suse.com>

--nX

> ---
>  fs/btrfs/space-info.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 39a28e1bec8a..72fa01502461 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -443,8 +443,8 @@ static u64 calc_effective_data_chunk_size(const struct btrfs_fs_info *fs_info)
>          */
>         data_sinfo = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA);
>         if (btrfs_is_zoned(fs_info))
> -               return data_sinfo->chunk_size;
> -       data_chunk_size = min(data_sinfo->chunk_size,
> +               return READ_ONCE(data_sinfo->chunk_size);
> +       data_chunk_size = min(READ_ONCE(data_sinfo->chunk_size),
>                               mult_perc(fs_info->fs_devices->total_rw_bytes, 10));
>         return min_t(u64, data_chunk_size, SZ_1G);
>  }
> --
> 2.47.2
>
>
