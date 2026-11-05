Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793891972;
	b=oy/08ILHu7ly/GsHQme41P2oYu7Q+wmivwTQ0HfHhzqaLzQqvxrn7TT1/CYAb8SktCmP
	 ObRXqIsvxdscHFyqlplhmFqfc/0Gl8f0CZjLRRcN8ivcFtJDwqfNoxaaacJRSXKoUcsMD
	 IN7eBNYBgrWCv9zuY5OfZoAj7bjuOVnHMHVeRuvvktYXDTIa6LklrC6/12Rj8mMPR0Fkr
	 pT0+ay4FjKd1UHSOI4i3QZxgo93KW9dONYGzKiLvfCvK0rY9GaDRzTFChqbGWFn+3LvKS
	 Y2q9kjNPjs3a0Qwr52Mo6oL/nktJCx10jdmWsiF37ubK+vSz666nAl1Ns9dFVQoEb2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793891972;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=ATOVBVbX9QJsuVPL48Ok+eSuu/QLECfR9OodEspE/Fw=;
	b=S8YDUDeJs33DbeBF1KwS3VL43jynEoYJ1TwOhCJvElf1+F5cn+97xUuspkdasYJ9T+FR
	 Z80ZIrROON689pubfUMINqtl/noGILw6DxfXUcegbnTo5PI77xNJmOuju+g14YpXySwjw
	 Nm+cMJxtPUQ8BHX+sZ1bTOkqZtxaIIoTVbp+iG6rL5Ko5Z78EJWFwJsq5q/VsFtWasjl4
	 16Xg6upBmUogBAaLKyunkPoEv9aqRgTeYsqx3zQU0wvfqGEzCOf1NRDJxXkjfmgytNALz
	 EwwsxUG0GL5EMtFtYAWkSY4Z9H+rXr032oFYO657LnmaqGctLzTeiP6t9iRZJZa45mw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A1wnbIw8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80DC606EE86
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 15:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C80DC606EE86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A1wnbIw8
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so1154619e87.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 07:19:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793891970; cv=none;
        d=google.com; s=arc-20260327;
        b=lDKwOBW2dUsTkCjn1C/0lPL2Ku4pqlgbdF9ScYwdJx6fJe7kwxA9OqDFcFhrOw22As
         FLGsnaDavmiQIxbUzUGF44gxmhNnj2mmpGoDpsr3dAoArYNW45UyuOy7VOxRg90BCd9K
         78N3uMqmufhECrAJBbkphgMrnKV1vBnj8YFbdCLih6C8XkKJuZycsluFTGv2TkV8pv4m
         tJEVEQ8l5ZXiavl5SrAXvskKAZ132mxLpJMF3s5pRDsIft6QDTzCKu4z9KE6tge2gYZn
         vZCCyLGIRdLH/aSpjpsjgYhO1xS5n+ZFXszPDmOT5N6XeIxKd3eX/uBphjkRVfreDlyG
         C7aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ATOVBVbX9QJsuVPL48Ok+eSuu/QLECfR9OodEspE/Fw=;
        fh=XgyVQL63bakpFfKqPxJJiY5NdZTbMYsxaBXyIXgyd7w=;
        b=e59qCJwZRe/5uCPOrI4ch9iaH6eZbCmN1IxOsCij4hqRdJcRh55cfupAW3HVTUN+mw
         ya8Ha+4+J1nIa84Mug0iLCL9GWlSIG2YYE0Vs9Ct0SdAJV2te9NSO/oRquZ8d7tbSyNv
         GGEEb+9JGcSNBdfJ9eZTM3j28jwA5Al9UZeDr/N0CF5/w1Chq32rwoHMjCvjbE+e7Ck8
         9JJGqOUGGK2Cf1xkYK1y9L6qZEwNUA/pXMsKaVExYWRv5lukXO6vVcGRRSZqrYrKbfOW
         ojMCqsmMHnnrTTrSsOAM9FbfLCpIKAVyk2V/YowNsGl+4SHIF00s7Pg1pboVia59Jhcy
         /70w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793891970; x=1794496770; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ATOVBVbX9QJsuVPL48Ok+eSuu/QLECfR9OodEspE/Fw=;
        b=A1wnbIw8WV/IxHvkVL9vwr7Y4VI1iDD2ZIS+9RUWI2sjwWvsMYAI88tFSJAto07auy
         o7XsRBS7L+5tXxPC9oegc0U81k6CXrrCytyv0pdy4jqQqnq3k0x+nCeey1EtuGRgLoVb
         uqS88NqaFVRDCtqDksJXn1tB8BuLSYf9LLrpno6ClJf7PhJ9SlQq0+GJBjQln+uG6FqS
         odrFIHuTmYhot3fvttJY7ZAvrY8JfHI7QTO9AUtSFuaMMg2NXV7bDD1iBaTRwz9mCgdu
         dny8cFvlrHl0mq4oDM1psjOdf5Hss5P0l9vS4cdatZ5s4ZRVQDojb34K0J3qzF5/J9lq
         mQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793891970; x=1794496770;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ATOVBVbX9QJsuVPL48Ok+eSuu/QLECfR9OodEspE/Fw=;
        b=Z2eOi4N8U7ZtKLf+atLQi6rXKyHY70L5/JuuZM+jd2hVmc1WfK2thREJrLh+tEEi8x
         drWZH1m1TpzeS+Vu8WPZWkc2V5jvSJEFfwupetsmuG2VH/c9F6gmRIlDqsDmH2rCdfpc
         R2hcJgKUAsL9ImUoX255Y/ZMzUi8iwm9upAH/31UaJUf0rTPSsvKBZlMXT+nMZUladYK
         CEVCGCFMZW3n6JDAnF38HubKuR5gJFb0oAzMJLfBo7bGnAGfcd5+WsMa78AbZtuIpyCS
         lw4qlsAMxWrBDvqymPQPrv9q2UJwGeLOo9aJR+I7FOLcUaHphCwE0phIuS/e/715CPCR
         dEPw==
