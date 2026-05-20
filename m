Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444153A5422
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 13:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779283488; cv=pass; b=njOVobAYAgS4PzJpfW7fe9bJ4ZdZ0S33VDNvxDFWnmXTmvwAVqFeyGArVPnxEK3Yiar76s6WMreu6te613hLgWjdmvRNw/zSYTyioF6hsmK9di6vBoNnO5VfzGqHD2tlYdRNxiPzkzC+coQAq/IgCxGh83FnXnVhORb4v19WhM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779283488; c=relaxed/simple;
	bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GfE0ST/SNKUpVbyRYLqWW+AEq9w970Ar8OY3hcWNZGTE9dRQOJoO66Q8ROiTjnd5WZ8ovhtazncTqbIdV9NvDJf45+1bMDO7UJAYs2wgPwUz7MhvLu6eDtjZOVrWfpAav3s2QnCS0yuPjUQ8/RjoTRpLp+HMQSUs75IzHfVuL88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwKoCw/P; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwKoCw/P"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-672645dbfeaso6485588a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 06:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779283485; cv=none;
        d=google.com; s=arc-20240605;
        b=hlKlbISiE0AUsHXDVSoyMzEaFgcGBw8GvAf/xO2mv6/a47J23uEnQ/j9rj9mjoeFah
         ga5i6etnkilJDVsxei8mUEE0MKyYJ2A9/KDHBrWHTqv8yJ4op3/k8DYWc2qbAxsF4x5C
         CyzausfBQLhxiu274lrVddh7qzEvMbfjsWtQujLNBIGOSt79DpDhmx8b3wg9JiQ8Oz3g
         IWCqjku3Uce4gKhL1Cq++OhQK254GCHa5IrwUz9gV4SJcY7e1BrhD+5cUE6Yi+ZHNCFZ
         BWbrIQUgy1sqcihb0fv8YinUO1vg1HU1yqkhp9PzIhs4xQc+DdX23Ocye5+75MRHJznr
         5XVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        fh=OeZGwzQ95pP0RTBbn4WWFtzGAo8M29N1VrIdTx4+0x4=;
        b=CnDeaKZqL1IeAoCXG3bbc9yvDDckI8/pxWpxHUMmizXKx5+wIqdstQKJ6qCbSNiyPB
         BmlI41P4KLPrdNk5gD+xPRjNDUMzUqdfqvdfkyTxbUJz+m6I1+2KdigxAIbRdAmWNXNb
         Tsn8Lyj5KiV9eZUn4XkK6TY1o2Hud5RW9O6pl6kAtGJqXhcDUGla3mXnhwz154dcJ+2g
         osKGrqVQeuoH9ihy8o+VhpB45vnDhPZ3S3t7Sz700BPd+foivcZsvLsE1Odo9Tu+QiKC
         vY40kseV5RGlm0G0D8yL9nDKJfJ7fOY5BqcgWt6Tnb9NJN8OMUg80m08yi+2sEYYmzs4
         6ZkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779283485; x=1779888285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=DwKoCw/PT7mQ10vNBMUrsTEgJ/KD0xilvxMKeI+aiO7GBDvQq7XKJJ6kyNOOhWPRFC
         qAQRff8dLVNruj1MIMY+n75FGD1FnYxldtzIkNgu+HLnxNvGPuCim/abv25tCKOX0c4M
         B90eJODV43Mun+Az+kck902Vl9CJYMttimw0RXk+sRWyhFsmweKWF99SC7Mwan6wOHFe
         ECm4lVjQVlTWgUeeELJ94rOZn5g2GnGibbV9qeU8cfV+5qB+iTfrqeWOwpY9JiXUFeT2
         qwR5fHpfjh1a5z5kJLq0R3QIzdIesXZWyZHMBltpqUvmJGhNMGt1egwYWRwxhVmDRO+w
         Lh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779283485; x=1779888285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rit3XOj+nAqSskgBa3AwkCsmGpVaId+gpzvsbFjHRsc=;
        b=SUD6JfkQ3ucOeUiBCeljbA7yIXmWxa3J0ff4pLW6X7iUWLMVtpXiTguaqVl27Z+jjz
         HE1f158I/dc0neoUOP6yG3y3c5Asq9WoXmoCIdBn1sRKezG1oIcTWV7HJmBSBH/601t+
         HSwm5tFk03ewEzYzfTj4pxVs9l4k+m9t2U0b7aCOnASDhA4El/bzD2OSx8PJX2ElTMSr
         OpyS67rhthyOH1daSDDF3qkBzGvPwW6xHTEz6p2CBEq938hCd/K3xdQbd37RuC+F+jyY
         LmSISEHJe09I8ZDaBXFrnxhi3WwXJY4fP+biuX1zhKNwyW0bxb+u4w6LbZOSbpLbhFSr
         GAJQ==
X-Forwarded-Encrypted: i=1; AFNElJ/EBUb5Ua+udP+V6bmh4cJCtKW+Jk++JqNjL7VhXXvUvJbeBtvYbum5YUO3xJ7cgA1T90PY/SRdlWjGCA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgPizb3zf+iyjgCdJt1hWtadvqLzKFSekNSutqcFfQcQeYbEbH
	aYPFEuafjzrs0v/pNqd3R0R1nj15vSgki+l0pQSW5vb2V1OnuqVCCwaaBitge/JHaGJEZ2MK62R
	HCPVo4WxY6QUIC4h54bSCirpCRCzCbGU=
X-Gm-Gg: Acq92OF1L7biYtciY71jSnUNhTe+KcrMdRKN09F/2LHYlQlZVutImwJ6/Q70L7jcnan
	Dfsjbd2i0OCJv47u484cgdgrBmKlJFIxjvUdFwUuKJM47Ru/WMEJuySrf1IwrC3sQAgKZ0lQKnV
	KvBTQc05mjHv+XJ9mG4/FsIDc+hM4jTkgZBzpCxlTbBLkWE9hkqiQgvAVKh+ZDGtHhUylGue6EW
	7hFR5dsybfUJnHvUpDhIIO5BltKfmM+KibVyZwHRXmKwHSL5Kz6a7EFhU3htuOf/6Y8tyYZGqpX
	rAP74tfgGRR0z5FPbXHwZGvTDjq30kJKHPtZ0PBYuP71ZXBToeHA
X-Received: by 2002:a05:6402:4313:b0:687:285d:44a3 with SMTP id
 4fb4d7f45d1cf-687285d465fmr1620985a12.15.1779283484506; Wed, 20 May 2026
 06:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
In-Reply-To: <n67pde3prjxt2c2u2pvjytfw7uzwbeij2yljlrwh7fixcgnzhp@piqsltgpcc4v>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 May 2026 15:24:33 +0200
X-Gm-Features: AVHnY4Jb9lW17aXG5JPAYjGDiGqwrTNH7OJH9zvcsbDKfZCeeZ6RTdTNxiDlapc
Message-ID: <CAOQ4uxiNN3U4datJb8kxxGVp7VNRFZB6_zEnO76kh9oEjE_-bg@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 2:54=E2=80=AFPM Andrey Albershteyn <aalbersh@kernel=
.org> wrote:
>
> On 2026-05-20 14:37:01, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> Amir, Eric, this is the last patch missing a review. Could one of
> you have a look at it. Not sure who should review this.

Feel free to upgrade my ack to:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
