Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8521C373BEC
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078043; cv=none; b=UYfV2X37USGPn3yRmKdCSOkMH3xkAbV51dprsFLPjzoAPFO+2Ol5EyN0i/e7G7rPapoCTDHWW0c7gWONuYx6NW03/xa/yBBJ/caOOUh/KbGY6FgpI6sMO4k/sq/poKKK22QRaZiFeoCrgeCnsPCYuRgPs81xor5isA/XU3ywvqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078043; c=relaxed/simple;
	bh=0SE33/yPhi22tpQigHRT4nLixF+TpY18gCUcEyGd04o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kehm/DoFwh9tNVxrLL5zsWrB9l46bbhUR8JmsEL2HcZUlNJw3k1qWEPkN5NLwS98QFSQIDPFih6CE6P5rspNmxG2nA8fY2CS46um/USrR05VOXA6TwBrNBey1L+lK6lGbGTA5hlgsMaUlsx4AUR7xpj+ugxxd/iwV//zU8yp3mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Cq2NgHkj; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Cq2NgHkj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789078039; x=1789682839; i=quwenruo.btrfs@gmx.com;
	bh=Gv/BEOeXhHAxJxY+PKHwGIse1o48BbmDjbC9IA5Z5Cw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Cq2NgHkjUwkUB87cuwzXuwd7GPJIcJS5IsDVLFRe/9BVxLWp0OjGuub57RutRYpH
	 t/XhZLyrYM9yLTw+l9WVug8EUnlBR0HOigJQ8tJNkql8+JYr1TUEMFA3Ih97SfhIL
	 mqoeLwktlnjsf8O9iRzlITZpRCvFv9TCiBxThGy01BldLXY5RAyFFe0bSM1TWXuOt
	 0XsBbCbs5sCiu5abEd6TX2cYf/B0mBKaqr7f+nOY2nEs9pSGBjuafKiiyHDdAf5Tt
	 A4HTi4Dl/NSLUsMmkuSOKV+Kbg9nL7FLPZ3jjsmdVeLGxa/g5SNAbFtPjhYpkS9dM
	 DbnIydVuzYIxcw3MsQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MvsEx-1wnfsX2pnj-013VLY; Fri, 11
 Sep 2026 00:07:19 +0200
Message-ID: <915dfe87-9b7f-4ec8-ae0c-a81819c72f27@gmx.com>
Date: Fri, 11 Sep 2026 07:37:15 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: tree-checker: print dev extent offset in error
 message
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <dcbc7e433e05fc137227f08015bfde547b7c1f6f.1789058730.git.fdmanana@suse.com>
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
In-Reply-To: <dcbc7e433e05fc137227f08015bfde547b7c1f6f.1789058730.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OjI4SEO6WsA7Y4T30XdQ3mjhEBDBkQLFnSb0rkVTbHtJbQ/0dLj
 j1FRyoB5tcKD1zArAPrU6pWsY+hb35nAja7Yiz60NAvkXLOW3DBb7b2ds7MTp0U9MCuTGqE
 /ePaMfDvI7yfODZPxy1cpW9RfmCKvS61379RU1rugajZSIgGzt58LZvisiMxAqzZLqgs4v+
 sBOTh0+x5mAfSK3zBBu+A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:t5Zba3+kOdc=;6coXjoazL5BJWHqBZQozipY4ui4
 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
 r1mXWtpZWMHCN



=E5=9C=A8 2026/9/11 02:16, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> If a dev extent's offset is not sector size aligned, the error message i=
s
> printing the dev extent's objectid instead of the offset. This is a copy
> paste error, as before this check we check the objectid field.
>=20
> Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tree-checker.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 401fd40ec7b2..63eea0852ceb 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2171,7 +2171,7 @@ static int check_dev_extent_item(const struct exte=
nt_buffer *leaf,
>   				 sectorsize))) {
>   		generic_err(leaf, slot,
>   			    "invalid dev extent chunk offset, has %llu not aligned to %u",
> -			    btrfs_dev_extent_chunk_objectid(leaf, de),
> +			    btrfs_dev_extent_chunk_offset(leaf, de),
>   			    sectorsize);
>   		return -EUCLEAN;
>   	}

