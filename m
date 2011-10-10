From: dima <dolenin@parallels.com>
Subject: Corrupt file in subvolume
Date: Mon, 10 Oct 2011 02:14:26 +0000 (UTC)
Message-ID: <loom.20111010T040355-185@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Somehow my subvolume with /home got corrupted. When I booted the machine this
morning (after perfectly normal shutdown) it gave me a bunch of kernel errors. I
found out that if I comment out my /home entry in fstab, it would boot ok. So
the / is not corrupted. I then booted from the live CD and set "clear_cache" for
/home instead of "inode_cache,space_cache"

/dev/disk/by-label/btrfs-root   /       btrfs  
defaults,noatime,inode_cache,space_cache        0 0
/dev/disk/by-label/btrfs-root   /var/lib/btrfs-root     btrfs  
defaults,noatime,subvolid=0     0 0
#/dev/disk/by-label/btrfs-root  /home   btrfs  
defaults,noatime,subvol=__home-new,inode_cache,space_cache  0 0
/dev/disk/by-label/btrfs-root  /home   btrfs  
defaults,noatime,subvol=__home-new,clear_cache  0 0
/var/lib/btrfs-root/boot        /boot   none    bind    0 0

Then I could mount the /home subvolume.

I also found the corrupted file
   ? -????????? ? ?   ?        ?            ? 13.4.4.40.js

Whenever I try to access it I am getting Input/output error and the following
error in the kernel.log


