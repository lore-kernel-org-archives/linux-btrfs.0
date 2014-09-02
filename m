Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from whm03.asteroidpc.com ([204.191.218.7]:50008 "EHLO
	whm03.asteroidpc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaIBBYA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 21:24:00 -0400
Received: from home.nathanshearer.ca ([207.228.103.143]:39253 helo=[10.64.0.30])
	by whm03.asteroidpc.com with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <mail@nathanshearer.ca>)
	id 1XObji-0005zJ-Bm
	for linux-btrfs@vger.kernel.org; Mon, 01 Sep 2014 18:14:14 -0600
Message-ID: <54050BD4.2060804@nathanshearer.ca>
Date: Mon, 01 Sep 2014 18:14:12 -0600
From: Nathan Shearer <mail@nathanshearer.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Kernel Bug while copying my data off btrfs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a multi-drive raid6 setup and failed and removed 2 drives. I tried
to start a scrub and rebalance to recalculate the parity and something
happened where I could not write to the filesystem. Any programs that
tried to interact with the filesystem would stall forever and bring the
server load up to ~40000.

Anyways, now I am mounting the entire filesystem in degraded and
read-only mode and trying to get my data out, but I keep hitting the
same kernel bug:

    Sep  1 17:37:29 storage01 kernel: [ 7781.048714] cp (3796) used
    greatest stack depth: 2584 bytes left
    Sep  1 17:42:26 storage01 kernel: [ 8078.141546] BTRFS info (device
    sdo1): csum failed ino 723851 extent 148790317056 csum 3580889741
    wanted 848104669 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.513407] BTRFS info (device
    sdo1): csum failed ino 723851 extent 4171022393344 csum 2590340982
    wanted 848104669 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.513786] BTRFS info (device
    sdo1): csum failed ino 723851 extent 148790312960 csum 2615865265
    wanted 848104669 mirror 1
    Sep  1 17:42:26 storage01 kernel: [ 8078.531244] BTRFS info (device
    sdo1): csum failed ino 723851 extent 4171022467072 csum 653240077
    wanted 1839153580 mirror 2
    Sep  1 17:42:26 storage01 kernel: [ 8078.532972] BTRFS info (device
    sdo1): csum failed ino 723851 extent 4171022467072 csum 3962186301
    wanted 848104669 mirror 3
    Sep  1 17:42:26 storage01 kernel: [ 8078.556560] BTRFS info (device
    sdo1): csum failed ino 723901 extent 148790509568 csum 3471705361
    wanted 3207739402 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.558995] BTRFS info (device
    sdo1): csum failed ino 723901 extent 4171026595840 csum 623201911
    wanted 3385769702 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.559034] BTRFS info (device
    sdo1): csum failed ino 723901 extent 4171026640896 csum 3647762664
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.561634] BTRFS info (device
    sdo1): csum failed ino 723901 extent 4171026640896 csum 2832653656
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.561643] BTRFS info (device
    sdo1): csum failed ino 723901 extent 4171026640896 csum 3839010108
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.562048] BTRFS info (device
    sdo1): csum failed ino 723901 extent 148790640640 csum 3233112747
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.562553] BTRFS info (device
    sdo1): csum failed ino 723901 extent 148790640640 csum 2236110192
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.562565] BTRFS info (device
    sdo1): csum failed ino 723901 extent 148790603776 csum 1364949859
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.562572] BTRFS info (device
    sdo1): csum failed ino 723901 extent 148790640640 csum 3213213740
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.562581] ------------[ cut
    here ]------------
    Sep  1 17:42:26 storage01 kernel: [ 8078.562588] kernel BUG at
    fs/btrfs/extent_io.c:2291!
    Sep  1 17:42:26 storage01 kernel: [ 8078.562592] invalid opcode:
    0000 [#1] SMP
    Sep  1 17:42:26 storage01 kernel: [ 8078.562599] Modules linked in:
    nfsd ipv6 it87 hwmon_vid eeepc_wmi asus_wmi rfkill video mxm_wmi
    edac_core kvm_amd kvm k10temp serio_raw pcspkr joydev sp5100_tco
    i2c_piix4 radeon cfbfillrect cfbimgblt cfbcopyarea fbcon ttm
    tpm_infineon bitblit softcursor font tileblit drm_kms_helper drm
    tpm_tis tpm snd_hda_codec_realtek backlight fb fbdev
    snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_codec
    snd_hwdep snd_pcm snd_timer snd soundcore shpchp wmi acpi_cpufreq
    processor
    Sep  1 17:42:26 storage01 kernel: [ 8078.562693] CPU: 1 PID: 3821
    Comm: btrfs-endio-3 Not tainted 3.14.17 #1
    Sep  1 17:42:26 storage01 kernel: [ 8078.562698] Hardware name: To
    be filled by O.E.M. To be filled by O.E.M./M5A99X EVO R2.0, BIOS
    1503 01/16/2013
    Sep  1 17:42:26 storage01 kernel: [ 8078.562704] task:
    ffff88013ab01160 ti: ffff88008ba68000 task.ti: ffff88008ba68000
    Sep  1 17:42:26 storage01 kernel: [ 8078.562709] RIP:
    0010:[<ffffffff813021e3>]  [<ffffffff813021e3>]
    end_bio_extent_readpage+0x943/0x950
    Sep  1 17:42:26 storage01 kernel: [ 8078.562719] RSP:
    0000:ffff88008ba69cd8  EFLAGS: 00010202
    Sep  1 17:42:26 storage01 kernel: [ 8078.562723] RAX:
    0000000000000003 RBX: ffffea00010370c0 RCX: ffffffffffffffff
    Sep  1 17:42:26 storage01 kernel: [ 8078.562728] RDX:
    000000002a638640 RSI: 0000000000000001 RDI: ffff8800b37376b8
    Sep  1 17:42:26 storage01 kernel: [ 8078.562733] RBP:
    ffff88008ba69d98 R08: 000003c995c00000 R09: 000003cc19c00000
    Sep  1 17:42:26 storage01 kernel: [ 8078.562759] R10:
    ffffea0004eac940 R11: ffffffff812dc061 R12: ffff880052a33d00
    Sep  1 17:42:26 storage01 kernel: [ 8078.562784] R13:
    ffff88012a6385e0 R14: 0000000000289000 R15: 0000000000000000
    Sep  1 17:42:26 storage01 kernel: [ 8078.562810] FS: 
    00007f4796229700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
    Sep  1 17:42:26 storage01 kernel: [ 8078.562890] CS:  0010 DS: 0000
    ES: 0000 CR0: 000000008005003b
    Sep  1 17:42:26 storage01 kernel: [ 8078.562915] CR2:
    00007f4796234000 CR3: 00000000b2e1a000 CR4: 00000000000007e0
    Sep  1 17:42:26 storage01 kernel: [ 8078.562941] Stack:
    Sep  1 17:42:26 storage01 kernel: [ 8078.562965]  ffff88008ba69d78
    ffffea0004eac940 ffff88008eb13720 ffff88008eb13788
    Sep  1 17:42:26 storage01 kernel: [ 8078.563017]  ffff88008ba69da8
    ffff88008eb138d8 ffff88012a638500 ffff88008eb13760
    Sep  1 17:42:26 storage01 kernel: [ 8078.563069]  000000002a638640
    0000000000000000 0000000000289fff 0000000000000000
    Sep  1 17:42:26 storage01 kernel: [ 8078.563121] Call Trace:
    Sep  1 17:42:26 storage01 kernel: [ 8078.563148] 
    [<ffffffff811b4523>] bio_endio+0x53/0x90
    Sep  1 17:42:26 storage01 kernel: [ 8078.563175] 
    [<ffffffff8116cf1d>] ? kfree+0xfd/0x140
    Sep  1 17:42:26 storage01 kernel: [ 8078.563200] 
    [<ffffffff811b456d>] bio_endio_nodec+0xd/0x10
    Sep  1 17:42:26 storage01 kernel: [ 8078.563227] 
    [<ffffffff812dc06c>] end_workqueue_fn+0x3c/0x50
    Sep  1 17:42:26 storage01 kernel: [ 8078.563254] 
    [<ffffffff81312257>] worker_loop+0x157/0x560
    Sep  1 17:42:26 storage01 kernel: [ 8078.563280] 
    [<ffffffff81312100>] ? btrfs_queue_worker+0x300/0x300
    Sep  1 17:42:26 storage01 kernel: [ 8078.563307] 
    [<ffffffff81082ff4>] kthread+0xc4/0xe0
    Sep  1 17:42:26 storage01 kernel: [ 8078.563333] 
    [<ffffffff81010000>] ? ftrace_raw_event_xen_mmu_alloc_ptpage+0x130/0x180
    Sep  1 17:42:26 storage01 kernel: [ 8078.563972] 
    [<ffffffff81082f30>] ? flush_kthread_worker+0x70/0x70
    Sep  1 17:42:26 storage01 kernel: [ 8078.563999] 
    [<ffffffff819021cc>] ret_from_fork+0x7c/0xb0
    Sep  1 17:42:26 storage01 kernel: [ 8078.564025] 
    [<ffffffff81082f30>] ? flush_kthread_worker+0x70/0x70
    Sep  1 17:42:26 storage01 kernel: [ 8078.564050] Code: 54 24 28 e9
    a6 fc ff ff 48 8b bd 68 ff ff ff 4c 89 e6 e8 71 e2 ff ff 48 8b 45 a8
    48 83 c0 01 48 89 85 60 ff ff ff e9 4d f8 ff ff <0f> 0b 66 66 2e 0f
    1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56
    Sep  1 17:42:26 storage01 kernel: [ 8078.564251] RIP 
    [<ffffffff813021e3>] end_bio_extent_readpage+0x943/0x950
    Sep  1 17:42:26 storage01 kernel: [ 8078.564279]  RSP <ffff88008ba69cd8>
    Sep  1 17:42:26 storage01 kernel: [ 8078.564527] BTRFS info (device
    sdo1): csum failed ino 723901 extent 4171026640896 csum 28745215
    wanted 3641694186 mirror 0
    Sep  1 17:42:26 storage01 kernel: [ 8078.564569] ---[ end trace
    5591f400f3ecd70a ]---

My kernel version is 3.14.17 and I am currently compiling 3.16.1 to see
if things are more stable there. What can I try next to get my data out?
