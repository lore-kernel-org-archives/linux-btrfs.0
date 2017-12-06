Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61380 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752519AbdLFGZR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 01:25:17 -0500
Subject: Re: system OOM when using ghettoVCB script to backup VMs to nfs
 server (sync mode) running btrfs
To: taibai li <litaibaichina@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAM50xkkrME2aq9kqZALwU5UjWBaKQcJYMbAs12GA-Ytc3aEkUg@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20692bf4-9141-f248-cd4c-00888ccbd2f8@gmx.com>
Date: Wed, 6 Dec 2017 14:25:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAM50xkkrME2aq9kqZALwU5UjWBaKQcJYMbAs12GA-Ytc3aEkUg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Hoh9lQVMViG7uDwS7UfSWjJDUAUSWOX6w"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Hoh9lQVMViG7uDwS7UfSWjJDUAUSWOX6w
Content-Type: multipart/mixed; boundary="iaG8wXEORBqrlWQWSUWK9hwOuLMR7hLOa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: taibai li <litaibaichina@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20692bf4-9141-f248-cd4c-00888ccbd2f8@gmx.com>
Subject: Re: system OOM when using ghettoVCB script to backup VMs to nfs
 server (sync mode) running btrfs
References: <CAM50xkkrME2aq9kqZALwU5UjWBaKQcJYMbAs12GA-Ytc3aEkUg@mail.gmail.com>
In-Reply-To: <CAM50xkkrME2aq9kqZALwU5UjWBaKQcJYMbAs12GA-Ytc3aEkUg@mail.gmail.com>

--iaG8wXEORBqrlWQWSUWK9hwOuLMR7hLOa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8806=E6=97=A5 14:22, taibai li wrote:
> Hi Guys,
>=20
> I hit the OOM issues with as Box running 4.4.x kernel,   so I tried to
> build a 4.14.3 kernel to try that.  The testbed is :
> NAS box with 2G memory, and a single disk raid ,  I setup a nfs server
> with sync mode,  add the storage on ESXi servers 6.0 and backup all
> the VMs on it by the ghettoVCB script , after about 14 hours,
> Inpot/Output error happened,
> checked the box , found OOM.
> # cat /etc/exports
> "/data/Videos" *(insecure,insecure_locks,no_subtree_check,crossmnt,anon=
uid=3D99,anongid=3D99,root_squash,rw,sync)
> # uname -a
> Linux lzx-314-desk 4.14.3.x86_64.1 #1 SMP Fri Dec 1 01:31:25 UTC 2017
> x86_64 GNU/Linux
> # btrfs fi show /data/
> Label: '43f611ae:data' uuid: 6fefb319-a21d-476e-9642-565e0600a049
> Total devices 1 FS bytes used 292.78GiB
> devid 1 size 1.81TiB used 296.02GiB path /dev/md127
>=20
> The stack is :
> Dec 04 23:47:43 lzx-314-desk kernel: nfsd: page allocation stalls for
> 621031ms, order:0, mode:0x14000c0(GFP_KERNEL), nodemask=3D(null)
> Dec 04 23:47:43 lzx-314-desk kernel: nfsd cpuset=3D/ mems_allowed=3D0
> Dec 04 23:47:43 lzx-314-desk kernel: CPU: 0 PID: 3376 Comm: nfsd Not
> tainted 4.14.3.x86_64.1 #1
> Dec 04 23:47:43 lzx-314-desk kernel: Hardware name: NETGEAR ReadyNAS
> 314/To be filled by O.E.M., BIOS 4.6.5 11/05/2013
> Dec 04 23:47:43 lzx-314-desk kernel: Call Trace:
> Dec 04 23:47:43 lzx-314-desk kernel: dump_stack+0x4d/0x6a
> Dec 04 23:47:43 lzx-314-desk kernel: warn_alloc+0xe3/0x180
> Dec 04 23:47:43 lzx-314-desk kernel: __alloc_pages_nodemask+0xb1e/0xed0=

