Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793886520;
	b=RsJHwQZHbteOCBxR25SFdtsHBb8D1g3J0QfWy7/PM/n8TMhcq2xQlarGP17H/prSht2J
	 QvB+v3jKHqQ/8cwJQcY84hlmGNjcZpnTidb1BGyb/fvuWIkr1tabu4P1jgVwslmnQvmTN
	 qecbPMTJmGv3Vc2Mx3sWV8xOF6ZgVqls91cb2upC6lIwuc/s9oEpLkWqytQiJpnWuDpZ7
	 64MCL76mXAV/GqVUac3C7VHbfLwmI/6yvSpFm4nF1fgAypm09FZpLK0VUgLYAM3gu79F9
	 4ktZresYW+ErYJRGYC9SfQmuY8gL6iDtIV/9xwBoOxBvZ87lYdStwTL/KPAkG26mRYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886520;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=9+Yxi1ftCSHBSZMF0+tAoCrDEYB5+kuJMJfx5CyWJaI=;
	b=D/JcKEwSRQOpV9LV3frkegSZOsn03PEp2UTor8ZQTnqjDbb9DYbhpOi69LN5XE3GNFY+
	 S9jPDfYodLgEgoGcH4bf9GDNS4W6YPPk1fBFlg0PB9vCvGZVurBvlLgX+FhM+l7ue/Gme
	 LrvYzlSeLALQbWe1ioRvO206PA0mBPP1u+4oT9uIK4LM3BWVO9QNchXba6n9gMUtv79RW
	 WOr/q1GgGB55ZoZS8EunSMYUF/Ok4g/sp9WPWAbpoXdnMFifNECasJv6+BpovZjsSYSE5
	 nCrph9QWUJ3BLXc0izREqfIWt8pg7vEbdhY5P5gxOElTNMQKLhXf6lvBbTWMWpnpggg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GXXCgdoS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2DC606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 13:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A2DC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GXXCgdoS
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ba3fba0080so1434872e87.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 05:48:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793886519; cv=none;
        d=google.com; s=arc-20260327;
        b=Pz7wK/+xgLLfhiRYRQueeJKzR/z0QlQB6Fh4H56GcmtjgXvYchldx1IaGMQfB0Esyd
         IRGXwoLTXp/g17OuCGr0kzyAfRnyNT8xZ8dlGAznH16yIELTQNzwVJSWaGKrh1xE6S+F
         oR6wr0R7T0FTgW3EyvVzzTIxE9rIwmcaG0rxSVXIWcJEw+K5tNSXu+6Yyd1Pl369mrjg
         CmyVesngGbcxRfL1sddBW/MIp5InkmiPCRfVDO7t8syQHnKsBjf0TNYs2ltn6qamf6VW
         2huqOEGT+MTqT0Zr8+gTiWjEpKXeGBdYV+wFszpZX15ZhoqaOMHw2SyiZrmdlDfW0/k/
         3/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9+Yxi1ftCSHBSZMF0+tAoCrDEYB5+kuJMJfx5CyWJaI=;
        fh=XgyVQL63bakpFfKqPxJJiY5NdZTbMYsxaBXyIXgyd7w=;
        b=UScT1zEs1jNDdaUO79A2YoHBMjzDeUM/Us+pVXxHJa/Dh5Gy+TBkWmUn2EV91txWuS
         aUDYocE6aA3X0eSm2cj0ynA8Rf4MBBfeIAHYqdecoe9gD2PHzcrcNH6FdIXw6FnK/Nj2
         LjcY4DkN8Vgjqa3Nv/luPApeJ+ivZfU9y4ip4krLLAQbk7pnk1d1eynFe6sGh79n4/+h
         OBYbP9I+jxZFFBDxfC8asayIQ1iEFyTZW6ufPkOWWYbS7qM7COeu910IymfjTG0UzEgT
         W8uQQCeEvw4RZnYjFScTNkMbAwCJazaNfWGZcnRiNnQOUVepq/ACnr2EosTPWfc1rWCw
         p+ow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793886519; x=1794491319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9+Yxi1ftCSHBSZMF0+tAoCrDEYB5+kuJMJfx5CyWJaI=;
        b=GXXCgdoS/D8fMa/L9f9djYya4bZefPYkvup10s6LSwhXAx3vh3Qq9KtqJAflM+YQi9
         g32bZ7hbCcQPG0G0gbuN0AMEdWy3njd3KtEVQaxazvZjRrUYXYyvDc7c0aoKG8r6Co+6
         Uv0Zwh65FThoEoEog6Fw1Xh00jkrmuXj3BkYCOR23P0IZN3hS2gLjEakglNkHI8CdQ7g
         fb9juh6/VUGxKYPtEcfjtH0pxRpXy0PkIO5jpkKnI2WRHqh9ZvxgfCVfhP6RUkm5jnEf
         sNCwHrREyUKG/F5PeplyLOh/efBqJ0WrriExa7phPSQ52+DjGCShzmyMltP58mb59sWJ
         G4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793886519; x=1794491319;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9+Yxi1ftCSHBSZMF0+tAoCrDEYB5+kuJMJfx5CyWJaI=;
        b=JtKsEN4dO80Cs3wMeHDw2J+5TnBIoNBztTAv5aFT+yXmRa1lJGwKj8NiFSGGcOY7nH
         h0I4yD+Aq8strskWujjrw3aGwuhLFBs9MwKdLBTSwUQr8UDVZpYGcnROexA+JrKSFSHU
         JcJhgd8w93sWTwowCi7+R0gUbvKN/arCWExYTb1ue3HR0w5F3Pf+5PFHzZMV/Jq7uO+2
         1MjbGl4cWQWUp6ETG9Sv9wi21bVelAPJSQyXyl8LljGLYM9D+WJsMVWP/t9X2SbOG+/m
         EH5PJABCdjQAERux+3JSELWViopFJcYPYuLXxvgp3vPy8306HA0DbDPWyUqVV2mJzUWK
         E/6w==
