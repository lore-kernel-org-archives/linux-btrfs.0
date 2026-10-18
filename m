Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FA739E9D6
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792358062; cv=none; b=dEsiiOBkXzPyqxE59nAdNrdjQ+AT6Ya+xydyi3Pk/Ly7+9Bucj3v9oChWPXXM4D9Jc9zXBR2vOTougmdESFgSRP3jphDwuTJyhC35es7yu796jur9FOMiHnkgw69EUj/HTD9b7xRDF/lK3P1+nyA2C2c3Jyy4PheGY59QqF3B88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792358062; c=relaxed/simple;
	bh=ELsTm3j7AhO/Y219Lftj+MonZ2lkR1m0RK4B8AueOsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nxv5UoEMffCHCA1wpAHyh7JCw/RRJ19pIxd3bfD0b6t9maVYDeZ3HAuXtgXth2krm6OHYZL/QacrhIBbjnDA/h0DHC2b/aua09gMtYm+yrcsft/zKi7aPwVHPLJmdvURr0wmcYd3XdMfqmeXXgoxnANPfHZFdyhc7OkQtpUVTsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DnvH0YsM; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DnvH0YsM"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e10a70540so298742f8f.1
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 14:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792358058; x=1792962858; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFmT0VCL/Q/dgan6nnGoPiwft7ERrnmKegD898CfuBQ=;
        b=DnvH0YsMiLc9ovWZPMzdj5+v0lNHZKf6BAfSmSpS5YQK38dsO5n5c5E31d0GGCe1Od
         Gpr5LP8fv5zK/MxH1cuTU/042qOf6pJ6M2LkdGaDDv/wiGe8CvCMgf8lOr4d38jn9n7K
         fSf0ExDk1N5nb4hRx/e/6SxtVl92FufH2Dkwddu93gKAQA67obhZ/C/NeiA0Xq89UwWy
         SOyckmDfLrpxix3cAQGfDjbvRXQjGmG+GPksCc8fVKPtad8zBvi5N3wL5m2j9A0fc3wJ
         OBYVbQHO4NfBxEj1iBSCeax+GFY3xFitoFZaiO42OMKS9v9iLSDhbJ2z7tYmcm6U4vqZ
         Tw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792358058; x=1792962858;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XFmT0VCL/Q/dgan6nnGoPiwft7ERrnmKegD898CfuBQ=;
        b=D19L9vythHktqu9pz03NdOLh1PTcudyCGsUec37Z5AL4dsZ3Rmm8KME4yFO6ygQ6dJ
         YYU6ciyp//f+k+JtMMDBW504AhXQB3M7WUDUgRX9BxToffLx6mHbUdw8J9SWtAxyUEA8
         SqRx/D4W5smTXpXjzo62Hr45pIurMd7w9AjF+nONOT58FpZDlwPhpb30ajn56Augawat
         /Yf4rLodjf7Odz/LD4D3Si7qq3+zS70jMMZJRFX/pc4S6Ie+BiTb3I3dabr0njJVP7p3
         zCVAfD1lHtrVgV41xvQY72aqyY6L4btPz5N/vDsdn2RakGKXUhpqeSHH1tj4qJYRbRfP
         ndvw==
X-Forwarded-Encrypted: i=1; AKwUvBzi4zwARW+jLs79wCe1cEcqaff7SGT9cEuPjK3frkHIzG7eQ7cxKAUpiVCspRLKsLp4p9ls1JRM3awHcg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKYvd53jd2wP07vCDUjVRbgTqxBJW7O+RnDI4EFoYCzJmDNPued
	XCa/7IqS//8FGc/5oZjRJveFCG46JOvdCW+I4X6CxT1Xa4eRhSSAfpYzTltsO3eQX2w=
X-Gm-Gg: AYBFou00ogqP6EpUz2WiAXLGNLZglziC9bYUEQ+qrYQdAOHto80C4TWQEYh76sdksk7
	DNqDvuiaLY2cj0h+uGY3Qi62sie2WJVz+Yg8ZI/GidvzjjbcrV71mrbKHunoKEFjwkslp/zveOz
	IjqHRjd00wyRMB8k2GLnwZvW4x2GUqW2TjfNxZRDbwgI6Q8J4UZu8YQzgExfES8jKxkcFTXhOB5
	wcbh/eYUgJGW4op1JQmEno4RRI8pgsnpcwx9wwXx9qd1oCVvdodXSfgpqQ4BeckxX9A7bDDXM8Q
	5WGtnf0pFYcA1MVIFdsX9MQbB0jNGWp08R6IleE0M4MiSPvi0YXvqhcEDCcPCO5tDvZAsMrUVkN
	Vj67IKb9ExJ3lkA1fVIDy2LgIkL9zBY/AL0DyrbQZRb3dOGHU8nQr0XurB8DOSREAj+hm6I2UmR
	a3u9vUfPysQYnTyeAJbNGL7VLQTqjrxlaUzZUQr+tipDAb2v+m17PLe1Fd4XDu28A=
X-Received: by 2002:a05:600c:4503:b0:4a1:985b:83a9 with SMTP id 5b1f17b1804b1-4a1d75acb11mr135826505e9.4.1792358058435;
        Sun, 18 Oct 2026 14:14:18 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8aad3dsm30778145ad.64.2026.10.18.14.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2026 14:14:16 -0700 (PDT)
Message-ID: <e6e38b8b-130b-40d4-b4aa-30e9bdc79618@suse.com>
Date: Mon, 19 Oct 2026 07:44:10 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: prevent deleting the wrong subvolume by ID
To: guolingxing <guolingxing@tju.edu.cn>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Marcos Paulo de Souza
 <mpdesouza@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261018073709.1586733-1-guolingxing@tju.edu.cn>
 <20261018153810.2692021-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
In-Reply-To: <20261018153810.2692021-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/19 02:08, guolingxing 写道:
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
> requested ID while holding the parent directory lock. Return -EAGAIN
> on a mismatch so that userspace can retry the operation instead of
> being told that the requested subvolume does not exist.
> 
> Fixes: 949964c92843 ("btrfs: add new BTRFS_IOC_SNAP_DESTROY_V2 ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes since v1:
> - Return -EAGAIN instead of -ENOENT on a subvolume ID mismatch,
>    as suggested by Qu Wenruo.
> 
> 
> Testing:
> - Unpatched kernel: 9 wrong deletions in 14 independent runs.
> - v2 patched kernel: 0 wrong deletions in 30 independent runs.
> - EAGAIN was observed in 14 runs; all 30 runs successfully deleted
>    the requested subvolume while preserving the other one.
> 
>   fs/btrfs/ioctl.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 576cd76ca0bf..d82a7f3f3d14 100644
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
> +		ret = -EAGAIN;
> +		goto out_end_removing;
> +	}
> +
>   	if (!capable(CAP_SYS_ADMIN)) {
>   		/*
>   		 * Regular user.  Only allow this with a special mount

