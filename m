Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794578445;
	b=Xx09H3uMk2JWUkpc9lukbdu0fURhkRkf7qTdPtVV9LugKHVDqFenbQbNVrilG9PZn+JQ
	 OC59MiZ1xuoCQRL6AmzoQ/fzstL01TKtWx/gXxwn3BgJw2tg/aLHXxwyx5skzSuxjN76U
	 lXxjKGorjvVZ0PS0ohd13TsLvXnFPRW8oSZuTzizq8Vi6sFuz6Tjg7MB/GpxMT0pijgCP
	 NesegIUkF7TCatH+qJZajqjj1+M7For10mDQd2KKDiMZE6c3kmieDGVmEHeCiWPYSiQk5
	 +nx1CE20XmN/NQDZicCM8F4POcxY7jt7deJmUeymsXNavJG6ThifhgepvDBh2L8n67g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578445;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PBB00BHqoOflCJuLhO4AkX5ieFMelnFYR/Wvx6dY4pQ=;
	b=1AINrATWYIggethi0lfZySW3M/c0ywXX/COsJ4puTYCs9o8OCLf1+w9op0+FPHXnIVTy
	 iaZPM7jHp/acx2wnz0PuyI5a3Kr+cybuVColOVKtgGWdLmcr6lsZdevAsXCeI3EA5FFX/
	 0ARGRLesKUDcR1oSrUDjePAS313suRmzgSEGsUMf7HDJaYaaE3qA8FmgOL5GlLfih5oqJ
	 WecInSnnsnyU80bkhdiWxVZ1KbIn4N+NLGFjjAntVOnulq93N6hrX6regAjrg2k9W0S4a
	 RWSeJhnKP7Mjma2ZSLMGqyAtN1V5rqw9zAiW87DS517Bmalsy9E+fB5DJTGC1aWTlNA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QUNnNfrk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D189606A32D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 14:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D189606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QUNnNfrk
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3ab3dd966e1so11252311fa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 06:00:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794578443; cv=none;
        d=google.com; s=arc-20260327;
        b=Q4KzPYchZT+2vcWb3g+ydiBXnaxfA/XaN0sPOMJ8uuauW9DmuVHObbEhn5zbq3YgBv
         KQ8XoXMi9vDeWb348UIl7qh3eOJEmmI9F8XSX7GAMKAmtmEECXUbarSFdS8Lq4WgEWWf
         DXtfi0nLB3z2C3LZJNpb9edfUlF7+A1IvADw5I7BRx1domFKFof73MygGJ1np4KDMFBo
         L4UN8JXKYmubS9e57BZuRUBaTl8kvqRykFnplySY64ZkzJ7RmcbSOHBxMhny9+URVUtk
         HWFmNzIVBIDkMGunSfMQha0+NB4ZCs5eaEDdevkdUf2lOqAikj86mN+c8aWPFBIkyOJj
         Ujfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PBB00BHqoOflCJuLhO4AkX5ieFMelnFYR/Wvx6dY4pQ=;
        fh=vqi83i0Rv0x5Ogz7MPFhWJ8aqtsaP/hPP5da1zFcFF0=;
        b=KUt1j2Mvt2YvF9X6DPwUtSespHKdiSBW2Zgvn9nrPhiqGuk+8uAMo2y4+LoGLZZzen
         K0KpoDb1b+UteGiIzU1onsL/Em2X/U65yUwHgulX1DNCmdz6E2kphuoHAkZbJewbBz72
         XX0UXINhsXyzjsvmYfwrBHnWPZSnx4oH7CGTd0yqQT43yoycPURawgvXmbZZnSdc5Mux
         wUS4VVhYIfJoJmm3R2bhybwI3spR7rUhtNnIJaIBxM3xx4rfYKAkjpWQgabFS3/F+Shc
         VkgctI8SkWenSkYwvzWr+3sGRzVlwkmjz4snk3AYwsO3A82mdjEqrHlaOTDK2Frmb4gn
         uX9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794578443; x=1795183243; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PBB00BHqoOflCJuLhO4AkX5ieFMelnFYR/Wvx6dY4pQ=;
        b=QUNnNfrkiiFBFIEsW+tYOWSZTEdfAwaKCKIleLHFnvODiQUDyWyegkRjKIYNoYL41w
         yQxbpNxFi/T3HdfssmTyFxaKix4xXYrUyLC023Ht5IzfD4cTgvu5ur3qZOfvTiWbGhKf
         zjA+Brf4Cjwm0sAWNs+Nof+lUp0Dll0fPAQumUo1iTbRmEm30BJjscEj+17sDZrUCGBR
         FRXikNUGlVz746L7H5tdUdEyf9TxDChLUKaZ8nCHWq7OjxYmY1Y5b6KBEJN/NmxpO4c5
         cI24Y8eN2aDyUzR4vbLvXrn93sPfXCKMICabVMVvLvHYh1I1DMGdwY2MQWzVOi1A/FjL
         M3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794578443; x=1795183243;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PBB00BHqoOflCJuLhO4AkX5ieFMelnFYR/Wvx6dY4pQ=;
        b=FR0DsvkE+QNavfHZvU4i/kJ1Ok9feaWBYT+0HZwRn8zQG6/AbierzDmwkeqni4dKhG
         zZIaqKLbfy+yX1uQMoZrvTZXBe0UP8kAS3m3HxQryyn05Fzy1FDMVE9H4gzZhOz6sb96
         9pzWbUojbbVoYwTQJdL+reAYdIqYwcO6GnZcyYUjiWcIS9NiIe9nX+EWfCuHV7TbfYaw
         +iVxR94JGzOst2d5um4f+czq+GFf8sm+GfREVDp+CeuTV6W9y4guXDzbd9Yt5dJHGJ6B
         m/xW3LVv/nP2DmuXaNAczHgrae7VjmzcBCx6zjPZJh/Y8oQeOBa4raV+WFcY5CEWFXvi
         RKsA==
