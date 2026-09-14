Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1798F242D65;
	Mon, 14 Sep 2026 06:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367576; cv=none; b=olj5tzhuHdfzK7pVhUx7jFnJlViLDSUIAh2T9DLRTYCbIcxW2fIv8XpT1TDIsTaHTVQi8l0ywH16fFgFUiRen5WNpr5yibB/n0Nda9nvmIv0odM8UOmZrXYFcc7G2gFc7AhG0eon4PE2UXZSDdxWj76docoP4Enld6/V/1hx6mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367576; c=relaxed/simple;
	bh=kc6pQGkEGwd0CMKTAYQ+AdBctix3FOQwJdv/43wTVV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxbxfSVlDj+jY7O43Hbcj9o5WZ0L1cMmcLeJObvUaY8Hh16FJHgMCcfHILxeQv4eYgpbSooW2W9Ebnoynqolk9+RwB8GfUx0XHYVwDIHlE/2Cw9Sdr51sPFCXtYr63zo7CsTGpP9QAQMlZfWB9U4IDgUoob+YKxhC/4+WeHgefU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=RI0R0Kj5; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="RI0R0Kj5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789367568; x=1789972368; i=quwenruo.btrfs@gmx.com;
	bh=o1rcAZIuPZLuOOhUOSTdIn85cxJC6r1J7wO4UsUMFsI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RI0R0Kj5aQwEPdc4LxX4gMuhMbeXC9oc0aozU2y2Mv/mXh4nZZDIek5+Hku3I0pu
	 HnGfcraKk6zPkXet2ojE3OhuyQ2B3nDnm+bztyMECl698oMJtKag8c4d6m7KdJhe6
	 HGGVTV0SyxYKWuUvyjtOmoRqBPByUgyGPIPUq6xmsmR3gzTWUubg0+EeIEN4WdVcE
	 sb5MBsNJnq83o4hXdWDSd+ffx+CjMwTaa9yYIjtJt2fadc/DBq7iSN93tKfYoyhyt
	 ln2IXLFM2+NxQYkyhN0plCn7h8Ay2ukq7wSPDhsdnqBRwvs0gnuNY9ZvkQjajNKos
	 Kbtr5ngKA6/u9Loz9w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MWRRT-1xKfn21N4l-00Mi04; Mon, 14
 Sep 2026 08:32:48 +0200
Message-ID: <2107e9f8-2bc6-42e5-98e2-30e25be016dd@gmx.com>
Date: Mon, 14 Sep 2026 16:02:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: don't force the filesystem read-only on
 EDQUOT/ENOSPC verity rollback
To: Daniel Linjama <daniel@dev.linjama.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260914062459.3889313-1-daniel@dev.linjama.com>
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
In-Reply-To: <20260914062459.3889313-1-daniel@dev.linjama.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JKXr1w1Ut0fePJxpFJemJq8wmbl0JedDU6cjFun+Jw6X46ag8zQ
 dEYhukeUZ2wDZJIqoHVqVQZNhUg8ayShTBi+o05nAh8CTV4/0KflsREXo1i4UzfilNacW5I
 LchkRgTVMbkslu6zd+0P6tDqzz7qSeopTCY1IeSsaBBj+bx7mP+bUeq6qh5pPkPpP4nKd12
 aMJtzHl471PW4BpDPfd2Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mbMfne6zBxE=;hUrAGf0eR6Dkg0i2x1ILto4SW5s
 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
 f5wxUUF/23OX9+N0h416T5



=E5=9C=A8 2026/9/14 15:54, Daniel Linjama =E5=86=99=E9=81=93:
> When enable_verity() hits the qgroup limit, rollback_verity() needs its
> own metadata reservation. When the qgroup limit refuses the rollback,
> the whole filesystem is forced read-only even though the qgroup limit
> was for one subvolume only.
>=20
> Skip btrfs_handle_fs_error() for -EDQUOT/-ENOSPC and just return the
> error. The verity orphan item is left in place but the orphan cleanup
> from commit 705242538ff3 ("btrfs: verity metadata orphan items") will
> remove it at the next mount. fsverity enable still correctly fails but
> the filesystem is not forced read-only.
>=20
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Daniel Linjama <daniel@dev.linjama.com>
> ---
> Verified on a virtual machine with a mainline kernel (08df884136f1) and
> a loop-mounted btrfs, with either a qgroup limit on a subvolume or a
> full filesystem. On the unpatched kernel the whole filesystem was forced
> read-only. On the patched kernel fsverity enable returns -EDQUOT/-ENOSPC
> and the filesystem stays read-write.

Please also submit a fstests case for it.

>=20
>   fs/btrfs/verity.c | 22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 4e0ab5842274..8d0f9eea4c39 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -441,7 +441,9 @@ static int del_orphan(struct btrfs_trans_handle *tra=
ns, struct btrfs_inode *inod
>    *
>    * We try to handle recoverable errors while enabling verity by rollin=
g it back
>    * and just failing the operation, rather than having an fs level erro=
r no
> - * matter what. However, any error in rollback is unrecoverable.
> + * matter what. Failing to delete the verity items for lack of space is
> + * tolerated, the orphan item ensures they are removed on the next moun=
t.
> + * Any other error in rollback is unrecoverable.
>    *
>    * Returns 0 on success, negative error code on failure.
>    */
> @@ -456,9 +458,21 @@ static int rollback_verity(struct btrfs_inode *inod=
e)
>   	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
>   	ret =3D btrfs_drop_verity_items(inode);
>   	if (ret) {
> -		btrfs_handle_fs_error(root->fs_info, ret,
> -				"failed to drop verity items in rollback %llu",
> -				inode->vfs_inode.i_ino);
> +		/*
> +		 * -EDQUOT and -ENOSPC mean we could not reserve metadata to
> +		 * delete the verity items. That is not a consistency problem,
> +		 * so don't turn the filesystem read-only. Leave the items and
> +		 * the orphan in place, orphan cleanup on the next mount will
> +		 * remove them.
> +		 */

EDQUOT is fine, but I'm not sure if ENOSPC is really recoverable.

Even if we ignore ENOSPC for now, we may have really exhausted the=20
metadata, and the next transaction may be aborted anyway.

I believe your test case is only utilizing qgroup limit, or did you hit=20
a case where btrfs_drop_verity_items() returns -ENOSPC and the fs still=20
works fine?

Otherwise the idea looks good to me.

Thanks,
Qu
> +		if (ret !=3D -EDQUOT && ret !=3D -ENOSPC)
> +			btrfs_handle_fs_error(root->fs_info, ret,
> +					      "failed to drop verity items in rollback %llu",
> +					      inode->vfs_inode.i_ino);
> +		else
> +			btrfs_warn(root->fs_info,
> +				   "failed to drop verity items in rollback %llu: %pe",
> +				   inode->vfs_inode.i_ino, ERR_PTR(ret));
>   		goto out;
>   	}
>  =20

