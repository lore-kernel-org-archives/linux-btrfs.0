Received: from gapmx.vk4msl.com (eth2015.qld.adsl.internode.on.net [150.101.176.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCA2366836
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 02:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.101.176.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780368398; cv=none; b=ie6HOBmXF5b7iNmJjRlvG4dfDDgopB6NrUk3icxmBT2bitPBzY0WUZ1LYMBu2vgoBhgNvXdcYI6RqAinFi+FjaAYhr4AAR7XGHD3Pyh/t6O6hpMXTcoT/PW1f1iclic8FanzlFcPuytPvQ4u6FqRD01pK9yam6rA0thMqk8Pc2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780368398; c=relaxed/simple;
	bh=wYEIO7aXN68p2x7cd+z/ODgZm9DpGmCVn4vVj22Maw0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=EAYWMLTWJn/QTyqPNVIQjxJFmhfBvAKamG9m6AYrzGI8D1lyo1EOD/6CejDI7WA9+JlJ74NNsKSb81Ra56B9S5E86jMo90/5ifqo9KP01IOgzAcBHLkfe5IIydFjlaC3SL5mbYaHjSKSsTWK+LV6ickNmmzhJ4bRp/CWGC4VZuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vk4msl.com; spf=pass smtp.mailfrom=vk4msl.com; dkim=pass (4096-bit key) header.d=vk4msl.com header.i=@vk4msl.com header.b=U1+pxB2X; arc=none smtp.client-ip=150.101.176.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vk4msl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vk4msl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=vk4msl.com header.i=@vk4msl.com header.b="U1+pxB2X"
Received: from gapmx.vk4msl.com (gapmx.vk4msl.com [127.0.0.1])
	by gapmx.vk4msl.com (Postfix) with ESMTP id 9ECAE58D55
	for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 12:46:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=vk4msl.com; h=message-id
	:date:mime-version:subject:from:to:references:in-reply-to
	:content-type:content-transfer-encoding; s=gapmx; bh=wYEIO7aXN68
	p2x7cd+z/ODgZm9DpGmCVn4vVj22Maw0=; b=U1+pxB2XLmjA3g1ylCAoB5oVZvk
	dqLnbgFVOkY3QYgyjnAr/CSHmlVhgUG3gNcae7pKTtq2DEWSMEmue7WiM6Z0RWcH
	DuOYkoY0ab6fMmd2vMu+qfX2VHJu7Vh9Ycb2/YqwXVypC1Weulr1gfkJpKKS0Lpz
	2Jp+TdfHqP3FvnAsZxlXanZVdAc7EO4xKqxsGSbZlmmISeeRw9LQiTtE2H1MZ6y/
	At677ULinJVHpqyUAyVOPx6EuEgyVniiaHft9tcB8+Mr5BhIDIBtvRB3Je5RKJcU
	0RpcHhzz40hfMiX5mX71OhAmA4PnqIVEO6DZoSCa8IRdq3+OMCnwwFieA+7/YQs9
	2aUgzcAjfvQi/adbmKX1F+Ph55lvNaZJemPJzb7/w3JbE2wvOIFgntsjKTwGWtO0
	YIYNlrmS2LcDe1DJPavY7ByJ9HLXusr8HeHLuibuT1hcTL71PQxzlwZ0tcuOOOuM
	3K+W7m9ib0Uk3+DuUCp4eItOps6yx/eLwHTCQ5ufCPnTJVLtT/r9WVB4Fw2rjuT8
	lmY4H2uJz9BFJ40ZWhS5ZRixRVfFEyKA42QCWH/BQCFzyKu3Qy4pqxtKkEyHQQtH
	EZB/gW1f8tlUPxP1KeF4AVNyUlfEi31nWRwL/WP4NMg5jdvBrxnv9Zs/ynbgTAZR
	nWgj8fC/AWU4/808=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=vk4msl.com; h=message-id
	:date:mime-version:subject:from:to:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=gapmx; b=h/LgM
	yV+e+BVIh2ztHGx2S8x4Rq2+Gk7LcQ+PDmN4uO9uuan0M00NBx8JzE1hmiF0bWTl
	4Aqpw3EEnPN4pcaP6AkXPD04arWlQOeATWyeonN1AsMM4x0FwdZongKkQKirC+b1
	0DL9drVH4pPjaoxXjmlBNCitprBPYgMxPV0/+mHvBzhCJAAbleiZBKFKDpI/Z/Ix
	WoxE657PIaBF8ZrNkXJ75h3OM3FxJ+clBBq6+GQa1p5WYLGvgErSf7klbXR0/GVW
	Lu+EFlvgAbPopaSRqlBvAY6bbtj+imWGquJBrQ6A+iN4BoAvmL79yd9k8n9f+JHb
	dDaprlAsvgs9vwWaw4q12UMelaBCaqucjYPDDxR7gIZEawzIdkE+hJTnutUDj9wb
	YVTlz9uIKPaiBiv3i3nHrerXe1WcD6Qc5mJ2Q8bgwCl47LvVGKUPWxs7l7AfL0S/
	mCvIHyVnygdu+tbMT1AAVdXXmk+6H0o7fDH3eDs+G2Nbaudeb3gck9TqsxKW60JD
	Mfa89aIWRmGqSye54xBqOTC/YMW/aJ8E7y7ZKvvheQxYfdXOmAzTmx3+hZIdH9eI
	1WT+ckKPzCoBtMcNl/SBDv06CjjejOWCZf/KE8wW3HFu44ZHvb3YnLcWzrhb3yAv
	kaQQ8YbnNY0N5iuz5V7RELslT+Bjbn4XfixRGQ=
Received: from [IPV6:2001:44b8:21ac:7053:47c1:8297:2d98:5f10] (unknown [IPv6:2001:44b8:21ac:7053:47c1:8297:2d98:5f10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519)
	(No client certificate requested)
	by gapmx.vk4msl.com (Postfix) with ESMTPSA id 726A958D54
	for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 12:46:11 +1000 (AEST)
Message-ID: <2df62737-96a6-40d0-9050-369463ad6550@vk4msl.com>
Date: Tue, 2 Jun 2026 12:46:32 +1000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kernel 7.0.11 circular lock on armv5tejl system booting from mmc
From: Stuart Longland VK4MSL <me@vk4msl.com>
To: linux-btrfs@vger.kernel.org
References: <4a4f5924-d858-462d-9c7e-f6545d9250b2@vk4msl.com>
Content-Language: en-GB, en-AU
In-Reply-To: <4a4f5924-d858-462d-9c7e-f6545d9250b2@vk4msl.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/26 12:20, Stuart Longland VK4MSL wrote:
> I've been porting the latest mainline kernel to some ARMv5-based 
> industrial PCs and getting them running an up-to-date OS, and happened 
> to notice this stack trace which seems very reproduce-able.
> 
> Hardware platform is Technologic Systems TS-7670
> https://docs.embeddedts.com/TS-7670
> 
> CPU: Freescale i.MX286 (MXS family) at 454MHz
> RAML 120MB DDR2
> MMC card: HP 128GB A1 V30 U3 MicroSDXC Card (HFUD128-MX330)
> OS: Gentoo Linux ARM (musl libc; I'd consider Debian but they're 
> dropping support for `armel` platforms from release 14 onwards and 
> AlpineLinux just recently dropped ARMv6 having never supported ARMv5.)
> 
> Kernel tree is at
> https://github.com/sjlongland/linux-ts7670/tree/ts7670-7.0.11

Realised I grabbed the stack trace from the wrong box which was running 
kernel 7.0 (same repository, it's the `ts7670-7.0` branch in that case):

Here's one from 7.0.11:
> [  107.283716]
> [  107.285335] ======================================================
> [  107.291586] WARNING: possible circular locking dependency detected
> [  107.297831] 7.0.11-vrt-ts7670+ #1 Not tainted
> [  107.302253] ------------------------------------------------------
> [  107.308489] (udev-worker)/364 is trying to acquire lock:
> [  107.313864] c18f14c4 (&type->i_mutex_dir_key#2){++++}-{3:3}, at: lookup_slow+0x20/0x44
> [  107.322060]
> [  107.322060] but task is already holding lock:
> [  107.327949] c1a90498 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x150/0xba0
> [  107.337927]
> [  107.337927] which lock already depends on the new lock.
> [  107.337927]
> [  107.346158]
> [  107.346158] the existing dependency chain (in reverse order) is:
> [  107.353689]
> [  107.353689] -> #5 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
> [  107.360989]        __mutex_lock+0xb4/0x1278
> [  107.365275]        mutex_lock_nested+0x1c/0x24
> [  107.369806]        btrfs_run_dev_stats+0x34/0x38c
> [  107.374604]        commit_cowonly_roots+0xac/0x2d8
> [  107.379482]        btrfs_commit_transaction+0x478/0x1780
> [  107.384881]        transaction_kthread+0x160/0x1b8
> [  107.389752]        kthread+0x120/0x158
> [  107.393595]        ret_from_fork+0x14/0x38
> [  107.397777]
> [  107.397777] -> #4 (&fs_info->reloc_mutex){+.+.}-{3:3}:
> [  107.404563]        __mutex_lock+0xb4/0x1278
> [  107.408841]        mutex_lock_nested+0x1c/0x24
> [  107.413367]        btrfs_record_root_in_trans+0x58/0x98
> [  107.418677]        start_transaction+0xd8/0xbac
> [  107.423290]        btrfs_start_transaction+0x1c/0x24
> [  107.428336]        btrfs_create_common+0x98/0x12c
> [  107.433136]        vfs_mknod+0x144/0x228
> [  107.437154]        filename_mknodat+0x228/0x288
> [  107.441784]        sys_mknod+0x38/0x50
> [  107.445614]        ret_fast_syscall+0x0/0x1c
> [  107.449967]
> [  107.449967] -> #3 (btrfs_trans_num_extwriters){++++}-{0:0}:
> [  107.457189]        join_transaction+0xd4/0x574
> [  107.461723]        start_transaction+0x19c/0xbac
> [  107.466429]        btrfs_start_transaction+0x1c/0x24
> [  107.471477]        btrfs_create_common+0x98/0x12c
> [  107.476274]        vfs_mknod+0x144/0x228
> [  107.480288]        filename_mknodat+0x228/0x288
> [  107.484914]        sys_mknod+0x38/0x50
> [  107.488744]        ret_fast_syscall+0x0/0x1c
> [  107.493091]
> [  107.493091] -> #2 (btrfs_trans_num_writers){++++}-{0:0}:
> [  107.500045]        lock_release+0x154/0x334
> [  107.504333]        __btrfs_end_transaction+0x1fc/0x348
> [  107.509560]        btrfs_dirty_inode+0xa0/0xd0
> [  107.514097]        touch_atime+0xf8/0x288
> [  107.518190]        btrfs_file_mmap_prepare+0x64/0x90
> [  107.523257]        __mmap_region+0x478/0xbac
> [  107.527624]        do_mmap+0x3a4/0x504
> [  107.531470]        vm_mmap_pgoff+0xb8/0x1a8
> [  107.535745]        elf_load+0x15c/0x250
> [  107.539687]        load_elf_binary+0x2c8/0x149c
> [  107.544312]        bprm_execve+0x2b4/0x604
> [  107.548497]        do_execveat_common+0x16c/0x1b8
> [  107.553283]        sys_execve+0x38/0x50
> [  107.557204]        ret_fast_syscall+0x0/0x1c
> [  107.561556]
> [  107.561556] -> #1 (&mm->mmap_lock){++++}-{3:3}:
> [  107.567735]        __might_fault+0x4c/0x74
> [  107.571955]        filldir64+0xac/0x2b0
> [  107.575882]        offset_readdir+0x90/0x210
> [  107.580263]        iterate_dir+0x60/0x138
> [  107.584359]        sys_getdents64+0x68/0x1b0
> [  107.588710]        ret_fast_syscall+0x0/0x1c
> [  107.593065]
> [  107.593065] -> #0 (&type->i_mutex_dir_key#2){++++}-{3:3}:
> [  107.600132]        __lock_acquire+0x15b4/0x2bf0
> [  107.604756]        lock_acquire.part.0+0xb4/0x264
> [  107.609547]        down_read+0x34/0x200
> [  107.613478]        lookup_slow+0x20/0x44
> [  107.617501]        path_lookupat+0x1a4/0x2e4
> [  107.621865]        filename_lookup+0x7c/0xf0
> [  107.626229]        kern_path+0x38/0x50
> [  107.630072]        device_list_add.constprop.0+0x25c/0xba0
> [  107.635655]        btrfs_scan_one_device+0x114/0x244
> [  107.640708]        btrfs_control_ioctl+0xfc/0x1d0
> [  107.645516]        sys_ioctl+0x538/0xb5c
> [  107.649524]        ret_fast_syscall+0x0/0x1c
> [  107.653876]
> [  107.653876] other info that might help us debug this:
> [  107.653876]
> [  107.661931] Chain exists of:
> [  107.661931]   &type->i_mutex_dir_key#2 --> &fs_info->reloc_mutex --> &fs_devs->device_list_mutex
> [  107.661931]
> [  107.675282]  Possible unsafe locking scenario:
> [  107.675282]
> [  107.681254]        CPU0                    CPU1
> [  107.685831]        ----                    ----
> [  107.690406]   lock(&fs_devs->device_list_mutex);
> [  107.695129]                                lock(&fs_info->reloc_mutex);
> [  107.701847]                                lock(&fs_devs->device_list_mutex);
> [  107.709087]   rlock(&type->i_mutex_dir_key#2);
> [  107.713662]
> [  107.713662]  *** DEADLOCK ***
> [  107.713662]
> [  107.719630] 2 locks held by (udev-worker)/364:
> [  107.724137]  #0: c10aa2b0 (uuid_mutex){+.+.}-{3:3}, at: btrfs_control_ioctl+0xf0/0x1d0
> [  107.732303]  #1: c1a90498 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x150/0xba0
> [  107.742718]
> [  107.742718] stack backtrace:
> [  107.747137] CPU: 0 UID: 0 PID: 364 Comm: (udev-worker) Not tainted 7.0.11-vrt-ts7670+ #1 VOLUNTARY
> [  107.756276] Hardware name: Freescale MXS (Device Tree)
> [  107.761477] Call trace:
> [  107.761523]  unwind_backtrace from show_stack+0x10/0x14
> [  107.769454]  show_stack from dump_stack_lvl+0x48/0x64
> [  107.774644]  dump_stack_lvl from print_circular_bug+0x25c/0x37c
> [  107.780698]  print_circular_bug from check_noncircular+0x194/0x1c8
> [  107.786994]  check_noncircular from __lock_acquire+0x15b4/0x2bf0
> [  107.793120]  __lock_acquire from lock_acquire.part.0+0xb4/0x264
> [  107.799153]  lock_acquire.part.0 from down_read+0x34/0x200
> [  107.804764]  down_read from lookup_slow+0x20/0x44
> [  107.809595]  lookup_slow from path_lookupat+0x1a4/0x2e4
> [  107.814950]  path_lookupat from filename_lookup+0x7c/0xf0
> [  107.820483]  filename_lookup from kern_path+0x38/0x50
> [  107.825665]  kern_path from device_list_add.constprop.0+0x25c/0xba0
> [  107.832068]  device_list_add.constprop.0 from btrfs_scan_one_device+0x114/0x244
> [  107.839501]  btrfs_scan_one_device from btrfs_control_ioctl+0xfc/0x1d0
> [  107.846157]  btrfs_control_ioctl from sys_ioctl+0x538/0xb5c
> [  107.851853]  sys_ioctl from ret_fast_syscall+0x0/0x1c
> [  107.857007] Exception stack(0xc8ae5fa8 to 0xc8ae5ff0)
> [  107.862143] 5fa0:                   b5b60db0 00000014 00000014 90009427 beb694c8 beb69498
> [  107.870400] 5fc0: b5b60db0 00000014 00000000 00000036 beb694c8 00000014 00000ff7 00000003
> [  107.878646] 5fe0: beb68478 beb69370 005168a8 b6eec390
> [  109.991061] fec 800f0000.ethernet end0: renamed from eth0

-- 
Stuart Longland (aka Redhatter, VK4MSL)

I haven't lost my mind...
   ...it's backed up on a tape somewhere.
