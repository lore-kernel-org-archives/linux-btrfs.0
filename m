Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33537 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3AJRQe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 12:16:34 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1TtLk1-0005sp-Jy
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 09:16:33 -0800
Date: Thu, 10 Jan 2013 09:16:33 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: remounting 5 drive array (raid0) caused a bunch of errors and prevented unmount from suceeding (stuck in wait_block_group_cache_done)
Message-ID: <20130110171633.GA18469@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a 5 drive array where the SATA port multiplier one drive was in,
crapped out.
After fixing that, and remounting the array, I got a bunch of recovery errors, including
warnings. They seem like a lot more than I should have, but maybe they're
normal/expected, maybe not (at the bottom of the mial).

THe only problem is that this puts the kernel in a state where unmounting the partition
so that I can reformat it, failed.

gargamel:/var/local/scr/host# umount /mnt/dshelf3
^C
^Z

gargamel:~# ps -eo pid,user,args,wchan | grep '[uU]mount'
25597 root     umount /mnt/dshelf3         wait_block_group_cache_done
gargamel:~# 

Interestingly, the filesystem is marked as unmounted:
gargamel:~# grep dshelf3 /proc/mounts 
gargamel:~# 

>From there, it looks like I got some kernel induced corruption because my userland
now looks sick:
gargamel:/home/samba# echo t > /proc/sysrq-trigger
gargamel:/home/samba# dmtail
*** glibc detected *** dmesg: free(): invalid next size (fast): 0x0866a9e0 ***
======= Backtrace: =========
/lib/i386-linux-gnu/i686/cmov/libc.so.6(+0x6aa81)[0xf75ffa81]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(+0x6c2e8)[0xf76012e8]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(cfree+0x6d)[0xf760439d]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(+0x281a0)[0xf75bd1a0]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(+0x260dc)[0xf75bb0dc]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(+0x25a71)[0xf75baa71]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(dcgettext+0x43)[0xf75b9913]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(__strerror_r+0x51)[0xf7607b51]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(+0x4d7b3)[0xf75e27b3]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(perror+0xb2)[0xf75e28b2] dmesg[0x8048a59]
/lib/i386-linux-gnu/i686/cmov/libc.so.6(__libc_start_main+0xe6)[0xf75abe46] dmesg[0x8048691]
======= Memory map: ========
08048000-08049000 r-xp 00000000 09:00 32                                 /bin/dmesg
08049000-0804a000 rw-p 00000000 09:00 32                                 /bin/dmesg
0864a000-0866b000 rw-p 00000000 00:00 0                                  [heap]
f7200000-f7221000 rw-p 00000000 00:00 0
f7221000-f7300000 ---p 00000000 00:00 0
f7368000-f7384000 r-xp 00000000 09:00 4870                               /lib/i386-linux-gnu/libgcc_s.so.1
f7384000-f7385000 rw-p 0001b000 09:00 4870                               /lib/i386-linux-gnu/libgcc_s.so.1
f73a4000-f7594000 r--p 00000000 09:02 264351                             /usr/lib/locale/locale-archive
f7594000-f7595000 rw-p 00000000 00:00 0
f7595000-f76e8000 r-xp 00000000 09:00 9008                               /lib/i386-linux-gnu/i686/cmov/libc-2.13.so
f76e8000-f76e9000 ---p 00153000 09:00 9008                               /lib/i386-linux-gnu/i686/cmov/libc-2.13.so
f76e9000-f76eb000 r--p 00153000 09:00 9008                               /lib/i386-linux-gnu/i686/cmov/libc-2.13.so
f76eb000-f76ec000 rw-p 00155000 09:00 9008                               /lib/i386-linux-gnu/i686/cmov/libc-2.13.so
f76ec000-f76ef000 rw-p 00000000 00:00 0
f770d000-f7710000 rw-p 00000000 00:00 0
f7710000-f7711000 r-xp 00000000 00:00 0                                  [vdso]
f7711000-f772c000 r-xp 00000000 09:00 8976                               /lib/i386-linux-gnu/ld-2.13.so
f772c000-f772d000 r--p 0001b000 09:00 8976                               /lib/i386-linux-gnu/ld-2.13.so
f772d000-f772e000 rw-p 0001c000 09:00 8976                               /lib/i386-linux-gnu/ld-2.13.so
ffe5b000-ffe7c000 rw-p 00000000 00:00 0                                  [stack]

