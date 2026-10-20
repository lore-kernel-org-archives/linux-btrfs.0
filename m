Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792534628;
	b=H0izfvxd2FUvuZRuibynBeYT08KZU7hWJKhIFRqUvwcXd/fXg40aeh2DN/wiPTUHkmDI
	 JL+i+L1WI+BH/rMw7Hk+w6zG/68prZWz6Hs3oorIiU18I/PGB0+pOHautGudvCn0FRNBU
	 k75rPoTRIxqQlhk1PRRLYDsTfPlp5aHgBskWqS3UNgHwVVQNuHSYWPqPZte2faqm/tKqR
	 UZHIo4PtEnH+9bc+Nr4zmKLSeENW1MZulQl1+qkpwPa9J5hPMZ9XMAKLm6ezQl98Lmgrx
	 OskYN4Z1Nov9nAoC+gWFh5UWYuj+hLs04QZ0Gcd97drq7KAvhOBfjZYxr9dhC5KX8AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792534628;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Provags-ID:
	 X-Spam-Flag:UI-OutboundReport;
	bh=16tFVmM53OaoNwQf+zCM7lnpY1/NXXf0vRTBfXXsgXQ=;
	b=kJAY8fpkSkZGLt1+vQcCr8/U8bFknXs3LQMaJmda1wg/7Uzxl2pOHQLsk3L7TYqYS+mT
	 Htv2yPqD/x0V3WVUuNtE+9JtM3qtgTZHlnTDJvj/ptNqaT+qiaRipd7ZrkjjGwNdwDBle
	 Vj8wXxcZzUd43FdRkyMNQPDRQMuIiomMarh1fcRvxv0D4DTMcSTBlZmEsA4afPrs7H3fQ
	 +7zooQ7EisrrOZTXmMn82oqxIjL8fb9ZUlQycMKmDmA6AlH7w2c43axKCvSirHld3nSOM
	 Ft7GFXv9007kN/1cxHb+k/O74tYRUo6atoxikl8mVtmcD/Wj1XV/WOyakmWB5ljZyig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=uCa4OKm6;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96897606A31A
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 22:17:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96897606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=uCa4OKm6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792534622; x=1793139422; i=quwenruo.btrfs@gmx.com;
	bh=16tFVmM53OaoNwQf+zCM7lnpY1/NXXf0vRTBfXXsgXQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uCa4OKm6Njx2NaN5Nd5sHNdRzLwFOMfG/e2vP0/JMwJfTsOqp7yQuMcPl3NkaAIL
	 w5xOU8UrMSE5aSzEVDdEBKQ0FoNnAQuclqb4Ela70UKvaepe/neaZ0qn6zvWUgDPK
	 ZpdFpY1Fc0Fagh0A/uR+T06OuFY2xzt6fUajehnhdh97JFoZCszF0mKfJO3KBfqMx
	 rjkMLL0PHLagy9Yp15jkrlGKqh8ddgBDyT1/veGzrAScl9Y/45QJzWjecuHNrtoXJ
	 M7UbA5f7DXw74YcZeIGTWTY9NolySJBnKK2srwWGW5zJWWx1G60E33LCqWIzVsRJF
	 9/kgLIUhKDbWUP4ANw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M3lc9-1xITC23KiZ-009odT; Wed, 21
 Oct 2026 00:17:02 +0200
Message-ID: <8376153b-33cb-4ba0-abba-a4fdfdd93ec1@gmx.com>
Date: Wed, 21 Oct 2026 08:46:58 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] btrfs: convert zoned.c to use map->stripe_len
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo
 <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
 <5b7b68cf9d8a6ccfb89b78939507146c3f52652f.1792391732.git.wqu@suse.com>
 <6bbc56c2-7853-408b-a5f1-7ae0de8b1444@wdc.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <6bbc56c2-7853-408b-a5f1-7ae0de8b1444@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qIYzy5mp74CVQRql1j6oa1/r7msL1eUSlEpj3yqFkMVSRZDlJxE
 1pJao05yC7NB+NyLc3nf2eM+mhA0vvEJ0MC5UNbhrxQUIwyJ+lygPPzSTca/1S4GidqB00b
 Ozu70oT+2wVFAdphqksQZYOSjV0RqjL3ePvtn5/Ou/LTy94uySUn11hulb8x4T/hVFCQLJ1
 gidiFTJExxgQk4pAIGZhw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:F5gdCmlNNbs=;7ZEYbL/VL72iqkb1+JJeKvw2i+j
 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
 H8kAglQ3vV4Yn2ge1EGYjqUT5b9wyf3zRX3jLU=



=E5=9C=A8 2026/10/20 21:37, Johannes Thumshirn =E5=86=99=E9=81=93:
> On 19.10.26 08:40, Qu Wenruo wrote:
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (zone_info[i].alloc_offs=
et & BTRFS_STRIPE_LEN_MASK)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (zone_info[i].alloc_offs=
et & (stripe_len - 1))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 break;
>=20
> I think this would be a good opportunity for using IS_ALIGNED() here.

That's a good idea, I'll also update similar callsites in the series.

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe_nr =3D 0;
>> @@ -1619,8 +1621,8 @@ static int btrfs_load_block_group_raid0(struct=20
>> btrfs_block_group *bg,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (last_alloc) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 factor =3D m=
ap->num_stripes;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe_nr =3D last_alloc >>=
 BTRFS_STRIPE_LEN_SHIFT;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe_offset =3D last_allo=
c & BTRFS_STRIPE_LEN_MASK;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe_nr =3D last_alloc >>=
 stripe_shift;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe_offset =3D last_allo=
c & (stripe_len - 1);
>>
> And ALIGN()?

ALIGN() is round_up(), which doesn't seem to fit here.

And considering IS_ALIGNED() is also using "(a) - 1" as the mask, I=20
don't think there is a better way to generate a mask.

Thanks,
Qu
