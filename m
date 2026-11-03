Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793665027;
	b=dEyYerpcLLZP2WaCW5cWtIxJh+FNK7LTprM+zLQ/lyWtQVnmP33mdUGVhVX2ClkTSYz2
	 dMXqPmbFipcMds6K6ijKhgnC6mWF25ThbZQdLfwqe+dB6WA2H0l+gPsBVdefqLzBVykjf
	 Xa2SvLfcWF4Upp5tZ/AXw48xxNDWIJjNu+eLh5tHWfmcTSMSWCm/r+k+jUHMSWLuzGjSc
	 zMBNCHSY6hl5BF48agt3mZZHCblmUpTR+Af4VhczeI3T/nOjJKgoqijEObbeggHUzuv73
	 7+LuqT/op4CB3zrWCbFnWRxTN76+hZqtdJNd+xD2JdgcK+V/H1npcz/fXBDy5YjhuXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793665027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=y/w61r0Q0N5FeoZRAlF2wxKpZ02g+pV8TJgHPugsmLA=;
	b=f9gfR/wgXLArf0GB7HZhVxiOEy/xKAGX2vC5KMREGJmQ2z0aoEUdL9HBp8Uvbv+sn5+f
	 D/3mpGKrF6Y/HZbLf1JTQcIepeGrLCnZFhnsp8bn6Uixt35ftbIodAxIQc961hIfQl0xw
	 Txqwpm8Q0dwJpTyURKxDu7+6KYRG8M1jheey/t721vZqlmDKJwGEj+jY4Z6PL1y/PEn77
	 IPOg7ljO+UUBOlFqDAtCXLjBy0FmQaLOJIKJBBoorFJBXsHumAjqBNND6xyG4VKCXvS7g
	 HlbzQSGik8rwD7tXGCwnRpa8I18mvxO18HX92MScWpiwPH0D9GTrI+UGvPOGHoC3yBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=TIghWWsc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.50
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99908606A324
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 00:17:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99908606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=TIghWWsc
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6fe4372c5f3so2462080eaf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 16:17:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793665025; cv=none;
        d=google.com; s=arc-20260327;
        b=ZtW4/84NSGfQ7/ZldkFLQRQ4Ih3BFXLWUPQe7wvku90uLuTGg0Rm9EhtBee0EhKooV
         MAqzsakQ0nMJKlZHtMc1ORidcZG/Z5ifaNC5EPHemssP0NQtensHBeeBgZmwqdY+FftQ
         SKA2VJ/exFUb0InCTub7Xh03iArdLfJUnyDNfGxYz6CoudXmXd5JL6vSHQneRip040oE
         cznC8u/NcStgri+YAOB71V3X0LYktRfx9nb8NrUzT7qiUMu8kmFyjp/ydmRmflFROYv/
         CvD3EcNyFMKG3yesqgtdITHeGk1yIrIaRW4kTAzTWuRpZOAMxC841/RnIuK6s2niCUFQ
         s2Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=y/w61r0Q0N5FeoZRAlF2wxKpZ02g+pV8TJgHPugsmLA=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=qeUA5pMtYU1tQxKlCHS/uaphD8csftI6vhrvsuFCdbM8UdqizOl4UnaxLy+dSGBIo0
         4+/ytOGxjogTjPCe1Qxy1BHg0MSgRPttqKv1eFN24ZNllhbRpRv/droAc/bZJJrs/F3B
         Rf5y6T0M7U827P0fNWs403Q4TPi4ckv6VJt8lyYIzzSWNiSIIXCQDUYNr4oODcQ4dpPx
         zxELJvByRLVEzeJAxPnJqNc3RtNeleowJFU4LgHmD14cTIDi28tZhcFiJu2rdWieg1dt
         +GGrBkffRD9w5lAyiCwN1vFKKVrP/ufuZ4TBQaOCf3Q8TQ4XjQao+Q5sPOgtVTZT6xMy
         3TZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793665025; x=1794269825; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y/w61r0Q0N5FeoZRAlF2wxKpZ02g+pV8TJgHPugsmLA=;
        b=TIghWWscJji7hC2wmRZ+zJhUwU/XVC/8lmV+uhcdFzU+SfSxiiBtj9IMXKZaSe81of
         DvQrA0+TfdqoYlUTnUIzRl9dGUQBXYS/OXKvsanHk8XG+YQSLfyeHEgKDpOKjDY3zYSB
         6xusLUkYc71Wi2qN+YQJEA5/sNF+bYc1uWvIv1FYTjzZgCtjTGTqdVUOv3jZzi8NrQR3
         OG5YeU1prgdtUmh9nehUYAcQe5xsTQADL4zDoBMynORGFfwS48/bxIR1ynBAlu7J58bq
         PVgMnz6TOyobHV1mPXwvf1dQIQH9ekMJwatWINhw+5EosgH26JJaFOWyfUVWG7rRi16U
         rXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793665025; x=1794269825;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=y/w61r0Q0N5FeoZRAlF2wxKpZ02g+pV8TJgHPugsmLA=;
        b=EsjbY5p5qzxKJPyJ1Fn0eOWy9A8G1Tv06B/TiEkJm524h3O9K3dEL+YZrp2WX1lNFE
         2FU5v0IgZ5871YRZiPSIW2k+0i51yWI5f2bkrtwpqtYUYQH69/5+yNhQUIuN1L3/faF0
         FPAwHfNEXqNzDf1NAXCABHu1uOW8mhV1Aqx+ecc5Lb1y7+jLJ2kUM/+mIN4Ka9cnzecT
         HInOLkiNkZBq3uEO08x16Q48B1uI7fs4WXpT2VJHCQqLjF1MIaGb1gvCtal4C0+H42sF
         jTmFdOtg2lrO52YX+VkWZr1voFRvQAM8XHMDJ+AhSPx/0+S3aH3lAYFYKlFXsL0sYBa5
         3/OA==
