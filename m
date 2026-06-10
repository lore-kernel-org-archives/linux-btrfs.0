Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7F23A7F5E
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 21:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781125510; cv=none; b=MF93zZu5B+/juiJ4/s1J5cjrA6L8eUFY/s9KCUiCa0wLzUiKWtm/pm/d416ei9Q9lsn0BQ/JIk0j0GCpX+mqgGn2WPTR6d/UbjXHi5W3FkEePIK0o805/+1uEJoY5oP/DAQbEehhSmjiKoXeg4RPoGrr9x29ySvcXx6XjizWCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781125510; c=relaxed/simple;
	bh=uv3Qnxue75ZrzuYwAdf5b+X7xQlYJGx6iukW3Ua6Zpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=skniwPgPNYgLeOHEPmJowpzlwpTXTswKNC4Ibuw0XZVcrCImEJj766oId4q06AbGWJ952bgTcTP6kI7F4LP3KFsZ56eQhBaZFeSda7Iq3HGeHuMif40WenqxaynTQXxh0vNPKtg0QF1Xfkgiu41p3bt5rW/DIFJYaifLWq1LPWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L58k9rdy; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L58k9rdy"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so32452115e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 14:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781125507; x=1781730307; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y3mNKXAGqgbxmf1ZoEPRPgdRPtwi1B+hsTfQVhLfq2Q=;
        b=L58k9rdyRhiYyDOsb+Gup7A7eZN6444HK3QAwItLScADrDuCDyOs/tUbEOrOEfoLUv
         tmTSBXbL1iauglc3LoTzOjQmuBTl/z13fyLNU3PTaYHT3Sx0a2lX7RmZZ+C/4NI3cG38
         HhD2Q/BedfXi0zG6A+1RvTXaLs02Lvmh7+Jj4oloPs7JnSvUFJeG2PfmJ6/+ShN3c7za
         pO0B+zb0JmCgbHI+Hoodr1qWk/qQ7vZ+4FdO9hCPgKaXmNq1TCwliaTn2i1x9BlEdax/
         qBsLQ1cd/E0RUh6iflHDfIORJ9a2VyOOnpM6s+/Ybcj3jlWGKQUQgScZqhnOh5dc1saN
         rIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781125507; x=1781730307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3mNKXAGqgbxmf1ZoEPRPgdRPtwi1B+hsTfQVhLfq2Q=;
        b=LUeLY9wdGdOg3ZdnphRtM0nejznLhhEJzO9rkplN6YUn1iClJYqMqyC+4zNzx9T71y
         E7lAOXMJDLWbNXMG/gR7lP9BIwPCQ+nRqX+cAV4j1MTFG4PRAzYOBjT9CA5AOS2gIZFs
         VVFcW/zPQgP18pbjd/+pGuGCZdSbwNIhaNcfGgQVyAuBjCtFxT6tEerCo64x1+r8GAlC
         +OYOGg6en3qB0UFrBpx98q/6W5PnM9TPcuoR583dWjbnmnKdGabun3aOqj2SfaK4lXhG
         gVURzDBJir3Z43DsyQpDugBHbwiJsBbFHUFWMs2jLwAjYSd8RbQVkeKbSdpjJvPRTBzL
         +6Rg==
X-Forwarded-Encrypted: i=1; AFNElJ+gVfKL2k+5+hs4zDiX3+Tv9qVd7ZbFTP8Cgpoycj+61DP7Bv6wXKjBSOA8lnVHZRUBTAXMSJUKH452/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTMzq0tjU39GhnL3EaYq4B5yz8QYp8UcNLR59YQxsR63TXMrW/
	h7a1Dy8BFVtYkTfFDR19RBlZuAg2MofOFXi+Dj5iGumSlI/qonLXQ5deMWKN/l1t
