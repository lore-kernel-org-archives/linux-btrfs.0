Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793885815;
	b=d2/42un+DX8RcG+BJsC/DZulRCaXVGpHR4wg6j9SQunMs5LvAfRNDYLN5/EnB7o/u7Xw
	 JMGypSmJA9FYWeDuQHe6BduMFvmjX4b0OAWcVP2GH2oWcyYmfIUhjFGo6wkrlP8+VDL+1
	 FqsWku9VR1QMUCaNLQPWMTW4ybH9wwXogZp/k9mlGWFZoPgbUjYQ76bQ0FqkcmJ9Eg077
	 MfkYumZau/84T/T4T6fLGUXTqDicu2Ji1eAcjSJTGj3inADimV3g4MJQh+APiA6j0QChM
	 CdwJfpPeZowJEPPReWkzAYCygAszWnsdvpZEjTbuuFHRcVPls825XQOgjpYo3qzaEyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793885815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=E/JaD1BhtEGYNt4yt7vPgLEA4SKFHQo60mOAW9/7kiM=;
	b=oMZ9rjqZjrne4SLOMajcE/w78P3cQ1t3qGnvEkf+v/HsUGlziQavCgnNoe7nU4cEF4bg
	 gQobLQe6LyyNAJvB67xShANSgoTjJl4/7yrf4uEZN+M9mYgFmuyl60/JsTTt4mMYjRfvE
	 Zqqd5LWpvEa6ah4mURTLp2Qhf9x33AzVECBleL+jqcPG02yGv1zc9JCsrg6voMwnEupL4
	 e9deIcezbcK59Xoz6O/RnZA/RTI3CKJrmoa4F1mWHsxWlXzN88ii4by7+GRuhYLQFwhJh
	 NOOu9ocIfsqaajOCxzDGuRGjtsSCW+65ZXUWDsVBtEUUVwENfNDK0B2nGlEoTc7zUpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pNxnVrV1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD5B606A332
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 13:36:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCD5B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pNxnVrV1
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be4c78e8caso1542428e87.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 05:36:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793885813; cv=none;
        d=google.com; s=arc-20260327;
        b=W+hWLwSw8QApObfSvhldXP1XM5xrJQoZIrcbgkZQtq0Xg5Ti03Rah6jGcNBg8aVqQi
         XMR5j2KGoVVocSEhUbanWb67eGmDwqp1hn8NpFM5UC2ZSO3VJYWBWQ6KID8upXa763Rf
         BnEt8v157WpzAGZEN/HcBHdYWRjSmjiAOZbmRIoFXZ9nw65nQSKEpwBCUFd39tpyOluc
         Qk508XPi3Ak8Qc1fn8RPx2XhTcsLgXUhM58HMPjG54Rn8AkYA8tSAY1Tr5ID6szgYy9p
         rTvDyRIXgJvZWA0FIfwe9u5gxhrSTq+yG6bpQP5YeSGgV9QNQrw2M7POkU5vUzq+OiSy
         msKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=E/JaD1BhtEGYNt4yt7vPgLEA4SKFHQo60mOAW9/7kiM=;
        fh=XgyVQL63bakpFfKqPxJJiY5NdZTbMYsxaBXyIXgyd7w=;
        b=OyDKZa7SwIxPSkbBOo7qCj6QU7BlGB1qjk2kZamhB7Su9J1FLUrmr8Ms4dmxV7PMQy
         zKS0giAJxJyvhhRj3/i8OOmvKpadMeG1wUlmMDnOcag2pNHQEBvPtt5vslawiqCh2KE+
         Adjkp84aKH2F2SpNRJyxunq2WuomjAo7E+KAzGbcCJ+biCMnkoFAAjkXqSeReq6Z0Wlj
         iSbU/+uGFjj0ZY9OAAo3tHBpbWE03/4o2TKWCvjmYBLVvHJKXbbl+UhuSgTJdRE4ceZq
         XFHUO5Y5GQcRYsPeVYBVPwyxdxhgt/LHuSxnWQSRmGkqsoM6eOemOeXb3xqwMoL24FmK
         SvXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793885813; x=1794490613; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E/JaD1BhtEGYNt4yt7vPgLEA4SKFHQo60mOAW9/7kiM=;
        b=pNxnVrV1Y1d1N5Y1a/C6W7woSNArE8ZSkEJlYvcxJfiaxPvBsw3zocShwRZOmjUa6i
         8gwTmRqAfv2biezYwQOS/s0FjL0dVoMY58gcDmQigaY371fvBWwPiV3jm/IsCSNKykq6
         LKUu6Ct7cNlRqECoCbH07Z//cz2L6heq+QbWMg1kNvoEFVIB+jrTk14NpkRJffoOa4sm
         g5Qbma1VASqKnN/IyLIVeWDO0eiImyWdORkFFyq99RyS0Sj6qnJLNqlDhNwoFGBXoG/v
         wLqfp6Ldh/lJZgR9I0wywhYZZna6Jmoas8yEIDwum68eR4hL6hVAzmCHWxCSMSl5ZJFK
         j55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793885813; x=1794490613;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=E/JaD1BhtEGYNt4yt7vPgLEA4SKFHQo60mOAW9/7kiM=;
        b=nIuFJ5qOmL52t/YRs0ZMSfB+XyhSc9szTscsRWs+Qz9D+xallRd70lknWT1GHfSQjF
         eifZX8k0dGLyurxL0eDcuEEvAfgi1dCLzqVQhXJhAiK2+4a5wvRvo+GEcQUcw6Q5fNAD
         zx1kjUilVHI/Rb75FhJgtIzcudFxYbOkKSVlLxfUVk/4Qx+xzVGKfmgQejbfeB2XCksr
         /uiW7XREBljz8BQu7+H2FIgneg9HZ+LhY26Kxf64R/zmLkid9ZYdKKKS+c1nT8LWMb5J
         HahLI2invHyZ2c/2MnLQem60xd/F8RINL24W2Btm+IIX3baT1XRc/esxhGp08vnXGw4r
         YS2g==
