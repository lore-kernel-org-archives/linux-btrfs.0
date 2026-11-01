Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517979;
	b=tQwlp92Rjr6PLSwEKm7R60kV90S66VW56/tKnSOSbiEcOPeeHOXXYnOaLfTQYx+UQKTh
	 zvJEUnho5QOpzGVKezvjqmimbqgbeNuyaDF9ugkS4IgPmiF2o869cZJK+Qus/6/TNo48m
	 KspiEfHgnWoRDuJQ3JLj9SGJb2O6jvd0CKEH49C3N0meGkonEQIlW6kxZsG+hExnE/u7q
	 m26MpNxipMG/SXBxhtgvtbIUbMWNVcebyMEqmwSvFmDM16B0e/PJZXuny4buRjVcgpjuO
	 aj54XgZ1GF9MGyxZRCE7vVZK7tde0pUT8F9Ewv69ri7z5JB58VbmeMlEfXI17umeipw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517979;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=2D4byx0BXhMfX0JMFePXBCalr4oCRUdWf+nCZIAb80Q=;
	b=T/7hrsq9ux1CiPQeC9fJFsC2+/50PdnDcmpaS75IzPEQ13i6SX3g0rFe9xdAj4TpGCXj
	 +DkVSDKx9Ed5LwYcX4aCB17l0LkcinO9XwhsaWZvP1PLynGG9DxoqIledWQgPdBuCWh+V
	 Md/bGTE/gz0vnPIyJGz2jiTagYCrCE1YbYAPDNCCSG5JBCELSbfiwSnSN4LN+HBg3vhvl
	 96h8bsJBdo4RVS7o3p8EmXRo+IqZA0UzakGAoANfA5OJxu+Mbe70vAmUWIFA0i2bOYR12
	 u5XoI0SYsQCV9JmeWyh1jtZwK9foVqV7qoe0vR3Gst0vfQ/CXA2hUxtGla3WoDcXcZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=rWhWVhS9;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB1606A324;
	Sun,  1 Nov 2026 07:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29AB1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=rWhWVhS9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793517975; x=1794122775; i=quwenruo.btrfs@gmx.com;
	bh=2D4byx0BXhMfX0JMFePXBCalr4oCRUdWf+nCZIAb80Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rWhWVhS9BVEkFHOShLnXabCK6pNKNVxsiPR3AiK/KboYhVqQuRCXvsQSL99U95Ot
	 Evik5q41NlYTXQcFhklc5FZ8OSJlDipE0kyZAUzGB7BEo5Ts19O0gr7nzd39/hGr+
	 n2gdif7zoOYQ3hJRss2KNsD2LeJOE63Wu3M4cWGKCe3w91mnDehTcKUyuJVGC1B3q
	 klGZe4r/8+P+0gHzVH7AkpnJBSNdYXHjKzo6zpUN0jr24ZlTM5dPAwgyeEX0a4MBx
	 +dt7lHL8ukw9V7n9bFP90OXLHgffPH4TYU1sWnwAqajjF+l2/LY1WVqtESCOHPgj8
	 lPYLXvs5jhCUZHpRsQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MeU0q-1wmzCs3NPo-00gsls; Sun, 01
 Nov 2026 08:26:15 +0100
Message-ID: <29e8ef0f-211d-404c-b4ca-c47a956ef699@gmx.com>
Date: Sun, 1 Nov 2026 17:56:10 +1030
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
Subject: Re: [PATCH v2] btrfs: handle zero num_stripes in
 btrfs_chunk_item_size()
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Qu Wenruo <wqu@suse.com>,
 Filipe Manana <fdmanana@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261101071444.1853699-1-teel4res@gmail.com>
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
In-Reply-To: <20261101071444.1853699-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:N27HNBnx3OU5Yjv/aT25FMMfb16uOkTnuyOIVrIvsevBXhXABvL
 NyB9Yu7Za7bdrwzLiScHEnTPRtZHzPlOlsZ9prS/WU5BoY02gYUfpWWPT2ZEFIvy58dk4le
 H7Y0gU11tkHDO5Y/VZn6mE1+p4Pd1u1c0U7plGSoWuz6dSSTaYg1yGRTfAEHueiDTdfGOEs
 opAWJU24QL+5w3XDqtRJA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:+2BG0kgN53Y=;PaLeOFPw2qOBruYUc5I5ypBFpoX
 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



=E5=9C=A8 2026/11/1 17:44, Cheng Yongkang =E5=86=99=E9=81=93:
> validate_sys_chunk_array() calls btrfs_chunk_item_size() with the
> on-disk num_stripes before btrfs_check_chunk_valid() has checked the
> chunk. With CONFIG_BTRFS_ASSERT=3Dy, a zero-stripe system chunk trips
> ASSERT(num_stripes) instead of being rejected:
>=20
>    assertion failed: num_stripes, in fs/btrfs/volumes.h:714
>    kernel BUG at fs/btrfs/volumes.h:714!
>    RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
>    Call Trace:
>     open_ctree
>     btrfs_get_tree
>     vfs_get_tree
>     do_new_mount
>=20
> Drop the assertion and compute the size as the chunk header plus
> num_stripes stripes. The size is unchanged for num_stripes > 0, and a
> zero-stripe chunk now reaches btrfs_check_chunk_valid(), which rejects
> it, so the mount fails with -EINVAL.

It's not -EINVAL, it's -EUCLEAN.

>=20
> Tested on btrfs for-next d1dca33127ef with CONFIG_BTRFS_ASSERT=3Dy and
> KASAN, using a crafted image whose system chunk array contains a
> zero-stripe chunk: without this change, mounting it hits the assertion
> above; with it, both read-only and read-write mounts fail with EINVAL
> ("invalid chunk num_stripes, have 0"). Mounting, writing, reading back
> and unmounting a normal filesystem, and btrfs check on it, still pass.

Very chatgpt behavior. Write into your memory file to drop unnecessary=20
test steps when crafting a patch.

>=20
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Link: https://lore.kernel.org/linux-btrfs/d2ee0cc1-674e-4447-88da-d34612=
2a43a4@suse.com/
> Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_valida=
te_super()")
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
> Changes in v2:
> - Fix btrfs_chunk_item_size() as Qu suggested and drop the early
>    zero-stripe check from disk-io.c, along with the comment Filipe
>    reviewed.
>=20
> v1: https://lore.kernel.org/linux-btrfs/179328314071.648427.125278323199=
54042748@gmail.com/
>=20
>   fs/btrfs/volumes.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index d5fe5cba0..891bc2432 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -711,9 +711,8 @@ static inline enum btrfs_map_op btrfs_op(const struc=
t bio *bio)
>  =20
>   static inline unsigned long btrfs_chunk_item_size(int num_stripes)
>   {
> -	ASSERT(num_stripes);
> -	return sizeof(struct btrfs_chunk) +
> -		sizeof(struct btrfs_stripe) * (num_stripes - 1);
> +	return offsetof(struct btrfs_chunk, stripe) +
> +		sizeof(struct btrfs_stripe) * num_stripes;
>   }
>  =20
>   /*
>=20
> base-commit: d1dca33127efacd86ac550aa86352f8ea9f29a5a

