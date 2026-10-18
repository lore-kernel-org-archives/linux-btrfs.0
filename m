Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8AB3D903C
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 09:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792314610; cv=none; b=Dv46TdvtSaVrjEWopbaPFZC4RyI2BBjy0KEyqAwhqFuoGpXC3z2ZM+502bLaat/Iak4NLpTBBT+lYgQ3raR09D/Om86z70REjqTTztNrWR4rbzyNR/fgEd7NHIO6Gdk2NZzd/cGQ+hTEWe/sL9oAA3DJwx/fLaTg5mzEaNY6g6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792314610; c=relaxed/simple;
	bh=6UbMuFUNSIUDPuLNQyykJaUIEaiO7Ic8jq/hH7EuZfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5Eftu+ggSbze9z2mWaS986iWpnLkgVQCUh1F7HwHF2bwnl97o1asLjxMEsZU4TRTk8KUscA9fmJ8U1M2Mh4qXlBF1g+JY4mQWQsQjzckedNhNgHN0sWByicKNnutgQtItsC7FLA4TEuPFEgNTwsniO9Z1xtG5IWyA78kZnnXtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T+VF7c/F; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T+VF7c/F"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1e34ecb02so1386035e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 02:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792314605; x=1792919405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V+d1or3P8lxg5PV9fJm4UiRmlQR/9pMAaE/U1te/kOs=;
        b=T+VF7c/F0Cto4kfujed6OqF+777nfTJl1E8MHo0ZlTkZZpXYZ0OdYRDl2zYDQXyW0T
         bWT/4VwlqIJn8uaznDnZYZoUzE2EzerIg/KT8oqUiv2xiBO2pYBrJvTSbmfHQUjmcxPp
         xoIQ/2p62ST0XTPTO9A6shifJSkGy7GNkerJnZRt0mr6Qr8Lm0D5tijEej7zkr1KRbZk
         hg7Wgge3GsE5X8cmeRsni+OvHnkgdEG6pWWAiH4vqw/LEr7Y3hom+V0OnAmJJ15Of9eI
         Cj3if5QA7IMhX/PXXKKkZ5JfWKvglAreRDIYIikUeH9coZznnqDPy4wZtFh4xbvPKnsf
         p5KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792314605; x=1792919405;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V+d1or3P8lxg5PV9fJm4UiRmlQR/9pMAaE/U1te/kOs=;
        b=RseqkJKCD1Q2BaaQE+Afou+L95UlFaNQXEvIq203hYh7KZ0I6s2Mkc9VMdSd33tdxE
         IKLj4fCHWTGL89BprsDHHhakSANe30W0mclYv0NvqEOSDObUyFswlv2SW5EH1rFvjxV9
         BJByVDn2N/rFo3hEx2XrCLL2ixKNInx6z048rpN22MYR8UtqZMdY7EQ8sVR31rPk4cad
         UdXwTTpf7fqwm2qtkbAYCES3X0i1NNOkccCDx+BwBL5HGPG7aFwfyxIMI1O9iyd0dkHq
         59V19Dnrmh8/FslzQ3HbmuCO9mgYaB+8Yz7kLAnX4Ufv22ghinAdu2yAPKkxWETiIutJ
         kxjg==
X-Forwarded-Encrypted: i=1; AKwUvBzKzesmXrZseCz7xMe9yWYKABu4lSYeUEUk5M5HVkGpihTaqeI+gfl4GLm0FT+bkUhHVuB6TcwXeqUeEw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLH3XD83ifeOjTbaHsuHMmRFQLjOkjDj2Hf0IrWRIaKuyFl+YKw
	CaHZc6tZBcDVum3zF7IKHY9RzOTYWKCBqES3tQNYXNGu3PjHNQEWvxd2ITNcRjzhHn8=
X-Gm-Gg: AYBFou3CYOTAZso8x8l3QdkkoZB+Eo3bapxVLKOQNeMzlx/2XKnktKivqudyR0dEstD
	wfN5jLZqP6t0U/ft6t9ymCt2TvuImnD53/L7MulD0Fh3UrNQQedPkTcCfrPiYPiLuOnk5rAfkeV
	qH92vlbm/ifdoy533fK5RLLn0jD40G3+rRxMwbuCIi6nkCfthhaXF13SqgAPExek5Hg4ZSfde9f
	OgrBWDM1+xFBKxxC3zR5RM5/+TV9bhElBTDckAv6IALZjxc5USCZcwRgoi28FJHQiscKSUaIBq6
	mtJcj3UEaFYLwUp9olHEUZMIBkJHWboXz5OUNMNplquNMzeGYVWe4i8UidBtPhSYhUidas/lcI3
	Ra6xzbe89labu409cdPZ6p7U1bbRj+tA0TqYjALrfE9cjoi8ZDmW9Pcq7em0P3ljwGv+ce+aqUZ
	W3rBguFyI2pGduA0HUkuZ1RYHSve9m1ML1sDQ8FsaRS/yQTNd5s9G+p1/HmVNyTv8=
X-Received: by 2002:a05:600c:1f8d:b0:49e:823a:9dec with SMTP id 5b1f17b1804b1-4a1d75ac354mr108688365e9.3.1792314605074;
        Sun, 18 Oct 2026 02:10:05 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9474b52fsm18309736a91.9.2026.10.18.02.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 02:10:03 -0700 (PDT)
Message-ID: <2ab739b4-7d28-4914-9e37-a5c99a2f2175@suse.com>
Date: Sun, 18 Oct 2026 19:39:57 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: prevent deleting the wrong subvolume by ID
To: guolingxing <guolingxing@tju.edu.cn>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
In-Reply-To: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/18 18:07, guolingxing 写道:
> When deleting a subvolume by ID, btrfs_ioctl_snap_destroy() first
> resolves the requested ID to a name, then looks up that name again
> under the parent directory lock.
> 
> A concurrent rename can change which subvolume is associated with
> the name between these operations. Since the deletion path does not
> verify the ID of the resolved subvolume, it can delete a different
> subvolume while leaving the requested one intact.
> 
> This was reproduced by repeatedly exchanging the names of two
> subvolumes using renameat2(RENAME_EXCHANGE) while deleting one of
> them by ID. The wrong subvolume was deleted in 9 out of 14 independent
> tests.
> 
> Fix this by checking that the resolved subvolume ID matches the
> requested ID while holding the parent directory lock. Return -ENOENT
> if the IDs differ, preventing deletion of the wrong subvolume.

-ENOENT can be confusing to user space, the subvolumeid is still there.

-EAGAIN may be better?

Another thing is, if we got a incorrect subvolume tree, the better way 
may be retry the path resolution and lock again until we got either 
-ENOENT from path resolution.

But the current code base makes is pretty hard to retry. A refactor may 
be needed if you want to that retry path.

> 
> Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
> ---
>   fs/btrfs/ioctl.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 576cd76ca0bf..39eb7722998d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2380,6 +2380,17 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>   
>   	inode = d_inode(dentry);
>   	dest = BTRFS_I(inode)->root;
> +
> +	/*
> +	 * A concurrent rename may have changed which subvolume the name
> +	 * refers to. Verify that the resolved ID still matches the requested ID.
> +	 */
> +	if (destroy_v2 && (vol_args2->flags & BTRFS_SUBVOL_SPEC_BY_ID) &&
> +	    btrfs_root_id(dest) != vol_args2->subvolid) {
> +		ret = -ENOENT;
> +		goto out_end_removing;
> +	}
> +
>   	if (!capable(CAP_SYS_ADMIN)) {
>   		/*
>   		 * Regular user.  Only allow this with a special mount