X-Gm-Gg: Acq92OFsnK30MxUuSySXhT8N11WIjb9bMjxbSh37HPYVzG9jpzbmZ2T6yA9Bvdno8nA
	skWt+iYoEKjKkFoEJ+KCKzCzx5NItMHlU44hA1+MkcP28jBVRiFY0LyazFQrDR7SWu+9/rZnPkQ
	vycHAk773wXce5EC9hFKl0MLODCRPyEEUD8zoobxxzSKIu4lCBy2UuSQYC2UXcPUsbLg1FYlXy1
	B7pFlldqIPNcm6z2qAifmZHR9U9msnFyASFt8MlRsCqNlJg9IShjdrI0Eo1IZAwl5NujAlw7WgJ
	B7wC10gO7wsBG3xTNZmdnxmyF4NrmgDRRvCtaM1/FHEm4N1/FeZyMv4PL8cEhL63czW0DMFaTwU
	eZrEQBbMJNAwIxSVZtzG77dNdUNhSQcc0sO2KDU6/xBxUJqFgQxS9cTBORY9WLwF7lB5C1345xA
	z29pIl9refhl+19mRSVhYGOJoVC/7ASduss/9fK4w3YLKNtm+u9kBtXYg/Dk173oAcz9ul6uBsV
	0cHsbZLdT8DVoAlefPdLRSYHscV8L+JGDc=
X-Received: by 2002:a05:600c:6091:b0:490:601f:d766 with SMTP id 5b1f17b1804b1-490c259a103mr459462605e9.1.1781125506855;
        Wed, 10 Jun 2026 14:05:06 -0700 (PDT)
