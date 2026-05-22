Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3DD36D9E7
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 12:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451245; cv=pass; b=T2oevfQMXHMhgQ6wBL0FpT3LaC1MMfZiasWQI4oaDVlsyt5g1O/HbyCcuCuqNnu3bLlsJgXdmFTaKmf97+YlBt2P/24pIecOFhdyThP6jbS+A+RY9iZHlACol2LbmHCbLJeKu7vtUBWoaM3I55zd7hVkrktmRxEfaAXPcRW87Pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451245; c=relaxed/simple;
	bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gl9WULGpCAxA/2IWavmElAwGHWVDW1USbWewM63qikwwdJdKmF0YeRsGc1eTg8KDjpru7WwbBDczl8oPHj17ZvnXUzql9P0nNMt6rIwno86vRQWflF/PtYzxTfnLF/ALLJNnw9EJO2qZ8qoicFmGeSN6BTnGWZY2UD22mEAuZKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ykt8rEYk; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ykt8rEYk"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so82425995e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 05:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779451240; cv=none;
        d=google.com; s=arc-20240605;
        b=ikfKhwnmJ5BgAX/fSLpatRKbRsO4FhcoS9VzJ+EHsmp1ABJl7JFVvQxjTQCC2NyA+a
         mKbrT+9doeeo0AHiUrhgv3uQH4XeR1fh9/NIDGiO3db56KswVX/qi+KdBW5N9nVEKPBz
         4XsaQXZx37f3diegJJkZX7EDLrVOAzTiMUW2DYfjerg2KATASK2OAZfogf/oSvguDWwl
         NPUgNb0JnCulOEYwQyRuEVTKu5Hvd/MkrpEkSc2VbDqRTEbRMNJx07yXWd4l9TfsIabo
         +DMctf3T0eSzrzJl562TvkYe74HgIIUPf2W06C8Ho77btbj0NP0XDIoYeEdETlwPoNFT
         2ujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
        fh=3Pbpjkq2z67ifuDT8NoWiN/6or/ozDDvM7tVvXKhwjc=;
        b=jayObFtS/JZwKGt4tcIts4FLK+jxlKYKcN1AESA3pJgthRhS7esIwven7yrH7+zG15
         MEkI3oNgWEPnAzTUSEC0OYv+s8NmU1WNyQeULDH3qp/RMwtd9rNH3z4/5oJjDteMKx3y
         ltPKcMIl5Tj2HZM2lMVcInhqSU4uJ/5iwF8qo+M06mi2O3huUQzLrOUWMObl3RoFIjiS
         WUaOfexI13njdn6dedj44yM8/VMMqhP5x0/hP8bfBq9DjhRgc6rolNCSXOXBraWKwolq
         DGnuvxcndk+H4TbNoW2mARD/60Vf78n5tXDknb5WpZL+BOQ8FBbsQ6r4tvMm1Tki3wlc
         3TYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779451240; x=1780056040; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
        b=Ykt8rEYkjenflb7/tF/677oVnGU7WtpMdZ6ISzY8xTpgUY0DBn1gluzaFRb00NlMLR
         xLDc2uU/A2VibLCdHftPzNRSQZiWHxIYzJ4aQ1G5as7cVH2ESs677x4uEeP4ABQ+1Xin
         d4fW3zhIPaQpSB6A/Smoclf2pUhu5oqV5TNR3Oba7JEoc4yS8bPQwCyHBHWSPaGRXf26
         OeNrIecdYr6J1T+7NjCAAin82H3sBtzZsbxOWHbmxI5BlgCRp9i/ExfBOYR7FLCB7bxG
         QB8PG8BVHWtlTgt3buXhNjQpq50tGP/dd2RNRtELocYHswOIPfFLghpCCuF2TLaKJz9b
         bGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779451240; x=1780056040;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
        b=ZDoS+XtVSALtt1oLI8DVzvrEtw4ADoOwMB8CS85pZVp++MIJ6/QmcLW3h5Gg5sOGux
         L+2529K0N+1dbnjNDCgnh+sza2HvJa80ucloNW65DWR4deBowmBjLReWG1zGEFleKfPX
         SB90LJ7vhnPfWsnn6AVdOFJCabz6bMNE4WtWcsjTJyUD7gZVq3pxPjXfK3NkrSvppO4F
         glS7/CHttKRdfJP89QstPx9LYi1f5LTQYlwGKKrewlY0t1Gxi+2uOILJh4TKpdprp+0W
         Clsa0ni8EFnVlJHwl2WN8OY6C7/U78IzqTX7OymFNj5mua3XGt/oZXV3e0OlET3gp3ZS
         XKAg==
