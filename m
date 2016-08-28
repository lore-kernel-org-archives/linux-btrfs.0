Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58260 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbcH1N34 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 09:29:56 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1be09D-0003v0-0I
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 15:29:15 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
Date: Sun, 28 Aug 2016 15:29:08 +0200
Message-ID: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list!

It happened again. While using VirtualBox the following crash happened,
btrfs check found a lot of errors which it couldn't repair. Earlier
that day my system crashed which may already introduced errors into my
filesystem. Apparently, I couldn't create an image (not enough space
available), I only can give this trace from dmesg:

[44819.903435] ------------[ cut here ]------------
[44819.903443] WARNING: CPU: 3 PID: 2787 at fs/btrfs/extent-tree.c:2963 btrfs_run_delayed_refs+0x26c/0x290
[44819.903444] BTRFS: Transaction aborted (error -17)
[44819.903445] Modules linked in: nls_iso8859_15 nls_cp437 vfat fat fuse rfcomm veth af_packet ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge stp llc w83627ehf bnep hwmon_vid cachefiles btusb btintel bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec rfkill snd_hwdep snd_hda_core snd_pcm snd_timer coretemp hwmon snd r8169 mii kvm_intel kvm iTCO_wdt iTCO_vendor_support rtc_cmos irqbypass soundcore ip_tables uas usb_storage nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO) nvidia(PO) efivarfs unix ipv6
[44819.903484] CPU: 3 PID: 2787 Comm: BrowserBlocking Tainted: P           O    4.7.2-gentoo #2
[44819.903485] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013
[44819.903487]  0000000000000000 ffffffff8130af2d ffff8800b7d03d20 0000000000000000
[44819.903489]  ffffffff810865fa ffff880409374428 ffff8800b7d03d70 ffff8803bf299760
[44819.903491]  0000000000000000 00000000ffffffef ffff8803f677f000 ffffffff8108666a
[44819.903493] Call Trace:
[44819.903496]  [<ffffffff8130af2d>] ? dump_stack+0x46/0x59
[44819.903500]  [<ffffffff810865fa>] ? __warn+0xba/0xe0
[44819.903502]  [<ffffffff8108666a>] ? warn_slowpath_fmt+0x4a/0x50
[44819.903504]  [<ffffffff8121351c>] ? btrfs_run_delayed_refs+0x26c/0x290
[44819.903507]  [<ffffffff811feb1e>] ? btrfs_release_path+0xe/0x80
[44819.903509]  [<ffffffff81216afa>] ? btrfs_start_dirty_block_groups+0x2da/0x420
[44819.903511]  [<ffffffff812279f3>] ? btrfs_commit_transaction+0x143/0x990
[44819.903514]  [<ffffffff8116a2c5>] ? kmem_cache_free+0x165/0x180
[44819.903516]  [<ffffffff8124396c>] ? btrfs_wait_ordered_range+0x7c/0x110
[44819.903518]  [<ffffffff8123ecf6>] ? btrfs_sync_file+0x286/0x360
[44819.903522]  [<ffffffff811ae343>] ? do_fsync+0x33/0x60
[44819.903524]  [<ffffffff811ae57a>] ? SyS_fdatasync+0xa/0x10
[44819.903528]  [<ffffffff8162299b>] ? entry_SYSCALL_64_fastpath+0x13/0x8f
[44819.903529] ---[ end trace 6944811e170a0e57 ]---
[44819.903531] BTRFS: error (device bcache2) in btrfs_run_delayed_refs:2963: errno=-17 Object already exists
[44819.903533] BTRFS info (device bcache2): forced readonly


Since I had to get back up and running fast, I restored from backup. I
now bought some extra 3TB backup space and created a rescue system
including all tools on a USB stick, so next time it happens I may be
able to create an image of the broken filesystem.

Btrfs --repair refused to repair the filesystem telling me something
about compressed extents and an unsupported case, wanting me to take an
image and send it to the devs. *sigh*

System is kernel 4.7.2, Gentoo Linux, latest VirtualBox stable.
VirtualBox was using VDI image format without nocow. I now reverted
back to using nocow on VDI files and hope it doesn't strike again too
soon. I didn't try again yet, first I need to refresh my backup which
takes a while.

The filesystem runs on 3x SATA 1TB mraid1 draid0 through bcache in
writeback mode, backed by a 500GB 850 Evo - if that matters.

The problem occurred during high IO on 4.7.2. I previously ran 4.6.6
which didn't show this problem. Part of the culprit may be that I was
using bfq patches - I removed them for now and went back to deadline io
scheduler. The bfq patches froze my system a few times when I booted
4.7.2 which may already have broken my btrfs (although it shouldn't,
right? btrfs is transactional). Last time this happened (on an earlier
kernel), bfq may have been part of the problem, too. So I think bfq
does something to btrfs which may break the fs, or at least interferes
badly with the transaction as otherwise it shouldn't break. You may
want to run your test suites with bfq also (or different io schedulers
in general).

My home partition is mounted as a subvolume:
/dev/bcache0 on /home type btrfs (rw,noatime,compress=lzo,nossd,space_cache,autodefrag,subvolid=261,subvol=/home)


-- 
Regards,
Kai

Replies to list-only preferred.