X-Gm-Message-State: APuU4Z89yuoZJrKHIiWuAGpdbiHejHH/YGRPAADWG8FjX6TjqfzZ6HD/
	WZNHDzhaKoqIw79BzYMKmMtoLOk/FYa1+6n3H2Kz3IhKlGM94Tpf58/z17iC9UXmYBupB4HJAcd
	fSirSC0zIp145g2EvaNnMhMdJvACPVzAcn+LU
X-Gm-Gg: AYBFou39oYzgDWoS4YMyfTzQvdrM5viC68/X8eyWeBH23D6xAd4K3LSIyqR3r6+wskM
	XcpoI6HFtUlefJZ5y01Bp56vgfBAQt9MWhXRlSeheotu3D1vAYp6nrZojSeR9uSn/nL5Vku1BJ3
	j5w03egyM2MFk7/xXywNIgSAClvtobWszOAz7lkCFUtG6FhWKIMjz4WUyux2C7Er8UXKvHp69zT
	HRwPzMqZ0ee785hxiVdE7HhPtBV67CMlq1nAoxkg2ws0pFToMlD6GDtlrGlvcd+NVIrsuyRZNXA
	o/9STEojyk+yiuToFuY8WoO6C+/lO2fYHlqzyUBkAYK2O/X8Svk8OTWflK44mm0qaMedx1Pm9rB
	ceG/vJbz10xofQRBJbz5+oSrytEvkq2Z3+zwyKJnN2S3Y8SByiV0hcsyE2IV8pUvrwGZ0tg35PU
	jP2HqdUw0FcXpu8EdQN66ahyIMpeqpbvaqzbYqQ4MADPZxPSN67nYbo21WVZx3jViZtCxaTA==
X-Received: by 2002:a05:6512:15a0:b0:5bf:c045:964a with SMTP id
 2adb3069b0e04-5bfd957b6bamr6950450e87.18.1793886518249; Thu, 05 Nov 2026
 05:48:38 -0800 (PST)
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
In-Reply-To: <CAD=K2o_MwSF_XS=iRu8GMPhH2Sn6t3bsKLm5BLOjZ34tV4aRvg@mail.gmail.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Thu, 5 Nov 2026 14:48:26 +0100
X-Gm-Features: AclHuK_QZfcOAWA9W_8XeXugtIZms0OYovJU8a6fG56F9WNmmVgs4_rmfeKEZkE
Message-ID: <CAD=K2o82LSzq9CN3mQxfoByGCteSLCXXetjnxLGQaQv+8gC6-A@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

small update: my distro has meanwhile shipped a new kernel,
I'm now running 7.3.1-202.nobara.fc44.x86_64 .

I haven't tested with it yet, the fs is still mounted read-only
via fstab. Should I try a read-write mount with the new kernel,
or do you want the on-disk state left untouched until you've
looked at the zone report?

Thanks,
Jochen

