Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B843639D6F2
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 04:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780980159; cv=none; b=R7ARyzpCSFnP8qfgbpNXzUt/suyDLJsbtOixKXzyG8ann4bc69uOp/Q6ApzeAPryMmJxVxFkYFiL/UOAyXPc5D3R7rilIYlYAVORodWEEgt8uoT6QCZdXRP3Vy3wd6eyJvIrVNI5P5M7VvDqwGPEiAf4pLWA5qzfreIF2Ut6cYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780980159; c=relaxed/simple;
	bh=9/EbXPmkd37P635boW1easNYPdifsjwFFF1dbwSn1T0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=bzuM4w4Ape8yAZrP6evIkVulgju3m2BVx7SnV1+/uNCRsU6XKi3ADTlbRQehZ/+oq3wr9J19sboV8G2KYi0K1Rg98AH/94VRntVDMIlJr6Lq/Jz2TWg42pRSi+Jna44tPp1Xs+eMiLXasBB4gj0f5HWUstyMQg2kFoVoh9rv/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeOjwGtG; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeOjwGtG"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ee5cdbd28so3539935f8f.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jun 2026 21:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780980156; x=1781584956; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVtz3Lbs6dsR/YnY9TLnzkrBN/0QKioytjI99PMLG7k=;
        b=aeOjwGtGcfSOirUsTxk9cQn2Z/B5zkSqPhYsiRT+zg7L5TQY+E6kDJwZrur1046W56
         Fi86Noe6IgrP2vJFZb8ZYXtyIP0SkVe/w17HPwdp1xGTF1wFst0r1gX6597lw9FYQ99g
         HpKQEZ7hNNNm7xptxgFFM/E/MTdRT6mUZclGmL7pZ560MEcnIE7Z+OlxOlDSK8Eb12RA
         668caEfWo9A/RvY+Ip5oE8Ti3k805Opf8bZMjTgMrg1fvN7PPPdJpc+yr3lolJHtdn4+
         zvMR629rDpKiQVSoORwE9XxugYrtLvzGH75oXM9QnPZKoMa9K9AdIYItahHjfw/XENCi
         wVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780980156; x=1781584956;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oVtz3Lbs6dsR/YnY9TLnzkrBN/0QKioytjI99PMLG7k=;
        b=QhjE9eIxxKL3iQWtO+JZGcQD4hFc0+KA41flEEY0QV8JIr7TfPouqAfHvVghBiIeF7
         lHLwSd8URLGt573hOAGF/Rfef/gJUGmph0owdhtIGS6F14O4qqBc4tS+qkF5NdhS/Bl2
         1t6HktczAHzWG71TQrD8EoYMdTe0IreMI1P2lXwPNAHJg3D26fjZPXxlwcu0Q6T5HPh1
         sj0XJgl/5yVghBLH0kBWXSANi7AWNeiFwwG2FdeeGVQvoSB9LbG2AQi3LHq3FItYOPCq
         avF4K5hV9zkRB7rhuMTfDCEFwR1z1VAg0IvO21+2bFT72Xtjf9YeGt7C7Gb1wN4DcAPg
         Z58g==
X-Gm-Message-State: AOJu0Yx0dEndR8QglY1OX7HlfSP9dJmTluTfGeIXe/wW2o+UCHqpkdsw
	9Z5Vz1ZaYAyymVKKD7LN8KVu25xeYSC1bQVj5b92mCVlzGExlQOJXMcj5Dewym9L
