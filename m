Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C744908C3
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792060475; cv=none; b=KeexiegBvprGgio+XVV6v2sYBGWWy5+WQ424gCeUAIAgoTWGtbnpxIRFMSR8C9/WQ+C90DUe1AKW8ogcRe6TM8RDcc511v43aNPmqK5Xpzp2twt7UxiVSxqy3wilZZkIF+jwJ2iTnUmYSjA+60V73R382kbbc9EzeZWAtd1teh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792060475; c=relaxed/simple;
	bh=uuA282mbAAsxubVd//hesrkFUMk7A9wWWPpltUN9p9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JduTP0iL4aQvVTo7uxbAXcql/+GIopHN9g2FZjItR5AFSG4k++W8y90p7jLiMHrHj9wQiigjIInKSD3KDJa1Hyxb6Cxe8dMb10e2ftu79ElGgdBbyQUA//kf4xuMFfEntJsfUl9gcivSJU2OEMfw58ivO8ADKG3HRcL48i2nR9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Dtondgv6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Dtondgv6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a16c399641so49487465e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 03:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792060472; x=1792665272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P3osTZ0BdPAIjeNNLvrEv8uJJ4FA/b0wHvWNDV0Nx5A=;
        b=Dtondgv6iliSEPp36uw9udtSxFxYcHH9YqxR9wat8hX8GLoLCXkehpv6LV/bZAkqAR
         P9Bq5ivpRTQmnu2wztU6CuoUTihAe3qhczzzbFrEHy/T7SHeK/6gRnS7Ho1jB9BqC3mf
         w0pb8gW76Yee+FUYbktpXb3dZQeIImHGHaW34h47vl5/wYlqgKZiyzZcJ1T8j1bEv7fD
         PNr4iUPRQpdWXBKGLaEsZO26InzD1WQSU90SIGMT3VndiCLnQQ4WRKUx3S63VRs6f0eH
         vC8e4Tj1URg3nsBr3TmkKkkDjoc1PfdctZ2Juu7/3wYA92NLITPhBsVoOJKhVhIlJh5Q
         nCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792060472; x=1792665272;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P3osTZ0BdPAIjeNNLvrEv8uJJ4FA/b0wHvWNDV0Nx5A=;
        b=ywFO6A/MgOb21i3wTBHGKaep2H7huYxC74yNAbNHligvJGmrNckbQqGGqk918lDt5m
         Hkejy9TbD7KpW3CD7D7EPWtW/Kcl4gzqxZCRlBmxnn6IRBrGPImJ7GJRKVMNXLHdNqyK
         VzYlMxX4XX4UcDi3WDCdJ4uF5Y0UNbQDFzVqyHpqhxpkpGZxjaj1HiEjrcmzF+aOOt4E
         1XYhXaKX95xCsrHuDY0Bh3KjjxJNTiI2GEqoebEG9b4hcPgi7J5/RpZZueToB4yD0pgk
         ACfXJMuv1/vTOaaUqkU3TPgoTO8bMSidpEhXmjFMkRjbasFUJjxM+/H42YqFyMKHEsiT
         BJ5g==
X-Gm-Message-State: AFq9FYJmvZJ3Zof5BvPYQ4KYboT9Sv4GSp+FXkEVDW7+0V0RoYGELMfV
	isJe+XJmzc9uZDBNImC5TbqDiuSE2axEP4jW4+1E77aTV3OuJI8OWQhuhP/QQt2Ob9w=
X-Gm-Gg: AYBFou1UI4PtyBJt1DDQWcDLTaZtBP5Ym8KXoo4rxzk99hC/k4vYFyE/fNOxXXvY6af
	eZyx6MHny+lF/Q+2/o4HHSZfZnfTR3dloXz/wYZ8PdRT3kiomUV0WoQOOulBRWOcabyY2DOmJCx
	HlEyoi0jS71ECAxdv/uA/ZoZH4CvY3F8kt/ok2WjegzKAyjD1bOuJ2EGWNwx1Xekf3Y+/IVz0YO
	O20WaWRfG2qMXaOiDjNPXI4T+CHPWqTXWA9QZmZoxKgatL4sqfwtAjO7SJ/Sm8bhCte/atRUE2R
	l/Bb65YMB7bzPFMO108Msuev6Hrn13J2t23iTclRr/uVEbDSOWjg7Lvq6P1lxigYSt/Hkp383EF
	qJPulu5d5b7z+rm05nhONFSpCOiCUmDoScmhjOvw6Q0OYA9ZKeSyUAZW8ydETSZb0Pi6rbYICHr
	CDUbW7naB2A6xquzCQUcahNprIGnTu9oJPc5qtDIrQFkLQYEIPSA91saipwqaF75IsDxF3z3ET
X-Received: by 2002:a05:600c:608d:b0:49c:cee0:e7c1 with SMTP id 5b1f17b1804b1-4a18e48d45cmr404356995e9.16.1792060472529;
        Thu, 15 Oct 2026 03:34:32 -0700 (PDT)
Received: from [10.86.129.46] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944af2f1sm3803007a91.15.2026.10.15.03.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 03:34:31 -0700 (PDT)
Message-ID: <0928487d-bde6-45e3-868d-8bdf9d22b6c8@suse.com>
Date: Thu, 15 Oct 2026 21:04:26 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: verity: propagate orphan insertion errors when
 enabling verity
To: guolingxing <guolingxing@tju.edu.cn>, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e3321d2d-d8dc-43e5-8501-31b2d5ae1146@suse.com>
 <20261015095901.4140409-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20261015095901.4140409-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/15 20:29, guolingxing 写道:
> btrfs_begin_enable_verity() ignores the return value of
> btrfs_orphan_add() and unconditionally returns 0. If orphan insertion
> fails, btrfs_orphan_add() aborts the transaction, but the generic
> fs-verity code still proceeds with Merkle tree construction because
> the begin_enable_verity callback reported success.
> 
> Return the error so that fs-verity stops immediately instead of
> continuing after the initialization failure.
> 
> The transaction is already aborted by btrfs_orphan_add() and the
> handle is released by btrfs_end_transaction(), so no additional
> cleanup is needed.
> 
> Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Will push to for-next branch soon.

> ---
> Hi Qu, you are right. The claim about leaving the on-disk state
> inconsistent was incorrect.
> 
> btrfs_orphan_add() aborts the transaction on failure, so I do not
> have evidence that ignoring its return value can cause on-disk
> inconsistency. The real issue is that btrfs_begin_enable_verity()
> reports success despite the initialization failure, letting the
> generic fs-verity code proceed with Merkle tree construction only to
> encounter an error later, instead of returning the original error
> immediately. This revision removes the on-disk inconsistency claim and
> describes the error propagation issue instead.
> 
> Thanks for pointing this out.
> 
> Changes in v2:
> - Remove the incorrect claim about on-disk inconsistency.
> - Clarify that the fix propagates the initialization error immediately.
> 
>   fs/btrfs/verity.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 600337a84fbe..d92c9dab0293 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -615,7 +615,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
>   		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
>   	btrfs_end_transaction(trans);
>   
> -	return 0;
> +	return ret;
>   }
>   
>   /*

