Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA2D4FD790
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792420280; cv=pass; b=kK8zWfCtlmQ8hIyaYtZqyVjF62mzF0BWvMMOeMAGg+1T5nNk3L97M/qOwz2uA+7l5P/mbTWXMoPN47/Sdyt0F4snv+xA7NOE/+JBU1Wvg3ZZIWko4/naVc7jkx5BBfDrjFnOYesvY8twy6blFRIYLGl7hKs3yDi00n9hpdURH3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792420280; c=relaxed/simple;
	bh=KbdS1QoZ1PXBwd4Ez11kzBP2POxVWA/9t6cQuS/WKQg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=gu+6zIFlX66wZk6Qx/lPoqwD7k4Ss44tSmg1eTmOofnohgDtJUwHWDUAgRpShtQuyIKoKcAc51Tj2rua6Qv2aNOwR9uw8HIPKbnCwjITwK9p0rk/HRMIlQa49hXw7Ai0ksd+pqHzizFn0fd3BnBHRE+gTCeMpEHfPwFYGtO2eLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NaiMzuCv; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NaiMzuCv"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5be4c78e8caso1830512e87.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 07:31:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792420276; cv=none;
        d=google.com; s=arc-20260327;
        b=GutUiuM+VTxBUcUkwkDW+cjKVp/2AfMkgYDPjYCYPXytZFTT994+JfFKsoLW6MqoLH
         ZNMVuvYLqDyguHtu3ZTnfQtx93MStZD2A/zEZ8ew3/RfU2HixAYvC5hxZSzCh/fYButx
         pAj0bas4FvK14ZeqrN+RucxewrlnmBogrO7q8bNQ1fe8+x1fIS44DleJSazcojRVuN42
         H9APi6sJhqHlGcPjeLZo+UMq9d3lL5qf97SKmXUCoMr1eGmkWn9O0YC1yy8gv7+ClMpe
         Dh5OHexzbuxXP/fCccEe9Rsne3k/DWl8oUxFS2gqPZf/P7L6uT4JgaPwzg7i28wVDLud
         r/2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=ltGPjWMuYtX5UImiAm1OeSwgCatpc5k8jIn80e3IXwc=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=ofVz4IVudO4Xtq4kql0Ri+6iyUKyUT1GSeKmWfYkWinWdumT7GyCn3X9a6p98AdiJO
         fiYYKcVkfuBW9lLAyuDXi/lhCSQra8u/6yRGYTgHaPf25g1KpZtPCqvs7tQvERbu59PY
         TZFVZMqw98wK3O852uX0uDosQrHKsiPAhtCmSnf6GugoaiIQCwgLskun9jzGHOvZG4Rz
         CpgXbuz95eIezGUkWeidi5lkbKoa1bp1+A2LHNHnx/N85WdEy6Sc2YgYlHL4VasF8HU0
         t3Ox8f3qbtUBFfEuMp5iKi6YYXXXV3a3uHAPYWN+ucjTVcjgsNUdwuMiEU0soOcN7W1Q
         6eHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792420276; x=1793025076; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ltGPjWMuYtX5UImiAm1OeSwgCatpc5k8jIn80e3IXwc=;
        b=NaiMzuCv42qw5xwv3Ka5CQCYptJa5a4dz1fKMUzxTB8PiG5AW35EG8urLKpCs7/c4B
         JwOsaLt0CwBWwALBBN/dT3oipUQmpFpfEtIkI13B+MVIeTe1/9QwEIS3d5/0x2eNJazd
         m8NuuMNCkQ3JXG0fiR8tHLXyIjxLYBFxyEUUYt72dg88PktxOUY7VLsQEYbOOKDRpDkE
         CYRTXURsEFx16REU7nG0jUB4pEwIdGHW76F+41MAt5zki+TS8/PdaSnUEENFR52dWX0J
         CpJ6/BPOeljTloUFqFhDhW/tUemVqzqX6MPxAppywNtdaWFmc/dT7ZEwwiOhpw7BxdEy
         9dFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792420276; x=1793025076;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ltGPjWMuYtX5UImiAm1OeSwgCatpc5k8jIn80e3IXwc=;
        b=kw2x3XIdsBsguxGMz9OR3oc1fppW5VDdqZtYg7OsYu+yyiyizLvQb6qLs3z9WnTQDk
         HmKYhyh/URv1kgJZ4xvIW9/bnLGHs3vWovlkjvq/JlTSK+J53j//Nl+/N6s2DoRM4eto
         IG46gtzKj0sDKCWS6R47zYBIDdC1bZv/SVXS1Uc5RNXjcofNyOAhJvzQ/qhcsBbIxpvf
         PK1qoEs0EAOyPIAPmU8aELLrhu2HNCBwkn4ljCH1TwUSS/u00LLEyzPVv3D1XTNtfn6M
         Ao+ecCOy89YIaHId7veSg5FJ6vpQyhe9iC6cNoDIHvfy5YjXaNrZ7be58SGDe23m8pNE
         W/AQ==
