Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52673 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2KNQwL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 11:52:11 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so621780obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 08:52:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A3BCE0.6030604@giantdisaster.de>
References: <CAPsrAuANYejGoos4i-Qnk3cRB5=7tc=Lu_3cnYxw3ytd2MC9Ww@mail.gmail.com>
	<50A3BCE0.6030604@giantdisaster.de>
Date: Wed, 14 Nov 2012 17:52:10 +0100
Message-ID: <CAPsrAuAGM7vFLvKLBVwEN8+n8d=AXjhh7wxhdxB5vjVPnJiToA@mail.gmail.com>
Subject: Re: kernel BUG at btrfs/scrub.c:638 (kernel 3.6.5)
From: Joeri Vanthienen <mail@joerivanthienen.be>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sure Stefan. Thank you! Looking forward to the fix.


On Wed, Nov 14, 2012 at 4:46 PM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On Wed, 14 Nov 2012 15:27:28 +0100, Joeri Vanthienen wrote:
>> Hi,
>>
>> I was testing a new HBA (lsi SAS2008 based) in combination with BTRFS
>> and kernel 3.6.5
>>
>> #mkfs.btrfs -m raid1 -d raid1 /dev/sdf /dev/sdg
>> # btrfs filesystem show
>> Label: none  uuid: fe542409-7346-4ea1-af04-fd1765b6a1a2
>>  Total devices 2 FS bytes used 123.02MB
>>  devid    2 size 298.09GB used 19.01GB path /dev/sdg
>>  devid    1 size 298.09GB used 19.03GB path /dev/sdf
>>
>> Btrfs v0.19+
>>
>> I was simulating a faulty disk by physical removing the disk and
>> connecting again.
>> After reconnecting the disk, the disk appeared again but I get some
>> kernel BUG report in dmesg after running a scrub.
>>
>> [  936.138067] Btrfs loaded
>> [  936.138252] device fsid fe542409-7346-4ea1-af04-fd1765b6a1a2 devid
>> 1 transid 3 /dev/sdf
>> [  936.190574] device fsid fe542409-7346-4ea1-af04-fd1765b6a1a2 devid
>> 2 transid 3 /dev/sdg
>> [  950.208483] device fsid fe542409-7346-4ea1-af04-fd1765b6a1a2 devid
>> 1 transid 4 /dev/sdf
>> [  950.216385] btrfs: disk space caching is enabled
>> [ 1079.577103] mpt2sas0: log_info(0x3003010a): originator(IOP),
>> code(0x03), sub_code(0x010a)
>> [ 1079.577151] mpt2sas0: log_info(0x3003010a): originator(IOP),
>> code(0x03), sub_code(0x010a)
>> [ 1079.577416] mpt2sas0: log_info(0x30030101): originator(IOP),
>> code(0x03), sub_code(0x0101)
>>
>>
>> => after disconnection of one disk
>> [ 1253.444417] sd 8:0:1:0: [sdg] Synchronizing SCSI cache
>> [ 1253.444442] sd 8:0:1:0: [sdg]
>> [ 1253.444444] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>> [ 1253.444588] mpt2sas0: removing handle(0x000a), sas_addr(0x4433221106000000)
>>
>> testsan:/btrfs # btrfs filesystem show
>> Label: none  uuid: fe542409-7346-4ea1-af04-fd1765b6a1a2
>>  Total devices 2 FS bytes used 123.02MB
>>  devid    1 size 298.09GB used 19.03GB path /dev/sdf
>>  *** Some devices missing
>>
>> Btrfs v0.19+
>>
>> => after connecting the same disk again
>> => it seems that the disk is now sdh instead of sdg, could be that
>> I've connected the disk on another port of the HBA
>>
>> # btrfs filesystem show
>> Label: none  uuid: fe542409-7346-4ea1-af04-fd1765b6a1a2
>>  Total devices 2 FS bytes used 123.02MB
>>  devid    2 size 298.09GB used 19.01GB path /dev/sdh
>>  devid    1 size 298.09GB used 19.03GB path /dev/sdf
>>
>> Btrfs v0.19+
>>
>> After running a scrub command I get now the following errors in dmesg:
>>
>> [ 1253.444417] sd 8:0:1:0: [sdg] Synchronizing SCSI cache
>> [ 1253.444442] sd 8:0:1:0: [sdg]
>> [ 1253.444444] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
>> [ 1253.444588] mpt2sas0: removing handle(0x000a), sas_addr(0x4433221106000000)
>> [ 1385.440298] scsi 8:0:2:0: Direct-Access     ATA      WDC
>> WD3200AAJS-0 3E01 PQ: 0 ANSI: 6
>> [ 1385.440307] scsi 8:0:2:0: SATA: handle(0x000a),
>> sas_addr(0x4433221106000000), phy(6), device_name(0x0000000000000000)
>> [ 1385.440310] scsi 8:0:2:0: SATA:
>> enclosure_logical_id(0x500605b0054dc1f0), slot(5)
>> [ 1385.440415] scsi 8:0:2:0: atapi(n), ncq(y), asyn_notify(n),
>> smart(y), fua(y), sw_preserve(y)
>> [ 1385.440421] scsi 8:0:2:0: qdepth(32), tagged(1), simple(0),
>> ordered(0), scsi_level(7), cmd_que(1)
>> [ 1385.440627] sd 8:0:2:0: Attached scsi generic sg0 type 0
>> [ 1385.441276] sd 8:0:2:0: [sdh] 625142448 512-byte logical blocks:
>> (320 GB/298 GiB)
>> [ 1385.444743] sd 8:0:2:0: [sdh] Write Protect is off
>> [ 1385.444747] sd 8:0:2:0: [sdh] Mode Sense: 7f 00 10 08
>> [ 1385.445860] sd 8:0:2:0: [sdh] Write cache: enabled, read cache:
>> enabled, supports DPO and FUA
>> [ 1385.464525]  sdh: unknown partition table
>> [ 1385.472633] sd 8:0:2:0: [sdh] Attached SCSI disk
>> [ 1593.048743] ------------[ cut here ]------------
>> [ 1593.050188] kernel BUG at
>> /usr/src/packages/BUILD/kernel-default-3.6.5/linux-3.6/fs/btrfs/scrub.c:638!
>> [ 1593.051654] invalid opcode: 0000 [#1] SMP
>> [ 1593.052712] Modules linked in: btrfs zlib_deflate libcrc32c
>> af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave
>> dm_mod snd_hda_codec_hdmi iTCO_wdt snd_hda_codec_realtek gpio_ich
>> iTCO_vendor_support sg i2c_i801 acpi_cpufreq mperf coretemp serio_raw
>> pcspkr sr_mod cdrom snd_hda_intel mei lpc_ich mfd_core e1000e
>> kvm_intel kvm microcode snd_hda_codec snd_hwdep snd_pcm snd_timer snd
>> usb_storage tpm_tis tpm hid_generic wmi usbhid soundcore
>> snd_page_alloc tpm_bios edd autofs4 uhci_hcd ehci_hcd usbcore
>> usb_common i915 drm_kms_helper drm i2c_algo_bit video button processor
>> thermal_sys scsi_dh_hp_sw scsi_dh_rdac scsi_dh_alua scsi_dh_emc
>> scsi_dh mpt2sas scsi_transport_sas raid_class ata_generic
>> [ 1593.052712] CPU 2
>> [ 1593.052712] Pid: 2823, comm: btrfs-scrub-1 Not tainted
>> 3.6.5-0-default #1 Acer Veriton M67WS/EQ45M
>> [ 1593.052712] RIP: 0010:[<ffffffffa0526032>]  [<ffffffffa0526032>]
>> scrub_handle_errored_block+0x972/0x980 [btrfs]
>> [ 1593.052712] RSP: 0018:ffff88022d6c1ca0  EFLAGS: 00010246
>> [ 1593.052712] RAX: 0000000000000007 RBX: ffff88022d012800 RCX: 0000000000010000
>> [ 1593.052712] RDX: 0000000000000000 RSI: ffff88022d4a79a0 RDI: ffff88022d012800
>> [ 1593.052712] RBP: ffff88022d4a71f0 R08: ffff88022d6c0000 R09: dead000000100100
>> [ 1593.052712] R10: dead000000200200 R11: 0000000000000001 R12: 0000000000000001
>> [ 1593.052712] R13: 0000000000000000 R14: ffff88022d4a7278 R15: 0000000000000000
>> [ 1593.052712] FS:  0000000000000000(0000) GS:ffff88023bd00000(0000)
>> knlGS:0000000000000000
>> [ 1593.052712] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [ 1593.052712] CR2: 00007f014f8dc000 CR3: 0000000001a0c000 CR4: 00000000000407e0
>> [ 1593.052712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [ 1593.052712] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [ 1593.052712] Process btrfs-scrub-1 (pid: 2823, threadinfo
>> ffff88022d6c0000, task ffff88022517a180)
>> [ 1593.052712] Stack:
>> [ 1593.052712]  0000000000000300 ffff88023bd0e000 0000000300000000
>> 0000000000001000
>> [ 1593.052712]  ffff88023bd13140 ffff88022e09f000 000000010004ee83
>> ffff88022d012800
>> [ 1593.052712]  ffff88022517a620 ffff8802253e8000 0000000000010000
>> 0000000000000000
>> [ 1593.052712] Call Trace:
>> [ 1593.052712]  [<ffffffffa05265bc>] scrub_bio_end_io_worker+0x57c/0x720 [btrfs]
>> [ 1593.052712]  [<ffffffffa0502f83>] worker_loop+0x153/0x540 [btrfs]
>> [ 1593.052712]  [<ffffffff81065645>] kthread+0x85/0x90
>> [ 1593.052712]  [<ffffffff81568034>] kernel_thread_helper+0x4/0x10
>> [ 1593.052712] Code: c7 e4 35 54 a0 e8 9f d8 ff ff e9 7b ff ff ff 48
>> 8b 74 24 38 48 c7 c7 cb 35 54 a0 e8 89 d8 ff ff e9 0d fd ff ff 0f 0b
>> 0f 0b 0f 0b <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 56 49
>> 89 fe
>> [ 1593.052712] RIP  [<ffffffffa0526032>]
>> scrub_handle_errored_block+0x972/0x980 [btrfs]
>> [ 1593.052712]  RSP <ffff88022d6c1ca0>
>> [ 1593.109840] ---[ end trace 6f23598a7da7ea0c ]---
>> [ 1983.558609] mpt2sas0: log_info(0x3003010a): originator(IOP),
>> code(0x03), sub_code(0x010a)
>> [ 1983.560570] mpt2sas0: log_info(0x3003010a): originator(IOP),
>> code(0x03), sub_code(0x010a)
>> [ 1983.562707] mpt2sas0: log_info(0x30030101): originator(IOP),
>> code(0x03), sub_code(0x0101)
>>
>> Scrub keeps running...
>> # btrfs scrub status /btrfs
>> scrub status for fe542409-7346-4ea1-af04-fd1765b6a1a2
>>  scrub started at Wed Nov 14 15:07:33 2012, running for 840 seconds
>>  total bytes scrubbed: 0.00 with 0 errors
>>
>> What is going on ?
>
>
> This issue is reproducible here with v3.6.5 and with the latest 3.7-rc as well. I'll prepare a fix for btrfs-next.
>
> Thank you for finding and reporting this issue! I'll add a Reported-by tag with your name and address if you don't mind?
>
