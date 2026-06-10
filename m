Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93897408634
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781097574; cv=pass; b=lDda301fSbKgAc0OX7WsC3W/KCd9Ie3N7JerT8q990t7ne923j/6/NEazAprzAQDSDysZj2FowExuj0yVOzAQPatPSFPBrY34JNP4NNVlGPp+T7JTcmMIIyBv4GJav1W9fhXNOxbd0M/yC6PLayegy6wlRfd3EVeySpNt9Y7kfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781097574; c=relaxed/simple;
	bh=lGRQFI3Hp/wayJqw+xf0lgQEfSFmDvi6/ZWTJl9pGSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BVw1AyU5VFLE9uGb9jBQU+Y82TlRgKr2FgW1fmGEJJisw4sB/Tanc2ImZNkCRrEfJDmjMMSkdxHLeyRz0O56O7PoHUO1in6GkJoCH8Z6UspTkL/IZYI8pXhUawvCY7zJqzSTSB9XN42glpMp4WRS+BKe8a7ci6QXLJ0vABnw40U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EWsQI+1P; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EWsQI+1P"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef616daf6so6254933f8f.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 06:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781097570; cv=none;
        d=google.com; s=arc-20240605;
        b=AdXHha895bvrD/nXnWpzVmvuLjB/DNUZxCPSsMOeGgERQSEeFttSRbMReAbX/FF13j
         7OiAOn+AF8icERI3NsxP4TV3bZGpm5GEWs4FCLBHMYmjlIvSd6UgB+PAeRXf2tklUWE2
         u48m3iM80Z2W9FHVIkfjBJ7IOTeMuaqGLzCvsqSz63n8MfSbn/FxD/0q0iCSzsOY8dML
         KjeS+fXamqQGopYdfUOrBmi9jb7pCv9/tWFgnn8+jwn14RNnkp1hlO+0VgFD5B6rU3Ky
         ZR+Bwd896b/acEF5bD7Ya7Kv/A2mnqH6oGYX2uFR+tpyDHXEWPBm6J6HARR1kB/V9jZj
         h3Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZiiuXZsTISkwh6lAvtwah1aW4/G3cB8JXIp3JxzVYw8=;
        fh=mYivsWxMzm02wraQol8zJoBWieRAUZF4upII6oe2oLc=;
        b=QH4aImVrovxA8ErIz7rFSxOqzPuO9MvPNEOjdaHkBBtUBkaeszjYDBqrXaKsh00UYA
         In81dvmNwUGZnq+xnZ8jA3iTs5ymB+pQgZvhDsPOzlktYp1oYjx2v7nBhiFwzmYH9GDj
         idQ+V6cbn94zIykNl6zhPdRpiN3nUH0ecnpLvNs3iMv5ny+IHJ+rnBI6G8eXM9Z/e/3j
         U7CQb6w/bQOoy3NbQTtsE9e4JVnGSq9KcHqVs6GIeuCPKlx8QHykZr0jESb9sukd1GCv
         RdmZflIlKhXhHi/DMdyBJQ/eweKXaRawPvLPsELV7MdYeMzFbhkfabtUqxV1MfSwCIQR
         vwNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781097570; x=1781702370; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiiuXZsTISkwh6lAvtwah1aW4/G3cB8JXIp3JxzVYw8=;
        b=EWsQI+1PHRt5cJmsyJ3ajj9Tth53M2IR+9GHVPtZW6HR6bWyc4weZjTdyEOmMIW7ef
         IqM3ByglwjqeWAfLJ9MUU91AauLIXZZ2q3t2EhYg47KYAfonhd4cjXBKDslAJughRWdW
         BQkfHCAxvNYKeRDj/fzsv/rifdgfKIxv38JyS8cXlY92rzg+iUklQAjCBefVTgIMlE6H
         chRUlexFVEeKdMwisLFkrif8PF4rz3IhkKKIrKaxzNfwVhEY5KOrm+rq4XS3imqM6jU3
         +o0aqlpPDapAzO7B3JjrgEW3zZ199s0lLtvrtOni71ediE1rjMOI2kgpIwk6+OPJV06H
         ey+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781097570; x=1781702370;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZiiuXZsTISkwh6lAvtwah1aW4/G3cB8JXIp3JxzVYw8=;
        b=XHXgXfv28NZ26fyRl5yc2CSepbDyrXDdoh6JlJfp7l+++l0p+5Y2HR9ISaVtqw6SMP
         Tm3LLuf+QFBqPLEzai2vOLu1AFeCNKa25oO3FBID8MIF1hVcg33P/3GIs4mGqXE8/tI3
         Vm8GNP2ziMlReTAib8Mr6NhBk/5rIgSTfa+YbeimSnq5a6tzp6eq2GXRpplN3qlR1GkE
         huklUoB3h4Ps4f1FKbQN5YMKvCl9foFA5R7HoRhSLUSnbs8odkwyOwuc2aUPl8VvnKOb
         p/SGJI0d+JZ2k3qLmNYkG966Ksu9/zET1ZHXpiYBsTVWKeKG3N20k7o8mgPpvQxPayUn
         iOrg==
