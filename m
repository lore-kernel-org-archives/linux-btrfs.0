Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36232 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbcAYTqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 14:46:53 -0500
Received: by mail-io0-f175.google.com with SMTP id g73so166670201ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 11:46:52 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160125155541.GD23751@merlins.org>
References: <20160123170354.GA10113@merlins.org>
	<56A57C59.1040203@cn.fujitsu.com>
	<20160125155541.GD23751@merlins.org>
Date: Mon, 25 Jan 2016 19:46:52 +0000
Message-ID: <CAL3q7H63tfdYgDppk9WUO6S8GQXk7F9d_MSE+DkVmjDP7oAtXg@mail.gmail.com>
Subject: Re: 4.4.0: btrfs-send BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
From: Filipe Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 3:55 PM, Marc MERLIN <marc@merlins.org> wrote:
> I still have 2 more days before I can rebuild my broken filesystem.
> In the meantime, I just got this new error with 4.4

Nop, not new in 4.4. I have seen 1 report of someone hitting this with
a 4.0 kernel in the past. Not a problem with send afaics but some
inconsistent state achieved likely after adding/modifying/deleting a
xattr.

Nothing new, just send the output of btrfs-debug-tree -t <parent
snapshot id> and for the send snapshot too. Also in the function that
triggered the BUG_ON(), add a printk like the following right before
the BUG_ON() line:

