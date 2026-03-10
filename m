Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B010626A1B5
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132118; cv=pass; b=m4pDa/5Sm1MxESLCkgvR2T2Js4ZkuNWFleIa7XmeKeFpQHHee71yOVWFkf6u3996C/VIRbvi0tAd/b5GKyEGnrFQ5Hq6YEVa3fcd9a/SLXimZlUllJena0E5kIOe0wZX/fBIttGcDzec3rLPqd137R0WTEtncTNflwmcNxXocew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132118; c=relaxed/simple;
	bh=eDSWPCbwxBzo4De/D6dtfMarcGEIAzAKbz8L29S2nKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ADGAhSaZE3/+hdo7j+0M561rfqH3PbOCDbPo2kF9ys2AFz7vLd6TPPUGLxuZ+Y9ZxmGC8+1WKPt9Qr2KnOhgCUEVbOvdxmzWMIZwwA/F9TOAZrkmgukT5XFfQZtD+LmytI/WkBiqi75+s1spKydEKTMH6m7Fh4EjSv657O1s8sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pozq2Wei; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pozq2Wei"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b941bb3e23cso762796366b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 01:41:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773132115; cv=none;
        d=google.com; s=arc-20240605;
        b=TvMvQZNBDr2Z9hvlIBc2Q11DRQHpb1L4imIQMJsxBuExZ4PdYsJzdqlSaZ9kqM9pld
         bNIdE0oR8JW7kq/FIyT+rURDT/n5uzjXC/pVpBxybGE7zr3JlXp7W+bEHU1p2EgUfN9T
         XKJO0meehkAWiw5vlR4iaalQ1/mvKij9Qi8LfCv8qRzoQCJ6GhxXE3XE8d9R5ZPY/CO1
         5yL/i1h5yL4t/W5YbmgdtkfquAbdjET8HjFfcA21rjc4pu4lqFF0PdEhC55zYFt0FQlW
         MGMt9MykOFpFHOCD8mrehcsSEPn3si2x/7iC8V1cSJus2mz0FqtckHDVKF928zH08T4m
         VEng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tcHneVAopfvC6QrBV1mtbNtLaENsIGFUlG2qWEyDgec=;
        fh=8jZY04UmseQRUT97drUR/R9FjWScxTuiBtugywDNwcQ=;
        b=jr7p8UebkDZf7ZxU/5vLKZO8uG87Dxsydu/lDPI7gmW1SNc49dAgfgNua5Nkcg7y9F
         ukIPwYpSR+pRuM1SaygEDtTgFq4w4Zz8lONkCBxRbyN6SdJpAmBUEvoUGXaSfemDJuXg
         yAn+4rmuO9sibrXju4+9YS92/SIZCimdNUvQZDOEoTuN+3vVzpqUPeqO8Qgh/Xmqy/mp
         gKZKlBIwYhFJ6PREaV3ZL4iyAzMGRnSsc2L3kovOsm5WQo+YrekJQvUAQFi7xgKjDWLc
         FPHbuilFSlE5B/rRTXVrUe5Fq53q3Gl0/1+8RrI3QLCHynbl+mcv7or4r62qDQ7t7H++
         ZPVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773132115; x=1773736915; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tcHneVAopfvC6QrBV1mtbNtLaENsIGFUlG2qWEyDgec=;
        b=Pozq2WeiKfChyXk3ex92JwbqnxDHNpHr1yfu6eNn3cz2TssemkyL3XxjZ8GHdu9Dkt
         gO5mlQJmb6nptT/oTXCsMtQZ0CZup7tVndaMQiIp7ZNby5eiD3wNQI9n5S1OrR1p2k3e
         qZ1u4wIqgCHZlp5Auy2lNnTmSClhFxuWuJslzD0yVTLoNnvMRGC+CZ9hzYy5D6GLnyJL
         hJPgx/LR3wzgd++bvIVxoHApj+gHGuZcry7icts/Wcu4kfvt2g2pfI2c5W81usFUeYOY
         K89qbA1l98CO+NF3NnDWRqcjreWX4MwYcI6FIXaRbBUjQB5W0my2My3Lq9VXBheoSUMf
         FzIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773132115; x=1773736915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tcHneVAopfvC6QrBV1mtbNtLaENsIGFUlG2qWEyDgec=;
        b=H8gVfs5iRCAmQWpuxpEeFhkTjtLZrsgfsRApShkWtX8o4fE+eTCpa1IAJi/PJlf8P3
         PAA7zREUw+qDfmJMQc5euh+8GwNPJxw5S3oEQ+f7K26yx00Abm5oe7OWRtlL5P9F9lIT
         3t+FiyggW9LZUfIlkbKeNyf0Ka+x4cH6RXE1PMjZRmn8kr/wKe4145A45S8LSzucjORf
         FU+KRwMazmIoq7NMklBLesrl5LurWSy4rxD5DMDIbkSJhsEtlMlmW0Zq7wJGf7uyNvdY
         ejCeth/N7/fFZNde74QJ3MxiwxYDHPR5DxfhAx7vvzBMWD+hpR85FksOrVHLaygh57ZR
         A3vA==
