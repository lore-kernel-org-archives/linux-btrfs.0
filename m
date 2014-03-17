Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55480 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaCQQNJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 12:13:09 -0400
Date: Mon, 17 Mar 2014 09:13:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
Message-ID: <20140317161307.GJ6143@merlins.org>
References: <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com> <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com> <20140316231729.GA29149@merlins.org> <85AE52FE-5191-49AF-98A9-380F224A5DA1@colorremedies.com> <20140317005145.GZ16946@merlins.org> <99A46301-9C0E-43F0-8415-E23B86FDB5E2@colorremedies.com> <20140317011752.GV6143@merlins.org> <3592E609-7145-4F1A-8B16-EEF3C736D191@colorremedies.com> <20140317034451.GW6143@merlins.org> <B593C5F2-5CE0-428C-97FB-A75AB0B11254@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B593C5F2-5CE0-428C-97FB-A75AB0B11254@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 16, 2014 at 11:12:43PM -0600, Chris Murphy wrote:
> 
> On Mar 16, 2014, at 9:44 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > On Sun, Mar 16, 2014 at 08:56:35PM -0600, Chris Murphy wrote:
> > 
> >>> If I add a device, isn't it going to grow my raid to make it bigger instead
> >>> of trying to replace the bad device?
> >> 
> >> Yes if it's successful. No if it fails which is the problem I'm having.
> > 
> > That's where I don't follow you.
> > You just agreed that it will grow my raid.
> > So right now it's 4.5TB with 10 drives, if I add one drive, it will grow to
> > 5TB with 11 drives.
> > How does that help?
> 
> If you swap the faulty drive for a good drive, I'm thinking then you'll be able to device delete the bad device, which ought to be "missing" at that point; or if that fails you should be able to do a balance, and then be able to device delete the faulty drive.
> 
> The problem I'm having is that when I detach one device out of a 3 device raid5, btrfs fi show doesn't list it as missing. It's listed without the /dev/sdd designation it had when attached, but now it's just blank.

Ok, I tried unmounting and remounting degraded this morning:

polgara:~# mount -v -t btrfs -o compress=zlib,space_cache,noatime,degraded LABEL=backupcopy /mnt/btrfs_backupcopy
Mar 17 08:57:35 polgara kernel: [123824.344085] BTRFS: device label backupcopy devid 9 transid 3837 /dev/mapper/crypt_sdk1
Mar 17 08:57:35 polgara kernel: [123824.454641] BTRFS info (device dm-9): allowing degraded mounts
Mar 17 08:57:35 polgara kernel: [123824.454978] BTRFS info (device dm-9): disk space caching is enabled
Mar 17 08:57:35 polgara kernel: [123824.497437] BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 3888, rd 321927975, flush 0, corrupt 0, gen
0
/dev/mapper/crypt_sdk1 on /mnt/btrfs_backupcopy type btrfs (rw,noatime,compress=zlib,space_cache,degraded)

What's confusing is that mounting in degraded mode shows all devices:
polgara:~# btrfs fi show
Label: backupcopy  uuid: 7d8e1197-69e4-40d8-8d86-278d275af896
        Total devices 10 FS bytes used 376.27GiB
        devid    1 size 465.76GiB used 42.42GiB path /dev/dm-0
        devid    2 size 465.76GiB used 42.40GiB path /dev/dm-1
        devid    3 size 465.75GiB used 42.40GiB path /dev/mapper/crypt_sde1 << this is missing
        devid    4 size 465.76GiB used 42.40GiB path /dev/dm-3
        devid    5 size 465.76GiB used 42.40GiB path /dev/dm-4
        devid    6 size 465.76GiB used 42.40GiB path /dev/dm-5
        devid    7 size 465.76GiB used 42.40GiB path /dev/dm-6
        devid    8 size 465.76GiB used 42.40GiB path /dev/mapper/crypt_sdj1
        devid    9 size 465.76GiB used 42.40GiB path /dev/mapper/crypt_sdk1
        devid    10 size 465.76GiB used 42.40GiB path /dev/dm-8

Ok, so mount in degraded mode works.