X-Gm-Message-State: AFq9FYKG6nO7115eG7Uog7j0I95Y0i4XzEK2aPK7jjnTtUlG5or6tYN+
	kWN9b88B69/xbzGaGIGHq1N+5LfD7+tCiZTlBomZ1KDj7+On5LbS3F99+ZG9v7UFhSEvd3WhMhw
	LN9H9ohKn43zvHAj1y3f71JymJpQA3vAiUF06
X-Gm-Gg: AYBFou2n2UZbGXsbuUstOtSz91wpINaQAXrii2uacykHBlP/BdQiLid8OCRq99hS8u+
	BNycCOtAlyK60jdT62CpMHD5Us1Msv5tMjCgHWU87g/08KnIDp+RnwcgHV8K+CfLYLAt+TRwM5l
	J1P3ow7tq8hbwsGBFk6pPpp+RR/lC4RF6jplWpknCT3GDJygZDOW3pJVsfOOHJloZWWyXN+5ERj
	q5bz6MYThQnmDZSZmNuwHI3OddumG2fk7XxoBS5AlxQ3P1KEn6JXi9RGLLWSBJxYSUNuYCcRB+1
	HS+gLgz/C8prfG3pgkLdKKdYiyYIXZRJXdKZHO3NK7J/d0TLJTVC/hb9dIYQLAN4RXGX+6OQ3Wt
	/eS/YkaV9AOaxPth7jf2v4B/34OuY71pgP+AuiphafXGXB6F84JaW+y6bQSDUv73hMnA9CP0QlX
	gik1PPI8ppTZgD
X-Received: by 2002:a05:6512:114c:b0:5ba:4296:cb8d with SMTP id
 2adb3069b0e04-5be50a9c3eamr2987377e87.57.1792420276237; Mon, 19 Oct 2026
 07:31:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jochen Philipp <a2jphilipp@gmail.com>
