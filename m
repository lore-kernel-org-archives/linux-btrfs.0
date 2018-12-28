Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D2DC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 10:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00CF120879
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 10:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbeL1KLY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 05:11:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:44541 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727902AbeL1KLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 05:11:24 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MLNeQ-1gdN4I3CKI-000ZPP; Fri, 28
 Dec 2018 11:10:53 +0100
Subject: Re: Kernel traces
To:     "Stephen R. van den Berg" <srb@cuci.nl>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
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
Message-ID: <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
Date:   Fri, 28 Dec 2018 18:10:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181228092036.GA30363@cuci.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NdnTbvlWMsfdCOVkWFQwG0WZzRdph64Bk"
X-Provags-ID: V03:K1:BiaT+vBtF+bRtshbAZGjXLX2IrSz0ueWprHa7TiaSqv91oUloU5
 56oHzVnYyGR2v+24fP3ogwQvujygUH1WTudFbCkY/sTg5v4bjXyfiuo2CZGnxYa4CP+htD8
 ODykVgkClzmmRGcFm0rFeij1WPv1jIgQoTxesNnRIu2C6We4q+g8DS8nwl1DNP/F8qSBOq1
 aC9OHS8I+v285fKhzhB7A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:oCo1LGesIr8=:bJqYddx2DDstoj2RzcaISn
 Hvs4IMGJamvFD3XFpfy7w+XcuSJVPt87luX7fAsk4We0OUO3XvYh4m8fnONoPGylA4td3CgRO
 vHRVjB3s+CaAVGdgpr54xp25PFU8pNxB5ClGcLdMD9DRbjcGoZYIHtQ6JPyMYn/usQSCzUOBN
 1nBOgRwBi4Oa/VT89ALfEuKDFvJJmqezCh74vcodbGln0ZSQ+1NfKpyAW6zbdE5kNXPHEogAz
 WYX9fl5YNkPdwxW7NVnh22/9Eb+I5gQcc8fio7QZexRdtBqCw5AofPXtINcvelcsH7dnTO0pB
 RxMkL3Cr6Cjm+jO2E+Vqr9oJ5yLZ7yb+pT4NORhd447g/Q7qa/5pRTg5mcUZkhcbR/ekJq/Fk
 KfBEy1xjBKE3Nb7+r3JAk08Gm+8j0jgncjQh2x8EVda8wopbV1rBUWmUlLF/GK2EbdK6TggrT
 XyWXzbRPiY/sZDXXa6ZO97OC5NU+UYzpzDBq7pKUE4gHHkp4onj5URXgKpUXlFPAR3ZplCTFC
 u7D1bMEtdbYArTxXFhGqErKyQxHHQGuHXpY9OSjVUmtjRakU5FUHF2a71MwdFMeKyhRYmW+is
 LHZG+JJI4TMMcvYtb/hL/Ls+V0h7ipanq+qnjEYLdEO8V9KJsBg5NUlKVpxp3r2h57DJcNwFc
 Ss9is4uqiMuGUm9fXw8nIr/UqMfOi0vKACiR10WpJDv8lp7RNIWXFwhgMGbzSLpQLzfK6s3vf
 TV1Mugs2sbhjSxiz+/Sv2wBPvoUf5re7ih+0xoo5731JDQ3kF5LCa2CnA5DGBS45RMY3JW067
 IWMbvcu7w76q8ZdmQhb3Lg4b1sOrStACrD6njNSZLSEPwm/Yfr43/bFKVI83klkM6Pg1iHukR
 zSdkhrmwd2dORIenn8WVrZDP/Nz9DKYqDJ8oxwsNS+IVURfimqaI2NrEVVXKr9
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NdnTbvlWMsfdCOVkWFQwG0WZzRdph64Bk
Content-Type: multipart/mixed; boundary="L98cmhuFg5e4pvkHWOidz4xeO0aiO3Co3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Stephen R. van den Berg" <srb@cuci.nl>,
 Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