X-Gm-Message-State: APuU4Z/8t1XR/6AKszRWg1gO25GM1QlIcZUEOc/ukktQOdSWVAD2arrZ
	JxHFZB6vugLaC81kixXHLH4SiVFiFaJabmLk0qlsZsOWNEsFgVCg+b2x3YoJQQxRtdOWmm1nBVN
	I1yTdlzCsnHNGvl7n+GksWabXnKEXqr/gPMiV
X-Gm-Gg: AYBFou3f40GyYPjFcjS/31yggD1HjxAKEzdoeX6epKmS8pGfWvY8tjxlfbQ9vmlqt3c
	Hvf0Gx/DNGsrXaUfJkqlwn1oMimSSQU/9OWRA/sSoTG0HXvsTCtuYfBbnupuohktJ0mzOYP8S3R
	Bfi5p2beRm2uBFhojRl/UWvvdp7VuJ2qVNW+UB6HB5DavvdS6xsBSGDN/GiMkzNm50Kv+RuZWgL
	GKk5qoKdWrYB4L90oPU7w9b9P3UoyPiUYnljLtQjOA8EboALxXV8HVOdyUNd/kWEUyr9AZqVlE2
	m3Of+13ceT2c+XtCJRoj37E2kRGNeQnDTDpdYdFZhE8xWWp4t4U6f8WEqwVFfWwCpSeMM5wtkNV
	H9Z8A9YlDYvIf9c6lm6srXNxEl/XGOyKM9LCxJ6QB/LkhSqvyaV1kkpQY1GImcb4D2wggvazA81
	9lwZiI58n/KiDUU+EB84Rply9X+tt2s4PXy4RWixiHm9OQMAUE3RxBg4fXu7GKgmEsAnaYmA==
X-Received: by 2002:a05:6512:124a:b0:5bf:d60c:9f98 with SMTP id
 2adb3069b0e04-5bfd9583912mr7363113e87.59.1793885812611; Thu, 05 Nov 2026
 05:36:52 -0800 (PST)
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
 <CAD=K2o8kWgTRqBBw1sRfO2fopqQOLfdeX61h=OFPMST=Wdo+KQ@mail.gmail.com> <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
