Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2921D3890EE;
	Mon,  7 Sep 2026 06:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762822; cv=none; b=U1DuAoxHtHVPDhRfL6UpNDvdf9r2HSIFKYY1zY/8zlb57vUDMUBk6xWJetgkk7tZrMpmEu1Y10tuNrJPP+Y3h3tgbajYin+HIHnw/GZKB7p8Vt/YiXLsrYOd5sTlu+uZOB0VDkgotFjYtMDgG+0NtN8aPR+wjXpbFm13LI1IwNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762822; c=relaxed/simple;
	bh=nNwsJKKRx8yqz0h2dnMJc9XYy0eKf8Oii59BzZVrFNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f6zvGE5rWZnyOM6hdkfbAdvwUoiwHeuV9sCAoeg+9F+iz7HwGtNRI86pkWwWn5UWBvSdkeORgQ+kBto9/b/8vEWIVQPDXQXt7sfUBj1f0k+j/7ok1vGRRbnr8r5lmSmusWnkJBZr02AlzWJ7EBE8PAVtntT2JGUDFZmFxKWg1T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=RIrHgQh5; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="RIrHgQh5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788762815; x=1789367615; i=quwenruo.btrfs@gmx.com;
	bh=+qOnSei9ObAKnZ+u4Y1NE9XW4UnEsoph2Hf4PvPg7pc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RIrHgQh5dXhat1vk9JsFzX0D2RDai+0KjciUOcJT4WRr6ac1STxiV2GPCJJEvC6J
	 BjmuzFBpQDQTpHASdHQF84VH3JyKjITwAmNZRUF6pwZ2q3N+wm0RK7ygFxckcf8c2
	 y5GurwhtBmyRolhxr1f5uA0ORzGLJoBI4cRnZEIP2gNZljcbxfZGbFYdQ92iuPM7o
	 06OOq2nfQ1kM24NpQhNCidVPHLhiSUPt5kY/8GNtK9EMJMFCZ4cdyU//B1WZbRZLo
	 +SnuhLRqH9gag8ocafuhB/rkk8BPGZz7A+t8QA1H7CR/gLEDp8KxaNol1vHhhXh9S
	 GZyZtLCM9llQm2Fddw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MxDp4-1wfJG229iS-00vKyt; Mon, 07
 Sep 2026 08:33:35 +0200
Message-ID: <4dead4c3-91fc-4c63-a1ff-101ee5e7122a@gmx.com>
Date: Mon, 7 Sep 2026 16:03:27 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] btrfs: tests: use eb folio helpers in extent buffer
 memory checks
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-3-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-3-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UtUX7gcSoq9EHADeyWMY9iHhEBpORe0krDGHI3YkiWRqQa1vzPe
 4bCs2aO4SMp3jUki1UpCyJwPPvMdb80pU5N+fhN+Vz30iLLyAT7+zA5aCq1CtuvElVZ1vxB
 24cWXakrxSxT+77bfGvefxIWXHLNyoT/X0yF0cC1+l9IcrhWEwTGgHWErR62xSExjZQyrFI
 izjPgYA0cAmk10PKh5TUg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MPG2Qv8rO34=;uxMvyRsG671xpWDFp7b/7WKocqh
 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
 ioEjIgzw3wjxtqVRh9uy2V3VOgQdbxvAr5A==



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> dump_eb_and_memory_contents() and verify_eb_and_memory() hardcode one
> page per folio instead of using get_eb_folio_index() and
> get_eb_offset_in_folio() like the rest of the extent buffer code. Use
> the helpers and folio_address(). This removes the last struct page usage
> in the file.
>=20
> No functional change. The tests only run with sectorsize =3D=3D PAGE_SIZ=
E,
> and the test extent buffers are backed by order-0 folios.
>=20
> Assisted-by: Claude:claude-fable-5-1
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/tests/extent-io-tests.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io=
-tests.c
> index 3056dd934b54..7a68b321608e 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -669,8 +669,9 @@ static void dump_eb_and_memory_contents(struct exten=
t_buffer *eb, void *memory,
>   					const char *test_name)
>   {
>   	for (int i =3D 0; i < eb->len; i++) {
> -		struct page *page =3D folio_page(eb->folios[i >> PAGE_SHIFT], 0);
> -		void *addr =3D page_address(page) + offset_in_page(i);
> +		const unsigned long idx =3D get_eb_folio_index(eb, i);
> +		void *addr =3D folio_address(eb->folios[idx]) +
> +			     get_eb_offset_in_folio(eb, i);
>  =20
>   		if (memcmp(addr, memory + i, 1) !=3D 0) {
>   			test_err("%s failed", test_name);
> @@ -685,9 +686,12 @@ static int verify_eb_and_memory(struct extent_buffe=
r *eb, void *memory,
>   				const char *test_name)
>   {
>   	for (int i =3D 0; i < (eb->len >> PAGE_SHIFT); i++) {
> -		void *eb_addr =3D folio_address(eb->folios[i]);
> +		const unsigned long offset =3D i << PAGE_SHIFT;
> +		const unsigned long idx =3D get_eb_folio_index(eb, offset);
> +		void *eb_addr =3D folio_address(eb->folios[idx]) +
> +				get_eb_offset_in_folio(eb, offset);
>  =20
> -		if (memcmp(memory + (i << PAGE_SHIFT), eb_addr, PAGE_SIZE) !=3D 0) {
> +		if (memcmp(memory + offset, eb_addr, PAGE_SIZE) !=3D 0) {
>   			dump_eb_and_memory_contents(eb, memory, test_name);
>   			return -EUCLEAN;
>   		}
>=20