Oct 10 10:38:03 yukikaze kernel: [34592.275080] parent transid verify failed on
105930436608 wanted 58565 found 134248
Oct 10 10:38:03 yukikaze kernel: [34592.275161] BUG: scheduling while atomic:
ls/2545/0x00000002
Oct 10 10:38:03 yukikaze kernel: [34592.275166] Modules linked in: ipv6 loop
usb_storage uas radeon snd_hda_codec_hdmi ttm snd_hda_codec_via drm_kms_helper
ppdev sg snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd edac_core
soundcore sp5100_tco r8169 drm firewire_ohci firewire_core i2c_algo_bit
i2c_piix4 i2c_core edac_mce_amd parport_pc shpchp parport pci_hotplug pcspkr
evdev mii serio_raw k10temp psmouse asus_atk0110 snd_page_alloc crc_itu_t wmi
button powernow_k8 processor mperf sr_mod cdrom sd_mod pata_acpi usbhid hid
ohci_hcd pata_atiixp ahci libahci libata ehci_hcd scsi_mod usbcore
Oct 10 10:38:03 yukikaze kernel: [34592.275268] Pid: 2545, comm: ls Not tainted
3.0.6-aya1 #3
Oct 10 10:38:03 yukikaze kernel: [34592.275273] Call Trace:
Oct 10 10:38:03 yukikaze kernel: [34592.275288]  [<ffffffff8143fd33>]
__schedule_bug+0x5f/0x64
Oct 10 10:38:03 yukikaze kernel: [34592.275298]  [<ffffffff81447c89>]
__schedule+0x7c9/0x980
Oct 10 10:38:03 yukikaze kernel: [34592.275310]  [<ffffffff812705e7>] ?
submit_bio+0x87/0x110
Oct 10 10:38:03 yukikaze kernel: [34592.275320]  [<ffffffff81009e29>] ?
read_tsc+0x9/0x20
Oct 10 10:38:03 yukikaze kernel: [34592.275329]  [<ffffffff8107e7bd>] ?
ktime_get_ts+0xad/0xe0
Oct 10 10:38:03 yukikaze kernel: [34592.275338]  [<ffffffff810eb550>] ?
__lock_page+0x70/0x70
Oct 10 10:38:03 yukikaze kernel: [34592.275346]  [<ffffffff8104ac6f>]
schedule+0x3f/0x60
Oct 10 10:38:03 yukikaze kernel: [34592.275354]  [<ffffffff81447fbf>]
io_schedule+0x8f/0xd0
Oct 10 10:38:03 yukikaze kernel: [34592.275362]  [<ffffffff810eb55e>]
sleep_on_page+0xe/0x20
Oct 10 10:38:03 yukikaze kernel: [34592.275370]  [<ffffffff8144876f>]
__wait_on_bit+0x5f/0x90
Oct 10 10:38:03 yukikaze kernel: [34592.275379]  [<ffffffff810eb748>]
wait_on_page_bit+0x78/0x80
Oct 10 10:38:03 yukikaze kernel: [34592.275388]  [<ffffffff81074140>] ?
autoremove_wake_function+0x40/0x40
Oct 10 10:38:03 yukikaze kernel: [34592.275397]  [<ffffffff81210902>]
read_extent_buffer_pages+0x412/0x480
Oct 10 10:38:03 yukikaze kernel: [34592.275405]  [<ffffffff811e4410>] ?
verify_parent_transid+0x240/0x240
Oct 10 10:38:03 yukikaze kernel: [34592.275414]  [<ffffffff811e529a>]
btree_read_extent_buffer_pages.isra.61+0x8a/0xc0
Oct 10 10:38:03 yukikaze kernel: [34592.275422]  [<ffffffff811e6bf1>]
read_tree_block+0x41/0x60
Oct 10 10:38:03 yukikaze kernel: [34592.275431]  [<ffffffff811cbaab>]
read_block_for_search.isra.33+0x1fb/0x500
Oct 10 10:38:03 yukikaze kernel: [34592.275439]  [<ffffffff811cb0bd>] ?
generic_bin_search.constprop.35+0x17d/0x1f0
Oct 10 10:38:03 yukikaze kernel: [34592.275447]  [<ffffffff811cb214>] ?
bin_search+0xe4/0x130
Oct 10 10:38:03 yukikaze kernel: [34592.275454]  [<ffffffff811ceb48>]
btrfs_search_slot+0x358/0x900
Oct 10 10:38:03 yukikaze kernel: [34592.275464]  [<ffffffff811e310f>]
btrfs_lookup_inode+0x2f/0xa0
Oct 10 10:38:03 yukikaze kernel: [34592.275473]  [<ffffffff811f6e38>]
btrfs_iget+0x108/0x4d0
Oct 10 10:38:03 yukikaze kernel: [34592.275482]  [<ffffffff811e0b7f>] ?
btrfs_lookup_dir_item+0xdf/0x110
Oct 10 10:38:03 yukikaze kernel: [34592.275491]  [<ffffffff811f78f3>]
btrfs_lookup_dentry+0x383/0x480
Oct 10 10:38:03 yukikaze kernel: [34592.275499]  [<ffffffff811367b9>] ?
kmem_cache_alloc+0x149/0x160
Oct 10 10:38:03 yukikaze kernel: [34592.275508]  [<ffffffff811f7a06>]
btrfs_lookup+0x16/0x30
Oct 10 10:38:03 yukikaze kernel: [34592.275515]  [<ffffffff811561d5>]
d_alloc_and_lookup+0x45/0x90
Oct 10 10:38:03 yukikaze kernel: [34592.275524]  [<ffffffff811632b5>] ?
d_lookup+0x35/0x60
Oct 10 10:38:03 yukikaze kernel: [34592.275531]  [<ffffffff81157a3e>]
do_lookup+0x29e/0x310
Oct 10 10:38:03 yukikaze kernel: [34592.275538]  [<ffffffff811586bc>]
path_lookupat+0x11c/0x700
Oct 10 10:38:03 yukikaze kernel: [34592.275546]  [<ffffffff81158cd1>]
do_path_lookup+0x31/0xc0
Oct 10 10:38:03 yukikaze kernel: [34592.275553]  [<ffffffff8115a909>]
user_path_at+0x59/0xa0
Oct 10 10:38:03 yukikaze kernel: [34592.275561]  [<ffffffff8102f8f0>] ?
do_page_fault+0x1c0/0x4d0
Oct 10 10:38:03 yukikaze kernel: [34592.275570]  [<ffffffff8114fd64>]
vfs_fstatat+0x44/0x70
Oct 10 10:38:03 yukikaze kernel: [34592.275578]  [<ffffffff810677fd>] ?
do_sigaction+0x12d/0x1f0
Oct 10 10:38:03 yukikaze kernel: [34592.275586]  [<ffffffff8114fdcb>]
vfs_stat+0x1b/0x20
Oct 10 10:38:03 yukikaze kernel: [34592.275593]  [<ffffffff8114ff0a>]
sys_newstat+0x1a/0x40
Oct 10 10:38:03 yukikaze kernel: [34592.275601]  [<ffffffff81067bcd>] ?
sys_rt_sigaction+0x8d/0xc0
Oct 10 10:38:03 yukikaze kernel: [34592.275610]  [<ffffffff8144b055>] ?
page_fault+0x25/0x30
Oct 10 10:38:03 yukikaze kernel: [34592.275617]  [<ffffffff8144b602>]
system_call_fastpath+0x16/0x1b

My question - is it possible to delete this rogue file somehow or repair it?
I tried to delete the directory that contained it, but got the same Input/output
error.

Any help is appreciated.

I need to mention that I did have the very same error about a couple of months
ago with about 30 files getting corrupt this way in my /home. I had to create a
new subvolume for /home (__home-new) and restore the missing files from backup.
When I tried to delete the corrupted subvolume it gave me a bunch of kernel
errors, but when I repeated the command, it completed ok. However, on reboot the
space from this subvolume was not recovered. I tried to balance the subvolume
after that but after a couple of hours I am getting only the note about 22
extents in my kernel.log

Oct 10 11:03:22 yukikaze kernel: [36111.396313] btrfs: found 22 extents
Oct 10 11:03:27 yukikaze kernel: [36116.922236] btrfs: found 22 extents
Oct 10 11:03:33 yukikaze kernel: [36122.922488] btrfs: found 22 extents

and no relocation messages. So I think it go stuck (

thanks
~dima

---
archlinux
Linux yukikaze 3.0.6-aya1 #3 SMP PREEMPT Sat Oct 8 19:01:41 JST 2011 x86_64 AMD
Athlon(tm) II X4 635 Processor AuthenticAMD GNU/Linux
the latest btrfs-tools

