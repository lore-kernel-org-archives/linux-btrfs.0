Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C433D409617;
	Tue, 14 Jul 2026 08:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784018306; cv=none; b=r6B4yBJVcJ37SPE6YIFcDUAKxP/hhxh5A93y2nuUKKwjTCFuCCPEjIoWwsG6L4gqGXirh5pVwyxp9Ml2o7PBs7hH8DfcFIOqeVryHJ1gqykXQwPST37WT0tjRLPz8sMpDs+4F50NwOMEAm3mw8FvG8yG5CIvO3M101qunLyJAd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784018306; c=relaxed/simple;
	bh=45ipIGtaKmGzXWGBhmvdZC66gbmaTp3oJAml4QQakEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MfjQAuJEMA+Pn9L6p5s9pbNHunQ9UhhImKKDxANbQZ/ptIExg+6+4ZlV/nFlgJwPKdBy8X9C9igWZasIRAuIIyiEZbDUxWSBMqRt5x8Fy9Bi8BIhCjLFhlB6RYWp78hvhFd2InwnfH92jZ4eiBtAg1IjFceWsggG/8tjuKYYbaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=L2UN1kFk; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="L2UN1kFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784018294; x=1784623094; i=quwenruo.btrfs@gmx.com;
	bh=gPosDkbTQT+KERRQy3AyvSFkA25SQTrPDgIXpR5uNLQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=L2UN1kFkuqHTeir2DnCelGImA9q+335pL0l/vhCSv+gj+zE8HZxzxxVLzNF1XMMK
	 6ZC8yRM0YV2uSYR2wzryUkSCcbW54t8pbFAunu1kuYKgnqRTNd0JaVIfflIcifvoU
	 JoyaDRWlDWLLJz1+IJKVwyv5bRy9Jdyy1NYJOSxx+Wt4UtU1x6ln4FWjpCiJoYIKY
	 TWmbIK6b267J3QxnfOc+YuE97TqmPMoF0SNvWyEojQRAGMZWfLU71NZ0SdlwZiPW0
	 eLAZPPbO6QyBdzlr9ODt6ZHzPDXRsS3ia2KHhsqF/75IPkj9FkelUCcpwUG1vKpSt
	 Ehv63vcnzgm5vgOQ6A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MLzFx-1wRc843hVh-00NKui; Tue, 14
 Jul 2026 10:38:14 +0200
Message-ID: <31f257bd-bcdf-454f-8561-a03ce42380c2@gmx.com>
Date: Tue, 14 Jul 2026 18:08:09 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: lzo: reject inline extents without both headers
To: David Lee <david.lee@trailofbits.com>, Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>,
 Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260714071054.1715464-1-david.lee@trailofbits.com>
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
In-Reply-To: <20260714071054.1715464-1-david.lee@trailofbits.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YlH+UMhG1O5qhCWVVRj2Lr1oC8yzcdzPTqa53Rc0zCvQfw6Sgvt
 C1flhBQ0zRzdbOi8VKS896qYzqqZBRlTAy8LJVCFfcJF/pwf27AuqGxz2FEfw/aqfqRQPs8
 A9I2JNzHaz/BjrII6zqyBoMWBw2ac62WVqMtPQESc5J7qgmz2Y5XGK6FpjJR7DZtrONYjmq
 TcNJcXeM/ylm4C+zntCWw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SRDGu+F/BCw=;GaBr5B5aNG0kFuoDogoSxVCZOkh
 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



=E5=9C=A8 2026/7/14 16:40, David Lee =E5=86=99=E9=81=93:
> inline Btrfs LZO payload shorter than two LZO headers.
>=20
> Fix the validation or lifetime rule at the vulnerable boundary so malfor=
med
> or racing input cannot reach the faulting path.
>=20
> Signed-off-by: David Lee <david.lee@trailofbits.com>
> Assisted-by: Codex:gpt-5.5
> ---
> Trail of Bits has a reproducer for this bug demonstrating Kernel Panic w=
hich can be shared further if needed.
>=20
> fs/btrfs/lzo.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -552,7 +552,8 @@ int lzo_decompress(struct list_head *ws, const u8 *d=
ata_in,
>   	size_t max_segment_len =3D workspace_buf_length(fs_info);
>   	int ret;
>  =20
> -	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * =
2))
> +	if (unlikely(srclen < LZO_LEN * 2 ||

srclen =3D=3D LZO_LEN * 2 is also invalid, as that means the lzo payload i=
s=20
empty.


Also your base is a little too old.

The latest for-next branch has extra error messages, thus your patch=20
doesn't apply cleanly.

Please rebase to the latest for-next branch:

  https://github.com/btrfs/linux.git for-next

Otherwise the fix looks good to me.

Thanks,
Qu

> +		     srclen > max_segment_len + LZO_LEN * 2))
>   		return -EUCLEAN;
>  =20
>   	in_len =3D get_unaligned_le32(data_in);
>=20
>=20

