Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E4A3932DD
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 04:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773289648; cv=pass; b=t+C2TG92BJJhwnnO6uZjo8YfKqZEWbD6DIe475Rfs5DILtZheFMAx6FujfLSAWMPsDEpciXGK/bWpv322wrNEFUimRzr6fRuzjnI1rp5plSEeFFeWK7x8dq3eJNVI0E260hQaHObIWinrwRJ6AtNJeo8K9gPylBCy4G27XmngTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773289648; c=relaxed/simple;
	bh=bgS08NV15zpqEb1qjiuZmr0KhTZ/0NDHrKoU1TsnW1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JiIxLj676f/6yiLMnSZYrp8M+2SkXyWv8toCsjX+a6W14NC+6Ewh05DYWvHRXX/ANf/G+eU6cJeGbyWh94bteidasaAtOJDpEaFsVgJYWQYtT86lW4uL01Qv5XcETGCMz2nhjFl/XWSNA5t5xzd5TSv2T8GVRlZKlwohPp3+Q9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KeicoiGK; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KeicoiGK"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b9358dd7f79so82129766b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 21:27:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773289645; cv=none;
        d=google.com; s=arc-20240605;
        b=YwHczLyCAqCo8jejxacnRcZz7IycTuvBC77OsDCngjuqxC4nFNji3NO0pPeL/a2EC7
         axdG4UhBlfDTrQCW4J1HXD5WQ5kZKyJL5uHNl9AexkvMXU8UlzZ5h+LoxdKAseqsnI33
         dkp0z4Un7X0nB2mRDu44FVs1HNoxjk1fj+/5RodPbymv14i/iEXb7IWW0b6cBz/ka5bY
         9e4wr4my6fdZ3gJ6yuKsXfKYM7Jsg4sy4x0LOEwBgQOFlGiUbmxpbpkWKnGAB16TiG4e
         ehy6COoAlwsKBKOvN/8XJ+7b8dbwv1qRz5SD8NJD58w8bdfn6PulVTvgroXj7vr/fe0k
         5jbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bgS08NV15zpqEb1qjiuZmr0KhTZ/0NDHrKoU1TsnW1A=;
        fh=lYJQ96ZSlXbVw9QhmBFdmHqZAD7Hwtza3GZNfoDCZoo=;
        b=KTDYXXLy06PzRbUS5VPqSjthHNKW/jUQyTfKCsIWLozp2hF4Rn9lW/J6osm1/EHLaP
         uRbZMTVSo1MCykBk2wnsr4I57WEdKzktMgY2XeQkaDyqx1AyLee1LccLROGdyNN4JO6+
         1Ws4Gr5sJ5HVW/T7CRy7eK0/kCIh0NidaXVX/x7AU7IJUXOJhdof0yIzqxT9jFb9v1os
         jLZoDnNLlTj3otBxzTvGdPKeiorGEviHnxp9acPpq3kbrLkm4DJbcD9bylI7JFLHH9M7
         MIVKtq14ezea0X+7EWqeuPqX5xtknpE8OXgMnd1meueHtdeaBInoGkbTlBKow3MtVxNy
         oBTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773289645; x=1773894445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgS08NV15zpqEb1qjiuZmr0KhTZ/0NDHrKoU1TsnW1A=;
        b=KeicoiGKpEZdRfNJcAbq8cbUWTId8t2ZmUqH2AL4y6UEvfmQhi9cGwb2DeTSbkqu77
         O6p2qO113NhGpwaIAzJ5RBXj98blMpOcn358OViR1Lo7ExojLHTbWQGfoWXHFFouBlC4
         8vyJGRTOM1aRN3nlMMHe7lmQicgldvysJVxbW593PhfNvcnUbOLGjORZp2D7YBPLbzIu
         hE4snT8UEbAD6uMtgfwkwwu5E8bBkRNUsIfC5VUR82hgoCipddhLsil/EbS3kU2Z/25S
         OZ/yDf/1GZPp+5WHygIEK8dR3kQiMXjMwQYUDbTpq4S2KYdOoND/TS+CXkyEIO5aidlN
         mGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773289645; x=1773894445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bgS08NV15zpqEb1qjiuZmr0KhTZ/0NDHrKoU1TsnW1A=;
        b=hfkQmUFn6jzikagheNJeWPFRkPDo7Su0SrEPS4sgdl63CiU76IJpHMVeWGqqrXhFYL
         YUQHTA4B14ouKBpNbbr/5s8Z39Iorr4rVJFX8PODGdYvz9HfHlwpkMXWAFG539hrbQyG
         Bto/IOXfXqtot2CZdRiT3Fbsi8wQw5JdTBCb24W2u2crvingmuh4Sm9d+T7dLsqSI9aE
         lS7sDwE+8vLwqLRA2Nd9dohrUR9+JPyTgAuD5NTt0UGNV9bgE1WCAGkwM2oJcDbADg2k
         Cwc3JjBiUG5dsa3CAQYTUIOHUGls7rkuKuIv1cLRAPliP8MGaWUGSTXuzrdeXJuFuI99
         lk/w==
