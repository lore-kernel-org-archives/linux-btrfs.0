Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35017376BE0;
	Mon, 17 Aug 2026 06:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786946588; cv=none; b=ZMasg/qOQR3yEDNv97caDU2FcrZZPG/FYfjmBnNmJQhAAyO5JZnLqkX6mcC8BNtqD64XNgSTKbfgSlUTvhD/QPY4wwhUyeObKwwxiUy5i8KgN3VpWoOyj1Nd8HSDalh2khgBf3U3M6DFVUOwUep6ynw+hWSw5CEl+3A3z8VtoWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786946588; c=relaxed/simple;
	bh=TsyzuttOxgRaryjt2XnleFPtUNp8nuJslUmymXN10mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpVJOfIuL09gctm81n/5E7j9dFjrSPxvtu5U4IesqJKBhb6SdvvHYWGbi/HY0iH2swGUW6WTcV8n/BihLg2KBEu3m8MvaJA+IAjC4fQN8NHza5sts0EOL1icg8XeykWVfvDoUcBZR4SR2/yEZ7d9kzZKYvol1W87nDEOmUrpDlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=QDhEdcgM; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="QDhEdcgM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786946568; x=1787551368; i=quwenruo.btrfs@gmx.com;
	bh=XeHDOqrscDb6V8WG+Mcy4XrXhDny68BRKgokOMisDfY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QDhEdcgM5qTGxXVSxC74GJ5wDyxWUpZCR/coJGWpX2SJKiwfZw+oQfqadDSh64JA
	 yUlnt+ElwtkMStL7j0BfQObq9M9OKfPznRahihoRFo/phFEGbJdkcLPSF97AyUjlY
	 9c9lKFhGfc4w5l6w2Wl0hOp4cNJLacndgvnQ2LvPxDWpkhKbGnfgZaTxrc0YoI0Ye
	 CwsFPRXvo+T6fAaiEvo4okO/ggO/j2wdFRSX0K4Sy+nstOAcXEoE0y4+kh6BvOXCV
	 TiFp0M+jH/9WzEBGIEVfZ7I8xq3XNC9+NRUIPIp9FyEgdYYb495yXum6IbncCZPn6
	 PN8+Wq9j0Jdgvw3OWQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MjjCL-1wXDCF0DEJ-00nkqN; Mon, 17
 Aug 2026 08:02:48 +0200
Message-ID: <eb3d2310-fbd0-474a-b44a-1d5da3d0a8f6@gmx.com>
Date: Mon, 17 Aug 2026 15:32:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: handle highmem folios in read_key_bytes
To: Hongling Zeng <zhongling0719@126.com>,
 Hongling Zeng <zenghongling@kylinos.cn>, clm@fb.com, dsterba@suse.com,
 lizetao1@huawei.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260817022012.19658-1-zenghongling@kylinos.cn>
 <8e30fed1-5879-4a26-a1a2-d1a3302bc068@gmx.com> <6A828ABB.10507@126.com>
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
In-Reply-To: <6A828ABB.10507@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:X7/Qa/VGtu547RbKL4/lNl5POuoxCOflDj2+o6KUT6+PGwZMTR/
 KW95h5j5iigkrFILGOtXq+z4ziXuI8wQjSIdOHU2XHlQHDeQx7bRfSXieQquy6EbAHuKfyf
 Mxw3NGjghwFOtokXctLEvu8/sHAhEzcJnVEZm8SJtC2XQllgt1Bj9GvJbvqrJg/NPdI2+2L
 24XD+U6qJ5Tlug3qWKWfw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vwKyM7wz1Eg=;n+aPgEvLNV3X+V3FDG+P0/yMCJe
 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



