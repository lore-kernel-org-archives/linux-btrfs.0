Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BC32F7445
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780698867; cv=none; b=U8ypfVmSMQaagg7P/YCpNOHcb9hEZC2XqYIAbBgFbyAyBW1obn8QfjiUQq4XbMU/C+BA8Vo8fzmdgFxGvyxu2Uk65JtN9EN9LT/NYj7nKbTlqkYMJrDLtrg8lLvUUNEr8k3uAZep15AiEMT8QK0SzmOfCgTvPZSbFD14Rh/a0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780698867; c=relaxed/simple;
	bh=ZQdg82RASjDIEOkts4Y6UEiDA7Spnk7fUA6Sl1o9k7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gKYtmCZM5YK/woKK2w36K7849qAapqtU+NcffvOsuoRY1ccY0hXDAcmzH+Eh05DSBAYjuPFauONVkG8tjv/jQjxwgRr8oCQv+wbvZjeGEXvVahJni2F7s5mgd5aFzVYfk949OzjRQSIb19KLIPw48lA+ih5NMJiLGaoKI4LYLFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=IFimVAUf; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="IFimVAUf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780698859; x=1781303659; i=quwenruo.btrfs@gmx.com;
	bh=QAT+9FdNI6rg4i9ppxppX5xPTINeC+wg/NPqxHoU6Do=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=IFimVAUfG51emql2en8KGqfZCc775j4Yw48nZH0lnikGtAeVvQ+0DNEVXj/YefhN
	 KGjSbXcBFRvMVxYUYKlcVUM05Zrlg9+6f6Vhk3yJvj2Pdk0YvlHCt1mEvDl19Mcm6
	 wkthvqYiUmN6sDHH02sZVIwTbQ3dfd32rCXHdyx9mpRlBaWCCxc4QQgG7WkMyDHMp
	 hL9j1pkZxDje+49B+w0oNHmGRN1dkvjk1Sk/hVaUNpSEVl+Q2svkVAgK0s8jXBgdu
	 fVc983ULNMQsC/Tlc6spmmOSgiOk4dh8iI0nM9ZAxCfaPhbP2EXKRTqR81AtIGZLd
	 0mzIDLW6sFfQ01tmMg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MwQTF-1xNJfT477N-01840R; Sat, 06
 Jun 2026 00:34:19 +0200
Message-ID: <8f08eca2-3f65-490c-b9e6-c59351deb1be@gmx.com>
Date: Sat, 6 Jun 2026 08:04:15 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move WARN_ON on unexpected error in
 __add_tree_block()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <3c637e06f9a7c3e83b430c4b30620118356cd3f5.1780677634.git.fdmanana@suse.com>
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
In-Reply-To: <3c637e06f9a7c3e83b430c4b30620118356cd3f5.1780677634.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:u04eR3UNO/2ECPox5l8g+KHGeil/R3KhTD9i4xQtIWHvTec23YG
 e+IypKqNzg+KHPh1NBdSLPRhWPRC+/8xFXW/W7NSxkuph57NFxcBjuQ/BH0wW5AXCD070bE
 zBCbAmMamkuociqDlAz79eX0dPvDrGGTaIte9OfFGnXTrcrZ2D8srC14ERj1NRvwbaiShf7
 oBboaH9ua80sSC8UIZu8w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ro9Bwrcys6E=;B695CUmM395PITchRtx3xBBO4BS
 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



=E5=9C=A8 2026/6/6 02:11, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> There's no point in having the WARN_ON(1) inside the if statement for th=
e
> unexpected error. Move it into the if statement's condition, which bring=
s
> a couple benefits:
>=20
> 1) It marks the branch as unlikely, hinting the compiler to generate
>     better code;
>=20
> 2) The WARN_ON() produces a stack trace after the dumped leaf and error
>     message which can hide that more important information in case we ge=
t
>     a truncated dmesg/syslog.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/relocation.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 9771975dae99..6b462920306c 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3236,13 +3236,12 @@ static int __add_tree_block(struct reloc_control=
 *rc,
>   			goto again;
>   		}
>   	}
> -	if (ret) {
> +	if (WARN_ON(ret)) {
>   		ASSERT(ret =3D=3D 1);
>   		btrfs_print_leaf(path->nodes[0]);
>   		btrfs_err(fs_info,
>   	     "tree block extent item (%llu) is not found in extent tree",
>   		     bytenr);
> -		WARN_ON(1);
>   		return -EINVAL;
>   	}
>  =20

