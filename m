Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794605833;
	b=g4BA+ymz69oMyDwB7tX/+QH1W4eVHDbNfQ7mR42LUYjM1X59vgG9jEoHhPcT4Qi7Xj+t
	 70c5N5yHTo6X3IIW02OOa/WXdM+lAteWiMzWHeFnHa5ZtFWS56nc6g0fjhJVi9jxUmAnZ
	 PdTyq4buk5uxxXXuy3n88bRFHGK3cWmm/hWNXTP8TDNtNTLPIcX4AT9Pk0UNd9uuW+wnW
	 1oNgnfordUCM1il/4cdRQqQ1vP4tOBiB1vEpysRf/TIdJ9o70p4/4xfUIzOWvCBZy/GiO
	 Yw0xef1Wg//lISOA8uSUx8iybPJGmcmW/qgF8Adjhl+glUM7Fp6ecZUv2Y/gwZ8TTEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794605833;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=yUtJCu54CURRZ9xDSnRFX5gL9DCJ5JkPF3Et087nR/g=;
	b=xnPVHbe2BnqLbZQ1Mey22kP0sg3q1k3ccH58paRfwV5STG3SH1C+yyEcC3mR5AD3aXDR
	 GcWy4ktG427irpntGh2YLqq+kx8PhkQ2eX/dLg5MRU4cy659Tv26fFq81Nvk2uzHIwYeJ
	 K6x+myLSlDHIQojimNmwiL1GCSXVdAE4noW3TB7ht9c0jwEef3IcQ+GTJJlY6bxsPuXwu
	 CeEfCIgnh8URRGgwmuk8Fn7KnxXVQFemiqz4Nr27bAnoRqfsD/2hVpbdatHev6ceE8kVN
	 LRjGgWN2gvgavtKJBnwPQiRel0ffzuLIr+aVj/lnJq5LwnGdxZKE4YI8Tcd/ly//VpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=toCSREax;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C5B606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04C5B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=toCSREax
DKIM2-Signature:  i=1; m=1; t=1794605829;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:Rt4EI7ZyRPkB0zDZ8DGz4KrQ3mPf
   /Z8+RmWPHO+id/sFbNz+6ub1daC14PvunBEw4HY1SCPJZZftaqAsfwMPKQfsX92/d3bhz+Ay7NY
   71z/RKepAS3XoAegr86KnoWWviCZC9fyJLquAt3tQM1uE0LfOzTf2kipLNyj8PwdTwixsP4ZMcT
   voclZRBDjW/EdDBSyfIayisDh3dPcbUsjIzfXlwHXDI8Rd48Mib052SZ1UcXTthzxV7GAwPaBMi
   +31z7Ia6pSxwwqkpQyeijOgUVxTI3emcqzisXgJrVRIoto+KWjwgIBKzfieT/Sg4gGweh2tVvVx
   0i9hfoA53Gy/0g==;
Message-Instance:  m=1;
 h=sha256:
   dratfZJjy9g+8Ti/Pyv97WQYATFxbtdv81KeSiTEjq4=:
   69sU6lnvxDMyDFlOEDlgXZ9+apYct1C4UVH/Gchsw64=,
  sha512:
   /7q+I8McKx0BSZZUwf8RCnOoFejPblmwgXrkEStAWj3buOqLa37rOGBJTHjm4JHCvjPyF0kYAO/1PLS/lktk7A==:
   aZJEGwDRn/N/aLGrtRZ8Q9AIb04e0uWYhT8mX6n0Va/1kFyJGM18+eUxOlw5JlQmC6IvtLajllIoNPNj+AaXhQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794605829; x=1795210629; i=quwenruo.btrfs@gmx.com;
	bh=yUtJCu54CURRZ9xDSnRFX5gL9DCJ5JkPF3Et087nR/g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=toCSREaxgbrlwv/mMQUVwf3tJz4ik21iYdO0yMuey4xeNJGGxT18qxycMpPkRyhp
	 mPCNQb1IsV5w9MExYbVb5OyZhQgt5nfFQLqTN0fFzCu2b1MQhiO7CZw/vBabTo8ei
	 ej7uFh7Sbe4YF9LUIm50vRwuXSGc9sW8xVgHwXec7NfSdHppv3S4lqWsTfFK9Xhsb
	 5qhoRtW0Kvy5xXVbGIFK0t3lDuk67HMXK9WtyEyK0kZJnOZDnvH0NvsN9BQDw2aO/
	 UbCZlhMqH0t/c99vQGBgZ0YThKqELoyivYViy5TGnTWlzl4EONtv7T1NGgE7ZcFbn
	 ZyNI5fpDZDeivaqHrw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MKsnP-1xBHz73wAH-00NfL0; Fri, 13
 Nov 2026 22:37:09 +0100
Message-ID: <bc53b27d-1fef-44b0-b318-1d6ec93a674f@gmx.com>
Date: Sat, 14 Nov 2026 08:07:06 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix blocking allocation for nowait encoded reads
 of inline extents
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <68de579e49460c18b37fb3468b63c9c33a6e8ada.1794591635.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <68de579e49460c18b37fb3468b63c9c33a6e8ada.1794591635.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:h3ft2Y5s4ynvUGF/vMe/LT0V//AhIlM31uoMiCKD+Ycb2p3575l
 KQNJtAjY5sG3pQZTLCTk3zY0M3whDe3K4NDhqQX+OWpbD+NMSYcd5p4qgzb1U/6MwI8uZhk
 goXZjErzGeAA41FcucIx9OHITUTmiuF52CfQksoPuVPEUD4psNICeDhQBWC4qANknl76x/F
 L4bcXz+VngJYec8xh2pvw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5VD0zuf1dbw=;LeCF9wPfoKlDlsfGcHxdEXV0WoL
 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



=E5=9C=A8 2026/11/14 04:10, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If we are doing a nowait encoded read of an inline extent, we are doing
> a GFP_NOFS allocation for the temporary buffer, which can block. We are
> also returning -ENOMEM on failure, which is wrong for a nowait context.
>=20
> Fix this by using GFP_NOWAIT when we are in a nowait context and by
> returning -EAGAIN insteaf of -ENOMEM if the allocation fails.
>=20
> Fixes: 973a432637ed ("btrfs: don't sleep in btrfs_encoded_read() if IOCB=
_NOWAIT is set")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/inode.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 62ff1e568a5c..e68c9871ee1e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9480,9 +9480,9 @@ static ssize_t btrfs_encoded_read_inline(
>   		ptr +=3D iocb->ki_pos - extent_start;
>   	}
>  =20
> -	tmp =3D kmalloc(count, GFP_NOFS);
> +	tmp =3D kmalloc(count, nowait ? GFP_NOWAIT : GFP_NOFS);
>   	if (!tmp)
> -		return -ENOMEM;
> +		return nowait ? -EAGAIN : -ENOMEM;
>  =20
>   	read_extent_buffer(leaf, tmp, ptr, count);
>   	btrfs_release_path(path);