If someone wants the output of 
gargamel:/home/samba# echo d > /proc/sysrq-trigger 
gargamel:/home/samba# echo l > /proc/sysrq-trigger 
gargamel:/home/samba# echo t > /proc/sysrq-trigger 
let me know.


This is what brtfs outputted when mounting the filesystem and causing things to go wrong:

lost page write due to I/O error on /dev/dm-8
btrfs: bdev /dev/dm-8 errs: wr 10277, rd 1, flush 0, corrupt 0, gen 0
lost page write due to I/O error on /dev/dm-8
btrfs: bdev /dev/dm-8 errs: wr 10278, rd 1, flush 0, corrupt 0, gen 0
lost page write due to I/O error on /dev/dm-8
btrfs: bdev /dev/dm-8 errs: wr 10279, rd 1, flush 0, corrupt 0, gen 0
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:125 btrfs_put_block_group+0x4a/0x63()
Hardware name: System Product Name
Modules linked in: usb_storage uas usblp binfmt_misc ppdev lp tun autofs4 kl5kusb105 ftdi_sio keyspan nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipt_REJECT xt_state xt_tcpudp xt_LOG iptable_mangle iptable_filter deflate ctr twofish_generic twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic camellia_x86_64 serpent_sse2_x86_64 lrw serpent_generic xts gf128mul blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo dm_crypt dm_mirror dm_region_hash dm_log aes_x86_64 fuse lm85 hwmon_vid dm_snapshot dm_mod iptable_nat ip_tables nf_conntrack_ftp ipt_MASQUERADE nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx snd_hda_codec_hdmi snd_hda_codec_realtek snd_cmipci gameport snd_opl3_lib snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_hda_intel snd_seq snd_hda_co
dep rc_ati_x10 snd_pcm snd_rawmidi snd_timer ati_remote snd_seq_device rc_core usbserial kvm_intel kvm snd i915 drm_kms_helper drm i2c_i801 eeepc_wmi i2c_algo_bit microcode asus_wmi sparse_keymap rfkill parport_pc xhci_hcd acpi_cpufreq pci_hotplug crc32c_intel mperf lpc_ich ghash_clmulni_intel processor wmi ehci_hcd button cryptd pcspkr fan thermal video coretemp parport i2c_core snd_page_alloc soundcore tpm_tis evdev tpm r8169 mei usbcore thermal_sys sata_sil24 tpm_bios sata_mv mii usb_common [last unloaded: kl5kusb105]
Pid: 14465, comm: umount Tainted: G        W    3.5.3-amd64-preempt-noide-20120903 #1
Call Trace:
 [<ffffffff8103d664>] warn_slowpath_common+0x7e/0x96
 [<ffffffff8103d691>] warn_slowpath_null+0x15/0x17
 [<ffffffff811caf3e>] btrfs_put_block_group+0x4a/0x63
 [<ffffffff811d1677>] btrfs_free_block_groups+0x127/0x2da
 [<ffffffff811da8ef>] close_ctree+0x1e5/0x2d4
 [<ffffffff81128dfd>] ? evict_inodes+0xed/0xfc
 [<ffffffff811bac86>] btrfs_put_super+0x14/0x16
 [<ffffffff81115e92>] generic_shutdown_super+0x54/0xd1
 [<ffffffff81115f82>] kill_anon_super+0xe/0x19
 [<ffffffff811baad1>] btrfs_kill_super+0x12/0x1e
 [<ffffffff8111604e>] deactivate_locked_super+0x21/0x52
 [<ffffffff81116bba>] deactivate_super+0x32/0x36
 [<ffffffff8112b4ca>] mntput_no_expire+0x139/0x141
 [<ffffffff8112c216>] sys_umount+0x2f8/0x32a
 [<ffffffff814aa8d3>] ? _raw_spin_lock_irq+0x20/0x24
 [<ffffffff8112c253>] sys_oldumount+0xb/0xd
 [<ffffffff814b0bc6>] sysenter_dispatch+0x7/0x21
