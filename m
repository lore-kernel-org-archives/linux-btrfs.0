From: Josef Bacik <josef@redhat.com>
Subject: Re: Kernel BUG in tree-log.c on mount
Date: Thu, 15 Oct 2009 14:39:49 -0400
Message-ID: <20091015183948.GA9021@localhost.localdomain>
References: <cb81ffa90910142048g4aa9a30fmca8e5ce7007d13e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: David Pflug <dtpflug@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cb81ffa90910142048g4aa9a30fmca8e5ce7007d13e1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2009 at 11:48:59PM -0400, David Pflug wrote:
> I don't know if there's any useful data in this dump, for you guys. I
> can get you the output of btrfs-debug-tree as well, if it'd be
> helpful.
> 
> No idea what caused this. I thought it went through a normal shutdown
> and unmount, and btrfsck doesn't report any issues.
> 
> Btrfs loaded
> device label archstick devid 1 transid 4802 /dev/sdb2
> btrfs: unlinked 1 orphans
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/tree-log.c:800!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:04.0/net/eth0/operstate
> Modules linked in: btrfs zlib_deflate crc32c libcrc32c sr_mod cdrom
> usb_storage tun ipv6 snd_seq_dummy snd_wavefront snd_seq_oss battery
> snd_seq_midi_event snd_cs4236 snd_intel8x0 snd_wss_lib snd_opl3_lib
> analog snd_seq snd_ac97_codec ac97_bus snd_pcm_oss snd_hwdep snd_pcm
> snd_mixer_oss ppdev snd_timer i2c_sis96x ohci_hcd lp ac ns558 pcspkr
> gameport parport_pc snd_mpu401 snd_mpu401_uart ehci_hcd shpchp
> snd_rawmidi snd_seq_device sis_agp snd i2c_core fan psmouse usbcore
> serio_raw parport evdev soundcore snd_page_alloc pci_hotplug sg button
> thermal sis900 processor agpgart mii rtc_cmos rtc_core rtc_lib ext4
> mbcache jbd2 crc16 sd_mod ata_generic pata_acpi pata_sis libata
> scsi_mod floppy
> 
> Pid: 1709, comm: mount Not tainted (2.6.31-ARCH #1)
> EIP: 0060:[<f8723e77>] EFLAGS: 00010246 CPU: 0
> EIP is at add_inode_ref+0x497/0x4b0 [btrfs]
> EAX: 00000000 EBX: 00000097 ECX: de59c810 EDX: 00000000
> ESI: de59c3ec EDI: de5a2af0 EBP: ed0ffd2c ESP: ed0ffbb8
>  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process mount (pid: 1709, ti=ed0fe000 task=ece30c60 task.ti=ed0fe000)
> Stack:
>  bdada5e8 00000000 00000000 ed0ffc10 ed0ffc0c ed0ffc04 00000004 bdada5e8
> <0> ed0ffc63 bdada5e8 ecd83800 f6d650e0 ecd80800 ed0ffc10 ed0ffc0c ed0ffc08
> <0> de59c3ec de5a2af0 de5a7000 00000000 00000000 eadc1000 00000002 bdada5e8
> Call Trace:
>  [<f8724eff>] ? replay_one_buffer+0x26f/0x3b0 [btrfs]
>  [<f8721d94>] ? walk_down_log_tree+0x3c4/0x570 [btrfs]
>  [<f8724c90>] ? replay_one_buffer+0x0/0x3b0 [btrfs]
>  [<f8721ff7>] ? walk_log_tree+0xb7/0x200 [btrfs]
>  [<f8723294>] ? btrfs_recover_log_trees+0x244/0x330 [btrfs]
>  [<f8724c90>] ? replay_one_buffer+0x0/0x3b0 [btrfs]
>  [<f86eccda>] ? open_ctree+0xe9a/0x13a0 [btrfs]
>  [<c119c73b>] ? strlcpy+0x2b/0x80
>  [<f86ce8a1>] ? btrfs_get_sb+0x3b1/0x480 [btrfs]
>  [<c10efae5>] ? pcpu_alloc+0x455/0x490
>  [<c110e84a>] ? alloc_vfsmnt+0x8a/0x150
>  [<c110e8af>] ? alloc_vfsmnt+0xef/0x150
>  [<c10f5635>] ? vfs_kern_mount+0x75/0x160
>  [<c10f57b6>] ? do_kern_mount+0x56/0x120
>  [<c110f1c7>] ? do_mount+0x257/0x7a0
>  [<c110d161>] ? copy_mount_options+0x61/0x160
>  [<c110f7ab>] ? sys_mount+0x9b/0x100
>  [<c1003cb3>] ? sysenter_do_call+0x12/0x28
> Code: 44 24 4c e8 8c 49 9e c8 31 c0 8b 54 24 5c 65 33 15 14 00 00 00
> 75 24 83 c4 60 5b 5e 5f 5d c3 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f>
> 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe e8 a4 28 92 c8
> EIP: [<f8723e77>] add_inode_ref+0x497/0x4b0 [btrfs] SS:ESP 0068:ed0ffbb8
> ---[ end trace 535e961ea446e6c7 ]---
> --

Can you paste what line 800 is and the surrounding lines so I can see where it
BUG'ed?  Thanks,

Josef