Subject: Re: Kernel traces
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
In-Reply-To: <20181228092036.GA30363@cuci.nl>

--L98cmhuFg5e4pvkHWOidz4xeO0aiO3Co3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/28 =E4=B8=8B=E5=8D=885:20, Stephen R. van den Berg wrote:
> Chris Murphy wrote:
>> On Wed, Dec 12, 2018 at 12:26 AM Stephen R. van den Berg <srb@cuci.nl>=
 wrote:
>>> I'm using CFQ, and I don't think I ever tried a different one.
>>> But, btrfs should be compatible with all schedulers.
>=20
>> But yeah, one of the developers might have more to say about it once
>> sysrq+w output is available, which should expose what's stuck or busy.=

>=20
> Ok.  Finally have a sysrq+w output of 4.19.8.
> The uptime of this system has been a few days.  It has already received=
 quite
> some btrfs-sends in that time (every night).  When the sysrq+w output w=
as
> taken, the system started to get more and more processes in a D kernel =
state
> bordering on becoming unusable.  I had to hard-reset the system after t=
his
> to get it going again.

It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().

This is one of the easiest way to trigger an ABBA deadlock.

Please either disable qgroup or apply this patch to solve it:
https://patchwork.kernel.org/patch/10725371/

Thanks,
Qu

