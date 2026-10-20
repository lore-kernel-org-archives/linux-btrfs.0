Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792500469;
	b=aXLzBb2Ysz0iMiwoxB4UCvjAU2E2wpytyJsy5FGxPEh7FfEfvnumIqqn+2VSdqcK3hyo
	 T79KVk1/19mWqoJEDdHldvSua3391DqHJrCgGd7ICXjCfdu1zMo4OIJgDJ1CafzoYy+pJ
	 +cXzBYREqMoQFKwvl557/QSRb+XYTqFlyO8GYgMnZjKYcLiRXSPabF2PCkCkKDTM/LL+p
	 fwRedbxz1Uh26t2tLkqId51JLkkVEM06sUEgmp8wfDd1wRqLvvElweZq2oma+P7HHNV3r
	 3O3okXq/v+Cg9kx2d6tIBcXGPp8099hMWzGqumcf/WeKeYnat7dTXyZFp3RotQeZ7HA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=iCuxQpyuiE1BvZonBc/G16oJBnyOGaUhrEZX/PRVuCE=;
	b=oOzivTjdzvbbuK+0yzitlxJi8PUwDnsKPUWtBCySRYjQqBr9hTjQAbELET62VTsBmJDx
	 /clPPeNTKymB1lKGSIK8P1GeWtEHlItg1j1Ive8NRgyOgosLkdn5P6Z/G4EfWcCIHtFgV
	 CkI4WUUSC2334CXalfaCeVN7YMzXH9Ki3kbVXUvO5l6pj21HR8gBfeQBWIO8J964btqgv
	 0v8kJ8s/lYLs/CohxdaVDq8oRGKJm7Uy9Shsm+miDjCLJACFCmH2FkcVq0zeBno6iFh+3
	 3YJmQj+yqrxAWfucm0D5uWDOymojg4EfkUkCz7JOH5jXYSp25V3v7nUCq1eJINUpFkg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JNZuUFoO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC26606A31D
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 12:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAC26606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JNZuUFoO
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e00eee27dso1870521f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 05:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792500467; cv=none;
        d=google.com; s=arc-20260327;
        b=LuymZITB8z0gBQTnsMHYFulG7ds9yyb0he8tDEFeIFwUW6TemZoDBiXCHGx2r7upCX
         uvg6fbRKmg37D+CbNOaHCcSFg1cZm9B8/AZk34/DyapD9XinisSBfogEGSeXEM67u9ir
         KA1qOfZhLnbyYyBXsX5lnjQTuM9P55AwuPG3s5svwDh4p0JohPht3O3eG7qYl+RMVLWJ
         S67qWd64S6KuehXgpHa1vRkmiBVUP0CjzgAaNM4QMe8w3CnlCp9Pou1xFv72/TZ82vcL
         pA+Yuqip7fhN3cAbeiyMyZyjGzTpthRNlCmO2eKdG0u8hvD5LckryMPT0HnxLF0WwYmG
         pxVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iCuxQpyuiE1BvZonBc/G16oJBnyOGaUhrEZX/PRVuCE=;
        fh=DNhRoUogv4njemsTPAOB4Tb4wfg3Mu7IYlLDA9H4+4Y=;
        b=MqsqpVErPviBdIdogApti9IGO95ZsP2cnxfzcpLAyGAFj9nscMDBZCCQd9pHRImsGa
         jkWRjLlZTrpylwUfpeMEBGphkPVpTcn3xdG6dL+SSPtn/V2YGs6Y709hitmZEGn1OOiW
         +RQjZc0ChZ7sMrYbuqJAukR/6biHafGFHuGpHUr1/7AMVJhNpOOWP2qwIMKAZ0siV5O6
         O6noYEv8rNcPQMgrsXokNgiprCNnYOjRySNFC5scJjKHuAbDQF70GMViLyH5QcwYH58Z
         uW1Xn4/YgOmgrlrsl0KptUKD65N4/4lhxAkUNkxcxKnZ9XFK1JCQ5H+O/I432hbRzgLG
         jeMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792500467; x=1793105267; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iCuxQpyuiE1BvZonBc/G16oJBnyOGaUhrEZX/PRVuCE=;
        b=JNZuUFoOSyi/1KwfNjwV80d+bhbRI5mf2A/uBATMyP6PYSw206qUxU1jTzhTQw5s2d
         QhhdRcOfa+/lw7UymQeNP3pjWkaLBrolw4SvX590Of/O+TcCKWo8uA3yuh48blA07zec
         lsM55taMNr3KTQ8R8yMZVu3pNARTv0mQA8/1MXNgev5ZBLsVav9pv/vkZyoz0s2RyX+w
         G79/YDTd4ZLVlvEN9rX8uP/Op9JuflNJmnLVnY5qbNutelBpFv7ZFQR8TbyUxayi8rI/
         PQsAc9je0vqTqi5d61FJx1NArlAy5qBIDJKai3/W248Tfg2IVpwlNfcwetxnbXlzc+TC
         tLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792500467; x=1793105267;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iCuxQpyuiE1BvZonBc/G16oJBnyOGaUhrEZX/PRVuCE=;
        b=SQDYZ5cZc90+Ttk09egct030WBjoI6Lq/iHILHrUkgu5c6xHjW4Tbjc3JjAcxzkjfg
         R7NdWH/IVCbmM31yUobVW0J1v3h5KOioSbuh9QpbT2zi9dBhD2yQigEAvXGa92YnPge1
         kWEymsBjP7VI0up+rsF52DIsNeF/HS/DbueT+CK5kvZJAeo6fN/H8qt8bjTP0pXI7vvj
         1cEibcO2jx+OKBylQKmdd4LGQwfeIVz9PYrcwynT2xnQvFZ9ubE5sMQpRoNy2V2zEksm
         kMQqxyFhJLDEtpQVFqYuOo7K1NsMVPPPWgHuY9HDl+R5ch+1OvhUzDo+bEkgLVl31eh2
         U3yw==
