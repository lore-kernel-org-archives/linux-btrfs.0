Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ECB3F44CE;
	Tue, 14 Jul 2026 08:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784019464; cv=none; b=adaVcz2qc+ksc6bPkPZUuMwsODClFSqZIXxQEPccyRkGwe6cvzW9tu9vpA7RHoWlpMmLCvqK1ptT2mGdbTeBBYpn3GdcCLH8LxuNaEfYp2rgE8u2xnP0c6iGTjYwz156ANZr30Mc0qLJL84eEDNLaxCiJtJjaf2DR5YK2PijTzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784019464; c=relaxed/simple;
	bh=gSIyBONUFDPiYxxIGtW4O102+rtf2F1MqEfrVJHj+tE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Bvb6JfzGaCWvh7rFOULmfAHrOhn33wh+jlaLZaVH1uLjQFoy0FC9qPKcYdGEBS3IA6nvqL9sdxGm91/rXF7RK3MmiIl8cHoQ36IdI09yo1alp2WygRqdD+7c9htPf3HR5RxKh8mKYdyiqqW8nmQzPmm8NMhbtKDZ7We89g0f4gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ZgYeKRYR; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ZgYeKRYR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784019455; x=1784624255; i=quwenruo.btrfs@gmx.com;
	bh=D9bIOVrVaFiSI/VrPhs11gAnfaDEOSQbzL0qHLzJ9O0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ZgYeKRYRpMVTonqAQ9P7VjjFuW+1vO8TK1BmB9s4hLwj27ifjQFloQCgtmwPnd0N
	 Ui7tgKQSIwCIsTGmuClW6w4UK2RAuq5zOYUHMpll+m2hUaopmBqiyEWhYOY9W1Azt
	 jANrQkV+2MFaAADgZuuMqUst5D0flauFBmMFZbgN2VWyoSt/QCAm5w43G/5oZ52bS
	 RJkt69hfGpubZONcrq+m7vsT9AnAB4B5VV6POTqjDLgxmmDpQS9PJWtqTyvr0l8Za
	 yZ+bNI45O9Yi8I4zs7b8o4PAXQGohc2CT2qSU2qvdwU9GL++4q7evmaLV3OfK1hIc
	 dNTsW7PcTy8b2L4Wqg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mg6dy-1xFqxl0Jos-00a0e4; Tue, 14
 Jul 2026 10:57:35 +0200
Message-ID: <bbd8db69-6541-4790-890f-fdbda17e1cde@gmx.com>
Date: Tue, 14 Jul 2026 18:27:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: lzo: reject inline extents without both headers
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Lee <david.lee@trailofbits.com>, Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>,
 Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260714071054.1715464-1-david.lee@trailofbits.com>
 <31f257bd-bcdf-454f-8561-a03ce42380c2@gmx.com>
Content-Language: en-US
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
In-Reply-To: <31f257bd-bcdf-454f-8561-a03ce42380c2@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZYgfkFgxwCGUqVdL/1bmIl/jcNpOZYKYNM+1+VIKW+PAEVJUJqY
 LZlqJxBMEt/4vDiDEfidSlPe6rEeV+8k6uyRa9Ee36tDxIVHKEFUBfyXl86FO7RMPwOAhIB
 VzNJwex/7KwLNjC3CEK4RfJV+udB+2Gd3dyyD7ReuzFeCitCcH7+esqFl8v7pHtpcNIe89P
 u/LFsgTguohej3QuCjLgA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mWi50xTFl+U=;n1iRcLk7aglkXS0Au/CRbAAGt2Z
 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
 G8p+Wdskk=



=E5=9C=A8 2026/7/14 18:08, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/7/14 16:40, David Lee =E5=86=99=E9=81=93:
>> inline Btrfs LZO payload shorter than two LZO headers.
>>
>> Fix the validation or lifetime rule at the vulnerable boundary so=20
>> malformed
>> or racing input cannot reach the faulting path.
>>
>> Signed-off-by: David Lee <david.lee@trailofbits.com>
>> Assisted-by: Codex:gpt-5.5
>> ---
>> Trail of Bits has a reproducer for this bug demonstrating Kernel Panic=
=20
>> which can be shared further if needed.

Also forgot to mention, it's always better to provide the full calltrace.

It will benefit people who hit a similar crash to determine if it's=20
already fixed.
>>
>> fs/btrfs/lzo.c |=C2=A0=C2=A0=C2=A0 3 ++-
>> =C2=A0 1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -552,7 +552,8 @@ int lzo_decompress(struct list_head *ws, const u8=
=20
>> *data_in,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t max_segment_len =3D workspace_buf=
_length(fs_info);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> -=C2=A0=C2=A0=C2=A0 if (unlikely(srclen < LZO_LEN || srclen > max_segme=
nt_len +=20
>> LZO_LEN * 2))
>> +=C2=A0=C2=A0=C2=A0 if (unlikely(srclen < LZO_LEN * 2 ||
>=20
> srclen =3D=3D LZO_LEN * 2 is also invalid, as that means the lzo payload=
 is=20
> empty.
>=20
>=20
> Also your base is a little too old.
>=20
> The latest for-next branch has extra error messages, thus your patch=20
> doesn't apply cleanly.
>=20
> Please rebase to the latest for-next branch:
>=20
>  =C2=A0https://github.com/btrfs/linux.git for-next
>=20
> Otherwise the fix looks good to me.
>=20
> Thanks,
> Qu
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 srclen > max_segment_len + LZO_LEN * 2))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EUCLEAN;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in_len =3D get_unaligned_le32(data_in);
>>
>>
>=20
>=20

