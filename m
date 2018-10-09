Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22436C64EB0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 03:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D102075C
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 03:21:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7D102075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbeJIKgi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 06:36:38 -0400
Received: from mout.gmx.net ([212.227.17.20]:54905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbeJIKgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 06:36:38 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LvzF3-1fc6ek1dID-017oo5; Tue, 09
 Oct 2018 05:21:48 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LvzF3-1fc6ek1dID-017oo5; Tue, 09
 Oct 2018 05:21:48 +0200
Subject: Re: qgroups not enabled, but perf stats reports
 btrfs_qgroup_release_data and btrfs_qgroup_free_delayed_ref
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQau7DtuUUeycCkZ36qjbKuxNzsgqJ7+sJ6W0dK_NLE3w@mail.gmail.com>
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
Message-ID: <747cd19d-3f75-c972-aa3d-eebe8269644b@gmx.com>
Date:   Tue, 9 Oct 2018 11:21:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQau7DtuUUeycCkZ36qjbKuxNzsgqJ7+sJ6W0dK_NLE3w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8jfyW71d45oTo5Sa7tK7JWOPbmTP3hsLb"
X-Provags-ID: V03:K1:Oh6TYNToCBAcfTEdLeyFDui/XjRvOJb7Vpn+Ce29ena5DPgzfCq
 hBdDec7z7lVKmFFXm8JFLYhdcZWcWbXMf9XccEO7muZ7KFG7Qzg0MEx6HFi99khrjZOn5KX
 sPFBO2tFOhPu7y0BHQenwQvpi97fpY6EEdFm5sa3FGmx226IbjQnVgTETZh7I4q7hxQWHCP
 ozijv+HJywZle2qiRQYOQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:68dwamHdCPo=:4acmLXhqjyuAU/ttt4yDvv
 exxsjgcM2mfO+OYtdMc67Ohg6OGSzuc/jVSzZKevkP5HOJz6dnTfLSXQAKZTe/5cDeqrtTBbi
 Ye0YIazGXj9hOmDqCgMGzelp+ulutojK7jpsiokh0/ITaQ96Jsnd5FUZWYD/Thcti1ydMf79d
 vhXGfuEtsjYf4tLtElFOCWqTwSvu5GEXrBwWchOM7jq+Fyz7/82XIJLF/Sxmzd+Jj1CyDt3Ot
 wJ4jy8Fo+E1hN6zLoqJKvn6cz5D1EbXNB25/2qTT2knBzGtzQJ2GzvBxsZixgqqm4X5YTTaea
 lHQmhZfo7DCFV99vMGKTHVgPy+um4ep1czwpk5wdv2DFDYJXzg8va87hrGLtNV5y9AyTTbk6x
 PpLYKrW5Gb4Z8MfsSiFVEUoxMQLkAPWy0n3stQtTS769Jgss5amFGkxQXBgtmK7tAPLreS3k+
 d0fJGT8nAZSYDZ16jiXIkZ4zqCUxf9VU2awD1dB5P6bhBLWmG7vhZwATIKEEi87BhugRfN9qx
 u70OYmNF7Y7rC4ljyfo02irWkdBS/BN4y4BfDKGcu2EEBzG9LSXZF//ezol0Putzyc3RibtOc
 vDWy+4i4NiIZEaUQxfNLVFZPugRQUQ1c853Rkm2K3reoh2KDgIQkL7jyHB2VhUnNpJVT0oLD2
 rjmXr7UuGCf653pdiusewZAa1Ah+vVUb5fBs73AuBCzht3Q0pjCOUGI0K6hPzWLHxyLBdSUlV
 Chzf79mnuHD74YGT4zTqCqyF2bVO/QykGlUeDkAoq18866B1DnBgmIHjzr0KdwS2QPkbKN7r5
 26rdzc0UG5pEVoxSDgL1emqnBKCbg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8jfyW71d45oTo5Sa7tK7JWOPbmTP3hsLb
Content-Type: multipart/mixed; boundary="JxZ1iEVonqbly6QEpBqmGqEPQP8vxVbGT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <747cd19d-3f75-c972-aa3d-eebe8269644b@gmx.com>
Subject: Re: qgroups not enabled, but perf stats reports
 btrfs_qgroup_release_data and btrfs_qgroup_free_delayed_ref
References: <CAJCQCtQau7DtuUUeycCkZ36qjbKuxNzsgqJ7+sJ6W0dK_NLE3w@mail.gmail.com>
In-Reply-To: <CAJCQCtQau7DtuUUeycCkZ36qjbKuxNzsgqJ7+sJ6W0dK_NLE3w@mail.gmail.com>

--JxZ1iEVonqbly6QEpBqmGqEPQP8vxVbGT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/9 =E4=B8=8A=E5=8D=886:41, Chris Murphy wrote:
> [chris@flap ~]$ sudo perf stat -e 'btrfs:*' -a sleep 70
> ##And then I loaded a few sites in Firefox early on in those 70 seconds=
=2E
>=20
>  Performance counter stats for 'system wide':
>=20
>                  5      btrfs:btrfs_transaction_commit
>                 29      btrfs:btrfs_inode_new
>                 29      btrfs:btrfs_inode_request
>                 25      btrfs:btrfs_inode_evict
>              1,602      btrfs:btrfs_get_extent
>                  0      btrfs:btrfs_handle_em_exist
>                  1      btrfs:btrfs_get_extent_show_fi_regular
>                 88      btrfs:btrfs_truncate_show_fi_regular
>                 19      btrfs:btrfs_get_extent_show_fi_inline
>                  2      btrfs:btrfs_truncate_show_fi_inline
>                189      btrfs:btrfs_ordered_extent_add
>                189      btrfs:btrfs_ordered_extent_remove
>                  9      btrfs:btrfs_ordered_extent_start
>                592      btrfs:btrfs_ordered_extent_put
>              1,207      btrfs:__extent_writepage
>              1,203      btrfs:btrfs_writepage_end_io_hook
>                 25      btrfs:btrfs_sync_file
>                  0      btrfs:btrfs_sync_fs
>                  0      btrfs:btrfs_add_block_group
>              1,508      btrfs:add_delayed_tree_ref
>              1,498      btrfs:run_delayed_tree_ref
>                379      btrfs:add_delayed_data_ref
>                336      btrfs:run_delayed_data_ref
>              1,887      btrfs:add_delayed_ref_head
>              1,839      btrfs:run_delayed_ref_head
>                  0      btrfs:btrfs_chunk_alloc
>                  0      btrfs:btrfs_chunk_free
>                794      btrfs:btrfs_cow_block
>              6,982      btrfs:btrfs_space_reservation
>                  0      btrfs:btrfs_trigger_flush
>                  0      btrfs:btrfs_flush_space
>                952      btrfs:btrfs_reserved_extent_alloc
>                  0      btrfs:btrfs_reserved_extent_free
>              1,005      btrfs:find_free_extent
>              1,005      btrfs:btrfs_reserve_extent
>                816      btrfs:btrfs_reserve_extent_cluster
>                  1      btrfs:btrfs_find_cluster
>                  0      btrfs:btrfs_failed_cluster_setup
>                  1      btrfs:btrfs_setup_cluster
>              5,952      btrfs:alloc_extent_state
>              6,034      btrfs:free_extent_state
>                374      btrfs:btrfs_work_queued
>                362      btrfs:btrfs_work_sched
>                362      btrfs:btrfs_all_work_done
>                116      btrfs:btrfs_ordered_sched
>                  0      btrfs:btrfs_workqueue_alloc
>                  0      btrfs:btrfs_workqueue_destroy
>                  0      btrfs:btrfs_qgroup_reserve_data
>                201      btrfs:btrfs_qgroup_release_data
>              1,839      btrfs:btrfs_qgroup_free_delayed_ref
>                  0      btrfs:btrfs_qgroup_account_extents
>                  0      btrfs:btrfs_qgroup_trace_extent
>                  0      btrfs:btrfs_qgroup_account_extent
>                  0      btrfs:qgroup_update_counters
>                  0      btrfs:qgroup_update_reserve
>                  0      btrfs:qgroup_meta_reserve
>                  0      btrfs:qgroup_meta_convert
>                  0      btrfs:qgroup_meta_free_all_pertrans
>                  0      btrfs:btrfs_prelim_ref_merge
>                  0      btrfs:btrfs_prelim_ref_insert
>              2,663      btrfs:btrfs_inode_mod_outstanding_extents
>                  0      btrfs:btrfs_remove_block_group
>                  0      btrfs:btrfs_add_unused_block_group
>                  0      btrfs:btrfs_skip_unused_block_group
>=20
>       70.004723586 seconds time elapsed
>=20
> [chris@flap ~]$
>=20
>=20
> Seems like a lot of activity for just a few transactions, but what
> really caught my eye here is the qgroup reporting for a file system
> that has never had qgroups enabled. Is it expected?

Indeed some of them can be avoided, as for qgroup not enabled case, such
function is really doing nothing.

In the case of btrfs_qgroup_free_delayed_ref() case, it doesn't check if
qgroup is enabled and calls btrfs_qgroup_free_refroot() under all cases,
and expect btrfs_qgroup_free_refroot() to do some check.

However btrfs_qgroup_free_refroot() doesn't do any check on if qgroup is
enabled or not.
And btrfs_qgroup_free_refroot() will just find no corresponding qgroup
and exit.

Thanks for exposing such bug,
Qu


>=20
>=20
> Chris Murphy
>=20


--JxZ1iEVonqbly6QEpBqmGqEPQP8vxVbGT--

--8jfyW71d45oTo5Sa7tK7JWOPbmTP3hsLb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu8HsgACgkQwj2R86El
/qh3Swf+Plpjkpc0szwjKGBMKTYT38qH/GqADle2dYnAlkwkhUT5zWNuXsmV/lXU
oZOdGDK7qAjiXGJSo/eNCFUZ/jVyPrr6lLVxttj3XobUzwlHzSXWrOBY5CNK6/0w
nFg0EQ/Kd0KwiZgqTZ8MbQPkJbgGYV8WkxliLNDG/Z4KuiFhEO2L+DWwhKvbg5+n
NkoE0IJ8zuFY77Y4KKR1pyB4pxYtXD/qagGyyLiOwEZvePpr8n4QqEYiuZ5eDEuG
Zbjb8UiaK5bor4EdJnkiJn2md7uYlgsvhiw6n3QTCiDroiHxYkMZhw1pWArld0jr
lYnK2+ooxkdk1cAfHe04RwtE22UqZQ==
=lQJ1
-----END PGP SIGNATURE-----

--8jfyW71d45oTo5Sa7tK7JWOPbmTP3hsLb--
