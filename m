Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819417;
	b=oF9MljniGZUm+4DV3ZFIMViES2UmYXhHKHEyfBUnYROrN5Kfo5rzRln3xMjghhyFjJ+k
	 PmbsdFsEEy57h6ueaCgxKF3etX39fdmBz7Sw33lyC7iOMt2f0yHoJ/NAwfUIdiJ7jAWTC
	 GqrmlObtqDaO9dSR9+uQe3Zfa0ii8Pr5oL8o51UoPqdpA5Os6Ll+MSlS77NWuEG1FuPUI
	 6cjNnotfx4MCwERN2mtBJwWGsABCIjEY9nM0yvbD48INXFeGMabzRw3ANxsFxdte3nbJq
	 VuHcYVtvOlVoGTpd2DvVbzYpphFSOBOJ1DyondD+9BR/5CRpFyGXZSMy7uLNWMeaDBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819417;
	h=DMARC-Filter:DKIM-Signature:Cc:User-Agent:References:In-Reply-To:To:
	 Subject:Received:Date:Mime-Version:Content-Type:X-Lms-Return-Path:
	 X-Original-From:From:Message-Id:Content-Transfer-Encoding;
	bh=qMN6Gy99ku6X7bmf1HLvDwK1SCbZB7fU4lGsGsyiAE8=;
	b=YRb5zHjikVHaWZOAHaezsLcZS3T7y9C+fRFY9lffY+yZXkqyVFq4GvDDQ+kAkbQATkob
	 pEoKZpUOP5w+C3A/6T1rVZpg4lgroaah6s/RYespIQBcarEd6fCcAdYzcFFvCN8UHTzk+
	 uHrvJLz8vwVjPJzCn98HkJeufi/2QilgBG3NSoHm3lTJFu27zQ//3cexKbnBaaxmCmuni
	 9nOkmQgs2ljaPNmsvImVtdXOeg3C5dONPRJve/SagbD3VVQ4W9hIGN4jxENnHvbBDbLFm
	 rZDMzy+tuaUAED5oWnB7xhDRniXJgE6AjiCPzAu0RIoMXfN4WrOXIubRdbTXxpbAP+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=LaFVMLUr;
	arc=none smtp.remote-ip=209.127.231.51
Received: from va-2-51.ptr.blmpb.com (va-2-51.ptr.blmpb.com [209.127.231.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01A9606A31C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 08:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F01A9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=LaFVMLUr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794819409;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=qMN6Gy99ku6X7bmf1HLvDwK1SCbZB7fU4lGsGsyiAE8=;
 b=LaFVMLUrlcQel/QYGB9DJHR8e0Gy1Bd4QzmJCK570+TZV32J0J5bQl6G1c2cS4XTmln3pg
 M8ODQ6sMxErBJr5BOcVoy7I15S7c6EuJZwWvlsYHVWBUZ157gBPXRZQ3RGJWefX3SHxZHZ
 IdYNWbuizUktTFFFO6iwENhPPG3dB+XvTSeYh3TPeteEzx3XF9/FuRneUxZKJQ432Drxtx
 +Gebu3MErc4mygLHBtDkVsJNPqkhRxFNJhClyOzv3FiNOzIB04esBdYc6ZAyaYP4hmiMa7
 f1jhtSpkZDwlXezXGM1c5Poio+hFfvoYgLbzOAZFY6JCpfZL2F1+Z+HgbrGZEw==
Cc: <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>, 
	<naohiro.aota@wdc.com>
User-Agent: Mozilla Thunderbird
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com> <e3261fe5-4b98-47e6-ae66-d4af05caa621@gmail.com> <CAD=K2o8W085XSBeTYXjvaTRxgnx6y0_fVrNRH18-At=EUtWOUg@mail.gmail.com> <18ce5468-92c5-4247-aad0-bbea25d8ef70@wdc.com>
In-Reply-To: <18ce5468-92c5-4247-aad0-bbea25d8ef70@wdc.com>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>, 
	"Jochen Philipp" <a2jphilipp@gmail.com>, 
	=?utf-8?q?Martin_=C5=A0koda?= <mar.skoda@gmail.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations for conventional zones
Received: from [192.168.8.64] ([183.34.162.5]) by smtp.larksuite.com with ESMTPS; Mon, 16 Nov 2026 08:56:48 +0000
Date: Mon, 16 Nov 2026 16:56:41 +0800
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26afac551+73b858+vger.kernel.org+zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <80ecdc9f-9604-4314-ae26-4d6a879671ad@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/11/16 14:59, Johannes Thumshirn =E5=86=99=E9=81=93:
> On 11/13/26 6:13 PM, Jochen Philipp wrote:
>> Hi all,
>>
>> results of the larger write test with Dongjiang's
>> zoned-fixes-testing branch (7.4.0-rc1-zhu+, untainted):
>>
>> - ~2.3 TB written via rsync in ~3 hours (~200 MB/s), fs now
>> =C2=A0=C2=A0 holds 6.7 TB total (the first abort back in October happene=
d
>> =C2=A0=C2=A0 at ~4.3 TB written)
>> - no btrfs messages at all during the run
>> - closed zones: still 5 after the run (124 before the first
>> =C2=A0=C2=A0 mount with this branch, 128 on the broken fs)
>> - clean unmount, no "unable to release extent buffer" warnings
>> - btrfs check --readonly: no error found
>> - mounted again, stays rw
>>
>> So for me the series fixes both the broken on-disk state and the
>> problem itself. If it helps, feel free to add:
>>
>> Tested-by: Jochen Philipp <a2jphilipp@gmail.com>
>>
>> Johannes, I'm happy to test your patches as well once they're
>> out.
>=20
> This sound very good.=C2=A0 Martin, can you also test Dongjiang's patches=
?
>=20
> Dongjiang can you resend the patches in your branch?

Hi Jochen, Johannes,

Jochen, thank you very much for all your testing!

Johannes, sure. I'll get the patches ready and send out v4 soon.

Thanks,
Dongjiang