X-Gm-Message-State: APuU4Z9ueDz79cvLuxyQbzSNvCUCSjcLH25h0vO80+zL/nXYISFL8KR2
	tcw6HuiSHBjVjrUGMJtyj+2FhSUPJmqWF+Nua5nhg9M+0LrDjD9darqKyIk0sqjWJlNof+ST6Ub
	mvpZBM8/o01Bt6f5XCh/m5AvvS0YRviH8pw7d
X-Gm-Gg: AYBFou1kfKLa0w08lbJDzyvgNQ3tcGLPpnMNdVEjfIJWH7JpJdUqhShEU82Yggdzb8/
	jCsnlLZQGDaz3MgWzUC/PbdPMAkWEdju0pfmsFZJl9AVDaHUi51eV5urSxrKB2aKYBrMZKmu1kw
	WS8dA/H8LCSlj438QslVKIvx70i/huynC/WjQmw1P/Js+JOIdNhyCY5Kogz6DiXh9Vbe/oVDS7a
	IHkYES1EUcHbdok+H1842uFh8gwVEavgEQM6GqsMLwwI7wOR88byQlrBw4Z42QLau6C1syuqfIT
	4GkH0lqb/b9JPYNxG7dcE6QM8eYDlPt4LszjTI8QOawsWQVzWTNvO5TZTsEdTuuCCrI9wHq72qV
	w36UUwfNxf5SKiZB4bQtNbiie6vHquIg+0t+WeSl+l2j7djsADw2sEP1i4Uix/qoBEdP/1GZsTE
	KGM+fZm1QBvAPjNKUv5kj8ak2r2DzZi/CV1nP4uGjoUqEcpkRJdEX+IZ1tcizA8hIqAUmIuw==
