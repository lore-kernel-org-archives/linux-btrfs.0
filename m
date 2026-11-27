Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795779355;
	b=G8K5Lk4vIfB4jfn0U9RT1pDI4Z0xkH48upsA0kD8iVbYCHs9uiG6NCQjoxwNb3WmxHsg
	 FV1muJKIG/ADaAqgCQ1INAzhjS5JEHVxXX+W7qLFZ1qvq2RDoCWLk2NutkZQn4fDi1T20
	 000sZ0G653UtKbwCn27StsfistScwvrswLJlON72f5KelO6YLMJc8in2eJhNm6+d695Bh
	 cZXq8Ve68udctMC8hmXBdTvIyM3F0pUMpisWujQUq5kz+qPI3jMyPVr0LBv9qsuGxzRI3
	 a4n3vxAc/CB+QLYSb0JAjjNA7Vt2QwLXp+iifDVAwEjJQ4vh+QuVe5MZ9sbnXqbaBwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795779355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
	b=vJo23aU835g/KrlQFp8X0QBOGs6i1UJopmZq5ALl7U0Mj5wLcuqSwB5m/ExVc4AkPd2x
	 +FVj4GsJ5GGh6yTYAYjAgOMSyozJRusvQzuh0llLQdSgMJHUnwuzmsrFNI8HnEPAo6Ynj
	 xbOr9bn5+0AU7d1rI8OXudwenoUFr3cz8ODC+3DuK35W7ikN2WhaqWvOyRwcib2dszMRu
	 Zqcy52lfq7znjkf80ozpJkp5QCy3AAEdioejFIaCzDvPZdhyrMLYKnyHC6olB4tTsRgTX
	 YwvNiPR0lQD3ZLbcUXCh07WhjQ2hIblUw1keNWrsc8OyP+lK8trM0Yzt38omYtY2lvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vfl6nsas;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A504606A321
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 11:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A504606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vfl6nsas
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b8627e0eb2so10289865a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 03:35:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795779353; cv=none;
        d=google.com; s=arc-20260327;
        b=jSy9cSjXIn1jgS7iPmUD04wpfPMUZE6Q8SmTaL6x4RHZ4qG4i/20iKc6oKm3Z41dRC
         k+HuKJGmOsVa/ER1Zluh/m+H9v7NQb7LuNmMapAqI2qKYhKpPAEBeiGptmgcrFgdjNAI
         RWB/5Gfg4RblPMS5M6BqNzrIKy3SGkvhWwUvxZlAn8eFrA2Q7whVR+E38ro7+jJtPCxj
         2U3TtZnE7W9/DOtuje8jqO/JgP2zK6ltnbhVhlqdZhXeQ0GjhRVGq5dLBKtf6afBKpZt
         8UmippxpMkAU4yucjeBORde6w7x8pZL7HdB1SMPUyc4m0tmNQRuZq332b6+1dENSxDu/
         BMmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        fh=fSiNIQtfl212eEioSRl1RNGnnJMu9jF+mAWeFlFwvOo=;
        b=fjt7P+5fGRxVvmnEIcr6Ep531T2fQIlMIP8posw+PuM30m30J2s0sCRz+TulyuD5n5
         NnMN7DzBpVa4UuH6ucnaOBY1Rdu86NXVCQLaHAo6KmJeR13i3sq7gmoZuzNdfFoRF/1n
         tx82wPeSFhVOM68OtkN/SCB/6PLo2ovb3qwZcDMPftr7G1OQEOVcMlj24B0yIHrZ+Glm
         L6bB8dQiB/1rEOU9Z/cpGtPhh5HWgUObjNElgne1Splz5poX/aVftaQGBjctBNfWmmI0
         QqL89mkl0Vl0+J0D4JfPgyvhwGzkAm/BeOCZDEdvo3/pCzRFUiqXMTWCkXTcks68KBqw
         qDfg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795779353; x=1796384153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        b=vfl6nsasnL9MeKJC3PKlnSrIcRDT85xssIPtgR+brRFXXZVzFiEq6BssOPBNi+U1NX
         rACDgNvbgFoECMBGeOSxlv7f9ZZPlw8jbFZGiBU72Swu1vfaeCoxTTziHNw7UcLrHWJR
         AKKiFDsyO93LUbEmoG+hHJdZEh650ptJD3odyQ/w9fPYc4PvSJ0mm2Sf5PxZt3k35+Xr
         wxob5ZuRAYUg/cXXu2K92l8bOQgHSH8rodtPWHXJuG7bBF/5TfgeoeRbDB0Wy/K1sCCD
         uVtxcxA6CrL6WBmCavRtirj9U2/SaEAzfTB9jrKlSoL4xIH/1z47TjHh6YE/4ycLvzHM
         m/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795779353; x=1796384153;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zckLxKTSVIvkUKQrRBT4ZQPN8xSZzGvjPSGz1nKrgeM=;
        b=C6Lau0AkL7Cbu43dgQSTaidbcIZoA/TktWcJZOvh6CSlrNEkz0zxlaFvzxPFSW3Q0t
         ykh2fZBsGsncc7UZ76WX4Dm7ePgELWdUFeP1Bf8FArs/ATD2s7u8hINvVbQUbw0Xe+Zi
         CaRI5uMVY3PKwfMxXxiDQPzzsnDqzlrB362aQyqQRN4I+j3GrhQjxjwvGwg7b5eZqfP9
         nInNmukOqYZfGJIieZ+NEv21CXKJr3IxUDVwKBoF80l8zLydWaYW7mPrGLgZxUJP7oUr
         VrWcc5m+2fcpu4IiDd9gcUODOL58ve8BW5GSk8nVOizMA+hFFOl3Q3us3nL0fkR0sFjC
         2Gtg==
