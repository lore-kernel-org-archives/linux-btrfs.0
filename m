Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D504C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 12:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3212220868
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 12:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfAEM6F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 5 Jan 2019 07:58:05 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:47260 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAEM6E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2019 07:58:04 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gflWc-00075g-G4; Sat, 05 Jan 2019 12:58:02 +0000
Date:   Sat, 5 Jan 2019 12:58:02 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Jos van Roosmalen <jos.v.roosmalen@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: BTRFS crash: what can I do more?
Message-ID: <20190105125802.GA330@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Jos van Roosmalen <jos.v.roosmalen@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAPQNX0RKOtnyrF-QGY4r0aKdKjFs4yO7zukwNofdc+VpjebegQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CAPQNX0RKOtnyrF-QGY4r0aKdKjFs4yO7zukwNofdc+VpjebegQ@mail.gmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 05, 2019 at 01:50:36PM +0100, Jos van Roosmalen wrote:
> Hi,
> 
> I have a problem with BTRFS. I am running Ubuntu 18.10 and after the
> problems arises, I manually compiled . Problems started to occur when
> I upgraded from 16.04 LTS to 18.04 LTS. After this happened I first
> tried to upgrade Ubuntu 18.10 and also I manually compiled the latest
> btrfs-progs v4.19.1.
> 
> As shown in the stack trace below, I get a: "BTRFS: error (device sda)
> in __btrfs_free_extent:6953: errno=-28 No space left"
> 
> What I already tried:
> 
> - btrfs filesystem resize max <mountpoint>
> - btrfs balance start <mountpoint> -dlimit=<different parameters>
> - btrfs check with lowmem option (without in runs out of memory), and
> that detected nothing (see snippet below).
> 
> Every time I did a unmount and mount, but after a time the crash occurred again.
> 
> What can I try more than only rescue everything in read only mode,
> rerun mkfs, and copy everything back?

   This sounds like the old bug in the free space cache, where the
cache got corrupted and there was apparently no free space in the FS
when there was actually loads unallocated.

   Try mounting with -oclear_cache. That should drop the broken cache
and rebuild it.

   Hugo.

