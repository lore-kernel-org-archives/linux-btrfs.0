Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D3935F184
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 06:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792304592; cv=pass; b=H9EY3PZL/liXwbs5YQRgK41dwinKzTMW5+Ox5DWCI2JnP9IyaNCNfp5Z0si/lQwb5v6idi4fEb0pkEkjLbD17lLZdDsQWuMNg1lmZMSSmGaDNvX17xmBDAJJJhMQ7oVx4bUeHEnMXh7j53yOfsLvX1j1hHq/P1VuYBH9BjvqwQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792304592; c=relaxed/simple;
	bh=v68QpwS1nNRpOK8iLfTN92+uGahGd0hzTkpbMj3q970=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oe9hWTqtFjNjPZio30l0OK4RIkXuyl45j+l0ZyMil/paSngA3Vzx2nBhYEj31OTDZ2vBNA200BvH08xqKoYb4D2LqXRAsoqWcUVzyToYhkP8wwqPksIkTeCMwMtZqkObRT5Z3PNZjWO36RBlDKrv6FB66vkeQ7oFjisb+iVaikg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TzAzhE1d; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TzAzhE1d"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48df4f540ebso508102f8f.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2026 23:23:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792304590; cv=none;
        d=google.com; s=arc-20260327;
        b=SpZuvgROdE+wO6bjezuRJmxyV5fpYULtuXzgbRTns/7kZNbFda5BjG6hGEoN3MVg/Y
         S9i1j9qznVOhXeG+s8LT1hSjB1LFhfm5lCkf5k6IJJuBbPVVIEY8YDhw/HaAMAH5KJd0
         2TYE4ttdo/7KxPXjuGQLuVg28zpppom5+cKDAGKDYUhh3OiWG958SzYU6CWqx6tCDtOG
         wN7Frwjekp1UK7XF5OgY1MGewMcAkRASExU8Nq/M+zl9iGtyo4KVFzdahul/7oElpZyS
         qyw/Zw2VEIBNZNtE200Uke9yS2E3RdeLWrp4X6W9qjF2s3rf7ELgUWzxLAoI8mG+XS1N
         MPyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kFW5+0WA2OU7ZRnAm1Nj6hXfupoHVAnFCF6g6DQ5Wfc=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=ftDlabNVjwRazSjjObXtcI1P/h2EPJ7rF/ZYYtz3Hjxse2Imu3PP8cv+t7/7HtkjHQ
         HHq/tycyDeEhnZToHfikmqvhVnYsgiBzf9UdbVeeCkuY90WN2vPQqyNhwXGcuOWKd5Dd
         mT/kXvYRu8Ir/k2G6QD5Wsm/iSTBbvGsawTdhkWv11lThlqIfeBcsUVfu2+QoHeVFWiv
         3/OJOP4IrGiLMcWPHTkR7yR1up3R1kTgjB95MkDNnHXjxafQtgDgStBT21S5QZ12yrQA
         LY0wZvwjQhLak8hkreCs7D72ssuQ7/h7Q22sdpxX+6qf8crXz/bX3Ry/9hjA4bLwhllT
         U6/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792304590; x=1792909390; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kFW5+0WA2OU7ZRnAm1Nj6hXfupoHVAnFCF6g6DQ5Wfc=;
        b=TzAzhE1dkfzfqM0DXnhUnjKZmvl5o5/ZV/N6IDXLy/ueftogW7LSv9aMw8Y61Hh8hz
         QnYeAz7s6gBbaEGT44F6GuDHPgIwulps0RbN+bsjDA7bsTEuMCD3GknW7soo4fG0AZix
         IDAfDvkml5c5MQ2DEdHdyr6qoyf4e6SzJhTlMRCfVXHN776EWF5YbGEp0mwsl9R0dZ0k
         /pXNrZx6jt92Qy0KjWI2CYUyU8NmR1R+ez/VdUYRF9sOfqlLPP6pvXqDyWqpI7rzhH+D
         B08tMTXGtYlOTvKRQUxAzT6QOVJfbUtqJRmjNjQHKbZd1O5QeQTlVysIkoHZ+hTZu40O
         BBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792304590; x=1792909390;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kFW5+0WA2OU7ZRnAm1Nj6hXfupoHVAnFCF6g6DQ5Wfc=;
        b=xD0HsSyCO/hAUyycex1S7WjhCI1QuDhs2zlMXV/XdSX7MHHlk8gwf5AgDgf1Ut6vck
         UfBuqULS9kuL2XLqCq4jmYrNNVDN3VtwXINdMQ80YtevEN1uckGep5P8+ubrpDNy6xPi
         uKSRhYiPDv2LyCvLn4+M0VbjWjF7Wdnb65OR2flY/GcWrAiSr12sXGVNMEMqkqe9CTHx
         M6x4yrzX82+XG1o1nKZsDp/O9vfioqZTYIHHxeu9WpBJKfhOEJGLOyuid/PD1D9PY/6e
         zDlcxGqLSLEY54zc0hPmxi6wGdMI+Pp4UV6jBB0xbzsN+hTlYHnBKcqlG2pBNgPi2opo
         gu+A==
