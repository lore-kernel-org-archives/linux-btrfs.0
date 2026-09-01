Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356CF47FAFE
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 12:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265134; cv=pass; b=sMZj0qa7QPAWcnc6qh8jacJEMxe63Vkht+cqGECNZfI8jycZSrMYywd2V6YrV6cAwPw87+ygqSE34UchBph7p25pzsjbSUW4LNteHCGteuE7NdJHQGk85p4sdGNkJSCFnAK6zZyFrf+Jqg2t4bW/+LZUYeCO8d4cmkGYRFABzzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265134; c=relaxed/simple;
	bh=Es/cIjPUD1zzwXufbvKj4+Elkno+b+6GyubYx/khWOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JVNQBq1apxNBg4PjPwaTBB8Qc90v40FuiZV+55w157oNOWLdcs8nQ5d2R5u5MZwGVZ9H27PEj3wU5sWu3rv0KS2Us88TnhHmEmu2um/FQX+yzho6fVchLSoNJA1MJjEiwLdm4jFxZ1fozsn5b2pj8SsHC8HmKYqpIEiBljexDxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cu+sxr8M; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cu+sxr8M"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49b0dbfbf7bso33726875e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2026 05:18:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788265130; cv=none;
        d=google.com; s=arc-20260327;
        b=nXJKJb+BjByXVNA6x7Ttnu4zJmoYgYmxkjsvfv4A2qR2AXKHBebWmquU3MgV+b29lO
         HcV+6WgedrdEEc/p77I1E7tip0Pt8zWaJafAgppkbVzBKc/9rt3XsF1LzFyhW4g+AK53
         gdf8eck/iOJ66z4PKxe5Z+y8ta7oKPqit+EWj723fO83L1ZLrC4c9zDr5bXHNOe5gZFO
         v/4McwOKMXB3w7Isr1b+Mc4KpqYj03HR1jkf5zdyadIoCKZbUQtSZLkhpDIaWcJndgSR
         iD7p/HUxVG2TxXPJsoqF4kP6axewDxBT7kTGzUTAgbSLi4569WoLW01CpPNTm9KXb8f8
         jlfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UvAi+mvqn+hfoITwGygPm/YRj+YQGu0S7A55rivu94M=;
        fh=U9f2nfHM7zw2TIOOAC0BdYOELJ4ryU8MV8q4RJomI4w=;
        b=Ajh5YuQZMGJt80OjzrrDqMQrJpZqoSnuM+G2xeo2iQS6fgWbk+RT5Sw1fTrQ7aCaWq
         7lvIP4bWqbdOMeEIbYbEW99rSMGGjiItB9GKGLV0+l+KYJS8SGu16+4TedeDk9R4W2+Z
         OX6DB567+oAo4A0GCfN3+WgZ8ftGb3mWA41WtiM1UwMugo4Q9jeVGqF5kOUEtRZiHnJv
         bRjuaBObejNlqSpC/6S2jt4bqJtDz5brtzShXMQShNSGS+dmFvqBmOY9LsNKJh6fliN6
         d+MAzk1L/myAYnho8gIBlsFaxX2wC3VKCuCw44/PpaRMEDLenY7Z1cqLUumeayVcStc7
         2jBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788265130; x=1788869930; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UvAi+mvqn+hfoITwGygPm/YRj+YQGu0S7A55rivu94M=;
        b=cu+sxr8MK5sNC/uVsEzuQ15QB5fgL926vBMF3dm9MLyD0FjEmRuoRHqdEw9BqHWhye
         TBa1ExtRh8OOER2i74w5OILPqw3+MU4Kneja2YTshuGPesAeBzKlKZEA+4NbY/5uo52s
         RDr+jyzZQQCG6tHuikKqwWYYiwbpYYhMR6EbPHdhaZQl39yJH+6Ucx/k92aI0waI5QSl
         O6fMckPyqyodn5Dc8lzaFZj2I8G38EoFHu45F90amE/RCLIGCffXnCpC2dryp2Qwhlb4
         V10VFurB6/JJp3Fd+6q9Mu32cH5NG19cGUnMpuMfignb3pTXtybWNn1dMXKfukPyXipz
         0y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788265130; x=1788869930;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UvAi+mvqn+hfoITwGygPm/YRj+YQGu0S7A55rivu94M=;
        b=eFP09Fe/ocpb3fPwxlEow/zklodjWUSvqEDKWLb0RYuUMcVoCkatdVhAZrBo5MH3NI
         14hxWp7yClQYtqIbd3UJW7QeGGspuBALNH6NrvgMZSJgfNDIPHSdkbIwLFFvChZdaEVl
         jb4SoMHEVWI/TaOI74CXy8Ja+tm1+yTjHHDu+esH/HTTkq9czsWKTj+ScLNwo8/1M7De
         TUnI3BdsssZYcFuKCAJQLsYIIjL4+jfsny9KXbSfEXl0zp5Fg2VtwHZjYIP3mTLv4aWT
         1DQYGcA7amoKVViOHLh9qupmfMMflhxKYdOwfpEkCqIPqXUJnndBXdyPZKfnHs+CqQXh
         8PqQ==
