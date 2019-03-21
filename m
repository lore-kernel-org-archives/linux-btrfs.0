Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FBBC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 23:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60052190A
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 23:55:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="YSpckvVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfCUXzk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 19:55:40 -0400
Received: from mout.gmx.net ([212.227.17.20]:33687 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfCUXzk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 19:55:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553212534;
        bh=O66Yak/ea4pYO77zrrBMRhp+USvbULODn6K4sagmsls=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=YSpckvVFOaidNutQ+4AEAztOsu4gZj6/cUxzYLP/qlN55VrAc0lV7xhypVT3pweE9
         FnIK3VMgEaAxel9jhEXNjVFllQr8BHynbE10fa1kAm2G1BU8KFlf5Ubkfw9uSpA9yV
         yd2TYpiKOa72LncnCgSTVae5BVoKras5+990q/hg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Mh9cj-1hKgIm2O8H-00MKai; Fri, 22
 Mar 2019 00:55:34 +0100
Subject: Re: Fw: kernel oops when mounting btrfs
To:     Thorsten Hirsch <T.Hirsch@web.de>, linux-btrfs@vger.kernel.org
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
Date:   Fri, 22 Mar 2019 07:55:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MOLimIkSLyVSzo34IDM6xplWbSvuTtshh"
X-Provags-ID: V03:K1:YtRd/Yrbs2a+O5Ves7Lxtoqeu7y/ST0arRzwet0uWlXglt4UaAm
 X1WkYGmcRm4vLjyiCM4XYB30WjLy7j/odPi0DSvza9Cyjz7g7crpXrG/3TkWqyLMAm6Emj3
 gRU0qc3Pvc2gXpGOIjK90uh9Thtm04pSy6nAahXh48JqOPVLGZ6qDguF70rVlilWFceIyNV
 seUIBrLJEUawYKM5VqN5Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:S8LRvdITurQ=:dMufPutPywxIuyfkt/Nb/B
 /CZ7F7bzkUooCoJCqFpUbHzc0v1KS3NMcjzXjzVRNTJZx7m5TPJ3BZG6VkiYFstx/Wc8Btn6n
 j5kpMSAU+QlJyreytVJhKP0FdtxR+m/q0udKXGpVoej3YlBMnWxcuC7ZI0uyg7+5ChkHYmGbQ
 JHilMTTPY6eHW9wy1WfoqPQwdtvttzIpd697Air42ACXh8xIBv+++eUTvIMZr7Yrn3VbWg53+
 QVvBIfk/loNlQICIbA46zv4USklalUwDV/p3168RrsX/zHRakEJLUvqB6wCByjMpjslN+MIpF
 W8TafOPYbAVVm+3mV9V93p+jSjJ2a7zdUsgY8btNZhH3LUmphJCAOhtjbezL+HloZVxWoqbZh
 9fbP1sD2lTAM2zWYcjbW7CUYPZGYPuXlYR+UEpReWIVDGC1Wr3SB6AzGGJuj40111M3L6npev
 2FzRy/GB3XM1LovhgYTbxhaDL5toLRkdpHKsL6ausIWae04E+BfYOAm5YutmpTFkUlBuXsWor
 1FLAA1fkgM5qqr6U4A3eM2pDt0Q5ERV7CsP1Sg5LsN6f0bcsptaWoO6zAfmNBrxx+Yb8L/3OJ
 mJEtQyG57CMVJulDkYfh26gbqU7MzKHcR7lwsQglRHQGwIVuQZIM+OWdDMzFZeiDpPi6mOKm0
 8lhd1iBHoBHJdNrDcz6oRlfRWRubQe16mrr34ihk9jSNlI6t1PGSkPU9IMYfTdMSaKytBJegT
 APM25kIMfPU8xlFBiQeGFp9c7DlfHJ1s89NNveXTt0yOpqwfSJBjL/3g9YJNlNo+VzZVbj9gZ
 ZyuVKvSaW3zcPrMDsdtIUPdYEbhJZfTIXHkyJ8AmFrJ9ho6zX0ph9MdrruB6UnII5mjRVGP4a
 iOqFPVr+EC6jIJDZCcgmo60tvJqAd3nhG2jFiAoFbqMuiAJr0lGyAVc5pieyZZ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MOLimIkSLyVSzo34IDM6xplWbSvuTtshh
Content-Type: multipart/mixed; boundary="bt9P5vHeoYFnuSZN3q57LILMFpKPSbwGY";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Thorsten Hirsch <T.Hirsch@web.de>, linux-btrfs@vger.kernel.org
Message-ID: <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
Subject: Re: Fw: kernel oops when mounting btrfs
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
In-Reply-To: <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>

--bt9P5vHeoYFnuSZN3q57LILMFpKPSbwGY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/22 =E4=B8=8A=E5=8D=887:23, Thorsten Hirsch wrote:
> Meanwhile I upgraded to kernel 5.0, but the problem remained the same. =
So I zeroed the log with btrfs rescue zero-log. The command was successfu=
l, however the problem still remains more or less the same, which means:
>=20
> - I still get a kernel oops when mounting.
> - The stack trace looks a bit different now, e.g. RIP 0010 is not null =
anymore, and there's another RIP code: 0033. Maybe "set_page_dirty" is in=
teresting, too. But see for yourserlf below.
>=20
> Any ideas?
>=20
> Thorsten Hirsch
>=20
> P.S.: btrfs check --readonly tells me that everything's fine. But it al=
ready did so before zeroing the log.
>=20
>=20
> [   12.400224] BTRFS: device label Linux devid 1 transid 30104 /dev/nvm=
e0n1p3
> [   12.400523] BTRFS info (device nvme0n1p3): disk space caching is ena=
bled
> [   12.400524] BTRFS info (device nvme0n1p3): has skinny extents
> [   12.427049] BTRFS info (device nvme0n1p3): enabling ssd optimization=
s
> [   12.461362] init_special_inode: bogus i_mode (0) for inode nvme0n1p3=
:882
> [   12.462844] init_special_inode: bogus i_mode (0) for inode nvme0n1p3=
:802
> [   12.515489] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000001
> [   12.515491] #PF error: [normal kernel read fault]
> [   12.515492] PGD 0 P4D 0
> [   12.515495] Oops: 0000 [#1] SMP NOPTI
> [   12.515497] CPU: 8 PID: 487 Comm: exe Not tainted 5.0.0-7-generic #8=
-Ubuntu
> [   12.515499] Hardware name: Gigabyte Technology Co., Ltd. AB350M-DS3H=
/AB350M-DS3H-CF, BIOS F24 12/25/2018
> [   12.515504] RIP: 0010:__set_page_dirty_buffers+0x4c/0x100
> [   12.515506] Code: 84 00 00 00 49 89 c5 4c 89 e7 e8 df 71 73 00 48 8b=
 03 f6 c4 20 74 28 48 8b 03 f6 c4 20 0f 84 ae 00 00 00 48 8b 43 28 48 89 =
c2 <48> 8b 0a 83 e1 02 75 04 f0 80 0a 02 48 8b 52 08 48 39 d0 75 eb 48
> [   12.515507] RSP: 0018:ffffa9d2c28e7688 EFLAGS: 00010202
> [   12.515509] RAX: 0000000000000001 RBX: ffffe34f45261300 RCX: 0000000=
000000000
> [   12.515510] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8fc=
1b80b784c
> [   12.515512] RBP: ffffa9d2c28e76a0 R08: 0000000000028200 R09: fffffff=
fc07af588
> [   12.515513] R10: ffff8fc1cc594000 R11: ffff8fc1ba605ff0 R12: ffff8fc=
1b80b784c
> [   12.515514] R13: ffff8fc1b80b77c8 R14: ffff8fc1bc255600 R15: 0000000=
000000040
> [   12.515516] FS:  00007f2fafc505c0(0000) GS:ffff8fc1cec00000(0000) kn=
lGS:0000000000000000
> [   12.515517] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   12.515518] CR2: 0000000000000001 CR3: 00000003fe150000 CR4: 0000000=
0003406e0
> [   12.515520] Call Trace:
> [   12.515524]  set_page_dirty+0x5e/0xb0
> [   12.515541]  btrfs_dirty_pages+0x11f/0x2a0 [btrfs]

It's free space cache write out causing the problem.

Btrfs check would not report cache generation mismatch as a problem.

Considering the previous output about bogous inode mode, it maybe some
bug in the free space cache inode mode.

Would you please dump the root tree (contains no file name except
subvolume name, feel free to mask them) by the following command:
 # btrfs ins dump-tree -t root /dev/nvme0n1p3

Then you can try to completely wipe out the free space cache by the
following command:
 # btrfs check --clear-space-cache v1

If the above command successes, try mount again, and it should work.

Thanks,
Qu


> [   12.515562]  ? io_ctl_set_crc+0x5e/0xf0 [btrfs]
> [   12.515576]  __btrfs_write_out_cache+0x3aa/0x470 [btrfs]
> [   12.515590]  btrfs_write_out_cache+0x9a/0xf0 [btrfs]
> [   12.515600]  btrfs_write_dirty_block_groups+0x293/0x3a0 [btrfs]
> [   12.515611]  ? btrfs_run_delayed_refs+0xa7/0x190 [btrfs]
> [   12.515622]  commit_cowonly_roots+0x21a/0x2c0 [btrfs]
> [   12.515634]  btrfs_commit_transaction+0x32e/0x8c0 [btrfs]
> [   12.515647]  btrfs_recover_log_trees+0x392/0x430 [btrfs]
> [   12.515660]  ? replay_dir_deletes+0x2a0/0x2a0 [btrfs]
> [   12.515671]  open_ctree+0x1b2c/0x1bb0 [btrfs]
> [   12.515681]  btrfs_mount_root+0x4ff/0x650 [btrfs]
> [   12.515683]  ? cpumask_next+0x1b/0x20
> [   12.515685]  ? pcpu_alloc+0x1bd/0x610
> [   12.515687]  mount_fs+0x51/0x165
> [   12.515689]  vfs_kern_mount.part.38+0x5d/0x110
> [   12.515691]  vfs_kern_mount+0x13/0x20
> [   12.515700]  btrfs_mount+0x16f/0x860 [btrfs]
> [   12.515702]  ? pcpu_block_update_hint_alloc+0x1af/0x200
> [   12.515703]  ? pcpu_alloc_area+0xed/0x140
> [   12.515704]  ? pcpu_next_unpop+0x3c/0x50
> [   12.515706]  ? cpumask_next+0x1b/0x20
> [   12.515707]  ? pcpu_alloc+0x1bd/0x610
> [   12.515708]  mount_fs+0x51/0x165
> [   12.515709]  ? mount_fs+0x51/0x165
> [   12.515711]  vfs_kern_mount.part.38+0x5d/0x110
> [   12.515712]  do_mount+0x22f/0xd50
> [   12.515714]  ? __check_object_size+0x166/0x192
> [   12.515716]  ? memdup_user+0x4f/0x80
> [   12.515717]  ksys_mount+0xb6/0xd0
> [   12.515718]  __x64_sys_mount+0x25/0x30
> [   12.515720]  do_syscall_64+0x5a/0x110
> [   12.515722]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   12.515723] RIP: 0033:0x7f2fafb82aca
> [   12.515725] Code: 48 8b 0d c9 53 0c 00 f7 d8 64 89 01 48 83 c8 ff c3=
 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f =
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 96 53 0c 00 f7 d8 64 89 01 48
> [   12.515726] RSP: 002b:00007ffde16c06c8 EFLAGS: 00000202 ORIG_RAX: 00=
000000000000a5
> [   12.515727] RAX: ffffffffffffffda RBX: 0000000000008401 RCX: 00007f2=
fafb82aca
> [   12.515728] RDX: 00007ffde16c2dd5 RSI: 00007ffde16c2df8 RDI: 00007ff=
de16c2de9
> [   12.515728] RBP: 00007f2fafc50540 R08: 0000000000000000 R09: 0000000=
000000000
> [   12.515729] R10: 0000000000008401 R11: 0000000000000202 R12: 0000000=
000000000
> [   12.515730] R13: 0000000000000000 R14: 00007ffde16c0938 R15: 0000000=
000000000
> [   12.515731] Modules linked in: btrfs xor zstd_compress raid6_pq libc=
rc32c nls_iso8859_1 dm_mirror dm_region_hash dm_log uas usb_storage hid_g=
eneric usbhid hid amdgpu chash amd_iommu_v2 gpu_sched i2c_algo_bit ttm dr=
m_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm r8169 i2c_=
piix4 ahci nvme realtek libahci nvme_core wmi gpio_amdpt gpio_generic
> [   12.515742] CR2: 0000000000000001
> [   12.515744] ---[ end trace 3e026a4bcaf67667 ]---
> [   12.515745] RIP: 0010:__set_page_dirty_buffers+0x4c/0x100
> [   12.515746] Code: 84 00 00 00 49 89 c5 4c 89 e7 e8 df 71 73 00 48 8b=
 03 f6 c4 20 74 28 48 8b 03 f6 c4 20 0f 84 ae 00 00 00 48 8b 43 28 48 89 =
