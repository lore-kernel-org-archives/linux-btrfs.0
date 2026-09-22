Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9935D23ED6A
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 09:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067638; cv=none; b=j04PDIhYq7xtrYbRxByRZF1FhelM3c9VApp+ZQiZHjvUv9WJ8eTNOykJERLi99yaeqZ/RsrzBttzWcmgtFo2MqqzuIt+4pHzGdGZMzCyT2bur4Hp/oNMR3y0SRtVvsBnz3cTbShKSPEeehSaU52ox/PG8wOHLGZyTBjgRZY1nRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067638; c=relaxed/simple;
	bh=HmmHSOBi6Fqj+ayaB0kp+lUWkEfnbaCEl7Q3FaEXEB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxr/jyt3HBC16nZ7ACUt7mKCmC9NZuqvU9zXbX9f1e/AuNDAAE9ke/04KimVN2fwwgy5xaYYeXBHDLX74Yr2SXO4JUiFCGnLXx6QFGLEjAVeWmiMMeehlNEVMfFMyUqtxeoXEd73ib/dTnAdusUR+GxBhXmzFf3jGP6mQzxG9+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SnYZK+LM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEfecw90; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SnYZK+LM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEfecw90"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
	b=SnYZK+LMDE7gGrg6l7IcDTNmdilwHNWT+A9W8Te1ofRL9Zr1CaKTdMm8KwHy+46xpFCjXW
	u84pw0HkfUxXtFFswxPfyiS6tU6uzgNAwYhQSpjqIOPvgAfTspnn6+0/p2nvqnKIxpUGgW
	ltO1EX/PmAJ5psyFvmEu4zyrSOutaxc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-OiCzpQdwONKyYP0jUBYqeQ-1; Tue, 22 Sep 2026 05:00:34 -0400
X-MC-Unique: OiCzpQdwONKyYP0jUBYqeQ-1
X-Mimecast-MFC-AGG-ID: OiCzpQdwONKyYP0jUBYqeQ_1790067633
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c210c66672eso487581466b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 02:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067633; x=1790672433; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=dEfecw90byyjd4UIPI/J6VNySFo4NcC2qD+NZekmiNFbPXDjJ7+0irYnPP7DI3cInb
         PrSALNg7tzt9wBMjtAXhQHCb7Q5fcCouXglQzdmSzdmv1q0dOnaDUXnDDhLUcrb3cqdZ
         0GEpy3VaKMHMYlj7ElQ+iB55sNezg4dnm+v+lSKy6QHgpYd5Zqfq3O0DnOIZeSMTu5N7
         4azx/xzj9DXH7qhBSl97pFg6PzjlGpzrQ/4ChW3a+eeiXOw60KT00AGhaFnnKJCHK9M+
         WYjXQ4np1KKhUN1BYUUTcAAz/KtkB/t899hMRnheSaaO36A0aCOqhnmVDBxuj9X/jqVx
         /fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067633; x=1790672433;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YJMnxCx7h1aVciSzhmVbEN46xY6rfHQRJ4daqV9A0s=;
        b=WRCxHl7cdAb8EEEcuolbHozL3qjLbZLhZp+62nlQt8Xgi6/g/n6XRaOxihzoKd96Kc
         2YFVkO5Rn/quCPl6yKl9OPDAKDEWRkSRF2JWgBYv7RowRztKx8V1FOws/DydCS7o3BQB
         NcPgpM7pn5QGM1/JtgNJ0phIefSS3S0ve9OasL+69DWgU26iJOmM1EoFH6tgFuPdKayJ
         jwA2yp/ms89L/iLCIUntywD8/Qbr0VsLq3TwRDLN6dQcVJxJ+PCou2IA6YCBGlz6eTgk
         eqXdDYl6uylaYXnGBdr4vQaDZjILE2a8N6POmr4Y9Orjt81IDzIsWlyqtfaEpK6avCug
         fR2w==
X-Forwarded-Encrypted: i=1; AKwUvBxrV3w7m+RtTYjiWt1/7ais643M/rs+eihm/40fJ6yPN56ZafEMUAys7vWMnkm8PNRqaGFLkjfLsgiMlQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mzV9wu3BLc3PZ+tck04vr4SW7xArsGTHku7L2Zat4j8LV+RjnH
	+eIg7wwAl5dWaW/FrJBHxkJ8c5YSzuIwnMJXSz80XS9IiHYq/0i0zme5dghkQrkiP+Ha/lMFhc0
	THtEswfeDgZ2MTdsyKWtUPoYH2SBUPi9aqmj5igaoFnYY+bVTBQH3lBaB9TXwlC0=
X-Gm-Gg: AYBFou0FC83OKn+OUOztBbkHReOt521LnSlI4o29VYFByoSSfgE6xRsJCMXCFwO7dvj
	D3rjWWl/EDdP4IE14TwjBt+eqz4NqWA8iWHrJPxfoky+IvQL8Ubf0KdNczai7u7hj4YvTouWK7G
	97lMpzBwqZqhFqA9dtBMi+kFNVR/3uGsjgmSCnk/2crTn9w/4DVhs1MaY0ZgoD+ut6Ae73AEHT1
	KozbqjSRLaV+4bgxBsOqta7RJdLbaxu8A9gc6yU73xAH11bB6vDUvZ0qaYDaLvRq8hMo7rM8Ywo
	alsTuER8B5oS/RiKyzc5YzVZGWvRP6xJ7ZdjCw+6+Bp/jyVa6CohKjKQ6+ahq0xghjw8JQX4WkV
	rQkpY66/7JScIyGUGI+E=
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217332866b.20.1790067627986;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
X-Received: by 2002:a17:906:9fc1:b0:c29:4a1f:76be with SMTP id a640c23a62f3a-c2a15703413mr1217326266b.20.1790067627294;
        Tue, 22 Sep 2026 02:00:27 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c4309c7sm51460566b.6.2026.09.22.02.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:00:26 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:00:26 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, 
	hch@lst.de, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <arJC542mXklAeswE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260922045144.GP2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922045144.GP2705364@frogsfrogsfrogs>

On 2026-09-21 21:51:44, Darrick J. Wong wrote:
> On Fri, Sep 18, 2026 at 01:15:12PM +0200, Andrey Albershteyn wrote:
> > Hi all,
> > 
> > This is next revision of fsverity for XFS.
> > 
> > The main change from v15 is addion of kmem cache
> > xfs_fsverity_ioend_cache instead of adding work_struct to iomap's ioend
> > struct.
> 
> FWIW, Sashiko found at least one or two bugs, but the reports only got
> echoed to the ext4 list.  Perhaps it's time to discuss allowing it to
> email linux-xfs for bugs that it claims to have found in xfs code?

I'm checking its report for fsverity series, but for other patches
not that often. So, maybe it would be useful for "critical" and
"high" priority issues (not sure if it's possible to configure it
that way).

*this time sashiko sent me a bunch of "no regression found" emails
which I think are not necessary

-- 
- Andrey