X-Forwarded-Encrypted: i=1; AHgh+RpoX6wn4gEVAvmFstBIzgWiHWlkQekPrSiqiToRYp23xn/cI3e+jaqWjhQWK+ADiBZKfxibN8mEz5dtlA==@vger.kernel.org
X-Gm-Message-State: AFuF++n4ooibmo5wKMDnG9bwLLWcI5wdBAUxp5OE3EHguyeOqZvszzCE
	UaF16N7RIvBZVYTQsy4EB9qyKT0YHNerApdoS0SwY6afsXhT1AzxxgSJZAcTL0F/2s7zTGYcKuw
	9kb6DNBXqOl0j8fOeSXOzqbmZyjTCqJZZOG1RPsoqUQ==
X-Gm-Gg: AR+sD11bDyzDHzBlS74LeoG5GRozEls+s4JvCdLXSZPWZ1trNfQo+HXUbxe7IaFyCpA
	jvD8wvfQr3T4Vhl/m/DHjVFCMrbk0izpmu/XnxxB0hMbJKThmWIN7TcZywzkVH98OrLst3vw/ko
	IicsoD+cLL2vQtmqZEpZEkdb1QOx1grwy8Itb9th/Cw04ZwvBrE7DF0wkuOI7zJPuaa2f/km0xk
	Bpczkv2kkOfgzhy1jy5TgdF5iKg1DqSm3szj9asPSOEd4z4EbMxqwIxbvafdlX3UIMtZLCEExyy
	H7cpHRdVLsCMFUJMzsKc8U8p/zNV77OH92yErzCZvTPKxBUGZ9xATuRYO22/P6pVXJdhMNdIP06
	8JbIM5XSTD2/0T2cUD0AmkAl5PF5ijnuVpalA70P1CQ==
X-Received: by 2002:a05:600c:3b13:b0:495:4d5c:903e with SMTP id
 5b1f17b1804b1-49cdc4332d4mr140012115e9.7.1788265130443; Tue, 01 Sep 2026
 05:18:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-6-neelx@suse.com>
 <20260601230913.GD25574@quark>
In-Reply-To: <20260601230913.GD25574@quark>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 1 Sep 2026 14:18:39 +0200
X-Gm-Features: AcwNN1WZzfR7nMvK7wzsu0uw9g-Q6K8Z-mgC6-phqgqu2rO8TCpwPmWb_Vlt_uY
Message-ID: <CAPjX3FebVAj-U3s7nJiwu3D74p_nAGacYPJAX04TVXJBaievGg@mail.gmail.com>
Subject: Re: [PATCH v7 05/43] blk-crypto: add a process bio callback
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 01:09, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:39AM +0200, Daniel Vacek wrote:
> > @@ -330,6 +330,17 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
> >               }
> >       }
> >
> > +     /* Process the encrypted bio before we submit it. */
> > +     if (bc->bc_key->crypto_cfg.process_bio) {
> > +             blk_status_t status;
> > +
> > +             status = bc->bc_key->crypto_cfg.process_bio(src_bio, enc_bio);
> > +             if (status != BLK_STS_OK) {
> > +                     enc_bio->bi_status = status;
> > +                     goto out_free_enc_bio;
> > +             }
> > +     }
>
> This looks very out of place in this function, because this function
> potentially submits multiple encrypted bios whereas this code assumes
> there's just one.  I think we could at least use a comment here, as well
> as a WARN_ON_ONCE(!bc->bc_key->crypto_cfg.process_bio) in the case where
> an additional bio is being submitted.

While this funcion may submit multiple encrypted bios in general case,
the check below makes sure that in case of crypto_cfg.process_bio
callback splitting is not allowed and only single encrypted bio will
be submitted. The WARN_ON would be impossible to hit. That's why no
handling is implemented with the in-loop submit.

> > +     /*
> > +      * We cannot split bio's that have process_bio, as they require the original bio.
> > +      * The upper layer must make sure to limit the submitted bio's appropriately.
> > +      */
> > +     if (bio_segments(src_bio) > BIO_MAX_VECS && bc->bc_key->crypto_cfg.process_bio) {
>
> Checks should be reversed so that the expensive bio_segments() check
> only gets done if process_bio is non-NULL.
>
> (Sashiko spotted this too, by the way)

Yup, true.

> > + * @process_bio: the call back if the upper layer needs to process the encrypted
> > + *            bio
>
> or NULL if no such callback is needed.

I'll add this.

> > + * @proces_bio: optional callback to process encrypted bios.
>
> Typo.

Already fixed. Sashiko also noticed.

> By the way, after writing kerneldoc you should run the kerneldoc
> checker, as it will find things like this:
>
> $ scripts/kernel-doc -v -none include/linux/blk-crypto.h
> Info: include/linux/blk-crypto.h:79 Scanning doc for struct blk_crypto_config
> Warning: include/linux/blk-crypto.h:95 struct member 'process_bio' not described in 'blk_crypto_config'

Hey, this is a good hint. Thanks, I'll keep that in mind.

--nX