c2 <48> 8b 0a 83 e1 02 75 04 f0 80 0a 02 48 8b 52 08 48 39 d0 75 eb 48
> [   12.515747] RSP: 0018:ffffa9d2c28e7688 EFLAGS: 00010202
> [   12.515748] RAX: 0000000000000001 RBX: ffffe34f45261300 RCX: 0000000=
000000000
> [   12.515749] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8fc=
1b80b784c
> [   12.515750] RBP: ffffa9d2c28e76a0 R08: 0000000000028200 R09: fffffff=
fc07af588
> [   12.515750] R10: ffff8fc1cc594000 R11: ffff8fc1ba605ff0 R12: ffff8fc=
1b80b784c
> [   12.515751] R13: ffff8fc1b80b77c8 R14: ffff8fc1bc255600 R15: 0000000=
000000040
> [   12.515752] FS:  00007f2fafc505c0(0000) GS:ffff8fc1cec00000(0000) kn=
lGS:0000000000000000
> [   12.515753] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   12.515754] CR2: 0000000000000001 CR3: 00000003fe150000 CR4: 0000000=
0003406e0
>=20


--bt9P5vHeoYFnuSZN3q57LILMFpKPSbwGY--

--MOLimIkSLyVSzo34IDM6xplWbSvuTtshh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyUJHIACgkQwj2R86El
/qgQ0Af/bn7IyigmOIdr4u+GyG0BWVjqSuvkcqax9TQV7ObYBs3Wrd+fTQWHkvy+
ouxSnDRoFrpIUjJ8Wt9qhpF+IeXIrkuF0fZEhERuHuTxwOT2FqUdYkUu9ulxG7WU
C6h9/rd5oyXbpbwNpss+gftWjtoWcY1ncSLz2k/L/HOmKRiz24mtptoWu8AmHpYB
mk6yQoCdz9zOkryT9Z8ilblrw8MvRA0uKZDrIeZ5VUDzYdbO3dU25nOcPlbnxOiN
6GmSXeQQCeKyhai2YtHqyhQVwcYS4VAzxP/gdUYW2RfCEPnUvFoR56OXLWqx05xU
yDzy8VCAIwE0eZKJox9yG3J5Ia0hxg==
=hcu7
-----END PGP SIGNATURE-----

--MOLimIkSLyVSzo34IDM6xplWbSvuTtshh--
