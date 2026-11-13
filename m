Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794564904;
	b=bm79E66+qN9qHDcqxUv0qWfdbjBpAjnHm5KEPOF/vOAgy3gk60A4kqlLo/NraHBd2077
	 KHW/uGmVDXhiJT7/jDv93d+qK0YdxTrTCr9lVC319cRFBiub2fcVxRm6a+wbGl/Ul/sIk
	 v9WHOOxgJ6cc9hKyl8Bpzu9HPEHiMkeXhgQc5164sg7IRYoNBoneuJr60Iyx3St/JcLRE
	 fnrbvdY1T+ZMy2bxdhRGW20NsrBf1m43StrNPl8LEeI4O1V4i48gwS5ZZ9OtOFf7IEsTM
	 EubaO5XMHKajQzk3cs8oER127qJvX8s7TB5vRFgWDOnVDAPvqrBN0qNyUG7FPvI1Xlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564904;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mrxmNCREKqHgD5Bc8O/uzTH4E+BhI2TJYl4rkJ1asHo=;
	b=zeoLo8ngkIl2OFzPHUZ5QLIqeV8wYdfPI4X3WdF+Y2UzIqwa9IqYvWQMl40goYQ+SFGV
	 OmJ7iFQN1KtkJh11RU5SriPp43SwjrZH0WruDVK8Mg6wZsSpAMqQvLQ3NeRCay469/vu9
	 ytQnQ2q5z+N2LE0HXehRrLEGAUtxrz8LJWqdMLY1u/dYfcVNrgT9R9T+illPtVSShku/J
	 kLU7D/6TSVTAxnYXbVea/2SQEmpx4UXsz9e+vjhmhfdIEoDZzV2IEmyFSbsbBf33Nd5oU
	 gYQeRqC/TV3bND4Ii2CoNRLv17wsFqfdTefn/+ocdcGeSJKudmZFhD/P2WwkLo0XP+A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S3axYXfr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.42
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445D0606A894
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 10:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 445D0606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S3axYXfr
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5c102ad8420so1006351e87.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 02:15:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794564902; cv=none;
        d=google.com; s=arc-20260327;
        b=HiUPGDntANvITuRkqwavePJZ0mXYxACbKkRx/wTq2Vff+6DbZsELbbr8o5vcNfy5/g
         WkraDoBG5tj7joPr7NDzS0fKKcVrbSZFdQYiy2jqWx1tZ9VKqqJNFAANcu2HvV2AIUyH
         dgtBz9jG7owf8qfjDLrOKPhteKZvGZ0f9Y0RGwha00mK933ov3vz1t9CzJQbtHfF6dNd
         X0jN05OOpXhRqtQAB6xEbUq+Sjc26MK0TgVa3ios3I4+NSplk7sPaLrsGDx0732eVJNu
         c0MzvRpoavxQRmHDgP0ipQnM1oHVSC6VnIOHR+fqmkhej9pjGBhWTjH7Qe5W2+ZZvnhP
         XSVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mrxmNCREKqHgD5Bc8O/uzTH4E+BhI2TJYl4rkJ1asHo=;
        fh=d8gBXC+M5ObSn1w1MQ0U9IG8Y8QH3ss5FF6EXlTVkxw=;
        b=K/CxTwGe+DwUfi6MmjW7JtZL7uPMa6yFBiBiwxEgqcocAtSxJoOLkUtbkMFyBiLZId
         sx7aEOS2SNxdHpgDdMnBZFPskq5y9hjPfnDSGHNqTwn3qKHVdZVj1CdMAne3GlLmpLN9
         0rPuv89d+QAg873G/3SDKKu+KYnnywE/uAacmzfU/BA16DaK4RGrS3wVXbYWfgSyau72
         C/I+ccpS7VX3q2DW6s79u2INqjbndrth9nrdI4C8y133ypJIuWZwROzdHTDTSu1QY5cM
         3iAA2UJyND3urR8CHEvk61nKxGnVOlTs/ePu/ryqoCMJm7ccaBzNguo5ENMTaaZjVosY
         BZPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794564902; x=1795169702; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mrxmNCREKqHgD5Bc8O/uzTH4E+BhI2TJYl4rkJ1asHo=;
        b=S3axYXfrsV5j1WaK8TcfJGtHrS7zH1Kg8isIuXa7ehtvH01raWismdF74SldpnxuIU
         LemiHjykEstSDVuPYpjv5D27jaiiIAB/Wt2IbJ+yusPjW5+Nhz/x3vCCyzyfh11qy1Je
         7MpT7VfgSGcB8OkO8vIUNuJBIn1fRMWha8nlU8aUbNHSIS5EWyTUA03TapByMn5/EdVP
         C4EtdETR3+Rv0CflFsJaFlYTqh8/zHK3PytWNChIWsjEgAkp/LnNPdLzCanzWF+cUQMW
         sbHpTWPKAOObNswK7ziQmYtd6kvowGP89KSKOIhGFgBdDmR168PyFSgR/6M7JMW8EdYr
         ebZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564902; x=1795169702;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mrxmNCREKqHgD5Bc8O/uzTH4E+BhI2TJYl4rkJ1asHo=;
        b=fA3X23Fou7tevT/0F787zxJux16uzZ6qoZOr4O90PcIo2yFz5zhT10ZKA0PxE8xX3b
         mjC8oVZd1ryaVDJW8u9vEHQjCvDo/nawC7/4dtXCe2zItPyfQUkGi0Cb+81O7FO+6vy4
         EZm2tRdxEZPm8zbk3COZWqyyjCQYBMWPaPGqzSrioq/RLWG0093m/qtoOHoejYP3lP28
         tKIe+wQxH0r5rM5rVap7qaK9iPTjQD8M3X1GN1tKUfo1p2NUgkrkQXRYcIfPvshkRc+9
         w60TN3/SOpT8mWIMR7wAf6TuQr7nMKgicbevR929UdUhTyTNRF/OOvx57dNEgpf1LHt1
         63Eg==
