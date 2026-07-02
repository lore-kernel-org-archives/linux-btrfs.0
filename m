Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8880390C89
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782976742; cv=pass; b=rTq9duA9yP9SiWS1y/D0YuzZrHvt42OvbJWFUclI1TE26ucA/inT4QUJf+xYkPPHzRzfjalBw8tcFCRe0OAzalcuUEUgy6H7VWVxIBRx5PS6+SdUJlOU1WPXGusGtfGic4EVdijnRhoqWLuc//qxqbg7xVDiUwlLWaV0mh08FP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782976742; c=relaxed/simple;
	bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ealc6U6QJSUFIIHFcSZE8AZZNb3o2/hezqKqRB4jvsK6B5FZWxZFDhsoIc0RgXzkhQ608VlYQwWMBf8keAHyGWrauCtkb0V+Yijo5l9jM5wqY1zIppGcqp8LI8YJiqlnrcJmagBy3c40o9IPw9rLpF7L3gGazMyhhpXa3PA3Vd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PzIdkSNW; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PzIdkSNW"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c59f740cso2162015e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 00:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782976737; cv=none;
        d=google.com; s=arc-20260327;
        b=Jjp6RgO1q/6Q6l/9eDgRvXoAPcaF0847ZeIvDufRopvJr5HVJEdFotV23oBFfzC+Ig
         LeYn2D66uut9bjKkyOodMe6w/ajpA4l5RRdfngQHgAISK5pzjfd7WXdX9LX9c1HV5FuI
         qFS6RIXB5I3310w/WicwDbT3B57NJ/y7X0vjEFRZ3rQrFvRCrRuIClDF6Q6iV7KhVPIJ
         WHETdfIhSrHI9RlJcI+XP1SqqYGlQlERT4nSuKGG9jUSa57gTVmWMspd5rxBMfluEJSu
         hPjvaDO2YQU0O9GHjvodXW2ylryZN0L8otaM0WOnVRX/Y6gZndAqe0GN0fdNAr2pwu4K
         UyPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
        fh=M6sWhnYh9xwOHRA9iPiwLfK/vBL8hsuRDYDhuYPE93I=;
        b=S9PEA2ecZppC+dSIb6/SwG8/2SjCmdHDZnSp4bgKRSlTDsS9Ji1KCkg9dU+Rq0BlT9
         /opy/fb9YHDF7wqdxV6PgthyLT4Y27ooOaiGvzcJpeVZJwj6YY3l+zU79K9Mhh99hY+q
         gi6wCVRyZbSMftya5pwlk7VUCr7F6PktQfCifQXu+WTW41m8N7G9cQVDV5C9jlQqM1v5
         6r93fnXwTQdAfx8gscRRpdUlG0AbLc+qKGyHqn+oaZcA1seI1DDlGWXOjq/pe0vo0Mz4
         RhxTLSRUBfgGxtpzZZgbsEDSbRRs0Ey2Z/2EchSmLkX+9HmL+ohrYBDTDxTAxWVZ4jDS
         G9mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782976737; x=1783581537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
        b=PzIdkSNWXvl6WWsnM5EdePveBC3TSCk5cZa/soGX4ViEWRBNN0sV/+oYcjS2B9iod/
         5GdUzboiDQLkywUb83lw4VbDMSyQzOJC1el/8WdLnbtN0Lc2LJvbJf/Eyzv2cG/BrzNB
         Zi+4DF6JtY5ilEuh7dfMZrT1XBIzgTdJa0IwQc8DdcSVHVdjBg1CT5E4vDroam+Y25L2
         McejGmWTxARBiKkqgUhTD2c+GDmnfdVeY0sVG5HFb12suV3ebpR5dNW9Q+4nyu8DD4D2
         lTRsG0trOdPPBygt4lvjmH/9K81TcW3+xwH/sXNH6koBQKQgShcZ221jFsyD6z0y1POa
         r7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782976737; x=1783581537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
        b=mNmyyeR9Z6jnjfqFrQLN98zY49pBiWGMAMWYbQZkGZjd+F4mTIrkvJ5QLGuqbSNaKy
         klPmQrjqD95xqARUzlTCjUhwezMRm6oBb+yQZsYvxS6fiQNr2oXAUt0FqHKMbPylYcbb
         u2esobuUcEUt0+WNnqGToM9d8oSqESic0zY9Z+3H6oAmC32zxlfxbC5aumHnVJLIIRJU
         R+dzsHq/jkBXTCZjZNWLUFgeGmMtTgZZHiK05stDl66+aI3k1gu46Byq/jeJTe4bNxO4
         6tHEcrVXmI15UDQl4ixt9PdGVem/AR7y+0Zap57yc8ogNceegmcYbA75F7dRqRz5xB8f
         XJbg==
