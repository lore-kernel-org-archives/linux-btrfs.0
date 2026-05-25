Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC2B35C1AD
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779739767; cv=pass; b=g1qnsHkhNb5p80YcuBU7OlyU6qlrz27y7a42KuEcISnXZDiOs49vsk1v/W367RoMPr0sO1Ur7SYyhpy2bX2u1wJF29ASqPOhpUkBnOqVfn3QzzGvqxXmYwAxgIqQyos5F6nP5pfZiCxJ1KKGdYn7gR6vk23P3qr+6FrkKGaFmdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779739767; c=relaxed/simple;
	bh=Ny57PvF2PVuoXfKPhSrVu3LNZCXN3Y60lrvBU6Z7Ft4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WNkeeJfpUEN/RzRTr/2GM7SWmqq+DgRWknhx22qEj/3wvftHaXLticLrXAceR+vy+9tKf2Yzy3EBgyEgOFytJSBkiEAxtPZ/WhNMQ1ouUPQ0LLJIuJ7tSo24fSjBaeGwF40VB3Xxqmt8MSBygxn+XiVuT2jpt4Qi4TJwvg+iuIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6atx7nz; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6atx7nz"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7c7fc722b50so75580287b3.2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 13:09:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779739765; cv=none;
        d=google.com; s=arc-20240605;
        b=PCN92+sLVTVALLg6v1gGNA642nsS3ptoecvaMX0kdSIxE4gwIWOj/bmtwRup05dIac
         FPkXJbfY+39vuTom55Os2AlCLDNin/yhh/bjqqPV1/0Uk8NzCxeuA2KRFb+WtmcafPAC
         2jiUL26biB+QxD7A64SxODMlBj916kHBcNVWOXilzTzIChUSVM37DrB6uAfXpoSuOpkq
         Of/7BuCsfQKJ+lypBPTTamQgo1dqEYOBPDW9wo1SDj9ksSNeFDjW/lFdY4zpHiF9+JYC
         IxkDqZKui3tfCfgjSrXPVAQ3iOf1Z34pOCy330daUBpcuAs73VH+jdErih1+X5xiDt0u
         VeNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=d4XFM809e9oCG9uYtc/8REQMTTHh7XwrQ5hnfUji/Rs=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=gV97m6ZP7/sOPrM5L/msvVaXkgsTrOWAZpAwK+zB5ESSLe11lB4L0IWpu+Ujk2vq+2
         236Zwt4TfpSvXu8qwhjvKVSABZLoggdvE29EhL+alyaoHqDczs2Elosr+bZNAGlkspEc
         V7Ckggqp0LU42jByyVhEx8R2Dv9uh9jqxwggpyXu0yixIAX/D8u7KkljZUyy8zkJlKhe
         u7tc/cmsfxhH6ynNh0axO4BLdm0lEpCxfC6UfVXeJFEDUYtcERNB3svqqdqoukEXW18X
         K0rp8MJK8n0PwKLyc2/J2ADeElY6IVChdHV5BciP021Rrxktm6GNsuIqjbwCqcMGIxig
         hiog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779739765; x=1780344565; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d4XFM809e9oCG9uYtc/8REQMTTHh7XwrQ5hnfUji/Rs=;
        b=W6atx7nzk7D5kBPS7IVQffWRre0PBcQgXTaWODVNccVVznz5xbKJwp4GRoKnqqjSvj
         en2DGVx3zSXNFR0If3TlVAx3SCk1ktRM14Pgr1Ib4cbHv0h5G/DyBF3F+2QUjTwIK79u
         XsqcGLvhNUC9z4m52AyYQHcDaAVVkMm2JWF/DlzP4Ey/ocg+s2yKj+42l7snznR9jodr
         RzI0cdNTmQ+4XTe/JTwJbJAs5SD9iP5UYg9cYIAdMzaX1SJDBvAiTZFXYT59UyUKvNAG
         vX1Ms4xxPPlcs17Ctl08K4qWEAtbvshDwaKz+qfFmHiHEqkejNzEiGJbKKAHkkxm/hhy
         o8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779739765; x=1780344565;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4XFM809e9oCG9uYtc/8REQMTTHh7XwrQ5hnfUji/Rs=;
        b=bLQZ9QXtjxvKAQlP9yaWMlisHNTf7h87rAIURisqvHDtfd0DQShHYsvq0aPL/OGXhV
         Dgv2EevBmWAK78eThIrgS25mimMWS9mep+JUKK3anbbsDrs+BQVjXK0zHKonsOo72ptV
         Rc9zXNXrA1gdtTiANd5ihGm+Z7tSWtbyGLl5x2CMLdGIZKGvFiTYaj4088HaA8qt+dcD
         lOiu391yB2iX3ltzsD/Ou1rg0aUgCnf+YUGYZ45SJalXTvQ2rN5dbzs3MDTl/KmM4M95
         bHI5EGTJaTPjQLQmm/h/chZ0grZNW7774dXum3v5YiBTRuNsk8u3sesTsEkPOUc69v8h
         dULQ==