X-Forwarded-Encrypted: i=1; AJvYcCW77jrVoYdvc66rsfRw0XZZK5npIkxeIgxFskm/OLYZVKgMa8I9zFFgYWuZja94yrraBPk72/+vgbBmVw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5n++w+QbBYCe109KryyWPW/u56Rl2SguptcKfU2d2glqyoYsS
	ZOPE0fwG/7pMMaw3F2JO5k7fuYIT3/qcvuMhTcI33/ngJ3SMpO/GER4y2fdTeyUph9sfUWCyxmr
	SDNtSdnEW3aAsvBeSbsLIuXjIf9ham4c=
X-Gm-Gg: ATEYQzzIbeaNWue7FxpAfMjRb2ssI1plL6pScYZEr9c97Mr3ArTTixTO8Y73hQB79/O
	7fQgwJy03LQ9MbqUFPZV6jwLbkNmiUiWikEnjtUKtnuFzu2CJrgZswmNb5Vf+Qw+m7WrfmNvC6o
	v+0BBW7lIbXVU8Am5KaemMt+LI8aAcl+L3ATS8uu7s4qXma0FpjoHGmbm397pXnZE0XkMLC93bm
	O/8MYMuC6AmKvNyMWzce56ZRAT3odiEo1fdlRja7YAW6YWu7gqTPhYrIKVzg3eRjRhrNO9uToqY
	m6qzlf9muERg0YmMHzXv0s1qNSg+0cbVcZG7cAL/T8p+JroZrV5TTZk=
X-Received: by 2002:a17:907:9701:b0:b96:d802:8b4b with SMTP id
 a640c23a62f3a-b972e1d6d97mr257929766b.24.1773289644646; Wed, 11 Mar 2026
 21:27:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312001443.3011961-1-gality369@gmail.com> <17c102a6-bbd1-4937-b5cc-5f6912551180@suse.com>
 <8533b404-3377-416e-81d9-2bdb00baaae2@suse.com> <CAOmEq9UusAbrMLSMkca+DEPff9hXokAvVn3V4acQ0EvSp67HLQ@mail.gmail.com>
 <a478f7a7-5255-4039-9ace-7d2b410db602@suse.com>
In-Reply-To: <a478f7a7-5255-4039-9ace-7d2b410db602@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 12 Mar 2026 12:27:13 +0800
X-Gm-Features: AaiRm52CLpJm6-aGNQAqlGhZJys1CvKKOMghfPAzniNQ3h5ztDOzV_-MJpZB5j0
Message-ID: <CAOmEq9Xj1+S1oDXaNEP3rWyG9DOd4LWm7sd3P5Ub86Fdx6Tgog@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: reject root items with drop_progress and zero drop_level
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 12:16=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
> > My understanding had been that patches should generally be sent only
> > after passing
> > checkpatch.pl cleanly,
>
> No, that is only a script which has its limits.
> Checkpatch is good for its code style checks, but not always correct on
> other suggestions.
>
> Sometimes even its code style checks may conflict with the rules inside
> each subsystem.

Thanks for the clarification.

Understood, that makes sense. I had been treating checkpatch.pl
warnings too strictly. I'll follow the documented guidelines and
subsystem expectations instead.

Thanks again,
ZhengYuan Huang
