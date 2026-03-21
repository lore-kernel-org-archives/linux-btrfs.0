Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7657C29B764;
	Sat, 21 Mar 2026 03:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774065012; cv=none; b=c7sWMqagIBHxPQXyc5JJql6vrNNO1DSqp59d2C3x/00Ey1fyY0zuvv9D82yz6/kCmXkC8Q6X4+fLyuX9s4hB6I0qpCO9yR1jZ4xiZn3v/wxEFfRR1ndyjuXFccS0TUGNTOTBOtNAvId84qcWuSzfKSeRfGZ9TsrYVrN15mnWYEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774065012; c=relaxed/simple;
	bh=ikPixLMxxWlOcdnZnX07qmr7crTCRm8kf6UTDVrIro4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=goR6GGAwz0VwnwY23wl4jI/4baQIU+qJ37saUZ0AGh2jladutHNVon1Y29jCVOfRYqJGmy4hjV1xkPte7VEv2iHgRvRyt+X6NOuSNMJPduSdj/jh6RXa+7OoK60AgKDdPpX1x/P840jZ7KupXXUyCbgGr8Y7IK/+5aMxa+hi/8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=gElk4lE5; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="gElk4lE5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774065008; x=1774669808; i=quwenruo.btrfs@gmx.com;
	bh=ZtjlirWwilM/B1Tb+ELLjjgGrpxpGS5NxGTZQ8IW3VA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gElk4lE52Rzo+L/LhBmc/9ix4QkPD8togtbhhlr02ZUaBvU6GeG8qL6ZIJnFg0XJ
	 dCOOTFiSBCyLZ9B8DW1g1ozlHCyorr/iC3G6SHPhQ4kewXqQQDw1FKvHy/aeuB5LY
	 9ypZyK6jVkrk/HHq/FBEyy8EfW4fiosrPMN12nx2aG/W7NK2SOo3p9ZzrrJETptEw
	 su5B+uXm3ZalInvUfTw39sWoJQKlgL2qX15DHJ9jKLg/WP4n7N6snGCZX3wG+jM3X
	 0xoiNb/52oNz1qXeax28tSGNfwiTR/h6fwRSkvgn5btSLTAfhmQwNhbrRJ/GqlXnt
	 9TrHbXNx9HhuAAUTCQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MMXUN-1wK5Hb0jZP-00WtRd; Sat, 21
 Mar 2026 04:50:08 +0100
Message-ID: <83471b13-d179-4b8c-95ca-7534eb4c3d7f@gmx.com>
Date: Sat, 21 Mar 2026 14:20:03 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
To: Daniel J Blueman <daniel@quora.org>, Qu Wenruo <wqu@suse.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com
References: <20260319053413.14771-1-daniel@quora.org>
 <4d6f78d3-f274-43e1-adc8-c4fff4f85e24@suse.com>
 <20260320220137.GI5735@twin.jikos.cz>
 <33164dbf-ab81-4611-ba1a-e6e187bfaf51@suse.com>
 <CAMVG2stDsMQigJ4NhFH6+K+DO+OLGFHZzCk3S0KX6B9yBOU9cg@mail.gmail.com>
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
In-Reply-To: <CAMVG2stDsMQigJ4NhFH6+K+DO+OLGFHZzCk3S0KX6B9yBOU9cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8J8+v3RcXUEymBY5p88g+zt5Ek8zp51j9rDP+U2jVqCZa0JE8MP
 Fc23DVKYaLa+uW9oAprr4WU863NYpdgLd+FxCIuSfBgRLfMY3shhy5Jcrn+e7C471daZ1VG
 zYlPdbA0l4e8+C08jQsYej+R1lwpx87FsQ4/APay/LxtYwC6pEP4F9qQnEL4JpWYGE8PqUG
 I4Udefs7rEC/8QST+7TPg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/m/Rr1Mte70=;LHJ9WQzS27HIIXi9UusHs5BK5mV
 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



=E5=9C=A8 2026/3/21 13:09, Daniel J Blueman =E5=86=99=E9=81=93:
> On Sat, 21 Mar 2026 at 06:27, Qu Wenruo <wqu@suse.com> wrote:
>> =E5=9C=A8 2026/3/21 08:31, David Sterba =E5=86=99=E9=81=93:
>>> On Thu, Mar 19, 2026 at 07:26:34PM +1030, Qu Wenruo wrote:
[...]
>>
>> There is the interface, page_kasan_tag_set()/page_kasan_tag_reset(), an=
d
>> is already utilized inside MM.
>>
>> And the deeper problem is, if this is a false alert, shouldn't we fix
>> the sanitizer?
>>
>> Especially in this case I didn't see any problem accessing properly
>> allocated and physically adjacent pages.
>=20
> I agree with this, however BTRFS doesn't have multi-page folios, thus
> these pages are from different allocations; from extent_io.c:
>=20
> /* For now, we should only have single-page folios for btree inode. */
> ASSERT(folio_nr_pages(existing_folio) =3D=3D 1);
>=20
> The goal of the differing KASAN tags per allocation is to catch UAF
> and other lifecycle issues. If preferred, I can test and submit a
> patch to set the same KASAN tag in alloc_eb_folio_array()? This would
> be removed when multi-page folio support is added and is along the
> lines of:
>=20
> for (int i =3D 1; i < num_pages; i++)
>    page_kasan_tag_set(page_array[i], page_kasan_tag(page_array[0]));

That's exactly what I expect.

>=20
> It will be less minimal as won't implicitly be compiled out as per my
> previous patch.

To be honest, I think the above change is the minimal fix, as it doesn't=
=20
inject kasan code into the main loop of folio allocation.

And it will be compiled out, as page_kasan_tag_set() is no-op if neither=
=20
software nor hardware tag is selected, and I believe the compiler is=20
definitely clever enough to remove a loop with no-op in it.

Thanks,
Qu

>=20
> Thanks,
>    Dan

