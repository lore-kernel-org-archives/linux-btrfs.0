Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc4s27.hotmail.com ([65.55.111.166]:63670 "EHLO
	BLU004-OMC4S27.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbaKUI6A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 03:58:00 -0500
Message-ID: <BLU436-SMTP225ABEBDA858CEA823D4CDBAB770@phx.gbl>
Date: Fri, 21 Nov 2014 08:49:48 +0000
From: Boris Chernov <aqs1024@hotmail.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Changing label few times killed filesystem?
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl> <20141121093543.6685cbe5@natsu>
In-Reply-To: <20141121093543.6685cbe5@natsu>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-21 04:35, Roman Mamedov wrote:
> On Fri, 21 Nov 2014 01:27:17 +0000
> Boris Chernov <aqs1024@hotmail.com> wrote:
>>       I have changed file system label few times in total. When I tried
>> to mount it after that, it became not mountable:
>>
>> # mount /dev/sdb1 /mnt
>> mount: Not a directory
> I'd say that implies something is wrong with your /mnt, rather than /dev/sdb1.
> Before mounting try things like "ls -la /mnt/", "umount /mnt", etc.
> Or simply mounting somewhere else other than /mnt/
     Before I attempted mounting to /mnt I tried to mount with KDE 
Device Notifier to /media/username/label, then I have tried to create 
directory manually in /media/ and tried to mount in the command-line, 
then tried /mnt, and error was the same. So I'm sure there is nothing 
wrong with my mount points.
     Now I have rebooted and tried to mount in KDE Device Notifier to 
/media/username/label, it failed again, so I tried from command-line as 
root:

# mkdir /media/sdb1 && ls -la /media/sdb1 && mount /dev/sdb1 /media/sdb1
total 8
drwxr-sr-x 2 root disk 4096 Nov 21 08:12 .
drwsrwsrwT 7 root disk 4096 Nov 21 08:12 ..

     ...and that's it, no output from mount command (it just hanged and 
become unkillable process). Please let me know if there is anything else 
I could try to either restore it or debug it (to at least understand why 
exactly it screwed up itself so it will not happen again to me or anyone 
else). If it matters, the disk is with single partition (BTRFS-only), 
was plugged-in all the time and I use Xeon-based workstation with ECC 
memory. In the dmesg I see the following, it seems after encountering 
btrfs bugs in its recovery tools (mentioned in my previous mail) I have 
also encountered btrfs bug in the kernel:

