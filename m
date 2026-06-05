Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4CA282F1A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780698901; cv=none; b=iUr47B68FHjJQSMsIyjSv9h1g0mKUFxN88CHPGnTIS1si+TSovfkvxr+uSAmBa/OcG4EZemae+HU8OWZsl1F3w26kn2mHHZ2eqVPU8sX2VHPWQSu8e8D9TZzBkrg2INEtWvMysDM4zNRtvPGNrUv3UXdkMUgdWQd93lQ8BWjeW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780698901; c=relaxed/simple;
	bh=R/Pg0cqmYEbCU5R4ilHOuHBERKUt2rhYXeA3pNk7Y6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X8l4TZPd9O16dtkelFEdM+zo9u7WZXGWaFXbqZ99R2NanNARM39Kfgoecezrh8DB7OhXozDnUTQEz0LzIsLhSdnmytil49Bvzz0GTvH2voUbVpRZIGjsCNqLLMWOH6hue81ZHIAbmBAnxlFFd/sJmeRz7D0GafBT6F2ZNkbUyFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ArM6F6zO; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ArM6F6zO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780698897; x=1781303697; i=quwenruo.btrfs@gmx.com;
	bh=ulamJcAHPeC2GeMl85ETWFnGNpDv4VnYqGf20iLJpu8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ArM6F6zOaPscoeTWJyW7cwlOWzq9n3N2VFWGkInzAgdCqZIDwo4FFN99O7r2orKo
	 U2Ge+3IGkniPnxP+wAgMvek70nxxlQOL1iAunFWEN2FbNzajCxqjs8VQuMQz6pqvu
	 ZIQF//CW4hGwzCnUMSNZjypL3jBaYUaYsKbqR2OLq5TQvkxcX7M3KaVKOHfTOIay/
	 TgoAEN7jjQNY5NDdLiu4EhyP1WW6JZO4Fuhoh8tUxC3woQvEvW1pSpwX84PPfA8Dn
	 IkBAdDYAOl+1rRXq3a/Suhiy5EWFeEGpbOYFRdN7gT80ALMeTzkdXv5d4Vx3mSGB3
	 FxCU2HLVA1ZWI7YOzw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MKsnF-1wqAge16Tt-00YobW; Sat, 06
 Jun 2026 00:34:57 +0200
Message-ID: <ad6591e7-df35-4330-b9f4-db486fa22e2a@gmx.com>
Date: Sat, 6 Jun 2026 08:04:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: move locking into btrfs_get_reloc_bg_bytenr()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <c492fc55bfc660b3638fbf8ed2f7eaf5e8b06f16.1780677506.git.fdmanana@suse.com>
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
In-Reply-To: <c492fc55bfc660b3638fbf8ed2f7eaf5e8b06f16.1780677506.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0oE2D1mThptfzxzE5fFDTBb/3TtdaYKqxeaO5FsAtPY1S4mhz4n
 7/6MxedL5/EQYqZvYAkrqEgYRhs/YFpnTQOohaWHXe4ghUiOvrXYyxHLpaZqBGC6UA7zJml
 h4ltiIP0QZ0WqboM/pyqrEKietE0VnmM3Q2l1qgVVKexCzairUoNhxEvUxrJmpHcGq8VszG
 59f6WK5BC+0u2ha6CuAXw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Z17hkFQgQJo=;g3DKEP6Gv1Q0c6beIyAQ5HGcgXe
 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
 GlOopHqjrsmzRpNJ99X8eekPAsEgQm5wWokM=



=E5=9C=A8 2026/6/6 02:08, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> It does not make sense for the single caller to have the responsability
> to lock the relocation mutex before calling the function and then have
> the function to assert the lock is held. As this is a function in
> relocation.c, move the locking details into it.
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/inode.c      | 2 --
>   fs/btrfs/relocation.c | 7 ++++---
>   fs/btrfs/relocation.h | 2 +-
>   3 files changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3c66853276b7..4a2f7ab39963 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -226,9 +226,7 @@ static void print_data_reloc_error(const struct btrf=
s_inode *inode, u64 file_off
>   	u32 item_size;
>   	int ret;
>  =20
> -	mutex_lock(&fs_info->reloc_mutex);
>   	logical =3D btrfs_get_reloc_bg_bytenr(fs_info);
> -	mutex_unlock(&fs_info->reloc_mutex);
>  =20
>   	if (logical =3D=3D U64_MAX) {
>   		btrfs_warn_rl(fs_info, "has data reloc tree but no running relocatio=
n");
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1af5d0d67af3..9771975dae99 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5905,14 +5905,15 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans=
_handle *trans,
>    *
>    * Return U64_MAX if no running relocation.
>    */
> -u64 btrfs_get_reloc_bg_bytenr(const struct btrfs_fs_info *fs_info)
> +u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info)
>   {
>   	u64 logical =3D U64_MAX;
>  =20
> -	lockdep_assert_held(&fs_info->reloc_mutex);
> -
> +	mutex_lock(&fs_info->reloc_mutex);
>   	if (fs_info->reloc_ctl && fs_info->reloc_ctl->block_group)
>   		logical =3D fs_info->reloc_ctl->block_group->start;
> +	mutex_unlock(&fs_info->reloc_mutex);
> +
>   	return logical;
>   }
>  =20
> diff --git a/fs/btrfs/relocation.h b/fs/btrfs/relocation.h
> index d647823b5d13..bb7a86e7dbe3 100644
> --- a/fs/btrfs/relocation.h
> +++ b/fs/btrfs/relocation.h
> @@ -41,7 +41,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handl=
e *trans,
>   int btrfs_should_cancel_balance(const struct btrfs_fs_info *fs_info);
>   struct btrfs_root *find_reloc_root(struct btrfs_fs_info *fs_info, u64 =
bytenr);
>   bool btrfs_should_ignore_reloc_root(const struct btrfs_root *root);
> -u64 btrfs_get_reloc_bg_bytenr(const struct btrfs_fs_info *fs_info);
> +u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info);
>   int btrfs_translate_remap(struct btrfs_fs_info *fs_info, u64 *logical,=
 u64 *length);
>   int btrfs_remove_extent_from_remap_tree(struct btrfs_trans_handle *tra=
ns,
>   					struct btrfs_path *path,