X-Forwarded-Encrypted: i=1; AJvYcCUhR2ifJTpXCi702GyaBEx/xxFST9hgvhtpT9IwY1PCMuLDEETGSWpxcvb+1UfrJQj08nKjF8iXKNpKyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyDer1vMiam9TffRi7CyW36bh2MjZxNH6ykS/pGyl6Z42zvs6O
	209OvSOHGMkvfKvOaEz5ZOtO8XLyMYkugYpQfx5nclKAm2qIpiLqpqX8FSSYvjQFDVbzYot2KZx
	xvSqRbfTa10pnvKG8mkDiYetNKg1iLJI=
X-Gm-Gg: ATEYQzy3lWVeTnvGZod5K6ixfuP9v1gO1SgiqwSxOeQ4xVsX0YKmRj9gYSJUJ17WDxE
	3gqSgNg5IJ0P/Ajy0El/Ze9hQU8GELUZlvJqmCidalZe1qgG4xr2Zjx38EOcSGMGfr+OAriwUw1
	5ntCZAnHFhN4aMb4CONay9eizFWP+z2moxGz6VXyXI2wOn9Wg3JvujL1oWp3Vts74qqkh2G+uCO
	Z3FHR2YjcD+/eTze0j129CQyssfbX3C/9meqLEE/afDzWnF4//7UtssilA5QutwNP0RVOxT4I+L
	jfAhdlWMUG1t/YOz85yZ92zj+tMh76RA/qmYmG8N7wCX7LED200QEr3whlJ/FMoMj6dWlxrR/Vf
	kLwcW/oGBJcAq+wlt+nc45A==
X-Received: by 2002:a17:906:4fc8:b0:b94:25b5:2b52 with SMTP id
 a640c23a62f3a-b942dcde31emr782688966b.27.1773132114793; Tue, 10 Mar 2026
 01:41:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310075447.2088205-1-gality369@gmail.com> <19e81a86-a8ce-42df-8cf7-da74205584ce@suse.com>
In-Reply-To: <19e81a86-a8ce-42df-8cf7-da74205584ce@suse.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 10 Mar 2026 16:41:43 +0800
X-Gm-Features: AaiRm52HhZz3j4znZQsuhdkwjJzg2SYK8Z_mFutGffEHv2kfRcHu3qiVx8J_a08
Message-ID: <CAOmEq9Umi=3AA+0DkmHrfFjj2hBnkq4xGSFdfS40x5F7DpEtuw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: reloc: unlink orphan reloc roots before dropping them
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com, 
	zzzccc427@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 4:13=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
> >  [...]
>
> Put this important info into changelog, and this is not the first time I
> or other reviewing asking you to do it.

Thanks a lot for the detailed review and for being patient with my patch
submissions. I'm still learning the kernel patch submission style,
especially how much detail should go into the changelog above the "---" lin=
e
versus what should stay below it.

I think part of my confusion comes from seeing many patches with very conci=
se
changelogs, so I have been trying to keep that part short, but I may
have overdone it and moved too much useful information below the separator.

From your feedback, my understanding is that the changelog should include
the essential root cause, the fix rationale, and the key crash symptom
(for example
a concise KASAN summary), while the material below "---" should be limited =
to
supplementary information such as full reproduction details or longer
logs. Is that
the right interpretation?

If there is a patch or changelog example that you think is a good reference
for this style, I would really appreciate it. I'd like to study it carefull=
y
and improve how I write future submissions.

Thanks again for the guidance.

Thanks,
ZhengYuan Huang
