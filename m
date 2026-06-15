Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93001176238
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 00:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781483140; cv=none; b=LbnAcBOsOe/hWjhlV/HN52rCohMwDkvToJ/i3Z3DCFvvIF3BCFEEyJhvcVeZhVnNMIs8yetc7IaUdZDDDermXz1kO3e1L1rU3H8mW5m2oVlZW3zZXzCK1cLndomYeF+dbQC2DKbV7bbDWHKgKvsHMl2UgnXlsTbg3cc8+NmFvXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781483140; c=relaxed/simple;
	bh=eLfW8tsDWQgpdavpnGqewKi3dtMwQy8YDsb4NZdvVso=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=hncvWLtPaHvJMfpzWbOw+1sKFtb5ccm84GJA/bOp6d8SOfPsOHTFi3ZFrjwG9hsEAn3x44GfIXfiiLtaFDG9CMh9ZA7Q3VXjJjZO7ndl9KSK9jN8tuRfzEX0yMFNxZvIPVCuc63ebQofYshofvXB/xWHiQeZ2NDifGseVa3+qOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WKaHoQfd; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKaHoQfd"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef4223be7so1481125f8f.2
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jun 2026 17:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781483136; x=1782087936; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IF5EDFoKJR5DAAnCh1WbhvRSOUDfs6me4ifggNyGDBI=;
        b=WKaHoQfdanW4rmVbECinuufRhSPSZ92tx+k+B++EfUWlQJ7uXy4JjGXyHa08cn73Rj
         JqpYCdTHZ+94Rf9QiPzXPV/2/keTzk8olNNCi/uUET6Q4WRnjquDo+uOLtv/VABDXHKY
         RVJvOmjlNJbaG1tr4DPfAFvFRmS3ZADikpEHdemh+0fQNW8AOshJfPLCmxkQN4IM7f2z
         ZLSELziDhLfrbiQNTzHqEWV7dHX5Vfw2aZFbMAw3d/aUAN6kDZw62qv9gJrnZMThM0bB
         R7bEtIMc6bpNZ+cB+xZmsF1L5HMcsQXGfYCmVC0lgDHeXWsT3gdOsLGOM2aiMjX3fDHk
         /TDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781483136; x=1782087936;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IF5EDFoKJR5DAAnCh1WbhvRSOUDfs6me4ifggNyGDBI=;
        b=VdzaGQ6JQp2F+5mfxUY+KhcOgoVmmw+cp/k78AkaQEWlvm2AE5BGGDmZRlH5MAgIVs
         Sw889ewqXbEVxSlh0XQYmUotWtCW0s1bFquYdO3MHTpDxS4aG2uXkzZt7oXlwRdCqnUP
         6UjErYxBAaltG/62IUSQGn1xO7MFCMtVKZLzotBjKP6hApRhDhS7Rs4JgNUYk6gwVAUA
         ZgeGLeY74zN7P2D9Vu1WohZ4yAEuQ7Kf5fEyZvaz5uyYP+R0uPE/UyxuV5sgaTloJ8B7
         ouIvhg2Xt+eCf8MafoZCDBcXC5gGhiXNJw5qm9XBIXBvCH05xU8JBN8EBXb7xvXbS0kI
         3dtw==
X-Forwarded-Encrypted: i=1; AFNElJ/mr5/2vRRV74Obc/gxM0RKb7gjiV7S4vFuoLhvpeXrAp8p2Qt2QrJW8yGTT1iFx7iq7b+LXYWSyIToOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxTjVgpt6afrlZWbRzqaw9ry0GxJpv1xd4PnDaFWkTOt7T3sFF
	8Vwb4lp7kFuCsDopnUZO2ySzP5yJhI7L2WLEEPzmguUjv5XabiIidabP3fPGkUwD
X-Gm-Gg: Acq92OEwFsLiFMGsNClEcNqbxAY9ReKBrqBCxTozxm0/vLNaNlJzo+cpUM6mOlGmI1/
	hAqe8XWesTjX6bjD3KX4l2dJV7Kv9388G4gU4Q2nhZcBhzIV+xFlsiBPylDcccxZeuFT9vjQ3FE
	UvYcpNP9VSwKmqk2M3JRpg137xx5yRy1EvTsAGgLierLGxHkN8raxrON9QO7Zc46o78esX1mtaB
	XtPHJATGO1irG2pkHKvS5QxwHWksrZkTXlUKYfEhr+DihnrgsR+Ho1cYUG5z6HQWWsgHOZwL6UM
	3Tbw677ByVmAMkxWJDs63Gd3XftZHWC7LqYhB0OTRCpXNSFgDwVzNns1aFjiJJd7z2X0Ol/HnVc
	K3/DayH9Bepf1jW1A3uzLZv331oIzdgv+9EdHfju9rIZI0OH62/JDOs9CiOhiIGWGVdW9nJtutG
	RN2Qa+ViuK8PnTQBLuxCQsXQiVafjUmJB9Tc/hI3cNvlNt6Dsfg6Ix+Vtmdo7HESBAayifcxU12
	QSsT+Yr3mAXciUxUf6s86Ek
X-Received: by 2002:a05:6000:288f:b0:45e:f236:6fb5 with SMTP id ffacd0b85a97d-4606dbab301mr17234522f8f.37.1781483135524;
        Sun, 14 Jun 2026 17:25:35 -0700 (PDT)
