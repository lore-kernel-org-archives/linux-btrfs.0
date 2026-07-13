Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9019644B;
	Mon, 13 Jul 2026 08:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932896; cv=none; b=U10juqsJVGPBhkwVzuE+Dxk8wjRoDeZg1OJmjKtoX1/bw4Z4KsnOD6zz1KdZWmJ0zTuWCtEb2Q2MIvq0AroST8TpaoEoAo9L/nOKaDJ98IGbkOCGDzcvEUWCpTn36GRJQk5PK/WhKuI5Eqt2PRfeEHdKdwpng+Otca6O1C/k1a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932896; c=relaxed/simple;
	bh=SYTfPedHvEVpJRlu6cbH6d7PdN9JUgAzxRwE0WGIi3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lwdhWL6Grj31HL2gMGFJIR55/L/0yoZ5+ZjOcpZn6PUf1sfU4EqXW7hM64/45kJSQd5ZxFjiyyMXxR/gWkrEKSvLvpdfSTOmk6HUI9HnuCm2z+ny0jaDor9kw2mc0Ji10OQMd3zaVmuNCRs7kngVEuRzG62I5LdtXLfqJ/6OS8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=q4YHyqh7; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="q4YHyqh7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783932887; x=1784537687; i=quwenruo.btrfs@gmx.com;
	bh=VdA/alSAqVOBGETKlbvEkpq8RUbHFuFLSwoS/3DAb1M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=q4YHyqh7MIVNbURKXZTmVqblQGjb2pcbEXx65nK9pIcznN5+MyTtOLl9BbpSfSaR
	 pxZr2VcC2H7qdZuFooqtmTSoRhH/JC7R/ID9RLoTGWG1756BdxwoQMni3u8JKSBnY
	 5SW4tQ/YtCwLVl+p91Gx0k42H34MBE9qJw7mYD/EWoxV+9uEHrwv3oFsolJC+ESMI
	 oRll+ozqp6+s2AozDYIszXMZs1yIMjWxbDWtjmxsrbjx5jwMCofduRQmdUVlCpLBN
	 YiXi5HScCQ/n4bxlzLQqvzE4r1dSHbEzHdJ8jqecb+L9khJNOkJJWfS2Js12OZpzY
	 uiPKyqBRMtLHwN7poA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MwfWU-1wz6QH0NIY-00uzVn; Mon, 13
 Jul 2026 10:54:47 +0200
Message-ID: <f29fc4cd-10a7-4342-80be-2d1cb2ac293d@gmx.com>
Date: Mon, 13 Jul 2026 18:24:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix GET_SUBVOL_INFO after compat refactor
To: daan@amutable.com, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260713-btrfs-get-subvol-info-fix-v1-1-a58cc55b3696@amutable.com>
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
In-Reply-To: <20260713-btrfs-get-subvol-info-fix-v1-1-a58cc55b3696@amutable.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MyILxX8D+IBzvObVzCmy5g3dzUaX3jlbrWGBw6gElEmDkdZ5mrp
 gwZ7eNJvCjSTulLS7AZ4hAEPnqdr7BJyE8l5hBa2/OtcdxznQpMC8V86Co+t4SDJBt9ZXbD
 lsnNuwEp2YuEjxpNv4cmDZkPBBhsOX7po4EBqKR6uvBAhbnRP34eFF+JDdnF2zMmnz12v1c
 TbS1D57kO1M6a5uvargbw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:S+5nMBYFYh0=;ryTwtvB4MXKah6I+a8fVwHt37TD
 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
 JJK7Xvn9ARl6V3cSAFaPTqb4C6EKXcC53J/8f5i



=E5=9C=A8 2026/7/13 17:20, Daan De Meyer via B4 Relay =E5=86=99=E9=81=93:
> From: Daan De Meyer <daan@amutable.com>
>=20
> btrfs_search_slot() returns a positive value when the search key does
> not exactly match an item. This is expected here, since offset 0 is used
> to find the first ROOT_BACKREF for the subvolume and the actual key has
> the parent root ID as its offset.
>=20
> Before the compat ioctl refactoring, the native handler still copied the
> filled structure to userspace when the search returned 1. After the
> lookup was moved to a shared helper, both native and compat callers
> treat the positive return value as a failure and skip copy_to_user(),
> leaving BTRFS_IOC_GET_SUBVOL_INFO unusable for non-top-level
> subvolumes.
>=20
> Reset ret after successfully validating and reading the ROOT_BACKREF so
> the helper reports success and both callers copy the result to
> userspace.
>=20
> Fixes: 538e5bdbc899 ("btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_S=
UBVOL_INFO")
> Signed-off-by: Daan De Meyer <daan@amutable.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Fix BTRFS_IOC_GET_SUBVOL_INFO for non-top-level subvolumes after the
> recent 32-bit compat ioctl refactor.
> ---
>   fs/btrfs/ioctl.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9d47d16394fc..ab6c17716026 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2042,6 +2042,7 @@ static int _btrfs_ioctl_get_subvol_info(struct ino=
de *inode,
>   			ret =3D -ENOENT;
>   			goto out;
>   		}
> +		ret =3D 0;
>   	}
>  =20
>   out:
>=20
> ---
> base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
> change-id: 20260713-btrfs-get-subvol-info-fix-e93803926554
>=20
> Best regards,
> --
> Daan De Meyer <daan@amutable.com>
>=20
>=20
>=20

