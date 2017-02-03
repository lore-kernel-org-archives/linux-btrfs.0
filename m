Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40501 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752863AbdBCWo1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 17:44:27 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZmaY-0000cC-5a
        for linux-btrfs@vger.kernel.org; Fri, 03 Feb 2017 23:44:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
Date: Fri, 3 Feb 2017 23:44:10 +0100
Message-ID: <20170203234410.7ef21de7@jupiter.sol.kaishome.de>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
        <11009787.rdtfuSitqF@thetick>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+/9PLWTWgWTOE3F.zGnGjJE"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/+/9PLWTWgWTOE3F.zGnGjJE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Thu, 02 Feb 2017 13:01:03 +0100
schrieb Marc Joliet <marcec@gmx.de>:

> On Sunday 28 August 2016 15:29:08 Kai Krakow wrote:
> > Hello list! =20
>=20
> Hi list
>=20
> > It happened again. While using VirtualBox the following crash
> > happened, btrfs check found a lot of errors which it couldn't
> > repair. Earlier that day my system crashed which may already
> > introduced errors into my filesystem. Apparently, I couldn't create
> > an image (not enough space available), I only can give this trace
> > from dmesg:
> >=20
> > [44819.903435] ------------[ cut here ]------------
> > [44819.903443] WARNING: CPU: 3 PID: 2787 at
> > fs/btrfs/extent-tree.c:2963 btrfs_run_delayed_refs+0x26c/0x290
> > [44819.903444] BTRFS: Transaction aborted (error -17)
> > [44819.903445] Modules linked in: nls_iso8859_15 nls_cp437 vfat fat
> > fuse rfcomm veth af_packet ipt_MASQUERADE nf_nat_masquerade_ipv4
> > iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> > nf_conntrack bridge stp llc w83627ehf bnep hwmon_vid cachefiles
> > btusb btintel bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek
> > snd_hda_codec_generic snd_hda_intel snd_hda_codec rfkill snd_hwdep
> > snd_hda_core snd_pcm snd_timer coretemp hwmon snd r8169 mii
> > kvm_intel kvm iTCO_wdt iTCO_vendor_support rtc_cmos irqbypass
> > soundcore ip_tables uas usb_storage nvidia_drm(PO) vboxpci(O)
> > vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_modeset(PO)
> > nvidia(PO) efivarfs unix ipv6 [44819.903484] CPU: 3 PID: 2787 Comm:
> > BrowserBlocking Tainted: P           O    4.7.2-gentoo #2
> > [44819.903485] Hardware name: To Be Filled By O.E.M. To Be Filled
> > By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013 [44819.903487]
> > 0000000000000000 ffffffff8130af2d ffff8800b7d03d20 0000000000000000
> > [44819.903489]  ffffffff810865fa ffff880409374428 ffff8800b7d03d70
> > ffff8803bf299760 [44819.903491] 0000000000000000 00000000ffffffef
> > ffff8803f677f000 ffffffff8108666a [44819.903493] Call Trace:
> > [44819.903496]  [<ffffffff8130af2d>] ? dump_stack+0x46/0x59
> > [44819.903500]  [<ffffffff810865fa>] ? __warn+0xba/0xe0
> > [44819.903502]  [<ffffffff8108666a>] ? warn_slowpath_fmt+0x4a/0x50
> > [44819.903504]  [<ffffffff8121351c>] ?
> > btrfs_run_delayed_refs+0x26c/0x290 [44819.903507]
> > [<ffffffff811feb1e>] ? btrfs_release_path+0xe/0x80 [44819.903509]
> > [<ffffffff81216afa>] ? btrfs_start_dirty_block_groups+0x2da/0x420
> > [44819.903511] [<ffffffff812279f3>] ?
> > btrfs_commit_transaction+0x143/0x990 [44819.903514]
> > [<ffffffff8116a2c5>] ? kmem_cache_free+0x165/0x180 [44819.903516]
> > [<ffffffff8124396c>] ? btrfs_wait_ordered_range+0x7c/0x110
> > [44819.903518] [<ffffffff8123ecf6>] ? btrfs_sync_file+0x286/0x360
> > [44819.903522] [<ffffffff811ae343>] ? do_fsync+0x33/0x60
> > [44819.903524]  [<ffffffff811ae57a>] ? SyS_fdatasync+0xa/0x10
> > [44819.903528]  [<ffffffff8162299b>] ?
> > entry_SYSCALL_64_fastpath+0x13/0x8f [44819.903529] ---[ end trace
> > 6944811e170a0e57 ]--- [44819.903531] BTRFS: error (device bcache2)
> > in btrfs_run_delayed_refs:2963: errno=3D-17 Object already exists
> > [44819.903533] BTRFS info (device bcache2): forced readonly =20
>=20
> I got the same error myself, with this stack trace:
>=20
> -- Logs begin at Fr 2016-04-01 17:07:28 CEST, end at Mi 2017-02-01
> 22:03:57 CET. --
> Feb 01 01:46:26 diefledermaus kernel: ------------[ cut here
> ]------------ Feb 01 01:46:26 diefledermaus kernel: WARNING: CPU: 1
> PID: 16727 at fs/btrfs/extent-tree.c:2967
> btrfs_run_delayed_refs+0x278/0x2b0 Feb 01 01:46:26 diefledermaus
> kernel: BTRFS: Transaction aborted (error -17) Feb 01 01:46:26
> diefledermaus kernel: BTRFS: error (device sdb2) in
> btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists Feb 01
> 01:46:27 diefledermaus kernel: BTRFS info (device sdb2): forced
> readonly Feb 01 01:46:27 diefledermaus kernel: Modules linked in: msr
> ctr ccm tun arc4 snd_hda_codec_idt applesmc snd_hda_codec_generic
> input_polldev hwmon snd_hda_intel ath5k snd_hda_codec mac80211
> snd_hda_core ath snd_pcm cfg80211 snd_timer video acpi_cpufreq snd
> backlight sky2 rfkill processor button soundcore sg usb_storage
> sr_mod cdrom ata_generic pata_acpi uhci_hcd ahci libahci ata_piix
> libata ehci_pci ehci_hcd Feb 01 01:46:27 diefledermaus kernel: CPU: 1
> PID: 16727 Comm: kworker/u4:0 Not tainted 4.9.6-gentoo #1
> Feb 01 01:46:27 diefledermaus kernel: Hardware name: Apple Inc.=20
> Macmini2,1/Mac-F4208EAA, BIOS     MM21.88Z.009A.B00.0706281359
> 06/28/07 Feb 01 01:46:27 diefledermaus kernel: Workqueue:
> btrfs-extent-refs btrfs_extent_refs_helper
> Feb 01 01:46:27 diefledermaus kernel:  0000000000000000
> ffffffff812cf739 ffffc9000285fd60 0000000000000000
> Feb 01 01:46:27 diefledermaus kernel:  ffffffff8104908a
> ffff8800428df1e0 ffffc9000285fdb0 0000000000000020
> Feb 01 01:46:27 diefledermaus kernel:  ffff880003c1b1b8
> ffff8800bb73e900 0000000000000000 ffffffff810490fa
> Feb 01 01:46:27 diefledermaus kernel: Call Trace:
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff812cf739>] ?=20
> dump_stack+0x46/0x5d
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8104908a>] ?
> __warn+0xba/0xe0 Feb 01 01:46:27 diefledermaus kernel:
> [<ffffffff810490fa>] ? warn_slowpath_fmt+0x4a/0x50
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff81201fa8>] ?=20
> btrfs_run_delayed_refs+0x278/0x2b0
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff81202064>] ?=20
> delayed_ref_async_start+0x84/0xa0
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8105ce76>] ?=20
> process_one_work+0x126/0x310
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8105a893>] ?=20
> pwq_activate_delayed_work+0x33/0x60
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8105d0a5>] ?=20
> worker_thread+0x45/0x450
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
> process_one_work+0x310/0x310
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8105d060>] ?=20
> process_one_work+0x310/0x310
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff8104c7e7>] ?=20
> do_group_exit+0x37/0xa0
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff81061c99>] ?=20
> kthread+0xb9/0xd0
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff81061be0>] ?=20
> kthread_park+0x50/0x50
> Feb 01 01:46:27 diefledermaus kernel:  [<ffffffff814f6252>] ?=20
> ret_from_fork+0x22/0x30
> Feb 01 01:46:27 diefledermaus kernel: ---[ end trace 5d090b8f212318e0
> ]--- Feb 01 01:46:27 diefledermaus kernel: BTRFS: error (device sdb2)
> in btrfs_run_delayed_refs:2967: errno=3D-17 Object already exists
> Feb 01 07:33:52 diefledermaus kernel: BTRFS error (device sdb2):
> parent transid verify failed on 4722283290624 wanted 283904 found
> 194340 Feb 01 07:33:52 diefledermaus kernel: BTRFS error (device
> sdb2): parent transid verify failed on 4722283290624 wanted 283904
> found 194340 Feb 01 07:33:53 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:53 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:53 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:53 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:54 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:54 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:54 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 07:33:54 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:33 diefledermaus kernel:
> verify_parent_transid: 14 callbacks suppressed
> Feb 01 09:03:34 diefledermaus kernel: BTRFS error (device sdb2):
> parent transid verify failed on 4722283290624 wanted 283904 found
> 194340 Feb 01 09:03:34 diefledermaus kernel: BTRFS error (device
> sdb2): parent transid verify failed on 4722283290624 wanted 283904
> found 194340 Feb 01 09:03:34 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:34 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:35 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:35 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:35 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:35 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:36 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:36 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel:
> verify_parent_transid: 10 callbacks suppressed
> Feb 01 09:03:39 diefledermaus kernel: BTRFS error (device sdb2):
> parent transid verify failed on 4722283290624 wanted 283904 found
> 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error (device
> sdb2): parent transid verify failed on 4722283290624 wanted 283904
> found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:03:39 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:10 diefledermaus kernel:
> verify_parent_transid: 14 callbacks suppressed
> Feb 01 09:04:10 diefledermaus kernel: BTRFS error (device sdb2):
> parent transid verify failed on 4722283290624 wanted 283904 found
> 194340 Feb 01 09:04:10 diefledermaus kernel: BTRFS error (device
> sdb2): parent transid verify failed on 4722283290624 wanted 283904
> found 194340 Feb 01 09:04:10 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:10 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:11 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:11 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:11 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:11 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:11 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:11 diefledermaus kernel: BTRFS error
> (device sdb2): parent transid verify failed on 4722283290624 wanted
> 283904 found 194340 Feb 01 09:04:19 diefledermaus kernel:
> verify_parent_transid: 14 callbacks suppressed
> Feb 01 09:04:19 diefledermaus kernel: BTRFS error (device sdb2):
> parent transid verify failed on 4722283290624 wanted 283904 found
> 194340 Feb 01 09:04:19 diefledermaus kernel: BTRFS error (device
> sdb2): parent transid verify failed on 4722283290624 wanted 283904
> found 194340 Feb 01 09:10:20 diefledermaus kernel: BTRFS error
> (device sdb2): cleaner transaction attach returned -30
> Feb 01 09:11:41 diefledermaus kernel: usb 1-6: USB disconnect, device
> number 2 Feb 01 09:11:41 diefledermaus kernel: sd 6:0:0:0: [sdb]
> Synchronizing SCSI cache
> Feb 01 09:11:41 diefledermaus kernel: sd 6:0:0:0: [sdb] Synchronize
> Cache(10) failed: Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
>=20
> (This is the entire dmesg output for that day up to that time.  The
> non-dmesg log before that is just getmail running (on a different FS)
> with the previous entries a few minutes beforehand, and afterwards
> it's just a bunch of SSH related messages from btrbk trying to
> continue the backups, followed by unrelated log entries.)
>=20
> > Since I had to get back up and running fast, I restored from
> > backup. I now bought some extra 3TB backup space and created a
> > rescue system including all tools on a USB stick, so next time it
> > happens I may be able to create an image of the broken filesystem. =20
>=20
> I wanted to create an image, but btrfs-image segfaults after a few
> seconds.
>=20
> > Btrfs --repair refused to repair the filesystem telling me something
> > about compressed extents and an unsupported case, wanting me to
> > take an image and send it to the devs. *sigh* =20
>=20
> I haven't tried a repair yet; it's a big file system, and btrfs-check
> is still running:
>=20
> # btrfs check -p /dev/sdd2
> Checking filesystem on /dev/sdd2
> UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
> parent transid verify failed on 3829276291072 wanted 224274 found
> 283858 parent transid verify failed on 3829276291072 wanted 224274
> found 283858 parent transid verify failed on 3829276291072 wanted
> 224274 found 283858 parent transid verify failed on 3829276291072
> wanted 224274 found 283858 Ignoring transid failure
> leaf parent key incorrect 3829276291072
> bad block 3829276291072
>=20
> ERROR: errors found in extent allocation tree or chunk allocation
> block group 4722282987520 has wrong amount of free space
> failed to load free space cache for block group 4722282987520
> checking free space cache [O]
> root 32018 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32089 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32091 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32092 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32107 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32189 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32190 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32191 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32265 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32266 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32409 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32410 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32411 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32412 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32413 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32631 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32632 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32633 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32634 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32635 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32636 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32718 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32732 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> checking fs roots [o]
>=20
> I know that the "file extend discount" errors are fixable from my
> previous email to this ML, but what about the rest?  From looking
> through the ML archives it seems that --repair won't be able to fix
> the transid failures.  It seems that one person had success with the
> "usebackuproot" mount option, which I haven't tried yet.
>=20
> > System is kernel 4.7.2, Gentoo Linux, latest VirtualBox stable.
> > VirtualBox was using VDI image format without nocow. I now reverted
> > back to using nocow on VDI files and hope it doesn't strike again
> > too soon. I didn't try again yet, first I need to refresh my backup
> > which takes a while.
> >=20
> > The filesystem runs on 3x SATA 1TB mraid1 draid0 through bcache in
> > writeback mode, backed by a 500GB 850 Evo - if that matters.
> >=20
> > The problem occurred during high IO on 4.7.2. I previously ran 4.6.6
> > which didn't show this problem. Part of the culprit may be that I
> > was using bfq patches - I removed them for now and went back to
> > deadline io scheduler. The bfq patches froze my system a few times
> > when I booted 4.7.2 which may already have broken my btrfs
> > (although it shouldn't, right? btrfs is transactional). Last time
> > this happened (on an earlier kernel), bfq may have been part of the
> > problem, too. So I think bfq does something to btrfs which may
> > break the fs, or at least interferes badly with the transaction as
> > otherwise it shouldn't break. You may want to run your test suites
> > with bfq also (or different io schedulers in general).
> >
> > My home partition is mounted as a subvolume:
> > /dev/bcache0 on /home type btrfs
> > (rw,noatime,compress=3Dlzo,nossd,space_cache,autodefrag,subvolid=3D261,=
subvol=3D/
> > home) =20
>=20
> The system the drive runs on is:
>=20
> % uname -a
> Linux diefledermaus 4.9.7-gentoo #1 SMP Wed Feb 1 23:52:56 CET 2017
> x86_64 Intel(R) Core(TM)2 CPU T5600 @ 1.83GHz GenuineIntel GNU/Linux
>=20
> However during the crash it was running 4.9.6-gentoo.  The system
> uses the standard CFQ scheduler, so perhaps BFQ is not at fault in
> Kai's case.
>=20
> The system I am running btrfs-check on is:
>=20
> % uname -a
> Linux thetick 4.9.6-gentoo #1 SMP PREEMPT Fri Jan 27 00:50:02 CET
> 2017 x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
> AuthenticAMD GNU/Linux
>=20
> Both have btrfs-progs 4.9:
>=20
> % /sbin/btrfs --version
> btrfs-progs v4.9
>=20
> And the file system in question:
>=20
> % sudo /sbin/btrfs fi show /dev/sdd2=20
> Label: 'MARCEC_BACKUP'  uuid:
> f97b3cda-15e8-418b-bb9b-235391ef2a38 Total devices 1 FS bytes used
> 842.50GiB devid    1 size 976.56GiB used 877.31GiB path /dev/sdd2
>=20
> The file system is mounted with
> "noatime,compress,comment=3Dsystemd.automount".

So our common denominator is only "compress". Well, and systemd and
Gentoo - but that probably doesn't count.

It looks like you're running without bcache and on a single disk.

Do you use files that should maybe better be marked nocow? (chattr
+C)... in terms like VirtualBox images or database files?

I'm running 4.9.6-gentoo also and this problem didn't happen again yet.
And I switched from deadline back to cfq (but I will probably revert
this).

I'm backing up with borgbackup to an internal drive running XFS, this
runs flawless so far and without major performance impacts.

> In my case the crash also happened during high I/O load (three btrfs-
> send/receive backups running at the same time).  If
> "usebackuproot" (now called "recovery"?) fails, then I'll just wipe
> the FS and start the backups from scratch.
>=20
> Since I would like to have that done by Saturday: is there any
> information I can provide that might help fix whatever bug(s) caused
> this?  Should I file a bug if one doesn't exist yet (I haven't
> checked yet, sorry)?
>=20
> Greetings



--=20
Regards,
Kai

Replies to list-only preferred.

--Sig_/+/9PLWTWgWTOE3F.zGnGjJE
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAliVB7oACgkQ+D7cQ/kIzAV8UACfekRDDwRRSqx8dfApi7NpDeaK
bMYAniQzMmwUPVlu/uuCxu8nJ3FPDK0j
=rxPO
-----END PGP SIGNATURE-----

--Sig_/+/9PLWTWgWTOE3F.zGnGjJE--