> Dec 04 23:47:43 lzx-314-desk kernel: svc_recv+0x99/0x900
> Dec 04 23:47:43 lzx-314-desk kernel: ? svc_process+0x241/0x690
> Dec 04 23:47:43 lzx-314-desk kernel: nfsd+0xd2/0x150
> Dec 04 23:47:43 lzx-314-desk kernel: kthread+0x11a/0x150
> Dec 04 23:47:43 lzx-314-desk kernel: ? nfsd_destroy+0x60/0x60
> Dec 04 23:47:43 lzx-314-desk kernel: ? kthread_create_on_node+0x40/0x40=

> Dec 04 23:47:43 lzx-314-desk kernel: ret_from_fork+0x22/0x30
> Dec 04 23:47:43 lzx-314-desk kernel: readynasd invoked oom-killer:
> gfp_mask=3D0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=3D(null), order=3D=
0,
> oom_score_adj=3D-1000
> Dec 04 23:47:43 lzx-314-desk kernel: readynasd cpuset=3D/ mems_allowed=3D=
0
> Dec 04 23:47:43 lzx-314-desk kernel: CPU: 3 PID: 3307 Comm: readynasd
> Not tainted 4.14.3.x86_64.1 #1
> Dec 04 23:47:43 lzx-314-desk kernel: Hardware name: NETGEAR ReadyNAS
> 314/To be filled by O.E.M., BIOS 4.6.5 11/05/2013
> Dec 04 23:47:43 lzx-314-desk kernel: Call Trace:
> Dec 04 23:47:43 lzx-314-desk kernel: dump_stack+0x4d/0x6a
> Dec 04 23:47:43 lzx-314-desk kernel: dump_header+0x9a/0x21b
> Dec 04 23:47:43 lzx-314-desk kernel: ? pick_next_task_fair+0x1d5/0x4b0
> Dec 04 23:47:43 lzx-314-desk kernel: ? security_capable_noaudit+0x40/0x=
60
> Dec 04 23:47:43 lzx-314-desk kernel: oom_kill_process+0x216/0x430
> Dec 04 23:47:43 lzx-314-desk kernel: out_of_memory+0xf9/0x2e0
> Dec 04 23:47:43 lzx-314-desk kernel: __alloc_pages_nodemask+0xd6c/0xed0=

> Dec 04 23:47:43 lzx-314-desk kernel: __read_swap_cache_async+0x11d/0x19=
0
> Dec 04 23:47:43 lzx-314-desk kernel: read_swap_cache_async+0x17/0x40
> Dec 04 23:47:43 lzx-314-desk kernel: swapin_readahead+0x1f1/0x230
> Dec 04 23:47:43 lzx-314-desk kernel: ? find_get_entry+0x19/0xf0
> Dec 04 23:47:43 lzx-314-desk kernel: ? pagecache_get_page+0x27/0x210
> Dec 04 23:47:43 lzx-314-desk kernel: do_swap_page+0x432/0x590
> Dec 04 23:47:43 lzx-314-desk kernel: ? do_swap_page+0x432/0x590
> Dec 04 23:47:43 lzx-314-desk kernel: ? poll_select_copy_remaining+0x120=
/0x120
> Dec 04 23:47:43 lzx-314-desk kernel: __handle_mm_fault+0x33e/0xa20
> Dec 04 23:47:43 lzx-314-desk kernel: handle_mm_fault+0x14a/0x1d0
> Dec 04 23:47:43 lzx-314-desk kernel: __do_page_fault+0x212/0x440
> Dec 04 23:47:43 lzx-314-desk kernel: page_fault+0x22/0x30
> Dec 04 23:47:43 lzx-314-desk kernel: RIP:
> 0010:copy_user_generic_unrolled+0x89/0xc0
> Dec 04 23:47:43 lzx-314-desk kernel: RSP: 0000:ffffc90000cdbd70 EFLAGS:=
 00010202
