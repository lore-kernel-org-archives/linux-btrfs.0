Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsrv.kern.pm ([138.201.172.171]:43628 "EHLO vsrv.kern.pm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750873AbdAaHe0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 02:34:26 -0500
Received: from authenticated-user
        by vsrv.kern.pm with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <pkern@debian.org>)
        id 1cYSvn-0001PM-Mi
        for linux-btrfs@vger.kernel.org; Tue, 31 Jan 2017 08:32:47 +0100
Subject: Re: Battling an issue with btrfs quota
To: linux-btrfs@vger.kernel.org
References: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
From: Philipp Kern <pkern@debian.org>
Message-ID: <0518f878-5827-611f-d4ed-0e56cb938141@debian.org>
Date: Tue, 31 Jan 2017 08:32:46 +0100
MIME-Version: 1.0
In-Reply-To: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3X7KWqBXEW1oKJS4WeRV7Wdvl2D7HrJk2"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3X7KWqBXEW1oKJS4WeRV7Wdvl2D7HrJk2
Content-Type: multipart/mixed; boundary="ETL9u81btR5OXBhLf7hIVUF0hGsxI9oiS";
 protected-headers="v1"
From: Philipp Kern <pkern@debian.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <0518f878-5827-611f-d4ed-0e56cb938141@debian.org>
Subject: Re: Battling an issue with btrfs quota
References: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
In-Reply-To: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>

--ETL9u81btR5OXBhLf7hIVUF0hGsxI9oiS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/31/2017 01:15 AM, Philipp Kern wrote:
[...]
>>   149 0            0 RW   [btrfs-transacti]
>=20
> So there's always a running btrfs-transaction. The kernel messages star=
t
> off like this:
[...]

At it turns out, it also OOMs the complete machine after 2h while
consuming the available 4 GB RAM (w/o swap):

> [rootfs ]# [ 6347.417391] Out of memory: Kill process 228 (sh) score 0 =
or sacrifice child
> [ 6347.450652] Killed process 228 (sh) total-vm:6724kB, anon-rss:112kB,=
 file-rss:1624kB, shmem-rss:0kB
> [ 6347.500015] Kernel panic - not syncing: Out of memory and no killabl=
e processes...
> [ 6347.500015]=20
> [ 6347.544684] CPU: 0 PID: 149 Comm: btrfs-transacti Not tainted 4.9.6-=
1-ARCH #1
> [ 6347.580157] Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 07=
/16/2015
> [ 6347.614874]  ffffc90000d77738 ffffffff81305440 ffffc90000d77800 ffff=
ffff81930520
> [ 6347.651089]  ffffc90000d777c0 ffffffff8117eed5 0000000000000008 ffff=
c90000d777d0
> [ 6347.687037]  ffffc90000d77768 0000000009689dbd 0000000000000003 ffff=
8801032adcc0
> [ 6347.723589] Call Trace:
> [ 6347.735614]  [<ffffffff81305440>] dump_stack+0x63/0x83
> [ 6347.760845]  [<ffffffff8117eed5>] panic+0xe4/0x22d
> [ 6347.784187]  [<ffffffff81185e23>] out_of_memory+0x333/0x480
> [ 6347.811209]  [<ffffffff8118b4c6>] __alloc_pages_nodemask+0xda6/0xe80=

> [ 6347.842223]  [<ffffffff811df1e5>] alloc_pages_current+0x95/0x140
> [ 6347.871859]  [<ffffffff81181634>] __page_cache_alloc+0xc4/0xe0
> [ 6347.900582]  [<ffffffff81181737>] pagecache_get_page+0xe7/0x290
> [ 6347.929238]  [<ffffffffa01fa4a3>] alloc_extent_buffer+0x113/0x480 [b=
trfs]
> [ 6347.962291]  [<ffffffffa01cb670>] read_tree_block+0x20/0x60 [btrfs]
> [ 6347.992642]  [<ffffffffa01a9488>] read_block_for_search.isra.16+0x13=
8/0x300 [btrfs]
> [ 6348.030866]  [<ffffffffa01ab72e>] btrfs_search_slot+0x3be/0x9b0 [btr=
fs]
> [ 6348.063286]  [<ffffffffa023e816>] find_parent_nodes+0x116/0x14b0 [bt=
rfs]
> [ 6348.096113]  [<ffffffffa023fc6e>] __btrfs_find_all_roots+0xbe/0x130 =
[btrfs]
> [ 6348.131093]  [<ffffffffa023fd55>] btrfs_find_all_roots+0x55/0x70 [bt=
rfs]
> [ 6348.164002]  [<ffffffffa0243a78>] btrfs_qgroup_prepare_account_exten=
ts+0x58/0xa0 [btrfs]
> [ 6348.203555]  [<ffffffffa01d4344>] btrfs_commit_transaction.part.12+0=
x3e4/0xa90 [btrfs]
> [ 6348.241927]  [<ffffffff810c4200>] ? wake_atomic_t_function+0x60/0x60=

> [ 6348.273073]  [<ffffffffa01d4a2b>] btrfs_commit_transaction+0x3b/0x70=
 [btrfs]
> [ 6348.307196]  [<ffffffffa01cedcb>] transaction_kthread+0x1ab/0x1e0 [b=
trfs]
> [ 6348.340041]  [<ffffffffa01cec20>] ? btrfs_cleanup_transaction+0x570/=
0x570 [btrfs]
> [ 6348.376634]  [<ffffffff8109e8f9>] kthread+0xd9/0xf0
> [ 6348.400423]  [<ffffffff8102d752>] ? __switch_to+0x2d2/0x630
> [ 6348.428162]  [<ffffffff8109e820>] ? kthread_park+0x60/0x60
> [ 6348.455055]  [<ffffffff8160a995>] ret_from_fork+0x25/0x30
> [ 6348.481684] Kernel Offset: disabled
> [ 6348.505391] ---[ end Kernel panic - not syncing: Out of memory and n=
o killable processes...
> [ 6348.505391]=20
> Killed

Kind regards
Philipp Kern


--ETL9u81btR5OXBhLf7hIVUF0hGsxI9oiS--

--3X7KWqBXEW1oKJS4WeRV7Wdvl2D7HrJk2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFFBAEBCAAvFiEEPzuChCNsw7gPxr3/RG4lRTXQVuwFAliQPZ4RHHBrZXJuQGRl
Ymlhbi5vcmcACgkQRG4lRTXQVuxK5wf5AQQWDZP/s85j0abtUHWY5++zg/ZZPgsC
mfTE06dKAFfprqyJcv0Sndegyhzw555UE9RWMqJ4jy4CSdOiTD30XFjoeJGzftYm
H+8vy5vCsbHtfssi25u9CBiHAq0HFDElDRsUqM7U3jVZdwMzOrPartiyidoqvyrS
8d4VJOLA/fXCQMKHSHdyV/ErpU1Z6mn+VJG6zePriNLCd1dQhzXxyeHCi5dRUuSm
FqXIac5KbPMpI2O0C5jsP9mFuxmv3HR5ruhdmt4mKZzMvKwEvRfH/Uj8qI/+wVIE
66c9YQR6D+vUqU2AxPHrX58RCbIB49gTJ4o5txiUOw8n4Db6WJNZeg==
=vaL6
-----END PGP SIGNATURE-----

--3X7KWqBXEW1oKJS4WeRV7Wdvl2D7HrJk2--
