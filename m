From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Wed, 01 Feb 2012 19:39:46 +0100
Message-ID: <fgdov8-ord.ln1@hurikhan.ath.cx>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Interestingly, the filesystem was not unmountable - system hung. After 
reisub and checking again with "btrfs scrub" no errors where reported and it 
just rsync'ed fine this time. This does not make sense to me.

In any case here's my backup script although I see nothing special with it:

#!/bin/bash
DATE=$(date +%Y%m%d-%H%M)
BASEDIR=/mnt/usb-backup
ionice -c3 -p$$
mount ${BASEDIR} && (
  [ -d "${BASEDIR}/snapshots/system-${DATE}" ] || (
    time rsync -avAXH --delete --inplace --no-whole-file --stats \
      --exclude "/proc/" \
      --exclude "/dev/" \
      --exclude "/sys/" \
      --exclude "/boot/" \
      --exclude "/media/" \
      --exclude "/mnt/" \
      / ${BASEDIR}/current/
    btrfs subvolume snapshot \
      "${BASEDIR}/current" \
      "${BASEDIR}/snapshots/system-${DATE}"
    btrfs filesystem sync "${BASEDIR}"
  )
  umount /mnt/usb-backup
)


Kai Krakow <hurikhan77+btrfs@gmail.com> schrieb:

> Just happened while writing a huge avi file to my usb3 backup disk:
> 
> [356036.596292] ------------[ cut here ]------------
> [356036.596300] kernel BUG at fs/btrfs/inode.c:1588!
> [356036.596304] invalid opcode: 0000 [#1] SMP
> [356036.596307] CPU 2
> [356036.596309] Modules linked in: vmnet(O) vmblock(O) vsock(O) vmci(O)
> vmmon(O) af_packet snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss
> snd_mixer_oss nls_iso8859_15 nls_cp437 vfat fat btusb bluetooth zram(C)
> loop snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_seq_device
> gspca_sonixj gspca_main videodev v4l2_compat_ioctl32 pcspkr i2c_i801 evdev
> unix fuse xfs nfs nfs_acl auth_rpcgss lockd sunrpc reiserfs scsi_wait_scan
> hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony
> hid_cherry hid_belkin hid_apple hid_a4tech usbhid usb_storage hid sr_mod
> cdrom sg pata_cmd64x [last unloaded: microcode]
> [356036.596346]
> [356036.596349] Pid: 28747, comm: btrfs-fixup-1 Tainted: G         C O
> 3.2.1-gentoo-r2 #1 To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3
> [356036.596355] RIP: 0010:[<ffffffff811605fe>]  [<ffffffff811605fe>]
> btrfs_writepage_fixup_worker+0xde/0x121
> [356036.596363] RSP: 0000:ffff8801e2379de0  EFLAGS: 00010246
> [356036.596366] RAX: 0000000000000000 RBX: ffffea00019b1a00 RCX:
> 0000000000000000
> [356036.596370] RDX: 0000000000000000 RSI: ffffffffffffffff RDI:
> ffff88008a1bbb40
> [356036.596373] RBP: 00000000033fd000 R08: ffff8801e2379d2c R09:
> 0000000180240024
> [356036.596377] R10: 0000000000000000 R11: bf800000bf800000 R12:
> ffff88008a1bbc10
> [356036.596380] R13: 0000000000000000 R14: ffff8801e2379df8 R15:
> 00000000033fdfff
> [356036.596384] FS:  0000000000000000(0000) GS:ffff88043fb00000(0000)
> knlGS:0000000000000000
> [356036.596387] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [356036.596391] CR2: 00007f5ef9660000 CR3: 00000003253f2000 CR4:
> 00000000000406e0
> [356036.596394] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [356036.596398] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [356036.596401] Process btrfs-fixup-1 (pid: 28747, threadinfo
> ffff8801e2378000, task ffff8802d2160650)
> [356036.596405] Stack:
> [356036.596407]  ffff88008a1bbab0 ffff88026d847540 ffffffffffffffff
> ffff88003a7c1f50
> [356036.596412]  0000000000000000 ffff88019bf62d80 ffff88019bf62dd0
> ffff88019bf62d98
> [356036.596417]  ffff88019bf62da8 ffff8802d2160650 ffff88019bf62d88
> ffffffff8117f23f
> [356036.596421] Call Trace:
> [356036.596426]  [<ffffffff8117f23f>] ? worker_loop+0x170/0x485
> [356036.596431]  [<ffffffff8117f0cf>] ? btrfs_queue_worker+0x272/0x272
> [356036.596435]  [<ffffffff8117f0cf>] ? btrfs_queue_worker+0x272/0x272
> [356036.596439]  [<ffffffff810489fb>] ? kthread+0x7a/0x82
> [356036.596445]  [<ffffffff81444634>] ? kernel_thread_helper+0x4/0x10
> [356036.596449]  [<ffffffff81048981>] ? kthread_worker_fn+0x135/0x135
> [356036.596453]  [<ffffffff81444630>] ? gs_change+0xb/0xb
> [356036.596456] Code: 00 00 4c 89 f1 48 8b 3c 24 e8 67 4f 01 00 48 89 df
> [e8
> b2 70 f2 ff ba 01 00 00 00 4c 89 ee 4c 89 e7 e8 bf 29 01 00 e9 4b ff ff ff
> <0f> 0b 41 b8 50 00 00 00 4c 89 f1 4c 89 fa 48 89 ee 48 8b 3c 24
> [356036.596478] RIP  [<ffffffff811605fe>]
> btrfs_writepage_fixup_worker+0xde/0x121
> [356036.596483]  RSP <ffff8801e2379de0>
> [356036.653626] ---[ end trace 9fa19a7644192fb6 ]---
> 
> btrfsck now finds many of these:
> 
> jupiter ~ # btrfsck /dev/sde1
> root 256 inode 12746 errors 400
> root 256 inode 12747 errors 400
> root 256 inode 12748 errors 400
> root 256 inode 12749 errors 400
> root 256 inode 17141 errors 400
> root 256 inode 219966 errors 400
> root 256 inode 224243 errors 400
> root 256 inode 225245 errors 400
> root 256 inode 225354 errors 400
> root 256 inode 290639 errors 2000
> root 256 inode 291751 errors 2000
> 
> This disk is used for nothing else then the following cycle:
> 
> 1. mount it (compress-force=gzip)
> 2. run rsync to backup my system (using cow-friendly rsync flags)
> 3. create a snapshot
> 4. unmount it
> 
> So that error must have been introduced simply by running rsync. It has
> plenty of free space (about 800 GB).
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


