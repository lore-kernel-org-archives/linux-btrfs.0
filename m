From: Chris Mason <chris.mason@oracle.com>
Subject: Re: fsfuzz testing: some results
Date: Thu, 10 Apr 2008 08:55:04 -0400
Message-ID: <200804100855.04654.chris.mason@oracle.com>
References: <804dabb00804100433q375e31fdw6a9b107f3ffd3338@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: btrfs-devel@oss.oracle.com, linux-btrfs@vger.kernel.org
Return-path: <btrfs-devel-bounces@oss.oracle.com>
In-Reply-To: <804dabb00804100433q375e31fdw6a9b107f3ffd3338@mail.gmail.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/btrfs-devel>
List-Post: <mailto:btrfs-devel@oss.oracle.com>
List-Help: <mailto:btrfs-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/btrfs-devel>,
	<mailto:btrfs-devel-request@oss.oracle.com?subject=subscribe>
Errors-To: btrfs-devel-bounces@oss.oracle.com
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 April 2008, Peter Teoh wrote:
> Testing with a modified copy of the fsfuzz, the btrfs filesystem
> hanged with the following output in dmesg.   The system still remain
> responsive, except for the terminal that was doing the testing.   Any
> attempt to list files in the btrfs-mounted directory will block as
> well.

Yes, btrfs currently falls over badly when the metadata isn't in the expected 
format.  This is  partially intentional, I want to catch mistakes instead of 
limping along and letting the bugs continue.

So, the suggestion right now is don't fuzz it ;)

-chris

>
> I am not sure how to proceed from here.   Possibly to reboot the
> system next.   But anyone can shed some suggestion?
>
> Downloaded and compile the following (latest stable) package from
> http://www.kernel.org/hg/index.cgi/btrfs/progs/archive/:
>
> kernel-e4cd88595ed7.tar.bz2
> progs-269a009cca47.tar.bz2
>
> ------------[ cut here ]------------
> kernel BUG at /tmp/btrfs-stable/extent-tree.c:1746!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: btrfs libcrc32c nls_utf8 ipt_MASQUERADE iptable_nat
> nf_nat bridge autofs4 nf_conntrack_netbios_ns ipt_REJECT
> nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables
> ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables hidp rfcomm
> l2cap bluetooth sunrpc loop dm_multipath sbs sbshc battery ac ipv6
> parport_pc lp parport snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep
> snd_hda_intel snd_seq_dummy sg snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device snd_pcm_oss snd_mixer_oss ide_cd_mod cdrom snd_pcm
> snd_timer snd button soundcore sky2 snd_page_alloc serio_raw i2c_i801
> i2c_core ohci1394 iTCO_wdt pcspkr iTCO_vendor_support floppy
> dm_snapshot dm_zero dm_mirror dm_mod ahci ata_piix libata dock sd_mod
> scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
>
> Pid: 213, comm: pdflush Not tainted (2.6.25-rc7 #3)
> EIP: 0060:[<f8b936b3>] EFLAGS: 00010286 CPU: 1
> EIP is at btrfs_alloc_extent+0xba/0x328 [btrfs]
> EAX: ffffffe4 EBX: f2455730 ECX: c2017c88 EDX: 00000000
> ESI: f3da7130 EDI: 00000000 EBP: f7945c64 ESP: f7945c20
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process pdflush (pid: 213, ti=f7945000 task=f79426e0 task.ti=f7945000)
> Stack: f3d6b400 f2455730 f288c400 00000000 000002f4 00000000 07b45000
> 00000000 0000394d 00000246 f7945c64 c041fec6 42a9fd92 00000172 027f9000
> 00000000 00000000 f7945d10 f8b9a246 027f9000 00000000 00000003 00000000
> 00000671 Call Trace:
>  [<c041fec6>] ? hrtick_set+0xcf/0xd7
>  [<f8b9a246>] ? cow_file_range+0x15f/0x243 [btrfs]
>  [<f8b9a89f>] ? run_delalloc_range+0x294/0x2b5 [btrfs]
>  [<f8ba622b>] ? unlock_extent+0x17/0x19 [btrfs]
>  [<f8ba69ed>] ? __extent_writepage+0x1a0/0x62d [btrfs]
>  [<c0456f41>] ? write_cache_pages+0x180/0x287
>  [<f8ba684d>] ? __extent_writepage+0x0/0x62d [btrfs]
>  [<f8b9b079>] ? btrfs_writepages+0x0/0x1d [btrfs]
>  [<f8ba53c6>] ? extent_writepages+0x29/0x44 [btrfs]
>  [<f8b9d029>] ? btrfs_get_extent+0x0/0x70e [btrfs]
>  [<f8b9b091>] ? btrfs_writepages+0x18/0x1d [btrfs]
>  [<c0457092>] ? do_writepages+0x23/0x34
>  [<c0487ee2>] ? __writeback_single_inode+0x123/0x22a
>  [<c0488317>] ? sync_sb_inodes+0x192/0x249
>  [<c04886b0>] ? writeback_inodes+0x6a/0xb1
>  [<c0457b89>] ? pdflush+0x0/0x185
>  [<c0457784>] ? background_writeout+0x73/0x9e
>  [<c0457c7b>] ? pdflush+0xf2/0x185
>  [<c0457711>] ? background_writeout+0x0/0x9e
>  [<c0434145>] ? kthread+0x3b/0x62
>  [<c043410a>] ? kthread+0x0/0x62
>  [<c04055ab>] ? kernel_thread_helper+0x7/0x10
>  =======================
> Code: ff 75 48 ff 75 3c ff 75 38 ff 75 44 ff 75 40 6a 00 6a 00 ff 75
> 34 ff 75 30 ff 75 0c ff 75 08 e8 84 f6 ff ff 83 c4 40 85 c0 74 04 <0f>
> 0b eb fe 8b 45 08 8b 55 0c 01 46 58 11 56 5c 8b 4d bc 01 81
> EIP: [<f8b936b3>] btrfs_alloc_extent+0xba/0x328 [btrfs] SS:ESP
> 0068:f7945c20 ---[ end trace 41a23788337ff97c ]---