Am Do., 5. Nov. 2026 um 14:38 Uhr schrieb Jochen Philipp <a2jphilipp@gmail.=
com>:
>
> Hallo Johannes,
>
> wie versprochen der blkzone-Report im Anhang (191.776 Zeilen,
> xz-komprimiert).
>
> Danke auch f=C3=BCr das Angebot, auf Deutsch zu wechseln. Auf der
> Liste bleibe ich der Dokumentation zuliebe bei Englisch, aber
> hier privat ist es f=C3=BCr mich nat=C3=BCrlich einfacher.
>
> Der Offenheit halber, wie schon in meiner ersten Mail erw=C3=A4hnt:
> Ich bin gelernter Fachinformatiker, aber kein Kernel- oder
> Dateisystem-Entwickler. Bei der Analyse und beim Verstehen der
> Logs hat mir Claude (Anthropic) geholfen. Die Befehle f=C3=BChre ich
> selbst aus und nur, wenn ich verstanden habe, was sie tun. Falls
> du mir also etwas zum Testen schickst, bin ich f=C3=BCr eine kurze
> Erkl=C3=A4rung dankbar, was der Schritt bewirkt.
>
> Viele Gr=C3=BC=C3=9Fe
> Jochen
>
> Am Do., 5. Nov. 2026 um 14:36 Uhr schrieb Jochen Philipp <a2jphilipp@gmai=
l.com>:
> >
> > Hi Johannes,
> >
> > no problem, hope you had a good vacation!
> >
> > Dropping the list was not on purpose, sorry about that - re-added
> > it. Happy to stay in English here for the archive.
> >
> > The full 'blkzone report /dev/sda' output is ~191k lines, so I've
> > sent it to you off-list as an xz-compressed attachment.
> >
> > The fs is currently mounted read-only via fstab, untouched since
> > the last abort. I'll leave it like that until you tell me
> > otherwise.
> >
> > Thanks,
> > Jochen
> >
> > Am Do., 5. Nov. 2026 um 14:07 Uhr schrieb Johannes Thumshirn
> > <johannes.thumshirn@wdc.com>:
> > >
> > > On 11/2/26 1:28 PM, Jochen Philipp wrote:
> > > > Hi Johannes,
> > > > in addition:
> > > >
> > > > On unmount, 26 extent buffers from the aborted transaction could
> > > > not be released (gen 860, contiguous addresses 16K apart, owners
> > > > 1/2/4/10/11):
> > > >
> > > > [23383.428807] BTRFS info (device sda state EA): last unmount of
> > > > filesystem d7485764-0e3c-416e-8b4f-56904307949f
> > > > [23383.451749] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779683803136 owner 4 gen 860 refs 2 flags 0x7
> > > > [23383.451756] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779683819520 owner 10 gen 860 refs 2 flags 0x7
> > > > [23383.451760] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779683835904 owner 10 gen 860 refs 2 flags 0x7
> > > > [23383.451763] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779683852288 owner 11 gen 860 refs 2 flags 0x7
> > > > ...
> > > > [23383.451814] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779684179968 owner 2 gen 860 refs 2 flags 0x7
> > > > [23383.451817] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779684196352 owner 2 gen 860 refs 2 flags 0x7
> > > > [23383.451820] BTRFS warning (device sda state EA): unable to relea=
se
> > > > extent buffer 5779684212736 owner 1 gen 860 refs 2 flags 0x7
> > > >
> > > > ...
> > > > Thanks,
> > > > Jochen
> > > >
> > > > Am Mo., 2. Nov. 2026 um 13:15 Uhr schrieb Jochen Philipp <a2jphilip=
p@gmail.com>:
> > > >> Hi Johannes,
> > > >>
> > > >> 7.3 is installed now (7.3.0-203.nobara.fc44), but the filesystem
> > > >> does not survive the first commit after mount anymore:
> > > >>
> > > >> - mounted at boot via fstab, ~60 seconds later the first periodic
> > > >>    commit fails with -EAGAIN, fs forced read-only
> > > >> - no user writes at all before the abort
> > > >> - on-disk transid is 859, the aborted transaction is 860 - the sam=
e
> > > >>    transaction number that was aborted in my second report on 7.2
> > > >>
> > > >> My guess as a layman: the aborted commit on 7.2 left something on
> > > >> disk (maybe partially written metadata in a zone) that the fs now
> > > >> trips over on every mount. But that's just a guess.
> > > >>
> > > >> Nov 02 06:39:23 nobara-X99 kernel: mlx4_en: ens4: Steering Mode 1
> > > >> Nov 02 06:39:24 nobara-X99 kernel: mlx4_en: ens4: Link Down
> > > >> Nov 02 06:39:26 nobara-X99 kernel: r8169 0000:06:00.0 enp6s0: Link=
 is
