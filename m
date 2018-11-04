Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21460C32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 13:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B23A92082D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 13:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B23A92082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbeKDWw6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 17:52:58 -0500
Received: from mout.gmx.net ([212.227.17.22]:44435 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729507AbeKDWw6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Nov 2018 17:52:58 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lmazv-1fjgjK3mWR-00aCy0; Sun, 04
 Nov 2018 14:37:47 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lmazv-1fjgjK3mWR-00aCy0; Sun, 04
 Nov 2018 14:37:47 +0100
Subject: Re: Filesystem mounts fine but hangs on access
To:     Sebastian Ochmann <ochmann@cs.uni-bonn.de>,
        linux-btrfs@vger.kernel.org
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <7c69325a-7e95-7377-5a47-5c98eb941253@gmx.com>
Date:   Sun, 4 Nov 2018 21:37:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vBQKKUrnQLjFLa0ep539DHePr4spdaXA6"
X-Provags-ID: V03:K1:/t+ovGUJf8WxLU2fMI6RUbPTL19hTN23PLxMepUDKcSyB6zxSS5
 pJ3apXSljkF6xHI+TTMrCHMJn+tOcVvPYVZXp72PEcLmYfbh9MbTGH+gq8cUILQ0b3dZfBq
 hJd1p9LN/NDC6n2HWuZ5uPqyl8J1AN2Sl8hx8HKmPIbBA+e1Ul2N7N9BS8vk/bOmfJhBZNb
 nvlbe5ZDSKNtGllHVry+g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:IqjB9Zr4v5M=:uzSR8IquvI6MIZvl+bqXAf
 T+4a4f3b4wO43lbWnpC4e6ri98yAWC7xUs0LMo8m11INYoaTkAuiI1Xl489MIUQfDoC2etzYu
 ciKrPPi+rE0ugtzYDBrFHRK4RbUnJr2zJxrqS86ZW2sw/AGngcrx3AFLYnZ6fXfhoJZ4hJZnu
 90SPuCOui/61+q7XehQXuuFCoVRdw9uFhRAvivlQv08iGFuiXQplDq6GvjFlSWPDXWEmmIKAT
 M7oBbmjtBheCX0hTd5mbF9Hqj3ysVxliXvOsNk/nQzYVRU1SZtW0qGRqXG5cSnSe6kDvdHWwx
 +rJzT+9mc4X2ep96lFe66q6YeIiYLYhQ9apJ/xtRsQUmTP2VgBZL/ny0DWoELNarAtDJRQM4s
 +70lFRUA72qk0xurdHoN3lnXlTzQoYibYEr60SPH4Hs45js8OapIAUIHsQgT4W9Ay9lpKudC/
 Vt8qxjaOKx0g6FzZtNE1q+9xMT1aM5/H05LnwjCHqzknd6OaHYke6rK2Dc2GpdByQ74sUlmVs
 FiG3BCG59cKtt/po6dcA2eygdqdqItocJ03Ic65mMt5mwqDLLmHYnx9Hk7V07Iq50INYKYK01
 kbIwuyAtB3LzvHCf5/eypjNIWgZu5HSSM18IswAp6idpPjI/t862jmLsESjrt5SHmGJxU52dO
 EKvjJP3Rl09BMN8FnqwuQh2J5zKT37AtSgMb/QwudKODU9qrX6KQ8c+CQ5Mkh2lvtF1Nqkn2h
 LCSfrOa82lx630X3xrocJBjCBfnDm8jSSamRUEI8XRAES0ZHjoMP+eNFZEtgvocDU9JrpSKJk
 B9dgnjOJC2V3GMq3a1PyhfAtbzO2Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vBQKKUrnQLjFLa0ep539DHePr4spdaXA6
Content-Type: multipart/mixed; boundary="6C1x5JYkAbDk398y7q5VOU9lyCguHk1nz";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>, linux-btrfs@vger.kernel.org
Message-ID: <7c69325a-7e95-7377-5a47-5c98eb941253@gmx.com>
Subject: Re: Filesystem mounts fine but hangs on access
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
In-Reply-To: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>

--6C1x5JYkAbDk398y7q5VOU9lyCguHk1nz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/4 =E4=B8=8B=E5=8D=889:15, Sebastian Ochmann wrote:
> Hello,
>=20
> I have a btrfs filesystem on a single encrypted (LUKS) 10 TB drive whic=
h
> stopped working correctly. The drive is used as a backup drive with zst=
d
> compression to which I regularly rsync and make daily snapshots. After =
I
> routinely removed a bunch of snapshots (about 20), I noticed later that=

> the machine would hang when trying to unmount the filesystem. The
> current state is that I'm able to mount the filesystem without errors
> and I can view (ls) files in the root level, but trying to view content=
s
> of directories contained therein hangs just like when trying to unmount=

> the filesystem. I have not yet tried to run check, repair, etc. Do you
> have any advice what I should try next?

Could you please run "btrfs check" on the umounted fs?

>=20
> A notable hardware change I did a few days before the problem is a
> switch from an Intel Xeon platform to AMD Threadripper. However, I
> haven't seen problems with the rest of the btrfs filesystems (in
> particular, a RAID-1 consisting of three HDDs), which I also migrated t=
o
> the new platform, yet. I just want to mention it in case there are know=
n
> issues in that direction.
>=20
> Kernel 4.18.16 (Arch Linux)
> btrfs-progs 4.17.1
>=20
> Kernel log after trying to "ls" a directory contained in the
> filesystem's root directory:
>=20
> [=C2=A0=C2=A0 79.279349] BTRFS info (device dm-5): use zstd compression=
, level 0
> [=C2=A0=C2=A0 79.279351] BTRFS info (device dm-5): disk space caching i=
s enabled
> [=C2=A0=C2=A0 79.279352] BTRFS info (device dm-5): has skinny extents
> [=C2=A0 135.202344] kauditd_printk_skb: 2 callbacks suppressed
> [=C2=A0 135.202347] audit: type=3D1130 audit(1541335770.667:45): pid=3D=
1 uid=3D0
> auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dpolkit comm=3D"systemd=
"
> exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
> [=C2=A0 135.364850] audit: type=3D1130 audit(1541335770.831:46): pid=3D=
1 uid=3D0
> auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dudisks2 comm=3D"system=
d"
> exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
> [=C2=A0 135.589255] audit: type=3D1130 audit(1541335771.054:47): pid=3D=
1 uid=3D0
> auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Drtkit-daemon comm=3D"s=
ystemd"
> exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D? res=
=3Dsuccess'
> [=C2=A0 368.266653] INFO: task kworker/u256:1:728 blocked for more than=
 120