> Thanks.
> 
> Info:
> 
> $:sudo btrfs fi show
> Label: none uuid: 262a8d86-279a-4f6b-8968-32e200c32255
> Total devices 1 FS bytes used 1.69TiB
> devid 1 size 7.28TiB used 1.70TiB path /dev/sda
> 
> $:sudo btrfs fi df <mntpoint>
> Data, single: total=1.47TiB, used=1.47TiB
> System, single: total=36.00MiB, used=224.00KiB
> Metadata, single: total=236.01GiB, used=223.85GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> BTRFS Check results:
> 
> [7/7] checking quota groups skipped (not enabled on this FS)
> found 1851414237184 bytes used, no error found
> total csum bytes: 1574317908
> total tree bytes: 238866268160
> total fs tree bytes: 215080239104
> total extent tree bytes: 21947711488
> btree space waste bytes: 40128587376
> file data blocks allocated: 169482145660928
> referenced 174793029906432
> 
> DMESG Stack Trace
> 
> [1676572.901657] ------------[ cut here ]------------
> [1676572.901661] BTRFS: Transaction aborted (error -28)
> [1676572.901752] WARNING: CPU: 2 PID: 22731 at
> fs/btrfs/extent-tree.c:6953 __btrfs_free_extent.isra.72+0x3ec/0xac0
> [btrfs]
> [1676572.901754] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs
> msdos jfs xfs cpuid binfmt_misc ccm ip6table_filter ip6_tables
> xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_multiport xt_conntrack
> nf_conntrack iptable_filter bpfilter dm_crypt arc4 ath9k ath9k_common
> ath9k_hw ath mac80211 ppdev intel_rapl x86_pkg_temp_thermal cfg80211
> intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel intel_cstate intel_rapl_perf
> parport_pc parport mei_me mei acpi_pad mac_hid sch_fq_codel ib_iser
> rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi
> scsi_transport_iscsi ip_tables x_tables autofs4 btrfs zstd_compress
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
> aesni_intel aes_x86_64
> [1676572.901857] crypto_simd i915 cryptd nvme i2c_algo_bit glue_helper
> drm_kms_helper i2c_i801 syscopyarea video sysfillrect sysimgblt
> fb_sys_fops ahci drm libahci nvme_core
> [1676572.901886] CPU: 2 PID: 22731 Comm: btrfs-transacti Tainted: G W
> 4.18.0-12-generic #13-Ubuntu
> [1676572.901888] Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./B250M Pro4, BIOS P1.50 02/10/2017
> [1676572.901928] RIP: 0010:__btrfs_free_extent.isra.72+0x3ec/0xac0 [btrfs]
> [1676572.901929] Code: 88 48 8b 40 50 f0 48 0f ba a8 10 ce 00 00 02 72
> 1b 41 83 fd fb 0f 84 6f c3 09 00 44 89 ee 48 c7 c7 a0 c2 77 c0 e8 56
> 6e 9c cf <0f> 0b 48 8b 7d 88 44 89 e9 ba 29 1b 00 00 48 c7 c6 40 1c 77
> c0 e8
> [1676572.902010] RSP: 0018:ffffa7b54364bbc8 EFLAGS: 00010282
> [1676572.902014] RAX: 0000000000000000 RBX: 000000ff3c38c000 RCX:
> 0000000000000006
> [1676572.902017] RDX: 0000000000000007 RSI: 0000000000000092 RDI:
> ffff95392ed164b0
> [1676572.902020] RBP: ffffa7b54364bc70 R08: 0000000000000001 R09:
> 00000000000005e0
> [1676572.902022] R10: 0000000000000004 R11: 0000000000000000 R12:
> ffff95360178d930
> [1676572.902025] R13: 00000000ffffffe4 R14: 0000000000000000 R15:
> 0000000000000002
> [1676572.902029] FS: 0000000000000000(0000) GS:ffff95392ed00000(0000)
> knlGS:0000000000000000
> [1676572.902032] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [1676572.902034] CR2: 00007fb84400f798 CR3: 00000001b9a0a002 CR4:
> 00000000003606e0
> [1676572.902037] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [1676572.902040] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [1676572.902042] Call Trace:
> [1676572.902051] ? __slab_free+0x225/0x340
> [1676572.902107] ? btrfs_merge_delayed_refs+0x31d/0x360 [btrfs]
> [1676572.902148] __btrfs_run_delayed_refs+0x20e/0x1010 [btrfs]
> [1676572.902193] ? btree_set_page_dirty+0xe/0x10 [btrfs]
> [1676572.902233] btrfs_run_delayed_refs+0x80/0x190 [btrfs]
> [1676572.902274] btrfs_start_dirty_block_groups+0x2c3/0x400 [btrfs]
> [1676572.902320] btrfs_commit_transaction+0xcb/0x870 [btrfs]
> [1676572.902364] ? start_transaction+0xa0/0x410 [btrfs]
> [1676572.902409] transaction_kthread+0x15c/0x190 [btrfs]
> [1676572.902416] kthread+0x120/0x140
> [1676572.902458] ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
> [1676572.902463] ? kthread_bind+0x40/0x40
> [1676572.902469] ret_from_fork+0x35/0x40
> [1676572.902474] ---[ end trace f2212539a1b94aed ]---
> [1676572.902490] BTRFS: error (device sda) in
> __btrfs_free_extent:6953: errno=-28 No space left
> [1676572.902505] BTRFS info (device sda): forced readonly
> [1676572.902511] BTRFS: error (device sda) in
> btrfs_run_delayed_refs:3057: errno=-28 No space left
> [1683350.961567] kauditd_printk_skb: 1140 callbacks suppressed

-- 
Hugo Mills             | Great films about cricket: 200/1: A Pace Odyssey
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcMKnaAAoJEFheFHXiqx3kNRUQALV1PNXCSJnGfpBnP+q6IMkP
uiqLfElznJZjt0B9cVZdECBtM0ZxtLi+iCfj22I3BpVtOTVywm7v294gxQHBLIWc
5exrL2RR4xDPouAyGko3j1EcsAeWHcPUH5vEyuVXqRiwoVKMo5N4K16+2Y+7ChZI
lRkr9kVM4dRVTR8XuSHMex042/qAfwwC4U7daPMZQEsb5Y8YqWnlAO8v9sCR8NB2
EJa+2LDtysJbYDHayQCmMvCelSywZKue13a878Da4ii64TiINMKe5PWISvGdxj6i
WfzD6X++UzHHTGlIeBtzQhWKhDKiXS8UIsCZ/YK9FedqH/rGnFqNDIAHY3TmIy+u
/ybyY/UUP7kpkz4Zv9Xg+evWJLYqRV58v1X1ctM+KvoBnX4iQcYEJGwZTf+R82/W
UaWnuNiv5CbCr3OzocDpjKXjYMbHTdgfm2Wueg26KLs1fSvXV+nfV9Fq9hQYIaWE
y+bBf/DXGjQeqkFzUxx9h7JsDo9RvUmaElB4pWM9XEnlM2SztnzMtFkVnojdY9jm
F4oYI0pR05vf5TcmSmLLmUaogQqplmVxeALxwBu820QfsxNSWg5WFEX64zw6f4oq
VU/a6HrY3dMutwTBG/vP5YXUvHID//a305ucryxrXk08dfpPM04ywEyfbWHv4snO
DSAlDaFigkRMUBvXSXAt
=I8zz
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
