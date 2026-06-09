Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7A413621
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2026 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781007432; cv=none; b=kPcXLnnUO+7Qp+yduDAyP1C9LUB4mwkjy/eNZR8EDlOqBAvFVYywgo7fStvop7l7SFgOAlYYKrlMdtzIT/DBQ309Xje+XMLbHq6Y4lRmMsxgUCzs+zydaWk99xscFBjLEqYR2WS6c91BWB4gp4WoubP/VnntVY95XDjwYUiQXck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781007432; c=relaxed/simple;
	bh=O4sgonml119DSzoYZuYwCSqlXdzBu8OpSHNeKy3vtmA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=CoX3hIkLJ8vmXCmFv1okcw7MzXuLWfXBLw2LJUEUaTSKGy4qQyRnpQeCltkpDfF8MB2PAY1GokXN1DH1WRimky+uBnSNj/rkyP2HCsykYvkOHc+ylULxO7mak9Sp4KEgdFRfAwEd5k6flO6xB7F5m4Y3gTk+JTNBIu2cJAOTyn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJRbHQQ+; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJRbHQQ+"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490be03d47bso46840925e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 05:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781007429; x=1781612229; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hFIRzVFVAfu3slpaPkTHUWsA08SLVMaaIIagINDmwk=;
        b=BJRbHQQ+znrHzCZjRraTZKpve6dqrfjJO1kfyjAvH56IfiJ05261sZj0QsxWMBVcBx
         E54iDw/LTIaa7E0lpTtX4G8V8g1i8mRK9k24tQBjJ7qq7QqXT/5o4JEluh6PWJnI6WIq
         ieMME9hCvs19dDdz1kjnEDQ9kqoBgytdF6i1G7Jpo7ejQPyNoYocoeyA5uIZlj1KKo1P
         XsHnmT7IaTIx8mwmAljclh+Lk7fzugJEaKrd8dMYply45tFKYBD0gbgjnPDG8FCFdim1
         QYzpji+4DdIkXHB9j+5HCWVGXT/vAsIO91NgmhrM0fMoNaYenQmJIv29uNUyQcrF1kei
         DKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781007429; x=1781612229;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hFIRzVFVAfu3slpaPkTHUWsA08SLVMaaIIagINDmwk=;
        b=AExRqPwZ+vAdpK/xSsftBa14TCg+gC9tteqABvb0nNmlEmKWz8om786/AprNsbIbTf
         NcDJ+DYIw9L7KaWBJoUA2Qs8GzLuzxGucT57uq2zkBLGhV7C3M5hPDBZ11AuIZ16BrVO
         +aqR2EiKjzCdFwtRrJxHoK6SjUX7TW3W/x5xOnIQJn3+qIMSWYebW39i294DSD8+/wqF
         rwzQO0Ea74OItt7ig1eSTDAyaiY+YiDer4Tbf1cc8P0cEOfo2tTJrxZIQDeHRD5UlxwI
         JDwQq2mh8fCmoFiwHY0VWNkUPK8i3q0rYUELoM/UsT7dlu9V68x8Wzw8gnXJibXk0+1u
         /weg==
X-Gm-Message-State: AOJu0YymFkTHvy2gFkT/fEo8HjYTpWcFRJFZCV8fEgIlWVrk66NXdTql
	DryreE9hqLqPitMc19mXGxfsdJxEEs69A/ZfJw4e6DUxyxXbm7n4bdyLEdZOY4Xx
X-Gm-Gg: Acq92OGoMmf3Gkds88OrL6K946Qs+8mcoQkomNvU5T+gZf0UQAzOv5Prjz3ivkgEOzb
	txXe3X9ygOjTAvVye1Bq8JTDNqUdJHqzQa+2MhJZNTcdtY+HfR1MyQNb1kX4bqwe8k3T5Ne6mvy
	UUq3/tGdrtmtnmwYtgBhWWFkZTi3w7uFL94vyvZZArw4qq/lpEc+a90EV+IlSVhjMLoLVuQfXZX
	kGmkW0HQY9MIYA31kb2bjhCE4VZdz8efKjcYxuJKjEF2oxDBUjmAtRPoZf2Bkdc5N7hA4Yopy8F
	YHH3Ul3DIP8ON5n/RD2D8YhbTjC7cNg5h6e0292RmxhO69n+65DZwfPhE6MSr7Gben1urpgZZeO
	8+CxYQkqGmXXmDCRKNBHz4RUTWAxboFbsvlGl00FTyZivadN1AE96Ce93fC74T2RV5ej6beUkDR
	HCK2bmj+rCNqpbibBghPtYFJUd+pr5cpiFAWoqp0FWvhpffZ1I1kRArGhPQfUDIPuh7jzbYkhV3
	Devhg1p8EGtjqlPGDClR1IbAmNEU1vLmFI=
