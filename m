From: Chris Dunlop <chris@onthe.net.au>
Subject: WARNING: at fs/btrfs/inode.c:2143
 btrfs_orphan_commit_root+0x7f/0x9b
Date: Mon, 7 Feb 2011 17:31:02 +1100
Message-ID: <20110207063102.GD25062@onthe.net.au>
References: <20110204084808.GA3814@onthe.net.au>
 <1296830292.2408.0.camel@wido-desktop>
 <20110207062306.GB25062@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20110207062306.GB25062@onthe.net.au>
List-ID: <linux-btrfs.vger.kernel.org>

G'day,

Using Josef's btrfs-work bacae123 (+ ceph-client 9aae8faf), I
can consistently reproduce the following btrfs warning by simply
creating and starting a new btrfs-based ceph file system:

[  549.767234] ------------[ cut here ]------------
[  549.767276] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()
[  549.767305] Hardware name: System Product Name
[  549.767331] Modules linked in: loop btrfs zlib_deflate crc32c libcrc32c dm_mod tpm_tis psmouse tpm tpm_bios i2c_piix4 i2c_core shpchp pci_hotplug button processor nfs lockd nfs_acl auth_rpcgss sunrpc sd_mod ata_generic ahci libahci libata r8169 mii ohci_hcd ehci_hcd scsi_mod thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[  549.768192] Pid: 10, comm: kworker/0:1 Tainted: G        W   2.6.37-otn1-33361-ga3f5274 #3
[  549.768221] Call Trace:
[  549.768255]  [<ffffffffa0217444>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[  549.768286]  [<ffffffff81044644>] ? warn_slowpath_common+0x78/0x8d
[  549.768319]  [<ffffffffa0217444>] ? btrfs_orphan_commit_root+0x7f/0x9b [btrfs]
[  549.768354]  [<ffffffffa020cdfe>] ? commit_fs_roots+0x87/0xef [btrfs]
[  549.768388]  [<ffffffffa020da71>] ? btrfs_commit_transaction+0x342/0x60f [btrfs]
[  549.768422]  [<ffffffffa00aef5d>] ? xprt_release_xprt+0x41/0x73 [sunrpc]
[  549.768450]  [<ffffffff8105df3a>] ? autoremove_wake_function+0x0/0x2e
[  549.768480]  [<ffffffffa00ace70>] ? call_transmit+0x214/0x24f [sunrpc]
[  549.768513]  [<ffffffffa020dd50>] ? do_async_commit+0x12/0x1b [btrfs]
[  549.768541]  [<ffffffff8105903b>] ? process_one_work+0x22c/0x3a5
[  549.768574]  [<ffffffffa020dd3e>] ? do_async_commit+0x0/0x1b [btrfs]
[  549.768601]  [<ffffffff81059507>] ? worker_thread+0x1d5/0x353
[  549.768628]  [<ffffffff81059332>] ? worker_thread+0x0/0x353
[  549.768656]  [<ffffffff8105daf0>] ? kthread+0x7e/0x86
[  549.768683]  [<ffffffff8100a7e4>] ? kernel_thread_helper+0x4/0x10
[  549.768710]  [<ffffffff8105da72>] ? kthread+0x0/0x86
[  549.768737]  [<ffffffff8100a7e0>] ? kernel_thread_helper+0x0/0x10
[  549.768765] ---[ end trace 38bb7d3c072c3ca5 ]---

This or similar warnings look to have previously been reported
by others, e.g.:

2010-11-19 http://article.gmane.org/gmane.comp.file-systems.btrfs/7707/match=btrfs_orphan_commit_root
2011-01-06 http://article.gmane.org/gmane.comp.file-systems.btrfs/8512/match=btrfs_orphan_commit_root
2011-01-26 http://article.gmane.org/gmane.comp.file-systems.ceph.devel/1726/match=btrfs_orphan_commit_root

The process I use to reproduce is:

mkcephfs -v -c /etc/ceph/ceph.conf --allhosts --mkbtrfs -k /etc/ceph/keyring.bin
umount /data/osd0
/etc/init.d/ceph start 

This is using a minimal ceph.conf file:
------------------------------------------------------------
[global]
[mon]
	mon data = /data/mon$id
[mon0]
	host = b3
	mon addr = ip.ip.ip.ip:6789
[mds]
	keyring = /data/keyring.$name
[mds.b3]
	host = b3
[osd]
	osd data = /data/osd$id
[osd0]
	host = b3
	btrfs devs = /dev/sda
------------------------------------------------------------


Cheers,

Chris.