Adding a new device failed though:
polgara:~# btrfs device add /dev/mapper/crypt_sdm1 /mnt/btrfs_backupcopy
BTRFS: bad tree block start 852309604880683448 156237824
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1963 at fs/btrfs/super.c:257 __btrfs_abort_transaction+0x50/0x100()
BTRFS: Transaction aborted (error -5)
Modules linked in: xts gf128mul ipt_MASQUERADE ipt_REJECT xt_tcpudp xt_conntrack xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats ppdev rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse dm_crypt dm_mod configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs btusb bluetooth 6lowpan_iphc rfkill usbkbd usbmouse joydev hid_generic usbhid hid iTCO_wdt iTCO_vendor_support gpio_ich coretemp kvm_intel kvm microcode snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec pcspkr snd_hwdep i2c_i801 snd_pcm_oss snd_mixer_oss lpc_ich snd_pcm snd_seq_midi snd_seq_midi_event sg sr_mod cdrom snd_rawmidi snd_seq snd_seq_device snd_timer atl1 mii mvsas snd nouveau libsas scsi_transport_
soundcore ttm ehci_pci asus_atk0110 floppy uhci_hcd ehci_hcd usbcore acpi_cpufreq usb_common processor evdev
CPU: 0 PID: 1963 Comm: btrfs Tainted: G        W    3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
 0000000000000000 ffff88004b5c9988 ffffffff816090b3 ffff88004b5c99d0
 ffff88004b5c99c0 ffffffff81050025 ffffffff8120913a 00000000fffffffb
 ffff8800144d5800 ffff88007bd3ba00 ffffffff81839280 ffff88004b5c9a20