X-Forwarded-Encrypted: i=1; AL+hErGHLgpVNPp4t1JULnlNYuThws79x2kVEvuGYDg3oGQPY1ecJ3N8NzgI4rjPhB0omVgD7mmA2SwaoV00ww==@vger.kernel.org
X-Gm-Message-State: APuU4Z9h5MeY2SPg83CHEPEucPqHupX3Y5m4lvd6M/hgxehSzO5/VmVe
	6JN7/N57ybhOIkPQcFSDqJp4PKPCELoK0oaI9Akk0Wg31eH6KjgBOHBjBrIBGKptn2wutQZTewi
	DI5qcFGpIcuydYtEc8C524BACYvqJx5s=
X-Gm-Gg: AZFdTZeNw2rZUpaqIi9MN/XK3QyzAz5BFUfjiF2xejugTtMGjru2eyJiPjuslG3ENJO
	XB0neWcInl6CnxN8U/DxiZn5iNl6tbKJthoUoLQv3tVMO5S5bXKdloVJnUxr39LCOvg/bNPBt3b
	n/DYBjBjAOjIt+rz0Gi/Rd0Ch22bNoEhtYFM0v9HKW5CXtByLLw1iDCynxVpXybbp9rtZxigJEF
	HkdTeI8eEfgGxsQg1iBeZmCPBS6uG5j5GsAiinufJ49DTj75RYYQZfTO8ljn0h1BtP40eATOhb/
	gKMWeZwEbGDdhslQ6fTiphK6FwC5BCPy7iZV4V6Ts3Smwz3uhO4WeTm91Esv9e8hV6143AtGAu/
	bBam0+nmxUy/ZIzkQktLMd8uD/KP8Ei/YJDhDF2YLnPQVcjYrJXUpjif1nCH2duOAvBJqnA==
X-Received: by 2002:a05:6402:42cd:b0:6b7:b872:27c0 with SMTP id
 4fb4d7f45d1cf-6ba37ebff16mr18720566a12.44.1795779353347; Fri, 27 Nov 2026
 03:35:53 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126163114.403846-1-koray.fra@gmail.com> <20261126163114.403846-3-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-3-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 27 Nov 2026 12:35:41 +0100
X-Gm-Features: Aa3M54oDVUmD4L041vA_Ja2kzcuIcnu49jvnV20FPfNA1gUDEEUT8nV16GU1jvk
Message-ID: <CAOQ4uxjGLfuZMFABCwMvdXwnU+P24G_aTJLudWbjeSmWwyDF6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] fscrypt: update fscrypt_prepare_setflags() to use xflags
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	Alexander Aring <alex.aring@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Update fscrypt_prepare_setflags() to use FS_XFLAG_* xflags instead of
> legacy FS_*_FL flags.
>
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/crypto/hooks.c       | 10 +++++-----
>  fs/file_attr.c          |  2 +-
>  include/linux/fscrypt.h |  6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index 149498bdab94..52d6a33fc9e9 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -182,10 +182,10 @@ int __fscrypt_prepare_setattr(struct dentry *dentry=
, struct iattr *attr)
>  EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>
>  /**
> - * fscrypt_prepare_setflags() - prepare to change flags with FS_IOC_SETF=
LAGS
> + * fscrypt_prepare_setflags() - prepare to change xflags

prepare to change the file attributes with file_setattr() or one of
the legacy ioctls

>   * @inode: the inode on which flags are being changed
> - * @oldflags: the old flags
> - * @flags: the new flags
> + * @oldxflags: the old xflags
> + * @xflags: the new xflags
>   *
>   * The caller should be holding i_rwsem for write.
>   *
> @@ -193,7 +193,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_prepare_setattr);
>   *        another error occurs.
>   */
>  int fscrypt_prepare_setflags(struct inode *inode,
> -                            unsigned int oldflags, unsigned int flags)
> +                            unsigned int oldxflags, unsigned int xflags)

This here is a backporting landmine -

Changing the semantics drastically without changing the helper name
or signature.

Please rename the helper something like fscrypt_prepare_fileattr_set()
so that backporting mistakes will be caught at build time.

Thanks,
Amir.
