Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48365 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbcDNIpg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 04:45:36 -0400
Subject: Re: [PATCH v4 00/13] Introduce device state 'failed', spare device
 and auto replace
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
 <20160413212143.GA28202@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <570F5897.6090701@oracle.com>
Date: Thu, 14 Apr 2016 16:45:11 +0800
MIME-Version: 1.0
In-Reply-To: <20160413212143.GA28202@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




Thanks for the report ! more below..


On 04/14/2016 05:21 AM, Yauhen Kharuzhy wrote:
> On Tue, Apr 12, 2016 at 10:15:50PM +0800, Anand Jain wrote:
>> Thanks for various comments, tests and feedback.
>
> Hmm... I broke it :)
>
> I get kernel oops after few cycles of drive removing-insertion-replacing.
>
> My steps to reproduce:
> 1) create RAID (I used RAID6)
> 2) remove drive (i tested /sys interface for this and VBox storage
> management – reproduced with both bethods). Write & sync fs to detect
> falure.
> 3) insert drive again
> 4) wipe it
> 5) replace missing device (reproduced with user-initiated replace and
> autoreplace)
> 6) repeat steps 2-3
>
> At reboot, kernel oopses (see below). Sometimes more than one repeat of
> steps 2-5 needed (I am still working to localize this now).
>
> Commands from my last session:
>
> root@grack12:~# btrfs fi show
> Label: 'test'  uuid: 833fef31-5536-411c-8f58-53b527569fa5
>          Total devices 4 FS bytes used 768.00KiB
>          devid    1 size 8.00GiB used 1.41GiB path /dev/sdc
>          devid    2 size 8.00GiB used 1.41GiB path /dev/sdd
>          devid    3 size 8.00GiB used 1.41GiB path /dev/sde
>          devid    5 size 8.00GiB used 1.12GiB path /dev/sdg
>
> Global spare
>
> root@test:~# ls -l /sys/block/sdg
> lrwxrwxrwx 1 root root 0 Apr  8 20:03 /sys/block/sdg -> ../devices/pci0000:00/0000:00:1f.2/ata7/host6/target6:0:0/6:0:0:0/block/sdg
> root@test:~# echo 1 > /sys/class/scsi_device/6\:0\:0\:0/device/delete
> root@test:~# touch /media/833fef31-5536-411c-8f58-53b527569fa5/ && btrfs fi sync /media/833fef31-5536-411c-8f58-53b527569fa5/
> FSSync '/media/833fef31-5536-411c-8f58-53b527569fa5/'
> root@test:~# echo 0 0 0 > /sys/class/scsi_host/host6/scan
> root@test:~# wipefs -a /dev/sdg
> 8 bytes were erased at offset 0x10040 (btrfs)
> they were: 5f 42 48 52 66 53 5f 4d
> root@test:~# btrfs replace start 5 /dev/sdg /media/833fef31-5536-411c-8f58-53b527569fa5/
> root@test:~# echo 1 > /sys/class/scsi_device/6\:0\:0\:0/device/delete
> root@test:~# echo 0 0 0 > /sys/class/scsi_host/host6/scan
> root@test:~# echo 1 > /sys/class/scsi_device/6\:0\:0\:0/device/delete

  You may use simpler devmgt tool, https://github.com/asj/devmgt

