From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Bug report, OOPs on weird conditions.. device under mdadm raid1 failed...
Date: Wed, 4 Jun 2008 01:01:27 +0100
Message-ID: <f058a9c30806031701w633a199dq5cc56b07df1b19f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a Kernel Bug report.
I must warn that this happened on bad hardware.. one disc of a md
raid1 started to fault..
my dmesg if full of these:

ata1: soft resetting port
ata1.00: configured for UDMA/33
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:20:bf:23:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 16384 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1.00: configured for UDMA/33
sd 0:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        00 00 00 00
sd 0:0:0:0: [sda] ASC=0x0 ASCQ=0x0
end_request: I/O error, dev sda, sector 9151
ata1: EH complete
sd 0:0:0:0: [sda] 240121728 512-byte hardware sectors (122942 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA

kernel is gentoo-hardened-2.6.23 on x86.

after a lot of messages like the ones above, I have this in my dmesg..
------------[ cut here ]------------
Kernel BUG at e1cd57a4 [verbose debug info unavailable]
invalid opcode: 0000 [#1]
Modules linked in: nouveau drm btrfs libcrc32c snd_pcm_oss
snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_via82xx
snd_ac97_codec snd_mpu401_uart snd_ens1370 snd_rawmidi snd_seq_device
snd_pcm snd_timer snd_ak4531_codec snd snd_page_alloc usbhid ehci_hcd
nls_cp437 vfat fat nfsd exportfs lockd auth_rpcgss sunrpc xt_multiport
xt_TCPMSS xt_tcpudp xt_mac ipt_MASQUERADE xt_state xt_limit xt_tcpmss
nf_nat_irc nf_conntrack_irc iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack iptable_filter ip_tables x_tables xfs usb_storage
parport_pc parport floppy ac97_bus soundcore via_rhine i2c_viapro
i2c_core uhci_hcd usbcore 8139cp 8139too mii bitrev crc32
CPU:    0
EIP:    0060:[<e1cd57a4>]    Not tainted VLI
EFLAGS: 00010282   (2.6.23-hardened-r4 #6)
EIP is at btrfs_commit_transaction+0x554/0x5a0 [btrfs]
eax: fffffffb   ebx: cd7ab6c8   ecx: 00000015   edx: d97ef160
esi: da159200   edi: 00000000   ebp: fffffffb   esp: c8139f34
ds: 0068   es: 0068   fs: 0000  gs: 0000  ss: 0068
Process btrfs/0 (pid: 31392, ti=c8138000 task=d7e0baa0 task.ti=c8138000)
Stack: 00000000 c330e3e4 e1cd4c14 d857159c 00000001 c8139f6c c330e3e4 ceddecc0
       00000005 00000000 d7e0baa0 c042b400 c8139f64 c8139f64 d7b94240 d7b94240
       da159200 00001d4c e1cd57f0 00000000 e1cd58a5 d85715c0 c65520c0 c0428085
Call Trace:
 [<e1cd4c14>] btrfs_defrag_root+0xd4/0xe0 [btrfs]
 [<c042b400>] autoremove_wake_function+0x0/0x50
 [<e1cd57f0>] btrfs_transaction_cleaner+0x0/0xd0 [btrfs]
 [<e1cd58a5>] btrfs_transaction_cleaner+0xb5/0xd0 [btrfs]
 [<c0428085>] run_workqueue+0x65/0xe0
 [<c042b400>] autoremove_wake_function+0x0/0x50
 [<c042889b>] worker_thread+0x9b/0xf0
 [<c042b400>] autoremove_wake_function+0x0/0x50
 [<c0428800>] worker_thread+0x0/0xf0
 [<c042b0c2>] kthread+0x42/0x70
 [<c042b080>] kthread+0x0/0x70
 [<c0404577>] kernel_thread_helper+0x7/0x10
 =======================
Code: 00 05 9c 01 00 00 e8 3c 66 97 de 8b 86 bc 00 00 00 05 90 01 00
00 e8 2c 66 97 de 89 d8 e8 e5 ef ff ff e9 1d fc ff ff 0f 0b eb fe <0f>
0b eb fe 0f 0b eb fe 0f 0b 66 90 eb fc b8 df b5 ce e1 bd 48
EIP: [<e1cd57a4>] btrfs_commit_transaction+0x554/0x5a0 [btrfs] SS:ESP
0068:c8139f34

Some time after all this... other mount points/volumes behind this
raid1 also started to fail.

ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: soft resetting port
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1: failed to recover some devices, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: soft resetting port
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1.00: limiting speed to UDMA/33:PIO3
ata1: failed to recover some devices, retrying in 5 secs
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: soft resetting port
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata1.00: disabled
ata1: EH pending after completion, repeating EH (cnt=4)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: soft resetting port
ata1: EH complete
sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sda, sector 240121552
md: super_written gets error=-5, uptodate=0
sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sda, sector 12695824
Device md1, XFS metadata write error block 0x40 in md1
sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sda, sector 130152336
I/O error in filesystem ("md1") meta-data dev md1 block 0x7003ec0
 ("xlog_iodone") error 5 buf count 5120
xfs_force_shutdown(md1,0x2) called from line 958 of file
fs/xfs/xfs_log.c.  Return address = 0xe0a91f58
Filesystem "md1": Log I/O Error Detected.  Shutting down filesystem: md1
Please umount the filesystem, and rectify the problem(s)
sd 0:0:0:0: [sda] Result: hostbyte=0x04 driverbyte=0x00
end_request: I/O error, dev sda, sector 240121552
md: super_written gets error=-5, uptodate=0

should I report this to md mantainers? .. I don't think that
propagating a disc error all the way up to the filesystems should
happen on raid1...

Kind regards...


-- 
Miguel Sousa Filipe