> Dec 04 23:47:43 lzx-314-desk kernel: RAX: 0000000000000000 RBX:
> 0000000000000008 RCX: 0000000000000001
> Dec 04 23:47:43 lzx-314-desk kernel: RDX: 0000000000000000 RSI:
> ffffc90000cdbdd8 RDI: 00007ff45e7fba80
> Dec 04 23:47:43 lzx-314-desk kernel: RBP: ffffc90000cdbee8 R08:
> 0000000000000000 R09: 0000000000000104
> Dec 04 23:47:43 lzx-314-desk kernel: R10: ffffc90000cdbd78 R11:
> 0000000000000104 R12: 0000000000000000
> Dec 04 23:47:43 lzx-314-desk kernel: R13: ffffc90000cdbdc0 R14:
> 00007ff45e7fba80 R15: ffffc90000cdbdc0
> Dec 04 23:47:43 lzx-314-desk kernel: ? core_sys_select+0x208/0x2a0
> Dec 04 23:47:43 lzx-314-desk kernel: ? __handle_mm_fault+0x4fc/0xa20
> Dec 04 23:47:43 lzx-314-desk kernel: ? ktime_get_ts64+0x44/0xe0
> Dec 04 23:47:43 lzx-314-desk kernel: SyS_select+0xa6/0xe0
> Dec 04 23:47:43 lzx-314-desk kernel: entry_SYSCALL_64_fastpath+0x13/0x9=
4
> Dec 04 23:47:43 lzx-314-desk kernel: RIP: 0033:0x7ff488f05893
> Dec 04 23:47:43 lzx-314-desk kernel: RSP: 002b:00007ff45e7fb9f0
> EFLAGS: 00000293 ORIG_RAX: 0000000000000017
> Dec 04 23:47:43 lzx-314-desk kernel: RAX: ffffffffffffffda RBX:
> 0000000000000018 RCX: 00007ff488f05893
> Dec 04 23:47:43 lzx-314-desk kernel: RDX: 0000000000000000 RSI:
> 00007ff45e7fba80 RDI: 0000000000000019
> Dec 04 23:47:43 lzx-314-desk kernel: RBP: 00007ff48fc4b0f0 R08:
> 00007ff45e7fba70 R09: 00007ff4480008c0
> Dec 04 23:47:43 lzx-314-desk kernel: R10: 0000000000000000 R11:
> 0000000000000293 R12: 0000000000000000
> Dec 04 23:47:43 lzx-314-desk kernel: R13: 0000000000000000 R14:
> 0000000001999670 R15: 00007ff4480008c0
> Dec 04 23:47:43 lzx-314-desk kernel: Mem-Info:
> Dec 04 23:47:43 lzx-314-desk kernel: active_anon:0 inactive_anon:0
> isolated_anon:0
> active_file:322 inactive_file:461978 isolated_file:352
> unevictable:0 dirty:136 writeback:0 unstable:0
> slab_reclaimable:15780 slab_unreclaimable:5246
> mapped:1 shmem:0 pagetables:1165 bounce:0
> free:13867 free_pcp:60 free_cma:0
> ......
>=20
> I tried to fomat the md device to ext4,  then it's fine to backup all
> the VMs,  And if I use async option for nfs, it works too, so seems
> like  btrfs is more memory consuming sometimes.
>=20
> I attatched the full logs.
>=20
> Any one hit  similar issue or have any ideas ?

Are you using btrfs qgroups (quota)?

It's known qgroup will take extra memory and may cause OOM if there are
a lot of extents modified in current transaction.

Thanks,
Qu

>=20
> thanks so much.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--iaG8wXEORBqrlWQWSUWK9hwOuLMR7hLOa--

--Hoh9lQVMViG7uDwS7UfSWjJDUAUSWOX6w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlonjUUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiOpgf9FBLOIurJ/yIoLwrGzCBa+S11
FhkjbxW1Le5kMiyqoAvcVnpjPM024gS7gO1z8tToR5pepF84ri6t4BGU4pkJA6Wn
hmv0woTjMvPjxlwmnoz6GzHmrOzD8Aez3BWIw+AzNDYxPnJE7gPtxuRuDBTYrEdW
/SdCkeZf3n5gvnYpU9s6X6SXi7rdX3g7n8/mncSHlerjBBGrmxOmLUPoBvVcaV2F
6+ev6CZ37KWlsZNMl0DOYJccSDBrgC8DXlBNK8/nM/wz4pkSZZBIGe7LBX/peUK9
g54+es1HusODbc/6LWS5nmD5+Vrqt7mAUBAjko58DAxxBfKQ2FNOqckVjFxViA==
=J9fi
-----END PGP SIGNATURE-----

--Hoh9lQVMViG7uDwS7UfSWjJDUAUSWOX6w--
