Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3973E49C0
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792304690; cv=pass; b=VhSdtc5EWxxgAB6vSPA84b5PTP/PRFq3tS0ih7ZGaUb+MY8sulwDWz3+pwf0iQ8omQ34HfMmKDIVKwmPaW6Kzglg9vvZ3DvpI0tcW+H2YbfFX001J1AEII1VrrjLR1GjrnHibYbkKU7Pryc7h/uZGvn6HQxDcSaBlUF+RRI/Gsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792304690; c=relaxed/simple;
	bh=6tF1s9OWhX7ZZqqfIukFRchOPtFu5uzIgpidqFwFYC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=otEB2oqwPXl7Lyogxy2K5V0JgUd7oARgLnF12XZ5WjzZV0QSURu7VGwcZQE5UbUmU4yzyzP07r33GYahX32Gov0fK41rxs+MxHepA3SOARLZNo6JGwddr7lGI2wCXc87i5dUVZwL1BF5QU1ka5Ppkop5HLN20pwSJCKeNPG2+kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YNEe3KPA; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YNEe3KPA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so8049135e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 23:24:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792304688; cv=none;
        d=google.com; s=arc-20260327;
        b=RoTeWPFuJyE8l3oiXGaJKR9q7FWdllgbGFEINKTdd3Kp5IHXSTLTtxlZHZZABcTRBq
         t4wRV1BnlLIKyscn4wSanIwKz7pmZzOwbsebO4VV5x7abvVUfC0wZVsyxEdbCEMMhwwi
         X8CjidP4VyT735ucmYmjIbsE01qz8DEoyHofJ/YHRHBd+eMWV9xUrkUgC0tNwkoxgk/A
         KB+oxLhApvlTzv6q+/nQdbg2N8L9UNAfPffNmyfU/Y5+ttoqZEkF6T/Y9iOXN3OQC8UD
         kUxE4dTppyXwCX2GRCzM5J8YY2YXB/ZQt6dslVPmPYTqgL3Yr5LZ6Ph4ELeoSNa+LgS2
         yvMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mrFQaebQdm8EYbD6xXysWMWRw4YW2pwm/qWilX9xyoo=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=jL96mQoaFUOiV0fuXmh6nYa+EJa9w0VIYxbqs43bkEo6BHBMzzPXvdQrsHPzwy5SxQ
         6K1pkhLqhQhlrWCaOqEglxrj3I2hZVVKWADMK/shG3olSV3NPkQdE+lmi0V1oZ024DeE
         Tsk6blslSHWM2hwyw4lz4xAb8/nMh7ev/UtVvKwr7gw8thRCWHLcKcYXPlqyq38lVtep
         K7xBu6DTV5KNRanURcz/6WySVqAkt35UqCkT00uUlPCqDYhTCCAouIlUeGsyzibq0iRl
         TN0CaB4WTNk5za2Q7opag1mCeZnK+CA734OdMCgeBq5lfYO4LL9vkSuNpb4MeGNXVyfj
         gJxg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792304688; x=1792909488; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mrFQaebQdm8EYbD6xXysWMWRw4YW2pwm/qWilX9xyoo=;
        b=YNEe3KPAg4VoP3NU/TkZB5/ocLZkfZqaiiyoMP1xH9SS7BZFZRwxZhmo5YRzIBi5It
         O+ujijxLHQVBsTLm2mFHXWFKOTBAkaWMTaJb3DCuLbQtn1TpKUzrxIEd3pik76JhtFkh
         LkryVarHOQcG4iwTotKfevIEnktQDIeGM4F/1vWjUAXvbbme1R/Z6SFb7AAV5YxycKez
         25fExhN3oBAdPdOJqfF2ABI6GGqmeqdwdmJYtQ/SMzzuanDPV5JiuuU1KtomaVzPwYuH
         hmpW4rRNYcg7iiq8GkVclPS+zI5XXx/pw4o+mygXItxVe9KACeTErTrEyhgCecH4eLPN
         ip8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792304688; x=1792909488;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mrFQaebQdm8EYbD6xXysWMWRw4YW2pwm/qWilX9xyoo=;
        b=kXgGnwTbGpuWknmhH1CNaP7+EgHJtBu3hKv22+J3r5zZ/zsDt925/Sx0IutPIMdG0F
         y4oYvrw0GHeTU+8cV6AVb++TI/YmzZ9+8DhbiZKVpF61CO5DYwihY7HO66JREB/xhcPP
         BV0lc/4Zz0Nn8C+DdDRiMcl7Muq/ePhZrdJ/YoyYePpSwKlA3nEoOylnxTXa5GC+RVWo
         XI9NDDlEkqLu4sZ1NIsP7qeM0M9Toly2Sbg6toJR1F7pXJeuyFUk42dOXJe3Kc6wJPE+
         Qf+zAxHanqS8i5sLm4JjgD6SIMoF3Yta4rpWzu1MhT/esd6A92F9BiMp+QZ4hvJWcROY
         rFtQ==