X-Gm-Gg: Acq92OHmOrxlaqCwOlPtpxD0sKbDE+sv8fG8O98oW1/6DKfMtrSYj/MZjthJiYG0EY9
	HUOL1YcK6piuFpgN13eHkDAh3MyJ3XnxVQcx74h/lGzmDywfpVpane7TLfyyTuhm+SK03E9iqdh
	pCOcPmpB7tyAn0GCeZqdeOiiF+gv7fbopQp5SKOZAmV7FMVyMJgvqQOq4OODCbbZilcRAzydmoZ
	Oy/tSBM4mxV3PuoCaWQG36b4k8fnydqPcBFC8+1k/ttWluLyBKZsXLEFWIDk9N4KH979tnf+RTE
	ZeRGKXXpg70peBzy9Vyqly510dZTO0MRY3vBzfruYnIsVly/39Rd6+hDSvKwBhgQXbHQPpFSp3U
	augrSWKvUsxyY6Wx5yoEz4YGPEOTqPvZzdO9mi6/IgH87LWLavIdOL76H8J51D25flf8bCNCuip
	5w9yLr+8TShoATVqxcQDeeQWPyJp9zdpRoe95O7scqiuokbpn2tKlqC5YOI9wqTW0KlfQXs3p86
	9rMMbEWZZA5tJym2/8RhJxvKLO+wl9QVuE=
X-Received: by 2002:a05:6000:40dd:b0:455:564e:3a28 with SMTP id ffacd0b85a97d-46032da1939mr27544615f8f.17.1780980155818;
        Mon, 08 Jun 2026 21:42:35 -0700 (PDT)