> root@test:~# touch /media/833fef31-5536-411c-8f58-53b527569fa5/ && btrfs fi sync /media/833fef31-5536-411c-8f58-53b527569fa5/
> FSSync '/media/833fef31-5536-411c-8f58-53b527569fa5/'
> root@test:~# echo 0 0 0 > /sys/class/scsi_host/host6/scan
> root@test:~# wipefs -a /dev/sdg
> 8 bytes were erased at offset 0x10040 (btrfs)
> they were: 5f 42 48 52 66 53 5f 4d
> root@test:~# btrfs replace start 5 /dev/sdg /media/833fef31-5536-411c-8f58-53b527569fa5/
> root@test:~# echo 1 > /sys/class/scsi_device/6\:0\:0\:0/device/delete
> root@test:~# touch /media/833fef31-5536-411c-8f58-53b527569fa5/ && btrfs fi sync /media/833fef31-5536-411c-8f58-53b527569fa5/
> FSSync '/media/833fef31-5536-411c-8f58-53b527569fa5/'
> root@test:~# echo 0 0 0 > /sys/class/scsi_host/host6/scan
> root@test:~# wipefs -a /dev/sdg
> 8 bytes were erased at offset 0x10040 (btrfs)
> they were: 5f 42 48 52 66 53 5f 4d
> root@test:~# btrfs replace start 5 /dev/sdg /media/833fef31-5536-411c-8f58-53b527569fa5/
> root@test:~# reboot
>
> Oops itself:
>
> [  349.559019] BTRFS info (device sdd): dev_replace from <missing disk> (devid 5) to /dev/sdg started
> [  349.647966] BTRFS info (device sdd): dev_replace from <missing disk> (devid 5) to /dev/sdg finished
> [  373.701691] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  373.731698] Modules linked in: cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservative softdog nfsd a
> uth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc ipmi_devintf ipmi_msghandler iosf_mbi crct10dif_pclmul c
> rc32_pclmul sha256_ssse3 sha256_generic snd_pcm snd_timer iTCO_wdt hmac drbg iTCO_vendor_support ansi_cprng snd soundco
> re aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse evdev serio_raw pcspkr acpi_cpufreq 8250_
> fintek lpc_ich video ac battery parport_pc tpm_tis tpm mfd_core parport button processor rng_core i2c_piix4 btrfs xor r
> aid6_pq dm_mod raid1 md_mod sg sd_mod sr_mod cdrom ata_generic ahci libahci ata_piix libata crc32c_intel scsi_mod pcnet
> 32 mii
> [  373.933548] CPU: 0 PID: 3955 Comm: umount Not tainted 4.4.5-scst31x-debug+ #33
> [  373.941730] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  373.945337] task: ffff88005b2fe080 ti: ffff880056cbc000 task.ti: ffff880056cbc000
> [  373.951991] RIP: 0010:[<ffffffff811a1069>]  [<ffffffff811a1069>] __filemap_fdatawrite_range+0x29/0xf0


  You are failing the replace-target, presumably when the replace is
  still running, however note that this patch-set does not fail the
  replace-target for errors (as of now I have no idea how to do that
  without leading to a messy situation), and so it would follow the
  original code as without this patch.
  Next, originally with-out this patch-set we won't close any device
  for errors. So when you delete the device at the block-layer and
  re-attach (scan) most probably you are having a newer device path
  to the block device. (which kind of defeats the idea of testing
  an intermittently disappearing device), so I doubt, if the test
  case is reliable,  and above panic is btrfs related and if its
  this patch-set related.



HTH.

Thanks, Anand


> [  373.954135] RSP: 0018:ffff880056cbfd50  EFLAGS: 00010286
> [  373.972201] RAX: 0000000000000000 RBX: ffff880056cbfd50 RCX: 0000000000000000
> [  374.003989] RDX: 7fffffffffffffff RSI: 0000000000000000 RDI: ffff880056cbfdb0
> [  374.044001] RBP: ffff880056cbfdc8 R08: 0000000000000000 R09: 0000000000000002
> [  374.099584] R10: ffffffff81d1b880 R11: ffffffff81d1b840 R12: 00441f0f0000441f
> [  374.113566] R13: ffff88005b2fe080 R14: 0000000000000000 R15: ffff88005b2fe080
> [  374.157600] FS:  00007f9281eea7e0(0000) GS:ffff880066600000(0000) knlGS:0000000000000000
> [  374.164870] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  374.184379] CR2: 0000000001277048 CR3: 0000000060324000 CR4: 00000000000406f0
> [  374.190320] Stack:
> [  374.201539]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [  374.245946]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [  374.286073]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [  374.313913] Call Trace:
> [  374.329665]  [<ffffffff811a11ec>] filemap_flush+0x1c/0x20
> [  374.357488]  [<ffffffff812619d6>] __sync_blockdev+0x26/0x30
> [  374.389452]  [<ffffffff8125814e>] sync_filesystem+0x4e/0xa0
> [  374.425568]  [<ffffffff81220867>] generic_shutdown_super+0x27/0xf0
> [  374.457622]  [<ffffffff81220ba2>] kill_anon_super+0x12/0x20
> [  374.489572]  [<ffffffffa018ea88>] btrfs_kill_super+0x18/0x120 [btrfs]
> [  374.529552]  [<ffffffff81220e1e>] deactivate_locked_super+0x3e/0x70
> [  374.561196]  [<ffffffff8122126c>] deactivate_super+0x5c/0x60
> [  374.602015]  [<ffffffff8124182f>] cleanup_mnt+0x3f/0x90
> [  374.632955]  [<ffffffff812418c2>] __cleanup_mnt+0x12/0x20
> [  374.652292]  [<ffffffff810a5533>] task_work_run+0x73/0xa0
> [  374.662654]  [<ffffffff810032ac>] exit_to_usermode_loop+0xcc/0xd0
> [  374.672858]  [<ffffffff81003e0c>] syscall_return_slowpath+0xcc/0xe0
> [  374.702077]  [<ffffffff816379e2>] int_ret_from_sys_call+0x25/0x9f
> [  374.721467] Code: ff 90 0f 1f 44 00 00 55 31 c0 41 89 c8 b9 0c 00 00 00 48 89 e5 41 55 41 54 53 48 8d 5d 88 49 89 fc
>   48 89 df 48 83 ec 60 f3 48 ab <49> 8b 3c 24 48 b8 ff ff ff ff ff ff ff 7f 48 89 55 a0 48 89 45
> [  374.853615] RIP  [<ffffffff811a1069>] __filemap_fdatawrite_range+0x29/0xf0
> [  374.909672]  RSP <ffff880056cbfd50>
> [  374.937941] ---[ end trace 2bbc2fd699f402ff ]---
>
>
