Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3GHGqT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 02:46:19 -0400
Message-ID: <51DA6039.9080107@hiperscan.com>
Date: Mon, 08 Jul 2013 08:46:17 +0200
From: =?ISO-8859-15?Q?Franziska_N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs crashes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

we are using a btrfs RAID 1 with four 2TB hard drives on a Debian 7.1 
(Kernel 3.9.6).

After about one year of working, there was an error in messages log and 
the filesystem was mounted read-only.

After that I restarted the system but that doesn't fix the bug. The 
btrfs-filesystem couldn't be mounted.

I attach four logs:

-> when the error occured
-> after the error occured
-> when rebooting the system
-> when I tried ti mount manually

Before I rebuilt the filesystem (formatting everything and creating a 
new btrfs-pool) I made a btrfs-image. I can provide it to you.



messages when the error occured:
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.567383] parent transid 
verify failed on 1750188515328 wanted 475562 found 475559
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614152] parent transid 
verify failed on 1750188515328 wanted 475562 found 475559
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614165] ------------[ cut 
here ]------------
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614186] WARNING: at 
fs/btrfs/super.c:255 __btrfs_abort_transaction+0x4c/0xcf [btrfs]()
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614187] Hardware name: 
System Product Name
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614190] Modules linked in: 
vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) xts gf128mul tun pc
i_stub cpufreq_powersave cpufreq_userspace cpufreq_stats 
cpufreq_conservative binfmt_misc fuse nfsd auth_rpcgss nfs_acl nfs lockd 
fscache su
nrpc ext2 dm_crypt loop firewire_sbp2 snd_hda_codec_hdmi radeon 
snd_hda_intel coretemp snd_hda_codec kvm_intel kvm ttm drm_kms_helper drm i7
core_edac ehci_pci i2c_algo_bit snd_hwdep iTCO_wdt iTCO_vendor_support 
lpc_ich mfd_core snd_pcm edac_core asus_atk0110 acpi_cpufreq evdev mp
erf i2c_i801 psmouse i2c_core pcspkr mxm_wmi serio_raw processor 
snd_page_alloc snd_timer button wmi thermal_sys snd soundcore microcode ext
4 crc16 jbd2 mbcache btrfs xor zlib_deflate raid6_pq libcrc32c dm_mod 
raid1 md_mod sd_mod crc_t10dif sg hid_generic usbhid hid firewire_ohci
  crc32c_intel firewire_core crc_itu_t sata_sil r8169 mii ahci libahci 