X-Gm-Message-State: AFq9FYJViTsPMAMaD/fA5QANBT48h8bBRPJpxzUZfan+/G2d3xNBuXb0
	isVeBqDet76S8XJNsEOkqUEh628zdKsb0GqhnaUUhyfodocsmtM8X02Zh0w6Yph6/yVQDTvPl4P
	Ggf1Vn6oxs3SHWQmH5gWWeQxiPCXoTd9SGxIbHh4weQ==
X-Gm-Gg: AYBFou3H46fa4hVm6ZTbXQqSTgzdH/T7MbfEnuO//2OEvLwpeTCVplwFD/zPjfoMEpu
	8y/NLZ+XAPB50bovlnGli1Dsf/CMKQWbJ6QZDT5xy4CeuIWRW3bgInrfR0zMT/oLSEiwepLnJ7v
	2jWk9pvVynSgHR3GhFaTe2Gkx0pro1KUfYRbpV+Y+Cv+i/avzHQoHE5oy6WPSvShiwgXjqgRo+K
	ZSXmr7Tb3eKtw4WfDBmi+tgRqHXh3tVi4HCPa0HIxhjTuNBpCw1hI1F4S/S6t1dtEPxSRsDnQyr
	ObXnYysmHCjjUEIf5oTY8vOq+ITpyom1xC76ppNjGIWaAnzkDOK5pGxN2tx0oU7pq79gR4qS9GB
	B4BMBD2ztswEH+E+9z6ISS1vXZtAwJtdoMxD9snyYiNc9wF0qqY3BpA==
X-Received: by 2002:a05:600c:3e85:b0:4a0:25d5:e853 with SMTP id
 5b1f17b1804b1-4a1d7631660mr81908955e9.35.1792304687692; Sat, 17 Oct 2026
 23:24:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792170434.git.fdmanana@suse.com> <9e108b4bf1d4ecb1420521ffaa0603c6f9159ab5.1792170434.git.fdmanana@suse.com>
In-Reply-To: <9e108b4bf1d4ecb1420521ffaa0603c6f9159ab5.1792170434.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Sun, 18 Oct 2026 08:24:37 +0200
X-Gm-Features: AclHuK-GMZa0UpODd3qtZqSBoKM2N0IsMmFUyzhgf-YHNbKN68rm_wCl9hSpczQ
Message-ID: <CAPjX3Fd28sKHSYzVrD7Grmo5GZ9a-fvXUk-vFJUNf5hZZwViJQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs: scrub: fix race between scrub and scrub
 progress ioctl
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 at 20:19, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> The scrub progress ioctl is copying the scrub progress stats without
> acquiring the spinlock that protects it and a concurrent scrub can be
> updating the stats at the same time which can lead to load tearing
> issues. So take the spinlock when copying the progress stats.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

Thanks.

> ---
>  fs/btrfs/scrub.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 389ebb5f7d61..e9ef17d4d43b 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3296,8 +3296,11 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
>         if (dev) {
>                 mutex_lock(&fs_info->scrub_lock);
>                 sctx = dev->scrub_ctx;
> -               if (sctx)
> +               if (sctx) {
> +                       spin_lock(&sctx->stat_lock);
>                         memcpy(progress, &sctx->stat, sizeof(*progress));
> +                       spin_unlock(&sctx->stat_lock);
> +               }
>                 mutex_unlock(&fs_info->scrub_lock);
>         }
>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> --
> 2.53.0
>
>
