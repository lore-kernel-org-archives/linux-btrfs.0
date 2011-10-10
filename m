From: dima <dolenin@parallels.com>
Subject: Re: Corrupt file in subvolume
Date: Mon, 10 Oct 2011 11:03:34 +0000 (UTC)
Message-ID: <loom.20111010T124733-121@post.gmane.org>
References: <loom.20111010T040355-185@post.gmane.org> <20111010103723.GE17912@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks David,

The last shutdown was clean, but I had to powercycle several times this month.
I am also mounting a swapfile via loop device, so maybe this also adds up to
instability.

The corrupt file is a firefox source file
(mozilla-central/js/src/tests/e4x/XML/13.4.4.40.js). Interesting thing that I
did not touch this file or rebuild firefox for about 3-4 days, so I do not have
any idea why it got corrupted suddenly.

When trying to remove the directory containing this file I am getting:

Oct 10 14:03:13 yukikaze kernel: [ 9836.993172] ------------[ cut here
]------------                                           
Oct 10 14:03:13 yukikaze kernel: [ 9836.993261] kernel BUG at
fs/btrfs/inode.c:3024!                                           
Oct 10 14:03:13 yukikaze kernel: [ 9836.993340] invalid opcode: 0000 [#1]
PREEMPT SMP                                          
Oct 10 14:03:13 yukikaze kernel: [ 9836.993438] CPU 0                           
                                              
Oct 10 14:03:13 yukikaze kernel: [ 9836.993474] Modules linked in: reiserfs
usb_storage uas ipv6 loop snd_hda_codec_hdmi snd_hda_codec_via sg snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_timer snd sp5100_tco i2c_piix4 radeon ttm
drm_kms_helper drm i2c_algo_bit firewire_ohci psmouse ppdev shpchp evdev
serio_raw pcspkr firewire_core pci_hotplug i2c_core edac_core soundcore
snd_page_alloc asus_atk0110 k10temp edac_mce_amd parport_pc parport crc_itu_t
r8169 mii button wmi powernow_k8 processor mperf usbhid hid sr_mod cdrom sd_mod
pata_acpi ohci_hcd ehci_hcd pata_atiixp ahci libahci libata scsi_mod usbcore    
                 
Oct 10 14:03:13 yukikaze kernel: [ 9836.994630]                                 
                                              
Oct 10 14:03:13 yukikaze kernel: [ 9836.994662] Pid: 3043, comm: rm Not tainted
3.0.6-aya1 #3 System manufacturer System Product Name/M4A785TD-V EVO            
                                                                                
            
Oct 10 14:03:13 yukikaze kernel: [ 9836.994840] RIP: 0010:[<ffffffff811f5221>] 
[<ffffffff811f5221>] btrfs_unlink+0xd1/0xe0    
Oct 10 14:03:13 yukikaze kernel: [ 9836.994983] RSP: 0018:ffff8800a616fe28 
EFLAGS: 00010282                                   
Oct 10 14:03:13 yukikaze kernel: [ 9836.995070] RAX: 00000000fffffffe RBX:
ffff8801178f6240 RCX: 000000000331d8c0              
Oct 10 14:03:13 yukikaze kernel: [ 9836.995185] RDX: 000000000331d880 RSI:
0000000000018dc0 RDI: ffffea0003d28130              
Oct 10 14:03:13 yukikaze kernel: [ 9836.995301] RBP: ffff8800a616fe58 R08:
ffffffff811c7dda R09: 0000000000000000              
Oct 10 14:03:13 yukikaze kernel: [ 9836.995416] R10: 0000000000000000 R11:
0000000000000001 R12: 00000000fffffffe              
Oct 10 14:03:13 yukikaze kernel: [ 9836.995530] R13: ffff880096fb05c8 R14:
ffff8801186ad800 R15: ffff8800426bbf88
Oct 10 14:03:13 yukikaze kernel: [ 9836.995646] FS:  00007f54a0d6e700(0000)
GS:ffff88011fc00000(0000) knlGS:0000000000000000   
Oct 10 14:03:13 yukikaze kernel: [ 9836.995777] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Oct 10 14:03:13 yukikaze kernel: [ 9836.995870] CR2: 0000000001ddf0b8 CR3:
00000001081d9000 CR4: 00000000000006f0
Oct 10 14:03:13 yukikaze kernel: [ 9836.995984] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct 10 14:03:13 yukikaze kernel: [ 9836.996099] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113] Process rm (pid: 3043,
threadinfo ffff8800a616e000, task ffff8800967e1d00)
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113] Stack:
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  0000000000000000
ffff880012f8b300 0000000000000000 ffff880096fb05c8
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  0000000000000000
0000000000000003 ffff8800a616fe88 ffffffff8115a42f
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  ffff8800a616fe88
ffff880012f8b300 ffff8800426bbf88 0000000000000000
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113] Call Trace:
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  [<ffffffff8115a42f>]
vfs_unlink+0x9f/0x110
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  [<ffffffff8115a63a>]
do_unlinkat+0x19a/0x1c0
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  [<ffffffff811496b6>] ?
filp_close+0x66/0x90
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  [<ffffffff8115b332>]
sys_unlinkat+0x22/0x40
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  [<ffffffff8144b602>]
system_call_fastpath+0x16/0x1b
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113] Code: 5d d8 4c 8b 65 e0 4c 8b 6d
e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 66 0f 1f 44 00 00 4c 89 fe 48 89 df e8 e5 cd ff
ff 85 c0 74 b8 0f 0b <0f> 0b 41 89 c4 eb c9 0f 1f 84 00 00 00 00 00 55 48 89 e5
41 57 
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113] RIP  [<ffffffff811f5221>]
btrfs_unlink+0xd1/0xe0
Oct 10 14:03:13 yukikaze kernel: [ 9836.996113]  RSP <ffff8800a616fe28>
Oct 10 14:03:13 yukikaze kernel: [ 9837.023860] ---[ end trace 771cebd6df5534bd
]---

I did btrfsck with the latest btrfs-tools

After

        item 33 key (150121906176 EXTENT_ITEM 4096) itemoff 2234 itemsize 51
                extent refs 1 gen 33099 flags 2
                tree block key (1215402 1 0) level 0
                tree block backref root 257

(i.e. very early, about 4-5 seconds after I started checking)
it gave me an error

failed to find block number 150121762816

Unless I touch this file, the FS is fully functional.
Yes, I can create a new subvolume of course, but as I mentioned before, there is
a big chance that the corrupted one will not be deleted cleanly and my disk gets
bloated even more with junk data I can do nothing about.

thanks
~dima

