Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2B726ACC
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 00:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778469; cv=none; b=BGZ35DdSN4f13E0+Edcihs4VItfWKKk+k4m4BTmWzxQXmnA0ugb8hQTq4/2cLd0tpKXfWMinHVY9Z/l8u1i7AJ2/98/PP/f4oLOt29/el5yVAuzMi+R/fTz/hoD8JSlvEz+c5co53vrPJ/nVOjlXYPJebwPGTfT8uRUOEhg4wBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778469; c=relaxed/simple;
	bh=c1LuQmVBUIrfP67CXdbY6adffxpdpkDoj3LTZ3ftUh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hP6l9W6JadLFVxbE9pwxnLAdXpv6Oh9xGvjvNAGvccFAzhW5L+A0XR111OgGZDWxVFs3P8gzERG+KKLBjRVncx4t1zUYkL3updwY4FzLsigBSFQ0WiwFc4mSnAOQBG31lbQkbqW1ldzabvud8rIxue/VjdUBhecY479W8cnG0OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Bf5LdRzh; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Bf5LdRzh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782778465; x=1783383265; i=quwenruo.btrfs@gmx.com;
	bh=E6/ijKjodt2+/xF2U/EYJPJEZa0RsEk0DvFWr8of0ps=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Bf5LdRzhfGaVx0uaZzHHo//LALvcjJ5pP8cT2pA2nlVZwiiZDZbhLNKaNDZXz2a5
	 c0uK8DsHgViMsi9BPVvxl6uHC9LRRCUOhD7pEWo3KnKh8x3+fQjGIvbhW/kVYt3DG
	 KHe3BCfLcf0mP7XzBxUOYGcb+sKCreD9S6zD74ScXvEh/+1qEQ40h8e281QyAxwBH
	 Y4XAzVikK9Qw3Ba9YKv8Yf3nU4tIQlNhxNJylq+qsHI2TsDhQZmltSe9CBMhi9AH+
	 FVadet/qHubfuXzYln2N+fTYDwYqJQYa5BQzR+Psw16X0V/dzoo4mu5+Ahh4XeCES
	 XTjj4YV34oytZcROCg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MVvPD-1wWUOz3aWj-00KANT; Tue, 30
 Jun 2026 02:14:25 +0200
Message-ID: <bc40bcfe-94b6-4369-a54d-888589f3eb29@gmx.com>
Date: Tue, 30 Jun 2026 09:44:22 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: sink idmap parameter to
 __btrfs_ioctl_snap_create()
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260630000917.2521623-1-dsterba@suse.com>
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
In-Reply-To: <20260630000917.2521623-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:maxS0ELT9wGwAgMijisc/P4ouQejg3BE/uHXp+IMzoxhVt3HkxD
 5lquaBQopr2VvMEbAwVGIrRLuY0XsAOPt1HgWaLpk/906XNURVehlN+TAZz+0lF2RMhbUmD
 TVGOnqhof2kGBp0SPot8M06HZT2FfFHI4h4RMmKTSqfJ2j9fknBmUuBS5OoMg4kYN6cm7ey
 HlT4r+teZxsWqkpGyHg/g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bp2mZDMnn1I=;lsDe5Vf4JkPqRJemf6x+C7GMyFc
 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
 sQBtmqYp+iTBIemcaA=



=E5=9C=A8 2026/6/30 09:39, David Sterba =E5=86=99=E9=81=93:
> The 'idmap' parameter is derived from 'file' that we also pass to
> __btrfs_ioctl_snap_create(), assign it inside the function.
>=20
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/ioctl.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 1ed16ff4007b..8aa6538f005c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1143,13 +1143,13 @@ static noinline int btrfs_ioctl_resize(struct fi=
le *file,
>   }
>  =20
>   static noinline int __btrfs_ioctl_snap_create(struct file *file,
> -				struct mnt_idmap *idmap,
>   				const char *name, unsigned long fd, bool subvol,
>   				bool readonly,
>   				struct btrfs_qgroup_inherit *inherit)
>   {
>   	int ret;
>   	struct qstr qname =3D QSTR(name);
> +	struct mnt_idmap *idmap =3D file_mnt_idmap(file);
>  =20
>   	if (!S_ISDIR(file_inode(file)->i_mode))
>   		return -ENOTDIR;
> @@ -1227,8 +1227,7 @@ static noinline int btrfs_ioctl_snap_create(struct=
 file *file,
>   	if (ret < 0)
>   		return ret;
>  =20
> -	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
> -					 vol_args->name, vol_args->fd, subvol,
> +	return __btrfs_ioctl_snap_create(file, vol_args->name, vol_args->fd, s=
ubvol,
>   					 false, NULL);
>   }
>  =20
> @@ -1271,8 +1270,7 @@ static noinline int btrfs_ioctl_snap_create_v2(str=
uct file *file,
>   			return ret;
>   	}
>  =20
> -	return __btrfs_ioctl_snap_create(file, file_mnt_idmap(file),
> -					 vol_args->name, vol_args->fd, subvol,
> +	return __btrfs_ioctl_snap_create(file, vol_args->name, vol_args->fd, s=
ubvol,
>   					 readonly, inherit);
>   }
>  =20