Call Trace:
 [<ffffffff816090b3>] dump_stack+0x4e/0x7a
 [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
 [<ffffffff8120913a>] ? __btrfs_abort_transaction+0x50/0x100
 [<ffffffff8105008a>] warn_slowpath_fmt+0x4c/0x4e
 [<ffffffff8120913a>] __btrfs_abort_transaction+0x50/0x100
 [<ffffffff81216fed>] __btrfs_free_extent+0x6ce/0x712
 [<ffffffff8121bc89>] __btrfs_run_delayed_refs+0x939/0xbdf
 [<ffffffff8121dac8>] btrfs_run_delayed_refs+0x81/0x18f
 [<ffffffff8122aeb2>] btrfs_commit_transaction+0xeb/0x849
 [<ffffffff8124e777>] btrfs_init_new_device+0x9a1/0xc00
 [<ffffffff8114069b>] ? ____cache_alloc+0x1c/0x29b
 [<ffffffff81129d3e>] ? mem_cgroup_end_update_page_stat+0x17/0x26
 [<ffffffff8125570f>] ? btrfs_ioctl+0x989/0x24b1
 [<ffffffff81141096>] ? __kmalloc_track_caller+0x130/0x144
 [<ffffffff8125570f>] ? btrfs_ioctl+0x989/0x24b1
 [<ffffffff81255730>] btrfs_ioctl+0x9aa/0x24b1
 [<ffffffff81611e15>] ? __do_page_fault+0x330/0x3df
 [<ffffffff8116da43>] ? mntput_no_expire+0x33/0x12b
 [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
 [<ffffffff8115676b>] ? ____fput+0xe/0x10
 [<ffffffff8106973a>] ? task_work_run+0x87/0x98
 [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
 [<ffffffff81611ed2>] ? do_page_fault+0xe/0x10
 [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
---[ end trace 7d08b9b7f2f17b38 ]---
BTRFS: error (device dm-9) in __btrfs_free_extent:5755: errno=-5 IO failure
BTRFS info (device dm-9): forced readonly
ERROR: error adding the device '/dev/mapper/crypt_sdm1' - Input/output error
polgara:~# Mar 17 09:07:14 polgara kernel: [124403.240880] BTRFS: error (device dm-9) in btrfs_run_delayed_refs:2713: errno=-5 IO failure

Mmmh, dm-9 is another device, although it seems to work:
polgara:~# dd if=/dev/dm-9 of=/dev/null bs=1M
^C1255+0 records in
1254+0 records out
1314914304 bytes (1.3 GB) copied, 15.169 s, 86.7 MB/s

polgara:~# btrfs device stats /dev/dm-9
[/dev/mapper/crypt_sdk1].write_io_errs   0
[/dev/mapper/crypt_sdk1].read_io_errs    0
[/dev/mapper/crypt_sdk1].flush_io_errs   0
[/dev/mapper/crypt_sdk1].corruption_errs 0
[/dev/mapper/crypt_sdk1].generation_errs 0


I also started getting errors on my device after hours of use last night (pasted below).
Not sure if I really have a 2nd device problem or not:

/dev/mapper/crypt_sde1 is dm-2,

BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
quiet_error: 123 callbacks suppressed
Buffer I/O error on device dm-2, logical block 16
Buffer I/O error on device dm-2, logical block 16384
Buffer I/O error on device dm-2, logical block 67108864
Buffer I/O error on device dm-2, logical block 16
Buffer I/O error on device dm-2, logical block 16384
Buffer I/O error on device dm-2, logical block 67108864
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
BTRFS: lost page write due to I/O error on /dev/mapper/crypt_sde1
Buffer I/O error on device dm-2, logical block 0
Buffer I/O error on device dm-2, logical block 1
Buffer I/O error on device dm-2, logical block 2
Buffer I/O error on device dm-2, logical block 3
Buffer I/O error on device dm-2, logical block 0
Buffer I/O error on device dm-2, logical block 122095101
Buffer I/O error on device dm-2, logical block 122095101
Buffer I/O error on device dm-2, logical block 0
Buffer I/O error on device dm-2, logical block 0
btrfs_dev_stat_print_on_error: 366 callbacks suppressed
btrfs_dev_stat_print_on_error: 346 callbacks suppressed
btrfs_dev_stat_print_on_error: 606 callbacks suppressed
btrfs_dev_stat_print_on_error: 276 callbacks suppressed
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
btrfs_dev_stat_print_on_error: 11469 callbacks suppressed
btree_readpage_end_io_hook: 31227 callbacks suppressed
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064
BTRFS: bad tree block start 16817792799093053571 2701656064

eventually it turned into:
BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 3891, rd 321927996, flush 0, corrupt 0, gen 0
BTRFS: bdev /dev/mapper/crypt_sde1 errs: wr 3891, rd 321927997, flush 0, corrupt 0, gen 0
BTRFS: bad tree block start 17271740454546054736 1265680384
------------[ cut here ]------------
WARNING: CPU: 1 PID: 10414 at fs/btrfs/super.c:257 __btrfs_abort_transaction+0x50/0x100()
BTRFS: Transaction aborted (error -5)
Modules linked in: xts gf128mul ipt_MASQUERADE ipt_REJECT xt_tcpudp xt_conntrack xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats ppdev rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse dm_crypt dm_mod configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs btusb bluetooth 6lowpan_iphc rfkill usbkbd usbmouse joydev hid_generic usbhid hid iTCO_wdt iTCO_vendor_support gpio_ich coretemp kvm_intel kvm microcode snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec pcspkr snd_hwdep i2c_i801 snd_pcm_oss snd_mixer_oss lpc_ich snd_pcm snd_seq_midi snd_seq_midi_event sg sr_mod cdrom snd_rawmidi snd_seq snd_seq_device snd_timer atl1 mii mvsas snd nouveau libsas scsi_transport_
soundcore ttm ehci_pci asus_atk0110 floppy uhci_hcd ehci_hcd usbcore acpi_cpufreq usb_common processor evdev
CPU: 1 PID: 10414 Comm: btrfs-transacti Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
Hardware name: System manufacturer P5KC/P5KC, BIOS 0502    05/24/2007
 0000000000000000 ffff88004ae4fb30 ffffffff816090b3 ffff88004ae4fb78
 ffff88004ae4fb68 ffffffff81050025 ffffffff8120913a 00000000fffffffb
 ffff88004f2e7800 ffff8800603804c0 ffffffff81839280 ffff88004ae4fbc8
Call Trace:
 [<ffffffff816090b3>] dump_stack+0x4e/0x7a
 [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
 [<ffffffff8120913a>] ? __btrfs_abort_transaction+0x50/0x100
 [<ffffffff8105008a>] warn_slowpath_fmt+0x4c/0x4e
 [<ffffffff8120913a>] __btrfs_abort_transaction+0x50/0x100
 [<ffffffff81216fed>] __btrfs_free_extent+0x6ce/0x712
 [<ffffffff8121bc89>] __btrfs_run_delayed_refs+0x939/0xbdf
 [<ffffffff8121dac8>] btrfs_run_delayed_refs+0x81/0x18f
 [<ffffffff8122ae40>] btrfs_commit_transaction+0x79/0x849
 [<ffffffff812277ca>] transaction_kthread+0xf8/0x1ab
 [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
 [<ffffffff8106bc56>] kthread+0xae/0xb6
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
 [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
---[ end trace 7d08b9b7f2f17b35 ]---
BTRFS: error (device dm-9) in __btrfs_free_extent:5755: errno=-5 IO failure
BTRFS info (device dm-9): forced readonly
BTRFS: error (device dm-9) in btrfs_run_delayed_refs:2713: errno=-5 IO failure
------------[ cut here ]------------


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
