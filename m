From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: btrfs-related kernel oops due to media error
Date: Mon, 09 Jan 2012 23:35:55 +0100
Message-ID: <4F0B6BCB.80308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Vincent Vanackere <vincent.vanackere@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

One of my disks, partitioned into a single btrfs partition, is showing 
media errors. The problem is that these errors lead to kernel panic from 
btrfs - that make the filesystem unusable until reboot - and therefore 
it is very hard for me to do a full backup of the data prior to changing 
the disk.
My current kernel is 3.2.0-8-generic from Ubuntu/precise (based on linux 
3.2-final) but I quickly tested and get the same error with an older 3.1 
kernel (and I can probably reproduce it with a vanilla kernel if necessary).
I assume that the filesystem should not panic even in case of a media 
error... Is there any procedure I can follow / patch I could apply to 
salvage my data while ignoring media errors ?

logs/OOPS at the end of this mail, please let me know if more 
information is needed,

Best regards,

Vincent

-----------------------------------------------------------------------

    [  129.241636] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
    [  129.241640] ata6.00: BMDMA stat 0x24
    [  129.241643] ata6.00: failed command: READ DMA EXT
    [  129.241649] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag
    0 dma 4096 in
    [  129.241651]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0
    Emask 0x9 (media error)
    [  129.241654] ata6.00: status: { DRDY ERR }
    [  129.241656] ata6.00: error: { UNC }
    [  129.256243] ata6.00: configured for UDMA/133
    [  129.256261] ata6: EH complete
    [  131.640911] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
    [  131.640915] ata6.00: BMDMA stat 0x24
    [  131.640918] ata6.00: failed command: READ DMA EXT
    [  131.640922] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag
    0 dma 4096 in
    [  131.640923]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0
    Emask 0x9 (media error)
    [  131.640926] ata6.00: status: { DRDY ERR }
    [  131.640927] ata6.00: error: { UNC }
    [  131.656244] ata6.00: configured for UDMA/133
    [  131.656260] ata6: EH complete
    [  134.317351] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
    [  134.317355] ata6.00: BMDMA stat 0x24
    [  134.317359] ata6.00: failed command: READ DMA EXT
    [  134.317365] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag
    0 dma 4096 in
    [  134.317366]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0
    Emask 0x9 (media error)
    [  134.317369] ata6.00: status: { DRDY ERR }
    [  134.317371] ata6.00: error: { UNC }
    [  134.332234] ata6.00: configured for UDMA/133
    [  134.332248] ata6: EH complete
    [  136.894260] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
    [  136.894264] ata6.00: BMDMA stat 0x24
    [  136.894268] ata6.00: failed command: READ DMA EXT
    [  136.894274] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag
    0 dma 4096 in
    [  136.894275]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0
    Emask 0x9 (media error)
    [  136.894278] ata6.00: status: { DRDY ERR }
    [  136.894280] ata6.00: error: { UNC }
    [  136.924255] ata6.00: configured for UDMA/133
    [  136.924269] ata6: EH complete
    [  139.437990] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
    [  139.437994] ata6.00: BMDMA stat 0x24
    [  139.437998] ata6.00: failed command: READ DMA EXT
    [  139.438004] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag
    0 dma 4096 in
    [  139.438005]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0
    Emask 0x9 (media error)
    [  139.438008] ata6.00: status: { DRDY ERR }
    [  139.438010] ata6.00: error: { UNC }
    [  139.468239] ata6.00: configured for UDMA/133
    [  139.468253] ata6: EH complete
    [  141.937488] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
    [  141.937493] ata6.00: BMDMA stat 0x24
    [  141.937497] ata6.00: failed command: READ DMA EXT
    [  141.937503] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag
    0 dma 4096 in
    [  141.937504]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0
    Emask 0x9 (media error)
    [  141.937507] ata6.00: status: { DRDY ERR }
    [  141.937509] ata6.00: error: { UNC }
    [  141.952236] ata6.00: configured for UDMA/133
    [  141.952253] sd 5:0:0:0: [sdd] Unhandled sense code
    [  141.952256] sd 5:0:0:0: [sdd]  Result: hostbyte=DID_OK
    driverbyte=DRIVER_SENSE
    [  141.952260] sd 5:0:0:0: [sdd]  Sense Key : Medium Error [current]
    [descriptor]
    [  141.952264] Descriptor sense data with sense descriptors (in hex):
    [  141.952266]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
    [  141.952275]         70 2f dc 61
    [  141.952279] sd 5:0:0:0: [sdd]  Add. Sense: Unrecovered read error
    - auto reallocate failed
    [  141.952284] sd 5:0:0:0: [sdd] CDB: Read(10): 28 00 70 2f dc 5f 00
    00 08 00
    [  141.952293] end_request: I/O error, dev sdd, sector 1882184801
    [  141.952313] ata6: EH complete
    [  141.952335] BUG: unable to handle kernel NULL pointer dereference
    at           (null)
    [  141.952383] IP: [<ffffffffa018e439>]
    extent_range_uptodate+0x59/0xe0 [btrfs]
    [  141.952440] PGD 21caae067 PUD 221e55067 PMD 0
    [  141.952466] Oops: 0000 [#1] SMP
    [  141.952485] CPU 1
    [  141.952496] Modules linked in: ip6table_filter ip6_tables rfcomm
    bnep bluetooth ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
    nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM
    iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge
    stp kvm_intel kvm parport_pc ppdev nfsd nfs lockd fscache
    auth_rpcgss nfs_acl sunrpc binfmt_misc dm_crypt snd_usb_audio
    snd_usbmidi_lib joydev snd_hda_codec_realtek snd_hda_intel
    snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
    snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse
    soundcore snd_page_alloc serio_raw lp parport btrfs zlib_deflate
    libcrc32c hid_logitech ff_memless usbhid hid i915 r8169
    drm_kms_helper drm i2c_algo_bit video pata_jmicron
    [  141.952823]
    [  141.952830] Pid: 945, comm: btrfs-endio-met Not tainted
    3.2.0-8-generic #14-Ubuntu Gigabyte Technology Co., Ltd.
    G33-DS3R/G33-DS3R
    [  141.952873] RIP: 0010:[<ffffffffa018e439>]  [<ffffffffa018e439>]
    extent_range_uptodate+0x59/0xe0 [btrfs]
    [  141.952916] RSP: 0018:ffff88021ca0fde0  EFLAGS: 00010246
    [  141.952936] RAX: 0000000000000000 RBX: 000000df57385000 RCX:
    0000000000000000
    [  141.952960] RDX: 0000000000000001 RSI: 000000000df57385 RDI:
    0000000000000000
    [  141.952984] RBP: ffff88021ca0fe00 R08: 0000000000000000 R09:
    ffff8801c8065200
    [  141.953008] R10: ffff8801c8d03010 R11: 0000000000001000 R12:
    ffff8802182fc030
    [  141.953032] R13: 000000df573853ff R14: ffff88022121dc40 R15:
    ffff88022154e590
    [  141.953057] FS:  0000000000000000(0000) GS:ffff88022fc80000(0000)
    knlGS:0000000000000000
    [  141.953085] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [  141.953104] CR2: 0000000000000000 CR3: 000000021f8d9000 CR4:
    00000000000406e0
    [  141.953128] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
    0000000000000000
    [  141.953152] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
    0000000000000400
    [  141.953176] Process btrfs-endio-met (pid: 945, threadinfo
    ffff88021ca0e000, task ffff88022121dc40)
    [  141.953207] Stack:
    [  141.953215]  ffff88021ca0fdf0 ffff8801d310d638 ffff8801d2c73f00
    ffff88021f526000
    [  141.953245]  ffff88021ca0fe10 ffffffffa016824d ffff88021ca0fe40
    ffffffffa01682d6
    [  141.953275]  ffff88021ca0fe88 ffff88022154e540 ffff88021ca0fe88
    ffff88021ca0fe98
    [  141.953304] Call Trace:
    [  141.953323]  [<ffffffffa016824d>]
    bio_ready_for_csum.isra.108+0xbd/0xc0 [btrfs]
    [  141.953356]  [<ffffffffa01682d6>] end_workqueue_fn+0x86/0xa0 [btrfs]
    [  141.953388]  [<ffffffffa01974e0>] worker_loop+0xa0/0x2b0 [btrfs]
    [  141.953413]  [<ffffffff8164fb2c>] ? __schedule+0x3cc/0x6f0
    [  141.953442]  [<ffffffffa0197440>] ?
    check_pending_worker_creates.isra.2+0xf0/0xf0 [btrfs]
    [  141.953472]  [<ffffffff8108833c>] kthread+0x8c/0xa0
    [  141.953491]  [<ffffffff8165c734>] kernel_thread_helper+0x4/0x10
    [  141.953513]  [<ffffffff810882b0>] ? flush_kthread_worker+0xa0/0xa0
    [  141.953535]  [<ffffffff8165c730>] ? gs_change+0x13/0x13
    [  141.953553] Code: 01 f0 48 09 f0 a9 ff 0f 00 00 75 4e 49 39 dd b8
    01 00 00 00 72 36 0f 1f 40 00 49 8b 7c 24 18 48 89 de 48 c1 ee 0c e8
    b7 86 f8 e0 <48> 8b 10 83 e2 08 74 5f 48 89 c7 48 81 c3 00 10 00 00
    e8 40 43
    [  141.953697] RIP  [<ffffffffa018e439>]
    extent_range_uptodate+0x59/0xe0 [btrfs]
    [  141.953738]  RSP <ffff88021ca0fde0>
    [  141.953750] CR2: 0000000000000000
    [  142.018534] ---[ end trace 1d226c0f6e9b247e ]---



