Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E5524F;
	Fri,  5 Jun 2026 04:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780633434; cv=none; b=ZEKL7z5GB5G5ED+chwAwE1S3RR3VWLVKsxs7gRr+bvWzSO+FI4C9T8xo0pIbOX0waEzC+03B8hnJO3ZTQw6Co+Uu+R7BqsDY9IpTXqJ3MpBljao9S3hGSfYzfisZSRVa/C5Ok6Ry1asxZM0Xu2/AVvQCbP1N2kV2Br56xCUj4q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780633434; c=relaxed/simple;
	bh=SD8aG0DNiisn4JcnIEsxoQpbwDjMoBR83EfqwWY8BSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLyAKiSS3RJttrJCczAFm+mZn3Rz8dNoOZ26Tu3p+rNNsyMWj77DBamn8IAWGUXV0p5Ep22051FAzz3ShbyuTRm9Ct+XOgjworFi/72xkQ8tuFDPxZXK1M33Btu9aJSO1xScVR9Pt2vKMMBjnhhvrsnOQ1JRKxczEMiUDNVTvt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=jgjGywv+; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="jgjGywv+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780633417; x=1781238217; i=quwenruo.btrfs@gmx.com;
	bh=lK/G1rY1bFoKoKbXsyRi9BR24YLUx/Fp2rvv9dM/o9Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jgjGywv+r5PpD31Iz3NRJTuVy/2CSkAnp3/99fPo80DrXM0JGUzzP7ydcsCKQSHu
	 q6FYgtIiDAXabhxycyqGiEAzZU5ilRHPfavNflQzv0lEiVpSA9jWMobZRI/BmIIHr
	 H/swRenBUurBO6JxC+d1oaQ4RqgcMT4FtgfxCvTMvR84qojUm63W/zF8eW4aI+4+q
	 P+ninaZ7w69X7S84/DWZEMxMucDCvkuP6EuluPl7EHAFiL2TB9yK4lSkx3+nypa3X
	 ARc1OLKGluHA98FMLNkGClzcZSFaCMvjROWJfwlWu5mK+wc0sOaFDQOgMb4ulwfQp
	 a7WaUU6MBL3UYe+8lA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MF3HU-1wTCNM1Wa8-000sWh; Fri, 05
 Jun 2026 06:23:37 +0200
Message-ID: <a6cf8da9-9fe6-4338-a130-13c1a475e9f9@gmx.com>
Date: Fri, 5 Jun 2026 13:53:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use -f by default for mkfs as xfs/extN do
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 linux-btrfs@vger.kernel.org
References: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
 <aiJL1CBTV_N4YAtb@infradead.org>
 <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
 <aiJN5l0UqOA9lY5_@infradead.org>
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
In-Reply-To: <aiJN5l0UqOA9lY5_@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O8S2FKLM5YSEsqPL8S9g/f9+yN5v6e9IW8U5TnG5HQ/CEm90/ar
 PSQM+VfjXwSFeq13NvtCPWVyZYyZ6NpVbwpa35exNiLsTg/HYJLkG4Co6p+UXzzQLNGYxFU
 hLdGs6r/aLpRBRpu0QznzUuZ2F/TSEvepTDp83l6jGm/LQZSI0twzR/ecRkS2MRvhiRBAJ4
 IhPXhfV69XtvbmEQyb79Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:EhhEaxQx2A8=;xYVyi3JsLg2wI+8ya7IQiSsAbsm
 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



=E5=9C=A8 2026/6/5 13:47, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Jun 05, 2026 at 01:44:02PM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/6/5 13:38, Christoph Hellwig =E5=86=99=E9=81=93:
>>> On Tue, Jun 02, 2026 at 10:47:39PM -0500, Eric Sandeen wrote:
>>>> Recently saw a case where testing ext4, xfs, then btrfs failed all
>>>> btrfs tests because mkfs.btrfs refused to overwrite the left-over
>>>> xfs filesystem on $SCRATCH_DEV.
>>>>
>>>> This seems well-enough fixed by only making the change to _scratch_mk=
fs,
>>>> but several other helper functions explicitly use -f / -F for xfs
>>>> and extN, so I've updated them for btrfs as well.
>>>
>>> I haven't run into this yet, but it seem like btrfs needs this.
>>> But maybe you should also Cc the btrfs list?
>>
>> This is the wrong fix.
>>
>> It's caused by a mkfs.btrfs help string output change, and it's properl=
y
>> fixed by this patch which is already merged for a while:
>>
>> https://lore.kernel.org/linux-btrfs/20260510001704.68396-1-wqu@suse.com=
/
>=20
> In other words: we already get -f, but it got broken recently.  That
> explains why things always worked for me.

Hey, this shows you're running on a proper server distro, not some=20
rolling bleeding edge one :)

And thanks for CCing the btrfs list.

>=20
> I took me a bit to reverse-engineers this from your answer :)
>=20
>=20