X-Received: by 2002:a05:6512:33c5:b0:5bf:b994:5f91 with SMTP id
 2adb3069b0e04-5bfd9562cf1mr6999416e87.15.1793891968735; Thu, 05 Nov 2026
 07:19:28 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
 <ca6f02ee-8b39-4e90-9006-a6f0606e26f8@wdc.com> <CAD=K2o_-NwLNpvNE+OreAmsvX+izzZnb2R1nCBV0gDf6fH=kmw@mail.gmail.com>
 <904615c7-003a-4158-922d-c57dee9a3ecf@wdc.com> <CAD=K2o_vLPSvm4Qzi8y4t5ay+Na9GNk2t5a3iMO3NYJvwodKDQ@mail.gmail.com>
 <CAD=K2o8xFgYBHMim-KqMysV+Tec9LEUbo6jfD6R-GOAU8N8K4w@mail.gmail.com>
 <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com>
 <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com> <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
 <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
 <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com> <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
In-Reply-To: <8d2e8334-8a6a-4bb9-9c78-a126be7d94d1@wdc.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Thu, 5 Nov 2026 16:19:16 +0100
X-Gm-Features: AclHuK_duarjdbotrIdqTV2fYE1fb1HOAX6Q2Qz4wIILKkry8pb7u4cqMZyjRTA
Message-ID: <CAD=K2o8CTZOPQ1iMTi2+zirKtQdY3bS5Dz9KMAamyid6Lf9QbQ@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

sure, I'll leave it untouched.

I had sent you the full report off-list as an .xz attachment,
I suspect it got caught by a mail filter. Here's the condensed
version instead.

Zone state summary:

   1918 zcond: 0(nw)
  30387 zcond:14(fu)
 159343 zcond: 1(em)
    128 zcond: 4(cl)

All zones that are neither empty, full nor conventional
(line number = zone index + 1):