> > > >> Up - 1Gbps/Full - flow control off
> > > >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS error (device sda): error
> > > >> while writing out transaction: -EAGAIN
> > > >> Nov 02 06:40:20 nobara-X99 kernel: ------------[ cut here ]-------=
-----
> > > >> Nov 02 06:40:20 nobara-X99 kernel: btrfs_abort_should_print_stack(=
__error)
> > > >> Nov 02 06:40:20 nobara-X99 kernel: WARNING:
> > > >> fs/btrfs/transaction.c:2603 at btrfs_commit_transaction+0xf70/0x10=
00,
> > > >> CPU#3: btrfs-transacti/1806
> > > >> Nov 02 06:40:20 nobara-X99 kernel: Modules linked in: nvidia_uvm(O=
E)
> > > >> snd_seq_dummy snd_hrtimer mlx4_ib mlx4_en ptp ib_core pps_core
> > > >> nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
> > > >> nft_fib_ipv4 uinput nft_fib_ipv6 nft_fib nft_reject_inet
> > > >> nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_n=
at
> > > >> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill nf_tables qrtr
> > > >> sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency
> > > >> intel_uncore_frequency_common sb_edac x86_pkg_temp_thermal
> > > >> intel_powerclamp coretemp vfat nvidia_drm(OE) fat kvm_intel
> > > >> nvidia_modeset(OE) kvm snd_hda_codec_alc662 spi_nor
> > > >> snd_hda_codec_realtek_lib mtd snd_hda_codec_generic irqbypass r816=
9
> > > >> rapl snd_hda_codec_nvhdmi snd_hda_codec_hdmi intel_cstate realtek
> > > >> phy_package iTCO_wdt spi_intel_platform spi_intel gpio_ich
> > > >> intel_pmc_bxt snd_hda_intel intel_uncore mdio_devres i2c_i801
> > > >> snd_hda_codec mxm_wmi pcspkr nvidia(OE) libphy i2c_smbus mdio_bus
> > > >> i2c_mux snd_hda_core snd_intel_dspcfg snd_intel_sdw_acpi snd_hwdep
> > > >> snd_seq mousedev joydev snd_seq_device
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  drm_ttm_helper snd_pcm ttm
> > > >> drm_display_helper snd_timer cec snd mlx4_core soundcore video lpc=
_ich
> > > >> mac_hid dm_mod zram 842_decompress 842_compress lz4hc_compress
> > > >> aesni_intel psmouse gf128mul wmi serio_raw crypto_user
> > > >> Nov 02 06:40:20 nobara-X99 kernel: CPU: 3 UID: 0 PID: 1806 Comm:
> > > >> btrfs-transacti Tainted: G           OE
> > > >> 7.3.0-203.nobara.fc44.x86_64 #1 PREEMPT(lazy)
> > > >> 002a07c3ed1de4339a31acc811ef5db3e3582962
> > > >> Nov 02 06:40:20 nobara-X99 kernel: Tainted: [O]=3DOOT_MODULE, [E]=
=3DUNSIGNED_MODULE
> > > >> Nov 02 06:40:20 nobara-X99 kernel: Hardware name: MACHINIST /E5-MR=
9A
> > > >> PRO, BIOS 5.11 08/05/2024
> > > >> Nov 02 06:40:20 nobara-X99 kernel: RIP:
> > > >> 0010:btrfs_commit_transaction+0xf70/0x1000
> > > >> Nov 02 06:40:20 nobara-X99 kernel: Code: 8b 43 60 f0 48 0f ba a8 8=
8 0a
> > > >> 00 00 02 0f 82 fc f5 6c ff 8d 45 1e 83 f8 19 77 0f ba 01 00 04 02 =
48
> > > >> 0f a3 c2 0f 82 bf f5 6c ff <0f> 0b e9 b8 f5 6c ff be 03 00 00 00 4=
c 89
> > > >> ef e8 ac 8c 2f 00 e9 41
> > > >> Nov 02 06:40:20 nobara-X99 kernel: RSP: 0018:ffffce5e815abe28 EFLA=
GS: 00010296
> > > >> Nov 02 06:40:20 nobara-X99 kernel: RAX: 0000000000000013 RBX:
> > > >> ffff8970dcf1e1f0 RCX: 0000000000000001
> > > >> Nov 02 06:40:20 nobara-X99 kernel: RDX: 0000000002040001 RSI:
> > > >> 0000000000000000 RDI: ffff8970d6e0d400
> > > >> Nov 02 06:40:20 nobara-X99 kernel: RBP: 00000000fffffff5 R08:
> > > >> ffff89803ff49801 R09: ffffffff8d1d9ec0
> > > >> Nov 02 06:40:20 nobara-X99 kernel: R10: ffffce5e815abbd0 R11:
> > > >> ffffce5e815abbc8 R12: ffff8970d0a2a000
> > > >> Nov 02 06:40:20 nobara-X99 kernel: R13: ffff8970d0a2a468 R14:
> > > >> ffff8970fa392800 R15: ffff8970d0a2a470
> > > >> Nov 02 06:40:20 nobara-X99 kernel: FS:  0000000000000000(0000)
> > > >> GS:ffff898072788000(0000) knlGS:0000000000000000
> > > >> Nov 02 06:40:20 nobara-X99 kernel: CS:  0010 DS: 0000 ES: 0000 CR0=
:
> > > >> 0000000080050033
> > > >> Nov 02 06:40:20 nobara-X99 kernel: CR2: 00007f7fefc07000 CR3:
> > > >> 0000000060222004 CR4: 00000000003726f0
> > > >> Nov 02 06:40:20 nobara-X99 kernel: Call Trace:
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  <TASK>
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ? start_transaction+0x337/0x8c=
0
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ? schedule_hrtimeout+0x150/0x1=
50
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  transaction_kthread+0x152/0x1c=
0
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ? __pfx_transaction_kthread+0x=
10/0x10
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  kthread+0xe6/0x120
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ret_from_fork+0x294/0x330
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  ret_from_fork_asm+0x1a/0x30
> > > >> Nov 02 06:40:20 nobara-X99 kernel:  </TASK>
> > > >> Nov 02 06:40:20 nobara-X99 kernel: ---[ end trace 0000000000000000=
 ]---