> seconds.
> [=C2=A0 368.266657]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Tainted: P=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 OE=C2=A0=C2=A0=C2=A0=
=C2=A0 4.18.16-arch1-1-ARCH #1
> [=C2=A0 368.266658] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [=C2=A0 368.266660] kworker/u256:1=C2=A0 D=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=
=A0 728=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2 0x80000080
> [=C2=A0 368.266680] Workqueue: btrfs-extent-refs btrfs_extent_refs_help=
er
> [btrfs]
> [=C2=A0 368.266681] Call Trace:
> [=C2=A0 368.266687]=C2=A0 ? __schedule+0x29b/0x8b0
> [=C2=A0 368.266690]=C2=A0 ? preempt_count_add+0x68/0xa0
> [=C2=A0 368.266692]=C2=A0 schedule+0x32/0x90
> [=C2=A0 368.266707]=C2=A0 btrfs_tree_read_lock+0x7d/0x110 [btrfs]
> [=C2=A0 368.266710]=C2=A0 ? wait_woken+0x80/0x80
> [=C2=A0 368.266719]=C2=A0 btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
> [=C2=A0 368.266729]=C2=A0 btrfs_search_slot+0xf6/0xa00 [btrfs]
> [=C2=A0 368.266732]=C2=A0 ? _raw_spin_unlock+0x16/0x30
> [=C2=A0 368.266734]=C2=A0 ? inode_insert5+0x105/0x1a0
> [=C2=A0 368.266746]=C2=A0 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
> [=C2=A0 368.266749]=C2=A0 ? kmem_cache_alloc+0x179/0x1d0
> [=C2=A0 368.266762]=C2=A0 btrfs_iget+0x113/0x690 [btrfs]
> [=C2=A0 368.266764]=C2=A0 ? _raw_spin_unlock+0x16/0x30
> [=C2=A0 368.266778]=C2=A0 __lookup_free_space_inode+0xd8/0x150 [btrfs]
> [=C2=A0 368.266792]=C2=A0 lookup_free_space_inode+0x63/0xc0 [btrfs]
> [=C2=A0 368.266806]=C2=A0 load_free_space_cache+0x6e/0x190 [btrfs]
> [=C2=A0 368.266808]=C2=A0 ? kmem_cache_alloc_trace+0x181/0x1d0
> [=C2=A0 368.266817]=C2=A0 ? cache_block_group+0x73/0x3e0 [btrfs]
> [=C2=A0 368.266827]=C2=A0 cache_block_group+0x1c1/0x3e0 [btrfs]

This thread is trying to get tree root lock to create free space cache,
while some one already has locked the tree root.

> [=C2=A0 368.266829]=C2=A0 ? wait_woken+0x80/0x80
> [=C2=A0 368.266839]=C2=A0 find_free_extent+0x872/0x10e0 [btrfs]
> [=C2=A0 368.266851]=C2=A0 btrfs_reserve_extent+0x9b/0x180 [btrfs]
> [=C2=A0 368.266862]=C2=A0 btrfs_alloc_tree_block+0x1b3/0x4d0 [btrfs]
> [=C2=A0 368.266872]=C2=A0 __btrfs_cow_block+0x11d/0x500 [btrfs]
> [=C2=A0 368.266882]=C2=A0 btrfs_cow_block+0xdc/0x1a0 [btrfs]
> [=C2=A0 368.266891]=C2=A0 btrfs_search_slot+0x282/0xa00 [btrfs]
> [=C2=A0 368.266893]=C2=A0 ? _raw_spin_unlock+0x16/0x30
> [=C2=A0 368.266903]=C2=A0 btrfs_insert_empty_items+0x67/0xc0 [btrfs]
> [=C2=A0 368.266913]=C2=A0 __btrfs_run_delayed_refs+0x8ef/0x10a0 [btrfs]=