Received: from [192.168.10.168] (91-175-163-178.subs.proxad.net. [91.175.163.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm58844481f8f.9.2026.06.08.21.42.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 21:42:35 -0700 (PDT)
Message-ID: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
Date: Tue, 9 Jun 2026 06:42:34 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Alban Browaeys <alban.browaeys@gmail.com>
Subject: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance paused
 in progress"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

On Debian Forky (testing), I tried to migrate my old SSD btrfs partition 
metadata from the previous default Single to the new DUP default.

The migration stopped halfway far /var and I am now stuck.

I am facing a severe ENOSPC deadlock it seems.


Symptoms:

- The filesystem conversion stopped midway and turned Read-Only during a 
balance operation.

- Attempting to remount or mount as 'rw' fails with ENOSPC.

- Adding a temporary loop device in RAM via 'btrfs device add' fails 
because the FS is read-only.

- Trying to run 'btrfs check --clear-space-cache v2' or cleanup tools at 
cold state fails with: "error: please finish/cancel the running 
replace/balance before running this command".

- 'btrfs balance cancel' cannot be run because mounting 'rw' is 
rejected, and it refuses to target the unmounted block device directly.


I can only boot into init=/bin/sh as of now.


Here are the outputs:


btrfs fi df /var
Data, single: total=65.44GiB, used=49.21GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=3.00GiB, used=1.59GiB
GlobalReserve, single: total=181.70MiB, used=0.00B
  prahal  ~  sudo btrfs balance start -mprofiles=single -mconvert=dup /var
ERROR: error during balancing '/var': Read-only file system
There may be more info in syslog - try dmesg | tail
uin 09 02:34:34 hermes kernel: BTRFS info (device sda3): balance: start -mconvert=dup,profiles=single -sconvert=dup,profiles=single
juin 09 02:34:34 hermes kernel: BTRFS info (device sda3): relocating block group 102442729472 flags metadata
juin 09 02:35:02 hermes kernel: BTRFS error (device sda3): failed to run delayed ref for logical 3976462336 num_bytes 8192 type 184 action 1 ref_mod 1: -28
juin 09 02:35:02 hermes kernel: ------------[ cut here ]------------
juin 09 02:35:02 hermes kernel: BTRFS: Transaction aborted (error -28)
juin 09 02:35:02 hermes kernel: WARNING: fs/btrfs/extent-tree.c:2247 at btrfs_run_delayed_refs+0x115/0x120 [btrfs], CPU#0: kworker/u32:11/1370737
juin 09 02:35:02 hermes kernel: Modules linked in: nilfs2 ufs qnx4 hfsplus hfs minix msdos jfs nls_ucs2_utils xfs ext4 mbcache jbd2 crc32c_cryptoapi cpuid exfat uinput rfcomm snd_seq_dummy snd_hrtimer snd_seq x>
juin 09 02:35:02 hermes kernel:  snd_soc_avs nls_ascii snd_soc_hda_codec kvm_intel snd_hda_ext_core nls_cp437 snd_hda_codec vfat snd_hda_core fat kvm btrtl btbcm snd_intel_dspcfg snd_intel_sdw_acpi snd_hwdep gs>
juin 09 02:35:02 hermes kernel:  hid_generic usbhid hid sr_mod cdrom uas usb_storage i915 drm_buddy ttm i2c_algo_bit drm_display_helper sd_mod cec rc_core iTCO_wdt drm_client_lib intel_pmc_bxt xhci_pci watchdog>
juin 09 02:35:02 hermes kernel: CPU: 0 UID: 0 PID: 1370737 Comm: kworker/u32:11 Tainted: P           OE       7.0.9+deb14-amd64 #1 PREEMPT(lazy)  Debian 7.0.9-1
juin 09 02:35:02 hermes kernel: Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
juin 09 02:35:02 hermes kernel: Hardware name: LENOVO 10M8S14C42/3102, BIOS M16KT71A 09/14/2023
juin 09 02:35:02 hermes kernel: Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
juin 09 02:35:02 hermes kernel: RIP: 0010:btrfs_run_delayed_refs+0x117/0x120 [btrfs]
juin 09 02:35:02 hermes kernel: Code: 32 27 c1 48 89 ef e8 e8 54 0f 00 eb 07 e8 f1 22 ed d5 31 db 89 d8 5b 5d 41 5c 41 5d c3 cc cc cc cc 48 8d 3d 5b 7f 31 00 89 de <67> 48 0f b9 3a eb be 66 90 90 90 90 90 90 90>
juin 09 02:35:02 hermes kernel: RSP: 0018:ffffd03f75b87d48 EFLAGS: 00010292
juin 09 02:35:02 hermes kernel: RAX: 0000000000000002 RBX: 00000000ffffffe4 RCX: ffff8ad782c55600
juin 09 02:35:02 hermes kernel: RDX: 0000000002040001 RSI: 00000000ffffffe4 RDI: ffffffffc11dcac0
juin 09 02:35:02 hermes kernel: RBP: ffff8ad783d7bc78 R08: 0000000000000000 R09: ffffffffc0ec412a
juin 09 02:35:02 hermes kernel: R10: fffff4c487b11b40 R11: ffff8ad86c46d460 R12: 0000000000000000
juin 09 02:35:02 hermes kernel: R13: ffff8ad6a2573c00 R14: 0000000000001252 R15: 0000000000000000
juin 09 02:35:02 hermes kernel: FS:  0000000000000000(0000) GS:ffff8adee617c000(0000) knlGS:0000000000000000
juin 09 02:35:02 hermes kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
juin 09 02:35:02 hermes kernel: CR2: 00007ffd95039e68 CR3: 000000072ca2c005 CR4: 00000000003726f0
juin 09 02:35:02 hermes kernel: Call Trace:
juin 09 02:35:02 hermes kernel:  <TASK>
juin 09 02:35:02 hermes kernel:  flush_space+0x126/0x5a0 [btrfs]
juin 09 02:35:02 hermes kernel:  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
juin 09 02:35:02 hermes kernel:  ? calc_available_free_space.isra.0+0x70/0xc0 [btrfs]
juin 09 02:35:02 hermes kernel:  do_async_reclaim_metadata_space+0x7d/0x180 [btrfs]
juin 09 02:35:02 hermes kernel:  btrfs_async_reclaim_metadata_space+0x54/0x70 [btrfs]
juin 09 02:35:02 hermes kernel:  process_one_work+0x19d/0x3a0
juin 09 02:35:02 hermes kernel:  worker_thread+0x1af/0x320
juin 09 02:35:02 hermes kernel:  ? __pfx_worker_thread+0x10/0x10
juin 09 02:35:02 hermes kernel:  kthread+0xe3/0x120
juin 09 02:35:02 hermes kernel:  ? __pfx_kthread+0x10/0x10
juin 09 02:35:02 hermes kernel:  ret_from_fork+0x2c7/0x350
juin 09 02:35:02 hermes kernel:  ? __pfx_kthread+0x10/0x10
juin 09 02:35:02 hermes kernel:  ret_from_fork_asm+0x1a/0x30
juin 09 02:35:02 hermes kernel:  </TASK>
juin 09 02:35:02 hermes kernel: ---[ end trace 0000000000000000 ]---
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): dumping space info:
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): space_info DATA (sub-group id 0) has 17422733312 free, is full
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): space_info total=70262980608, used=52839989248, pinned=0, reserved=0, may_use=192512, readonly=65536 zone_unusable=0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): space_info METADATA (sub-group id 0) has 442368 free, is full
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): space_info total=3221225472, used=2155544576, pinned=38010880, reserved=10387456, may_use=576634880, readonly=440205312 zone_unusable=0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): space_info SYSTEM (sub-group id 0) has 33538048 free, is not full
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): space_info total=33554432, used=16384, pinned=0, reserved=0, may_use=0, readonly=0 zone_unusable=0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): global_block_rsv: size 190529536 reserved 190480384
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): trans_block_rsv: size 0 reserved 0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): chunk_block_rsv: size 0 reserved 0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): remap_block_rsv: size 0 reserved 0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): delayed_block_rsv: size 0 reserved 0
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): delayed_refs_rsv: size 1270611968 reserved 368197632
juin 09 02:35:02 hermes kernel: BTRFS: error (device sda3 state A) in btrfs_run_delayed_refs:2247: errno=-28 No space left
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state EA): forced readonly
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state EA): 1 enospc errors during balance
juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state EA): balance: ended with status: -30




