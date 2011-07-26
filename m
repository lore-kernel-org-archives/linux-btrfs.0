From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs on MIPS with 16K page size
Date: Wed, 27 Jul 2011 01:46:48 +0600
Message-ID: <20110727014648.20c9bdc4@natsu>
References: <20110627010018.7133192e@natsu>
	<20110727010232.553f8480@natsu>
	<20110727013756.427c46fc@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9l.3prp9TP.M.kHqsZBfMcF"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110727013756.427c46fc@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/9l.3prp9TP.M.kHqsZBfMcF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jul 2011 01:37:56 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> On Wed, 27 Jul 2011 01:02:32 +0600
> Roman Mamedov <rm@romanrm.ru> wrote:
>=20
> > > - Can this filesystem (nodesize 16384 leafsize 16384 sectorsize 16384=
) be mounted on an
> > >   x86 system with page size of 4K at all, if I move the disk there (d=
idn't try that yet)?
>=20
> Just tried on an amd64 system, and 1) it mounts 2) an attempt to write ca=
uses a live(?)lock with flush-btrfs-11 taking 100% CPU.
> (you can disregard khubd, I had an USB device badly misbehave earlier, an=
d /dev/loop7 is not being accessed via USB anyways).

And got some more stuff in dmesg.

[975061.762564] ------------[ cut here ]------------
[975061.762610] WARNING: at fs/btrfs/inode.c:6775 btrfs_destroy_inode+0x2ab=
/0x2e0 [btrfs]()
[975061.762612] Hardware name: System Product Name
[975061.762614] Modules linked in: loop usb_storage uas xt_HL xt_DSCP xt_TC=
PMSS sit tunnel4 tun parport_pc ppdev lp parport vboxnetadp vboxnetflt ip6t=
_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_owner xt_tcpudp ip6table_mangle=
 ipt_MASQUERADE iptable_nat nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_i=
pv4 ipt_LOG ipt_REJECT iptable_mangle xt_multiport xt_state xt_limit xt_con=
ntrack nf_conntrack_ftp nf_conntrack ip6table_filter ip6_tables iptable_fil=
ter ip_tables x_tables nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 80=
21q garp stp pppoe pppox ppp_generic slhc fuse ext3 jbd aoe vboxdrv it87 hw=
mon_vid cp210x usbserial pcspkr edac_core edac_mce_amd k8temp evdev i2c_nfo=
rce2 i2c_core button asus_atk0110 processor ext4 mbcache jbd2 crc16 raid456=
 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ra=
id1 raid0 md_mod dm_mirror dm_region_hash dm_log dm_mod btrfs zlib_deflate =
crc32c libcrc32c usbhid hid r8169 sd_mod crc_t10dif pata_amd mii ahci libah=
ci sata_nv sata_mv ata_generic ohci_hcd ehci_hcd floppy libata usbcore ther=
mal e1000e fan thermal_sys scsi_mod forcedeth [last unloaded: soundcore]
[975061.762669] Pid: 48, comm: kswapd0 Tainted: G        W   3.0.0-rc6-rm1 =
#1
[975061.762671] Call Trace:
[975061.762679]  [<ffffffff8105637a>] warn_slowpath_common+0x7a/0xb0
[975061.762682]  [<ffffffff810563c5>] warn_slowpath_null+0x15/0x20
[975061.762695]  [<ffffffffa01c7f6b>] btrfs_destroy_inode+0x2ab/0x2e0 [btrf=
s]
[975061.762700]  [<ffffffff8114ca77>] destroy_inode+0x37/0x60
[975061.762703]  [<ffffffff8114cb71>] evict+0xd1/0x160
[975061.762706]  [<ffffffff8114cc36>] dispose_list+0x36/0x50
[975061.762708]  [<ffffffff8114cf5b>] shrink_icache_memory+0x16b/0x320
[975061.762713]  [<ffffffff810f28e2>] shrink_slab+0x112/0x180
[975061.762716]  [<ffffffff810f5984>] balance_pgdat+0x3c4/0x6b0
[975061.762719]  [<ffffffff810f5dee>] kswapd+0x17e/0x380
[975061.762723]  [<ffffffff81077460>] ? add_wait_queue+0x60/0x60
[975061.762726]  [<ffffffff810f5c70>] ? balance_pgdat+0x6b0/0x6b0
[975061.762728]  [<ffffffff81076bc7>] kthread+0x87/0x90
[975061.762731]  [<ffffffff81402be4>] kernel_thread_helper+0x4/0x10
[975061.762734]  [<ffffffff81076b40>] ? kthread_worker_fn+0x190/0x190
[975061.762736]  [<ffffffff81402be0>] ? gs_change+0x13/0x13
[975061.762738] ---[ end trace b186af89466d6bc9 ]---
[975061.762739] ------------[ cut here ]------------
[975061.762751] WARNING: at fs/btrfs/inode.c:6776 btrfs_destroy_inode+0x295=
/0x2e0 [btrfs]()
[975061.762752] Hardware name: System Product Name
[975061.762754] Modules linked in: loop usb_storage uas xt_HL xt_DSCP xt_TC=
PMSS sit tunnel4 tun parport_pc ppdev lp parport vboxnetadp vboxnetflt ip6t=
_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_owner xt_tcpudp ip6table_mangle=
 ipt_MASQUERADE iptable_nat nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_i=