X-Gm-Message-State: AOJu0YzjjtGeM7ATsHTBAvLvKlIcAXUIi+QoTdLm0MusAh8L71Fl766J
	S8xu6PkhXgDc2o5+01aY8pmZSuLQf/DExHxCJoBECz3No6dzdGZpLm/xl2UdEVPdXzkgJ1BBjlG
	L601MSD5v/Nrz2cMdVonbxP/XiVdI2PUC4L/SFT8=
X-Gm-Gg: Acq92OHGwoNjmtNaACeAfW4208IZ0xZo0UcJZ1qHwmBwBCvRn/POfIdZDOuGHD1y0TA
	c1C4hnXdanbnMW0IsekO5glREDX6sRk6nV+XpuiKXUnbrZSVP0zpRua9z8wUiBqNwdi+Vq2wWXX
	QEeK0Bp0Ah+FM/Lf0GQzZUXgcQ+FDlgLVUgWje5Yex2797ZoHv1BFZJ2mlIJ0nWJnds5SSBYcui
	Q85zc0gvoMiwuPKH1mYbNuN8YurBnxQPgwIsiYymcaLA+7oOOogCzHuYmEbnLJcoGYd6QAh8GRA
	21IsKgT1YMzU+GWY64xGPX6QpLmTdIdUjLZRAxASbEsyy7Vge8k=
X-Received: by 2002:a05:690c:8d02:b0:7c0:de77:f479 with SMTP id
 00721157ae682-7d3335f0df1mr142460137b3.6.1779739764703; Mon, 25 May 2026
 13:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Brian Thompson <brianbthompson@gmail.com>
Date: Mon, 25 May 2026 13:08:48 -0700
X-Gm-Features: AVHnY4K4Hl5AJ4-85JhoQgek2w6Yc2YXN3NeYPOc8tdVdTE7jQwH9qeb4_X6KWg
Message-ID: <CADcHvwf1-hdAkE=kOJO0AQkr=8=si3X0jc8Jrrctc+_YboJ6fA@mail.gmail.com>
Subject: I Need help. can't open btrfs drive after power outage while copying files
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi. I've been trying to recover a 12tb  usb drive that I formatted
using btrfs. The drive is a WD 12tb USB external HDD. I was copying
files to it from a different drive. The problem all started when I
paused the copy, and then lost power on the drive. Now when trying to
mount I'm given

BTRFS error (device sdc1 state ES): bad tree block start, mirror 1
want 1065746432 have 0
BTRFS error (device sdc1 state ES): bad tree block start, mirror 2
want 1065746432 have 0
BTRFS warning (device sdc1 state ES): couldn't read tree root
BTRFS error (device sdc1 state ES): open_ctree failed: -5

I've tried mounting with
-o rescue=all,ro
but, it still give the same error.

I've tried running various btrfs check and btrfs rescue commands to no avail
for example running "sudo btrfs rescue super-recover /dev/sdc1"
results in  All supers are valid, no need to recover

I'm at a loss, please let me know if there's anything else I missed or
can try. I just finished making a dd backup of the drive, just in
case.

Also, i should mention I'm running CachyOS with kernel  "7.0.9-1" and
kde as the DE
I should also mention this is a fairly new drive, and should not have
any bad sectors. (smart status shows good)