if (sctx->cur_ino != sctx->cmp_key->objectid)
    printk(KERN_ERR "sctx->cur_ino = %llu, sctx->cmp_key->objectid =
%llu\n", sctx->cmp_key->objectid, sctx->cmp_key->objectid);

And see the result in dmesg/syslog.

thanks

> Actually I'm assuming it happened on the broken filesystem, but maybe
> not, it may have happened on my other non broken FS that was also doing
> btrfs send.
>
>
> static int changed_xattr(struct send_ctx *sctx,
>                          enum btrfs_compare_tree_result result)
> {
>         int ret = 0;
>
>         BUG_ON(sctx->cur_ino != sctx->cmp_key->objectid);
>
>
>
> BTRFS error (device dm-1): bdev /dev/mapper/dshelf1 errs: wr 279, rd 0, flush 0, corrupt 0, gen 0
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/send.c:5639!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype bridge tun stp llc autofs4 softdog binfmt_misc ftdi_sio nfsd nfs_acl auth_rpcgss nfs fscache lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 ip_tables nf_conntrack_ftp ipt_MASQUERADE x_tables nf_nat_masquerade_ipv4 nf_nat nf_conntrack sg st snd_pcm_oss snd_mixer_oss snd_opl3_synth snd_hda_codec_realtek snd_seq_midi_emul snd_cmipci snd_hda_codec_generic gameport snd_opl3_lib snd_hda_intel kvm_intel snd_mpu401_uart snd_seq_midi snd_hda_codec kvm snd_seq_midi_event snd_hda_core snd_seq irqbypass snd_hwdep snd_rawmidi snd_pcm snd_seq_device snd_timer tpm_infineon tpm_tis rc_ati_x10 eeepc_wmi coretemp tpm 8250_fintek asus_wmi battery intel_rapl asix pcspkr sparse_keymap libphy snd iosf_mbi ati_remote xhci_pci processor lpc_ich rfkill intel_powerclamp evdev i2c_i801 soundcore parport_pc x86_pkg_temp_thermal wmi rc_core usbnet input_leds xhci_hcd parport usbserial e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx blowfish_x86_64 blowfish_common ecb xts ansi_cprng drbg aesni_intel ablk_helper lrw gf128mul glue_helper aes_x86_64 crc32c_intel crct10dif_pclmul ehci_pci crc32_pclmul fjes ehci_hcd sata_sil24 thermal sata_mv r8169 cryptd mii usbcore fan usb_common [last unloaded: ftdi_sio]
> CPU: 1 PID: 8229 Comm: btrfs Not tainted 4.4.0-amd64-i915-volpreempt-20150421 #1
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> task: ffff880114376300 ti: ffff88011b9dc000 task.ti: ffff88011b9dc000
> RIP: 0010:[<ffffffff812b6bc9>]  [<ffffffff812b6bc9>] changed_cb+0x549/0x8bf
> RSP: 0018:ffff88011b9dfb80  EFLAGS: 00210293
> RAX: 0000000000031ea2 RBX: 0000000000000000 RCX: 0000000000031e60
> RDX: ffff88011b9dfc5e RSI: 0000000000031ea0 RDI: ffff88017ce05400
> RBP: ffff88011b9dfc00 R08: ffff88011b9dfc5e R09: 0000000000000002
> R10: 0000160000000000 R11: ffff880000000000 R12: ffff88011b9dfc5e
> R13: 0000000000000002 R14: 0000000000000576 R15: ffff88017ce05400
> FS:  00007fa7b34cf8c0(0000) GS:ffff88021e240000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000f774a000 CR3: 000000013050c000 CR4: 00000000001406e0
> Stack:
>  ffff88011b9dfc6f ffff88013570fe30 ffff88011b9dfbe8 ffff8801507e4358
>  ffff88011b9dfbf8 ffffffff81271fb0 0000000000000000 ffff8801fb21f000
>  0000000000000000 ffff88011b9dfc08 ffffffff8127b04a ffff88013570fe30
> Call Trace:
>  [<ffffffff81271fb0>] ? btrfs_get_token_32+0x7a/0xcd
>  [<ffffffff8127b04a>] ? memcmp_extent_buffer+0xce/0xea
>  [<ffffffff81242029>] btrfs_compare_trees+0x3ec/0x4fd
>  [<ffffffff812b6680>] ? process_extent+0xdaa/0xdaa
>  [<ffffffff812b77e8>] btrfs_ioctl_send+0x8a9/0xd78
>  [<ffffffff8128ad28>] btrfs_ioctl+0x191/0x2630
>  [<ffffffff8108462f>] ? update_load_avg+0x21a/0x241
>  [<ffffffff8108462f>] ? update_load_avg+0x21a/0x241
>  [<ffffffff810840bf>] ? select_task_rq_fair+0x333/0x5db
>  [<ffffffff81085a19>] ? check_preempt_wakeup+0x116/0x1c3
>  [<ffffffff8118c452>] do_vfs_ioctl+0x3a1/0x414
>  [<ffffffff810dad4a>] ? __audit_syscall_entry+0xc0/0xe4
>  [<ffffffff811940ff>] ? __fget+0x2f/0x69
>  [<ffffffff8118c51c>] SyS_ioctl+0x57/0x79
>  [<ffffffff816d94b6>] entry_SYSCALL_64_fastpath+0x16/0x75
> Code: 8d b8 5c 03 00 00 e8 fa ae ff ff eb 54 80 fa 6c 89 c3 0f 85 78 03 00 00 49 8b 97 18 01 00 00 48 8b 02 49 39 87 20 01 00 00 74 02 <0f> 0b 41 83 bf 34 01 00 00 00 0f 85 00 fe ff ff 41 83 bf 38 01
> RIP  [<ffffffff812b6bc9>] changed_cb+0x549/0x8bf
>  RSP <ffff88011b9dfb80>
> ---[ end trace 06dd4eae9dda6399 ]---
> Kernel panic - not syncing: Fatal exception
>
>
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>
> On Mon, Jan 25, 2016 at 09:37:29AM +0800, Qu Wenruo wrote:
>>
>>
>> Marc MERLIN wrote on 2016/01/23 09:03 -0800:
>> >+David, +Qu
>> >about
>> >1) kernel crash on BUG_ON
>>
>> From your code mentioned, and your second kernel warning, it's out
>> of memory.
>> Such case also happened when I was debugging in-band de-dup patches.
>>
>> Things seems that by some method, btrfs used a lot of memory for
>> dirty page caches. Maybe metadata pages.
>>
>> Normally when such case happens, VFS should trigger a sync to free
>> dirty pages, but btrfs seems to either delayed the sync due to
>> running trans or the VFS sync is already too late.
>>
>> But it's also possible that large leafsize is related to such problem.
>> The larger leafsize is, the harder to alloc continuous memory for kmalloc().
>>
>> >2) check --repair not giving good clue that
>> >"type mismatch with chunk" is unfixable, and whether it can be kind of
>> >ignored or whether your FS really needs to be recreated from scratch
>> >(many hours of work for me, and probably 2 days of clock time to rebuild
>> >and restore from backup)
>>
>> For "type mismatch" problem, it's unfixable, but as far as what we
>> know, it shouldn't cause big problem.
>>
>> If you're using old version btrfsck, then it's possible such error
>> is a false alert. Update btrfsck and try again is a good idea.
>>
>> Even if it's not a false alert, mail list says it shouldn't cause
>> huge problem, only known problems happens is related to scrub.
>> And there is already some user reporting balance can fix it,
>> although you need to balance all chunks.
>>
>> >3) say more about "root 45948 inode 204452 errors 1000, some csum missing",
>> >that they aren't being fixed, and whether they're a big deal or not.
>>
>> Personally speaking, I didn't consider it as a big problem itself.
>> If csum is missing/corrupted, btrfsck --init-csum-tree can rebuild it.
>>
>> But the root problem is more important, maybe some extent/csum tree
>> blocks are corrupted and failed to find the checksum, or kernel bugs
>> causing csum missing.
>>
>> Although, from your very first report, a lot of file extents are
>> either corrupted or in bad shape.
>> Not sure how accurate the original/repaired data is.
>>
>> >
>> >More generally I'm curious to know if check --repair will sometimes fix
>> >more things on a 2nd (or 3rd...) run than on the first one.
>>
>> It is possible that further run to fix more problems, considering
>> the already complicated fixing codes.
>> But I also consider the possibility not very high though.
>>
>> I hope I could have your latest btrfsck result to further
>> investigate what's wrong (at least what's wrong on disk).
>>
>> Thanks,
>> Qu
>>
>> >
>> >Thanks,
>> >Marc
>> >
>> >On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
>> >>On Mon, Jan 18, 2016 at 03:21:53AM +0000, Duncan wrote:
>> >>>No.  Those are monotonically increasing counts that are never
>> >>>automatically reset over the life of the filesystem.  Use ...
>> >>>
>> >>>btrfs dev stats
>> >>>
>> >>>... to display them on the commandline (vs. the kernel log at filesystem
>> >>>mount), with the -z option to reset them after display, if desired.
>> >>
>> >>It's a bit counter intuitive that check --repair doesn't reset error counts if it fixed
>> >>underlying errors, but maybe there is a good reason :)
>> >>
>> >>btrfs dev stats -z /dev/mapper/dshelf1
>> >>put everything back to 0 as you hinted, I can now watch what's going on
>> >>from here on, thanks.
>> >>
>> >>On Mon, Jan 18, 2016 at 12:45:33PM +0000, Hugo Mills wrote:
>> >>>>bad extent [8697338122240, 8697338126336), type mismatch with chunk
>> >>>>bad extent [8697338126336, 8697338130432), type mismatch with chunk
>> >>>>bad extent [8697338130432, 8697338134528), type mismatch with chunk
>> >>>
>> >>>    This is, I think, a symptom of an FS created with a broken
>> >>>mkfs.btrfs, and it needs to be re-created. Take a look for that error
>> >>>message in the mailing list archives -- there's been a few posts about
>> >>>it in the last couple of months.
>> >>
>> >>Thanks for that other hint.
>> >>It was created quite a while ago (1y+), and ran ok until I had an
>> >>unexpected crash.
>> >>If I have to rebuild it, I will, but that will take 2 days+ due to the
>> >>size and getting the backup back (well also, I'm not home for a week, so
>> >>restoring backups remotely isn't going to be fun).
>> >>
>> >>But sure enough, while it ran perfectly fine for a long time, after check --repair,
>> >>my machine is now crashing every hour or so, with the crash below.
>> >>
>> >>I had to have an older kernel due to a separate problem where PMP (sata
>> >>port multiplier) support was broken in more recent kernels.
>> >>I've just put 4.3.3 on it to see if crashes still, but either way, I thought
>> >>btrfs had gotten rid of its last BUG_ON(xxx). System should never crash
>> >>due to unexpected filesystem state on a non system partition.
>> >>
>> >>Mmmh, scratch this, here's the BUG_ON, it's a memory problem :(
>> >>fs/btrfs/ctree.c:5200
>> >>            /* save our key for returning back */
>> >>            btrfs_node_key_to_cpu(cur, &found_key, slot);
>> >>            path->slots[level] = slot;
>> >>            if (level == path->lowest_level) {
>> >>                    ret = 0;
>> >>                    goto out;
>> >>            }
>> >>            btrfs_set_path_blocking(path);
>> >>            cur = read_node_slot(root, cur, slot);
>> >>            BUG_ON(!cur); /* -ENOMEM */
>> >>
>> >>Did check --repair potentially change my FS in a way that is now making the
>> >>kernel take a lot of RAM and crash?
>> >>
>> >>
>> >>------------[ cut here ]------------
>> >>kernel BUG at fs/btrfs/ctree.c:5200!
>> >>invalid opcode: 0000 [#1] SMP
>> >>CPU: 3 PID: 29041 Comm: btrfs Tainted: G        W       4.2.5-amd64-i915-volpreempt-20150421 #4
>> >>Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>> >>task: ffff88002f8482c0 ti: ffff8800c9058000 task.ti: ffff8800c9058000
>> >>RIP: 0010:[<ffffffff81234001>]  [<ffffffff81234001>] btrfs_search_forward+0x1a6/0x24b
>> >>RSP: 0018:ffff8800c905bbc8  EFLAGS: 00010246
>> >>RAX: 0000000000000000 RBX: ffff8801494409b0 RCX: 000000000003c6c8
>> >>RDX: 0000000000000000 RSI: 000000000aa60000 RDI: fffffffffffffffb
>> >>RBP: ffff8800c905bc38 R08: 0000000001c00000 R09: 0000000000000000
>> >>R10: 0000000000aaaaaa R11: ffffffff818799e0 R12: 0000000000000000
>> >>R13: 0000000000000001 R14: 0000000000000000 R15: ffff8801494409b4
>> >>FS:  00007fa9d46848c0(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
>> >>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >>CR2: 00000000f77cd000 CR3: 0000000143780000 CR4: 00000000001406e0
>> >>Stack:
>> >>  ffff8800c9bb6050 0001880149440a18 ffff8800c905bc87 ffff8800c939a800
>> >>  0000000000000003 1a0000000000002e 84000000000000b3 000000000003c59e
>> >>  000000000000002c ffff8801494409b0 0000000000000000 ffff8800c905bce0
>> >>Call Trace:
>> >>  [<ffffffff81278ca5>] search_ioctl+0xfc/0x167
>> >>  [<ffffffff81278d6b>] btrfs_ioctl_tree_search+0x5b/0x8e
>> >>  [<ffffffff8127c6af>] btrfs_ioctl+0x396/0x232f
>> >>  [<ffffffff81123a2d>] ? get_page+0xe/0x28
>> >>  [<ffffffff81123e68>] ? __lru_cache_add+0x23/0x44
>> >>  [<ffffffff81124139>] ? lru_cache_add_active_or_unevictable+0x2d/0x6b
>> >>  [<ffffffff8113a2df>] ? set_pte_at+0x9/0xd
>> >>  [<ffffffff8113e21d>] ? handle_mm_fault+0x90e/0xe9b
>> >>  [<ffffffff8100d02b>] ? paravirt_write_msr+0xf/0x13
>> >>  [<ffffffff811814af>] do_vfs_ioctl+0x39b/0x412
>> >>  [<ffffffff810ace61>] ? current_kernel_time+0xe/0x32
>> >>  [<ffffffff810d4d5c>] ? __audit_syscall_entry+0xbe/0xe0
>> >>  [<ffffffff81181580>] SyS_ioctl+0x5a/0x7f
>> >>  [<ffffffff816b0032>] entry_SYSCALL_64_fastpath+0x16/0x75
>> >>Code: 89 47 40 44 3b ab 84 00 00 00 74 69 48 89 df e8 f7 a3 ff ff 8b 55 b8 48 8b 7d a8 4c 89 e6 e8 d8 86 ff ff 48 85 c0
>> >><0f> 0b 48 89 c7 e8 23 a7 04 00 41 8d 45 ff 41 c7 47 5c 02 00 00
>> >>RIP  [<ffffffff81234001>] btrfs_search_forward+0x1a6/0x24b
>> >>  RSP <ffff8800c905bbc8>
>> >>---[ end trace e3c37adcaa703f63 ]---
>> >>Kernel panic - not syncing: Fatal exception
>> >>Kernel Offset: disabled
>> >>drm_kms_helper: panic occurred, switching back to text console
>> >>
>> >>
>> >>
>> >>
>> >>--
>> >>"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> >>Microsoft is to operating systems ....
>> >>                                       .... what McDonalds is to gourmet cooking
>> >>Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> >>--
>> >>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> >>the body of a message to majordomo@vger.kernel.org
>> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >
>> >On Wed, Jan 20, 2016 at 08:52:39PM -0800, Marc MERLIN wrote:
>> >>On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
>> >>>Thanks for that other hint.
>> >>>It was created quite a while ago (1y+), and ran ok until I had an
>> >>>unexpected crash.
>> >>>If I have to rebuild it, I will, but that will take 2 days+ due to the
>> >>>size and getting the backup back (well also, I'm not home for a week, so
>> >>>restoring backups remotely isn't going to be fun).
>> >>>
>> >>>But sure enough, while it ran perfectly fine for a long time, after check --repair,
>> >>>my machine is now crashing every hour or so, with the crash below.
>> >>
>> >>I ran check --repair a few more times on it but it does not seem to converge.
>> >>The bad extent stuff, I understand cannot be fixed (although it's not obvious from check
>> >>--repair that they are not getting fixed).
>> >>
>> >>But how about
>> >>root 45940 inode 204450 errors 1000, some csum missing
>> >>Are those getting fixed by check --repair or are they unfixable too?
>> >>
>> >>(...)
>> >>bad extent [8697338126336, 8697338130432), type mismatch with chunk
>> >>bad extent [8697338130432, 8697338134528), type mismatch with chunk
>> >>repaired damaged extent references
>> >>
>> >>Fixed 0 roots.
>> >>cache and super generation don't match, space cache will be invalidated
>> >>rootk262 inodeo204450 errors 1000, some csum missing
>> >>root 262 inode 204452 errors 1000, some csum missing
>> >>(...)
>> >>root 45940 inode 204450 errors 1000, some csum missing
>> >>root 45940 inode 204452 errors 1000, some csum missing
>> >>root 45944 inode 204450 errors 1000, some csum missing
>> >>root 45944 inode 204452 errors 1000, some csum missing
>> >>root 45948 inode 204450 errors 1000, some csum missing
>> >>root 45948 inode 204452 errors 1000, some csum missing
>> >>checking fs roots [o]
>> >>checking csums
>> >>checking root refs
>> >>found 9826295305149 bytes used err is 0
>> >>total csum bytes: 9584154948
>> >>total tree bytes: 12201304064
>> >>total fs tree bytes: 330776576
>> >>total extent tree bytes: 498921472
>> >>btree space waste bytes: 1373183541
>> >>file data blocks allocated: 9953275256832
>> >>  referenced 9964596801536
>> >>btrfs-progs v4.3
>> >>
>> >>
>> >>Thanks,
>> >>Marc
>> >>--
>> >>"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> >>Microsoft is to operating systems ....
>> >>                                       .... what McDonalds is to gourmet cooking
>> >>Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> >>--
>> >>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> >>the body of a message to majordomo@vger.kernel.org
>> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >
>> >
>>
>>
>>
>
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
