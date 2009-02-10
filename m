From: Aaron Straus <aaron@merfinllc.com>
Subject: Re: [PATCH] start work on delete snapshot code
Date: Tue, 10 Feb 2009 11:57:30 -0800
Message-ID: <20090210195730.GA20942@merfinllc.com>
References: <1234224453-4227-1-git-send-email-aaron@merfinllc.com> <loom.20090210T194303-716@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Michele Petrazzo <michele.petrazzo@unipex.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20090210T194303-716@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

  Thanks for the traceback, I'll look into it tonight and try to figure
out what went wrong.

  There are definitely problems with the patch (other than the complete
lack of locking and memory leaks).  :)

  One of the biggest issues with this snapshot deletion code is that it
relies on the snapshot refs and backrefs being accurate.  I'm not sure
that's the case with the current snapshot creation code.  

  I want to make sure my understanding of the root_refs and
root_backrefs is accurate before doing any more work on the patch
though.

				Regards,
				=a=

On Feb 10 07:44 PM, Michele Petrazzo wrote:
> Aaron Straus <aaron <at> merfinllc.com> writes:
> 
> <-cut-> 
> 
> Just tried and:
> 
> [20555.327056] btrfs: use compression
> [20592.252323] BUG: unable to handle kernel NULL pointer dereference at 00000073
> [20592.252335] IP: [<f8d185c6>] :btrfs:btrfs_ioctl_snap_destroy+0xeb/0x24a
> [20592.252385] *pde = 00000000
> [20592.252393] Oops: 0000 [#1] SMP
> [20592.252399] Modules linked in: btrfs nls_utf8 cifs nls_base vmnet vmci vmmon
> nvidia(P) agpgart ppdev lp rfcomm l2cap bluetooth vboxnetflt vboxdrv video
> output ac battery powernow_k8 cpufreq_userspace cpufreq_stats cpufreq_powersave
> cpufreq_ondemand freq_table cpufreq_conservative kvm_amd kvm dm_snapshot
> dm_mirror dm_log dm_mod ipv6 fuse zlib_inflate zlib_deflate libcrc32c
> firewire_sbp2 loop rtc_cmos rtc_core rtc_lib snd_pcsp k8temp snd_hda_intel
> snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc
> parport_pc parport button i2c_nforce2 i2c_core evdev joydev ext3 jbd mbcache
> raid1 md_mod sd_mod crc_t10dif ide_disk usb_storage usbhid sata_nv hid
> ff_memless ata_generic libata scsi_mod dock floppy forcedeth firewire_ohci
> firewire_core crc_itu_t ide_pci_generic amd74xx ide_core ehci_hcd ohci_hcd
> usbcore thermal processor fan thermal_sys [last unloaded: btrfs]
> [20592.252521]
> [20592.252527] Pid: 6247, comm: btrfsctl Tainted: P          (2.6.27-1-686 #1)
> [20592.252534] EIP: 0060:[<f8d185c6>] EFLAGS: 00210202 CPU: 0
> [20592.252573] EIP is at btrfs_ioctl_snap_destroy+0xeb/0x24a [btrfs]
> [20592.252578] EAX: 00000000 EBX: bfc53cc8 ECX: 00000000 EDX: 00000000
> [20592.252584] ESI: ffffffea EDI: f59bce7c EBP: f480ac00 ESP: f2e0dec4
> [20592.252589]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [20592.252595] Process btrfsctl (pid: 6247, ti=f2e0c000 task=dde44620
> task.ti=f2e0c000)
> [20592.252599] Stack: e9b91000 e9b91008 00000006 00000000 e685b744 f43a03c0
> bfc53cc8 f480ac00
> [20592.252613]        5000940f f8d187f4 00000000 c1000000 f4829668 f5666b40
> f480ac00 f4928b7c
> [20592.252626]        000000f6 00000000 00000000 003b9380 f4829680 00000000
> b7eb5300 f4829668
> [20592.252639] Call Trace:
> [20592.252643]  [<f8d187f4>] btrfs_ioctl+0xcf/0x897 [btrfs]
> [20592.252683]  [<c0168c12>] __vma_link+0x3f/0x4a
> [20592.252693]  [<c01693d4>] vma_link+0x4a/0xc5
> [20592.252701]  [<f8d18725>] btrfs_ioctl+0x0/0x897 [btrfs]
> [20592.252738]  [<c01825b0>] vfs_ioctl+0x1c/0x5d
> [20592.252747]  [<c0182830>] do_vfs_ioctl+0x23f/0x24d
> [20592.252755]  [<c018287f>] sys_ioctl+0x41/0x5a
> [20592.252763]  [<c01037f7>] sysenter_do_call+0x12/0x2f
> [20592.252771]  =======================
> [20592.252774] Code: 47 0c 31 f6 83 c0 78 e8 1e a1 5a c7 e9 67 01 00 00 8b 54 24
> 10 8b 52 0c 89 54 24 0c 8b 47 0c 83 c0 78 e8 03 a1 5a c7 8b 44 24 0c <f6> 40 73
> 40 75 07 68 70 20 d2 f8 eb 12 8b 54 24 0c 81 7a 20 00
> [20592.252839] EIP: [<f8d185c6>] btrfs_ioctl_snap_destroy+0xeb/0x24a [btrfs]
> SS:ESP 0068:f2e0dec4
> [20592.252881] ---[ end trace f1de5e7cc818c994 ]---
> (END)                                                                          

-- 
===================
Aaron Straus
aaron@merfinllc.com