X-Forwarded-Encrypted: i=1; AL+hErEcQI//diPwoyz02G3BrNrYhKQA1gkInPziKzNjdVynwUCnlkQlDt14DorqAQt/kVnVDgvjzpxR9TVFbQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/Mc68qq6DswznROi5VDV3SlrgGt3GGlOzkZKIH1g2x4gTfnYjd
	+O88YBIJi0VXRWhSGVVwZx+J6YTeAF5ugCJqjWFND8aleIWiTR9H0UCZ++epl0VBf8uemAEzj4Y
	KjxTwNWZs2KDMIejuC77JruP4D9vBuTE=
X-Gm-Gg: AYBFou2jqLAqMknsm9blBZDKCEtHXtiygDCV6skCQzf+zbUVMNfa8cZNrRJToquQxGu
	yGmG+yAa8NHC0gTuHEOHk8LoEtwzxVF89hs2RKa/vAiRj2ium2ZEBebas+j1teto8fQh2O2775O
	u0a7cqFi8n1/9XWx8IzxKG6vu4J7ZRp+HHWqS+hr8F7lq8lV25In6zo0MEoTR82RQu3gQojtwle
	QOzdg0Ev9LXSVaz3Km1FTHlsCkRNGZ4mO3p3Di8gyCLyLCngY/q9zN+cEByzes1L3LeCCIcrj+9
	guoExFV/hD0k3JWozeqHjmBg5+yO0mDi6LiKmgHS9NeInK8qNGpuxJEj1J0A4X9MObhTNtLgv24
	uMEMqfaNIdj9ByBYt5CrnmK35Lp0f8gPLsKrVUCPFh1P1FEaFWPHrLhmZg+zOq6DfRZgkWjUO61
	g6pJTuqP5nYHdAYZq5jTMcInRkWAIrR7ese2+tH+UI2EXVHnfCyNkN
