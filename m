Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8936222590;
	Thu, 16 Jul 2026 22:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240980; cv=none; b=awNeF73rF/xjn4lOYqJT8CPwcQl4hTljnYoeye/KoPT9FILSQAf8Ql8VqMRZMr2VbEHRYMMIxAI6mzHs5i+nbk1Qn8g1rGAWefUHm2LZ2Zrh9qC3PExdfGI2wCTbpirSMB+5sg4MdGvOHH2hcpQMm9BGXYL9gM7MLiTb6KvIN60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240980; c=relaxed/simple;
	bh=sIOgjUHXo4Ys2SsGm/2XEIS/NrzaJ6LtAZgD5ThS2PU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZ4snI9ntX9Icy2vU2U3lnA8tLKic7mcwPhREQ34GXxgy5NJK/CUJIIkizrM2LaUmzJcWoPKE629ChCRl64vhM6cRF6mANW4YLGSqp7M4TMEptLR3Ww8oxars8/+T/N8F1LJKiHeXc6w46ZrFspgLAPiT72NUDlhmILNM38qCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=kFuCPdWb; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="kFuCPdWb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784240972; x=1784845772; i=quwenruo.btrfs@gmx.com;
	bh=3mqNUWF5337paPweqp1aqJHaHTx3FV/vi0pHLiAOlws=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kFuCPdWbTQrlXD/ft94uQpUgVjFWInDwVoOAs8nB+MLUkjB7U/+ffppHRZnTjBvZ
	 HfP0xpr8w3NHA/mQQ1xh5gfmipD5p9kSF1NQbwjIeFf+eNDsUo5Hmcr2+du5I1mzU
	 WdK0TekSCKl/A5gnr3t40fr8dx7a7HX+m46pOb9PuRyTqhzvDyMySFWLGvV5WwNNq
	 OAmelubhGMA/s1BGEd7ZeQ4rDF2zPyqQGaKHFO8Eanf1b41cKwwjuNNgrry8nf1SJ
	 XCLXFpFVAWY5QTsIy3tMEY9N81Va/zqD+az5SxGA7s57ervDHDJ1TcxLnZWTAymL1
	 StcR98AzhH4fNDSWag==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZTqW-1wYtSf46xq-00Hg5F; Fri, 17
 Jul 2026 00:29:32 +0200
Message-ID: <79884bc0-1a2c-4e34-b8c7-75292f3466f6@gmx.com>
Date: Fri, 17 Jul 2026 07:59:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: raid56: fix inverted bio-list check in scrub read
 assembly
To: Mykola Lysenko <nickolay.lysenko@gmail.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, wqu@suse.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260716174511.8738-1-nickolay.lysenko@gmail.com>
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
In-Reply-To: <20260716174511.8738-1-nickolay.lysenko@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:b2e3kDCxDD66f0n+dpM/VItp8d10vxN/slHngHbtnSQi3wEZ0ES
 VryN5YENxKPfBc9BDk4EAZnHmBNyKhmJ696Zesj1mJFGhrX9OpQUEmB25maqlqGT9SdA7VM
 2TnxKMQx448z5kOqoDTdOPIXVmB0DPKPoKwGQZbsRqPcBzaggmyCc485hm1SxuyB4mBkxxq
 ZwUsa+hNDI5hU5Wk1OmEQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZgAOqQSy8Pc=;dUq8AHHDDwHVSezy4oMW00g4Xgf
 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



=E5=9C=A8 2026/7/17 03:15, Mykola Lysenko =E5=86=99=E9=81=93:
> Commit 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
> converted the bio-list membership checks from sector pointers to
> physical addresses.  The two conversions in rmw_assemble_write_bios()
> kept their polarity (skip the sector when it is NOT in the bio list,
> i.e. when there is nothing to write), but scrub_assemble_read_bios()
> has the opposite polarity -- skip the sector when it IS in the bio
> list, because then there is nothing to read -- and the conversion
> flipped it:
>=20
> 	-	sector =3D sector_in_rbio(rbio, stripe, sectornr, 1);
> 	-	if (sector)
> 	+	paddr =3D sector_paddr_in_rbio(rbio, stripe, sectornr, 1);
> 	+	if (paddr =3D=3D INVALID_PADDR)
> 			continue;
>=20
> Since a parity-scrub rbio's bio list only holds the empty completion
> bio, the result is that scrub_assemble_read_bios() submits no reads at
> all.

Then you should remove the check completely, and replace it with an=20
ASSERT() to make sure scrub should not have any bio sectors, aka,=20
rbio->bio_paddrs[] are all INVALID_PADDR, or all bios (should be one) in=
=20
the bio_list are empty.

Otherwise the analyze looks good to me.

> finish_parity_scrub() then compares the parity it computes from
> the (cached, correct) data stripes against whatever happens to be in
> the freshly allocated, uninitialized stripe pages:
>=20
>    - if the garbage differs from the computed parity, the sector is
>      "repaired" and written back -- accidentally producing the correct
>      on-disk result;
>    - if a recycled page happens to still hold the old (correct) parity
>      content, the sector is deemed clean, dropped from dbitmap, and the
>      actually-corrupt on-disk parity is left in place -- silently, with
>      every scrub error counter reading zero.

Unfortunately that's by design, as scrub never reports P/Q corruptions=20
since there is no counter for them, and there is no space left for=20
expansion either.

>=20
> The second case is intermittent because it depends on page-allocator
> recycling.  Observed with fstests btrfs/297 (raid5, 2 devices): the
> corrupted P stripe intermittently stays corrupt after a scrub that
> reports no errors -- roughly 1/10 runs on x86-64 KVM and up to 7/8 on
> a UML build whose timing favors page reuse. Instrumentation of
> verify_one_parity_step() showed the "on disk" bytes never matching the
> device content (stale 0xaa / zeroed pages instead of the injected
> 0xff), and after this fix the injected corruption is read, detected
> and repaired in every run (8/8 UML, 10/10 KVM).
>=20
> Fixes: 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
> CC: stable@vger.kernel.org # 7.1+
> Signed-off-by: Mykola Lysenko <nickolay.lysenko@gmail.com>
> ---
> Note 1: I found, reproduced and created a fix for this problem using AI
> tools

Not sure if we still require the disclosure of AI usage using=20
Assisted-by: tag, but I'd prefer that to be extra clear.

Thanks,
Qu

>=20
> Note 2: I am referencing UML (User-Mode Linux) above which is coming
> from the project https://github.com/mykola-lysenko/btrfs-uml-fstests/ to
> run xfstests in the UML. For reference only.
>=20
>   fs/btrfs/raid56.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 00a01b97cc..93de764d70 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2910,11 +2910,11 @@ static int scrub_assemble_read_bios(struct btrfs=
_raid_bio *rbio)
>  =20
>   		/*
>   		 * We want to find all the sectors missing from the rbio and
> -		 * read them from the disk. If sector_paddr_in_rbio() finds a sector
> -		 * in the bio list we don't need to read it off the stripe.
> +		 * read them from the disk. If sector_paddrs_in_rbio() finds a
> +		 * sector in the bio list we don't need to read it off the
> +		 * stripe.
>   		 */
> -		paddrs =3D sector_paddrs_in_rbio(rbio, stripe, sectornr, 1);
> -		if (paddrs =3D=3D NULL)
> +		if (sector_paddrs_in_rbio(rbio, stripe, sectornr, 1))
>   			continue;
>  =20
>   		paddrs =3D rbio_stripe_paddrs(rbio, stripe, sectornr);