X-Received: by 2002:a05:600c:e548:10b0:490:cf76:dea4 with SMTP id 5b1f17b1804b1-490cf76dec2mr87516385e9.2.1781007428040;
        Tue, 09 Jun 2026 05:17:08 -0700 (PDT)
Received: from [192.168.10.168] (91-175-163-178.subs.proxad.net. [91.175.163.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2eadefsm63363972f8f.11.2026.06.09.05.17.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 05:17:07 -0700 (PDT)
Message-ID: <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
Date: Tue, 9 Jun 2026 14:17:06 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance
 paused in progress"
From: Alban Browaeys <alban.browaeys@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
Content-Language: en-US
In-Reply-To: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

more details after a reboot (sda3 is now sdb3):

# mount -o ro,rescue=all /dev/sdb3 /var
[  597.965956] BTRFS: device label SSDHOME devid 1 transid 44655875 /dev/sdb3 (8:19) scanned by mount (437)
[  597.977243] BTRFS info (device sdb3 state S): first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[  597.987580] BTRFS info (device sdb3 state S): using crc32c checksum algorithm
[  598.028410] BTRFS info (device sdb3 state ECS): enabling ssd optimizations
[  598.035833] BTRFS info (device sdb3 state ECS): disabling log replay at mount time
[  598.043944] BTRFS info (device sdb3 state ECS): turning on async discard
[  598.051195] BTRFS info (device sdb3 state ECS): enabling free space tree
[  598.058445] BTRFS info (device sdb3 state ECS): ignoring bad roots
[  598.065110] BTRFS info (device sdb3 state ECS): ignoring data csums
[  598.071836] BTRFS info (device sdb3 state ECS): ignoring meta csums
[  598.078558] BTRFS info (device sdb3 state ECS): ignoring unknown super block flags


# btrfs balance resume /var
ERROR: error during balancing '/var': Read-only file system
There may be more info in syslog - try dmesg | tail

# umount /var
[ 1077.443570] BTRFS info (device sdb3 state EMCS): last unmount of filesystem 13af326c-631f-482b-9c34-b59b4f100608

# mount -o rw,skip_balance,clear_cache /dev/sdb3 /var
[ 1084.400924] BTRFS: device label SSDHOME devid 1 transid 44655875 /dev/sdb3 (8:19) scanned by mount (464)
[ 1084.412230] BTRFS info (device sdb3): first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[ 1084.421817] BTRFS info (device sdb3): using crc32c checksum algorithm
[ 1084.458776] BTRFS info (device sdb3): rebuilding free space tree
[ 1084.465327] BTRFS warning (device sdb3): Skipping commit of aborted transaction.
[ 1084.473209] ------------[ cut here ]------------
[ 1084.478283] BTRFS: Transaction aborted (error -28)
[ 1084.483526] WARNING: fs/btrfs/transaction.c:2060 at btrfs_commit_transaction+0xaaa/0xe20 [btrfs], CPU#6: kworker/u32:2/66
[ 1084.494986] Modules linked in: ntfs3 btrfs libblake2b raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 md_mod autof
s4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid sr_mod cdrom uas usb_storage i915 drm_buddy ttm i2c_algo_bit drm_display_helper cec sd_mod rc_core drm_clie
nt_lib drm_kms_helper iTCO_wdt xhci_pci ahci intel_pmc_bxt drm libahci watchdog xhci_hcd firewire_ohci libata firewire_core r8169 video realtek crc_itu_t usbcore scsi_m
od fan i2c_i801 wmi button usb_common i2c_smbus scsi_common efivarfs                                                                                                    [ 1084.546146] CPU: 6 UID: 0 PID: 66 Comm: kworker/u32:2 Not tainted 7.0.10+deb14-amd64 #1 PREEMPT(lazy)  Debian 7.0.10-1
[ 1084.557401] Hardware name: LENOVO 10M8S14C42/3102, BIOS M16KT71A 09/14/2023
[ 1084.564828] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[ 1084.572751] RIP: 0010:btrfs_commit_transaction+0xaac/0xe20 [btrfs]
[ 1084.579439] Code: ff 48 8b 7c 24 08 31 c9 48 8d b7 48 01 00 00 e8 9a 7c 0b 00 48 c7 43 18 00 00 00 00 e9 73 fe ff ff 48 8d 3d 66 fd 34 00 89 ee <67> 48 0f b9 3a e9 f
8 fe ff ff 49 8b bc 24 48 03 00 00 be 02 00 00
[ 1084.598660] RSP: 0018:ffffce9fc02fbce8 EFLAGS: 00010292
[ 1084.604372] RAX: 0000000000000002 RBX: ffff8ac4c75ae150 RCX: 0000000000000003
[ 1084.611984] RDX: 0000000002040001 RSI: 00000000ffffffe4 RDI: ffffffffc1028080
[ 1084.619598] RBP: 00000000ffffffe4 R08: 0000000000000000 R09: ffffce9fc02fbad0
[ 1084.627200] R10: ffff8acbe23fff90 R11: 00000000fff7ffff R12: ffff8ac4d02dd000
[ 1084.634799] R13: ffff8ac4d13a7600 R14: ffff8ac4d02dd4c0 R15: ffff8ac4c1100000
[ 1084.642401] FS:  0000000000000000(0000) GS:ffff8acc3a4fc000(0000) knlGS:0000000000000000
[ 1084.650947] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1084.657153] CR2: 00007f59bc90839c CR3: 0000000168c2c003 CR4: 00000000003706f0
[ 1084.664742] Call Trace:
[ 1084.667646]  <TASK>
[ 1084.670180]  ? start_transaction+0x228/0x880 [btrfs]
[ 1084.675649]  flush_space+0x3c3/0x5a0 [btrfs]
[ 1084.680430]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
[ 1084.686591]  ? calc_available_free_space.isra.0+0x70/0xc0 [btrfs]
[ 1084.693190]  do_async_reclaim_metadata_space+0x7d/0x180 [btrfs]
[ 1084.699618]  btrfs_async_reclaim_metadata_space+0x54/0x70 [btrfs]
[ 1084.706214]  process_one_work+0x19d/0x3a0
[ 1084.710679]  worker_thread+0x1af/0x320
[ 1084.714880]  ? __pfx_worker_thread+0x10/0x10
[ 1084.719592]  kthread+0xe3/0x120
[ 1084.723174]  ? __pfx_kthread+0x10/0x10
[ 1084.727370]  ret_from_fork+0x2c7/0x350
[ 1084.731562]  ? __pfx_kthread+0x10/0x10
[ 1084.735738]  ret_from_fork_asm+0x1a/0x30
[ 1084.740102]  </TASK>
[ 1084.742707] ---[ end trace 0000000000000000 ]---
[ 1084.747733] BTRFS info (device sdb3 state A): dumping space info:
[ 1084.754275] BTRFS info (device sdb3 state A): space_info DATA (sub-group id 0) has 17422925824 free, is not full
[ 1084.764845] BTRFS info (device sdb3 state A): space_info total=70262980608, used=52839989248, pinned=0, reserved=0, may_use=0, readonly=65536 zone_unusable=0
[ 1084.779326] BTRFS info (device sdb3 state A): space_info METADATA (sub-group id 0) has -190382080 free, is full
[ 1084.789819] BTRFS info (device sdb3 state A): space_info total=3221225472, used=2142470144, pinned=0, reserved=0, may_use=190382080, readonly=1078755328 zone_unusable=0
[ 1084.805227] BTRFS info (device sdb3 state A): space_info SYSTEM (sub-group id 0) has 0 free, is not full
[ 1084.815115] BTRFS info (device sdb3 state A): space_info total=33554432, used=16384, pinned=0, reserved=0, may_use=0, readonly=33538048 zone_unusable=0
[ 1084.829087] BTRFS info (device sdb3 state A): global_block_rsv: size 190382080 reserved 190382080
[ 1084.838378] BTRFS info (device sdb3 state A): trans_block_rsv: size 0 reserved 0
[ 1084.846167] BTRFS info (device sdb3 state A): chunk_block_rsv: size 0 reserved 0
[ 1084.853986] BTRFS info (device sdb3 state A): remap_block_rsv: size 0 reserved 0
[ 1084.861767] BTRFS info (device sdb3 state A): delayed_block_rsv: size 0 reserved 0
[ 1084.869752] BTRFS info (device sdb3 state A): delayed_refs_rsv: size 0 reserved 0
[ 1084.877621] BTRFS: error (device sdb3 state A) in cleanup_transaction:2060: errno=-28 No space left
[ 1084.887109] BTRFS warning (device sdb3 state EA): failed to rebuild free space tree: -28
[ 1084.895714] BTRFS error (device sdb3 state EA): commit super block returned -30
[ 1084.904462] BTRFS error (device sdb3 state EA): open_ctree failed: -28
mount: /var: fsconfig() failed: No space left on device.
        dmesg(1) may have more information after failed mount system call.


Le 09/06/2026 à 06:42, Alban Browaeys a écrit :
> Hello,
>
> On Debian Forky (testing), I tried to migrate my old SSD btrfs 
> partition metadata from the previous default Single to the new DUP 
> default.
>
> The migration stopped halfway far /var and I am now stuck.
>
> I am facing a severe ENOSPC deadlock it seems.
>
>
> Symptoms:
>
> - The filesystem conversion stopped midway and turned Read-Only during 
> a balance operation.
>
> - Attempting to remount or mount as 'rw' fails with ENOSPC.
>
> - Adding a temporary loop device in RAM via 'btrfs device add' fails 
> because the FS is read-only.
>
> - Trying to run 'btrfs check --clear-space-cache v2' or cleanup tools 
> at cold state fails with: "error: please finish/cancel the running 
> replace/balance before running this command".
>
> - 'btrfs balance cancel' cannot be run because mounting 'rw' is 
> rejected, and it refuses to target the unmounted block device directly.
>
>
> I can only boot into init=/bin/sh as of now.
>
>
> Here are the outputs:
>
>
> btrfs fi df /var
> Data, single: total=65.44GiB, used=49.21GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=3.00GiB, used=1.59GiB
> GlobalReserve, single: total=181.70MiB, used=0.00B
>  prahal  ~  sudo btrfs balance start -mprofiles=single -mconvert=dup 
> /var
> ERROR: error during balancing '/var': Read-only file system
> There may be more info in syslog - try dmesg | tail
> uin 09 02:34:34 hermes kernel: BTRFS info (device sda3): balance: 
> start -mconvert=dup,profiles=single -sconvert=dup,profiles=single
> juin 09 02:34:34 hermes kernel: BTRFS info (device sda3): relocating 
> block group 102442729472 flags metadata
> juin 09 02:35:02 hermes kernel: BTRFS error (device sda3): failed to 
> run delayed ref for logical 3976462336 num_bytes 8192 type 184 action 
> 1 ref_mod 1: -28
> juin 09 02:35:02 hermes kernel: ------------[ cut here ]------------
> juin 09 02:35:02 hermes kernel: BTRFS: Transaction aborted (error -28)
> juin 09 02:35:02 hermes kernel: WARNING: fs/btrfs/extent-tree.c:2247 
> at btrfs_run_delayed_refs+0x115/0x120 [btrfs], CPU#0: 
> kworker/u32:11/1370737
> juin 09 02:35:02 hermes kernel: Modules linked in: nilfs2 ufs qnx4 
> hfsplus hfs minix msdos jfs nls_ucs2_utils xfs ext4 mbcache jbd2 
> crc32c_cryptoapi cpuid exfat uinput rfcomm snd_seq_dummy snd_hrtimer 
> snd_seq x>
> juin 09 02:35:02 hermes kernel:  snd_soc_avs nls_ascii 
> snd_soc_hda_codec kvm_intel snd_hda_ext_core nls_cp437 snd_hda_codec 
> vfat snd_hda_core fat kvm btrtl btbcm snd_intel_dspcfg 
> snd_intel_sdw_acpi snd_hwdep gs>
> juin 09 02:35:02 hermes kernel:  hid_generic usbhid hid sr_mod cdrom 
> uas usb_storage i915 drm_buddy ttm i2c_algo_bit drm_display_helper 
> sd_mod cec rc_core iTCO_wdt drm_client_lib intel_pmc_bxt xhci_pci 
> watchdog>
> juin 09 02:35:02 hermes kernel: CPU: 0 UID: 0 PID: 1370737 Comm: 
> kworker/u32:11 Tainted: P           OE       7.0.9+deb14-amd64 #1 
> PREEMPT(lazy)  Debian 7.0.9-1
> juin 09 02:35:02 hermes kernel: Tainted: [P]=PROPRIETARY_MODULE, 
> [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> juin 09 02:35:02 hermes kernel: Hardware name: LENOVO 10M8S14C42/3102, 
> BIOS M16KT71A 09/14/2023
> juin 09 02:35:02 hermes kernel: Workqueue: events_unbound 
> btrfs_async_reclaim_metadata_space [btrfs]
> juin 09 02:35:02 hermes kernel: RIP: 
> 0010:btrfs_run_delayed_refs+0x117/0x120 [btrfs]
> juin 09 02:35:02 hermes kernel: Code: 32 27 c1 48 89 ef e8 e8 54 0f 00 
> eb 07 e8 f1 22 ed d5 31 db 89 d8 5b 5d 41 5c 41 5d c3 cc cc cc cc 48 
> 8d 3d 5b 7f 31 00 89 de <67> 48 0f b9 3a eb be 66 90 90 90 90 90 90 90>
> juin 09 02:35:02 hermes kernel: RSP: 0018:ffffd03f75b87d48 EFLAGS: 
> 00010292
> juin 09 02:35:02 hermes kernel: RAX: 0000000000000002 RBX: 
> 00000000ffffffe4 RCX: ffff8ad782c55600
> juin 09 02:35:02 hermes kernel: RDX: 0000000002040001 RSI: 
> 00000000ffffffe4 RDI: ffffffffc11dcac0
> juin 09 02:35:02 hermes kernel: RBP: ffff8ad783d7bc78 R08: 
> 0000000000000000 R09: ffffffffc0ec412a
> juin 09 02:35:02 hermes kernel: R10: fffff4c487b11b40 R11: 
> ffff8ad86c46d460 R12: 0000000000000000
> juin 09 02:35:02 hermes kernel: R13: ffff8ad6a2573c00 R14: 
> 0000000000001252 R15: 0000000000000000
> juin 09 02:35:02 hermes kernel: FS:  0000000000000000(0000) 
> GS:ffff8adee617c000(0000) knlGS:0000000000000000
> juin 09 02:35:02 hermes kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
> 0000000080050033
> juin 09 02:35:02 hermes kernel: CR2: 00007ffd95039e68 CR3: 
> 000000072ca2c005 CR4: 00000000003726f0
> juin 09 02:35:02 hermes kernel: Call Trace:
> juin 09 02:35:02 hermes kernel:  <TASK>
> juin 09 02:35:02 hermes kernel:  flush_space+0x126/0x5a0 [btrfs]
> juin 09 02:35:02 hermes kernel:  ? 
> btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
> juin 09 02:35:02 hermes kernel:  ? 
> calc_available_free_space.isra.0+0x70/0xc0 [btrfs]
> juin 09 02:35:02 hermes kernel: 
> do_async_reclaim_metadata_space+0x7d/0x180 [btrfs]
> juin 09 02:35:02 hermes kernel: 
> btrfs_async_reclaim_metadata_space+0x54/0x70 [btrfs]
> juin 09 02:35:02 hermes kernel:  process_one_work+0x19d/0x3a0
> juin 09 02:35:02 hermes kernel:  worker_thread+0x1af/0x320
> juin 09 02:35:02 hermes kernel:  ? __pfx_worker_thread+0x10/0x10
> juin 09 02:35:02 hermes kernel:  kthread+0xe3/0x120
> juin 09 02:35:02 hermes kernel:  ? __pfx_kthread+0x10/0x10
> juin 09 02:35:02 hermes kernel:  ret_from_fork+0x2c7/0x350
> juin 09 02:35:02 hermes kernel:  ? __pfx_kthread+0x10/0x10
> juin 09 02:35:02 hermes kernel:  ret_from_fork_asm+0x1a/0x30
> juin 09 02:35:02 hermes kernel:  </TASK>
> juin 09 02:35:02 hermes kernel: ---[ end trace 0000000000000000 ]---
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> dumping space info:
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> space_info DATA (sub-group id 0) has 17422733312 free, is full
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> space_info total=70262980608, used=52839989248, pinned=0, reserved=0, 
> may_use=192512, readonly=65536 zone_unusable=0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> space_info METADATA (sub-group id 0) has 442368 free, is full
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> space_info total=3221225472, used=2155544576, pinned=38010880, 
> reserved=10387456, may_use=576634880, readonly=440205312 zone_unusable=0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> space_info SYSTEM (sub-group id 0) has 33538048 free, is not full
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> space_info total=33554432, used=16384, pinned=0, reserved=0, 
> may_use=0, readonly=0 zone_unusable=0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> global_block_rsv: size 190529536 reserved 190480384
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> trans_block_rsv: size 0 reserved 0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> chunk_block_rsv: size 0 reserved 0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> remap_block_rsv: size 0 reserved 0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> delayed_block_rsv: size 0 reserved 0
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state A): 
> delayed_refs_rsv: size 1270611968 reserved 368197632
> juin 09 02:35:02 hermes kernel: BTRFS: error (device sda3 state A) in 
> btrfs_run_delayed_refs:2247: errno=-28 No space left
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state EA): 
> forced readonly
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state EA): 1 
> enospc errors during balance
> juin 09 02:35:02 hermes kernel: BTRFS info (device sda3 state EA): 
> balance: ended with status: -30
>
>
>
>
> Linux (none) 7.0.10+deb14-amd64 #1 SMP PREEMPT_DYNAMIC Debian 7.0.10-1 
> (2026-05-27) x86_64 GNU/Linux
>
>
> btrfs-progs v7.0
> -EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED 
> CRYPTO=builtin
>
>
> # /etc/fstab: static file system information.
> #
> # Use 'blkid' to print the universally unique identifier for a
> # device; this may be used with UUID= as a more robust way to name 
> devices
> # that works even if disks are added and removed. See fstab(5).
> #
> # <file system> <mount point>   <type> <options>       <dump>  <pass>
> LABEL=ROOT     /               btrfs 
> defaults,ssd,compress=zstd,noatime,space_cache=v2        0       1
> UUID=9C79-15CA  /boot/efi       vfat umask=0077                    
> 0       1
> LABEL=HDDHOME     /home           btrfs 
> defaults,compress=zstd,noatime,space_cache=v2            0       2
> #LABEL=SSDHOME     /ssdhome        btrfs 
> defaults,ssd,compress=zstd,noatime,space_cache=v2 0       2
> LABEL=SSDHOME     /var            btrfs 
> defaults,ssd,compress=zstd,noatime,space_cache=v2,subvol=@var 0       2
> UUID=EAB2-8BE4  /boot/efi-old       vfat umask=0077                    
> 0       1
>
> btrfs fi usage /var/@var/
> Overall:
>     Device size:          68.47GiB
>     Device allocated:          68.47GiB
>     Device unallocated:           1.00MiB
>     Device missing:             0.00B
>     Device slack:             0.00B
>     Used:              51.21GiB
>     Free (estimated):          16.23GiB    (min: 16.23GiB)
>     Free (statfs, df):          16.23GiB
>     Data ratio:                  1.00
>     Metadata ratio:              1.00
>     Global reserve:          95.19MiB    (used: 0.00B)
>     Multiple profiles:                no
>
> Data,single: Size:65.44GiB, Used:49.21GiB (75.20%)
>    /dev/sda3      65.44GiB
>
> Metadata,single: Size:3.00GiB, Used:2.00GiB (66.51%)
>    /dev/sda3       3.00GiB
>
> System,single: Size:32.00MiB, Used:16.00KiB (0.05%)
>    /dev/sda3      32.00MiB
>
> Unallocated:
>    /dev/sda3       1.00MiB
>
> btrfs balance status /var/@var/
> Balance on '/var/@var/' is paused
> 0 out of about 0 chunks balanced (0 considered), -nan% left
>
>
> btrfs balance cancel /var/@var/
> ERROR: balance cancel on '/var/@var/' failed: Read-only file system
>
>
>
> Thank you for your help,
>
> Alban
>
>
>
