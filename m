From: "Ken D'Ambrosio" <ken@jots.org>
Subject: btrfs/iSCSI/sparse file OOPS.
Date: Tue, 13 Oct 2009 12:40:44 -0400 (EDT)
Message-ID: <83af81d492eb76684573e83bcae78a23.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey, all.  I've tried repeatedly to get an 800 GB sparse file on a 1 TB
btrfs partition to work as an iSCSI target... and I can run fdisk on it
(and see the iSCSI disk just fine), but when I try to create a partition
and exit, it OOPSes every time.  Ubuntu, kernel 2.6.31-13-generic is the
latest I've tried.  Is this a known bug?  I've tried Googling to no avail.
 If there's anything I can do to help troubleshoot, please let me know.

Thanks!

-Ken

P.S.  FYI, tried the same thing on a reiserfs partition on the same
system, worked fine.

----------------------------- dmesg dump -------------------------------

[ 6310.208547] Loading iSCSI transport class v2.0-870.
[ 6310.229328] iscsi: registered transport (tcp)
[ 6310.273236] iscsi: registered transport (iser)
[ 6310.552757] scsi4 : iSCSI Initiator over TCP/IP
[ 6310.812801] scsi 4:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0
   PQ: 0 ANSI: 4
[ 6310.812950] sd 4:0:0:0: Attached scsi generic sg3 type 0
[ 6310.817523] sd 4:0:0:0: [sdc] 1572864000 512-byte logical blocks: (805
GB/750 GiB)
[ 6310.817743] sd 4:0:0:0: [sdc] Write Protect is off
[ 6310.817748] sd 4:0:0:0: [sdc] Mode Sense: 77 00 00 08
[ 6310.817883] sd 4:0:0:0: [sdc] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[ 6310.819622]  sdc: unknown partition table
[ 6310.822547] sd 4:0:0:0: [sdc] Attached SCSI disk
[ 6524.480833] BUG: unable to handle kernel NULL pointer dereference at
(null)
[ 6524.480840] IP: [<(null)>] (null)
[ 6524.480843] *pde = 00000000
[ 6524.480846] Oops: 0000 [#1] SMP
[ 6524.480849] last sysfs file: /sys/kernel/uevent_seqnum
[ 6524.480852] Modules linked in: ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad
ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
iscsi_trgt nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc btrfs
zlib_deflate crc32c libcrc32c snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm snd_usb_lib
snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd snd_page_alloc lp
ppdev psmouse soundcore parport_pc parport serio_raw binfmt_misc reiserfs
raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0
multipath linear fbcon tileblit font bitblit softcursor usbhid floppy tg3
i915 drm i2c_algo_bit video output intel_agp agpgart [last unloaded:
scsi_transport_iscsi]
[ 6524.480917]
[ 6524.480920] Pid: 2541, comm: istiod1 Not tainted (2.6.31-13-generic
#43-Ubuntu) HP Compaq dc5700 Small Form Factor
[ 6524.480923] EIP: 0060:[<00000000>] EFLAGS: 00010282 CPU: 0
[ 6524.480928] EIP is at 0x0
[ 6524.480930] EAX: f417be18 EBX: f964b660 ECX: 00000001 EDX: f417be9c
[ 6524.480932] ESI: f4082380 EDI: f417be18 EBP: f417beb0 ESP: f417be0c
[ 6524.480935]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 6524.480937] Process istiod1 (pid: 2541, ti=f417a000 task=f65e7110
task.ti=f417a000)
[ 6524.480939] Stack:
[ 6524.480941]  c01e28dc 00000000 00000000 00000000 00000400 00000000
00000001 ffffffff
[ 6524.480947] <0> f4082380 00000000 00000000 00000000 00000000 f65e7110
00000000 00000000
[ 6524.480954] <0> f65e7110 f65e7110 c0157970 f417be58 f417be58 00000000
00000000 f65e713c
[ 6524.480962] Call Trace:
[ 6524.480969]  [<c01e28dc>] ? do_sync_write+0xbc/0x100
[ 6524.480974]  [<c0157970>] ? autoremove_wake_function+0x0/0x40
[ 6524.480983]  [<fb3d7e8a>] ? fileio_make_request+0x11a/0x200 [iscsi_trgt]
[ 6524.480990]  [<fb3d7d70>] ? fileio_make_request+0x0/0x200 [iscsi_trgt]
[ 6524.480997]  [<fb3d011b>] ? tio_write+0x1b/0x60 [iscsi_trgt]
[ 6524.481001]  [<c0133797>] ? finish_task_switch+0x57/0xe0
[ 6524.481008]  [<fb3d8a41>] ? build_write_response+0x31/0xc0 [iscsi_trgt]
[ 6524.481012]  [<c056962c>] ? schedule+0x40c/0x730
[ 6524.481018]  [<fb3d36c3>] ? send_scsi_rsp+0x13/0xd0 [iscsi_trgt]
[ 6524.481025]  [<fb3d8944>] ? disk_execute_cmnd+0x194/0x1c0 [iscsi_trgt]
[ 6524.481031]  [<fb3d4e1e>] ? worker_thread+0xbe/0x1b0 [iscsi_trgt]
[ 6524.481035]  [<c0137ca0>] ? default_wake_function+0x0/0x10
[ 6524.481040]  [<fb3d4d60>] ? worker_thread+0x0/0x1b0 [iscsi_trgt]
[ 6524.481043]  [<c015767c>] ? kthread+0x7c/0x90
[ 6524.481046]  [<c0157600>] ? kthread+0x0/0x90
[ 6524.481050]  [<c0103f17>] ? kernel_thread_helper+0x7/0x10
[ 6524.481052] Code:  Bad EIP value.
[ 6524.481056] EIP: [<00000000>] 0x0 SS:ESP 0068:f417be0c
[ 6524.481066] CR2: 0000000000000000
[ 6524.481069] ---[ end trace 3e23029014423010 ]---
[ 6617.000088] iscsi_trgt: cmnd_abort(1149) 5c000000 1 0 42 4096 0 0
[ 6617.000093] iscsi_trgt: Abort Task (01) issued on tid:1 lun:0 by
sid:281474997486080 (Unknown Task)
[ 6617.000139] iscsi_trgt: Logical Unit Reset (05) issued on tid:1 lun:0
by sid:281474997486080 (Function Complete)
[ 6617.000200] BUG: unable to handle kernel NULL pointer dereference at
(null)
[ 6617.000205] IP: [<(null)>] (null)
[ 6617.000208] *pde = be212067
[ 6617.000211] Oops: 0000 [#2] SMP
[ 6617.000214] last sysfs file: /sys/kernel/uevent_seqnum
[ 6617.000217] Modules linked in: ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad
ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
iscsi_trgt nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc btrfs
zlib_deflate crc32c libcrc32c snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm snd_usb_lib
snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd snd_page_alloc lp
ppdev psmouse soundcore parport_pc parport serio_raw binfmt_misc reiserfs
raid10 raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 raid0
multipath linear fbcon tileblit font bitblit softcursor usbhid floppy tg3
i915 drm i2c_algo_bit video output intel_agp agpgart [last unloaded:
scsi_transport_iscsi]
[ 6617.000280]
[ 6617.000283] Pid: 2540, comm: istd1 Tainted: G      D
(2.6.31-13-generic #43-Ubuntu) HP Compaq dc5700 Small Form Factor
[ 6617.000286] EIP: 0060:[<00000000>] EFLAGS: 00010083 CPU: 0
[ 6617.000290] EIP is at 0x0
[ 6617.000292] EAX: f417bf98 EBX: f417bf98 ECX: 00000000 EDX: 00000003
[ 6617.000295] ESI: fffffff4 EDI: 00000000 EBP: f4179e48 ESP: f4179e28
[ 6617.000297]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 6617.000299] Process istd1 (pid: 2540, ti=f4178000 task=f57ab240
task.ti=f4178000)
[ 6617.000301] Stack:
[ 6617.000303]  c0129f90 00000000 00000001 00000003 f40683dc f40683d8
00000003 00000296
[ 6617.000309] <0> f4179e68 c012e777 00000000 00000000 00000001 f58157e0
f40683c0 00000033
[ 6617.000316] <0> f4179ea8 fb3d4fb3 00000000 f57ab26c c283d3e0 a3f18fc2
f4179ec0 c0136c0d
[ 6617.000324] Call Trace:
[ 6617.000330]  [<c0129f90>] ? __wake_up_common+0x40/0x70
[ 6617.000335]  [<c012e777>] ? __wake_up+0x37/0x50
[ 6617.000344]  [<fb3d4fb3>] ? wthread_queue+0x63/0x130 [iscsi_trgt]
[ 6617.000348]  [<c0136c0d>] ? update_curr+0x21d/0x230
[ 6617.000354]  [<fb3d1237>] ? iscsi_scsi_queuecmnd+0xe7/0xf0 [iscsi_trgt]
[ 6617.000360]  [<fb3d243d>] ? scsi_cmnd_exec+0x2d/0x70 [iscsi_trgt]
[ 6617.000365]  [<fb3d2a7f>] ? iscsi_cmnd_exec+0x7f/0x100 [iscsi_trgt]
[ 6617.000371]  [<fb3d0d5a>] ? cmnd_insert_hash+0xaa/0x120 [iscsi_trgt]
[ 6617.000377]  [<fb3d2bc0>] ? iscsi_session_push_cmnd+0xc0/0x1a0
[iscsi_trgt]
[ 6617.000382]  [<fb3d2d59>] ? cmnd_rx_end+0xb9/0x100 [iscsi_trgt]
[ 6617.000386]  [<c0137a47>] ? try_to_wake_up+0xf7/0x350
[ 6617.000390]  [<c056b731>] ? _spin_unlock_bh+0x11/0x20
[ 6617.000396]  [<fb3d4859>] ? recv+0x209/0x430 [iscsi_trgt]
[ 6617.000400]  [<c056b48a>] ? _spin_lock_irqsave+0x2a/0x40
[ 6617.000405]  [<fb3d4b38>] ? istd+0xb8/0x1c0 [iscsi_trgt]
[ 6617.000411]  [<fb3d4a80>] ? istd+0x0/0x1c0 [iscsi_trgt]
[ 6617.000415]  [<c015767c>] ? kthread+0x7c/0x90
[ 6617.000417]  [<c0157600>] ? kthread+0x0/0x90
[ 6617.000421]  [<c0103f17>] ? kernel_thread_helper+0x7/0x10
[ 6617.000423] Code:  Bad EIP value.
[ 6617.000427] EIP: [<00000000>] 0x0 SS:ESP 0068:f4179e28
[ 6617.000437] CR2: 0000000000000000
[ 6617.000440] ---[ end trace 3e23029014423011 ]---



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