Received: from [192.168.10.168] (91-175-163-178.subs.proxad.net. [91.175.163.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dc577sm76254630f8f.3.2026.06.10.14.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 14:05:06 -0700 (PDT)
Message-ID: <28d08133-999f-4d43-9cd5-67b856246687@gmail.com>
Date: Wed, 10 Jun 2026 23:05:05 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance
 paused in progress"
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
 <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
 <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
Content-Language: en-US
From: Alban Browaeys <alban.browaeys@gmail.com>
In-Reply-To: <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 09/06/2026 à 17:25, Chris Murphy a écrit :
> Try:
>
> mount -o skip_balance,nospace_cache,enospc_debug /dev/sdb3 /var
> btrfs balance start -dlimit=1 /var


Thanks for the suggestions. Unfortunately, the bypass did not work.

# mount -o skip_balance,nospace_cache,enospc_debug /dev/sdb3 /var
[117052.507168] BTRFS: device label SSDHOME devid 1 transid 44655875 /dev/sdb3 (8:19) scanned by mount (2004)
[117052.526475] BTRFS info (device sdb3): first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[117052.536146] BTRFS info (device sdb3): using crc32c checksum algorithm
[117052.543125] BTRFS error (device sdb3): cannot disable free-space-tree
[117052.550097] BTRFS error (device sdb3): open_ctree failed: -22
mount: /var: wrong fs type, bad option, bad superblock on /dev/sdb3, missing codepage or helper program, or other error.
        dmesg(1) may have more information after failed mount system call.


I believe this issue is blocking me:

[117052.543125] BTRFS error (device sdb3): cannot disable free-space-tree

So I tried with enospc_debug without nospace_cache, to get debug infos:

# mount -o skip_balance,enospc_debug /dev/sdb3 /var
[117261.590047] BTRFS: device label SSDHOME devid 1 transid 44655875 /dev/sdb3 (8:19) scanned by mount (2008)
[117261.612863] BTRFS info (device sdb3): first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[117261.622548] BTRFS info (device sdb3): using crc32c checksum algorithm
[117261.662415] BTRFS info (device sdb3): left=0, need=393216, flags=36
[117261.669328] BTRFS info (device sdb3): space_info SYSTEM (sub-group id 0) has 0 free, is not full
[117261.678792] BTRFS info (device sdb3): space_info total=33554432, used=16384, pinned=0, reserved=0, may_use=0, readonly=33538048 zone_unusable=0
[117261.692344] BTRFS info (device sdb3): global_block_rsv: size 190382080 reserved 190382080
[117261.701131] BTRFS info (device sdb3): trans_block_rsv: size 0 reserved 0
[117261.708349] BTRFS info (device sdb3): chunk_block_rsv: size 0 reserved 0
[117261.715571] BTRFS info (device sdb3): remap_block_rsv: size 0 reserved 0
[117261.722782] BTRFS info (device sdb3): delayed_block_rsv: size 0 reserved 0
[117261.730154] BTRFS info (device sdb3): delayed_refs_rsv: size 0 reserved 0
[117261.737462] BTRFS error (device sdb3): allocation failed flags 36, wanted 16384 tree-log 0, relocation: 0
[117261.747497] BTRFS info (device sdb3): space_info METADATA (sub-group id 0) has -190382080 free, is full
[117261.757371] BTRFS info (device sdb3): space_info total=3221225472, used=2142470144, pinned=0, reserved=0, may_use=190382080, readonly=1078755328 zone_unusable=0
[117261.772172] BTRFS info (device sdb3): global_block_rsv: size 190382080 reserved 190365696
[117261.780844] BTRFS info (device sdb3): trans_block_rsv: size 0 reserved 0
[117261.787995] BTRFS info (device sdb3): chunk_block_rsv: size 0 reserved 0
[117261.795127] BTRFS info (device sdb3): remap_block_rsv: size 0 reserved 0
[117261.802251] BTRFS info (device sdb3): delayed_block_rsv: size 0 reserved 0
[117261.809551] BTRFS info (device sdb3): delayed_refs_rsv: size 0 reserved 0
[117261.816785] BTRFS info (device sdb3): block group 55856594944 has 1073741824 bytes, 1007976448 used 0 pinned 0 reserved 0 delalloc 0 super 0 zone_unusable (65765376
  bytes available) [readonly]
[117261.834327] BTRFS info (device sdb3): block group has cluster?: no
[117261.840947] BTRFS info (device sdb3): 0 free space entries at or bigger than 16384 bytes
[117261.849500] BTRFS info (device sdb3): block group 101368987648 has 1073741824 bytes, 500957184 used 0 pinned 0 reserved 0 delalloc 0 super 0 zone_unusable (57278464
0 bytes available) [readonly]
[117261.867163] BTRFS info (device sdb3): block group has cluster?: no
[117261.873784] BTRFS info (device sdb3): 0 free space entries at or bigger than 16384 bytes                                                                            [117261.882313] BTRFS info (device sdb3): block group 102442729472 has 1073741824 bytes, 633536512 used 0 pinned 0 reserved 0 delalloc 0 super 0 zone_unusable (44020531
2 bytes available) [readonly]
[117261.899994] BTRFS info (device sdb3): block group has cluster?: no
[117261.906630] BTRFS info (device sdb3): 0 free space entries at or bigger than 16384 bytes
[117261.915176] BTRFS info (device sdb3): 1078755328 bytes available across all block groups
[117261.923750] BTRFS warning (device sdb3): Skipping commit of aborted transaction.
[117261.931608] ------------[ cut here ]------------
[117261.936687] BTRFS: Transaction aborted (error -28)
[117261.941950] WARNING: fs/btrfs/transaction.c:2060 at btrfs_commit_transaction+0xaaa/0xe20 [btrfs], CPU#6: mount/2008
[117261.952905] Modules linked in: ntfs3 btrfs libblake2b raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 md_mod auto
fs4 hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid sr_mod cdrom uas usb_storage i915 drm_buddy ttm i2c_algo_bit drm_display_helper cec sd_mod rc_core drm_cli
ent_lib drm_kms_helper iTCO_wdt xhci_pci ahci intel_pmc_bxt drm libahci watchdog xhci_hcd firewire_ohci libata firewire_core r8169 video realtek crc_itu_t usbcore scsi_
mod fan i2c_i801 wmi button usb_common i2c_smbus scsi_common efivarfs
[117262.004021] CPU: 6 UID: 0 PID: 2008 Comm: mount Tainted: G        W           7.0.10+deb14-amd64 #1 PREEMPT(lazy)  Debian 7.0.10-1
[117262.016343] Tainted: [W]=WARN
[117262.019853] Hardware name: LENOVO 10M8S14C42/3102, BIOS M16KT71A 09/14/2023
[117262.027348] RIP: 0010:btrfs_commit_transaction+0xaac/0xe20 [btrfs]
[117262.034117] Code: ff 48 8b 7c 24 08 31 c9 48 8d b7 48 01 00 00 e8 9a 7c 0b 00 48 c7 43 18 00 00 00 00 e9 73 fe ff ff 48 8d 3d 66 fd 34 00 89 ee <67> 48 0f b9 3a e9
f8 fe ff ff 49 8b bc 24 48 03 00 00 be 02 00 00
[117262.053426] RSP: 0018:ffffce9fc8b57418 EFLAGS: 00010292
[117262.059233] RAX: 0000000000000002 RBX: ffff8ac4d181a738 RCX: 0000000000000003
[117262.066946] RDX: 0000000002040001 RSI: 00000000ffffffe4 RDI: ffffffffc1028080
[117262.074658] RBP: 00000000ffffffe4 R08: 0000000000000000 R09: ffffce9fc8b57200
[117262.082364] R10: ffff8acbe23fff90 R11: 00000000fff7ffff R12: ffff8ac545885000
[117262.090075] R13: ffff8ac4c242ea00 R14: ffff8ac5458854c0 R15: ffff8ac4cff01b80
[117262.097779] FS:  00007f22c28cf940(0000) GS:ffff8acc3a4fc000(0000) knlGS:0000000000000000
[117262.106429] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[117262.112740] CR2: 00007f22c2cdfdd0 CR3: 00000001867ac001 CR4: 00000000003706f0
[117262.120434] Call Trace:
[117262.123451]  <TASK>
[117262.126121]  ? start_transaction+0x228/0x880 [btrfs]
[117262.131676]  flush_space+0x3c3/0x5a0 [btrfs]
[117262.136574]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
[117262.142855]  ? calc_available_free_space.isra.0+0x70/0xc0 [btrfs]
[117262.149597]  priority_reclaim_metadata_space+0x96/0x130 [btrfs]
[117262.156132]  handle_reserve_ticket+0x5b/0x290 [btrfs]
[117262.161800]  ? btrfs_reduce_alloc_profile+0x5a/0x1d0 [btrfs]
[117262.168076]  reserve_bytes+0x268/0x4c0 [btrfs]                                                                                                                      [117262.173127]  btrfs_reserve_metadata_bytes+0x1a/0xe0 [btrfs]
[117262.179306]  btrfs_block_rsv_refill+0x60/0x90 [btrfs]
[117262.184965]  evict_refill_and_join+0x47/0xe0 [btrfs]
[117262.190531]  btrfs_evict_inode+0x332/0x400 [btrfs]
[117262.195922]  evict+0xfd/0x270
[117262.199441]  btrfs_orphan_cleanup+0x21f/0x390 [btrfs]
[117262.205085]  btrfs_start_pre_rw_mount+0x2a0/0x6c0 [btrfs]
[117262.211071]  open_ctree+0x12fb/0x1730 [btrfs]
[117262.216028]  btrfs_get_tree.cold+0xb/0xb6 [btrfs]
[117262.221324]  ? security_inode_permission+0x4a/0x110
[117262.226747]  vfs_get_tree+0x29/0xd0
[117262.230776]  vfs_cmd_create+0x57/0xd0
[117262.234947]  __do_sys_fsconfig+0x2fc/0x5e0
[117262.239581]  do_syscall_64+0xcd/0x15f0
[117262.243873]  ? __fs_parse+0x68/0x1c0
[117262.247989]  ? aa_file_perm+0x18a/0x550
[117262.252368]  ? btrfs_parse_param+0x4f/0x960 [btrfs]
[117262.257818]  ? apparmor_file_permission+0x44/0xb0
[117262.263052]  ? fscontext_read+0x171/0x190
[117262.267594]  ? rw_verify_area+0x56/0x180
[117262.272039]  ? vfs_read+0xbf/0x390
[117262.275964]  ? __fs_parse+0x68/0x1c0
[117262.280063]  ? aa_file_perm+0x18a/0x550
[117262.284422]  ? btrfs_parse_param+0x4f/0x960 [btrfs]
[117262.289858]  ? apparmor_file_permission+0x44/0xb0
[117262.295082]  ? fscontext_read+0x171/0x190
[117262.299605]  ? rw_verify_area+0x56/0x180
[117262.304036]  ? vfs_read+0xbf/0x390
[117262.307943]  ? do_syscall_64+0x10a/0x15f0
[117262.312451]  ? from_kgid_munged+0x17/0x30
[117262.316955]  ? __do_sys_getgid+0x27/0x30
[117262.321369]  ? do_syscall_64+0x10a/0x15f0
[117262.325856]  ? from_kgid_munged+0x17/0x30
[117262.330340]  ? ksys_read+0x73/0xf0
[117262.334213]  ? do_syscall_64+0x10a/0x15f0
[117262.338694]  ? irqentry_exit+0x78/0x680
[117262.343000]  ? exc_page_fault+0x82/0x1d0
[117262.347384]  ? __irq_exit_rcu+0x3d/0xe0                                                                                                                             [117262.351683]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[117262.357197] RIP: 0033:0x7f22c2d0eb4a
[117262.361218] Code: 73 01 c3 48 8b 0d c6 32 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 af 01 00 00 0f 05 <48> 3d 01 f0 ff ff
73 01 c3 48 8b 0d 96 32 0d 00 f7 d8 64 89 01 48
[117262.380431] RSP: 002b:00007ffd5d547f68 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
[117262.388464] RAX: ffffffffffffffda RBX: 0000557471e4da50 RCX: 00007f22c2d0eb4a
[117262.396057] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
[117262.403650] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[117262.411240] R10: 0000000000000000 R11: 0000000000000246 R12: 0000557471e4ec40
[117262.418831] R13: 00007f22c2ea127c R14: 00007f22c2e9f460 R15: 00007f22c28cf7f0
[117262.426410]  </TASK>
[117262.429024] ---[ end trace 0000000000000000 ]---
[117262.434074] BTRFS info (device sdb3 state A): dumping space info:
[117262.440595] BTRFS info (device sdb3 state A): space_info DATA (sub-group id 0) has 17422925824 free, is not full
[117262.451184] BTRFS info (device sdb3 state A): space_info total=70262980608, used=52839989248, pinned=0, reserved=0, may_use=0, readonly=65536 zone_unusable=0
[117262.465659] BTRFS info (device sdb3 state A): space_info METADATA (sub-group id 0) has -190382080 free, is full
[117262.476171] BTRFS info (device sdb3 state A): space_info total=3221225472, used=2142470144, pinned=0, reserved=0, may_use=190382080, readonly=1078755328 zone_unusable=0
[117262.491598] BTRFS info (device sdb3 state A): space_info SYSTEM (sub-group id 0) has 0 free, is not full
[117262.501477] BTRFS info (device sdb3 state A): space_info total=33554432, used=16384, pinned=0, reserved=0, may_use=0, readonly=33538048 zone_unusable=0
[117262.515439] BTRFS info (device sdb3 state A): global_block_rsv: size 190382080 reserved 190382080
[117262.524731] BTRFS info (device sdb3 state A): trans_block_rsv: size 0 reserved 0
[117262.532538] BTRFS info (device sdb3 state A): chunk_block_rsv: size 0 reserved 0
[117262.540337] BTRFS info (device sdb3 state A): remap_block_rsv: size 0 reserved 0
[117262.548136] BTRFS info (device sdb3 state A): delayed_block_rsv: size 0 reserved 0
[117262.556110] BTRFS info (device sdb3 state A): delayed_refs_rsv: size 0 reserved 0
[117262.563998] BTRFS: error (device sdb3 state A) in cleanup_transaction:2060: errno=-28 No space left
[117262.573453] BTRFS info (device sdb3 state EA): space_info METADATA (sub-group id 0) has -190382080 free, is full
[117262.584033] BTRFS info (device sdb3 state EA): space_info total=3221225472, used=2142470144, pinned=0, reserved=0, may_use=190382080, readonly=1078755328 zone_unusable=0
[117262.599563] BTRFS info (device sdb3 state EA): global_block_rsv: size 190382080 reserved 190382080
[117262.608943] BTRFS info (device sdb3 state EA): trans_block_rsv: size 0 reserved 0
[117262.616846] BTRFS info (device sdb3 state EA): chunk_block_rsv: size 0 reserved 0
[117262.624749] BTRFS info (device sdb3 state EA): remap_block_rsv: size 0 reserved 0
[117262.632643] BTRFS info (device sdb3 state EA): delayed_block_rsv: size 0 reserved 0
[117262.640715] BTRFS info (device sdb3 state EA): delayed_refs_rsv: size 0 reserved 0
[117262.648696] BTRFS info (device sdb3 state EA): space_info METADATA (sub-group id 0) has -190382080 free, is full
[117262.659312] BTRFS info (device sdb3 state EA): space_info total=3221225472, used=2142470144, pinned=0, reserved=0, may_use=190382080, readonly=1078755328 zone_unusable=0
[117262.674875] BTRFS info (device sdb3 state EA): global_block_rsv: size 190382080 reserved 190382080
[117262.684287] BTRFS info (device sdb3 state EA): trans_block_rsv: size 0 reserved 0
[117262.692225] BTRFS info (device sdb3 state EA): chunk_block_rsv: size 0 reserved 0
[117262.700155] BTRFS info (device sdb3 state EA): remap_block_rsv: size 0 reserved 0
[117262.708086] BTRFS info (device sdb3 state EA): delayed_block_rsv: size 0 reserved 0
[117262.716191] BTRFS info (device sdb3 state EA): delayed_refs_rsv: size 0 reserved 0
[117262.724260] BTRFS warning (device sdb3 state EA): could not allocate space for delete; will truncate on mount
[117262.734622] BTRFS error (device sdb3 state EA): Error removing orphan entry, stopping orphan cleanup
[117262.744220] BTRFS error (device sdb3 state EA): could not do orphan cleanup -28
[117262.752021] BTRFS error (device sdb3 state EA): commit super block returned -30
[117262.760739] BTRFS error (device sdb3 state EA): open_ctree failed: -28
mount: /var: fsconfig() failed: No space left on device.
        dmesg(1) may have more information after failed mount system call.




> If the first command works but the second command does not, you could insert a `btrfs device add` command to add a partition. I'm not such a big fan of adding USB sticks or zram devices because if anything goes wrong, the file system ends up broken.
>
> This is a bit of a heavy hammer to fix this problem but it might actually be faster than troubleshooting Btrfs enospc:

I am all for troubleshooting this enospc issue because it is the first 
time I cannot even add a device to fix the enospc... in fact an hour 
before this issue I had an enospc issue this time with the root 
partition that had very few space left, and adding a device worked well 
and it was pretty easy to fix. But here I have gigabytes of unused data 
and metadata, I am puzzled.

I was switching my SSD btrfs partitions (I plan to merge them all but 
for historical reason they are split as separate btrfs partitions 
instead of subvolumes of a single btrfs partition) from single to DUP, 
the new default.



  I believe the main issue here is that the conversion attempted to use 
until the last megabyte of metadata before errorring out, preventing any 
simple rescue operation afterwards, and even preventing from balancing 
data to free chunks for metadata.

It would have been fine for the conversion to error out and let me 
balance data then resume the conversion. The main issue is that the 
conversion used so much metadata space that I cannot even mount the 
btrfs partition to balance its data space.

Maybe the metadata conversion should guard/ straight error out when 
there is not enough space in metadata (here 3GB to duplicate 1,59GB does 
not fit) and there is no way to get a new free chunk for metadata and 
tell to free chunks first ?


> It should still be possible to make the troubled Btrfs a read-only seed device using btrfs-tune; then mount it ro; use `btrfs dev add` using a device that's equal to or bigger; remount rw; then `btrfs dev rem` the 1st device, i.e. the ro seed. This will replicate/clone the file system from device 1 to device 2. And it'll take a while. But in the end you'll have a balanced file system on device 2.
>
> It isn't strictly necessary for device 2 to be equal to or bigger. It is possible to add a smaller device, but before you remove the 1st device, you wlil need to delete files. The bigger files you choose to delete, the fewer you will need to delete to get to the underprovisioned 2nd device size. Then remove the 1st device. Now only the files that have not been deleted will have extents replicated to the 2nd device.
>
> At the very least the seed-device is not being modified and shouldn't get any worse than it is.
> Chris Murphy


I don't know yet how to proceed with such a read-only seed option, I 
will look into it. But is there other flags or tune I could do that 
could let me cancel the pause operation, the balance the data space, 
then retry the conversion ?


Alban