X-Forwarded-Encrypted: i=1; AFNElJ/ACdHSKVg2LGyY/LRp/jJarWK9KS8YjYwGgYshJYKJl9N+0f1N99dT51o8CD3OArPwkEZnVTGNfFGiZg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYMJsTEYuMAdWetjkDNGo9PB1IZHZxTmHPKddlJOj458KVuCSJ
	69Zr6LciWrAFmWsk2hCgZpG5uq+p3uHuAq/nq9ycz+oHR9QWFmE4gnFkFsMYfKEoz3Ryv3h5EIm
	Bh9mz87MDFPcevXa3e0oXaXvf+r9m9XLNpBddVk5jrA==
X-Gm-Gg: Acq92OFG6+SxiQr8JQHRo6cQGdGbsxtyTAhIv/EInQTZ6QMuar6xxsZPfNx2TMZLBGY
	qLnlPPvaHTBvcHAcBXfT0hIrv/J/Ht3TMdvHqSWQnrItr6AcvK+Q9hxuzixodov/Vun/DKrPx2f
	OoedkFs8rmfxw2Vi9zSlMhYZVACoCdwqWi3E3tR/7LOKTPMQTjyu8yeo6H0noCbuT9O75Z2NCsa
	wX1F6/cWpK0d2IuPZZ/XXg+uIGzBI2LFb5fCY+4XEdiJ8tGBuqkIzWb7AVKY11GJZi9D16vM6b6
	/XWH0ro6/5sO19pio8QUD6NO2HwJyY96KxOyoPdOUEOzNptk/P3QiaWJFE/e58IEEycjdTJErw/
	5KkF4adJF+o35dg8=
X-Received: by 2002:a5d:4285:0:b0:43f:e721:76b8 with SMTP id
 ffacd0b85a97d-46030624015mr27894543f8f.37.1781097569748; Wed, 10 Jun 2026
 06:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
 <20260531002812.GA2302@sol>
In-Reply-To: <20260531002812.GA2302@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 10 Jun 2026 15:19:18 +0200
X-Gm-Features: AVVi8Cc3kwl9fZ56YD-UdBCxPsiFupB3WEKTLBFSqqAW2W86Bzv6x7-7G0urFU0
Message-ID: <CAPjX3FcWv4Pv_dc+ArUYdpr+KZh=57q8XFaqrF0=CX+59bDaPA@mail.gmail.com>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

On Sun, 31 May 2026 at 02:29, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, May 22, 2026 at 09:00:46AM +0200, Daniel Vacek wrote:
> > Hi Eric,
> >
> > This is just a gentle ping.
> > I was wondering if you had a chance to look at this version?
> > I believe all your previous feedback has been addressed and this
> > version is solid.
> > Please, let me know your thoughts.
> >
> > Regards,
> > Daniel
>
> It's been really hard to find time to review this huge patchset.  I've
> started going through it and will try to leave comments next week.

Hi Eric,

First, thank you for looking into this.

> In the mean time it would be really helpful if you went through the
> Sashiko reviews
> (https://sashiko.dev/#/patchset/20260513085340.3673127-1-neelx%40suse.com)
> and address the ones that make sense to.  It found 93 issues including
> 16 critical ones, which is kind of a lot.  Some of them are the same
> things I'm noticing already.  Same for the issue that Christoph noticed
> where new devices can be added; Sashiko had already found that too.
>
> If I'm going to have to use my limited human review time to point out
> issues that were already found, that's not a great use of time.

I already went through some of the Sashiko reviews (they were slowly
coming up one by one) before leaving for my vacation. And I found them
mostly confusing or misleading. I'm gonna have a look into the rest I
haven't seen yet to see if there are any useful points. And I'll
compare it to your notes to see if it was Sashiko being confused or if
it was me.

> I also don't see any information about how this was tested (and will
> continue to be tested in the future).

I'm using the `encrypt` group of xfstests as the acceptance criteria
and the full test run to ensure no regressions.

General support for btrfs had to be added. And since we only support
the v2 fscrypt policy, some tests had to be split into two tests - one
testing v1 and the other testing v2 policy.
There are also additional new btrfs specific tests (reflinks,
snapshots). xfstests also need fscrypt support in btrfs-progs with
related changes to export nonces and other metadata like device
offsets of encrypted blocks for validation.

I'll send the fscrypt updated btrfs-progs and xfstests next. I just
need to clean them up a bit first. I'm sorry about the delay, but I
only managed to post the kernel part before my vacation. I was hoping
it would give you all more time to review.

Thanks,
Daniel

> - Eric