Received: from [192.168.10.168] (91-175-163-178.subs.proxad.net. [91.175.163.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c5266sm32648455f8f.29.2026.06.14.17.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2026 17:25:34 -0700 (PDT)
Message-ID: <a0df776c-63a3-4ff8-afb5-dc6bce8768c9@gmail.com>
Date: Mon, 15 Jun 2026 02:25:32 +0200
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
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
 <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
 <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
 <28d08133-999f-4d43-9cd5-67b856246687@gmail.com>
 <f519b8d1-f6d0-4975-9301-74571e87436f@gmail.com>
Content-Language: en-US, fr
In-Reply-To: <f519b8d1-f6d0-4975-9301-74571e87436f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I had space after the sdb3 btrfs /var partition, a 9GB swap partition. I 
deleted this swap partition and expanded the sdb3 btrfs size with parted
But I don't seem to be able to expand the btrfs filesystem inside sdb3 
if I cannot mount it read write, is it so? Or is it only due to my 
pending operation?
Can I get this btrfs partition back?

I have an image of this partiton but it seems I will have the same issue 
with this image and will be unable to restore it.
Is there a way to copy the content of the partition mounted in ro in its 
current state, create a new partition and copy the content back to it?
There are docker subvolumes on it wich seems they can be recreated by 
docker later on (I hope so) so rsync might be an option but if the 
docker subvolume need to be backed up rsync is not able to backup them 
correctly.
And btrfs restore gives me thousands of

Also should I expect this behavior to happen everytime I do a btrfs 
filessytem conversion without checking I have enough metadata space 
available beforehand or will this be prevented by some new code one day ?


# parted /dev/sdb
GNU Parted 3.7
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) select /dev/sdb
Using /dev/sdb
(parted) p
Model: ATA SanDisk SD9SB8W1 (scsi)
Disk /dev/sdb: 128GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system     Name                  Flags
  1      1049kB  903MB   902MB   fat32           EFI system partition 
boot, hidden, esp
  2      903MB   39.8GB  38.9GB  btrfs           root
  3      43.2GB  117GB   73.5GB  btrfs           ssdhome
  4      119GB   128GB   9197MB  linux-swap(v1)  SSDSWAP               swap

(parted) rm 4
(parted) resizepart 3 100%
(parted) p
Model: ATA SanDisk SD9SB8W1 (scsi)
Disk /dev/sdb: 128GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name                  Flags
  1      1049kB  903MB   902MB   fat32        EFI system partition 
boot, hidden, esp
  2      903MB   39.8GB  38.9GB  btrfs        root
  3      43.2GB  128GB   84.8GB  btrfs        ssdhome



# mount /dev/sdb3 /mnt/3 
  

[441290.450174] BTRFS: device label SSDHOME devid 1 transid 44655875 
/dev/sdb3 (8:19) scanned by mount (7976) 
                           [441290.461454] BTRFS info (device sdb3): 
first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[441290.471065] BTRFS info (device sdb3): using crc32c checksum 
algorithm 

[441290.518919] BTRFS warning (device sdb3): Skipping commit of aborted 
transaction. 

[441290.527296] ------------[ cut here ]------------ 
  

[441290.532875] BTRFS: Transaction aborted (error -28) 

[441290.538625] WARNING: fs/btrfs/transaction.c:2060 at 
btrfs_commit_transaction+0xaaa/0xe20 [btrfs], CPU#2: mount/7976
[441290.550177] Modules linked in: nls_ascii nls_cp437 vfat fat exfat 
ntfs3 btrfs libblake2b raid10 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx x
or raid6_pq raid1 raid0 md_mod autofs4 hid_logitech_hidpp 
hid_logitech_dj hid_generic usbhid hid sr_mod cdrom uas usb_storage i915 
drm_buddy ttm i2c_algo_bit drm_displa
y_helper cec sd_mod rc_core drm_client_lib drm_kms_helper iTCO_wdt 
xhci_pci ahci intel_pmc_bxt drm libahci watchdog xhci_hcd firewire_ohci 
libata firewire_core r8169 vi
deo realtek crc_itu_t usbcore scsi_mod fan i2c_i801 wmi button 
usb_common i2c_smbus scsi_common efivarfs 

[441290.605209] CPU: 2 UID: 0 PID: 7976 Comm: mount Tainted: G        W 
          7.0.10+deb14-amd64 #1 PREEMPT(lazy)  Debian 7.0.10-1 

[441290.617556] Tainted: [W]=WARN 
  

[441290.621060] Hardware name: LENOVO 10M8S14C42/3102, BIOS M16KT71A 
09/14/2023
[441290.628556] RIP: 0010:btrfs_commit_transaction+0xaac/0xe20 [btrfs] 

[441290.635306] Code: ff 48 8b 7c 24 08 31 c9 48 8d b7 48 01 00 00 e8 9a 
7c 0b 00 48 c7 43 18 00 00 00 00 e9 73 fe ff ff 48 8d 3d 66 fd 34 00 89 
ee <67> 48 0f b9 3a e9
f8 fe ff ff 49 8b bc 24 48 03 00 00 be 02 00 00
[441290.654597] RSP: 0018:ffffce9fcc3fb6b8 EFLAGS: 00010292
[441290.660386] RAX: 0000000000000002 RBX: ffff8ac4c06a1c78 RCX: 
0000000000000003
[441290.668074] RDX: 0000000002040001 RSI: 00000000ffffffe4 RDI: 
ffffffffc1028080
[441290.675771] RBP: 00000000ffffffe4 R08: 0000000000000000 R09: 
ffffce9fcc3fb4a0
[441290.683464] R10: ffff8acbe23fff90 R11: 00000000fff7ffff R12: 
ffff8ac4c584f000
[441290.691152] R13: ffff8ac4c7211600 R14: ffff8ac4c584f4c0 R15: 
ffff8ac545b71b80
[441290.698842] FS:  00007f16a636e940(0000) GS:ffff8acc3a3fc000(0000) 
knlGS:0000000000000000 

[441290.707489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
  
                        [441290.713789] CR2: 00007f71f5dcb19c CR3: 
000000034a2fa002 CR4: 00000000003706f0
[441290.721478] Call Trace: 
  

[441290.724485]  <TASK> 

[441290.727145]  ? start_transaction+0x228/0x880 [btrfs] 

[441290.732712]  flush_space+0x3c3/0x5a0 [btrfs] 

[441290.737591]  ? __schedule+0x489/0x1010 

[441290.741896]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs] 

[441290.748152]  ? calc_available_free_space.isra.0+0x70/0xc0 [btrfs] 

[441290.754844]  priority_reclaim_metadata_space+0x96/0x130 [btrfs]
[441290.761360]  handle_reserve_ticket+0x5b/0x290 [btrfs]
[441290.767011]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs] 
  

