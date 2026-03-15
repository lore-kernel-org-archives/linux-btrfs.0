Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B1437C909;
	Sun, 15 Mar 2026 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773609489; cv=none; b=CcgQUw1yaeMCM5mzBd/3YwzD0FaqUgKZdMDsEetb7LHpAdnvS7uXhfeHZL9AbfcIPjNzvAIRQ+KKT2InFNXtgdlhj+l8xYL/ouYZ74KoWdravlmb2mN8LBjisW6LVrdYfsNfu/gDvtG8OXdApAbghub3U3IdTRSkeVfIF3o4JcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773609489; c=relaxed/simple;
	bh=nKUC9VLMGJtJSRZpYZjt7EOWGvkZByE2dn1NxbXoUj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CkW+4DDNersr6EQYIbeCcqGeeATuZbuwk+8msB1Drf5H/B8Rc3HMO+nTTX/8RTEmyha0vi8Yh6g41THZZX29XkSQVlWfPKH3q0YgD/p47CB4jQ2x3XvfoJ9LoGH4VdTv49wBMTZsooI/6ZRyheHCC4avfVwpXaox5AZPB+sCBks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=fSE+Dpwd; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="fSE+Dpwd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773609481; x=1774214281; i=quwenruo.btrfs@gmx.com;
	bh=w6j57X/hnC+HxeSrNTIxoxkLuo+bi2Rm6zvZ37QqwO4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=fSE+DpwdP0FpPFV+XPuZrMAPjGjUbDBduLErGHa7V7K4veS3HEnuwMQoOB5tLvt8
	 r1zhNl92oLr8n0m34nyWnuaXmjlD/6/DDQmSiQoq701Yh6wQO3Or5dS4/E3mKhoey
	 hKAV+zdk3OrxG38FnDMFYff8AWiuKDOjfF8uJkGdKxbOhRYql1hY6mk6yJfgbcknW
	 Yu8S1R49nsloFs8rE3bV6H5L6WRkrIkDaeFdqGXrbZp6oYUmWn2dvpLidF7SFg3qA
	 aHO3uJmfOFElZmXg0qkuoMGhzGq0kfYVyXo7HebRUxCb9QwtM2aqJN6BcupSzRiad
	 TaoJY7lFtL3a5hFAwQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MKsnF-1wKOGb45t7-00Hbol; Sun, 15
 Mar 2026 22:18:01 +0100
Message-ID: <bed22be8-4cfb-447d-8eea-9c121884b24b@gmx.com>
Date: Mon, 16 Mar 2026 07:47:56 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] btrfs: revalidate cached tree blocks on the
 uptodate path
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: wqu@suse.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260313091924.570554-1-gality369@gmail.com>
 <20260313091924.570554-3-gality369@gmail.com>
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
In-Reply-To: <20260313091924.570554-3-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Mf5nl2uLaTitQ0Clx3CZBmlzZWv7CnzMnXZOpQtwrvfgeetpxs+
 93rSedXhv9d8Iqbtfzp3N18KHfzpcFbQbOBhVT7mtlsf70GODCQlrzT+33bTJksMm7oCU/E
 WyBKD60+U7KIJqkE7rP/ioyud6C1F31x/AwM5nFNOCoQYgc6GGViu1jo3aU7+scyXBMoo0T
 wCTWNB5JLKqNOisQDFIVw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cXAVcDDi6oU=;gO+3TuiYuf8jF4Il0s6FpN9geVL
 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



=E5=9C=A8 2026/3/13 19:49, ZhengYuan Huang =E5=86=99=E9=81=93:
> read_extent_buffer_pages_nowait() returns immediately when an extent
> buffer is already marked EXTENT_BUFFER_UPTODATE. On that cache-hit path,
> the caller supplied btrfs_tree_parent_check is not re-run.
>=20
> This can let read_tree_root_path() accept a cached tree block whose
> actual header level does not match the expected level derived from the
> root item. In particular, if root_item.level is corrupted while the
> actual root block was already cached and validated earlier with a
> different expected level, the later read hits the cached uptodate path,
> skips re-validation, and builds an inconsistent btrfs_root.
>=20
> That inconsistent root can later lead to a null-ptr-deref in
> handle_indirect_tree_backref(), because backref walking uses
> root->root_item.level while btrfs_search_slot() fills path->nodes[]
> according to the cached commit_root's actual level.
>=20
> Fix this by re-validating cached extent buffers against the supplied
> btrfs_tree_parent_check on the EXTENT_BUFFER_UPTODATE path, and make
> read_tree_root_path() pass its check to btrfs_buffer_uptodate().
>=20
> This makes cache hits and fresh reads follow the same tree-parent
> verification rules, and turns the corruption into a read failure instead
> of constructing an inconsistent root object.
>=20
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>   fs/btrfs/disk-io.c   |  6 ++++--
>   fs/btrfs/extent_io.c | 12 +++++++++++-
>   2 files changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8773f1f7ea46..9a8c06c0adc2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1054,8 +1054,10 @@ static struct btrfs_root *read_tree_root_path(str=
uct btrfs_root *tree_root,
>   		root->node =3D NULL;
>   		goto fail;
>   	}
> -	if (unlikely(!btrfs_buffer_uptodate(root->node, generation, false, NUL=
L))) {
> -		ret =3D -EIO;
> +	ret =3D btrfs_buffer_uptodate(root->node, generation, false, &check);
> +	if (unlikely(ret <=3D 0)) {
> +		if (ret =3D=3D 0)
> +			ret =3D -EIO;
>   		goto fail;
>   	}
>  =20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 93eed1d3716c..1324449e892d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3828,8 +3828,13 @@ int read_extent_buffer_pages_nowait(struct extent=
_buffer *eb, int mirror_num,
>   {
>   	struct btrfs_bio *bbio;
>  =20
> -	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
> +	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags)) {

This has a conflict with the latest for-next branch.

It has already been replaced with extent_buffer_uptodate() helper by=20
commit "btrfs: use the helper extent_buffer_uptodate() everywhere",=20
which is introduced over one month ago.

I have solved the conflicts this time, but please always base your=20
patches on the latest for-next branch:

  https://github.com/btrfs/linux/tree/for-next

> +		int ret =3D btrfs_buffer_uptodate(eb, 0, true, check);
> +
> +		if (unlikely(ret < 0))
> +			return ret;

You didn't check (ret =3D=3D 0) case, where it's transid mismatch.

>   		return 0;
> +	}
>  =20
>   	/*
>   	 * We could have had EXTENT_BUFFER_UPTODATE cleared by the write
> @@ -3850,7 +3855,12 @@ int read_extent_buffer_pages_nowait(struct extent=
_buffer *eb, int mirror_num,
>   	 * will now be set, and we shouldn't read it in again.
>   	 */
>   	if (unlikely(test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))) {
> +		int ret;
> +
>   		clear_extent_buffer_reading(eb);
> +		ret =3D btrfs_buffer_uptodate(eb, 0, true, check);
> +		if (unlikely(ret < 0))
> +			return ret;

The same, I have fixed both call sites during merge.

Thanks,
Qu

>   		return 0;
>   	}
>  =20