Date: Mon, 19 Oct 2026 16:31:05 +0200
X-Gm-Features: AclHuK-hWpFb6gcOEQVbuecXoGepu7cT-swZaOzygz-gfl03okxrHlvH-Kxz1NY
Message-ID: <CAD=K2o-BBqh+ikgfD732Cb3M1Xx48QGw3kTFsP5iSgH1mkr0wA@mail.gmail.com>
Subject: Subject: zoned: transaction abort with -EAGAIN (-11) on host-managed
 SMR (WD HC670), fs forced read-only
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, I'm hitting a reproducible transaction abort with -EAGAIN on a
host-managed SMR drive. The filesystem is forced read-only during
plain sequential writes. Hardware: - WDC WSH722626ALN607 (Ultrastar DC
HC670 26TB, SATA, host-managed) - connected directly to onboard SATA
(Intel X99 AHCI), 6 Gbps - drive reports write cache disabled, no
DPO/FUA support Software: - Kernel: 7.2.11-200.nobara.fc44.x86_64
(Nobara/Fedora based, tainted by Nvidia out-of-tree modules) -
btrfs-progs v7.1 Zone info ( NAME ZONED        ZONE-SZ ZONE-NR
ZONE-AMAX ZONE-OMAX ZONE-APP ZONE-WGRAN
sda  host-managed    128M  191776         0       128      32M         4K
> max_open_zones / max_active_zones from sysfs: <128 0> Filesystem created =
with default options: mkfs.btrfs -L archiv /dev/sda (zoned detected automat=
ically, metadata DUP, data single, block-group-tree enabled) Workload: Sing=
le rsync job copying large video files (2.5-4.5 GB each) sequentially from =
a USB drive, ~160 MB/s. No other writers. The abort happened twice: first a=
fter ~4.3 TB written (with Dolphin, possibly two files in flight), second t=
ime ~10 minutes after remount with a single sequential rsync. What I checke=
d: - no ATA/SCSI errors in dmesg around the abort - SMART clean (no realloc=
ated/pending sectors, no CRC errors, no command timeouts, error log empty) =
- btrfs check --readonly after the first abort: no errors found - plenty of=
 unallocated space (19.5 TiB of 23.4 TiB) btrfs filesystem usage: < Overall=
:
   Device size:                  23.41TiB
   Device allocated:              3.96TiB
   Device unallocated:           19.45TiB
   Device missing:                  0.00B
   Device slack:                    0.00B
   Device zone unusable:          7.79GiB
   Device zone size:            128.00MiB
   Used:                          3.95TiB
   Free (estimated):             19.46TiB      (min: 9.73TiB)
   Free (statfs, df):            19.46TiB
   Data ratio:                       1.00
   Metadata ratio:                   2.00
   Global reserve:              512.00MiB      (used: 0.00B)
   Multiple profiles:                  no

Data,single: Size:3.95TiB, Used:3.94TiB (99.76%)
  /dev/sda        3.95TiB

Metadata,DUP: Size:8.12GiB, Used:5.46GiB (67.18%)
  /dev/sda       16.25GiB

System,DUP: Size:128.00MiB, Used:3.31MiB (2.59%)
  /dev/sda      256.00MiB

Unallocated:
  /dev/sda       19.45TiB

> dmesg of the second occurrence: < Okt 19 16:09:07 nobara-X99 kernel: BTRF=
S error (device sda): error while writing out transaction: -11
Okt 19 16:09:07 nobara-X99 kernel: ------------[ cut here ]------------
Okt 19 16:09:07 nobara-X99 kernel: btrfs_abort_should_print_stack(__error)
Okt 19 16:09:07 nobara-X99 kernel: WARNING:
fs/btrfs/transaction.c:2606 at btrfs_commit_transaction+0xf6d/0x1000,
CPU#12: btrfs-transacti/35530
Okt 19 16:09:07 nobara-X99 kernel: Modules linked in: overlay uas
usb_storage dm_crypt encrypted_keys trusted asn1_encoder tee loop
nvidia_uvm(OE
) snd_seq_dummy snd_hrtimer mlx4_ib mlx4_en ib_core ptp pps_core
uinput nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_ct rfkill nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_d
efrag_ipv4 nf_tables qrtr sunrpc nvidia_drm(OE) nvidia_modeset(OE)
intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency
_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp vfat
snd_hda_codec_alc662 snd_hda_codec_realtek_lib fat
snd_hda_codec_nvhdmi snd_h
da_codec_generic snd_hda_codec_hdmi kvm_intel spi_nor snd_hda_intel
nvidia(OE) mtd snd_hda_codec kvm snd_hda_core iTCO_wdt
spi_intel_platform spi
_intel gpio_ich intel_pmc_bxt snd_intel_dspcfg irqbypass
snd_intel_sdw_acpi r8169 rapl snd_hwdep intel_cstate realtek snd_seq
phy_package snd_seq
_device mdio_devres intel_uncore mxm_wmi
Okt 19 16:09:07 nobara-X99 kernel:  drm_ttm_helper pcspkr libphy
snd_pcm i2c_i801 ttm snd_timer i2c_smbus mdio_bus drm_display_helper
i2c_mux snd
lpc_ich cec soundcore video mousedev joydev mlx4_core mac_hid dm_mod
zram 842_decompress 842_compress lz4hc_compress aesni_intel gf128mul
psmous
e aead wmi serio_raw crypto_user
Okt 19 16:09:07 nobara-X99 kernel: CPU: 12 UID: 0 PID: 35530 Comm:
btrfs-transacti Tainted: G        W  OE
7.2.11-200.nobara.fc44.x86_64 #1
PREEMPT(lazy)  8032c1cc6f4c3d56dc9ce283429b1ba1085d0235
Okt 19 16:09:07 nobara-X99 kernel: Tainted: [W]=3DWARN, [O]=3DOOT_MODULE,
[E]=3DUNSIGNED_MODULE
Okt 19 16:09:07 nobara-X99 kernel: Hardware name: MACHINIST /E5-MR9A
PRO, BIOS 5.11 08/05/2024
Okt 19 16:09:07 nobara-X99 kernel: RIP:
0010:btrfs_commit_transaction+0xf6d/0x1000
Okt 19 16:09:07 nobara-X99 kernel: Code: 8b 43 60 f0 48 0f ba a8 88 0a
00 00 02 0f 82 cf 4c 6f ff 8d 45 1e 83 f8 19 77 0f ba 01 00 04 02 48
0f a3
c2 0f 82 92 4c 6f ff <0f> 0b e9 8b 4c 6f ff be 03 00 00 00 4c 89 ef e8
ef b6 2e 00 e9 44
Okt 19 16:09:07 nobara-X99 kernel: RSP: 0018:ffffcea7c8947e28 EFLAGS: 00010=
296
Okt 19 16:09:07 nobara-X99 kernel: RAX: 0000000000000013 RBX:
ffff8ca04ec27078 RCX: 0000000000000001
Okt 19 16:09:07 nobara-X99 kernel: RDX: 0000000002040001 RSI:
0000000000000000 RDI: ffff8cac607e1bc0
Okt 19 16:09:07 nobara-X99 kernel: RBP: 00000000fffffff5 R08:
ffff8cafbff4b801 R09: ffffffffb2bd32c0
Okt 19 16:09:07 nobara-X99 kernel: R10: ffffcea7c8947bd0 R11:
ffffcea7c8947bc8 R12: ffff8ca21087e000
Okt 19 16:09:07 nobara-X99 kernel: R13: ffff8ca21087e468 R14:
ffff8ca0f9973200 R15: ffff8ca21087e470
Okt 19 16:09:07 nobara-X99 kernel: FS:  0000000000000000(0000)
GS:ffff8cafccfe0000(0000) knlGS:0000000000000000
Okt 19 16:09:07 nobara-X99 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Okt 19 16:09:07 nobara-X99 kernel: CR2: 00000edc094d8000 CR3:
0000000fd2a22005 CR4: 00000000003726f0
Okt 19 16:09:07 nobara-X99 kernel: Call Trace:
Okt 19 16:09:07 nobara-X99 kernel:  <TASK>
Okt 19 16:09:07 nobara-X99 kernel:  ? start_transaction+0x337/0x8b0
Okt 19 16:09:07 nobara-X99 kernel:  ? schedule_timeout_interruptible+0x10/0=
x150
Okt 19 16:09:07 nobara-X99 kernel:  transaction_kthread+0x152/0x1c0
Okt 19 16:09:07 nobara-X99 kernel:  ? __pfx_transaction_kthread+0x10/0x10
Okt 19 16:09:07 nobara-X99 kernel:  kthread+0xe4/0x120
Okt 19 16:09:07 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
Okt 19 16:09:07 nobara-X99 kernel:  ret_from_fork+0x292/0x330
Okt 19 16:09:07 nobara-X99 kernel:  ? __pfx_kthread+0x10/0x10
Okt 19 16:09:07 nobara-X99 kernel:  ret_from_fork_asm+0x1a/0x30
Okt 19 16:09:07 nobara-X99 kernel:  </TASK>
Okt 19 16:09:07 nobara-X99 kernel: ---[ end trace 0000000000000000 ]---
Okt 19 16:09:07 nobara-X99 kernel: BTRFS error (device sda state A):
Transaction 860 aborted (error -11)
Okt 19 16:09:07 nobara-X99 kernel: BTRFS: error (device sda state A)
in btrfs_commit_transaction:2606: errno=3D-11 unknown
Okt 19 16:09:07 nobara-X99 kernel: BTRFS info (device sda state EA):
forced readonly
Okt 19 16:09:07 nobara-X99 kernel: _btrfs_printk: 50 callbacks suppressed
Okt 19 16:09:07 nobara-X99 kernel: BTRFS warning (device sda state
EA): Skipping commit of aborted transaction.
Okt 19 16:09:07 nobara-X99 kernel: BTRFS: error (device sda state EA)
in cleanup_transaction:2077: errno=3D-11 unknown

> The trace only shows the abort in btrfs_commit_transaction, not where -EA=
GAIN originated. I'm happy to test patches, enable debug options or try a d=
ifferent kernel if that helps. Claude helped me with this message I'm Germa=
n  Thanks, Jochen