[441290.773268]  reserve_bytes+0x268/0x4c0 [btrfs] 
  

[441290.778314]  btrfs_reserve_metadata_bytes+0x1a/0xe0 [btrfs] 
  

[441290.784484]  btrfs_block_rsv_refill+0x60/0x90 [btrfs] 
  
                        [441290.790127]  evict_refill_and_join+0x47/0xe0 
[btrfs] 

[441290.795671]  btrfs_evict_inode+0x332/0x400 [btrfs] 
  

[441290.801048]  evict+0xfd/0x270 
  

[441290.804556]  btrfs_orphan_cleanup+0x21f/0x390 [btrfs] 
  

[441290.810191]  btrfs_start_pre_rw_mount+0x2a0/0x6c0 [btrfs] 

[441290.816159]  open_ctree+0x12fb/0x1730 [btrfs] 
  

[441290.821099]  btrfs_get_tree.cold+0xb/0xb6 [btrfs] 
  

[441290.826385]  ? ksys_read+0x73/0xf0 
  

[441290.830311]  vfs_get_tree+0x29/0xd0 
  

[441290.834324]  vfs_cmd_create+0x57/0xd0 
  

[441290.838474]  __do_sys_fsconfig+0x2fc/0x5e0 
  

[441290.843059]  do_syscall_64+0xcd/0x15f0 
  

[441290.847326]  ? from_kuid_munged+0x13/0x30 

[441290.851847]  ? __do_sys_geteuid+0x27/0x30 

[441290.856373]  ? do_syscall_64+0x10a/0x15f0 
  

[441290.860889]  ? __x64_sys_mkdir+0x39/0x50
[441290.865317]  ? do_syscall_64+0x10a/0x15f0
[441290.869841]  ? __x64_sys_statx+0x73/0xd0
[441290.874261]  ? do_syscall_64+0x10a/0x15f0 

[441290.878766]  ? irqentry_exit+0x78/0x680 

[441290.883089]  ? exc_page_fault+0x82/0x1d0 

[441290.887504]  entry_SYSCALL_64_after_hwframe+0x76/0x7e 

[441290.893048] RIP: 0033:0x7f16a67adb4a 
  

[441290.897115] Code: 73 01 c3 48 8b 0d c6 32 0d 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 af 01 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 96 32 0d 00 f7 d8 64 89 01 48 

[441290.916373] RSP: 002b:00007ffded6881b8 EFLAGS: 00000246 ORIG_RAX: 
00000000000001af 

[441290.924455] RAX: ffffffffffffffda RBX: 00005603bb8eba50 RCX: 
00007f16a67adb4a
[441290.932099] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 
0000000000000003
[441290.939743] RBP: 0000000000000003 R08: 0000000000000000 R09: 
0000000000000000
[441290.947387] R10: 0000000000000000 R11: 0000000000000246 R12: 
00005603bb8ecb80
[441290.955041] R13: 00007f16a694027c R14: 00007f16a693e460 R15: 
00007f16a636e7f0
[441290.962695]  </TASK> 

[441290.965396] ---[ end trace 0000000000000000 ]---
[441290.970507] BTRFS info (device sdb3 state A): dumping space info:
[441290.977124] BTRFS info (device sdb3 state A): space_info DATA 
(sub-group id 0) has 17422925824 free, is not full 

[441290.987784] BTRFS info (device sdb3 state A): space_info 
total=70262980608, used=52839989248, pinned=0, reserved=0, may_use=0, 
readonly=65536 zone_unusable=0
[441291.002378] BTRFS info (device sdb3 state A): space_info METADATA 
(sub-group id 0) has -190382080 free, is full 

[441291.012959] BTRFS info (device sdb3 state A): space_info 
total=3221225472, used=2142470144, pinned=0, reserved=0, 
may_use=190382080, readonly=1078755328 zone_unusable=0 
  

[441291.028472] BTRFS info (device sdb3 state A): space_info SYSTEM 
(sub-group id 0) has 0 free, is not full 

[441291.038428] BTRFS info (device sdb3 state A): space_info 
total=33554432, used=16384, pinned=0, reserved=0, may_use=0, 
readonly=33538048 zone_unusable=0
[441291.052461] BTRFS info (device sdb3 state A): global_block_rsv: size 
190382080 reserved 190382080 

[441291.061805] BTRFS info (device sdb3 state A): trans_block_rsv: size 
0 reserved 0
[441291.069675] BTRFS info (device sdb3 state A): chunk_block_rsv: size 
0 reserved 0 

[441291.077552] BTRFS info (device sdb3 state A): remap_block_rsv: size 
0 reserved 0 