In-Reply-To: <30a6e871-8578-4d27-bb0a-679b94fb7f92@wdc.com>
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Thu, 5 Nov 2026 14:36:41 +0100
X-Gm-Features: AclHuK-hK9FARP3GAWdzRGPINXv1zGASS0vG0WFD6tYor7cjodOnzi8T5rI9QkE
Message-ID: <CAD=K2o9LbeJUcb0xefwVx-rC5udLNLwqouO8pqFB0R+rWQvHng@mail.gmail.com>
Subject: Re: Subject: zoned: transaction abort with -EAGAIN (-11) on
 host-managed SMR (WD HC670), fs forced read-only
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Johannes,

no problem, hope you had a good vacation!

Dropping the list was not on purpose, sorry about that - re-added
it. Happy to stay in English here for the archive.

The full 'blkzone report /dev/sda' output is ~191k lines, so I've
sent it to you off-list as an xz-compressed attachment.

The fs is currently mounted read-only via fstab, untouched since
the last abort. I'll leave it like that until you tell me
otherwise.

Thanks,
Jochen

Am Do., 5. Nov. 2026 um 14:07 Uhr schrieb Johannes Thumshirn
<johannes.thumshirn@wdc.com>:
>
> On 11/2/26 1:28 PM, Jochen Philipp wrote:
> > Hi Johannes,
> > in addition:
> >
> > On unmount, 26 extent buffers from the aborted transaction could
> > not be released (gen 860, contiguous addresses 16K apart, owners
> > 1/2/4/10/11):
> >
> > [23383.428807] BTRFS info (device sda state EA): last unmount of
> > filesystem d7485764-0e3c-416e-8b4f-56904307949f
> > [23383.451749] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779683803136 owner 4 gen 860 refs 2 flags 0x7
> > [23383.451756] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779683819520 owner 10 gen 860 refs 2 flags 0x7
> > [23383.451760] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779683835904 owner 10 gen 860 refs 2 flags 0x7
> > [23383.451763] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779683852288 owner 11 gen 860 refs 2 flags 0x7
> > ...
> > [23383.451814] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779684179968 owner 2 gen 860 refs 2 flags 0x7
> > [23383.451817] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779684196352 owner 2 gen 860 refs 2 flags 0x7
> > [23383.451820] BTRFS warning (device sda state EA): unable to release
> > extent buffer 5779684212736 owner 1 gen 860 refs 2 flags 0x7
> >
> > ...
> > Thanks,
> > Jochen
> >
> > Am Mo., 2. Nov. 2026 um 13:15 Uhr schrieb Jochen Philipp <a2jphilipp@gmail.com>:
> >> Hi Johannes,
> >>
> >> 7.3 is installed now (7.3.0-203.nobara.fc44), but the filesystem
> >> does not survive the first commit after mount anymore:
> >>
> >> - mounted at boot via fstab, ~60 seconds later the first periodic
> >>    commit fails with -EAGAIN, fs forced read-only
> >> - no user writes at all before the abort
> >> - on-disk transid is 859, the aborted transaction is 860 - the same
> >>    transaction number that was aborted in my second report on 7.2
> >>
> >> My guess as a layman: the aborted commit on 7.2 left something on
> >> disk (maybe partially written metadata in a zone) that the fs now
> >> trips over on every mount. But that's just a guess.
> >>
> >> Nov 02 06:39:23 nobara-X99 kernel: mlx4_en: ens4: Steering Mode 1
> >> Nov 02 06:39:24 nobara-X99 kernel: mlx4_en: ens4: Link Down
> >> Nov 02 06:39:26 nobara-X99 kernel: r8169 0000:06:00.0 enp6s0: Link is
> >> Up - 1Gbps/Full - flow control off
> >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS error (device sda): error
> >> while writing out transaction: -EAGAIN
> >> Nov 02 06:40:20 nobara-X99 kernel: ------------[ cut here ]------------
> >> Nov 02 06:40:20 nobara-X99 kernel: btrfs_abort_should_print_stack(__error)
> >> Nov 02 06:40:20 nobara-X99 kernel: WARNING:
> >> fs/btrfs/transaction.c:2603 at btrfs_commit_transaction+0xf70/0x1000,
> >> CPU#3: btrfs-transacti/1806
> >> Nov 02 06:40:20 nobara-X99 kernel: Modules linked in: nvidia_uvm(OE)
> >> snd_seq_dummy snd_hrtimer mlx4_ib mlx4_en ptp ib_core pps_core
> >> nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
> >> nft_fib_ipv4 uinput nft_fib_ipv6 nft_fib nft_reject_inet
> >> nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat
> >> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill nf_tables qrtr
> >> sunrpc intel_rapl_msr intel_rapl_common intel_uncore_frequency
> >> intel_uncore_frequency_common sb_edac x86_pkg_temp_thermal
> >> intel_powerclamp coretemp vfat nvidia_drm(OE) fat kvm_intel
> >> nvidia_modeset(OE) kvm snd_hda_codec_alc662 spi_nor
> >> snd_hda_codec_realtek_lib mtd snd_hda_codec_generic irqbypass r8169
> >> rapl snd_hda_codec_nvhdmi snd_hda_codec_hdmi intel_cstate realtek
> >> phy_package iTCO_wdt spi_intel_platform spi_intel gpio_ich
> >> intel_pmc_bxt snd_hda_intel intel_uncore mdio_devres i2c_i801
> >> snd_hda_codec mxm_wmi pcspkr nvidia(OE) libphy i2c_smbus mdio_bus
> >> i2c_mux snd_hda_core snd_intel_dspcfg snd_intel_sdw_acpi snd_hwdep
> >> snd_seq mousedev joydev snd_seq_device
> >> Nov 02 06:40:20 nobara-X99 kernel:  drm_ttm_helper snd_pcm ttm
> >> drm_display_helper snd_timer cec snd mlx4_core soundcore video lpc_ich
> >> mac_hid dm_mod zram 842_decompress 842_compress lz4hc_compress
> >> aesni_intel psmouse gf128mul wmi serio_raw crypto_user
> >> Nov 02 06:40:20 nobara-X99 kernel: CPU: 3 UID: 0 PID: 1806 Comm:
> >> btrfs-transacti Tainted: G           OE
> >> 7.3.0-203.nobara.fc44.x86_64 #1 PREEMPT(lazy)
> >> 002a07c3ed1de4339a31acc811ef5db3e3582962
> >> Nov 02 06:40:20 nobara-X99 kernel: Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> >> Nov 02 06:40:20 nobara-X99 kernel: Hardware name: MACHINIST /E5-MR9A
> >> PRO, BIOS 5.11 08/05/2024
> >> Nov 02 06:40:20 nobara-X99 kernel: RIP:
> >> 0010:btrfs_commit_transaction+0xf70/0x1000
> >> Nov 02 06:40:20 nobara-X99 kernel: Code: 8b 43 60 f0 48 0f ba a8 88 0a
> >> 00 00 02 0f 82 fc f5 6c ff 8d 45 1e 83 f8 19 77 0f ba 01 00 04 02 48
> >> 0f a3 c2 0f 82 bf f5 6c ff <0f> 0b e9 b8 f5 6c ff be 03 00 00 00 4c 89
> >> ef e8 ac 8c 2f 00 e9 41
> >> Nov 02 06:40:20 nobara-X99 kernel: RSP: 0018:ffffce5e815abe28 EFLAGS: 00010296
> >> Nov 02 06:40:20 nobara-X99 kernel: RAX: 0000000000000013 RBX:
> >> ffff8970dcf1e1f0 RCX: 0000000000000001
> >> Nov 02 06:40:20 nobara-X99 kernel: RDX: 0000000002040001 RSI:
> >> 0000000000000000 RDI: ffff8970d6e0d400
> >> Nov 02 06:40:20 nobara-X99 kernel: RBP: 00000000fffffff5 R08:
> >> ffff89803ff49801 R09: ffffffff8d1d9ec0
> >> Nov 02 06:40:20 nobara-X99 kernel: R10: ffffce5e815abbd0 R11:
> >> ffffce5e815abbc8 R12: ffff8970d0a2a000
> >> Nov 02 06:40:20 nobara-X99 kernel: R13: ffff8970d0a2a468 R14:
> >> ffff8970fa392800 R15: ffff8970d0a2a470
> >> Nov 02 06:40:20 nobara-X99 kernel: FS:  0000000000000000(0000)
> >> GS:ffff898072788000(0000) knlGS:0000000000000000
> >> Nov 02 06:40:20 nobara-X99 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> >> 0000000080050033
> >> Nov 02 06:40:20 nobara-X99 kernel: CR2: 00007f7fefc07000 CR3:
> >> 0000000060222004 CR4: 00000000003726f0
> >> Nov 02 06:40:20 nobara-X99 kernel: Call Trace:
> >> Nov 02 06:40:20 nobara-X99 kernel:  <TASK>
> >> Nov 02 06:40:20 nobara-X99 kernel:  ? start_transaction+0x337/0x8c0
> >> Nov 02 06:40:20 nobara-X99 kernel:  ? schedule_hrtimeout+0x150/0x150
> >> Nov 02 06:40:20 nobara-X99 kernel:  transaction_kthread+0x152/0x1c0
> >> Nov 02 06:40:20 nobara-X99 kernel:  ? __pfx_transaction_kthread+0x10/0x10
> >> Nov 02 06:40:20 nobara-X99 kernel:  kthread+0xe6/0x120
> >> Nov 02 06:40:20 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
> >> Nov 02 06:40:20 nobara-X99 kernel:  ret_from_fork+0x294/0x330
> >> Nov 02 06:40:20 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
> >> Nov 02 06:40:20 nobara-X99 kernel:  ret_from_fork_asm+0x1a/0x30
> >> Nov 02 06:40:20 nobara-X99 kernel:  </TASK>
> >> Nov 02 06:40:20 nobara-X99 kernel: ---[ end trace 0000000000000000 ]---
> >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS error (device sda state A):
> >> Transaction 860 aborted (-EAGAIN)
> >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS: error (device sda state A)
> >> in btrfs_commit_transaction:2603: errno=-11 unknown
> >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS info (device sda state EA):
> >> forced readonly
> >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS warning (device sda state
> >> EA): Skipping commit of aborted transaction.
> >> Nov 02 06:40:20 nobara-X99 kernel: BTRFS: error (device sda state EA)
> >> in cleanup_transaction:2074: errno=-11 unknown
> >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS: device label Dateien devid 1
> >> transid 8893 /dev/nvme0n1p1 (259:5) scanned by pool-7 (5400)
> >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> >> first mount of filesystem c70bbc9e-8d1e-416c-8fef-1c8233578d21
> >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> >> using crc32c checksum algorithm
> >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> >> enabling ssd optimizations
> >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> >> turning on async discard
> >> Nov 02 07:38:52 nobara-X99 kernel: BTRFS info (device nvme0n1p1):
> >> enabling free space tree
> >> Nov 02 07:39:43 nobara-X99 kernel: loop: module loaded
> >> Nov 02 07:39:43 nobara-X99 kernel: loop0: detected capacity change
> >> from 0 to 1824522240
> >>
> >> btrfs check --readonly:
> >> Opening filesystem to check...
> >> Checking filesystem on /dev/sda
> >> UUID: d7485764-0e3c-416e-8b4f-56904307949f
> >> [1/8] checking log skipped (none written)
> >> [2/8] checking root items
> >> [3/8] checking extents
> >> [4/8] checking free space tree
> >> [5/8] checking fs roots
> >> [6/8] checking only csums items (without verifying data)
> >> [7/8] checking root refs
> >> [8/8] checking quota groups skipped (not enabled on this FS)
> >> found 4329982099456 bytes used, no error found
> >> total csum bytes: 4222777424
> >> total tree bytes: 5858017280
> >> total fs tree bytes: 517259264
> >> total extent tree bytes: 572080128
> >> btree space waste bytes: 557473441
> >> file data blocks allocated: 4324124082176
> >>   referenced 4324124082176
> >>
> >> I haven't tried any repair. Reading works. Should I collect
> >> anything else (zone report, dump-super, ...) before touching it?
> >> Or is the fs in a state where recreating it is the only way?
>
> Sorry for the late answer, I've been on vacation for a few days.
>
> OK this is exactly what my patches should've fixed. I'll dig. Can you
> also send me the output of 'blkzone report /dev/sda' so I can check what
> the zone layout on the disks is.
>
>
> Btw did you drop the Mailinglist on purpose? If you don't mind I'd like
> to re-add it (for documentation purposes). But if you did it on purpose,
> I'd also be happy to switch to German (judging from your name and the
> Label of your drive I  think it's your native language as well).
>