X-Forwarded-Encrypted: i=1; AL+hErGVxe5yof4yToVaXd8x+N+vv9cIObnHRbwVry1nBUVgJ6oFariVd+NW2WAKUOqWkAgTbDlDdi5wVVxSXw==@vger.kernel.org
X-Gm-Message-State: APuU4Z/blIU89HSy2jQCPMk7+FNX+w/1g8Vp6sGCKtk0pyAWu9VEBaFq
	Y+RsE5JX7Cy/KlAvUCTSvludjrEoFX8djEW7qh3eVwINm1ciIFafDq/wIWoYJiKjzCXhuBXqUF/
	LRs40f7DF0IIv/U1MwtB2TLTNHzgIuX8=
X-Gm-Gg: AYBFou0hBng9wDQXa8CkuToBbt42zHTTL1P8EscTvSYi4g7b5uVYXht4MXuCpFe59qV
	uJTjooemRgpikKUpgXEEps0WvD0iDMvVuNirWd+dsoObPk6CR13gMaT46BprHWCE6WPVH5RL0y5
	zP4Lq08Q/AGzxfd0KXWO+k/Ngy1tn+6estxqHdG35L+0eIGnpP3YJcF0xcl3uFjLkaH3NYwyMKe
	NxFpdlnqjiRRbH1XiD0R00l3lm3J7LoeJABmEenW/vEECyke66Iek9KBh+sirM2c4NXm1dvkp3C
	nStusc+jvkNWNCfXlgk4quYxqnbpC8nDOER3U4NuXWhC3OQiZaaAC6NZ2snYjTlUQbkx2Sd0bok
	jor4IjmFy3b9/6aKvZwRfdZtDLeQ4YebBDWV1qJxj4Y+1cjENRUXHEBDY12YCeEjevgw4Rxb7v+
	Rq8VRYL8z094Gn07Jgak1+vhYXNO+XQewLCqXqCMg3577JOG1AsUlJwtM2vvzxBTm+Qe0Ubg==
X-Received: by 2002:a05:6512:1322:b0:5c0:a57:2cc5 with SMTP id
 2adb3069b0e04-5c170746417mr679199e87.3.1794564902148; Fri, 13 Nov 2026
 02:15:02 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
 <CAD=K2o8OvHTxo5o9ZNavnbzchtLqwFT2W6YiuKLMNux9qMRt6A@mail.gmail.com> <914ceff5-cce8-4716-8763-34e4e4a9b49f@fygo.io>
In-Reply-To: <914ceff5-cce8-4716-8763-34e4e4a9b49f@fygo.io>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Fri, 13 Nov 2026 11:14:49 +0100
X-Gm-Features: AclHuK8ar9fom_BLqqbtsNVeGFizdtszs0NzTlvdo7qBtLHCcBh8HcnoWL8nE-U
Message-ID: <CAD=K2o-yjUDPKJ_kFUur62z-JsXdNhT6YnEUftgtgoCZ6qG-oQ@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org, 
	David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dongjiang,

sure, I'll build your zoned-fixes-testing branch now and test it
on the same machine. Johannes, shout if you'd rather have me keep
the on-disk state untouched a bit longer - otherwise I'll mount
it once the build is done.

Thanks,
Jochen


Am Fr., 13. Nov. 2026 um 11:10 Uhr schrieb Dongjiang Zhu <zhudongjiang@fygo=
.io>:
>
> =E5=9C=A8 2026/11/10 23:08, Jochen Philipp =E5=86=99=E9=81=93:
> >
> > [...]
> >
> > Since you only tested patch 2 of Dongjiang's series: should I try
> > his full zoned-fixes-testing branch next, maybe together with
> > your fix? Or is there anything else you'd like me to collect
> > first?
>
> Hi Jochen,
>
> Could you give the full series a try?
>
> https://github.com/pdzhu/btrfs-linux/tree/zoned-fixes-testing
>
> Patch 1 of my series also addresses the conventional-zone accounting issu=
e, so there's no need to apply Johannes's fix separately.
>
> Thanks,
> Dongjiang
