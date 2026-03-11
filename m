Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2F282F29
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 13:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773235364; cv=none; b=ALBlnemYyTcYEPIbtLiwI/bwqY+FBjtU6uB0is9jy41UMPaXd5Bkxb0tYjg3ctf3N3vCOpMQmSy5K4EC3rfcd0NXbTjjgu8Z3bLBVdjckbqfpmx061Tg3JgmZwuIoIw6WXXybmAwZQBk+oUnxTrw3B/dKzaaB1ugVm1voNk6gbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773235364; c=relaxed/simple;
	bh=bQRlE5OR+3/41N9B/xBGXfMeOTv3hgeQ2WrY6jcTpBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GkM3fUACjRLRoaZiM2ac7Vb3QCdR50jSq8+a6aiu3Ol8cC/dyHbzirQtGEtD1Dvaj3sZUrn6ZOCTXaxS/ZeUZxSQ0piz15lfYCCHFbbwcwPuT1BhjdCj4cfPL6NcbtvVi9JY7H3LsIDCPFtyVoT5xHa7QyRVKbE7KZRskcmjOGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5ffa277c115so4958383137.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 06:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235363; x=1773840163;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=voAHzau37CHeZAyT/jaTR06LJfl3El656VMw5Cu+UsL85BF2OOlp+MnFCarVZdGTsk
         z0b+deDd3d2chphnd/DyXewufIEIF9j5dCalZ1HuidMm3HxbuJjyxk+dFLZW7bExFaeH
         mpBWLiHxNZ+5pDLjy6GgY9xY+ZFwnQRsZohbveqHkbvrYfcJSd9LnBEK+M3k+J7FOBII
         FM71PH7RUfWaftwJau/J77n5k16j1q/cXHrhDgSlfXYqBRErtpZck9i4nzYQiPzueLUf
         eIuPHYUup6mKiRLp6ttbbKXw8cQgZ1YloGthvihoHS3MiYNIJ/T1BteBSH2QpBpwS85k
         gv7g==
X-Forwarded-Encrypted: i=1; AJvYcCUtwUkQVyIMpRfTJX9HtfxYThnJoSIWN7vfYw2Hi8zed8ZADUBq/KSkKf9cssH4Xd1iKCdFzLrdcxz/3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPbU3vPPAGPUl/Hv6k0hl6s8KIYxAcKJvx3UyKwa5TaySudiaq
	lIrkbt3gkcVxHi9mwfFwSDpJazCWiXVyuzRGBnWCEKzZHA4LmEicejpY3qaCaJp11MM=
X-Gm-Gg: ATEYQzxUmRxbGvN4DZ3sQDE4vLh7tk0oDIEvv3lSz7ZnXxdmIfbi8ZHfsjlGnkSvRjJ
	7/iyJBDTG/BBu/m400MfIP8pz843hVFOLeLr4GR5H7toyn9EAEXU6ENgVBnAmX0/x7WgM9iP9Nw
	wDVl1ElVoBtWTrkFO4IcOihBVPLrYsFzrx66nPGhPdX276bPp5kdlflXEyLQS4o73e8sldvPvh4
	6wRQ4m7goRE7/Gt0Fi8rV/Bv8rZVspnhb/4kYH26f5XRrDv1zbG2yLWtPRKteCA4VxXpuAOYzTP
	L/d9AJiu0qooeU9HZ3L4C9qI9PWgaYMBGxjW+VHZT7JTLyuDyAHh5O3UaBlQP9h4t2I6I8b4i9G
	IZakEyNVuQIzbBxKc438PX75AEvsQDe4rIP56/UttYVgxoeFAU1rgrQ3p8e2XLq++MRmwt7YjaU
	qCbHvFs+f5F/2db6SOHkMmqWqIHoIlphSPCDJcq7ydnywBcMVoKtlZ+8tYRBLx
X-Received: by 2002:a05:6102:442c:b0:5ff:bd9d:b1f2 with SMTP id ada2fe7eead31-601debc1ef1mr1023039137.3.1773235362797;
        Wed, 11 Mar 2026 06:22:42 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94ecfc4ecabsm557565241.3.2026.03.11.06.22.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:22:42 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ffa277c115so4958370137.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 06:22:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVjiLc8nunmltNiWTTisVZEyevPBCYKxwYo0wd0hZIYWopkqTrGgsnjjF+/QDoRkZurREipz5u9uJ9pdA==@vger.kernel.org
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
