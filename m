From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel Oops on heavy compiling
Date: Fri, 18 Jul 2008 20:29:42 -0400
Message-ID: <1216427382.6932.78.camel@think.oraclecorp.com>
References: <200807171740.16534.toei.rei@stargazer.at>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Toei Rei <toei.rei@stargazer.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200807171740.16534.toei.rei@stargazer.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-07-17 at 17:40 +0200, Toei Rei wrote:
> Hello List, hello folks...
> 
> 
> I came across a bug lately while messing around with the new kde 4.1 (building 
> and svn checkouts for building it):
> 

I haven't forgotten this one ;)  Is there an easy command I could use to
check things out on a non-gentoo box?

-chris

> ------------[ cut here ]------------
> kernel BUG at /var/tmp/portage/sys-fs/btrfs-9999/work/kernel/volumes.c:1705!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: act_police sch_ingress cls_u32 sch_sfq sch_cbq wacom 
> snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event 
> snd_seq snd_seq_device btrfs esp4 aead ah4 arc4 nvidia(P) ecb 
> crypto_blkcipher pcmcia iwl3945 firmware_class firewire_ohci firewire_core 
> mac80211 intel_agp agpgart rtc tifm_7xx1 pcspkr tifm_core i2c_i801 e100 mii 
> yenta_socket rsrc_nonstatic pcmcia_core video thermal battery button wmi 
> snd_hda_intel snd_pcm crc_itu_t cfg80211 output ac snd_timer snd_page_alloc 
> snd_hwdep snd processor xfs nfs lockd sunrpc reiserfs ext3 jbd dm_bbr 
> dm_snapshot dm_mirror dm_mod usbhid ohci_hcd uhci_hcd usb_storage ehci_hcd 
> usbcore scsi_wait_scan [last unloaded: microcode]
> 
> Pid: 14647, comm: bash Tainted: P         (2.6.25-gentoo-r6 #1)
> EIP: 0060:[<f92520e7>] EFLAGS: 00010246 CPU: 1
> EIP is at btrfs_num_copies+0x30/0x80 [btrfs]
> EAX: 00000000 EBX: f03ea118 ECX: 00000000 EDX: 00001000
> ESI: f03ea120 EDI: f008b754 EBP: 37cc4939 ESP: d1163c58
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process bash (pid: 14647, ti=d1162000 task=f586c000 task.ti=d1162000)
> Stack: 00000000 c3f19000 fffffffb d46bf610 f92398a4 00001000 00000000 e52dec00
>        c3f19000 e52dec00 00001000 00000065 f923a4e2 00000000 00000000 b6fb9055
>        151ee77d b6fb9055 151ee77d f922cb55 00001000 b6fb9055 151ee77d efb4fce8
> Call Trace:
>  [<f92398a4>] btrfs_csum_final+0x1c8/0x1dc [btrfs]
>  [<f923a4e2>] read_tree_block+0x3e/0xee [btrfs]
>  [<f922cb55>] btrfs_release_path+0x340/0x34e [btrfs]
>  [<f9231455>] btrfs_search_slot+0xedf/0xf60 [btrfs]
>  [<c011567d>] find_busiest_group+0x259/0x643
>  [<f92380f3>] btrfs_lookup_dir_item+0x62/0x1a0 [btrfs]
>  [<f9240d85>] btrfs_read_locked_inode+0x4b1/0x697 [btrfs]
>  [<f8f0cf74>] ext3_get_acl+0x55/0x2ce [ext3]
>  [<c0169937>] d_alloc+0x11f/0x153
>  [<c016061b>] do_lookup+0xa6/0x145
>  [<c0161fb6>] __link_path_walk+0x830/0xc5f
>  [<c016242f>] path_walk+0x4a/0x98
>  [<c016273e>] do_path_lookup+0x17b/0x196
>  [<c0162f36>] __user_walk_fd+0x29/0x3f
>  [<c015d0fb>] vfs_stat_fd+0x15/0x3c
>  [<c015d1d7>] sys_stat64+0xf/0x24
>  [<c010378a>] sysenter_past_esp+0x5f/0x85
>  =======================
> Code: cf 56 8d 70 08 53 89 c3 89 f0 e8 ee 03 0b c7 89 ea ff 74 24 18 89 f9 89 
> d8 ff 74 24 18 e8 de 3e ff ff fe 43 08 5a 85 c0 59 75 04 <0f> 0b eb fe 8b 48 
> 10 8b 50 0c 39 f9 77 16 72 04 39 ea 77 10 03
> EIP: [<f92520e7>] btrfs_num_copies+0x30/0x80 [btrfs] SS:ESP 0068:d1163c58
> ---[ end trace e4232a9c9492073d ]---
> 
> 
> Some info:
> 
> Kernel:
> Linux pavilion 2.6.25-gentoo-r6 #1 SMP Tue Jul 8 10:35:45 CEST 2008 i686 
> Genuine Intel(R) CPU T2500 @ 2.00GHz GenuineIntel GNU/Linux
> 
> 
> ~ $ df -h
> Filesystem            Size  Used Avail Use% Mounted on
> ....
> /dev/sda4              30G  4.3G   26G  15% /home/kde-devel
> ....
> 
> 
> from the fstab:
> /dev/sda4               /home/kde-devel btrfs           users,exec                                              
> 0 7
> 
> 

