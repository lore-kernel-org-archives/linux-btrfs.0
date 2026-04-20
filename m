Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BCD332604
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 21:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776722229; cv=none; b=i7a43vLOZ9EsomQlKRjXsKwrTTlee6wDMTuUnxBwM7cYOhh1CxR37xbbBbEH9W93tO9iupdxrRP9bgU+ILFBJzamJkP5hAvgGs+zRUujiTf8M1R0IzMen5Lkp1CGvsYB+FBnJ/Fz7basIA1XFAG+qET4+B4+NsPAR2YuUrWNQYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776722229; c=relaxed/simple;
	bh=LPO2NlN6Gof5FkAmfq3ukN+xoJMIH+GFbP0tQU2ay9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aCPN62l82RNn8z+WRNMB6V2JCkdKjj36WNEMyx9dXZrSKcY3MA+OeGtVE4qYRE2kjpl8FCdQiOMnj5IhbqgaO0gxXsYUv6mvJK5h9mBmuyI4iFnbk6xDHbDEx2/AiBPvVieIcY4XpQSvmXGtylc721kvZ+soNDB/18VpJzhgmmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=VyH9HVhw; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="VyH9HVhw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1776722225; x=1777327025; i=quwenruo.btrfs@gmx.com;
	bh=kCccrwoBnlD+sRSlPiBCfXrSPR8eKz1J6i7OUbhGTkI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VyH9HVhwHShrgOg9mRq2jDbyHepx+PXEBLY+yZzmDqGz8EHzCJqV/h+mU3EVtKEs
	 5UWlqNt3y2Q8Cagg3ybxqDTwE6To0Lcq4L35qDpLa9TaR3Uk4vtl+vDkbsZFcbz6Z
	 0nNvQxLj59kijr1wYfecHJSdzaqSE+8za/83cASx/BEthi0iSVbkroS6djO6HcqM2
	 3Y9uxp3p2Ary8sdnsKb2z/H96ha6WbchIuyMZIz2KpfxqRMomvs8tDBr13l8he+sy
	 fyl1qZ1WVG9nY4pdJ5m2urzL06CM28ZX9wouVkF7E7VzaqajeSXinhJS3Q8Qf2FtR
	 czQb8tZU9YwtjbECKw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MrhQC-1va64b1P9g-00bIE8; Mon, 20
 Apr 2026 23:57:05 +0200
Message-ID: <4012d713-1d94-4e57-bf6c-09a008cc6430@gmx.com>
Date: Tue, 21 Apr 2026 07:27:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use min_size variable to setup block rsv in
 btrfs_replace_file_extents()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <efc156002e21e5453d58c2c0856f605575f27642.1776693213.git.fdmanana@suse.com>
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
In-Reply-To: <efc156002e21e5453d58c2c0856f605575f27642.1776693213.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bpVRMLhcQ4U4nECFbcflqQ2CE2B/D+eY5siZnc9G2xkdpMWw9Us
 DKQqvdTjzHAaGa3G0RrYTdK6Ngp8Fpk6DZoLJJ7wigyR0mPJ9q3SwNnnjQkniHXrJasU687
 FndrqPQCqliSumG3/KLhKJ5+Fazb1ljYjevMbz3K2oeyMHU0JcYU5fXrXrcdsEzTZBh6lkq
 pPd+k8YxCxiE6anQpnvCA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:r/5BCaROlmk=;cPgwkzzsHYGziZ/jbPp0DaCmWPi
 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



=E5=9C=A8 2026/4/20 23:23, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> There's no need to calculate again the size for the temporary block
> reserve in btrfs_replace_file_extents() - we have already calculated it
> and stored it in the 'min_size' variable.
>=20
> So use the variable to make it more clear and also make the variable con=
st
> since it's not supposed to change during the whole function.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/file.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f007f1f2fd84..7aab4a98caaa 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2395,7 +2395,7 @@ int btrfs_replace_file_extents(struct btrfs_inode =
*inode,
>   	struct btrfs_drop_extents_args drop_args =3D { 0 };
>   	struct btrfs_root *root =3D inode->root;
>   	struct btrfs_fs_info *fs_info =3D root->fs_info;
> -	u64 min_size =3D btrfs_calc_insert_metadata_size(fs_info, 1);
> +	const u64 min_size =3D btrfs_calc_insert_metadata_size(fs_info, 1);
>   	u64 ino_size =3D round_up(inode->vfs_inode.i_size, fs_info->sectorsiz=
e);
>   	struct btrfs_trans_handle *trans =3D NULL;
>   	struct btrfs_block_rsv rsv;
> @@ -2408,7 +2408,7 @@ int btrfs_replace_file_extents(struct btrfs_inode =
*inode,
>   		return -EINVAL;
>  =20
>   	btrfs_init_metadata_block_rsv(fs_info, &rsv, BTRFS_BLOCK_RSV_TEMP);
> -	rsv.size =3D btrfs_calc_insert_metadata_size(fs_info, 1);
> +	rsv.size =3D min_size;
>   	rsv.failfast =3D true;
>  =20
>   	/*