X-Forwarded-Encrypted: i=1; AFNElJ8wlqsnAH2wGJLfsYN1BUSU55P9HugujmTtyahGHtWoHvzJFXuANbpt7yEgeupEvqTdJO0KGATCGFPdXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqVUJ7Nokg0IBcFEW//Ut5IKtgdbFyl4H6plv3SlvUCc85yvfD
	gPI01ryKbjqBSCihXYt3lF/OA2pmex9Wgxei6GR0sf4YrqxZLTZbx+W1DVK9cT40UPQda3rpNAK
	nisd6U2Bffepn1gSP+IbHNysroE9L31Q552v/9cWvhg==
X-Gm-Gg: AfdE7cma6uex+yqsDl5cd4E+vFQYzheekKQL0gwNdsN3t+vzJJRIM5fMoSEILMEZ7SI
	4rPRTrLaiFjnKuVOxB+s8rhW9+rV/UlA7vMIFuXSD+LnBscWx5dhgFoHCYQKZ2mdhpJYbXtyuX5
	SBW5hIBqQYm8SbQINGaYrWW+whAC5uPXWiXRHqwkvTwKMPmE8mNPCG42E6f7tbhsy7K+3EPSxft
	VpSmrCv2PnQCA40dMjmliOlp7luVIRef4LIqdlfXIWNkxBIQ33GBLu1m/NoFLDO5IC/YJYLdW8v
	91QjfQvOzWpvYiYFKmQjU3MBiZ9Z1iaGDHzAtggD+ZHtXDsBjbyGGnNTvzTJp1ZPWkeoTg==
X-Received: by 2002:a05:600c:1986:b0:493:c3c9:218c with SMTP id
 5b1f17b1804b1-493c3c92192mr52905165e9.30.1782976736990; Thu, 02 Jul 2026
 00:18:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com> <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com> <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
 <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com> <CAPjX3FdzjXTR7q8RjOUdu_8h6V5wkBjsUKM+=_9VV=rcg+3FdA@mail.gmail.com>
 <1cb04346-a607-4253-add8-614de783a0f2@gmx.com>
In-Reply-To: <1cb04346-a607-4253-add8-614de783a0f2@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 09:18:45 +0200
X-Gm-Features: AVVi8CfLydV7MLy8qhraAKclKY-C8O9mruPT1LVYg123RLLwxpEiEiyk426zbl4
Message-ID: <CAPjX3Fdc7+iy+-zqHgnJQwgwDk4mNSbuWmLG44jWWJkk=3MWvg@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jul 2026 at 09:11, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 16:35, Daniel Vacek =E5=86=99=E9=81=93:
> [...]
> >>
> >> A simple tree dump can always show which range is hole and which is
> >> preallocated.
> >
> > Yeah, that's true. I'm curious how other FSes handle this. Let me see.
> > Or do you know from the top of your head?
>
> Sorry, not familiar with other fscrypt implementation at all.
> You may want to try to experiment on ext4 to see how it's implemented.
>
> I guess they do nothing special and just expose hole/prealloc info.
>
> As the other path would be always filling hole with zero filled regular
> extents (before encryption), and disable preallocation completely.
> That looks over-killed and may take a lot of extra space.

Well, rather filling the prealloc with the same zero-filled extent I guess.

--nX