pv4 ipt_LOG ipt_REJECT iptable_mangle xt_multiport xt_state xt_limit xt_con=
ntrack nf_conntrack_ftp nf_conntrack ip6table_filter ip6_tables iptable_fil=
ter ip_tables x_tables nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 80=
21q garp stp pppoe pppox ppp_generic slhc fuse ext3 jbd aoe vboxdrv it87 hw=
mon_vid cp210x usbserial pcspkr edac_core edac_mce_amd k8temp evdev i2c_nfo=
rce2 i2c_core button asus_atk0110 processor ext4 mbcache jbd2 crc16 raid456=
 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ra=
id1 raid0 md_mod dm_mirror dm_region_hash dm_log dm_mod btrfs zlib_deflate =
crc32c libcrc32c usbhid hid r8169 sd_mod crc_t10dif pata_amd mii ahci libah=
ci sata_nv sata_mv ata_generic ohci_hcd ehci_hcd floppy libata usbcore ther=
mal e1000e fan thermal_sys scsi_mod forcedeth [last unloaded: soundcore]
[975061.762804] Pid: 48, comm: kswapd0 Tainted: G        W   3.0.0-rc6-rm1 =
#1
[975061.762806] Call Trace:
[975061.762810]  [<ffffffff8105637a>] warn_slowpath_common+0x7a/0xb0
[975061.762812]  [<ffffffff810563c5>] warn_slowpath_null+0x15/0x20
[975061.762825]  [<ffffffffa01c7f55>] btrfs_destroy_inode+0x295/0x2e0 [btrf=
s]
[975061.762829]  [<ffffffff8114ca77>] destroy_inode+0x37/0x60
[975061.762832]  [<ffffffff8114cb71>] evict+0xd1/0x160
[975061.762834]  [<ffffffff8114cc36>] dispose_list+0x36/0x50
[975061.762837]  [<ffffffff8114cf5b>] shrink_icache_memory+0x16b/0x320
[975061.762840]  [<ffffffff810f28e2>] shrink_slab+0x112/0x180
[975061.762843]  [<ffffffff810f5984>] balance_pgdat+0x3c4/0x6b0
[975061.762846]  [<ffffffff810f5dee>] kswapd+0x17e/0x380
[975061.762849]  [<ffffffff81077460>] ? add_wait_queue+0x60/0x60
[975061.762852]  [<ffffffff810f5c70>] ? balance_pgdat+0x6b0/0x6b0
[975061.762854]  [<ffffffff81076bc7>] kthread+0x87/0x90
[975061.762857]  [<ffffffff81402be4>] kernel_thread_helper+0x4/0x10
[975061.762859]  [<ffffffff81076b40>] ? kthread_worker_fn+0x190/0x190
[975061.762861]  [<ffffffff81402be0>] ? gs_change+0x13/0x13
[975061.762863] ---[ end trace b186af89466d6bca ]---
----

"WARNING: at fs/btrfs/inode.c:6775 btrfs_destroy_inode",

void btrfs_destroy_inode(struct inode *inode)
{
	struct btrfs_ordered_extent *ordered;
	struct btrfs_root *root =3D BTRFS_I(inode)->root;

6775->	WARN_ON(!list_empty(&inode->i_dentry));
	WARN_ON(inode->i_data.nrpages);
	WARN_ON(atomic_read(&BTRFS_I(inode)->outstanding_extents));
	WARN_ON(atomic_read(&BTRFS_I(inode)->reserved_extents));




--=20
With respect,
Roman

--Sig_/9l.3prp9TP.M.kHqsZBfMcF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4vGagACgkQTLKSvz+PZwja3wCggQi5cAS0OZ0DIg9UHO4+VpSa
9UQAnRdqtEEVNO/1ajg/kvVX/+uEWfAs
=0x/1
-----END PGP SIGNATURE-----

--Sig_/9l.3prp9TP.M.kHqsZBfMcF--
