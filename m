Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8551A682B
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 22:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774997258; cv=pass; b=EJbSwECSNijtOehz0+2Wy3goyEerP9uEr6NplmCHBA6jDZ0HbtGvgvZaqyd8GIa973RYQMkTkKtLikadZMaOsVq0mhrIHPc0IsvrncIjXKx1COMKMX6JA9BiCyy6+sPepRn5HbeZ86nJxhkYTDKhdZsFaCqQcbQcKldGYXcaduE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774997258; c=relaxed/simple;
	bh=OfoX7L703MZ4cJln56y4+I2XS1B+XrSr1xvVdv0/W5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KRbBLAhZGMA7l/8ePTgARc9zVU1KCTiRAQ/tGqgR8U1TqB4hgIfn4iPQhOg/96h5o3M4dtHNRjeq+FgHReyc4Zx1GFpC+JCFfFFrlKOB1WfGAk7ix+E61UTeCMgIgLC01bzrYHuPrJLyAbRWtOvSkPuiLJaXvZiuRp8zzNHajyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=WFjPQCU2; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="WFjPQCU2"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-64ebdab2ecfso1065101d50.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 15:47:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774997256; cv=none;
        d=google.com; s=arc-20240605;
        b=UZ8biDB9UYrJhwZP1rNNzGoUs4svhar/TzfzRatE7icy39QJutomYiMQEq0OT1ME2i
         BHrE9tDGsAesxqSbELATrLlVjc2Z+Z2paCFV/qNCixf3fWpqsbfc9g4xX7kZjqpaTW8L
         VY3jZ/hSi4I5e5nQrMntLuCTLdSrIyaBBg8jrcYCIpN0+sPWM/4yWRyzaNmQUQm/lKEo
         oZAXRGmf6UbdUgjxB8U3T6sxXpFOaSwDCHK8wu7WXB/XTqhssVpfqfaxRWbNGD+q8z+6
         bkTfdR6UucQNtoMPhbEgbgTFENPFFvSq0Dez7oAHrGYOxNXYbtDSH9BVo8C2hciNq368
         DG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OfoX7L703MZ4cJln56y4+I2XS1B+XrSr1xvVdv0/W5E=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=FcrmTe6LPxil2AoQJS7h3SI7Wi+qcUgpYABAeUG0Nb7t23N4MhjMH4aZDhu4eNwpO5
         LZEk0xLzrGyGLBsF2CwOCzDFU1zsSs6EVFZNyGjFB6iukveEBBPb8wA/KZp0o2ep9G5d
         YVxW2zRHz3zirA/672zV89iQhmxQCtfAKoj0TeVfzu7DTFlEP8vp/56KslGozwkg4cC3
         F1u3Sklu9nncvHSh5DakTbPi0x8Imx0SviZOKK+ET1cV+/6Tzi4/iSSZs+3n8d4K7tW3
         +9JS1JHpTRrUIdZpGNV40A512PPrYymVUQPvE+gwRMCWfbJk9SZmJrmHP33njyQ32SIt
         S79Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1774997256; x=1775602056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfoX7L703MZ4cJln56y4+I2XS1B+XrSr1xvVdv0/W5E=;
        b=WFjPQCU2uf6cr+nT6TIZBSM9ebr9UkZXRh81plD8YauER7eDHx9lqBEamclPJakdm5
         wJk+wHzZd0QLaCa+GntZHa26PTjGo7JoFvRpFX9B18fVNiPBjC/NXLNlb0sS2/rRi1Bb
         xLNMH9ujt+TuFoas38TgSmB067pxtJYYUEIawGAA6L+ZdEmqrDjTg36JKXfAwE3KPPKk
         WYeJS7xL8pToDEWjvyLVc638a6Xu9122eIacBWcwPlwF4eIXEaqBLw2TjdUDW8RP6Iv9
         CxVW9ZYN+cTxx6QCrxWR26UWEIH7iKoF312ei2pPCuTz2QZjESOjbXIr1aqGt8mnBFj/
         z3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774997256; x=1775602056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfoX7L703MZ4cJln56y4+I2XS1B+XrSr1xvVdv0/W5E=;
        b=Orz5C0YH8Tm/kYqCS/GBivPfznkA0Weqn95zSqaGqgVx6zp8/0KUCQpGIlbGcz9LUI
         S0MfPZQcmTCdwREx3dnMJGsljMoH2d32lJFx+W5pB+3bA3cgr81yhgki286CqM4n4Fog
         am5Rl+7Hrxn4nlWRQ+IiO7RRg/zyjc4CQRTWCoFbbHcH8zMRsj40MQopx6CG16E1yTvN
         qmzzP3KqB00b9lQsklzEEnYzJ5J/e81J+jMmTQNBhvgkNHEiCHRnhH9JNKF6zDiaq1D1
         MSBOHAs5l8DxVrZzoaVR4qA2O0ghhLcZFD2xL4KVrg79Q479NG+sUzFI/fTgXPBG0BZt
         qiVA==