libata uhci_hcd ehci_hcd scsi_mod xhci_hcd usbcore usb_common [last un
loaded: vboxdrv]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614245] Pid: 2235, comm: 
btrfs-transacti Tainted: G           O 3.9.6 #1
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614247] Call Trace:
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614253] 
[<ffffffff8103d510>] ? warn_slowpath_common+0x76/0x8c
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614257] 
[<ffffffff8103d5be>] ? warn_slowpath_fmt+0x45/0x4a
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614268] 
[<ffffffffa01a8777>] ? __btrfs_abort_transaction+0x4c/0xcf [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614281] 
[<ffffffffa01bb32e>] ? btrfs_run_delayed_refs+0x237/0x394 [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614296] 
[<ffffffffa01c82ff>] ? btrfs_commit_transaction+0xaf/0x87a [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614310] 
[<ffffffffa01c7365>] ? join_transaction.isra.29+0x314/0x31e [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614314] 
[<ffffffff8105866b>] ? abort_exclusive_wait+0x79/0x79
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614329] 
[<ffffffffa01c92cc>] ? start_transaction+0x325/0x44d [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614332] 
[<ffffffff81049415>] ? ftrace_raw_event_timer_class+0x8e/0x8e
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614336] 
[<ffffffff8106144c>] ? should_resched+0x5/0x23
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614349] 
[<ffffffffa01c1d95>] ? transaction_kthread+0xe0/0x183 [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614363] 
[<ffffffffa01c1cb5>] ? try_to_freeze+0x31/0x31 [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614377] 
[<ffffffffa01c1cb5>] ? try_to_freeze+0x31/0x31 [btrfs]
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614380] 
[<ffffffff81057da4>] ? kthread+0x81/0x89
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614383] 
[<ffffffff81057d23>] ? __kthread_parkme+0x5d/0x5d
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614386] 
[<ffffffff8138b23c>] ? ret_from_fork+0x7c/0xb0
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614389] 
[<ffffffff81057d23>] ? __kthread_parkme+0x5d/0x5d
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614391] ---[ end trace 
c45c78ec20af1ebf ]---
Jun 25 17:02:25 hsad-srv-03 kernel: [870100.614395] btrfs is forced readonly
---------------------------------------------------------------------------------------
messages after the error before reboot:
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061426] Pid: 62, comm: 
kswapd0 Tainted: G        W  O 3.9.6 #1
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061427] Call Trace:
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061428] 
[<ffffffff8103d510>] ? warn_slowpath_common+0x76/0x8c
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061439] 
[<ffffffffa01d51ab>] ? btrfs_destroy_inode+0x5f/0x252 [btrfs]
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061441] 
[<ffffffff81119e30>] ? dispose_list+0x27/0x31
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061443] 
[<ffffffff8111aefe>] ? prune_icache_sb+0x2ab/0x2c6
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061445] 
[<ffffffff81109ed4>] ? prune_super+0xc3/0x12d
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061447] 
[<ffffffff810d0214>] ? shrink_slab+0x19b/0x287
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061449] 
[<ffffffff810d2a90>] ? kswapd+0x512/0x6fd
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061452] 
[<ffffffff810d257e>] ? try_to_free_pages+0x127/0x127
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061454] 
[<ffffffff810d257e>] ? try_to_free_pages+0x127/0x127
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061455] 
[<ffffffff81057da4>] ? kthread+0x81/0x89
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061458] 
[<ffffffff81057d23>] ? __kthread_parkme+0x5d/0x5d
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061459] 
[<ffffffff8138b23c>] ? ret_from_fork+0x7c/0xb0
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061461] 
[<ffffffff81057d23>] ? __kthread_parkme+0x5d/0x5d
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061463] ---[ end trace 
c45c78ec20af24c9 ]---
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061463] ------------[ cut 
here ]------------
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061473] WARNING: at 
fs/btrfs/inode.c:7924 btrfs_destroy_inode+0x76/0x252 [btrfs]()
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061474] Hardware name: 
System Product Name
Jun 25 23:02:13 hsad-srv-03 kernel: [891678.061475] Modules linked in: 
vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) xts gf128mul tun 
pci_stub cpufreq_powersave cpufreq_userspace cpufreq_stats 
cpufreq_conservative binfmt_misc fuse nfsd auth_rpcgss nfs_acl nfs lockd 
fscache sunrpc ext2 dm_crypt loop firewire_sbp2 snd_hda_codec_hdmi 
radeon snd_hda_intel coretemp snd_hda_codec kvm_intel kvm ttm 
drm_kms_helper drm i7core_edac ehci_pci i2c_algo_bit snd_hwdep iTCO_wdt 
iTCO_vendor_support lpc_ich mfd_core snd_pcm edac_core asus_atk0110 
acpi_cpufreq evdev mperf i2c_i801 psmouse i2c_core pcspkr mxm_wmi 
serio_raw processor snd_page_alloc snd_timer button wmi thermal_sys snd 
soundcore microcode ext4 crc16 jbd2 mbcache btrfs xor zlib_deflate 
raid6_pq libcrc32c dm_mod raid1 md_mod sd_mod crc_t10dif sg hid_generic 
usbhid hid firewire_ohci crc32c_intel firewire_core crc_itu_t sata_sil 
r8169 mii ahci libahci libata uhci_hcd ehci_hcd scsi_mod xhci_hcd 
usbcore usb_common [last unloaded: vboxdrv]
------------------------------------------------------------------------------------------------------------------------------
messages at reboot:
Jun 26 07:14:41 hsad-srv-03 kernel: [   13.735382] btrfs: use lzo 
compression
Jun 26 07:14:41 hsad-srv-03 kernel: [   13.735386] btrfs: allowing 
degraded mounts
Jun 26 07:14:41 hsad-srv-03 kernel: [   13.735389] btrfs: disk space 
caching is enabled
Jun 26 07:14:41 hsad-srv-03 kernel: [   34.700453] parent transid verify 
failed on 1750188515328 wanted 475562 found 475559
Jun 26 07:14:41 hsad-srv-03 kernel: [   35.095814] parent transid verify 
failed on 1750188515328 wanted 475562 found 475559
Jun 26 07:14:41 hsad-srv-03 kernel: [   35.124511] btrfs: open_ctree failed
Jun 26 07:14:41 hsad-srv-03 kernel: [   35.133282] device fsid 
526356ed-9708-40c2-83a1-82f3dbc8b72f devid 2 transid 476583 /dev/sde
--------------------------------------------------------------------------------------------------------------------------------
when I want to mount the btrfs: mount: wrong fs type, bad option, bad 
superblock on /dev/sde,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

best regards
Franziska