[441291.085436] BTRFS info (device sdb3 state A): delayed_block_rsv: 
size 0 reserved 0 

[441291.093455] BTRFS info (device sdb3 state A): delayed_refs_rsv: size 
0 reserved 0 

[441291.101367] BTRFS: error (device sdb3 state A) in 
cleanup_transaction:2060: errno=-28 No space left 

[441291.110841] BTRFS warning (device sdb3 state EA): could not allocate 
space for delete; will truncate on mount 

[441291.121191] BTRFS error (device sdb3 state EA): Error removing 
orphan entry, stopping orphan cleanup 

[441291.130780] BTRFS error (device sdb3 state EA): could not do orphan 
cleanup -28
[441291.138588] BTRFS error (device sdb3 state EA): commit super block 
returned -30
[441291.147315] BTRFS error (device sdb3 state EA): open_ctree failed: 
-28 

mount: /mnt/3: fsconfig() failed: No space left on device.
        dmesg(1) may have more information after failed mount system call.


# mount -o ro,rescue=all /dev/sdb3 /var
[442011.834443] BTRFS: device label SSDHOME devid 1 transid 44655875 
/dev/sdb3 (8:19) scanned by mount (8020)
[442011.845803] BTRFS info (device sdb3 state S): first mount of 
filesystem 13af326c-631f-482b-9c34-b59b4f100608
[442011.856089] BTRFS info (device sdb3 state S): using crc32c checksum 
algorithm
[442011.897204] BTRFS info (device sdb3 state ECS): enabling ssd 
optimizations
[442011.904566] BTRFS info (device sdb3 state ECS): disabling log replay 
at mount time
[442011.912626] BTRFS info (device sdb3 state ECS): turning on async discard
[442011.919811] BTRFS info (device sdb3 state ECS): enabling free space tree
[442011.927008] BTRFS info (device sdb3 state ECS): ignoring bad roots
[442011.933661] BTRFS info (device sdb3 state ECS): ignoring data csums
[442011.940357] BTRFS info (device sdb3 state ECS): ignoring meta csums
[442011.947051] BTRFS info (device sdb3 state ECS): ignoring unknown 
super block flags
# ls /var
@var
# btrfs fi resize max /var
ERROR: unable to start resize, another exclusive operation 'balance 
paused' in progress