X-Gm-Message-State: AFq9FYISjNn6knMZc143yLgcmwMo9dsytrxezabrdLtj5XxOPUmOkhSz
	CXIdI1lhJlj9cg7DychHX/YpWNuxcpRXyPglKwYjPgkvLOoLsbPu4LocqC5uPt1QFbhQpaFJn6p
	4/9VCwEY9H1JeluDitF4g65Ync8IUhfiP3ZLEUq6xtHGK/vXfpDfDV2/Dohs=
X-Gm-Gg: AYBFou1KL1CFlw5v+1s1xu3bAl0nUa7pXo5wZ8Q3uMxvGjGYimgG3SLi2BRK4WWeCRP
	UIs9qUdAxaKYfNiHg1CBCa7N4x5BZQmYi6RO6aV+tUh8a3yZtQ0dNbxfYWhhSysPXmSdbcUAKhM
	lK3hHO33U6ZN5i/oDra6AAFkYXTiFCjPbeYUPbnasmnO/7syqF/XFUfZCo92Nu+XNRqAASrePHs
	FKY2xeLXLCkBm9okB4+7/lU2Dv0iN9qFgggJxfgFk0ZFp9fI96gNGqofIgGfG8wRHra6FSg3jK2
	v1GWNgZsMWCygEQviEjcbnXgX2N/2pnmTTDtSaGRTQXIz/NlGHt1J/LKglUa8dLB8ak+vBlECMm
	hA8uIMXZ74cUuLP/b4BJQypTRjO/WBTHYuBAg7w==
X-Received: by 2002:a05:6808:f13:b0:4f4:813c:6a21 with SMTP id
 5614622812f47-5640dcb87admr7653299b6e.20.1793665025508; Mon, 02 Nov 2026
 16:17:05 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <7350d541824422978116bfb536d2c7bc68cbb826.1793664043.git.wqu@suse.com>
In-Reply-To: <7350d541824422978116bfb536d2c7bc68cbb826.1793664043.git.wqu@suse.com>
From: Siddharth Mishra <smish149@asu.edu>
Date: Mon, 2 Nov 2026 17:16:54 -0700
X-Gm-Features: AclHuK9qCr3dDvc04IEheNLz55h9Od5dJ1GmkGysQ5vvyTen6KlKg6UeLolR6wU
Message-ID: <CAKpDGtmO8v3Ny1vKDhU_4oUATTaL8pE5CqWusy-Xt65OttAqdw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: return error immediately for btrfs_validate_super()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 3, 2026 Qu Wenruo <wqu@suse.com> wrote:
> The function btrfs_validate_super() doesn't follow the common
> tree-checker behavior, that will immediately return the first error when
> something corrupted/unsupported is hit.

Thanks for taking this over, I won't send a v2 then.

Tested on btrfs for-next (d6f76ca0a70d) with KASAN and
CONFIG_BTRFS_ASSERT=y: the image with sectorsize 4097 no longer hits the
BUG, the mount fails with -EINVAL and only "invalid sectorsize 4097" is
printed. A clean image still mounts and unmounts normally.

Tested-by: Siddharth Mishra <smish149@asu.edu>

Siddharth Mishra