>=20
> sysrq: SysRq : Show Blocked State
>   task                        PC stack   pid father
> btrfs-cleaner   D    0   276      2 0x80000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? find_parent_nodes+0x89d/0x11df
>  ? __schedule+0x4ff/0x524
>  ? page_cache_tree_insert+0xc6/0xc6
>  ? btrfs_find_all_roots_safe+0x9e/0x10f
>  ? btrfs_find_all_roots_safe+0x9e/0x10f
>  ? btrfs_find_all_roots+0x58/0x77
>  ? btrfs_qgroup_trace_extent_post+0x38/0x7e
>  ? btrfs_qgroup_trace_subtree+0x21e/0x362
>  ? do_walk_down+0x3f5/0x495
>  ? walk_down_tree+0x99/0xd4
>  ? btrfs_drop_snapshot+0x2c4/0x5de
>  ? btrfs_kill_all_delayed_nodes+0x5a/0xd1
>  ? btrfs_need_cleaner_sleep+0x27/0x27
>  ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
>  ? cleaner_kthread+0x7a/0x138
>  ? kthread+0xeb/0xf0
>  ? __kthread_cancel_work+0x68/0x68
>  ? ret_from_fork+0x35/0x40
> btrfs-transacti D    0   277      2 0x80000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __switch_to_asm+0x40/0x70
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1ce/0x329
>  ? transaction_kthread+0xa7/0x132
>  ? btrfs_cleanup_transaction+0x3ca/0x3ca
>  ? kthread+0xeb/0xf0
>  ? __kthread_cancel_work+0x68/0x68
>  ? ret_from_fork+0x35/0x40
> lldpad          D    0  2165      1 0x00000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ntpd            D    0  2396      1 0x00000004
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? recalc_sigpending+0x17/0x3f
>  ? dequeue_signal+0x169/0x19a
>  ? do_filp_open+0x52/0xaf
>  ? __set_current_blocked+0x3d/0x55
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> smartd          D    0  2424      1 0x00000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? unlock_new_inode+0x4a/0x54
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_start_transaction_fallback_global_rsv+0x32/0xbc
>  ? btrfs_unlink+0x30/0xc0
>  ? vfs_unlink+0x81/0xc7
>  ? do_unlinkat+0x111/0x1e3
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> rs:main Q:Reg   D    0  7824   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __accumulate_pelt_segments+0x29/0x3a
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? find_busiest_group+0x108/0x5ef
>  ? btrfs_lookup_file_extent+0x4b/0x66
>  ? btrfs_get_extent+0x176/0x6fb
>  ? _cond_resched+0x20/0x23
>  ? kmem_cache_free+0x25/0xc4
>  ? __do_readpage+0x214/0x564
>  ? start_delalloc_inodes+0x2b8/0x2b8
>  ? mem_cgroup_commit_charge+0xb1/0xf3
>  ? __extent_read_full_page+0xcb/0xdb
>  ? start_delalloc_inodes+0x2b8/0x2b8
>  ? extent_read_full_page+0x42/0x75
>  ? prepare_uptodate_page+0x33/0x8c
>  ? prepare_pages+0xb6/0x15d
>  ? btrfs_buffered_write+0x29d/0x5cf
>  ? btrfs_file_write_iter+0x3a8/0x485
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0  7826   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? crc32c+0x66/0x90
>  ? btrfs_lookup_dir_item+0x7d/0xc6
>  ? btrfs_lookup_dentry+0x9d/0x40c
>  ? d_alloc_parallel+0x28a/0x2cb
>  ? btrfs_lookup+0xe/0x2c
>  ? __lookup_slow+0xd4/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? path_lookupat.isra.55+0x107/0x1c3
>  ? load_balance+0x150/0x6ed
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? filename_lookup.part.71+0x6f/0xd2
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? kmem_cache_alloc+0x9a/0x100
>  ? getname_flags+0x49/0x156
>  ? vfs_statx+0x71/0xce
>  ? hrtimer_cancel+0x11/0x1b
>  ? do_nanosleep+0xc0/0x168
>  ? __do_sys_newstat+0x3a/0x6d
>  ? hrtimer_nanosleep+0x9f/0x100
>  ? syscall_trace_enter+0x103/0x19c
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  7885   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? crc32c+0x66/0x90
>  ? btrfs_lookup_dir_item+0x7d/0xc6
>  ? btrfs_lookup_dentry+0x9d/0x40c
>  ? d_alloc_parallel+0x28a/0x2cb
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? btrfs_lookup+0xe/0x2c
>  ? __lookup_slow+0xd4/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? futex_wake+0x11e/0x145
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  7889   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? __switch_to_asm+0x34/0x70
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? futex_wake+0x11e/0x145
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  3974   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  4048   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  4269   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? __count_memcg_events+0x11/0x4e
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  4273   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> hiawatha        D    0  4439   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? __count_memcg_events+0x11/0x4e
>  ? do_filp_open+0x52/0xaf
>  ? inet_recvmsg+0x6c/0x98
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> postgres        D    0  8067   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? crc32c+0x66/0x90
>  ? btrfs_lookup_dir_item+0x7d/0xc6
>  ? btrfs_lookup_dentry+0x9d/0x40c
>  ? d_alloc_parallel+0x28a/0x2cb
>  ? unlazy_walk+0x45/0x94
>  ? btrfs_lookup+0xe/0x2c
>  ? path_openat+0x5d1/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? kernel_wait4+0xca/0x113
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> postgres        D    0  8531   8067 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? crc32c+0x66/0x90
>  ? btrfs_lookup_dir_item+0x7d/0xc6
>  ? btrfs_lookup_dentry+0x9d/0x40c
>  ? d_alloc_parallel+0x28a/0x2cb
>  ? btrfs_lookup+0xe/0x2c
>  ? __lookup_slow+0xd4/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to+0x1c8/0x37f
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> postgres        D    0  8694   3086 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? crc32c+0x66/0x90
>  ? btrfs_lookup_dir_item+0x7d/0xc6
>  ? btrfs_lookup_dentry+0x9d/0x40c
>  ? d_alloc_parallel+0x28a/0x2cb
>  ? unlazy_walk+0x45/0x94
>  ? btrfs_lookup+0xe/0x2c
>  ? path_openat+0x5d1/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? kernel_wait4+0xca/0x113
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> postgres        D    0  8716   8694 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? d_alloc_parallel+0x1d1/0x2cb
>  ? wake_up_q+0x45/0x45
>  ? __lookup_slow+0x73/0x117
>  ? lookup_slow+0x3a/0x52
>  ? walk_component+0x84/0x112
>  ? inode_permission+0x7c/0x115
>  ? link_path_walk.part.53+0x112/0x420
>  ? path_openat+0x164/0xa5b
>  ? __bpf_prog_run32+0x34/0x52
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to+0x1c8/0x37f
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> unbound         D    0  9532   3421 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? unix_dgram_sendmsg+0x4b8/0x523
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> pdns_server     D    0 10415   9913 0x20020104
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? vfs_statx+0x96/0xce
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> pdns_server     D    0 10422   9913 0x20020104
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __switch_to_asm+0x40/0x70
>  ? schedule+0x60/0x71
>  ? __rwsem_down_read_failed_common+0x180/0x1df
>  ? call_rwsem_down_read_failed+0x14/0x30
>  ? down_read+0x1c/0x2f
>  ? lookup_slow+0x2a/0x52
>  ? walk_component+0x84/0x112
>  ? path_lookupat.isra.55+0x107/0x1c3
>  ? filename_lookup.part.71+0x6f/0xd2
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? kmem_cache_alloc+0x9a/0x100
>  ? getname_flags+0x49/0x156
>  ? do_faccessat+0xce/0x1c4
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> pdns_server     D    0 10423   9913 0x20020104
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __switch_to_asm+0x40/0x70
>  ? schedule+0x60/0x71
>  ? __rwsem_down_read_failed_common+0x180/0x1df
>  ? call_rwsem_down_read_failed+0x14/0x30
>  ? down_read+0x1c/0x2f
>  ? lookup_slow+0x2a/0x52
>  ? walk_component+0x84/0x112
>  ? path_lookupat.isra.55+0x107/0x1c3
>  ? filename_lookup.part.71+0x6f/0xd2
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? kmem_cache_alloc+0x9a/0x100
>  ? getname_flags+0x49/0x156
>  ? do_faccessat+0xce/0x1c4
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> pdns_server     D    0 10434   9913 0x20020104
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __switch_to_asm+0x40/0x70
>  ? schedule+0x60/0x71
>  ? __rwsem_down_read_failed_common+0x180/0x1df
>  ? call_rwsem_down_read_failed+0x14/0x30
>  ? down_read+0x1c/0x2f
>  ? lookup_slow+0x2a/0x52
>  ? walk_component+0x84/0x112
>  ? path_lookupat.isra.55+0x107/0x1c3
>  ? filename_lookup.part.71+0x6f/0xd2
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? kmem_cache_alloc+0x9a/0x100
>  ? getname_flags+0x49/0x156
>  ? do_faccessat+0xce/0x1c4
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> pdns_server     D    0 11724   9913 0x20020104
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_read_failed_common+0x180/0x1df
>  ? call_rwsem_down_read_failed+0x14/0x30
>  ? down_read+0x1c/0x2f
>  ? lookup_slow+0x2a/0x52
>  ? walk_component+0x84/0x112
>  ? path_lookupat.isra.55+0x107/0x1c3
>  ? filename_lookup.part.71+0x6f/0xd2
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? kmem_cache_alloc+0x9a/0x100
>  ? getname_flags+0x49/0x156
>  ? do_faccessat+0xce/0x1c4
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> mysqld          D    0  7366  12050 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_sync_file+0x247/0x321
>  ? do_fsync+0x2e/0x47
>  ? __x64_sys_fsync+0x10/0x13
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> qmgr            D    0 12580  12570 0x00000104
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_read_failed_common+0x180/0x1df
>  ? call_rwsem_down_read_failed_killable+0x14/0x30
>  ? down_read_killable+0x1c/0x40
>  ? iterate_dir+0x59/0x131
>  ? __do_sys_getdents+0x91/0xf6
>  ? filldir64+0xd0/0xd0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> kworker/u16:4   D    0 29942      2 0x80000000
> Workqueue: btrfs-endio-write btrfs_endio_write_helper
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? find_parent_nodes+0x89d/0x11df
>  ? btrfs_find_all_roots_safe+0x9e/0x10f
>  ? btrfs_find_all_roots_safe+0x9e/0x10f
>  ? btrfs_find_all_roots+0x58/0x77
>  ? btrfs_qgroup_trace_extent_post+0x38/0x7e
>  ? btrfs_add_delayed_tree_ref+0x2d9/0x300
>  ? add_pinned_bytes+0x38/0x38
>  ? btrfs_inc_extent_ref+0x74/0xe3
>  ? __btrfs_mod_ref+0x1bc/0x1eb
>  ? update_ref_for_cow+0x153/0x260
>  ? __btrfs_cow_block+0x205/0x457
>  ? btrfs_cow_block+0xc6/0x129
>  ? btrfs_search_slot+0x296/0x71d
>  ? __switch_to_asm+0x34/0x70
>  ? btrfs_lookup_file_extent+0x4b/0x66
>  ? __btrfs_drop_extents+0x158/0x9d6
>  ? kmem_cache_free+0x25/0xc4
>  ? __set_extent_bit+0x3d0/0x3f8
>  ? insert_reserved_file_extent.constprop.58+0x9d/0x2b8
>  ? btrfs_finish_ordered_io+0x2e1/0x5ac
>  ? normal_work_helper+0xfe/0x243
>  ? process_one_work+0x18d/0x271
>  ? rescuer_thread+0x278/0x278
>  ? worker_thread+0x194/0x23f
>  ? kthread+0xeb/0xf0
>  ? __kthread_cancel_work+0x68/0x68
>  ? ret_from_fork+0x35/0x40
> kworker/u16:3   D    0  9685      2 0x80000000
> Workqueue: btrfs-endio-write btrfs_endio_write_helper
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __switch_to_asm+0x34/0x70
>  ? schedule+0x60/0x71
>  ? btrfs_tree_read_lock+0xc1/0xf8
>  ? finish_wait+0x60/0x60
>  ? btrfs_read_lock_root_node+0x1d/0x3b
>  ? btrfs_search_slot+0x181/0x71d
>  ? kmem_cache_alloc_trace+0xaf/0xbd
>  ? btrfs_lookup_file_extent+0x4b/0x66
>  ? __btrfs_drop_extents+0x158/0x9d6
>  ? test_clear_page_writeback+0x151/0x164
>  ? kmem_cache_free+0x25/0xc4
>  ? __set_extent_bit+0x3d0/0x3f8
>  ? insert_reserved_file_extent.constprop.58+0x9d/0x2b8
>  ? btrfs_finish_ordered_io+0x2e1/0x5ac
>  ? normal_work_helper+0xfe/0x243
>  ? process_one_work+0x18d/0x271
>  ? rescuer_thread+0x278/0x278
>  ? worker_thread+0x194/0x23f
>  ? kthread+0xeb/0xf0
>  ? __kthread_cancel_work+0x68/0x68
>  ? ret_from_fork+0x35/0x40
> btrfs           D    0  9998   9896 0x00000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_commit_transaction+0x21c/0x711
>  ? finish_wait+0x60/0x60
>  ? btrfs_ioctl_send+0x579/0xc54
>  ? _btrfs_ioctl_send+0xaf/0xf2
>  ? _btrfs_ioctl_send+0xc7/0xf2
>  ? node_tag_clear+0x2a/0x69
>  ? idr_alloc_u32+0xa5/0xc8
>  ? __radix_tree_lookup+0x6b/0xa5
>  ? btrfs_ioctl+0x16e3/0x2a51
>  ? task_rq_unlock.isra.43+0xd/0x1f
>  ? cpu_cgroup_fork+0x4a/0x67
>  ? freezer_css_free+0xa/0xa
>  ? select_task_rq_fair+0x6da/0xb52
>  ? __accumulate_pelt_segments+0x29/0x3a
>  ? update_cfs_rq_load_avg+0x124/0x150
>  ? vfs_ioctl+0x1e/0x2b
>  ? btrfs_ioctl_get_supported_features+0x22/0x22
>  ? vfs_ioctl+0x1e/0x2b
>  ? do_vfs_ioctl+0x523/0x54c
>  ? task_rq_unlock.isra.43+0xd/0x1f
>  ? wake_up_new_task+0x110/0x12f
>  ? ksys_ioctl+0x3e/0x5d
>  ? __x64_sys_ioctl+0x16/0x19
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 14456  14452 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? do_sys_ftruncate+0xc6/0xf9
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 19976  19974 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> default.script  D    0 22674  11529 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 25502  25500 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0 27719  10299 0x20020100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? swap_free+0x53/0x6d
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> scp             D    0 31033  31029 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0  4039   4037 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0  9821   9819 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 15307  15305 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 20769  20767 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 26250  26248 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0 28466  10299 0x20020100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? step_into+0x58/0x1a8
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? path_openat+0x293/0xa5b
>  ? swap_free+0x53/0x6d
>  ? unlock_page+0xa/0x1b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> scp             D    0 31805  31803 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   418    417 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? kernel_wait4+0xe0/0x113
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   436    435 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0   439  10299 0x20020100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? step_into+0x58/0x1a8
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? path_openat+0x293/0xa5b
>  ? swap_free+0x53/0x6d
>  ? unlock_page+0xa/0x1b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> apt.systemd.dai D    0   452    451 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   465    463 0x00000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   491    489 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   510    505 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? kernel_wait4+0xe0/0x113
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   523    522 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> apt.systemd.dai D    0   535    534 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cp              D    0  3321   3320 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_setattr+0x234/0x499
>  ? notify_change+0x268/0x347
>  ? do_truncate+0x82/0xb6
>  ? path_openat+0x95a/0xa5b
>  ? _cond_resched+0x20/0x23
>  ? do_filp_open+0x52/0xaf
>  ? _copy_to_user+0x22/0x28
>  ? cp_new_stat+0x151/0x181
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0  4985   4981 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 10762  10760 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cp              D    0 10911  10909 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? __d_lookup_rcu+0xdb/0x109
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? _copy_to_user+0x22/0x28
>  ? cp_new_stat+0x151/0x181
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 16301  16296 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 22063  22059 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 28266  28264 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0 30615  10299 0x20020100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? step_into+0x58/0x1a8
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? path_openat+0x293/0xa5b
>  ? swap_free+0x53/0x6d
>  ? unlock_page+0xa/0x1b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> scp             D    0  1758   1754 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0  7952   7950 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 14337  14330 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 20292  20290 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 26358  26354 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 32592  32589 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0  2698  10299 0x20020100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? step_into+0x58/0x1a8
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? path_openat+0x293/0xa5b
>  ? swap_free+0x53/0x6d
>  ? unlock_page+0xa/0x1b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> scp             D    0  6570   6568 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 13064  13061 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 19322  19320 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 25998  25996 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> kworker/u16:5   D    0 30954      2 0x80000000
> Workqueue: writeback wb_workfn (flush-btrfs-1)
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? btrfs_tree_lock+0xb1/0x1a8
>  ? finish_wait+0x60/0x60
>  ? lock_extent_buffer_for_io+0x3b/0x166
>  ? btree_write_cache_pages+0x1cb/0x29b
>  ? do_writepages+0x2d/0x56
>  ? __writeback_single_inode+0x84/0x2d3
>  ? writeback_sb_inodes+0x220/0x3ad
>  ? wb_writeback+0x157/0x281
>  ? wb_workfn+0x134/0x2e5
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? __switch_to_asm+0x34/0x70
>  ? __switch_to_asm+0x40/0x70
>  ? finish_task_switch+0x113/0x1e6
>  ? process_one_work+0x18d/0x271
>  ? rescuer_thread+0x278/0x278
>  ? worker_thread+0x194/0x23f
>  ? kthread+0xeb/0xf0
>  ? __kthread_cancel_work+0x68/0x68
>  ? ret_from_fork+0x35/0x40
> scp             D    0 32252  32250 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0  6528   6526 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> verify          D    0  6825  12570 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_sync_file+0x247/0x321
>  ? do_fsync+0x2e/0x47
>  ? __x64_sys_fdatasync+0x13/0x16
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cleanup         D    0  6826  12570 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? do_filp_open+0x52/0xaf
>  ? pipe_read+0x21c/0x22f
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> cron            D    0  9378  10299 0x20020100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? step_into+0x58/0x1a8
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? path_openat+0x293/0xa5b
>  ? swap_free+0x53/0x6d
>  ? unlock_page+0xa/0x1b
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_int80_syscall_32+0x50/0x5d
>  ? entry_INT80_compat+0x7d/0x90
> scp             D    0 13410  13406 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 19990  19988 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> scp             D    0 26896  26894 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? __rwsem_down_write_failed_common+0x2ff/0x382
>  ? call_rwsem_down_write_failed+0x13/0x20
>  ? down_write+0x29/0x38
>  ? btrfs_file_write_iter+0xd6/0x485
>  ? pipe_read+0x21c/0x22f
>  ? __vfs_write+0x9b/0xd9
>  ? vfs_write+0xa2/0xdf
>  ? ksys_write+0x5e/0xa0
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> bash            D    0 30962  30930 0x00000100
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? schedule+0x60/0x71
>  ? wait_current_trans+0xa1/0xdf
>  ? finish_wait+0x60/0x60
>  ? start_transaction+0x1b2/0x329
>  ? btrfs_create+0x5a/0x1bd
>  ? path_openat+0x643/0xa5b
>  ? path_lookupat.isra.55+0x19c/0x1c3
>  ? do_filp_open+0x52/0xaf
>  ? _cond_resched+0x20/0x23
>  ? slab_pre_alloc_hook+0x2b/0x4d
>  ? slab_post_alloc_hook.isra.66+0xa/0x1a
>  ? __alloc_fd+0x136/0x149
>  ? do_sys_open+0x7c/0x119
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> sync            D    0 32082  31611 0x00000000
> Call Trace:
>  ? __schedule+0x4db/0x524
>  ? bdi_split_work_to_wbs+0xfa/0x186
>  ? default_file_splice_write+0x1f/0x1f
>  ? schedule+0x60/0x71
>  ? wb_wait_for_completion+0x5e/0x88
>  ? finish_wait+0x60/0x60
>  ? sync_inodes_sb+0xa7/0x226
>  ? __queue_work+0x244/0x257
>  ? default_file_splice_write+0x1f/0x1f
>  ? iterate_supers+0x73/0xb4
>  ? ksys_sync+0x41/0xa6
>  ? __ia32_sys_sync+0xa/0xd
>  ? do_syscall_64+0x4e/0x5b
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20


--L98cmhuFg5e4pvkHWOidz4xeO0aiO3Co3--

--NdnTbvlWMsfdCOVkWFQwG0WZzRdph64Bk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwl9qkACgkQwj2R86El
/qjOrwgAn2/Rmn0B3GYqOwbzdwzvvrAHE0sByVdWvPNI3gRlJv/VVzU/BVU28RVF
n3UN61g5x7IcYjJ5Cgo9LdqEmRU+ZWO4zFBLx1D/YkawM5fhAdiALv5sIbpdI3UL
q2L9FXO6y+jZeW/iu1QZLRh9Haa9rldP12i1prIXxOI7v2PFAlTq/CrfINF57fye
CY8s2cljNpS6ZYCEf9EEOSOnvfWhDETfBgJjFAVnt/ro0r8lWnvY+6fkmnLsuEsB
1mUR//LjaoUO/LrHCgqI/CKrjA7nJwOVPjxkC4TE36NeEI/yNItkfybr1zyqE9IA
LQFkiQU7husgsjeQflc58TbAOhvipA==
=eOfn
-----END PGP SIGNATURE-----

--NdnTbvlWMsfdCOVkWFQwG0WZzRdph64Bk--