> [=C2=A0 368.266915]=C2=A0 ? preempt_count_add+0x68/0xa0
> [=C2=A0 368.266926]=C2=A0 btrfs_run_delayed_refs+0x72/0x180 [btrfs]
> [=C2=A0 368.266937]=C2=A0 delayed_ref_async_start+0x81/0x90 [btrfs]
> [=C2=A0 368.266950]=C2=A0 normal_work_helper+0xbd/0x350 [btrfs]
> [=C2=A0 368.266953]=C2=A0 process_one_work+0x1eb/0x3c0
> [=C2=A0 368.266955]=C2=A0 worker_thread+0x2d/0x3d0
> [=C2=A0 368.266956]=C2=A0 ? process_one_work+0x3c0/0x3c0
> [=C2=A0 368.266958]=C2=A0 kthread+0x112/0x130
> [=C2=A0 368.266960]=C2=A0 ? kthread_flush_work_fn+0x10/0x10
> [=C2=A0 368.266961]=C2=A0 ret_from_fork+0x22/0x40
> [=C2=A0 368.266978] INFO: task btrfs-cleaner:1196 blocked for more than=
 120
> seconds.
[snip, this trace doesn't look interesting at all]
> [=C2=A0 368.267135] INFO: task btrfs-transacti:1197 blocked for more th=
an 120
> seconds.
> [=C2=A0 368.267136]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Tainted: P=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 OE=C2=A0=C2=A0=C2=A0=
=C2=A0 4.18.16-arch1-1-ARCH #1
> [=C2=A0 368.267137] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [=C2=A0 368.267138] btrfs-transacti D=C2=A0=C2=A0=C2=A0 0=C2=A0 1197=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 2 0x80000080
> [=C2=A0 368.267139] Call Trace:
> [=C2=A0 368.267141]=C2=A0 ? __schedule+0x29b/0x8b0
> [=C2=A0 368.267142]=C2=A0 ? preempt_count_add+0x68/0xa0
> [=C2=A0 368.267144]=C2=A0 schedule+0x32/0x90
> [=C2=A0 368.267156]=C2=A0 btrfs_tree_lock+0x113/0x1f0 [btrfs]
> [=C2=A0 368.267158]=C2=A0 ? wait_woken+0x80/0x80
> [=C2=A0 368.267167]=C2=A0 btrfs_search_slot+0x7b4/0xa00 [btrfs]
> [=C2=A0 368.267178]=C2=A0 btrfs_insert_empty_items+0x67/0xc0 [btrfs]
> [=C2=A0 368.267188]=C2=A0 __btrfs_run_delayed_refs+0x8ef/0x10a0 [btrfs]=

> [=C2=A0 368.267190]=C2=A0 ? _raw_spin_unlock_irq+0x1d/0x30
> [=C2=A0 368.267201]=C2=A0 btrfs_run_delayed_refs+0x72/0x180 [btrfs]
> [=C2=A0 368.267212]=C2=A0 btrfs_commit_transaction+0x40/0x8a0 [btrfs]

And thread is running commit transaction.

This looks pretty like this bug which should be fixed by the following
patch:

https://patchwork.kernel.org/patch/10654433/

If previous "btrfs check" shows no error, would you please try apply
that patch and try again?

Thanks,
Qu


--6C1x5JYkAbDk398y7q5VOU9lyCguHk1nz--

--vBQKKUrnQLjFLa0ep539DHePr4spdaXA6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlve9iUACgkQwj2R86El
/qiCsQf9H80C6i/MigKUWl5xlmpTJVsi09bwdAx0utkJlWS+CdkzRRR5hWTr6Z1G
DF8YqbX133GMJsvH7381Tm8TFlEnFkzjDK7HmknObvS38uW3eox0I4rNr23eO91L
4SJAD+OLk68EOjdnlzPl/p4DU02zR8f8543czqj4SDuTxVQJ7Bv8Pl72/xM5Dgtt
l7KXTEMs+aQmjNXH24VbZdkdthU9OZXlgRWo47Tb5KhsJOcyYWSHFd+/RRsW9lw5
Npd/n3ykg81aOxiW6AZ719GjX2HHlmnxu/M1Fm0H0ODWGTXrNBSi+aPpL5N58COc
uhz3EIaFRV5Xsc7F1DSoj7ND4hDiSg==
=CHk9
-----END PGP SIGNATURE-----

--vBQKKUrnQLjFLa0ep539DHePr4spdaXA6--
