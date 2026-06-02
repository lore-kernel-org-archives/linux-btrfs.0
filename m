Received: from gapmx.vk4msl.com (eth2015.qld.adsl.internode.on.net [150.101.176.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FF335DA5B
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Jun 2026 02:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.101.176.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780367429; cv=none; b=CBRNOyAcE0iYsZtJ1BxJShV1YSvKoB/n5bnefnF2v+xNiBzGSQCTOF2pCOgS15vWtim1iRixrNP+XdONUs2+i7nPyyWfJdkwZ/RCpQDG/lJK3gqUe/7ur3/OgWeUR6JzSBWxd4HFx+7fI46TbjT4W487yMhHlFNrf41h0JYqEbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780367429; c=relaxed/simple;
	bh=IidRQEzaCRVi787i9z3vkETGXf4ZZJstU3ProAKTOz4=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=W31Xs64mtJGywlE4aMflJHyuCDotjFjwkkT6/7ZiaDeo5rGJNdQaAroi6fIE9wNs8mfnS5xUgglvz+XlfzTE/pX/qme04p5PB16Pjubyp1VRzjsRra5KC5u8IWAlMZQVO0hlHVHJQ3AuRFdQ/GU4tQaSxOd5huke78xD+DZTGDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vk4msl.com; spf=pass smtp.mailfrom=vk4msl.com; dkim=pass (4096-bit key) header.d=vk4msl.com header.i=@vk4msl.com header.b=Rgv25FMe; arc=none smtp.client-ip=150.101.176.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vk4msl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vk4msl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=vk4msl.com header.i=@vk4msl.com header.b="Rgv25FMe"
Received: from gapmx.vk4msl.com (gapmx.vk4msl.com [127.0.0.1])
	by gapmx.vk4msl.com (Postfix) with ESMTP id 645DF58D43
	for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 12:20:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=vk4msl.com; h=message-id
	:date:mime-version:from:to:subject:content-type
	:content-transfer-encoding; s=gapmx; bh=IidRQEzaCRVi787i9z3vkETG
	Xf4ZZJstU3ProAKTOz4=; b=Rgv25FMeiOjkbPRrs7Rp76HZrMxLLiSq8O2d5jc6
	EqZggvlRL0mxq68mWdSi5SkHu+XIepoxkoumy1rDo5ub4JP1uNm67PXnvuUN6yFB
	Hx8B8B1yCX0NWwG+UdOBKa2mrAaqba3SwRlkXciSmvitpy1p2KiUeH0kXKP+VwFV
	joFLUL14rUmDCGB25qhlrU1Y8NZAU5t2ReAteVs6rOQap89y5P2ismV8gRN2bVfG
	bSYrvBugBoaFFIIwf7V/1I/8BiKJHYNdK+F7qwUaCwrjMs2D5PqBb7z/rRsXBYGX
	qf8w7geZQoCflkLIwFDlLwerQAlyZcrSO4aj4NYpznATqeUbXdOxhfnv2Db5PR+/
	CQG2lQ6BtAJ33JzXosaehJANyuuCrxN6R5pC4XQs8Tvzkofbh0qD0mWJdKPpNm1N
	8jEDYUqRdTw7x+Z6BUMgUTTyED8FzKGKUDgjmkCwb/2uhmZBAuzx8oyNaKcm92Bt
	v8DSdl6+UhuBT1OLiWu7xdo05gYbSqGqwVteeZJGcik1hFX3X2vJJaY6r6qGnP8P
	UDAmuY1QcmajspxEpnkypYB3Ft45RC52WViI+1rHMMD+l7F9wBaXz3hhSL7DwcQL
	edWiMGeprSc0I1+uhQ9gK19bz5crpFvuG4vw9OoA2NB7SytIEYcrkkCraZ2kP9mw
	o9A=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=vk4msl.com; h=message-id
	:date:mime-version:from:to:subject:content-type
	:content-transfer-encoding; q=dns; s=gapmx; b=Ne8iVUZaiGSW4Ym5xg
	XLMmuPISXK5aznYuhkweY/4IufFQUCAIRrSISONtSr5LH6SXW7qGQQHCcjlaeXCB
	xsuvvhxy2H/FmI3pZsCo2jCUO/BjQZiUAN/zifhmfzfdKUh1Rmaebml30YvSpZ2L
	M1Bk69TRoWii41lgYz6l9L7MJLYv7PJ8EtZ6q6/YhCbBgsXMWrK18rpZctZ41kAr
	D8yK6cbwFDi2BEguB6SlzJWaESW/bfLE+hqg4xeC8vfFE6m267rxDFtVS+dz+1R/
	gx9TT7sLW7V3/Y6sQeepUkco3+eMFQq7l+5lQPYpiar7QfH5srSlPN1l9povBFh8
	mqMf6zJMAiqbQbR6ANjk32CRAbIuRw8iL5TyVZrlSxBKKeL7JgjTJ1v3R+aR5YSY
	HDC2/wU2hMbKv12I6xKF4L2GPvLJ+FbR+l1rLSqKQhsPgxFoJL8FLS4rjrdcLP+e
	zk8d3Uat/xWtNKazmMK2gw1A4mthdOnCwH/ak7t0Kc0WTHCWv0PTwieQe6Ot0lYs
	6yAngnLFHUuvIk0GpD6GNpHeHd/eeV/jraB8LQXTKLF7h6Bt2OJxw8m0wUY4f1hv
	wiphNUjTniAufwbVh9WpfffFS1ZfGzhG+XcIUVBz9qwS45qkXfibDKi8pvNrGpdy
	4190kA8E6NQ5/lMa1ZKBB43so=
Received: from [IPV6:2001:44b8:21ac:7053:47c1:8297:2d98:5f10] (unknown [IPv6:2001:44b8:21ac:7053:47c1:8297:2d98:5f10])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by gapmx.vk4msl.com (Postfix) with ESMTPSA id 26E5758D42
	for <linux-btrfs@vger.kernel.org>; Tue, 02 Jun 2026 12:20:18 +1000 (AEST)
Message-ID: <4a4f5924-d858-462d-9c7e-f6545d9250b2@vk4msl.com>
Date: Tue, 2 Jun 2026 12:20:38 +1000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, en-AU
From: Stuart Longland VK4MSL <me@vk4msl.com>
To: linux-btrfs@vger.kernel.org
Subject: Kernel 7.0.11 circular lock on armv5tejl system booting from mmc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I've been porting the latest mainline kernel to some ARMv5-based 
industrial PCs and getting them running an up-to-date OS, and happened 
to notice this stack trace which seems very reproduce-able.

Hardware platform is Technologic Systems TS-7670
https://docs.embeddedts.com/TS-7670

CPU: Freescale i.MX286 (MXS family) at 454MHz
RAML 120MB DDR2
MMC card: HP 128GB A1 V30 U3 MicroSDXC Card (HFUD128-MX330)
OS: Gentoo Linux ARM (musl libc; I'd consider Debian but they're 
dropping support for `armel` platforms from release 14 onwards and 
AlpineLinux just recently dropped ARMv6 having never supported ARMv5.)

Kernel tree is at
https://github.com/sjlongland/linux-ts7670/tree/ts7670-7.0.11

> [   12.440866] Freeing unused kernel image (initmem) memory: 276K
> [   12.440941] Kernel memory protection not selected by kernel config.
> [   12.441036] Run /sbin/init as init process
> [   12.441087]   with arguments:
> [   12.441123]     /sbin/init
> [   12.441159]   with environment:
> [   12.441191]     HOME=/
> [   12.441226]     TERM=linux
> [   80.823723] fec 800f0000.ethernet end0: renamed from eth0
> [   92.721930] CAN device driver interface
> 
> [   99.966243] ======================================================
> [   99.972489] WARNING: possible circular locking dependency detected
> [   99.978728] 7.0.0-vrt-ts7670+ #1 Not tainted
> [   99.983059] ------------------------------------------------------
> [   99.989290] (udev-worker)/347 is trying to acquire lock:
> [   99.994655] c18f14c4 (&type->i_mutex_dir_key#2){++++}-{3:3}, at: lookup_slow+0x20/0x44
> [  100.002846] 
>                but task is already holding lock:
> [  100.008736] c1a93898 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x150/0xba0
> [  100.018714] 
>                which lock already depends on the new lock.
> 
> [  100.026946] 
>                the existing dependency chain (in reverse order) is:
> [  100.034478] 
>                -> #5 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
> [  100.041780]        __mutex_lock+0xb4/0x1278
> [  100.046068]        mutex_lock_nested+0x1c/0x24
> [  100.050601]        btrfs_run_dev_stats+0x34/0x38c
> [  100.055405]        commit_cowonly_roots+0xac/0x2d8
> [  100.060285]        btrfs_commit_transaction+0x478/0x1780
> [  100.065690]        transaction_kthread+0x160/0x1b8
> [  100.070606]        kthread+0x120/0x158
> [  100.074454]        ret_from_fork+0x14/0x38
> [  100.078646] 
>                -> #4 (&fs_info->reloc_mutex){+.+.}-{3:3}:
> [  100.085437]        __mutex_lock+0xb4/0x1278
> [  100.089719]        mutex_lock_nested+0x1c/0x24
> [  100.094256]        btrfs_commit_transaction+0x3f8/0x1780
> [  100.099657]        transaction_kthread+0x160/0x1b8
> [  100.104555]        kthread+0x120/0x158
> [  100.108397]        ret_from_fork+0x14/0x38
> [  100.112577] 
>                -> #3 (btrfs_trans_unblocked){++++}-{0:0}:
> [  100.119368]        wait_current_trans+0xf0/0x1e0
> [  100.124081]        start_transaction+0x414/0xbac
> [  100.128785]        btrfs_join_transaction+0x20/0x28
> [  100.133752]        btrfs_dirty_inode+0x3c/0xd0
> [  100.138293]        touch_atime+0xf8/0x288
> [  100.142390]        pick_link+0x38c/0x45c
> [  100.146412]        step_into_slowpath+0x154/0x3bc
> [  100.151210]        link_path_walk+0x2e4/0x4e8
> [  100.155665]        path_lookupat+0x44/0x2e4
> [  100.159940]        filename_lookup+0x7c/0xf0
> [  100.164304]        vfs_statx+0x6c/0x144
> [  100.168221]        do_statx+0x70/0xb4
> [  100.171967]        sys_statx+0x54/0xa8
> [  100.175798]        ret_fast_syscall+0x0/0x1c
> [  100.180152] 
>                -> #2 (sb_internal){.+.+}-{0:0}:
> [  100.186071]        start_transaction+0x4bc/0xbac
> [  100.190783]        btrfs_join_transaction+0x20/0x28
> [  100.195746]        btrfs_dirty_inode+0x3c/0xd0
> [  100.200283]        touch_atime+0xf8/0x288
> [  100.204378]        btrfs_file_mmap_prepare+0x64/0x90
> [  100.209444]        __mmap_region+0x4b8/0xb68
> [  100.213820]        do_mmap+0x3a4/0x504
> [  100.217668]        vm_mmap_pgoff+0xb8/0x1a8
> [  100.221945]        elf_load+0x15c/0x250
> [  100.225890]        load_elf_binary+0x2c8/0x149c
> [  100.230515]        bprm_execve+0x2b4/0x5c0
> [  100.234697]        kernel_execve+0x124/0x198
> [  100.239056]        try_to_run_init_process+0xc/0x38
> [  100.244027]        kernel_init+0x90/0x108
> [  100.248142]        ret_from_fork+0x14/0x38
> [  100.252323] 
>                -> #1 (&mm->mmap_lock){++++}-{3:3}:
> [  100.258503]        __might_fault+0x4c/0x74
> [  100.262728]        filldir64+0xac/0x2b0
> [  100.266661]        offset_readdir+0x90/0x210
> [  100.271046]        iterate_dir+0x60/0x138
> [  100.275142]        sys_getdents64+0x68/0x1b0
> [  100.279498]        ret_fast_syscall+0x0/0x1c
> [  100.283852] 
>                -> #0 (&type->i_mutex_dir_key#2){++++}-{3:3}:
> [  100.290924]        __lock_acquire+0x15b4/0x2bf0
> [  100.295560]        lock_acquire.part.0+0xb4/0x264
> [  100.300356]        down_read+0x34/0x200
> [  100.304291]        lookup_slow+0x20/0x44
> [  100.308315]        path_lookupat+0x1a4/0x2e4
> [  100.312679]        filename_lookup+0x7c/0xf0
> [  100.317047]        kern_path+0x38/0x50
> [  100.320891]        device_list_add.constprop.0+0x25c/0xba0
> [  100.326478]        btrfs_scan_one_device+0x114/0x244
> [  100.331539]        btrfs_control_ioctl+0xfc/0x1d0
> [  100.336345]        sys_ioctl+0x538/0xb5c
> [  100.340359]        ret_fast_syscall+0x0/0x1c
> [  100.344712] 
>                other info that might help us debug this:
> 
> [  100.352765] Chain exists of:
>                  &type->i_mutex_dir_key#2 --> &fs_info->reloc_mutex --> &fs_devs->device_list_mutex
> 
> [  100.366111]  Possible unsafe locking scenario:
> 
> [  100.372080]        CPU0                    CPU1
> [  100.376657]        ----                    ----
> [  100.381228]   lock(&fs_devs->device_list_mutex);
> [  100.385948]                                lock(&fs_info->reloc_mutex);
> [  100.392664]                                lock(&fs_devs->device_list_mutex);
> [  100.399898]   rlock(&type->i_mutex_dir_key#2);
> [  100.404464] 
>                 *** DEADLOCK ***
> 
> [  100.410429] 2 locks held by (udev-worker)/347:
> [  100.414930]  #0: c10a6250 (uuid_mutex){+.+.}-{3:3}, at: btrfs_control_ioctl+0xf0/0x1d0
> [  100.423100]  #1: c1a93898 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x150/0xba0
> [  100.433521] 
>                stack backtrace:
> [  100.437938] CPU: 0 UID: 0 PID: 347 Comm: (udev-worker) Not tainted 7.0.0-vrt-ts7670+ #1 VOLUNTARY 
> [  100.446984] Hardware name: Freescale MXS (Device Tree)
> [  100.452179] Call trace: 
> [  100.452228]  unwind_backtrace from show_stack+0x10/0x14
> [  100.460168]  show_stack from dump_stack_lvl+0x48/0x64
> [  100.465355]  dump_stack_lvl from print_circular_bug+0x25c/0x37c
> [  100.471408]  print_circular_bug from check_noncircular+0x194/0x1c8
> [  100.477706]  check_noncircular from __lock_acquire+0x15b4/0x2bf0
> [  100.483829]  __lock_acquire from lock_acquire.part.0+0xb4/0x264
> [  100.489868]  lock_acquire.part.0 from down_read+0x34/0x200
> [  100.495483]  down_read from lookup_slow+0x20/0x44
> [  100.500318]  lookup_slow from path_lookupat+0x1a4/0x2e4
> [  100.505676]  path_lookupat from filename_lookup+0x7c/0xf0
> [  100.511211]  filename_lookup from kern_path+0x38/0x50
> [  100.516398]  kern_path from device_list_add.constprop.0+0x25c/0xba0
> [  100.522805]  device_list_add.constprop.0 from btrfs_scan_one_device+0x114/0x244
> [  100.530233]  btrfs_scan_one_device from btrfs_control_ioctl+0xfc/0x1d0
> [  100.536894]  btrfs_control_ioctl from sys_ioctl+0x538/0xb5c
> [  100.542591]  sys_ioctl from ret_fast_syscall+0x0/0x1c
> [  100.547756] Exception stack(0xc8b0dfa8 to 0xc8b0dff0)
> [  100.552897] dfa0:                   b5c28f90 0000001a 0000001a 90009427 beb414c8 beb41498
> [  100.561162] dfc0: b5c28f90 0000001a 00000000 00000036 beb414c8 0000001a 00000ff7 00000003
> [  100.569412] dfe0: beb40478 beb41370 0044e8a8 b6f7d390
> [  104.226914] BTRFS info: devid 1 device path /dev/root changed to /dev/mmcblk0p6 scanned by (udev-worker) (347)
> [  110.979184] Adding 8388604k swap on /dev/mmcblk0p5.  Priority:-1 extents:1 across:8388604k SS
> [  133.437056] random: crng init done

I'm in the process to swapping one system out to run EXT4 instead of 
BTRFS to see if I get the same issues with that, but I wasn't noticing 
this with kernel 6.0 when I was porting that earlier today.

Other than that, the machine seems to run okay, I've got three here, one 
is running a build of Linux and Gentoo from some years back: I plan to 
update it very soon, but I need to get this sorted out first.

A contributing factor may be the speed of the machine and its block 
device might make race conditions more likely.
-- 
Stuart Longland (aka Redhatter, VK4MSL)

I haven't lost my mind...
   ...it's backed up on a tape somewhere.

