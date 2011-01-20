From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Possible Kernel BUG regarding BTRFS
Date: Thu, 20 Jan 2011 12:12:17 +0000
Message-ID: <20110120121217.GA1301@carfax.org.uk>
References: <AANLkTika87_spu61JV0KcXfnhhZRtpvN4udfTYbOZ3VP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Cc: linux-kernel@vger.kernel.org,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: Sorin <sorin.cali@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTika87_spu61JV0KcXfnhhZRtpvN4udfTYbOZ3VP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(cc: btrfs list added)

On Thu, Jan 20, 2011 at 12:09:13AM -0800, Sorin wrote:
> Hardware:
> Intel Core i7, 8 GB RAM, SATA3 HDD with 3 partitions: EXT4 (/boot),
> BTRFS (/) with encrypted home folder, SWAP
> 
> OS:
> Ubuntu 10.10 Desktop 64bit, with Kernel 2.6.35-24-generic

   I would suggest trying again with 2.6.37. If you can't build it
yourself, there's a PPA at
https://launchpad.net/~kernel-ppa/+archive/ppa with recent kernels in
it.

   Hugo.

> Computer screen froze and after I rebooted I got the following error
> message: no init found. try passing init= bootarg
> I booted from Ubuntu CD and when I tried to mount the BTRFS partition,
> computer froze again.
> I disconnected the hard drive and added it to another computer (same
> hardware configuration, same Ubuntu/kernel) as a second hard drive. I
> booted this second computer from it's original hard drive and when I
> tried to mount the BTRFS partition from the second hard drive,
> computer froze again.
> I tried different utilities to test the BTRFS partition and the hard
> drive for errors and it seems that everything is fine, except I cannot
> mount it, without having the computer freeze. I tried the following
> commands: "sudo btrfsck /dev/sda2", "sudo gparted".
> 
> In order to collect some logs, I added the hard drive to the second
> computer (as a secondary hard drive), and below you can see all the
> logs from the moment I clicked on the BTRFS partition in Nautilus, in
> order to mount it. Computer froze instantly. See the logs below:
> 
> /var/log/syslog
> Jan 19 20:05:00 Desktop kernel: [ 2091.228274] device fsid
> b849836048fddcda-fdb584bb7dae7bb1 devid 1 transid 97123 /dev/sdb2
> Jan 19 20:05:00 Desktop kernel: [ 2091.228294] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000128
> Jan 19 20:05:00 Desktop kernel: [ 2091.228298] IP: []
> btrfs_test_super+0x10/0x30 [btrfs]
> Jan 19 20:05:00 Desktop kernel: [ 2091.228309] PGD 2338f8067 PUD 235875067 PMD 0
> Jan 19 20:05:00 Desktop kernel: [ 2091.228313] Oops: 0000 [#2] SMP
> Jan 19 20:05:00 Desktop kernel: [ 2091.228316] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda2/uevent
> Jan 19 20:05:00 Desktop kernel: [ 2091.228319] CPU 7
> Jan 19 20:05:00 Desktop kernel: [ 2091.228320] Modules linked in:
> btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs minix ntfs
> vfat msdos fat jfs xfs exportfs reiserfs cryptd aes_x86_64 aes_generic
> xt_multiport binfmt_misc parport_pc ppdev dm_crypt
> snd_hda_codec_atihdmi snd_hda_codec_realtek ipt_REJECT xt_comment
> xt_limit xt_tcpudp ipt_addrtype xt_state ip6table_filter ip6_tables
> nf_nat_irc snd_hda_intel nf_conntrack_irc nf_nat_ftp nf_nat
> snd_hda_codec nf_conntrack_ipv4 snd_hwdep nf_defrag_ipv4 snd_seq_midi
> snd_pcm snd_rawmidi nf_conntrack_ftp nf_conntrack snd_seq_midi_event
> iptable_filter snd_seq gspca_zc3xx gspca_main ip_tables snd_timer
> snd_seq_device x_tables psmouse videodev v4l1_compat
> v4l2_compat_ioctl32 serio_raw snd i7core_edac soundcore snd_page_alloc
> edac_core lp parport hid_apple usbhid hid radeon firewire_ohci ttm
> firewire_core drm_kms_helper crc_itu_t pata_jmicron ahci usb_storage
> r8169 libahci mii drm i2c_algo_bit
> Jan 19 20:05:00 Desktop kernel: [ 2091.228381]
> Jan 19 20:05:00 Desktop kernel: [ 2091.228384] Pid: 3248, comm: mount
> Tainted: G D 2.6.35-24-generic #42-Ubuntu MSI X58 Pro (MS-7522)
> /MS-7522
> Jan 19 20:05:00 Desktop kernel: [ 2091.228387] RIP: 0010:[] []
> btrfs_test_super+0x10/0x30 [btrfs]
> Jan 19 20:05:00 Desktop kernel: [ 2091.228395] RSP:
> 0018:ffff88023649dd18 EFLAGS: 00010283
> Jan 19 20:05:00 Desktop kernel: [ 2091.228397] RAX: 0000000000000000
> RBX: ffffffffa05cd000 RCX: ffff880236918d80
> Jan 19 20:05:00 Desktop kernel: [ 2091.228400] RDX: ffffffff81154a00
> RSI: ffff880236918d80 RDI: ffff880204a4e800
> Jan 19 20:05:00 Desktop kernel: [ 2091.228402] RBP: ffff88023649dd18
> R08: 0000000000000000 R09: 0000000000000001
> Jan 19 20:05:00 Desktop kernel: [ 2091.228404] R10: ffff880236918de8
> R11: 0000000000000010 R12: ffff880204a4e800
> Jan 19 20:05:00 Desktop kernel: [ 2091.228406] R13: ffffffffa063b250
> R14: ffff880236918d80 R15: ffffffffa063b220
> Jan 19 20:05:00 Desktop kernel: [ 2091.228409] FS:
> 00007f6abca567e0(0000) GS:ffff880001fc0000(0000)
> knlGS:0000000000000000
> Jan 19 20:05:00 Desktop kernel: [ 2091.228412] CS: 0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Jan 19 20:05:00 Desktop kernel: [ 2091.228415] CR2: 0000000000000128
> CR3: 000000023379d000 CR4: 00000000000006e0
> Jan 19 20:05:00 Desktop kernel: [ 2091.228418] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Jan 19 20:05:00 Desktop kernel: [ 2091.228421] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jan 19 20:05:00 Desktop kernel: [ 2091.228425] Process mount (pid:
> 3248, threadinfo ffff88023649c000, task ffff880234ea16e0)
> Jan 19 20:05:00 Desktop kernel: [ 2091.228427] Stack:
> Jan 19 20:05:00 Desktop kernel: [ 2091.228429] ffff88023649dd68
> ffffffff81155d52 ffffffff81154a00 0000000000000000
> Jan 19 20:05:00 Desktop kernel: [ 2091.228432] <0> ffff88023649dd68
> 0000000000000003Jan 19 20:06:12 Desktop kernel: imklog 4.2.0, log
> source = /proc/kmsg started.
> 
> /var/log/kern.log
> Jan 19 20:05:00 Desktop kernel: [ 2091.228274] device fsid
> b849836048fddcda-fdb584bb7dae7bb1 devid 1 transid 97123 /dev/sdb2
> Jan 19 20:05:00 Desktop kernel: [ 2091.228294] BUG: unable to handle
> kernel NULL pointer dereference at 0000000000000128
> Jan 19 20:05:00 Desktop kernel: [ 2091.228298] IP: []
> btrfs_test_super+0x10/0x30 [btrfs]
> Jan 19 20:05:00 Desktop kernel: [ 2091.228309] PGD 2338f8067 PUD 235875067 PMD 0
> Jan 19 20:05:00 Desktop kernel: [ 2091.228313] Oops: 0000 [#2] SMP
> Jan 19 20:05:00 Desktop kernel: [ 2091.228316] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda2/uevent
> Jan 19 20:05:00 Desktop kernel: [ 2091.228319] CPU 7
> Jan 19 20:05:00 Desktop kernel: [ 2091.228320] Modules linked in:
> btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs minix ntfs
> vfat msdos fat jfs xfs exportfs reiserfs cryptd aes_x86_64 aes_generic
> xt_multiport binfmt_misc parport_pc ppdev dm_crypt
> snd_hda_codec_atihdmi snd_hda_codec_realtek ipt_REJECT xt_comment
> xt_limit xt_tcpudp ipt_addrtype xt_state ip6table_filter ip6_tables
> nf_nat_irc snd_hda_intel nf_conntrack_irc nf_nat_ftp nf_nat
> snd_hda_codec nf_conntrack_ipv4 snd_hwdep nf_defrag_ipv4 snd_seq_midi
> snd_pcm snd_rawmidi nf_conntrack_ftp nf_conntrack snd_seq_midi_event
> iptable_filter snd_seq gspca_zc3xx gspca_main ip_tables snd_timer
> snd_seq_device x_tables psmouse videodev v4l1_compat
> v4l2_compat_ioctl32 serio_raw snd i7core_edac soundcore snd_page_alloc
> edac_core lp parport hid_apple usbhid hid radeon firewire_ohci ttm
> firewire_core drm_kms_helper crc_itu_t pata_jmicron ahci usb_storage
> r8169 libahci mii drm i2c_algo_bit
> Jan 19 20:05:00 Desktop kernel: [ 2091.228381]
> Jan 19 20:05:00 Desktop kernel: [ 2091.228384] Pid: 3248, comm: mount
> Tainted: G D 2.6.35-24-generic #42-Ubuntu MSI X58 Pro (MS-7522)
> /MS-7522
> Jan 19 20:05:00 Desktop kernel: [ 2091.228387] RIP: 0010:[] []
> btrfs_test_super+0x10/0x30 [btrfs]
> Jan 19 20:05:00 Desktop kernel: [ 2091.228395] RSP:
> 0018:ffff88023649dd18 EFLAGS: 00010283
> Jan 19 20:05:00 Desktop kernel: [ 2091.228397] RAX: 0000000000000000
> RBX: ffffffffa05cd000 RCX: ffff880236918d80
> Jan 19 20:05:00 Desktop kernel: [ 2091.228400] RDX: ffffffff81154a00
> RSI: ffff880236918d80 RDI: ffff880204a4e800
> Jan 19 20:05:00 Desktop kernel: [ 2091.228402] RBP: ffff88023649dd18
> R08: 0000000000000000 R09: 0000000000000001
> Jan 19 20:05:00 Desktop kernel: [ 2091.228404] R10: ffff880236918deJan
> 19 20:06:12 Desktop kernel: imklog 4.2.0, log source = /proc/kmsg
> started.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Someone's been throwing dead sheep down my Fun Well ---       

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOCagIKyzvlFcI40RAoY/AJwPW1OXWWZdEk2EXGLHPqYw99vYwgCdGbeG
aQcbHLzcAgyk+slu0fAw2ak=
=nqrO
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