X-Forwarded-Encrypted: i=1; AFNElJ+c6b6okfSbkg0wBz6xi263qPfIzP4gE9I44kv51w87L2qy82MnKh4DTZVGo5B1bI0ATaKd56dg/Nor/w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7GvzZ9W4eNHddXGT4Fy2FypQUgZpw/Vyx1BU0o9R5tOphLGva
	eIEqK0RG635VShX7Ld8l0hIdSPxMXKhlu/lJj1kugItvmt11FUxwnzbN1fdsTlN4VNM3p/twIxp
	OEGV3a7/jDvpUdr5aTUs9+erfrGvMTGKj180aieg66Q==
X-Gm-Gg: Acq92OEzTFQ+8/mBNAzrE4wJ1+BP01HAg1X81ecwwR/AO/93qYjphrq51IxRHV94gE9
	/kNBZD6inWP41hbJ4syhe56TTPw/pPApIWdq9XWXBPJ9C0Gjyg+ubLL9Ph4eKDcZAmTYAtOgq6g
	sEzDINqG01KeNGk39FFkr6rp0G8NeK4Uk5e9pRM/p4xF+BrnCxNnlOAGQu6PXTMQ14X6vhMUvz2
	qSgqpPCpAgc5oRZD4r6syeW6S68v8d5R/chs1DagWcFR4+YwTdeHlMTMCXJzOzkkaqBQvfXrAbx
	3cBHUHur2zRLgyeW04jZPZ0ISW4K/Xf0f0U/E8aBZwLQkuhogniTeKdB0L4L/mZlbUixFlrmi1v
	oCKocqVr91Vm/x7U=
X-Received: by 2002:a05:600c:3547:b0:48a:7b55:12a6 with SMTP id
 5b1f17b1804b1-4904224b05emr46591285e9.0.1779451239711; Fri, 22 May 2026
 05:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-18-neelx@suse.com>
 <ahAfvPa_yl6AKZoW@infradead.org>
In-Reply-To: <ahAfvPa_yl6AKZoW@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 22 May 2026 14:00:28 +0200
X-Gm-Features: AVHnY4L-B6zCGkAkTyjhybBzvlntESV7mYOAACpjsS69rRBft3tIVAlMyDpZ2_s
Message-ID: <CAPjX3FeoGzNOBnmY5ie34irNaAOZiFqV_Ccf7dXFrZJeUXh8PA@mail.gmail.com>
Subject: Re: [PATCH v7 17/43] btrfs: add get_devices hook for fscrypt
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 May 2026 at 11:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 13, 2026 at 10:52:51AM +0200, Daniel Vacek wrote:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > Since extent encryption requires inline encryption, even though we
> > expect to use the inlinecrypt software fallback most of the time, we
> > need to enumerate all the devices in use by btrfs.
>
> How does this handled adding/removing devices at runtime?

When called, this callback returns the list of bdevs opened by the
given superblock. If devices are added or removed, this function
returns a different list.
In other words it always returns a valid list.

This is called from `fscrypt_get_devices()`, which is called from
`fscrypt_select_encryption_impl()` or
`fscrypt_prepare_inline_crypt_key()` or
`fscrypt_destroy_inline_crypt_key()`. All these functions walk the
returned list and discard it immediately afterwards.

Note that with btrfs at this point we're only using the inline crypto fallback.
Is there any particular reason you asked this question?

--nX