=E5=9C=A8 2026/8/17 13:44, Hongling Zeng =E5=86=99=E9=81=93:
>=20
> =E5=9C=A8 2026=E5=B9=B408=E6=9C=8817=E6=97=A5 10:55, Qu Wenruo =E5=86=99=
=E9=81=93:
>>
>>
>> =E5=9C=A8 2026/8/17 11:50, Hongling Zeng =E5=86=99=E9=81=93:
>>> On 32-bit systems with highmem, folio_address() can return NULL for
>>> unmapped highmem folios. When this NULL is passed as the dest paramete=
r
>>> to read_key_bytes() with a non-NULL dest_folio, it violates the=20
>>> function's
>>> contract (which requires dest to be non-NULL when dest_folio is=20
>>> provided).
>>
>> But metadata folios are not allocated by page cache, but by btrfs=20
>> itself, which always use GFP_NOFS then attach the folio to page cache,=
=20
>> thus should not get highmem memory in the first place.
>>
>> And there is no way to trigger read from userspace on btree inode, so=
=20
>> there should be no highmem folios from the beginning.
>  =C2=A0 Thanks for the review.
>=20
>  =C2=A0 I was not able to reproduce this on a real system. This was=20
> identified through code analysis with assistance from glm 5.5, not from =
a
>  =C2=A0 real-world encounter.
>=20
>  =C2=A0 Your analysis about btrfs using ~__GFP_FS for folio allocation a=
nd=20
> the lack
>  =C2=A0 of userspace trigger paths makes sense.

Sorry, it doesn't.

I mis-read the context and considered the folio to be from btree inode,=20
but it's not.

So it can still be from page cache, which can be highmem.

But on the other hand, I do not think your fix is doing any good to the=20
readability either.

I'll rework the involved function and caller to remove the folio=20
parameter, and instead always pass a vaddr and length to=20
read_key_bytes(), and let the caller to handle the kmap instead.

> The proposed changes are=20
> based on the
>  =C2=A0 generic folio_address() behavior and the theoretical dest/dest_f=
olio
>  =C2=A0 invariant, but I do not currently have evidence that a highmem f=
olio can
>  =C2=A0 reach read_key_bytes() in this state.
>=20
>  =C2=A0 I will withdraw this patch rather than claim a reachable highmem=
 bug
>  =C2=A0 without a reproducer.
>=20
>>
>>>
>>> The original bug had two symptoms:
>>> 1. Unsigned len underflow when len -=3D copy_bytes executes (infinite=
=20
>>> loop)
>>> 2. The folio remains uninitialized because the copy block is skipped
>>
>> So did you really hit the problem in the real world?
>>
>>>
>>> Fix requires two changes:
>>>
>>> 1. Change "if (!dest)" to "if (!dest && !dest_folio)"
>>> =C2=A0=C2=A0=C2=A0 - Prevents the "counting-only" mode when dest_folio=
 is provided
>>> =C2=A0=C2=A0=C2=A0 - Fixes the underflow/infinite loop
>>>
>>> 2. Change "if (dest)" to "if (dest || dest_folio)"
>>> =C2=A0=C2=A0=C2=A0 - Ensures the copy block executes when dest_folio i=
s provided
>>> =C2=A0=C2=A0=C2=A0 - Allows kmap_local_folio() to properly map the hig=
hmem folio
>>> =C2=A0=C2=A0=C2=A0 - Actually writes data to the folio
>>>
>>> Without the second change, the highmem folio is not populated even
>>> though the read succeeds, causing subsequent fs-verity verification to
>>> operate on stale or uninitialized data.
>>>
>>> Fixes: 884937793db5 ("btrfs: convert read_key_bytes() to take a folio"=
)
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>
>> Missing LLM disclosure.
>>> ---
>>> =C2=A0 fs/btrfs/verity.c | 4 ++--
>>> =C2=A0 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
>>> index 983365a73541..80bc945c7dcb 100644
>>> --- a/fs/btrfs/verity.c
>>> +++ b/fs/btrfs/verity.c
>>> @@ -351,7 +351,7 @@ static int read_key_bytes(struct btrfs_inode=20
>>> *inode, u8 key_type, u64 offset,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* =
desc =3D NULL to just sum all the item lengths */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!dest)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!dest && !dest_folio)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 copy_end =3D item_end;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 copy_end =3D min(offset + len, item_end);
>>> @@ -362,7 +362,7 @@ static int read_key_bytes(struct btrfs_inode=20
>>> *inode, u8 key_type, u64 offset,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Offset from =
the start of item for copying */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 copy_offset =3D=
 offset - key.offset;
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dest) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dest || dest_folio) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (dest_folio)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kaddr =3D kmap_local_folio(dest_folio, 0=
);
>=20