X-Gm-Message-State: AFq9FYLGQi8Z+rpgXw06/h9MDjwrYZXTDyPdo0Ezt+m6/M2R2Jex0ofn
	gdk0cH0B+Dp16B42STcsDu49WIdjVGQWl/xYtQewhvgDLVPawfX2pvVvuiH7iEgCRu2fHrx62bz
	4FurJ6rjKPcXbgtPRnCENegvu2Rq89Gn/QOD2KbH3kw==
X-Gm-Gg: AYBFou07VbzvlRdwqM7RgauajYW8Z97o6PAPwPQbU0rZ4f18qQMU3LQZG0P4wi+Ozhi
	yuX9HY0M1fMekqRw6HjUToLfAToDBYWTpk0BY+pjqqazexkyhOfBJtB42qDK+Glkzvmy/6KiINs
	fQTBz0vYwrTjM4TV7QH6c/44xohl8mkygRfsaMsKdwZJkFvYQa2k+CTeP1iZLVVFeThTkB2GAgj
	7Co8KbLj3fHOFVbjsd2tCqwsnhECZ+ERy29Ma6Nj9O2/vBl8Jb1F4B+VmvFGwY/f5zl+rDknrSp
	v8rVgx6JFTMUB8KxGuvz6pHLH9o2X2x2hiNpFqH4BAVDatVr6cn84233DraWiRPq8F9nTUxza3D
	0i0buoj+64GCozJhPUiQ9vWEHu2zKCgogduJEKotJvBRydru25D8v
X-Received: by 2002:a5d:4909:0:b0:48b:11e1:8bc8 with SMTP id
 ffacd0b85a97d-48e07fada97mr16711711f8f.39.1792500467232; Tue, 20 Oct 2026
 05:47:47 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com> <20261002073715.2191177-5-johannes.thumshirn@wdc.com>
In-Reply-To: <20261002073715.2191177-5-johannes.thumshirn@wdc.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 20 Oct 2026 14:47:35 +0200
X-Gm-Features: AclHuK9ujUytAZtP1VNQjevvDVTEC3FXF9hJmFYI4L7fevV3da8tFP4kX4i0y8M
Message-ID: <CAPjX3FeuysXEhHRECegEjXHuuC=k=hrGBV4ORymSS3FD4q_Cxw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] btrfs: zoned: avoid underflow of bytes_zone_unusable
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Oct 2026 at 09:45, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
> The two functions btrfs_free_reserved_bytes() and
> btrfs_reset_unused_block_groups() both manipulate
> space_info->bytes_zone_unusable without using the accessor function
> btrfs_space_info_update_bytes_zone_unusable() potentially risking an
> underflow (in case of btrfs_reset_unused_block_groups()).
>
> Use btrfs_space_info_update_bytes_zone_unusable() in both function, in
> the case of btrfs_free_reserved_bytes() it is mostly for documenting
> purposes.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/block-group.c | 2 +-
>  fs/btrfs/zoned.c       | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index c148b9d6e597..74a61db93250 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -4114,7 +4114,7 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
>         if (bg_ro)
>                 space_info->bytes_readonly += num_bytes;
>         else if (btrfs_is_zoned(cache->fs_info))
> -               space_info->bytes_zone_unusable += num_bytes;
> +               btrfs_space_info_update_bytes_zone_unusable(space_info, num_bytes);
>
>         space_info->bytes_reserved -= num_bytes;
>         space_info->max_extent_size = 0;
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 96d3957db87f..89286a92a13f 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3241,7 +3241,7 @@ int btrfs_reset_unused_block_groups(struct btrfs_space_info *space_info, u64 num
>                 ASSERT(reclaimed == bg->zone_capacity,
>                        "reclaimed=%llu bg->zone_capacity=%llu", reclaimed, bg->zone_capacity);
>                 bg->free_space_ctl->free_space += reclaimed;
> -               space_info->bytes_zone_unusable -= reclaimed;
> +               btrfs_space_info_update_bytes_zone_unusable(space_info, -reclaimed);
>                 spin_unlock(&bg->lock);
>                 btrfs_return_free_space(space_info, reclaimed);
>                 spin_unlock(&space_info->lock);
> --
> 2.55.0
>
>
