Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB2274B42
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773237987; cv=none; b=Ve7T9vBRHIE4+HT9WyzmILkiJ2QCLp6W2rog/z/7eILPkX8UsBm8uACA0VBo7VYCTF4M+Fhn+YPQ0Oq2sefmRCRxCZkrL68rVxauE1r4Wyfr80+pD05388S3/A3edIn2iPz7/ptlJXoa7JXEybowS/qEWShODFxSyQ/ZZjXtkOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773237987; c=relaxed/simple;
	bh=POUJjzeRhBIXfPGojdZfC417KH92loTKx1KmDpRcfoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3HeVLumiC56DmdGuDhl8YgPLJX06t11rwdS4VJ3dPosLPYvI7ExYQaNH0eT634DMUZid1shZSV1hf+5itjRW129CDEjjRdi0G6YZVo/L9FC8ux0f90vw0lOAU0mrbtW4kKmEC6U/2zx/9x9rzEx3NDn//QjbDpdTz68HIownsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b93698bb57aso169050066b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 07:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773237985; x=1773842785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=isfTzlF2I93EN2VNYkiYlyQU0LZEzdyANivNiCgye8PrxhBy8gKXRQf3sAG045RkBq
         yqeCLwoiAcQzeNye8EMSJTPycAc/4gpdGvRoAmBceE5XoM71mAr46jaML/xifUeZSTtp
         O+97PP5dfmO3XwCqg7fzPycVG+8dJZMTb2XsL5Hns01+YKYsNCfN2ntELhnj4bt1D+iR
         dGvsBwLNYSDE4NKf+GI7lySGwUEsP1yFg2xibLyaQVoIAKmqgr/tDOe09kjUBWlHzDP6
         UCao3djdd/z7tfjAXrwTVFpgMaxZm/s2VsYkCTS8W720Pq0hjl9Mt71OvJ0PV6Ih1Set
         LNLA==
X-Forwarded-Encrypted: i=1; AJvYcCWOxh39otgiR4kTVlMsCJw8aH+UUov/FkRwSpcB2aMfn/41AuBZloIx97nPq4Zf6LoHJCFlf+7IhREN3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YytKTzffHuXk6ti5f0qPiBihUCp17FvZaAqIax9JFz+qarb2TvN
	KT4P6pNauG58W4bk6Wecux8ox+hVZM3U7rNQgZhH5xA0QxwUNSp1UusxMLD1M68BnrKSSA==
X-Gm-Gg: ATEYQzw6aFp7MzdUYHjvmEWNmhVA3P+h5y66qvKXIg5WuKKVgeyBt/8fy5QRDEiO5//
	jOyR8HlNw/29+8UaIlhjU1Ngoa8rAzE0EQansdM73w+lsqsp6/gAjuSflbTxuzQ6xlU83pZInpv
	XR4on7BWnSWlernA6pmSlRiiH8NVvexM6X27QGZhQq6naO1p7aVAtIQTsUMtb3qoEnYu6RvCRxQ
	8bQCazgVDLo1w+R+YSCzPWVlRRvtliOan9+jksyCU6nGncJ/lVJd1nMBnWDHLq6Fj+VgLPvPmnY
	Sl3R3+hwQf301C5vboApdFdnjzP/AtelOOhDRcD0j/Ix7i+4Sw/P5/sDLxPJ7Hj9U85oItXsLL9
	gpLuB5sYx5t+LZBq2XA0BTomdLfZCuDmhJrLsFNKi55csXnttNcW0sRdt3aIMzSBMOq61f3yb01
	1pPWPCktty3YGpvSS3rYZuuwPct9A+SXwXTM5v5W/TnOXi046+7uy9vqYSe907/SYGvn4sReQ=
X-Received: by 2002:a17:907:3d8c:b0:b8f:c684:db2f with SMTP id a640c23a62f3a-b97118af674mr452459066b.9.1773237984571;
        Wed, 11 Mar 2026 07:06:24 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b972de47966sm55928666b.17.2026.03.11.07.06.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:06:22 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-660be63279bso1531044a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 07:06:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXMtA2FBLbfN9pW188t0n4Q9OQeSzYgA9maDrdhA3CiGG7/SQ5QOcundVgLpENuZ6AJ8Jys5fZMIzwhrQ==@vger.kernel.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
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
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
