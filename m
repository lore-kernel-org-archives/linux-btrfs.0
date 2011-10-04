From: Milko Krachounov <sombre@gmail.com>
Subject: Re: [PATCH] Btrfs: fix orphan cleanup regression
Date: Tue, 04 Oct 2011 10:30:50 +0300
Message-ID: <j6ecna$dfk$1@dough.gmane.org>
References: <1316638676-21653-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:

> In fixing how we deal with bad inodes, we had a regression in the orphan
> cleanup
> code, since it expects to get a bad inode back.  So fix it to deal with
> getting
> -ESTALE back by deleting the orphan item manually and moving on.  Thanks,
> 
> Reported-by: Simon Kirby <sim@hostway.ca>
> Signed-off-by: Josef Bacik <josef@redhat.com>


Hello, thank you for your work, I applied your patch and it fixed the issue 
mentioned for me. However, I just got a kernel BUG that led to a total freeze. 
I suspect it might be related to your patch, because:

1. I haven't experienced it without your patch
2. I did experience a very similar one when I tried to fix the problem with 
the quickly hacked patch I posted here: 
http://comments.gmane.org/gmane.comp.file-systems.btrfs/12947

Oct  4 09:19:13 obelix kernel: [ 1903.728105] ------------[ cut here ]------------
Oct  4 09:19:13 obelix kernel: [ 1903.728147] kernel BUG at /root/linux-2.6-3.1.0~rc4/debian/build/source_amd64_none/fs/btrfs/inode.c:2390!
Oct  4 09:19:13 obelix kernel: [ 1903.728209] invalid opcode: 0000 [#1] SMP 
Oct  4 09:19:13 obelix kernel: [ 1903.728241] CPU 3 
Oct  4 09:19:13 obelix kernel: [ 1903.728256] Modules linked in: acpi_cpufreq mperf cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservat
ive parport_pc ppdev lp parport rfcomm bnep snd_hrtimer binfmt_misc uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext4 jbd2 ext3 jbd mb
cache firewire_sbp2 loop tuner_simple tuner_types tuner snd_hda_codec_analog tvaudio tda7432 snd_emu10k1_synth bttv snd_emux_synth snd_seq_virmidi snd_
seq_midi_emul snd_emu10k1 videobuf_dma_sg ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sony_decoder videobuf_core cryptd ir_jvc_decoder aes_x86_64 btcx
_risc snd_ac97_codec snd_hda_intel snd_hda_codec aes_generic ir_rc6_decoder ac97_bus ecb ir_rc5_decoder snd_pcm_oss snd_mixer_oss ir_nec_decoder snd_pc
m rc_core snd_util_mem snd_hwdep snd_seq_midi btusb snd_rawmidi snd_seq_midi_event snd_seq bluetooth tveeprom rfkill snd_timer snd_seq_device v4l2_comm
on videodev psmouse media emu10k1_gp crc16 gameport snd serio_raw v4l2_compat_ioctl32 processor i2c_i801 soundcore evdev 
Oct  4 09:19:13 obelix kernel: asus_atk0110 snd_page_alloc pcspkr btrfs zlib_deflate crc32c libcrc32c raid10 raid1 raid0 md_mod scsi_wait_scan usbhid h
id sr_mod sg cdrom sd_mod crc_t10dif usb_storage ata_generic uas uhci_hcd pata_jmicron ahci libahci skge libata firewire_ohci firewire_core crc_itu_t s
csi_mod ehci_hcd i915 floppy drm_kms_helper drm i2c_algo_bit usbcore i2c_core video thermal_sys button [last unloaded: scsi_wait_scan]
Oct  4 09:19:13 obelix kernel: [ 1903.729275] 
Oct  4 09:19:13 obelix kernel: [ 1903.729288] Pid: 8793, comm: python Not tainted 3.1.0-rc4-amd64 #1 System manufacturer System Product Name/P5B-V
Oct  4 09:19:13 obelix kernel: [ 1903.729358] RIP: 0010:[<ffffffffa0253ffb>]  [<ffffffffa0253ffb>] btrfs_orphan_cleanup+0x173/0x305 [btrfs]
Oct  4 09:19:13 obelix kernel: [ 1903.729443] RSP: 0018:ffff880188cdbb68  EFLAGS: 00010282
Oct  4 09:19:13 obelix kernel: [ 1903.729479] RAX: 00000000fffffffe RBX: ffff8802719fe400 RCX: ffff880194c15e40
Oct  4 09:19:13 obelix kernel: [ 1903.729525] RDX: 0000000000000007 RSI: ffff8801edeec5b0 RDI: 0000000000000296
Oct  4 09:19:13 obelix kernel: [ 1903.729571] RBP: ffff8801edeeceb0 R08: 0000000000000000 R09: ffff880188cdba30
Oct  4 09:19:13 obelix kernel: [ 1903.729617] R10: 0000000000000000 R11: 0000000000015d68 R12: ffff8802719fe788
Oct  4 09:19:13 obelix kernel: [ 1903.729663] R13: 000000000050deed R14: 0000000000000000 R15: ffff880188cdbb88
Oct  4 09:19:13 obelix kernel: [ 1903.729710] FS:  00007f0bcfb62700(0000) GS:ffff88027bd80000(0000) knlGS:0000000000000000
Oct  4 09:19:13 obelix kernel: [ 1903.729764] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct  4 09:19:13 obelix kernel: [ 1903.729801] CR2: 00000000015ba018 CR3: 0000000184601000 CR4: 00000000000006e0
Oct  4 09:19:13 obelix kernel: [ 1903.729848] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  4 09:19:13 obelix kernel: [ 1903.729894] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  4 09:19:13 obelix kernel: [ 1903.729941] Process python (pid: 8793, threadinfo ffff880188cda000, task ffff88026f0fb020)
Oct  4 09:19:13 obelix kernel: [ 1903.729998] Stack:
Oct  4 09:19:13 obelix kernel: [ 1903.730015]  ffff8801edeeceb0 ffff880194c15e40 ffff8801964211d8 ffff8802719fe790
Oct  4 09:19:13 obelix kernel: [ 1903.730075]  00000000000de11c 0000000000000001 ffff880100000000 ffff8801edeeceb0
Oct  4 09:19:13 obelix kernel: [ 1903.730132]  fffffffffffffffb ffffffffffffff30 ffff8802719fe4ff 0000000000000000
Oct  4 09:19:13 obelix kernel: [ 1903.730188] Call Trace:
Oct  4 09:19:13 obelix kernel: [ 1903.730228]  [<ffffffffa02544ed>] ? btrfs_lookup_dentry+0x360/0x39f [btrfs]
Oct  4 09:19:13 obelix kernel: [ 1903.730293]  [<ffffffffa0254535>] ? btrfs_lookup+0x9/0x15 [btrfs]
Oct  4 09:19:13 obelix kernel: [ 1903.730341]  [<ffffffff81106bd9>] ? d_alloc_and_lookup+0x3a/0x60
Oct  4 09:19:13 obelix kernel: [ 1903.730382]  [<ffffffff81107669>] ? walk_component+0x1df/0x405
Oct  4 09:19:13 obelix kernel: [ 1903.730422]  [<ffffffff81107d06>] ? link_path_walk+0x168/0x44b
Oct  4 09:19:13 obelix kernel: [ 1903.730463]  [<ffffffff81109fb3>] ? path_openat+0xac/0x350
Oct  4 09:19:13 obelix kernel: [ 1903.730500]  [<ffffffff810d568e>] ? handle_mm_fault+0x1ea/0x22c
Oct  4 09:19:13 obelix kernel: [ 1903.730541]  [<ffffffff8104af6c>] ? wait_consider_task+0x5f2/0x9ce
Oct  4 09:19:13 obelix kernel: [ 1903.730583]  [<ffffffff8110a2a0>] ? do_filp_open+0x2c/0x72
Oct  4 09:19:13 obelix kernel: [ 1903.730622]  [<ffffffff81343baf>] ? _cond_resched+0x9/0x20
Oct  4 09:19:13 obelix kernel: [ 1903.730660]  [<ffffffff811b385d>] ? __strncpy_from_user+0x19/0x4a
Oct  4 09:19:13 obelix kernel: [ 1903.730702]  [<ffffffff811134a4>] ? alloc_fd+0x69/0x110
Oct  4 09:19:13 obelix kernel: [ 1903.730738]  [<ffffffff810fdf02>] ? do_sys_open+0x5f/0xe6
Oct  4 09:19:13 obelix kernel: [ 1903.730775]  [<ffffffff81349fd2>] ? system_call_fastpath+0x16/0x1b
Oct  4 09:19:13 obelix kernel: [ 1903.730817] Code: 85 c0 0f 84 89 01 00 00 e9 6c 01 00 00 48 8b 54 24 20 48 89 de 48 89 c7 48 89 44 24 08 e8 34 b5 01 00 85 c0 48 8b 4c 24 08 74 02 <0f> 0b 48 
89 de 48 89 cf e8 5e 78 ff ff e9 f5 fe ff ff 4c 89 e7 
Oct  4 09:19:13 obelix kernel: [ 1903.731076] RIP  [<ffffffffa0253ffb>] btrfs_orphan_cleanup+0x173/0x305 [btrfs]
Oct  4 09:19:13 obelix kernel: [ 1903.731151]  RSP <ffff880188cdbb68>
Oct  4 09:19:13 obelix kernel: [ 1903.760747] ---[ end trace 14ec5cd3271fff43 ]---


