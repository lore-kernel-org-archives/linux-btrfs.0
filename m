Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564602;
	b=CM30nBGcX+KXXg0MyARuCmmvXtHuyfHjbJzCzTkViqpHBUEyqYYCGhFpLQOd/4SfKg/h
	 LIo7ertHIkoLUSgvLUthmJB1okY44LSf2SV8PwAlMHtDPjlVGQM62L9f4aKx2kLwyfFTa
	 g26TYHVVWI9oYt6jvBf2ZgET/Z8wIgZV6ReKjD2fUn4MhB6haLM70ol5W0Bd8sVs45s1V
	 5cN19s3l/t+xaonY3OcXT7kAaxslgx69PRyzZ48/AHExyZ9rOno3epavtm6q443Wr/06L
	 yzpWxehCnFXoO8SrMit2pVD2wMki+b+rKt/0k5bfXRfr9mNlxhdWCthL0VjdEbDvAsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564602;
	h=DMARC-Filter:DKIM-Signature:Mime-Version:X-Lms-Return-Path:
	 X-Original-From:Subject:Message-Id:Content-Type:In-Reply-To:To:Date:
	 Received:From:Content-Transfer-Encoding:References:User-Agent:Cc;
	bh=uynRIm37wzoV6Kx2+swAeIUBoBBHcfIwqA79t/cYmnA=;
	b=TsNFfk50ZH4T/dgQqXLV5s1ej8aBCiidMuYDe2M2R8Xu0xhql5zT60/1a3q9c6pEl5/k
	 YjlNVcsjCGhq0IchL5QHT8v7/F9VcCdeju83JeFOcctkhZLNWiJ0BOKOke85X9/t+m13c
	 y9k1FYcxhU/PInhBQTSzUuZSTkLacT/8V+0oQz41r8OP6GCYQ0MHmbaGFiyN6VsLb34qC
	 1A7n44rgpW7fdN+gkqewUIkt52f/+YM3mw+IyywBs8vzu9CwUSIp9D1XrYbrcsMJiNsI/
	 XYaKPmkpNqK5UOcjEd4y/pS3m1NKuVXcbQjQ5jA0UAVIH6dp7qvaNEAMPZDd6v+5PoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Ns5ukICB;
	arc=none smtp.remote-ip=209.127.231.50
Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0AE606A331
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 10:10:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B0AE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Ns5ukICB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794564593;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uynRIm37wzoV6Kx2+swAeIUBoBBHcfIwqA79t/cYmnA=;
 b=Ns5ukICBBWkSxKiC95WNKwuSRwfMIRY4oNvqNWcYebqyDvEMoauu5NE0VY1z2monJ2X3y3
 qLwZHSTqEi1Fy7TCzKxKFWOg7eb1pyZUKaouVJSHcQSJlnydOvgREn/lmW5B0mYtziAvdn
 q9V1DfP56P1tSdgUpp0RQVVSaiWiYPuih9aAt0ELlW0YGIYMIGXPM21HUhCTKeEGTW8LEX
 VkqSWIukAwfcbF1K2LsMm/16wNx/lz1gh0U6M38oCT9W7xDbMKCT5wBBat+piwca4GOO62
 0yYDPP2m3FwzD2+z3mWog6BMJrvyODYT+oi2CfTjlRJiZf6qfIoycg/bgQK7XA==
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26af6e1f0+d0678f+vger.kernel.org+zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations for conventional zones
Message-Id: <914ceff5-cce8-4716-8763-34e4e4a9b49f@fygo.io>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAD=K2o8OvHTxo5o9ZNavnbzchtLqwFT2W6YiuKLMNux9qMRt6A@mail.gmail.com>
To: "Jochen Philipp" <a2jphilipp@gmail.com>, 
	"Johannes Thumshirn" <johannes.thumshirn@wdc.com>
Date: Fri, 13 Nov 2026 18:09:48 +0800
Received: from [192.168.8.64] ([183.34.170.77]) by smtp.larksuite.com with ESMTPS; Fri, 13 Nov 2026 10:09:52 +0000
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Content-Transfer-Encoding: quoted-printable
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com> <CAD=K2o8OvHTxo5o9ZNavnbzchtLqwFT2W6YiuKLMNux9qMRt6A@mail.gmail.com>
User-Agent: Mozilla Thunderbird
Cc: <linux-btrfs@vger.kernel.org>, "David Sterba" <dsterba@suse.com>, 
	"Naohiro Aota" <naohiro.aota@wdc.com>

=E5=9C=A8 2026/11/10 23:08, Jochen Philipp =E5=86=99=E9=81=93:
>=20
> [...]
>=20
> Since you only tested patch 2 of Dongjiang's series: should I try
> his full zoned-fixes-testing branch next, maybe together with
> your fix? Or is there anything else you'd like me to collect
> first?

Hi Jochen,

Could you give the full series a try?

https://github.com/pdzhu/btrfs-linux/tree/zoned-fixes-testing

Patch 1 of my series also addresses the conventional-zone accounting issue,=
 so there's no need to apply Johannes's fix separately.

Thanks,
Dongjiang