X-Gm-Message-State: AFq9FYKHrz27BmG27XjaKPYyJIPRKsbt0Ofw3QHgy2RiBPkeWvNZ6WzE
	aP/5CI/ldGX1Ag4KUi+HyPXIwXumD7/pj92X22DAcI6sYos7tziZRz2oIJZyySXCfCET5pFa9vc
	oaujlIum1mnMaXWkqVregl7w1XagC7nGzJLIv1gVoBiPbtF2o0+9qr/A=
X-Gm-Gg: AYBFou2RX+LRpRIDn6URlkZz2fBoPawKCcGC/2GBEGY2MgTtdB0IMm3+tmxzmGbVPtC
	1/y1aO6m4/5te5/43RUXh7ZkfpgP5XsMVdrKFerva2bfUPaL+T4Xz3BbDSkDwdRdtTxvN2vtkXD
	86YuxYIy43ZJ0+q0NSCfoZvvoffBMFpux/WNNGIHtXRQ2mPlpH6rfZ7mQpJt1wRUrvl2V9VEYOb
	QwDP3wVnZJ7LHwrXtlmHsVZZQViGVdv02qaSXvTHz8jHGq7OpaOPllST8TCI+isG1T9bnA+oQPq
	nEqYgqFhZAXj9EszcS7EZzpqTZEvZCC0rMyWgi+0B1wLnsLwgC/qpAPBQSD0FhOQeh4XFGobEK7
	c7G8MNKE5C2nxQgCDRyUxwE50N+Rfo4KA/9H+USBi35MYo4h6SAcz2LALUPwHSSw=
X-Received: by 2002:a5d:64ed:0:b0:48d:f957:bca4 with SMTP id
 ffacd0b85a97d-48e07fdb461mr8393478f8f.44.1792304589730; Sat, 17 Oct 2026
 23:23:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792170434.git.fdmanana@suse.com> <1c760438fbab8c2d2bfe31a9c9dfd3d7c6637949.1792170434.git.fdmanana@suse.com>
In-Reply-To: <1c760438fbab8c2d2bfe31a9c9dfd3d7c6637949.1792170434.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Sun, 18 Oct 2026 08:22:59 +0200
X-Gm-Features: AclHuK984uJtaM3sdrZvJ07B4vwQMzUskOZJJ8yNE0nNz5PhyCuijmNim2-1umU
Message-ID: <CAPjX3FcnYqtVLEFCmsdi8A9t_jxBrzwx-g90LonRU8njiLDTrg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] btrfs: scrub: fix race leading to use-after-free
 in the scrub progress ioctl
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 at 19:16, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> If the scrub progress ioctl is called when replace is about to finish, we
> have a race that can result in a use-after-free of the scrub context:
>
> 1) A scrub is finishing and is at btrfs_scrub_dev();
>
> 2) A concurrent task called the scrub progress ioctl and is in
>    btrfs_scrub_progress(), where it takes the device_list_mutex and grabs
>    the device. Then it starts using the device's scrub context (for a
>    memcpy operation);
>
> 3) While the scrub progress ioctl task is running, the scrub task sets
>    the device's scrub_ctx to NULL (acquiring fs_info->scrub_lock) and
>    then calls scrub_put_ctx() against the scrub context, dropping the
>    last reference and freeing the memory - while the scrub progress ioctl
>    task is still using it, resulting in a use-after-free.
>
> Fix this by changing btrfs_scrub_progress() to take fs_info->scrub_lock
> before using the scrub context.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

Thanks.

> ---
>  fs/btrfs/scrub.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 0eb30625439b..389ebb5f7d61 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3293,10 +3293,13 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
>
>         mutex_lock(&fs_info->fs_devices->device_list_mutex);
>         dev = btrfs_find_device(fs_info->fs_devices, &args);
> -       if (dev)
> +       if (dev) {
> +               mutex_lock(&fs_info->scrub_lock);
>                 sctx = dev->scrub_ctx;
> -       if (sctx)
> -               memcpy(progress, &sctx->stat, sizeof(*progress));
> +               if (sctx)
> +                       memcpy(progress, &sctx->stat, sizeof(*progress));
> +               mutex_unlock(&fs_info->scrub_lock);
> +       }
>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>
>         return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;
> --
> 2.53.0
>
>
