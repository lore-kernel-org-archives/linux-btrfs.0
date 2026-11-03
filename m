Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793682965;
	b=bkCfino5ub6QoVwsrTt8C429UXpiF6zMM2AFiu6Q7pe3ALiXOk6ZdYswoJEuFHnapy+r
	 jz6u/ywblV5D/18cHo0VHqy8DJQaWagLw2+IodZeaNLx6Shm5mbDXING9n+3G8tUInUu5
	 elLYyaWqRMLzj3Zh87/qqq74in/8f4sY/4n74mWp9Y4tFnCEHXz/OpnBPX9nlga1ddlvu
	 8RYfRy2ddU1Rd8SyhPC/3rQYmlTcrdN/hkjWozK8vL7aO8axK8Y417RPg1J10EQ+G2TCJ
	 f/2Rzdj9zSRaNeLRRw/ARQceJlGc5mbg6lzgYlqEs4qqh/ktwaAWEToVTvoJvl41MSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793682965;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=PGFryZNd38Zhqh8hnykXJyIhCnVJvOsmZjjsn+Xx4Kk=;
	b=M//BsVl/GzhSJg3oorMMntGicTZh7WTSnPau4wczZxBtEhu0uLaw7zDFGwMz1eXetKWW
	 5s2UBjN5c9pE96aqlL0EJY/dDbgsHJtxvCwcnW8iJ8NdlVuDoirXqG5eNdwH9nMsYsmG2
	 YqPoOdXdP1Zc4eJZytVxeHtV4s+FS/7hCsMCvBlFQxBj+8iA2K6q3Ss88cNkdLvCh31XC
	 PTL/JZkXjC69H5jolJru+yrQitD04bMZ0/BgaxCQ/Z3rDC4F5JU8ARW7rcj1lFcSrShsW
	 N/GEnJM5KmXAykV625Az2xWwFRphJlb5464wJjM9ZlwINvT+axNcv7C3Y7mie/j6tIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=FSGnN9eu;
	arc=fail smtp.remote-ip=209.85.167.170
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361AC606A326
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 05:16:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 361AC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=FSGnN9eu
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4ab8cb2a6e4so2739563b6e.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 21:16:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793682964; cv=none;
        d=google.com; s=arc-20260327;
        b=CVHRAGamhtv8wNUoYZmWm/KYJmmgu1jOeN0YloXLDzQv/uh8LYARWhBFh2N59kVE/+
         F4/r/9aubeRK642jFxsWm4cxGxtr/KjxNSjoa8uOb11tJCVaKAHaiKRF4a67e6kUQEYp
         zd32j/9+PSHtcGRGDAtMQxbwfTzkvAJFosLBR8kLjQn0VGtTUp6Xyijq52ZZy5nZogAs
         0i90OFpldQiGtxyh9SaGBuUvY3bY52/D5TUj5uO/ao5EUDzN/h2VRgMr7vgJzqnSFHBR
         xvttUesaB47BgJFOABwZvzYQEfWj0yBLhT1/6lrDpsSRlN1zffs9gvL+joBQrsAWwFcN
         f3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PGFryZNd38Zhqh8hnykXJyIhCnVJvOsmZjjsn+Xx4Kk=;
        fh=29yJWJAeYWEoZNLctvn4qrxQi7+GyVJyUkuz6ehawYA=;
        b=EXlPJJo/36Fipm2D8tYi1w3zyp02F0WrCI/V/sEYkIvMp6gwhFmsZpQgoU9i0pqOQx
         g4JLD+zEe64f0c9qbZOUWOhMt2dTo1rWhljCWlgWYn3+pdeEiJyUVuFLrT4SFXuNB0Vk
         ye8pwxmNyhjWBrX6+kMpcbIXIvE+2WYQXyqxZSws+BEliF4TGCkNGAeb+vSx501A4mkF
         sXM3auVF0Xy1YHLObI8mZV1ubU+FSzB/lDYI0WqVB+HNzIFw8Kl4Ky7B1VevP/ZnOPD2
         09/OvmUCBNPvBp/aXhBE1aRPny4w5A6L85gJL5/sV4uYjyl4PX74it1MFf3xsIPt0idz
         Dlow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793682964; x=1794287764; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGFryZNd38Zhqh8hnykXJyIhCnVJvOsmZjjsn+Xx4Kk=;
        b=FSGnN9euCc9ApPpIPO11jVmZ5B0lESa7Ydpi553D8AMywtGLGjTxy80uGxzB5MbGBE
         wsDmxZVI6weJS603WotaUcvaZeercfWdQkLTAvdBWod27m4nX/vh8KZgytWZkkZr9RP9
         aHlZOYKQ+11VD8F63mr6nvqzOTxEK7TD5J8RvG7tZkN3h67kCjHAlOHRGw+YSHKAz7my
         j4Hj2JZyAjzWEoD3IZQV6XU6wIeLzz0CrMdsFB8QCKx4yStdWTmNB9ojG/SYMxlLQutD
         Tu+d4ch0ncnEEfl11kbmXXkuAX0sBOhMVMsWZLtTDrc5s3Gxr03xihwjRN3WCVC6wxNF
         zq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793682964; x=1794287764;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PGFryZNd38Zhqh8hnykXJyIhCnVJvOsmZjjsn+Xx4Kk=;
        b=nAMEtf8hqRkML2Bp2hpod/vPIpOO35iQrQojr9GSCaFSOsVSDQIgzUYsSRvfG32icB
         ASCI+8+V26vcs0s0Lil8AsTtV/uVADnxOdOjMVn/FeUUL8559dXjR0kmjziW5EbCg+IE
         nON2Y5L9BxfozJKsg746tR1GcgdRs9FiMK9qBMmoRZSFmURO75q4JT843jzpPB4q5fWM
         PTb8bv/3pe/vanCSetU980uKNsQgJKYKoLhmLLQa77f1mrZzgUzntAkCoApSIBPmfUCU
         bcXlp+t5OpowQ+2nYx6RErUYtnKX96oudLNA3mF9PHZjAw3uPRcaRzkdlSkhBumEsE3R
         BcnA==
