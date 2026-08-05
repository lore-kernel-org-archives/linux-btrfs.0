Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFAA6BB5B
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 03:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785899956; cv=none; b=fpskJ1wqVTw1gRJCiVw5B5jRK319n5dq3A+gRLyvdqeNuUXSUHgybPtBl3q0gBzHJjtEXTxryMyypVephkz+Re5QHFML3+fgZ8mCsnb/V+TW3jUVZg8kdrzqBZH2aFu7muIINCVvJ63W8hcraao1dqL0ENSfi4D2YNfSzui/p2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785899956; c=relaxed/simple;
	bh=YuncvcE5QpW+w5//fFoH7PWMZ9+THdRxcz1mutipCuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nihdDRpFMPky2gat+EB8G5ULQf0WuO86X/6q4t1R2Fjl8TUAHDOQrMTbu75q26kC6zOPxBRD2WjrzsG2KDGP9dKRy7W87E7FoCSIS3pDCKZmYBL9eBdXqODqcklBiE6ENn7PYTDntTBDIKi6RaHjjhaunlIMqh3P0456TDWAVGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=SvA4XVtL; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="SvA4XVtL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785899948; x=1786504748; i=quwenruo.btrfs@gmx.com;
	bh=gEfcPW2NWDYBLOa/rJ21GLS7wDK81rXvnWhR4gUGdvg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SvA4XVtLFIr+3vtuIm1SRTdH8YqaD63Vr9lQwOmqwZmNXsP/l+xtJWfbopdhMMMB
	 ggtMYBt3CBm/DQPBPHAQ4HfYxxyig02nZ0O3MnSBwm4wO02S7iVpw8yadLKVrsCAz
	 tbx88SHcLLhoepHCsPSv39+Dy/fxeLlyaDensjXqAy8ath77ApYj/SdGqvPTcETq7
	 S8zyez6DjhVeYn6Cf+neVuIur8TKvZ+If4kAbIUhZrnJ7Eq4J+jQpNTAURKaNAzA0
	 CMi6lnrmyDqDkxx1NbuXwWsjHAxTubJGxjElJx1TZSURbUsBenB8+1nxVAtD/VPjL
	 A0Hgy1M8Rw0yJ4Z4jQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Ml6m4-1xKyTX1qWa-00dz5p; Wed, 05
 Aug 2026 05:19:07 +0200
Message-ID: <49b72d7e-be1b-4bd1-a6b5-3261502ed1a0@gmx.com>
Date: Wed, 5 Aug 2026 12:49:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: unlock inode and extent on pages alloc failure
 in uring read
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Mark Harmstone <maharmstone@fb.com>
References: <20260805021135.1896609-1-yangxiuwei@kylinos.cn>
 <20260805021135.1896609-2-yangxiuwei@kylinos.cn>
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
In-Reply-To: <20260805021135.1896609-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d8/0Mgxu/Nn2cSjxCyieXz2FPPP/t68FQIKgoAJufY20PEerj3S
 EI2Fprr3pjIulU0tYFi0ENzuP0kdkkLsyWuZU6FgunLpq8gzvB75kwGMh2Gh+UdHu9+2iqZ
 /dsQ0dENsAqgLvutV2QfptJPvrQVhKbcza1EBgC9sJjDAiiWO3i0lMd+lEshkldCVuJyI6D
 4c6hPnevV/Mf4M12uoBig==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4W1fCNjL+x4=;fYFumiCGb4cRZjqqxJtgWxugzzT
 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



=E5=9C=A8 2026/8/5 11:41, Yang Xiuwei =E5=86=99=E9=81=93:
> btrfs_uring_read_extent() is only reached after btrfs_encoded_read()
> has taken the inode shared lock and the extent lock.  If allocating
> the pages array fails it returned -ENOMEM directly and left both
> locks held.
>=20
> Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENC=
ODED_READ ioctl)")
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>   fs/btrfs/ioctl.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 68b33f365fda..c953e4409d5b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4626,8 +4626,10 @@ static int btrfs_uring_read_extent(struct kiocb *=
iocb, struct iov_iter *iter,
>  =20
>   	nr_pages =3D DIV_ROUND_UP(disk_io_size, PAGE_SIZE);
>   	pages =3D kzalloc_objs(struct page *, nr_pages, GFP_NOFS);
> -	if (!pages)
> -		return -ENOMEM;
> +	if (!pages) {
> +		ret =3D -ENOMEM;
> +		goto out_fail;

The extra handling is only to unlock the inode and extent io tree.

And neither the inode nor extent io tree is locked by the function=20
itself, but btrfs_encoded_read().

I do not believe this is the correct location to unlock inode/extent io=20
tree.

Move the unlock into the caller, as the caller is already doing such=20
unlock after copy_to_user() failed.

> +	}
>   	ret =3D btrfs_alloc_page_array(nr_pages, pages, GFP_NOFS);
>   	if (ret) {
>   		ret =3D -ENOMEM;
> @@ -4677,9 +4679,11 @@ static int btrfs_uring_read_extent(struct kiocb *=
iocb, struct iov_iter *iter,
>   	btrfs_unlock_extent(io_tree, start, lockend, &cached_state);
>   	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>   	kfree(priv);
> -	for (int i =3D 0; i < nr_pages; i++) {
> -		if (pages[i])
> -			__free_page(pages[i]);
> +	if (pages) {
> +		for (int i =3D 0; i < nr_pages; i++) {
> +			if (pages[i])
> +				__free_page(pages[i]);
> +		}
>   	}
>   	kfree(pages);
>   	return ret;