X-Received: by 2002:a05:6512:401b:b0:5bf:c045:964a with SMTP id
 2adb3069b0e04-5c17077fef5mr989767e87.18.1794578442887; Fri, 13 Nov 2026
 06:00:42 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110080932.1205332-1-johannes.thumshirn@wdc.com>
 <CAD=K2o8OvHTxo5o9ZNavnbzchtLqwFT2W6YiuKLMNux9qMRt6A@mail.gmail.com>
 <914ceff5-cce8-4716-8763-34e4e4a9b49f@fygo.io> <CAD=K2o-yjUDPKJ_kFUur62z-JsXdNhT6YnEUftgtgoCZ6qG-oQ@mail.gmail.com>
 <CAD=K2o8t1zO+-d0H093C6fEsD-tM6nDq5FRPadW8jjviuO6CSQ@mail.gmail.com>
In-Reply-To: <CAD=K2o8t1zO+-d0H093C6fEsD-tM6nDq5FRPadW8jjviuO6CSQ@mail.gmail.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Fri, 13 Nov 2026 15:00:31 +0100
X-Gm-Features: AclHuK9_SpbbYRjt8Lj2V2R7ocJGs1pr3SeYrdac2pAEZXGNSZR_rZfg8Se2lsw
Message-ID: <CAD=K2o-ZYEY8dextmLedERe0kUxKCuvhcK2vVZeahB0VTKVCjw@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: Dongjiang Zhu <zhudongjiang@fygo.io>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org, 
	David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dongjiang,

quick update after the first write test:

- copied 57 GB via rsync, no errors in dmesg (only some
  correctable PCIe AER messages on the chipset link, unrelated
  to btrfs as far as I can tell)
- closed zones dropped from 124 to 5 after the copy + sync
- umount, btrfs check --readonly: no error found
- mounted again, transid 875, stays rw past the first commit

Next I'll do a larger run (a few hundred GB, maybe overnight).

Thanks,
Jochen

Am Fr., 13. Nov. 2026 um 13:40 Uhr schrieb Jochen Philipp
<a2jphilipp@gmail.com>:
>
> Hi Dongjiang,
>
> good news: with your zoned-fixes-testing branch
> (7.4.0-rc1-zhu+, untainted, same machine) the filesystem mounts
> read-write and stays that way.
>
> - mounted at 13:16:59, no errors in dmesg since
> - touch + sync on the fs worked, still rw afterwards
> - superblock generation is now 861 (was stuck at 859,
>   transaction 860 always aborted before)
> - closed zones according to blkzone report: 124 (128 before)
>
> For Johannes:
> Full kernel log of this boot and a fresh zone report are in the
> shared folder (zhu-test1.txt, blkzone-after-zhu.txt.xz).
>
> I haven't done any larger writes yet. Next I'd copy some data
> (a few hundred GB with rsync), then umount, btrfs check
> --readonly and mount again. Let me know if you'd like me to
> collect anything else first.
>
> Thanks,
> Jochen
>
> Am Fr., 13. Nov. 2026 um 11:14 Uhr schrieb Jochen Philipp
> <a2jphilipp@gmail.com>:
> >
> > Hi Dongjiang,
> >
> > sure, I'll build your zoned-fixes-testing branch now and test it
> > on the same machine. Johannes, shout if you'd rather have me keep
> > the on-disk state untouched a bit longer - otherwise I'll mount
> > it once the build is done.
> >
> > Thanks,
> > Jochen
> >
> >
> > Am Fr., 13. Nov. 2026 um 11:10 Uhr schrieb Dongjiang Zhu <zhudongjiang@=
fygo.io>:
> > >
> > > =E5=9C=A8 2026/11/10 23:08, Jochen Philipp =E5=86=99=E9=81=93:
> > > >
> > > > [...]
> > > >
> > > > Since you only tested patch 2 of Dongjiang's series: should I try
> > > > his full zoned-fixes-testing branch next, maybe together with
> > > > your fix? Or is there anything else you'd like me to collect
> > > > first?
> > >
> > > Hi Jochen,
> > >
> > > Could you give the full series a try?
> > >
> > > https://github.com/pdzhu/btrfs-linux/tree/zoned-fixes-testing
> > >
> > > Patch 1 of my series also addresses the conventional-zone accounting =
issue, so there's no need to apply Johannes's fix separately.
> > >
> > > Thanks,
> > > Dongjiang
