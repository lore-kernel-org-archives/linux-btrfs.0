From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: btrfs day 1
Date: Thu, 14 Aug 2008 11:06:12 -0700
Message-ID: <20080814110612.1f411564@extreme>
References: <20080814001120.4f1fea7a@speedy>
	<1218709514.15342.370.camel@think.oraclecorp.com>
	<20080814091937.470f42ed@speedy>
	<1218734760.15342.381.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1218734760.15342.381.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Aug 2008 13:26:00 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> On Thu, 2008-08-14 at 09:19 -0700, Stephen Hemminger wrote:
> > On Thu, 14 Aug 2008 06:25:14 -0400
> > Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > On Thu, 2008-08-14 at 00:11 -0700, Stephen Hemminger wrote:
> > > > Setup new 60G home partition on laptop as a real life test of 0.16.
> > > > Using Ubuntu standard kernel 2.6.24-19-generic on i386
> > > > 
> > > 
> > > Thanks for giving things a try
> > > 
> > > > I notice that during normal (busy time) everything seems fine, but after going away
> > > > for a while and coming back, it seems sluggish. Lots of errors in log:
> > > > 
> > > >  btrfs csum failed ino 139988 off 4583424 csum 3821684403 private 0
> > > >  btrfs csum failed ino 139988 off 4579328 csum 3233603900 private 0
> > > >  btrfs csum failed ino 139988 off 4575232 csum 306171610 private 0
> > > > 
> > > > Maybe it isn't handleing spindown properly? or something like that?
> > > 
> > > Were these the only errors in the log, or did you have other errors
> > > about not being able to find specific csums?
> > > 
> > > What does 'going away for a while and coming back' include?
> > 
> > 1. Start kernel build
> > 2. Come back 2+ hrs later
> > 
> > (So problem could be in step 1 or 2)
> > 
> > All failures are on the same inode
> 
> Ok, my guess is that if you find . -inum 13998 you'll get some form of
> vmlinux or .tmp_vmlinux*
> 
> So, the question is why the kernel compile workload works for me.  What
> kind of hardware are you running (ram, cpu, disks?)

Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
Memory 2G
Disk 80G (partition was 20G)

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E Gigabit Ethernet Controller (rev 14)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
1c:03.0 CardBus bridge: O2 Micro, Inc. OZ711SP1 Memory CardBus Controller (rev 01)
1c:03.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (rev 02)
1c:03.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD Controller (rev 01)

I tried rsyncing from usb disk onto a clean filesystem and got more trouble.
This was with 2.6.26.15 kernel with btrfs 0.16 module.

[  136.456741] device fsid 14cc68e1c545e25-7f9a584b5e79ea84 devid 1 transid 12 /dev/sda3
[  349.390467] bad mapping eb start 50405376 len 4096, wanted 421088093 4
[  349.390467] ------------[ cut here ]------------
[  349.390467] WARNING: at /home/shemminger/src/btrfs-0.16/extent_io.c:3180 map_private_extent_buffer+0x86/0xfd [btrfs]()
[  349.390467] Modules linked in: usb_storage i915 drm rfcomm l2cap ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservative sbs sbshc wmi container iptable_filter ip_tables x_tables dm_crypt dm_mod tcp_htcp btrfs snd_hda_intel snd_pcm_oss snd_mixer_oss pcmcia snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq arc4 ecb crypto_blkcipher tpm_infineon tpm snd_timer snd_seq_device tpm_bios yenta_socket iwl4965 usbhid hci_usb apanel input_polldev pcspkr ff_memless mac80211 rsrc_nonstatic bluetooth sdhci snd video backlight pcmcia_core cfg80211 output mmc_core battery ac button sky2 soundcore ata_generic sg sd_mod pata_acpi ahci ata_piix libata dock ehci_hcd uhci_hcd thermal processor fan fuse
[  349.390467] Pid: 4840, comm: rsync Not tainted 2.6.25.15 #2
[  349.390467]  [dm_mod:warn_on_slowpath+0x41/0xc6d] warn_on_slowpath+0x41/0x51
[  349.390467]  [wake_up_klogd+0x2e/0x31] ? wake_up_klogd+0x2e/0x31
[  349.390467]  [release_console_sem+0x19a/0x1a2] ? release_console_sem+0x19a/0x1a2
[  349.390467]  [btrfs:wait_on_page_bit+0x58/0x60] ? wait_on_page_bit+0x58/0x60
[  349.390467]  [btrfs:printk+0x15/0xbc] ? printk+0x15/0x17
[  349.390467]  [<f8bceb4a>] map_private_extent_buffer+0x86/0xfd [btrfs]
[  349.390467]  [<f8bcec10>] map_extent_buffer+0x4f/0x88 [btrfs]
[  349.390467]  [<f8bc8656>] btrfs_item_offset+0x57/0x9e [btrfs]
[  349.390467]  [<f8bae1bc>] leaf_space_used+0x6c/0x96 [btrfs]
[  349.390467]  [<f8bae6cd>] btrfs_leaf_free_space+0x3c/0x75 [btrfs]
[  349.390467]  [<f8baf5a1>] push_leaf_right+0x8a/0x505 [btrfs]
[  349.390467]  [btrfs:kmap_atomic+0xe/0x10] ? kmap_atomic+0xe/0x10
[  349.390467]  [<f8bceb9d>] ? map_private_extent_buffer+0xd9/0xfd [btrfs]
[  349.390467]  [<f8bcec10>] ? map_extent_buffer+0x4f/0x88 [btrfs]
[  349.390467]  [<f8bb0099>] split_leaf+0x61/0x6e0 [btrfs]
[  349.390467]  [<f8bc8692>] ? btrfs_item_offset+0x93/0x9e [btrfs]
[  349.390467]  [<f8bae1bc>] ? leaf_space_used+0x6c/0x96 [btrfs]
[  349.390467]  [<f8bb2b46>] btrfs_search_slot+0xe85/0xeea [btrfs]
[  349.390467]  [<f8bcf4b5>] ? tree_insert+0x5a/0x62 [btrfs]
[  349.390467]  [<f8bcedf3>] ? free_extent_state+0x65/0x68 [btrfs]
[  349.390467]  [<f8bcef4c>] ? merge_state+0xbc/0xc4 [btrfs]
[  349.390467]  [<f8bcfe19>] ? set_extent_bit+0x2eb/0x338 [btrfs]
[  349.390467]  [<f8bb2f74>] btrfs_insert_empty_items+0x49/0x342 [btrfs]
[  349.390467]  [<f8bd35c6>] ? set_extent_buffer_dirty+0x1bd/0x1c5 [btrfs]