---[ end trace fb580d6565350848 ]---

(repeated 10 times, snipped)

space_info 4 has 200734076928 free, is not full
space_info total=200798109696, used=55574528, pinned=0, reserved=4096, may_use=438272, readonly=8454144
btrfs warning page private not zero on page 6554193920
device label dshelf2 devid 1 transid 220194 /dev/dm-4
device label bigbackup devid 3 transid 78 /dev/dm-5
4263552 (dev /dev/dm-8 sector 2276624)
btrfs bad tree block start 7616421888 6554214400
btrfs: bdev /dev/dm-8 errs: wr 10279, rd 1, flush 0, corrupt 3, gen 0
btrfs read error corrected: ino 1 off 6554214400 (dev /dev/dm-8 sector 2276528)
btrfs bad tree block start 7616475136 6554267648
btrfs: bdev /dev/dm-8 errs: wr 10279, rd 1, flush 0, corrupt 4, gen 0
btrfs read error corrected: ino 1 off 6554267648 (dev /dev/dm-8 sector 2276632)
btrfs bad tree block start 7616442368 6554234880
btrfs: bdev /dev/dm-8 errs: wr 10279, rd 1, flush 0, corrupt 5, gen 0
btrfs read error corrected: ino 1 off 6554234880 (dev /dev/dm-8 sector 2276568)
btrfs bad tree block start 7616487424 6554279936
btrfs: bdev /dev/dm-8 errs: wr 10279, rd 1, flush 0, corrupt 6, gen 0
btrfs read error corrected: ino 1 off 6554279936 (dev /dev/dm-8 sector 2276656)
btrfs bad tree block start 7616479232 6554271744
btrfs: bdev /dev/dm-8 errs: wr 10279, rd 1, flush 0, corrupt 7, gen 0
btrfs read error corrected: ino 1 off 6554271744 (dev /dev/dm-8 sector 2276640)
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 0, gen 0
btrfs: bdev /dev/dm-7 errs: wr 16195, rd 7, flush 0, corrupt 0, gen 0
btrfs: bdev /dev/dm-5 errs: wr 17795, rd 0, flush 0, corrupt 0, gen 0
btrfs: bdev /dev/dm-6 errs: wr 16814, rd 0, flush 0, corrupt 0, gen 0
btrfs: bdev /dev/mapper/crypt_sdl1 errs: wr 17783, rd 0, flush 0, corrupt 0, gen 0
btrfs bad tree block start 7616507904 6554300416
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 1, gen 0
btrfs read error corrected: ino 1 off 6554300416 (dev /dev/dm-8 sector 2276696)
btrfs bad tree block start 7616512000 6554304512
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 2, gen 0
btrfs read error corrected: ino 1 off 6554304512 (dev /dev/dm-8 sector 2276704)
btrfs bad tree block start 7616425984 6554218496
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 3, gen 0
btrfs read error corrected: ino 1 off 6554218496 (dev /dev/dm-8 sector 2276536)
btrfs read error corrected: ino 1 off 6554230784 (dev /dev/dm-8 sector 2276560)
btrfs read error corrected: ino 1 off 6472060928 (dev /dev/dm-8 sector 2116072)
btrfs read error corrected: ino 1 off 6554308608 (dev /dev/dm-8 sector 2276712)
btrfs read error corrected: ino 1 off 6554251264 (dev /dev/dm-8 sector 2276600)
btrfs read error corrected: ino 1 off 6553313280 (dev /d 2276496)
btree_readpage_end_io_hook: 19 callbacks suppressed
btrfs bad tree block start 12857250491313006648 6472056832
btrfs_dev_stat_print_on_error: 19 callbacks suppressed
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 23, gen 0
btrfs bad tree block start 3761685522450378596 6472101888
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 24, gen 0
btrfs bad tree block start 17153894592407985031 6472085504
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 25, gen 0
btrfs bad tree block start 18218071396782892850 6472097792
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 26, gen 0
btrfs read error corrected: ino 1 off 6472097792 (dev /dev/dm-8 sector 2116144)
btrfs bad tree block start 17153894592407985031 6472085504
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 27, gen 0
btrfs bad tree block start 12857250491313006648 6472056832
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 28, gen 0
btrfs bad tree block start 3761685522450378596 6472101888
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 29, gen 0
btrfs bad tree block start 7165919078637720111 6472065024
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 30, gen 0
btrfs bad tree block start 697684509501546460 6472052736
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 31, gen 0
btrfs read error corrected: ino 1 off 6472065024 (dev /dev/dm-8 sector 2116080)
btrfs bad tree block start 8007453052303847987 6471864320
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 32, gen 0
btrfs read error corrected: ino 1 off 6471864320 (dev /dev/dm-8 sector 2115688)
btrfs read error corrected: ino 1 off 6472093696 (dev /dev/dm-8 sector 2116136)
btree_readpage_end_io_hook: 5 callbacks suppressed
btrfs bad tree block start 7616483328 6554275840
btrfs_dev_stat_print_on_error: 5 callbacks suppressed
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 38, gen 0
btrfs read error corrected: ino 1 off 6554275840 (dev /dev/dm-8 sector 2276648)
btrfs bad tree block start 7558873088 6496665600
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 39, gen 0
btrfs bad tree block start 7558873088 6496665600
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 40, gen 0
btrfs read error coror 2265664)
btrfs bad tree block start 7610863616 6548656128
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 45, gen 0
btrfs read error corrected: ino 1 off 6548656128 (dev /dev/dm-8 sector 2265672)
btrfs bad tree block start 7611703296 6549495808
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 46, gen 0
btrfs read error corrected: ino 1 off 6549495808 (dev /dev/dm-8 sector 2267312)
btrfs bad tree block start 7616491520 6554284032
btrfs: bdev /dev/dm-8 errs: wr 10263, rd 1, flush 0, corrupt 47, gen 0
btrfs read error corrected: ino 1 off 6554226688 (dev /dev/dm-8 sector 2276552)
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 190081662976
btrfs bad fsid on block 6472290304
btrfs bad fsid on block 6472290304
block group 195450372096 has an wrong amount of free space
btrfs: failed to load free space cache for block group 195450372096
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 200819081216
block group 206187790336 has an wrong amount of free space
btrfs: failed to load free space cache for block group 206187790336
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 211556499456
block group 216925208576 has an wrong amount of free space
btrfs: failed to load free space cache for block group 216925208576
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 222293917696
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 227662626816
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 233031335936
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 238400045056
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 243768754176
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 249137463296
btrfs: csum mismatch on free space cache
btrfs: failed to load free space cache for block group 254506172416
btrfs: failed to load free space cache for block group 259874881536
btrfs: failed to load free space cache for block group 265243590656
btrfs: failed to load free space cache for block group 270612299776
btrfs: failed to load free space cache for block group 275981008896
btrfs: failed to load free space cache for block group 281349718016
btrfs: failed to load free space cache for block group 286718427136
btrfs read error corrected: ino 1 off 6554288128 (dev /dev/dm-8 sector 2276672)
btrfs read error corrected: ino 1 off 6554292224 (dev /dev/dm-8 sector 2276680)
btrfs read error corrected: ino 1 off 6553165824 (dev /dev/dm-8 sector 2274480)
btrfs read error corrected: ino 1 off 6553169920 (dev /dev/dm-8 sector 2274488)
btrfs read error corrected: ino 1 off 6552420352 (dev /dev/dm-8 sector 2273024)
btrfs read error corrected: ino 1 off 6553329664 (dev /dev/dm-8 sector 2274800)
btrfs read error corrected: ino 1 off 6553022464 (dev /dev/dm-8 sector 2274200)
btrfs read error corrected: ino 1 off 6552453120 (dev /dev/dm-8 sector 2273088)
btrfs read error corrected: ino 1 off 6554238976 (dev /dev/dm-8 sector 2276576)
btrfs read error corrected: ino 1 off 6553608192 (dev /dev/dm-8 sector 2275344)
btrfs read error corrected: ino 1 off 6554243072 (dev /dev/dm-8 sector 2276584)



-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