[  339.349260] BTRFS info (device sdb1): disk space caching is enabled
[  339.397438] parent transid verify failed on 29458432 wanted 5 found 2759
[  339.397505] ------------[ cut here ]------------
[  339.397510] kernel BUG at fs/btrfs/locking.c:269!
[  339.397513] invalid opcode: 0000 [#1] SMP
[  339.397517] Modules linked in: ppp_deflate bsd_comp ppp_async 
crc_ccitt ppp_generic slhc snd_aloop snd_hrtimer xt_conntrack 
iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables 
snd_ice1724 snd_ak4113 snd_pt2258 snd_ak4114 snd_i2c snd_ice17xx_ak4xxx 
snd_ak4xxx_adda snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device 
snd_timer snd soundcore ac97_bus vmnet(O) parport_pc parport 
vmw_vsock_vmci_transport vsock vmw_vmci vmmon(O) cpufreq_conservative 
cpufreq_powersave cpufreq_userspace cpufreq_stats zram nvidia(PO) 
cfg80211 rfkill binfmt_misc uinput zfs(PO) zunicode(PO) zavl(PO) 
zcommon(PO) znvpair(PO) spl(O) nfsd auth_rpcgss oid_registry nfs_acl nfs 
lockd fscache sunrpc iTCO_wdt iTCO_vendor_support usblp kvm_intel kvm 
ses enclosure cdc_ether psmouse option i2c_i801 pcspkr usbnet mii 
usb_wwan usbserial serio_raw i7core_edac edac_core uvcvideo 
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media evdev 
joydev jc42 w83627ehf lm90 coretemp adt7475 hwmon_vid adm1021 ttm 
drm_kms_helper drm i2c_algo_bit i2c_core msr loop fuse tpm_infineon 
tpm_tis lpc_ich mfd_core tpm button acpi_cpufreq processor thermal_sys 
autofs4 ext4 crc16 mbcache jbd2 btrfs xor raid6_pq usb_storage sg sd_mod 
sr_mod cdrom crc_t10dif crct10dif_common hid_generic usbhid hid ahci 
libahci libata crc32c_intel scsi_mod e1000e ptp pps_core xhci_hcd 
ehci_pci ehci_hcd usbcore usb_common [last unloaded: vmnet]
[  339.397584] CPU: 0 PID: 25752 Comm: mount Tainted: P           O 
3.15.0-pf2 #1
[  339.397585] Hardware name: Supermicro X8SIE/X8SIE, BIOS 1.2        
08/19/11
[  339.397586] task: ffff880036c93f80 ti: ffff8805702b4000 task.ti: 
ffff8805702b4000
[  339.397587] RIP: 0010:[<ffffffffa0245050>] [<ffffffffa0245050>] 
btrfs_assert_tree_read_locked.part.0+0x0/0x10 [btrfs]
[  339.397604] RSP: 0018:ffff8805702b7bf0  EFLAGS: 00010246
[  339.397605] RAX: 0000000000000000 RBX: ffff8804db6da800 RCX: 
0000000000000581
[  339.397606] RDX: 0000000000000000 RSI: ffff8804db58d0e0 RDI: 
ffff8804db6da800
[  339.397607] RBP: 0000000000000001 R08: 000000000001b830 R09: 
ffff88063fc1b830
[  339.397608] R10: ffff88061afec700 R11: ffffea00136d6300 R12: 
0000000000000005
[  339.397609] R13: ffff88008c978820 R14: ffff88061af51000 R15: 
ffff8804db6da800
[  339.397610] FS:  00007f55bf45b840(0000) GS:ffff88063fc00000(0000) 
knlGS:0000000000000000
[  339.397612] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  339.397613] CR2: 00007f6b280af000 CR3: 00000004da047000 CR4: 
00000000000007f0
[  339.397614] Stack:
[  339.397614]  ffffffffa024557d ffff8804db6da800 ffffffffa0208838 
0000000000000000
[  339.397616]  0000000000000000 0000000000000000 0000000000000000 
ffff88008c978820
[  339.397617]  ffffffffa02093a0 0000000000001c18 0000000000000005 
ffff8804db6da800
[  339.397619] Call Trace:
[  339.397629]  [<ffffffffa024557d>] ? 
btrfs_tree_read_unlock_blocking+0x8d/0xc0 [btrfs]
[  339.397637]  [<ffffffffa0208838>] ? verify_parent_transid+0x118/0x1a0 
[btrfs]
[  339.397645]  [<ffffffffa02093a0>] ? 
btree_read_extent_buffer_pages.constprop.46+0xc0/0x110 [btrfs]
[  339.397653]  [<ffffffffa020a46e>] ? read_tree_block+0x2e/0x50 [btrfs]
[  339.397662]  [<ffffffffa020b90e>] ? btrfs_read_tree_root+0x10e/0x180 
[btrfs]
[  339.397670]  [<ffffffffa020e745>] ? open_ctree+0x1495/0x1e90 [btrfs]
[  339.397677]  [<ffffffffa01e791d>] ? btrfs_mount+0x6bd/0x880 [btrfs]
[  339.397683]  [<ffffffff81191f71>] ? mount_fs+0x31/0x1b0
[  339.397687]  [<ffffffff811ac63d>] ? vfs_kern_mount+0x5d/0x110
[  339.397690]  [<ffffffff811aecb5>] ? do_mount+0x225/0xa50
[  339.397693]  [<ffffffff811393b8>] ? memdup_user+0x38/0x70
[  339.397695]  [<ffffffff811af7fb>] ? SyS_mount+0x9b/0x110
[  339.397698]  [<ffffffff814de3f9>] ? system_call_fastpath+0x16/0x1b
[  339.397699] Code: ee e0 b9 ea ff ff ff e9 64 ff ff ff 4c 8b a4 24 90 
00 00 00 b9 ea ff ff ff e9 52 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 
1f 00 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 0b 66 66 66
[  339.397715] RIP  [<ffffffffa0245050>] 
btrfs_assert_tree_read_locked.part.0+0x0/0x10 [btrfs]
[  339.397722]  RSP <ffff8805702b7bf0>
[  339.397822] ---[ end trace 335f63b7cdc66864 ]---
[  341.358672] perf interrupt took too long (2508 > 2500), lowering 
kernel.perf_event_max_sample_rate to 50000
