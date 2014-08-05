Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41743 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbaHEJrB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 05:47:01 -0400
Date: Tue, 5 Aug 2014 10:46:56 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Waller <peter@scraperwiki.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Stack dumps in use_block_rsv while rebalancing ("block rsv
 returned -28")
Message-ID: <20140805094656.GI31950@carfax.org.uk>
References: <CAFChkqv7WOUmYPajdJMqZ_LAeMfssUH8X8a6J_y1Xghm_Rqgiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PaC+lnGZu4KSIdY4"
In-Reply-To: <CAFChkqv7WOUmYPajdJMqZ_LAeMfssUH8X8a6J_y1Xghm_Rqgiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PaC+lnGZu4KSIdY4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 10:34:13AM +0100, Peter Waller wrote:
> I already posted this in the thread "ENOSPC with mkdir and rename",
> but now I have a device with 100GB unallocated on the "btrfs fi sh"
> output, and when I run a rebalance of the form:
> 
> > btrfs filesystem balance start -dusage=50 -musage=10 "$mount"
> 
> I get more than 75 of such stack traces contaminating the klog. I've
> put some of them up in a gist here:
> https://gist.github.com/pwaller/1df8a7efc2f10343f2e3 and one of them
> is reproduced below.
> 
> Is this harmful or expected? Are there any workarounds?

   It's a warning, not an oops, so it's less immediately dangerous.
The other key thing is "block rsv returned -28", which says it's an
ENOSPC. My guess would be that you've got ENOSPC debugging enabled in
the kernel, and that the backtraces, while scary, are essentially
harmless (if irritating).

   Hugo.

> Thanks,
> 
> - Peter
> 
> [376007.681938] ------------[ cut here ]------------
> [376007.681957] WARNING: CPU: 1 PID: 27021 at
> /home/apw/COD/linux/fs/btrfs/
> extent-tree.c:6946
> use_block_rsv+0xfd/0x1a0 [btrfs]()
> [376007.681958] BTRFS: block rsv returned -28
> [376007.681959] Modules linked in: softdog tcp_diag inet_diag dm_crypt
> ppdev xen_fbfront fb_sys_fops syscopyarea sysfillrect sysimgblt
> i2c_piix4 serio_raw parport_pc parport mac_hid isofs xt_tcpudp
> iptable_filter xt_owner ip_tables x_tables btrfs xor raid6_pq
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel
> aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd floppy psmouse
> [376007.681980] CPU: 1 PID: 27021 Comm: pam_script_ses_ Tainted: G
>    W     3.15.7-031507-generic #201407281235
> [376007.681981] Hardware name: Xen HVM domU, BIOS 4.2.amazon 05/23/2014
> [376007.681983]  0000000000001b22 ffff8800acca39d8 ffffffff8176f115
> 0000000000000007
> [376007.681986]  ffff8800acca3a28 ffff8800acca3a18 ffffffff8106ceac
> ffff8801efc37870
> [376007.681989]  ffff88017db0ff00 ffff8801aedcd800 0000000000001000
> ffff88001c987000
> [376007.681992] Call Trace:
> [376007.682000]  [<ffffffff8176f115>] dump_stack+0x46/0x58
> [376007.682005]  [<ffffffff8106ceac>] warn_slowpath_common+0x8c/0xc0
> [376007.682008]  [<ffffffff8106cf96>] warn_slowpath_fmt+0x46/0x50
> [376007.682016]  [<ffffffffa00d9d1d>] use_block_rsv+0xfd/0x1a0 [btrfs]
> [376007.682024]  [<ffffffffa00de687>] btrfs_alloc_free_block+0x57/0x220 [btrfs]
> [376007.682027]  [<ffffffff8178033c>] ? __do_page_fault+0x28c/0x550
> [376007.682031]  [<ffffffff8119749f>] ? page_add_file_rmap+0x6f/0xb0
> [376007.682037]  [<ffffffffa00c8a3c>] btrfs_copy_root+0xfc/0x2b0 [btrfs]
> [376007.682041]  [<ffffffff811c60b9>] ? memcg_check_events+0x29/0x50
> [376007.682051]  [<ffffffffa013a583>] ? create_reloc_root+0x33/0x2c0 [btrfs]
> [376007.682061]  [<ffffffffa013a743>] create_reloc_root+0x1f3/0x2c0 [btrfs]
> [376007.682064]  [<ffffffff811dd073>] ? generic_permission+0xf3/0x120
> [376007.682073]  [<ffffffffa0140eb8>] btrfs_init_reloc_root+0xb8/0xd0 [btrfs]
> [376007.682082]  [<ffffffffa00ee967>]
> record_root_in_trans.part.30+0x97/0x100 [btrfs]
> [376007.682090]  [<ffffffffa00ee9f4>] record_root_in_trans+0x24/0x30 [btrfs]
> [376007.682098]  [<ffffffffa00efeb1>]
> btrfs_record_root_in_trans+0x51/0x80 [btrfs]
> [376007.682106]  [<ffffffffa00f13d6>]
> start_transaction.part.35+0x86/0x560 [btrfs]
> [376007.682109]  [<ffffffff8132c197>] ? apparmor_capable+0x27/0x80
> [376007.682117]  [<ffffffffa00f18d9>] start_transaction+0x29/0x30 [btrfs]
> [376007.682125]  [<ffffffffa00f19a7>] btrfs_join_transaction+0x17/0x20 [btrfs]
> [376007.682133]  [<ffffffffa00f7fa8>] btrfs_dirty_inode+0x58/0xe0 [btrfs]
> [376007.682141]  [<ffffffffa00fcaf2>] btrfs_setattr+0xa2/0xf0 [btrfs]
> [376007.682144]  [<ffffffff811eec74>] notify_change+0x1c4/0x3b0
> [376007.682146]  [<ffffffff811dde96>] ? final_putname+0x26/0x50
> [376007.682149]  [<ffffffff811d088d>] chown_common+0x16d/0x1a0
> [376007.682153]  [<ffffffff811f2b08>] ? __mnt_want_write+0x58/0x70
> [376007.682156]  [<ffffffff811d1a8f>] SyS_fchownat+0xbf/0x100
> [376007.682159]  [<ffffffff811d1aed>] SyS_chown+0x1d/0x20
> [376007.682163]  [<ffffffff817858bf>] tracesys+0xe1/0xe6
> [376007.682165] ---[ end trace 1853311c87a5cd94 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                     --- UNIX: Italian pen maker ---                     

--PaC+lnGZu4KSIdY4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU+CoEFheFHXiqx3kAQI7SRAAhb6zUvf/GJ+eiLX9lUYpNG2VzinSUmSR
E0nWTTsmKHycG7c8SfkZy4jaIPVZCU7GmNhfDQTQf4ZgrA/lyes3pHDhsquDdmQ3
0fWzwoszdK/XtuE6czgLGKnqcXd9azczgM2+l4DPUuCiWIcXSBiVqjoshwjTtunk
jIbgeReo2q8MFvRmj2DYFJFR2u/tjaTwB4VjpvBmZNTdTVGTEXgiupNPjx5IB7TN
lNuHuHc2rMDTNb801+tRAsr1NbgIlM1K8WbTiregOlQpztJvNGKj+u8dpOXYDN0y
HmCdi2pZYznHqTAvoHcYlJZdOxnTxzH5Hj0uUrmuv7bchrPxAo8kiQx/MyYO9XQa
2FhVc1vWpBblOzL0+DNt2slBvlMjZbIK9bZZw81jUiV/eF87HtdmWuKeOWWaI7Ij
LYGrcuCydBzdhLOYIRYKN3gsXXqRtxuksGeNbrVD8a5tpFrIB1+ryOiCi2BHxFmx
V9YG/LFKVJu4ZEHMKGGKosx/iZCOdapgjKyd9zj+FgtE1+ZLIabsFVyeUadTKKWO
h2yQgiDMM4zgml8zXS4cVHQnNq7z9A9dJw8bsqsRbiIvaGdIn9ECUbZD3e+s/EHS
eKKUtXfEoyQwkjdWiXA2s9c+7jxIJk7wFg87S4E2SUYCjSwIv7pgQhPEZLyS0+qq
fIF3TdVuysU=
=y++R
-----END PGP SIGNATURE-----

--PaC+lnGZu4KSIdY4--
