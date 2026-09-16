Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353274A0EF5;
	Wed, 16 Sep 2026 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595141; cv=none; b=hp2tvsyABZdLF/B2EMJeqoTiqpGJEwdf8yZBROOjnNN7jnRtKPOYbUh1oAQnw+uxjZru/mFjPoC5ch1UuBQ+v9VUMXRzy0/kqf5K4OZEdJ7gZbmmwW4QRioQXTACSbFe8C3CqsCVVvPFZlcz7oTOqCOTWH8Bn/v2a5aRK9/yxZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595141; c=relaxed/simple;
	bh=Fwm8a3dOIdFzadduf/rNdxdguQ7yL7Pb4S3xW/DvxAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0pfEA0Yd50dJaOIhG9SxsrOV6Z9YGCk7Wuc5c160Ab5EAqM9d0OciNzO7RWaMdu673vDA5CWTqMd8aQ5jK2SzAq3FP0+9qnsRp2+X6bH5nrYq+gBzS2qQLD1Y1CbSEMkB+/NcvX1lrXcWaYzE7YUmYZfFnFfDCtmnAoRN+J9aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=lXyKPl8y; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="lXyKPl8y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789595101; x=1790199901; i=quwenruo.btrfs@gmx.com;
	bh=MUuKI+WJEsJW26mjOH87AeCEJApOmnlKyC4DnSK66qU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lXyKPl8ycukx9j0fPZs22ELeXep2gOnr5UmfWvDAmUCTlhMuixlzrqiyAstmmgSj
	 KC5HqYgaiQAUZ0EeFvinMKX4qKy1uwc29ZeS4XB/UayUI24EFs7rrRQpZ63zpg5VN
	 b4r50Fc8Jpc7MUqMpUaQQ54Qv0kLkOsdQnONEnmAmZQUUmYAhcU5M2yxWsLBsYqpZ
	 DzTO8cRLcDKcUfghnh1Qb2F6E95X+t3hfC8+B3vQi0HalI1wdJ+/0XFLN/CHYOTUN
	 bOSb75StYeubPyFnrZx/kA6xiKwWnIVKQTHDd4zhJh02VpxBNmfL5Ku0+fr6RudSz
	 FxbVoSumF81aiRx68w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N6bk4-1wjYV02dEE-015pSF; Wed, 16
 Sep 2026 23:45:01 +0200
Message-ID: <448ab459-a442-48ac-8834-46ca0b7e5e62@gmx.com>
Date: Thu, 17 Sep 2026 07:14:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: Fix local_root reference leak in
 scrub_print_warning_inode()
To: Wentao Liang <vulab@iscas.ac.cn>, clm@fb.com
Cc: dsterba@suse.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, list.btrfs@jan-o-sch.net,
 stable@vger.kernel.org
References: <20260916171610.2086918-1-vulab@iscas.ac.cn>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <20260916171610.2086918-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H+pc+5hGxNhrHGDwRKzEDw6gt/G7LFgrsySqGYODG8Z/YhdvG5W
 wm0NTaWmQmLWOOIy+5RYdUlOzhMXhAmAxoxlXje48/YRMVddKlRtUZf8TBAnlGWnwoOAdP7
 6TZV1Q6HU+3WpARTIyDhLjO0mjgK+Kme5wbBk4eoOpasVpFRCN3vkea5jy9xYP6DfOL1QqV
 I02Drtk7qhlPjpVcs9lyw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:L+T5JCRSHHA=;DjlMOKfyyuKp1FyW9nDXVJPeKhJ
 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



=E5=9C=A8 2026/9/17 02:46, Wentao Liang =E5=86=99=E9=81=93:
> When paths_from_inode() fails, scrub_print_warning_inode() jumps to
> err without dropping the reference taken by btrfs_get_fs_root(),
> leaking a reference to the root every time path resolution fails while
> printing scrub warnings.  Every other error and success path of the
> function drops the reference.
>=20
> Drop the reference on the paths_from_inode() failure path too.
>=20
> Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 1ac609239cbe..570828ec780b 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -549,8 +549,10 @@ static int scrub_print_warning_inode(u64 inum, u64 =
offset, u64 num_bytes,
>   	}
>   	ret =3D paths_from_inode(inum, ipath);
>  =20
> -	if (ret < 0)
> +	if (ret < 0) {
> +		btrfs_put_root(local_root);
>   		goto err;
> +	}
>  =20
>   	/*
>   	 * we deliberately ignore the bit ipath might have been too small to