X-Gm-Message-State: AOJu0YxikpjfWHJPX41OUNJuu5UfB5NAZGEN1i02eZ0pqc2DojZY+RJv
	f5q8durK7TV5/kUtx8AllfU3IKMq3aPt/109yd6w+2iOWRaZ18+3hXxm/VtTI5nZmqkbIi36pNq
	bz6YF/Vi2H1H33jF2NY77xx2a0W/JXreHf/jc8jIKjQ==
X-Gm-Gg: ATEYQzzQkfuT+reNkAGNsrEqwni/v4cdwhJmgaRZN2dHMv1vKL/Y6sYADjTFzqyx1Dz
	F4YyIErcR+1MVzbU1LuKsTR+0/TUkwKbkzo/dYnRoTiWhpcL51P5Jk6d0cbgP0HCwpNoE7XEmYb
	cI560lxe3JrDjZdDNn95bvSQZDlw9fUmSTMk0VRyL5/B3cCjZRgvVPwRL+xkmXu1PsMbmu3tXwG
	j2OnZ+By1uzjKRCaclCaN+W2L5+pJK/HetdZ/VzekReeekp3OtPCQWfImGmxZg88mWO6aXOPnXp
	oLA8i+Hh8l2m4ehxRmNYeNdZB3+ZoaNCv8GUOQ==
X-Received: by 2002:a05:690c:6704:b0:79e:631e:67b with SMTP id
 00721157ae682-7a21213f98fmr10554377b3.4.1774997255734; Tue, 31 Mar 2026
 15:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com> <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
 <d470a043-72c0-4124-800c-385c19007b9e@suse.com> <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
 <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com> <CAF1bhLWnf2CLnZ=BbBVS1je8a7LYacbKDAaLYNgFzY+Z1=L2=Q@mail.gmail.com>
 <a2e56b07-b0fc-485c-8a68-2136e595ec3b@suse.com> <CAF1bhLUGwb17jVD-7cVqA1OTRRRYbt_ow1+GZYbFgChN8mdKtA@mail.gmail.com>
 <22009c9f-f4cf-499f-aad6-70e94874dadc@suse.com>
In-Reply-To: <22009c9f-f4cf-499f-aad6-70e94874dadc@suse.com>
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Wed, 1 Apr 2026 00:47:24 +0200
X-Gm-Features: AQROBzCdpNRFEzxUTlLXWShu8aKQmnrAOLfxjDQ8RmLRPRgeuxLTM_pGekb0gnQ
Message-ID: <CAF1bhLXNCeoct-SPoeLWXUKEmZnbjd0gXLmJqDdEmoPOg-FwZg@mail.gmail.com>
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 12:33=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/1 08:41, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> > On Wed, Apr 1, 2026 at 12:07=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
> >>
> >>
> >>
> >> =E5=9C=A8 2026/4/1 08:31, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> >>> On Tue, Mar 31, 2026 at 11:58=E2=80=AFPM Qu Wenruo <wqu@suse.com> wro=
te:
> >> [...]
> >>>> My bad, I forgot to ask for dump-tree of dev tree:
> >>>>
> >>>> # btrfs ins dump-tree -t dev <device>
> >>>>
> >>>> Again it's fine to dump it from any good device.
> >>>
> >>> No worries! Here it is: https://transfer.ddvtech.com/pY3LV9yw1L/dump_=
tree.txt
> >>
> >> And the last one, from chunk tree:
> >>
> >> # btrfs ins dump-tree -t chunk <device>
> >
> > Here you go:
> > https://transfer.ddvtech.com/FAXxEEq71p/dump_tree_chunk.txt
>
> Thanks a lot.
>
> All the dumps show that everything is fine, except we do not have a
> device item in the chunk tree for the replace target device.
>
> After some more digging, it looks like we didn't really insert the
> device item for the target device into chunk tree.
>
> So it triggered a false alert from btrfs_verify_dev_items(), thus
> rejected the mount.
>
> Thankfully the check is only introduced in v6.19 and should not been
> backported to older kernels.
>
> You can try to downgrade the kernel to v6.18 or even the latest LTS
> (v6.12), and try to mount them again.
>
> Meanwhile I'll need to address the regression properly.

That seems to have done the trick!

BTRFS info (device sdb1): first mount of filesystem
d18c93f8-d80a-4aa7-adc5-86d457ddde20
BTRFS info (device sdb1): using crc32c (crc32c-lib) checksum algorithm
BTRFS info (device sdb1): bdev /dev/sdh1 errs: wr 0, rd 16, flush 0,
corrupt 1054, gen 0
BTRFS info (device sdb1): bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
corrupt 379, gen 0
BTRFS info (device sdb1): bdev /dev/sdj1 errs: wr 0, rd 0, flush 0,
corrupt 1652, gen 0
BTRFS info (device sdb1): bdev /dev/sdk1 errs: wr 0, rd 0, flush 0,
corrupt 1522, gen 0
BTRFS info (device sdb1): start tree-log replay
BTRFS info (device sdb1): enabling free space tree
BTRFS info (device sdb1): continuing dev_replace from /dev/sdi1 (devid
7) to target /dev/sdb1 @7%

Thanks for the super fast response, and good luck patching the regression.

>
> Thanks,
> Qu
