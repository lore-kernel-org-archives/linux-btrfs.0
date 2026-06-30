Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9952C15BE
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 01:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782784328; cv=none; b=CmvuBnMm2EYgyitMjVSmonGfPu18xBKZJetGKThpP1vhZ5OdEIk75CaAACPzYEsDXBSxkzDYCKA90RKp1yJdgbsGJSLjksLDwlfdHSQ/RPnev6kjeXVaoKNP4k4sWhxPq4x0ABsxcrAWs1jUqNVN/kFJw/zQXnuySiHskaRcLi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782784328; c=relaxed/simple;
	bh=hsy2WoW6OghjvL7I3GyBPNZKwqMUFtZdwcbUqC3w6RU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVH5xtlBMDDsJG8oFloxUxg8Ba282uj/eLMiCJcKmFIp67T+a/8p3Ha66obqneQkH5i/uKBjcRCdSAqV6mjuwZareeHvVvtZes6/FlHGQPc4UtQ2t3so7/bvc2myrTQnwYcskHQ1e0FHjdkPaejtNmLU+Ep/M6nbygCNVMovHzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cWSS8Jvl; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cWSS8Jvl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782784324; x=1783389124; i=quwenruo.btrfs@gmx.com;
	bh=Je6mqdjvMDWrevDqAXsY29vVaX6XJRsn29mU3eVxYCE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cWSS8JvlntnNXr/Qr348X0uhU7PpatGSMItYTvT6uSM3z2tvFjhToQvH1yRqYUmQ
	 9MvuYuL926yxx32uONuuJzzivXJ4OcJf3p0PKdMjd4veBGBVa1oBIGbtB6vUu6vUR
	 1WFUiStvBMFX32dJVa02fHKGWNLIDt5NA8RBb76noFWs6qdBpNF8YlRmuYU2VDRzG
	 x85GlXNr8hfFNOazTnMsTVR7hqh4nLme3DY3BTnTn6cS3hQ35XAi2AEEoxZSlhyZp
	 vAjYLEzjIu7lNgiXhFR87WutKJFeLiWwwFtgTPIWaMYRm5eO4hh+x8LSs8Rh6NdbL
	 9wdLWIspqSsAwWkOxA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MORAa-1wU229499i-00VSzp; Tue, 30
 Jun 2026 03:52:04 +0200
Message-ID: <b236c537-5a8f-4454-ac0e-10b9d2e532b8@gmx.com>
Date: Tue, 30 Jun 2026 11:22:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] btrfs: use kvmalloc() for stripe buffer of
 scrub_stripe
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1782725129.git.wqu@suse.com>
 <8699b1f1eca9140ba234ece0fbf4e80148d914ba.1782725129.git.wqu@suse.com>
 <20260630010556.GD2398896@twin.jikos.cz>
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
In-Reply-To: <20260630010556.GD2398896@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mjuEC9QTdRjR/kba7kQhCdRqbGBLn50DX6QktqahQDX9Xv0JWkt
 x2Ak5xcx8TyUROhTOO3LSwrS2ilyp60BtUKSHbqQc0B1kXrNQaW8/rHMIZX3eq97YATTz/a
 T3HT7qRqAu/l8sX9ESyiajysQ6m5lpAiYipEP3zDx0xdfUP4I156KtcFv7Km7zsloBfpLvz
 3+56+GbD2Q59em5uzGf/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KNmsld9sb5M=;zP6186bUfUZs80h19jZkWNen1vA
 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



=E5=9C=A8 2026/6/30 10:35, David Sterba =E5=86=99=E9=81=93:
> On Mon, Jun 29, 2026 at 06:55:53PM +0930, Qu Wenruo wrote:
>> Currently we're using scrub_stripe::folios[] to store all contents of a
>> stripe.
>>
>> This means we need all the extra work to handle things like sub-page
>> cases, and also require larger folios to handle bs > ps cases.
>>
>> On the other hand, it's not hard to allocate a 64K large folio to cover
>> the full stripe, getting rid of the cross-page handling.
>>
>> Furthermore, even if that large folio allocation failed, we can still
>> use vmalloc() to allocate a virtually contiguous space and still get ri=
d
>> of cross-page handling.
>>
>> This patch will go with kvmalloc() to allocate 64K of memory for
>> the stripe buffer, thus getting rid of all the complex cross-page
>> handling.
>>
>> The following aspects can be greatly simplified:
>=20
> I think the trade off using the virtual mappings is justified, the code
> is indeed simplified.
>=20
>> @@ -332,13 +333,10 @@ static void release_scrub_stripe(struct scrub_str=
ipe *stripe)
>>   	if (!stripe)
>>   		return;
>>  =20
>> -	for (int i =3D 0; i < SCRUB_STRIPE_MAX_FOLIOS; i++) {
>> -		if (stripe->folios[i])
>> -			folio_put(stripe->folios[i]);
>> -		stripe->folios[i] =3D NULL;
>> -	}
>> +	kvfree(stripe->buffer);
>=20
> The life time of the stripe->buffer matches the scrub life time so we
> won't be allocating and freeing the page repeatedly.
>=20
>>   	kfree(stripe->sectors);
>>   	kfree(stripe->csums);
>> +	stripe->buffer =3D NULL;
>>   	stripe->sectors =3D NULL;
>>   	stripe->csums =3D NULL;
>>   	stripe->sctx =3D NULL;
>=20
>> @@ -840,8 +805,10 @@ static void scrub_verify_one_sector(struct scrub_s=
tripe *stripe, int sector_nr)
>>   		return;
>>   	}
>>  =20
>> -	ret =3D btrfs_check_block_csum(fs_info, paddr, csum_buf, sector->csum=
);
>> -	if (ret < 0) {
>> +	scrub_calc_vaddr_csum(fs_info,
>> +			      stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
>> +			      fs_info->sectorsize, csum_buf);
>> +	if (memcmp(csum_buf, sector->csum, fs_info->csum_size)) {
>=20
> Please use the if (memcmp(...) !=3D 0) form
>=20
>> @@ -891,6 +868,10 @@ static void scrub_repair_read_endio(struct btrfs_b=
io *bbio)
>>  =20
>>   	ASSERT(sector_nr < stripe->nr_sectors);
>>  =20
>> +	if (is_vmalloc_addr(stripe->buffer))
>> +		invalidate_kernel_vmap_range(
>> +			stripe->buffer + (sector_nr << fs_info->sectorsize_bits),
>> +			bio_size);
>=20
> This is done twice so may not require a helper but it's quite important
> for the virtual mappings, so a comment making it explicit that read side
> must do the invalidation would be good.

I can refactor the code so that scrub_repair_read_endio() and=20
scrub_read_endio() share a common function, only diff handling after the=
=20
bio is put.

In that case, we can easily add a common for the shared path code.

Thanks,
Qu

>=20
> Alternatively I was thinking about naming like "btrfs_invalidate_range_b=
efore_read"
> but a comment would be more clear, also we'd need to pass 2 more
> variables.
>=20
> Otherwise, I went through this patch a few times and haven't spotted
> anything suspicious.
>=20

