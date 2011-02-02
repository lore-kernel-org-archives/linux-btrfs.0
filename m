From: cwillu <cwillu@cwillu.com>
Subject: Re: BUG at inode.c:150 under 2.6.38rc2 + 9d4ba5: handle errors in btrfs_orphan_cleanup
Date: Wed, 2 Feb 2011 00:03:59 -0600
Message-ID: <AANLkTikC3Lk1m7BnWjA=xf53bHPzPZm9_A6d+6xXux+L@mail.gmail.com>
References: <AANLkTikhL0j5Hpq2sAN6qT30+KqWzeLB8g46NgxAfSWL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikhL0j5Hpq2sAN6qT30+KqWzeLB8g46NgxAfSWL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 1, 2011 at 11:37 PM, cwillu <cwillu@cwillu.com> wrote:
> A couple hours after a build finished involving creating and deleting
> a couple snapshots, I got the following BUG. =A0The system locked up
> completely.
>
> This is 2.6.38rc2 with btrfs from josef's master (9d4ba5: =A0Btrfs:
> handle errors in btrfs_orphan_cleanup).
>
> Original screenshot at http://imgur.com/sCinW
> Retyped from that:
>
> kernel BUG at /var/lib/dkms/btrfs/git/build/inode.c:150!
> invalid opcode: 0000 [#1] SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/block/=
sdb/uevent
> CPU 1
> Modules linked in: binfmt_misc ppdev ipt_MASQUERADE iptable_nat nf_na=
t
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
> xt_tcpudd iptable_filter ip_tables x_tables bridge stp
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
> snd_seq_device aes_x86_64 snd aes_generic soundcore dm_crypt
> asus_atk0110 lp snd_page_alloc parport raid10 raid456
> async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy
> async_tx raid1 raid0 multipath linear btrfs zlib_deflate libcrc32c
> radeon ttm drm_kms_helper drm usbhid usb_storage hid uas ahci
> i2c_algo_bit r8169 libahci pata_jmicron
>
> Pid: 17930, comm: btrfs-delalloc- Not tainted 2.6.38-020638rc2-generi=
c
> #201101220905 P5Q3/System Product Name
> RIP: 0010:[<ffffffffa0219cf8>] [<ffffffffa0219cf8>]
> insert_inline_extent+0x328/0x330 [btrfs]
> RSP: 0000:ffff88020a17bbf0 =A0EFLAGS: 00010282
> RAX: 00000000ffffffef RBX: 000000000000003f RCX: ffff88020a17a000
> RDX: 0000000000000008 RSI: ffff880000000000 RDI: ffff880185a99c38
> RBP: ffff88020a17bc80 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff88022a433800 R11: ffff88017b096a00 R12: ffff88021bfb7390
> R13: 0000000000000054 R14: 0000000000000200 R15: 0000000000000000
> FS: =A00000000000000000(0000) GS:ffff8800bfc80000(0000) knlGS:0000000=
000000000
> CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f6b5afdfc68 CR3: 000000021697c000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process btrfs-delalloc- (pid: 17930, threadinfo ffff88020a17a000, tas=
k
> ffff88022b158000)
> Stack:
> =A000000002005b09d8 0000000000000001 ffff88022a433800 0000000000000fd=
5
> =A0ffff88017b096a00 0000000000000001 ffff88022cab3d80 000000000000020=
0
> =A000000000005b09d5 000000000000006c ffff88020a17bc00 00000054a0253ff=
8
> Call Trace:
> =A0[<ffffffffa0219e21>] cow_file_range_inline+0x121/0x190 [btrfs]
> =A0[<ffffffff815a2ffe>] ? mutex_lock+0x1e/0x50
> =A0[<ffffffffa021ffb3>] compress_file_range+0x483/0x5e0 [btrfs]
> =A0[<ffffffffa0220145>] async_cow_start+0x35/0x50 [btrfs]
> =A0[<ffffffffa02419bc>] worker_loop+0x15c/0x5b0 [btrfs]
> =A0[<ffffffffa0241860>] ? worker_loop+0x0/0x5b0 [btrfs]
> =A0[<ffffffff81085147>] kthread+0x97/0xa0
> =A0[<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
> =A0[<ffffffff810850b0>] ? kthread+0x0/0xa0
> =A0[<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
> Code: f8 03 48 0f af c2 4c 89 ea 48 c1 e0 0c 48 01 f0 4a 8d 34 38 e8
> 0a b4 01 00 83 6b 1c 01 48 8b 7d 98 e8 3d 9e ef e0 e9 fc fe ff ff <0f=
>
> 0b eb fe 0f 1f 40 00 55 48 89 e5 48 83 ec 70 48 89 5d d8 4c
> RIP =A0[<ffffffffa0219cf8>] insert_inline_extent+0x328/0x330 [btrfs]
> =A0RSP <ffff88020a17bbf0>


The crash happened after a few hours idling;  last significant
workload was an experiment with my build process abusing the snapshot
facility: a base system was installed to a subvolume via debootstrap,
then 8 snapshots of that state were taken.  Things were installed to
those snapshots in parallel, and then everything was rsync'd back to
the master, after which the snapshots were deleted.  There wouldn't
have been any syncs, fsyncs or otherwise during the builds (dpkg was
run with libeatmydata, for instance).  The original subvolume would
have been ~1gb, and each snapshot grown slightly more than that, so
there would've been ~8gb worth of snapshots being deleted in the
background.

The code in question dates back to the original zlib compression
commit, and the system was running with compess=3Dlzo;  perhaps there's
some mismatch there?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
