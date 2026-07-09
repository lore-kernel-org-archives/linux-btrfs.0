Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DF19D8BC
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783636413; cv=none; b=ak2RSlUToiOHg9mrL6xmEtW3cI8rc8AFCykRym9jwL5l4hZ+11zogKIMwzKc37tSP+CCJ+Bs0CZAaXWlpxHNLX8M4UOJ2hJ2+1yh2l1iIFWg/GqWzdf7mtQS4K5MVBU6D5jl8P/se8lz90Lwmkw9HurVzfGvTZ7xCG88X1yTSvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783636413; c=relaxed/simple;
	bh=xy261IP+ne6cpfejLwbZZsIuy3TqjB6z5U9DCa6YhRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxRiiwfnTWrTWkcuTVHFbaLAruZ4znihXd85PW/IgSXq9UqmrA4YltajF4Qdf0BO+DESRBMQrOgS1gqkUjbRrr0HaIbXcLURZRmB2UFZnUUEN2VtHuBSY9lZo+ocpBX0ijfWbgYVLPCmgGEmwvQ8rQtiJHd1UNefgR7x+UwROtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rftC9n2Z; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rftC9n2Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783636392; x=1784241192; i=quwenruo.btrfs@gmx.com;
	bh=xy261IP+ne6cpfejLwbZZsIuy3TqjB6z5U9DCa6YhRg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rftC9n2Z3MI0Sy4V7NtY15lEgUwh0Fl7iqEoKKcnBc2uBZn106ZIXeWTCUtzpe6K
	 L6XR6F7jg1WxtCV34wySMsRVKA6opZsJ5JD9ILO3dFU+gQNiw46NgMxXhR6rFe1hF
	 HI19YWNei7MUoCAqziAk9/fuF9QaI+PkQdZPKaYbsAhjdJEeoDHDDuAsYCZow0eO0
	 jvCH6Hy6YnKLDsccb5mxMfLdvyLoMNai88V0i80wmE9RQz638BoYAokkLLvaxns6W
	 npseIRgk+wa7h5GriSpw+XgVC/PH14bJWMwBo8B/9zaWnE0NZiJLzT+Bc3R9QSEsy
	 AmeF6pDWmo0cAAVl+A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MJVDM-1wSdNX2PnM-00Pnot; Fri, 10
 Jul 2026 00:33:12 +0200
Message-ID: <ba111df7-4017-4336-ae3b-ba9bc9c53306@gmx.com>
Date: Fri, 10 Jul 2026 08:03:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, willy@infradead.org
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>
 <20260709171804.GB1552049@zen.localdomain>
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
In-Reply-To: <20260709171804.GB1552049@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hoA3bToyhqOrCbzGqReRKITKadNPSpuICF7FQo61kiK4zrkardv
 ySxa3Ly6vCM2fmXgIEW3JGCh6CBEipUfujHYVhkRHsyBEAWsedwLNCO94hHe/rzjnXQMNos
 TLYtSbeAgJHLI7ToYZlddGs7WNifqYeYu/roe3gJfiKDtlvqlU7/A8GV1hn46dUHIycjrLJ
 c1VlBcF929Oh7Uj29WjoQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8eAGu6pFwuk=;+YiSD43vpRqMfs+ZAMBWSN5puJj
 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
 k/3QKKiB5Nx26aKlNk=



=E5=9C=A8 2026/7/10 02:48, Boris Burkov =E5=86=99=E9=81=93:
> On Thu, Jul 09, 2026 at 06:16:55PM +0930, Qu Wenruo wrote:
[...]
>>
>> In that case, as I mentioned in another thread, I'd prefer not to call
>> folio_mkclean() too early.
>>
>> I'd prefer to call folio_mkclean() inside extent_range_clear_dirty_for_=
io()
>> instead.
>=20
> The idea is the zoned folios submitted by run_delalloc_range with
> pages_dirty=3Dtrue. Only the one main folio will be cleaned in
> extent_writepage but several get submitted in this loop while locked
> (which is asserted by the pages_dirty check).
>=20
> So assuming we want to clean those folios (which I think we do)
> then we need:
> extent_writepage (main one covers usual large folios and inline)
> extent_range_clear_dirty_for_io (covers compression stability)
> extent_write_locked_range pages_dirty =3D true (zoned batch)
>=20
> lock_delalloc_folios() covers the last two in a single more
> principled way, IMO.

Oh I forgot zoned cases. In that case indeed lock_delalloc_folios() is=20
the location that covers all.

Then the code looks good to me now.

Thanks,
Qu

>=20
> I am still making sure all of this reproduces exactly as I understand
> it, though, to be as convincing as possible :)
>=20