Le 11/06/2026 à 23:19, Alban Browaeys a écrit :
> Here is the debug dump of this partition sdb3_var_metadata-only- 
> debug.img at https://drive.google.com/file/ 
> d/1OzEZLaTUNpWsL1ohGKOMW4GiR9oQakdP/view?usp=drive_link done with 
> "btrfs-image -c 9 -t 4 /dev/sdb3 /mnt/4/hermes-var-20260610-enospc- 
> vanilla/sdb3_var_metadata-only-debug.img".
> 
> I tried to btrfs-resotre this partition but I get a lot of errors:
> 
> btrfs restore -v -m -x -i /dev/sdb3 /mnt/4/hermes-var-20260610-enospc- 
> vanilla/restored_var/
> 
> Skipping existing file /mnt/4/hermes-var-20260610-enospc-vanilla/ 
> restored_var/@var/backups/group.bak
> If you wish to overwrite use -o
> ERROR: zstd frame incomplete
> ERROR: copying data for /mnt/4/hermes-var-20260610-enospc-vanilla/ 
> restored_var/@var/backups/dpkg.arch.5.gz failed
> ERROR: zstd frame incomplete
> (...)
> 
> Alban
> 
> Le 10/06/2026 à 23:05, Alban Browaeys a écrit :
>> Le 09/06/2026 à 17:25, Chris Murphy a écrit :
>>> Try:
>>>
>>> mount -o skip_balance,nospace_cache,enospc_debug /dev/sdb3 /var
>>> btrfs balance start -dlimit=1 /var
>>
>>
>> Thanks for the suggestions. Unfortunately, the bypass did not work.
>>
>> # mount -o skip_balance,nospace_cache,enospc_debug /dev/sdb3 /var
>> [117052.507168] BTRFS: device label SSDHOME devid 1 transid 44655875 / 
>> dev/sdb3 (8:19) scanned by mount (2004)
>> [117052.526475] BTRFS info (device sdb3): first mount of filesystem 
>> 13af326c-631f-482b-9c34-b59b4f100608
>> [117052.536146] BTRFS info (device sdb3): using crc32c checksum algorithm
>> [117052.543125] BTRFS error (device sdb3): cannot disable free-space-tree
>> [117052.550097] BTRFS error (device sdb3): open_ctree failed: -22
>> mount: /var: wrong fs type, bad option, bad superblock on /dev/sdb3, 
>> missing codepage or helper program, or other error.
>>        dmesg(1) may have more information after failed mount system call.
>>
>>
>> I believe this issue is blocking me:
>>
>> [117052.543125] BTRFS error (device sdb3): cannot disable free-space-tree
>>
>> So I tried with enospc_debug without nospace_cache, to get debug infos:
>>
>> # mount -o skip_balance,enospc_debug /dev/sdb3 /var
>> [117261.590047] BTRFS: device label SSDHOME devid 1 transid 44655875 / 
>> dev/sdb3 (8:19) scanned by mount (2008)
>> [117261.612863] BTRFS info (device sdb3): first mount of filesystem 
>> 13af326c-631f-482b-9c34-b59b4f100608
>> [117261.622548] BTRFS info (device sdb3): using crc32c checksum algorithm
>> [117261.662415] BTRFS info (device sdb3): left=0, need=393216, flags=36
>> [117261.669328] BTRFS info (device sdb3): space_info SYSTEM (sub-group 
>> id 0) has 0 free, is not full
>> [117261.678792] BTRFS info (device sdb3): space_info total=33554432, 
>> used=16384, pinned=0, reserved=0, may_use=0, readonly=33538048 
>> zone_unusable=0
>> [117261.692344] BTRFS info (device sdb3): global_block_rsv: size 
>> 190382080 reserved 190382080
>> [117261.701131] BTRFS info (device sdb3): trans_block_rsv: size 0 
>> reserved 0
>> [117261.708349] BTRFS info (device sdb3): chunk_block_rsv: size 0 
>> reserved 0
>> [117261.715571] BTRFS info (device sdb3): remap_block_rsv: size 0 
>> reserved 0
>> [117261.722782] BTRFS info (device sdb3): delayed_block_rsv: size 0 
>> reserved 0
>> [117261.730154] BTRFS info (device sdb3): delayed_refs_rsv: size 0 
>> reserved 0
>> [117261.737462] BTRFS error (device sdb3): allocation failed flags 36, 
>> wanted 16384 tree-log 0, relocation: 0
>> [117261.747497] BTRFS info (device sdb3): space_info METADATA (sub- 
>> group id 0) has -190382080 free, is full
>> [117261.757371] BTRFS info (device sdb3): space_info total=3221225472, 
>> used=2142470144, pinned=0, reserved=0, may_use=190382080, 
>> readonly=1078755328 zone_unusable=0
>> [117261.772172] BTRFS info (device sdb3): global_block_rsv: size 
>> 190382080 reserved 190365696
>> [117261.780844] BTRFS info (device sdb3): trans_block_rsv: size 0 
>> reserved 0
>> [117261.787995] BTRFS info (device sdb3): chunk_block_rsv: size 0 
>> reserved 0
>> [117261.795127] BTRFS info (device sdb3): remap_block_rsv: size 0 
>> reserved 0
>> [117261.802251] BTRFS info (device sdb3): delayed_block_rsv: size 0 
>> reserved 0
>> [117261.809551] BTRFS info (device sdb3): delayed_refs_rsv: size 0 
>> reserved 0
>> [117261.816785] BTRFS info (device sdb3): block group 55856594944 has 
>> 1073741824 bytes, 1007976448 used 0 pinned 0 reserved 0 delalloc 0 
>> super 0 zone_unusable (65765376
>>  bytes available) [readonly]
>> [117261.834327] BTRFS info (device sdb3): block group has cluster?: no
>> [117261.840947] BTRFS info (device sdb3): 0 free space entries at or 
>> bigger than 16384 bytes
>> [117261.849500] BTRFS info (device sdb3): block group 101368987648 has 
>> 1073741824 bytes, 500957184 used 0 pinned 0 reserved 0 delalloc 0 
>> super 0 zone_unusable (57278464
>> 0 bytes available) [readonly]
>> [117261.867163] BTRFS info (device sdb3): block group has cluster?: no
>> [117261.873784] BTRFS info (device sdb3): 0 free space entries at or 
>> bigger than 16384 bytes [117261.882313] BTRFS info (device sdb3): 
>> block group 102442729472 has 1073741824 bytes, 633536512 used 0 pinned 
>> 0 reserved 0 delalloc 0 super 0 zone_unusable (44020531
>> 2 bytes available) [readonly]
>> [117261.899994] BTRFS info (device sdb3): block group has cluster?: no
>> [117261.906630] BTRFS info (device sdb3): 0 free space entries at or 
>> bigger than 16384 bytes
>> [117261.915176] BTRFS info (device sdb3): 1078755328 bytes available 
>> across all block groups
>> [117261.923750] BTRFS warning (device sdb3): Skipping commit of 
>> aborted transaction.
>> [117261.931608] ------------[ cut here ]------------
>> [117261.936687] BTRFS: Transaction aborted (error -28)
>> [117261.941950] WARNING: fs/btrfs/transaction.c:2060 at 
>> btrfs_commit_transaction+0xaaa/0xe20 [btrfs], CPU#6: mount/2008
>> [117261.952905] Modules linked in: ntfs3 btrfs libblake2b raid10 
>> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor 
>> raid6_pq raid1 raid0 md_mod auto
>> fs4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid sr_mod 
>> cdrom uas usb_storage i915 drm_buddy ttm i2c_algo_bit 
>> drm_display_helper cec sd_mod rc_core drm_cli
>> ent_lib drm_kms_helper iTCO_wdt xhci_pci ahci intel_pmc_bxt drm 
>> libahci watchdog xhci_hcd firewire_ohci libata firewire_core r8169 
>> video realtek crc_itu_t usbcore scsi_
>> mod fan i2c_i801 wmi button usb_common i2c_smbus scsi_common efivarfs
>> [117262.004021] CPU: 6 UID: 0 PID: 2008 Comm: mount Tainted: G 
>> W           7.0.10+deb14-amd64 #1 PREEMPT(lazy)  Debian 7.0.10-1
>> [117262.016343] Tainted: [W]=WARN
>> [117262.019853] Hardware name: LENOVO 10M8S14C42/3102, BIOS M16KT71A 
>> 09/14/2023
>> [117262.027348] RIP: 0010:btrfs_commit_transaction+0xaac/0xe20 [btrfs]
>> [117262.034117] Code: ff 48 8b 7c 24 08 31 c9 48 8d b7 48 01 00 00 e8 
>> 9a 7c 0b 00 48 c7 43 18 00 00 00 00 e9 73 fe ff ff 48 8d 3d 66 fd 34 
>> 00 89 ee <67> 48 0f b9 3a e9
>> f8 fe ff ff 49 8b bc 24 48 03 00 00 be 02 00 00
>> [117262.053426] RSP: 0018:ffffce9fc8b57418 EFLAGS: 00010292
>> [117262.059233] RAX: 0000000000000002 RBX: ffff8ac4d181a738 RCX: 
>> 0000000000000003
>> [117262.066946] RDX: 0000000002040001 RSI: 00000000ffffffe4 RDI: 
>> ffffffffc1028080
>> [117262.074658] RBP: 00000000ffffffe4 R08: 0000000000000000 R09: 
>> ffffce9fc8b57200
>> [117262.082364] R10: ffff8acbe23fff90 R11: 00000000fff7ffff R12: 
>> ffff8ac545885000
>> [117262.090075] R13: ffff8ac4c242ea00 R14: ffff8ac5458854c0 R15: 
>> ffff8ac4cff01b80
>> [117262.097779] FS:  00007f22c28cf940(0000) GS:ffff8acc3a4fc000(0000) 
>> knlGS:0000000000000000
>> [117262.106429] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [117262.112740] CR2: 00007f22c2cdfdd0 CR3: 00000001867ac001 CR4: 
>> 00000000003706f0
>> [117262.120434] Call Trace:
>> [117262.123451]  <TASK>
>> [117262.126121]  ? start_transaction+0x228/0x880 [btrfs]
>> [117262.131676]  flush_space+0x3c3/0x5a0 [btrfs]
>> [117262.136574]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
>> [117262.142855]  ? calc_available_free_space.isra.0+0x70/0xc0 [btrfs]
>> [117262.149597]  priority_reclaim_metadata_space+0x96/0x130 [btrfs]
>> [117262.156132]  handle_reserve_ticket+0x5b/0x290 [btrfs]
>> [117262.161800]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
>> [117262.168076]  reserve_bytes+0x268/0x4c0 [btrfs] [117262.173127] 
>> btrfs_reserve_metadata_bytes+0x1a/0xe0 [btrfs]
>> [117262.179306]  btrfs_block_rsv_refill+0x60/0x90 [btrfs]
>> [117262.184965]  evict_refill_and_join+0x47/0xe0 [btrfs]
>> [117262.190531]  btrfs_evict_inode+0x332/0x400 [btrfs]
>> [117262.195922]  evict+0xfd/0x270
>> [117262.199441]  btrfs_orphan_cleanup+0x21f/0x390 [btrfs]
>> [117262.205085]  btrfs_start_pre_rw_mount+0x2a0/0x6c0 [btrfs]
>> [117262.211071]  open_ctree+0x12fb/0x1730 [btrfs]
>> [117262.216028]  btrfs_get_tree.cold+0xb/0xb6 [btrfs]
>> [117262.221324]  ? security_inode_permission+0x4a/0x110
>> [117262.226747]  vfs_get_tree+0x29/0xd0
>> [117262.230776]  vfs_cmd_create+0x57/0xd0
>> [117262.234947]  __do_sys_fsconfig+0x2fc/0x5e0
>> [117262.239581]  do_syscall_64+0xcd/0x15f0
>> [117262.243873]  ? __fs_parse+0x68/0x1c0
>> [117262.247989]  ? aa_file_perm+0x18a/0x550
>> [117262.252368]  ? btrfs_parse_param+0x4f/0x960 [btrfs]
>> [117262.257818]  ? apparmor_file_permission+0x44/0xb0
>> [117262.263052]  ? fscontext_read+0x171/0x190
>> [117262.267594]  ? rw_verify_area+0x56/0x180
>> [117262.272039]  ? vfs_read+0xbf/0x390
>> [117262.275964]  ? __fs_parse+0x68/0x1c0
>> [117262.280063]  ? aa_file_perm+0x18a/0x550
>> [117262.284422]  ? btrfs_parse_param+0x4f/0x960 [btrfs]
>> [117262.289858]  ? apparmor_file_permission+0x44/0xb0
>> [117262.295082]  ? fscontext_read+0x171/0x190
>> [117262.299605]  ? rw_verify_area+0x56/0x180
>> [117262.304036]  ? vfs_read+0xbf/0x390
>> [117262.307943]  ? do_syscall_64+0x10a/0x15f0
>> [117262.312451]  ? from_kgid_munged+0x17/0x30
>> [117262.316955]  ? __do_sys_getgid+0x27/0x30
>> [117262.321369]  ? do_syscall_64+0x10a/0x15f0
>> [117262.325856]  ? from_kgid_munged+0x17/0x30
>> [117262.330340]  ? ksys_read+0x73/0xf0
>> [117262.334213]  ? do_syscall_64+0x10a/0x15f0
>> [117262.338694]  ? irqentry_exit+0x78/0x680
>> [117262.343000]  ? exc_page_fault+0x82/0x1d0
>> [117262.347384]  ? __irq_exit_rcu+0x3d/0xe0 [117262.351683] 
>> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> [117262.357197] RIP: 0033:0x7f22c2d0eb4a
>> [117262.361218] Code: 73 01 c3 48 8b 0d c6 32 0d 00 f7 d8 64 89 01 48 
>> 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 af 01 00 
>> 00 0f 05 <48> 3d 01 f0 ff ff
>> 73 01 c3 48 8b 0d 96 32 0d 00 f7 d8 64 89 01 48
>> [117262.380431] RSP: 002b:00007ffd5d547f68 EFLAGS: 00000246 ORIG_RAX: 
>> 00000000000001af
>> [117262.388464] RAX: ffffffffffffffda RBX: 0000557471e4da50 RCX: 
>> 00007f22c2d0eb4a
>> [117262.396057] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 
>> 0000000000000003
>> [117262.403650] RBP: 0000000000000003 R08: 0000000000000000 R09: 
>> 0000000000000000
>> [117262.411240] R10: 0000000000000000 R11: 0000000000000246 R12: 
>> 0000557471e4ec40
>> [117262.418831] R13: 00007f22c2ea127c R14: 00007f22c2e9f460 R15: 
>> 00007f22c28cf7f0
>> [117262.426410]  </TASK>
>> [117262.429024] ---[ end trace 0000000000000000 ]---
>> [117262.434074] BTRFS info (device sdb3 state A): dumping space info:
>> [117262.440595] BTRFS info (device sdb3 state A): space_info DATA 
>> (sub-group id 0) has 17422925824 free, is not full
>> [117262.451184] BTRFS info (device sdb3 state A): space_info 
>> total=70262980608, used=52839989248, pinned=0, reserved=0, may_use=0, 
>> readonly=65536 zone_unusable=0
>> [117262.465659] BTRFS info (device sdb3 state A): space_info METADATA 
>> (sub-group id 0) has -190382080 free, is full
>> [117262.476171] BTRFS info (device sdb3 state A): space_info 
>> total=3221225472, used=2142470144, pinned=0, reserved=0, 
>> may_use=190382080, readonly=1078755328 zone_unusable=0
>> [117262.491598] BTRFS info (device sdb3 state A): space_info SYSTEM 
>> (sub-group id 0) has 0 free, is not full
>> [117262.501477] BTRFS info (device sdb3 state A): space_info 
>> total=33554432, used=16384, pinned=0, reserved=0, may_use=0, 
>> readonly=33538048 zone_unusable=0
>> [117262.515439] BTRFS info (device sdb3 state A): global_block_rsv: 
>> size 190382080 reserved 190382080
>> [117262.524731] BTRFS info (device sdb3 state A): trans_block_rsv: 
>> size 0 reserved 0
>> [117262.532538] BTRFS info (device sdb3 state A): chunk_block_rsv: 
>> size 0 reserved 0
>> [117262.540337] BTRFS info (device sdb3 state A): remap_block_rsv: 
>> size 0 reserved 0
>> [117262.548136] BTRFS info (device sdb3 state A): delayed_block_rsv: 
>> size 0 reserved 0
>> [117262.556110] BTRFS info (device sdb3 state A): delayed_refs_rsv: 
>> size 0 reserved 0
>> [117262.563998] BTRFS: error (device sdb3 state A) in 
>> cleanup_transaction:2060: errno=-28 No space left
>> [117262.573453] BTRFS info (device sdb3 state EA): space_info METADATA 
>> (sub-group id 0) has -190382080 free, is full
>> [117262.584033] BTRFS info (device sdb3 state EA): space_info 
>> total=3221225472, used=2142470144, pinned=0, reserved=0, 
>> may_use=190382080, readonly=1078755328 zone_unusable=0
>> [117262.599563] BTRFS info (device sdb3 state EA): global_block_rsv: 
>> size 190382080 reserved 190382080
>> [117262.608943] BTRFS info (device sdb3 state EA): trans_block_rsv: 
>> size 0 reserved 0
>> [117262.616846] BTRFS info (device sdb3 state EA): chunk_block_rsv: 
>> size 0 reserved 0
>> [117262.624749] BTRFS info (device sdb3 state EA): remap_block_rsv: 
>> size 0 reserved 0
>> [117262.632643] BTRFS info (device sdb3 state EA): delayed_block_rsv: 
>> size 0 reserved 0
>> [117262.640715] BTRFS info (device sdb3 state EA): delayed_refs_rsv: 
>> size 0 reserved 0
>> [117262.648696] BTRFS info (device sdb3 state EA): space_info METADATA 
>> (sub-group id 0) has -190382080 free, is full
>> [117262.659312] BTRFS info (device sdb3 state EA): space_info 
>> total=3221225472, used=2142470144, pinned=0, reserved=0, 
>> may_use=190382080, readonly=1078755328 zone_unusable=0
>> [117262.674875] BTRFS info (device sdb3 state EA): global_block_rsv: 
>> size 190382080 reserved 190382080
>> [117262.684287] BTRFS info (device sdb3 state EA): trans_block_rsv: 
>> size 0 reserved 0
>> [117262.692225] BTRFS info (device sdb3 state EA): chunk_block_rsv: 
>> size 0 reserved 0
>> [117262.700155] BTRFS info (device sdb3 state EA): remap_block_rsv: 
>> size 0 reserved 0
>> [117262.708086] BTRFS info (device sdb3 state EA): delayed_block_rsv: 
>> size 0 reserved 0
>> [117262.716191] BTRFS info (device sdb3 state EA): delayed_refs_rsv: 
>> size 0 reserved 0
>> [117262.724260] BTRFS warning (device sdb3 state EA): could not 
>> allocate space for delete; will truncate on mount
>> [117262.734622] BTRFS error (device sdb3 state EA): Error removing 
>> orphan entry, stopping orphan cleanup
>> [117262.744220] BTRFS error (device sdb3 state EA): could not do 
>> orphan cleanup -28
>> [117262.752021] BTRFS error (device sdb3 state EA): commit super block 
>> returned -30
>> [117262.760739] BTRFS error (device sdb3 state EA): open_ctree failed: 
>> -28
>> mount: /var: fsconfig() failed: No space left on device.
>>        dmesg(1) may have more information after failed mount system call.
>>
>>
>>
>>
>>> If the first command works but the second command does not, you could 
>>> insert a `btrfs device add` command to add a partition. I'm not such 
>>> a big fan of adding USB sticks or zram devices because if anything 
>>> goes wrong, the file system ends up broken.
>>>
>>> This is a bit of a heavy hammer to fix this problem but it might 
>>> actually be faster than troubleshooting Btrfs enospc:
>>
>> I am all for troubleshooting this enospc issue because it is the first 
>> time I cannot even add a device to fix the enospc... in fact an hour 
>> before this issue I had an enospc issue this time with the root 
>> partition that had very few space left, and adding a device worked 
>> well and it was pretty easy to fix. But here I have gigabytes of 
>> unused data and metadata, I am puzzled.
>>
>> I was switching my SSD btrfs partitions (I plan to merge them all but 
>> for historical reason they are split as separate btrfs partitions 
>> instead of subvolumes of a single btrfs partition) from single to DUP, 
>> the new default.
>>
>>
>>
>>  I believe the main issue here is that the conversion attempted to use 
>> until the last megabyte of metadata before errorring out, preventing 
>> any simple rescue operation afterwards, and even preventing from 
>> balancing data to free chunks for metadata.
>>
>> It would have been fine for the conversion to error out and let me 
>> balance data then resume the conversion. The main issue is that the 
>> conversion used so much metadata space that I cannot even mount the 
>> btrfs partition to balance its data space.
>>
>> Maybe the metadata conversion should guard/ straight error out when 
>> there is not enough space in metadata (here 3GB to duplicate 1,59GB 
>> does not fit) and there is no way to get a new free chunk for metadata 
>> and tell to free chunks first ?
>>
>>
>>> It should still be possible to make the troubled Btrfs a read-only 
>>> seed device using btrfs-tune; then mount it ro; use `btrfs dev add` 
>>> using a device that's equal to or bigger; remount rw; then `btrfs dev 
>>> rem` the 1st device, i.e. the ro seed. This will replicate/clone the 
>>> file system from device 1 to device 2. And it'll take a while. But in 
>>> the end you'll have a balanced file system on device 2.
>>>
>>> It isn't strictly necessary for device 2 to be equal to or bigger. It 
>>> is possible to add a smaller device, but before you remove the 1st 
>>> device, you wlil need to delete files. The bigger files you choose to 
>>> delete, the fewer you will need to delete to get to the 
>>> underprovisioned 2nd device size. Then remove the 1st device. Now 
>>> only the files that have not been deleted will have extents 
>>> replicated to the 2nd device.
>>>
>>> At the very least the seed-device is not being modified and shouldn't 
>>> get any worse than it is.
>>> Chris Murphy


So with I tried with what I understood:
with a copy of the image I did of the partition: 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
# btrfstune -S 1 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
ERROR: please finish/cancel the running replace/balance before running 
this command

I tried:
# btrfs check --clear-space-cache v2 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
Opening filesystem to check...
Checking filesystem on 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
UUID: 13af326c-631f-482b-9c34-b59b4f100608
WARNING: --clear-space-cache option is deprecated, please use "btrfs 
rescue clear-space-cache" instead
ERROR: please finish/cancel the running replace/balance before running 
this command

# btrfs balance cancel 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
ERROR: not a directory: 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img

# btrfs rescue clear-uuid-tree 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
ERROR: please finish/cancel the running replace/balance before running 
this command



and without the seed flag:
# dd if=/dev/zero 
of=/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var_target.img 
bs=1M count=90000
90000+0 records in
90000+0 records out
94371840000 bytes (94 GB, 88 GiB) copied, 1340.52 s, 70.4 MB/s


# losetup -f --show 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
[475088.702700] loop0: detected capacity change from 0 to 166119424
/dev/loop0

# mkdir -p /mnt/seed_workspace

# mount -o ro,rescue=all /dev/loop0 /mnt/seed_workspace
[475287.536430] BTRFS info: device /dev/loop0 (7:0) using temp-fsid 
7d3aa685-b9cd-4cbc-87ed-c2d0288fdeba
[475287.546680] BTRFS: device label SSDHOME devid 1 transid 44655875 
/dev/loop0 (7:0) scanned by mount (8576)
[475287.556933] BTRFS info (device loop0 state S): first mount of 
filesystem 13af326c-631f-482b-9c34-b59b4f100608
[475287.567325] BTRFS info (device loop0 state S): using crc32c checksum 
algorithm
[475288.554301] BTRFS info (device loop0 state ECS): enabling ssd 
optimizations
[475288.562226] BTRFS info (device loop0 state ECS): disabling log 
replay at mount time
[475288.570394] BTRFS info (device loop0 state ECS): turning on async 
discard
[475288.577648] BTRFS info (device loop0 state ECS): enabling free space 
tree
[475288.584915] BTRFS info (device loop0 state ECS): ignoring bad roots
[475288.591652] BTRFS info (device loop0 state ECS): ignoring data csums
[475288.598482] BTRFS info (device loop0 state ECS): ignoring meta csums
[475288.605308] BTRFS info (device loop0 state ECS): ignoring unknown 
super block flags


# losetup -f --show 
/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var_target.img
[475310.285452] loop1: detected capacity change from 0 to 184320000
/dev/loop1


# btrfs device add /dev/loop1 /mnt/seed_workspace
Performing full device TRIM /dev/loop1 (87.89GiB) ...
ERROR: error adding device '/dev/loop1': Read-only file system



>>
>> I don't know yet how to proceed with such a read-only seed option, I 
>> will look into it. But is there other flags or tune I could do that 
>> could let me cancel the pause operation, the balance the data space, 
>> then retry the conversion ?
>>
>>
>> Alban
>>

Alban