> > > >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS error (device sda state A=
):
> > > >> Transaction 860 aborted (-EAGAIN)
> > > >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS: error (device sda state =
A)
> > > >> in btrfs_commit_transaction:2603: errno=3D-11 unknown
> > > >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS info (device sda state EA=
):
> > > >> forced readonly
> > > >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS warning (device sda state
> > > >> EA): Skipping commit of aborted transaction.
> > > >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS: error (device sda state =
EA)
> > > >> in cleanup_transaction:2074: errno=3D-11 unknown
> > > >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS: device label Dateien dev=
id 1
> > > >> transid 8893 /dev/nvme0n1p1 (259:5) scanned by pool-7 (5400)
> > > >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> > > >> first mount of filesystem c70bbc9e-8d1e-416c-8fef-1c8233578d21
> > > >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> > > >> using crc32c checksum algorithm
> > > >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> > > >> enabling ssd optimizations
> > > >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> > > >> turning on async discard
> > > >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> > > >> enabling free space tree
> > > >> Nov 02 07:39:43 nobara-X99 kernel: loop: module loaded
> > > >> Nov 02 07:39:43 nobara-X99 kernel: loop0: detected capacity change
> > > >> from 0 to 1824522240
> > > >>
> > > >> btrfs check --readonly:
> > > >> Opening filesystem to check...
> > > >> Checking filesystem on /dev/sda
> > > >> UUID: d7485764-0e3c-416e-8b4f-56904307949f
> > > >> [1/8] checking log skipped (none written)
> > > >> [2/8] checking root items
> > > >> [3/8] checking extents
> > > >> [4/8] checking free space tree
> > > >> [5/8] checking fs roots
> > > >> [6/8] checking only csums items (without verifying data)
> > > >> [7/8] checking root refs
> > > >> [8/8] checking quota groups skipped (not enabled on this FS)
> > > >> found 4329982099456 bytes used, no error found
> > > >> total csum bytes: 4222777424
> > > >> total tree bytes: 5858017280
> > > >> total fs tree bytes: 517259264
> > > >> total extent tree bytes: 572080128
> > > >> btree space waste bytes: 557473441
> > > >> file data blocks allocated: 4324124082176
> > > >>   referenced 4324124082176
> > > >>
> > > >> I haven't tried any repair. Reading works. Should I collect
> > > >> anything else (zone report, dump-super, ...) before touching it?
> > > >> Or is the fs in a state where recreating it is the only way?
> > >
> > > Sorry for the late answer, I've been on vacation for a few days.
> > >
> > > OK this is exactly what my patches should've fixed. I'll dig. Can you
> > > also send me the output of 'blkzone report /dev/sda' so I can check w=
hat
> > > the zone layout on the disks is.
> > >
> > >
> > > Btw did you drop the Mailinglist on purpose? If you don't mind I'd li=
ke
> > > to re-add it (for documentation purposes). But if you did it on purpo=
se,
> > > I'd also be happy to switch to German (judging from your name and the
> > > Label of your drive I  think it's your native language as well).
> > >