Linux (none) 7.0.10+deb14-amd64 #1 SMP PREEMPT_DYNAMIC Debian 7.0.10-1 (2026-05-27) x86_64 GNU/Linux


btrfs-progs v7.0
-EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=builtin


# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
LABEL=ROOT 	/               btrfs   defaults,ssd,compress=zstd,noatime,space_cache=v2		0       1
UUID=9C79-15CA  /boot/efi       vfat    umask=0077					0       1
LABEL=HDDHOME 	/home           btrfs   defaults,compress=zstd,noatime,space_cache=v2			0       2
#LABEL=SSDHOME 	/ssdhome        btrfs   defaults,ssd,compress=zstd,noatime,space_cache=v2	        0       2
LABEL=SSDHOME 	/var            btrfs   defaults,ssd,compress=zstd,noatime,space_cache=v2,subvol=@var	0       2
UUID=EAB2-8BE4  /boot/efi-old       vfat    umask=0077					0       1

btrfs fi usage /var/@var/
Overall:
	Device size:		  68.47GiB
	Device allocated:		  68.47GiB
	Device unallocated:		   1.00MiB
	Device missing:		     0.00B
	Device slack:		     0.00B
	Used:			  51.21GiB
	Free (estimated):		  16.23GiB	(min: 16.23GiB)
	Free (statfs, df):		  16.23GiB
	Data ratio:			      1.00
	Metadata ratio:		      1.00
	Global reserve:		  95.19MiB	(used: 0.00B)
	Multiple profiles:		        no

Data,single: Size:65.44GiB, Used:49.21GiB (75.20%)
    /dev/sda3	  65.44GiB

Metadata,single: Size:3.00GiB, Used:2.00GiB (66.51%)
    /dev/sda3	   3.00GiB

System,single: Size:32.00MiB, Used:16.00KiB (0.05%)
    /dev/sda3	  32.00MiB

Unallocated:
    /dev/sda3	   1.00MiB

btrfs balance status /var/@var/
Balance on '/var/@var/' is paused
0 out of about 0 chunks balanced (0 considered), -nan% left


btrfs balance cancel /var/@var/
ERROR: balance cancel on '/var/@var/' failed: Read-only file system



Thank you for your help,

Alban