4097:  start: 0x040000000, len 0x040000, cap 0x040000, wptr 0x001ad8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
27890:  start: 0x1b3c40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28076:  start: 0x1b6ac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28136:  start: 0x1b79c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28152:  start: 0x1b7dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28273:  start: 0x1b9c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28275:  start: 0x1b9c80000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28318:  start: 0x1ba740000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28319:  start: 0x1ba780000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28372:  start: 0x1bb4c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28376:  start: 0x1bb5c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28377:  start: 0x1bb600000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28400:  start: 0x1bbbc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28435:  start: 0x1bc480000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28516:  start: 0x1bd8c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28524:  start: 0x1bdac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28556:  start: 0x1be2c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28641:  start: 0x1bf800000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28642:  start: 0x1bf840000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28649:  start: 0x1bfa00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28721:  start: 0x1c0c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28727:  start: 0x1c0d80000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28728:  start: 0x1c0dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28752:  start: 0x1c13c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28895:  start: 0x1c3780000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
28957:  start: 0x1c4700000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29030:  start: 0x1c5940000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29308:  start: 0x1c9ec0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29331:  start: 0x1ca480000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29332:  start: 0x1ca4c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29395:  start: 0x1cb480000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29428:  start: 0x1cbcc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29432:  start: 0x1cbdc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29450:  start: 0x1cc240000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29528:  start: 0x1cd5c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29690:  start: 0x1cfe40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29696:  start: 0x1cffc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29705:  start: 0x1d0200000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29727:  start: 0x1d0780000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29792:  start: 0x1d17c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29885:  start: 0x1d2f00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29921:  start: 0x1d3800000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29938:  start: 0x1d3c40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
29939:  start: 0x1d3c80000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30029:  start: 0x1d5300000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30038:  start: 0x1d5540000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30081:  start: 0x1d6000000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30083:  start: 0x1d6080000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30155:  start: 0x1d7280000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30156:  start: 0x1d72c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30196:  start: 0x1d7cc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30291:  start: 0x1d9480000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30307:  start: 0x1d9880000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30355:  start: 0x1da480000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30410:  start: 0x1db240000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30524:  start: 0x1dcec0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30538:  start: 0x1dd240000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30576:  start: 0x1ddbc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30637:  start: 0x1deb00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30720:  start: 0x1dffc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30754:  start: 0x1e0840000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30764:  start: 0x1e0ac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30861:  start: 0x1e2300000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30939:  start: 0x1e3680000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
30961:  start: 0x1e3c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31006:  start: 0x1e4740000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31007:  start: 0x1e4780000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31029:  start: 0x1e4d00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31160:  start: 0x1e6dc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31161:  start: 0x1e6e00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31218:  start: 0x1e7c40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31219:  start: 0x1e7c80000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31226:  start: 0x1e7e40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31280:  start: 0x1e8bc0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31281:  start: 0x1e8c00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31375:  start: 0x1ea380000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31478:  start: 0x1ebd40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31632:  start: 0x1ee3c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31659:  start: 0x1eea80000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31660:  start: 0x1eeac0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31711:  start: 0x1ef780000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31783:  start: 0x1f0980000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31834:  start: 0x1f1640000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31901:  start: 0x1f2700000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
31966:  start: 0x1f3740000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32010:  start: 0x1f4240000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32028:  start: 0x1f46c0000, len 0x040000, cap 0x040000, wptr 0x03fb00
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32050:  start: 0x1f4c40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32053:  start: 0x1f4d00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32118:  start: 0x1f5d40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32119:  start: 0x1f5d80000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32121:  start: 0x1f5e00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32156:  start: 0x1f66c0000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32261:  start: 0x1f8100000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32312:  start: 0x1f8dc0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32330:  start: 0x1f9240000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32331:  start: 0x1f9280000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32365:  start: 0x1f9b00000, len 0x040000, cap 0x040000, wptr 0x03ffe8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32367:  start: 0x1f9b80000, len 0x040000, cap 0x040000, wptr 0x03fff0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32393:  start: 0x1fa200000, len 0x040000, cap 0x040000, wptr 0x03ffe0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32394:  start: 0x1fa240000, len 0x040000, cap 0x040000, wptr 0x03ffe8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32441:  start: 0x1fae00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32442:  start: 0x1fae40000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32444:  start: 0x1faec0000, len 0x040000, cap 0x040000, wptr 0x03fff0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32445:  start: 0x1faf00000, len 0x040000, cap 0x040000, wptr 0x03fff8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32446:  start: 0x1faf40000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32447:  start: 0x1faf80000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32448:  start: 0x1fafc0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32449:  start: 0x1fb000000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32451:  start: 0x1fb080000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32452:  start: 0x1fb0c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32453:  start: 0x1fb100000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32454:  start: 0x1fb140000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32455:  start: 0x1fb180000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32456:  start: 0x1fb1c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32457:  start: 0x1fb200000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32458:  start: 0x1fb240000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32459:  start: 0x1fb280000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32460:  start: 0x1fb2c0000, len 0x040000, cap 0x040000, wptr 0x03ffe8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32461:  start: 0x1fb300000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32462:  start: 0x1fb340000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32463:  start: 0x1fb380000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32464:  start: 0x1fb3c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32465:  start: 0x1fb400000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32466:  start: 0x1fb440000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32467:  start: 0x1fb480000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32468:  start: 0x1fb4c0000, len 0x040000, cap 0x040000, wptr 0x03ffc0
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]
32769:  start: 0x200000000, len 0x040000, cap 0x040000, wptr 0x001ad8
reset:0 non-seq:0, zcond: 4(cl) [type: 2(SEQ_WRITE_REQUIRED)]


The full report (191776 lines, 24 MB uncompressed) is available
if you need it - just tell me how you'd prefer to receive it.

Thanks,
Jochen

Am Do., 5. Nov. 2026 um 16:05 Uhr schrieb Johannes Thumshirn
<johannes.thumshirn@wdc.com>:
>
> On 11/5/26 2:48 PM, Jochen Philipp wrote:
> > Hi Johannes,
> >
> > small update: my distro has meanwhile shipped a new kernel,
> > I'm now running 7.3.1-202.nobara.fc44.x86_64 .
> >
> > I haven't tested with it yet, the fs is still mounted read-only
> > via fstab. Should I try a read-write mount with the new kernel,
> > or do you want the on-disk state left untouched until you've
> > looked at the zone report?
>
> If it's ok for you please leave it untouched an send me the results of
> the zone report.
>
>