X-Forwarded-Encrypted: i=1; AKwUvBz7EaksIEfi7619+e/tULWXm9hGtYzJr5wctbIqal+uZPnOS5klPowI223MLf4jrshEUlGJhRYjrgqw6Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLDIQxTWOH7+dMbj5vLka2EvZZ2HWw+dwabHgU2nfEuPxCxJgy7
	vIC7W9/Kp2ab+ws2Im/YtI7xV0kcMZQV0YBxZFp5r/YuSvrqRzJy4aU4jS92b3wzLJ6/+V5ItjL
	0V1A3R8nPDUXHtEKt0LeazMJkIcmK2HeShnTrZLcTV/q4tHMuIbWaJj6aDQU=
X-Gm-Gg: AYBFou3iJ9ZXK1RhEqPFuuNn+mI02R5Jr+RP4OOofNPuT87MIr0D7M4q25KXfYNQ7Lz
	Mndgtbu28967g/57MQDZgsJf/rNfhHWw8JCDVPRnwFlFivXDK412WdwQWobf0rb+pEU8jFZu6j7
	9xCVIwRz7mtEJkJv2/rjiHFxZbniBegjuJeRiWr6LKggSRPkExlyZfW/gizQXHz+73tOEEMRNCV
	9MstErn/RJrKtzUQwqvdDYZyxqEFvEzQyvJ+6T+4IcZP8POPfuOBL+DHWHLRq6Nu7iFrqOLwRBb
	4xYGaOy0nzZAjSb8zuEYthFpt0cm3oEpnI0HCNsZs8J+N8PHSp3Mbwo41ObMAU4wKhauqrQ4BYE
	HKEdYIv2esKkFvvvhoPsA1dN0NTeU0dVUQFmp6/AEIvHt31tejMhWCKxdrhusTx4OodCw4aw=
X-Received: by 2002:a05:6808:178b:b0:4e9:cbdd:457d with SMTP id
 5614622812f47-5640dcb7433mr8152707b6e.11.1793682964043; Mon, 02 Nov 2026
 21:16:04 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103034932.1790235-1-smish149@asu.edu> <20261103034932.1790235-3-smish149@asu.edu>
 <9b8d9f77-981e-4bcc-9d30-5c53a2c1d1b2@suse.com>
In-Reply-To: <9b8d9f77-981e-4bcc-9d30-5c53a2c1d1b2@suse.com>
From: Siddharth Mishra <smish149@asu.edu>
Date: Mon, 2 Nov 2026 22:15:52 -0700
X-Gm-Features: AclHuK8EhuIqsMApcRe1p4MKz2sF3pCM5QkPwADZCjYjbLoYzLMJZd77Dx7ktuo
Message-ID: <CAKpDGtmMzYinwYLF1AKbA4_kvpWS82Z3yWwsyo0-f0t1QknN_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: tree-checker: reject extent owner ref without
 simple quota
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Boris Burkov <boris@bur.io>, Chris Mason <mason@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 2, 2026 at 9:41 PM Qu Wenruo <wqu@suse.com> wrote:
>
> I don't think this should go into BUG section, but CAUSE.
>
> Again, remove the last paragraph.
>
> Again, I don't think this really counts as a fixes.
>
> Or all hardening would be considered as a fix, which makes no sense.
>

Thanks for the review. I'll send v2 with your reviews addressed.
v2 will drop the last paragraph and the fixes tag from both patches,
add the tree dumps you asked for, remove the comments, and move the
reproduction of the second patch into the [CAUSE] section.

Thanks,
Siddharth
