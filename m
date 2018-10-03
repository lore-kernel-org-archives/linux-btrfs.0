Return-Path: <SRS0=JEJz=MP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDC8C64EBD
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 00:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D58E2082A
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 00:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D58E2082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbeJCHIF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 03:08:05 -0400
Received: from mout.gmx.net ([212.227.15.19]:45211 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725724AbeJCHIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Oct 2018 03:08:05 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MH07e-1futji1B0E-00DprF; Wed, 03
 Oct 2018 02:22:05 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MH07e-1futji1B0E-00DprF; Wed, 03
 Oct 2018 02:22:05 +0200
Subject: Re: Writing a large file causes odd freeze
To:     Gerard Saraber <gsaraber@rarcoa.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
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
Message-ID: <281eee3a-a21b-4427-1def-87e29cc5dabd@gmx.com>
Date:   Wed, 3 Oct 2018 08:22:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oqx3EsJgAxFHa30CLwUUDZ1jUz9bz0JTQ"
X-Provags-ID: V03:K1:kjpOqbyCL79pSbB1QVx3iaINnD8S1EeSK8MzHPTwJHeJGk81zoD
 qczyMqmYN8GerIcq2nOx8Z8L/xtG7bQzyZmTmpKbayVU6CuX0wCOJhl+NVOVNxa4GLJzMS4
 7QfKVkj3WBaDuCo0I4i/MoI4DjsxyI4n37a5LR4fVLqmfEZVINEgCIZTYEp+h6Y9nBCWnSc
 B2opWulJwo/yv07s0NFig==
X-UI-Out-Filterresults: notjunk:1;V01:K0:LpnkoGFv1yQ=:8u35glEnfTP1+fmkRIaxk0
 0h0kwCTT/34JfZmjRrZA69d3h3Jjupst8uPQDLJZ1LctfUOAHm0j5FlJj3Ad1HALwF1tw0uZg
 n5Kp22xdVw/rX6G52eth4wZ8Ix0QuySmsaUpoZo98RR+tzTLM653PoNkT9ICjsiwarDQ/uzP6
 xIbCN07zkmAlF2P8CGfqreU5dfyCz83sHg6CznRK6UBKjm5aK6vBU7/xeaD0gH2V1Eml7b+L4
 M26Gy3lT8MvX3l5pXUpxgLMCTAjlvG1Ug2EO9KNMo91KUvTmHoM4q+jVv5I7W/v2YbBUcYeO0
 VOf7qqlrJsU+/ZCWsXAbNu8l7eo5xZU1tXSDPpCkR4P5wa4WptRQUnF5K57OW16i8i6eSdXTp
 Of3WM61owHZ0/oaH8uYEICwY5Iv8/cXLyh+9LLE9Kx0aHRTr/BL0P0+OCdRQdhUh2JpQq7Dwc
 ARZ25zHWFyhRskSUIZmY+OKZJ544VhTVQvZ66ce5pk1esJaowx2F6NKvJwq4wmJxSXSNAtESt
 kiHFBOPEdvDwP8oG9JpbJa7hkBAjKQKk2t+rK5i9MUzBzzpgzCxXxa41hDmGUowYSujW3EDXf
 AO3AeVOjd4wA1LMVoL4+KNqcOUmlpL4WiaMupKzX61YIPUWjMQLXC4PhFqfqP+KZim76yJn2d
 GJg9A8xo1eLjSf5a6YnXlfNES8z6kFNG6ZXz0mZeKB3UhPdKphv8eSK0VmsMOc7T4AQ7j/T2n
 firXptEgGHZLeR1vXPws/uTjX9SKrYG/rhL4IxaLoNib/s+JLyoKsjQTgOAe98361C7SoR2C/
 8FrM6+hm8YcCQhWccnpJ4kBNkHG2g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oqx3EsJgAxFHa30CLwUUDZ1jUz9bz0JTQ
Content-Type: multipart/mixed; boundary="qnCeeEInAl6f3oPRG1JzMDaudHnUqBy3b";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Gerard Saraber <gsaraber@rarcoa.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <281eee3a-a21b-4427-1def-87e29cc5dabd@gmx.com>
Subject: Re: Writing a large file causes odd freeze
References: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>
In-Reply-To: <CAPsdh31hOT+mjCJJCTFAnNpFOtCJtn=iCrwUKWvL0DZf70Qe2g@mail.gmail.com>

--qnCeeEInAl6f3oPRG1JzMDaudHnUqBy3b
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/2 =E4=B8=8B=E5=8D=889:31, Gerard Saraber wrote:
> I have a 25TB mirrored filesystem that I'm able to consistently freeze
> by ungzipping a large file.
> The filesystem scrubs complete without errors and smartd reports no
> errors at the moment.
>=20
> The command is:
> gzip -dc /btrfsarray/largefile.gz > /btrfs/db/output.sql
> At around 31GB it quits writing to the output file, and I start
> getting the 'hung task' messages in my kernel log.
> They are 3.0GB gzipped SQL dumps, that uncompress into about 42GB SQL
> dump files.

I assume you're not using qgroups, right?

Just to rule out some obvious transaction slowdown causes.

BTW, as you're already using space_cache=3Dv2, what about disable free
space cache completely?
If it's really caused by space cache writing at transaction committing
time, disabling it more or release reduce the hang time.

Thanks,
Qu

>=20
> after that 'ps auwx' completely hangs and I can't write to the
> filesystem anymore, no errors, the processes just hang. I can still
> read from the FS as far as I can tell.
> I'm not sure how to diagnose it, or if i've simply ran into some kind
> of bug (may not even be BTRFS related)
>=20
> Linux cloud1 4.18.10 #1 SMP Fri Sep 28 07:44:06 CDT 2018 x86_64 x86_64
> x86_64 GNU/Linux
> [ I think It used to work on 4.18.0-rcX ]
>=20
> Hardware specs:
>  AMD Ryzen Threadripper 1950X 16-Core Processor
> 128GB ram
> A bunch of 3-8TB SATA drives connected to the motherboard and a pair
> of LSI cards
>=20
> root@cloud1:~# btrfs fi usage /btrfsarray
> Overall:
>     Device size:                  79.14TiB
>     Device allocated:             55.38TiB
>     Device unallocated:           23.76TiB
>     Device missing:                  0.00B
>     Used:                         55.30TiB
>     Free (estimated):             11.91TiB      (min: 11.91TiB)
>     Data ratio:                       2.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>=20
> Data,RAID1: Size:27.61TiB, Used:27.58TiB
>    /dev/sda        1.64TiB
>    /dev/sdb        1.64TiB
>    /dev/sdc        1.87TiB
>    /dev/sdd        4.37TiB
>    /dev/sde        2.55TiB
>    /dev/sdf        2.55TiB
>    /dev/sdg        4.37TiB
>    /dev/sdh        4.36TiB
>    /dev/sdi        2.55TiB
>    /dev/sdj        4.36TiB
>    /dev/sdk        4.37TiB
>    /dev/sdl        1.64TiB
>    /dev/sdm        4.37TiB
>    /dev/sdn        2.54TiB
>    /dev/sdo        2.55TiB
>    /dev/sdp        2.55TiB
>    /dev/sdq        2.55TiB
>    /dev/sdr        4.37TiB
>=20
> Metadata,RAID1: Size:87.00GiB, Used:77.46GiB
>    /dev/sda        5.00GiB
>    /dev/sdb        5.00GiB
>    /dev/sdd       14.00GiB
>    /dev/sde       12.00GiB
>    /dev/sdf        8.00GiB
>    /dev/sdg        6.00GiB
>    /dev/sdh       20.00GiB
>    /dev/sdi       11.00GiB
>    /dev/sdj       19.00GiB
>    /dev/sdk        5.00GiB
>    /dev/sdl        6.00GiB
>    /dev/sdm        7.00GiB
>    /dev/sdn       17.00GiB
>    /dev/sdo        7.00GiB
>    /dev/sdp       13.00GiB
>    /dev/sdq       12.00GiB
>    /dev/sdr        7.00GiB
>=20
> System,RAID1: Size:32.00MiB, Used:5.19MiB
>    /dev/sdc       32.00MiB
>    /dev/sdr       32.00MiB
>=20
> Unallocated:
>    /dev/sda        1.08TiB
>    /dev/sdb        1.08TiB
>    /dev/sdc        5.40TiB
>    /dev/sdd        1.08TiB
>    /dev/sde        1.08TiB
>    /dev/sdf        1.08TiB
>    /dev/sdg        1.08TiB
>    /dev/sdh        1.08TiB
>    /dev/sdi        1.08TiB
>    /dev/sdj        1.08TiB
>    /dev/sdk        1.08TiB
>    /dev/sdl        1.08TiB
>    /dev/sdm        1.08TiB
>    /dev/sdn        1.08TiB
>    /dev/sdo        1.08TiB
>    /dev/sdp        1.08TiB
>    /dev/sdq        1.08TiB
>    /dev/sdr        1.08TiB
>=20
>=20
> Oct  2 08:02:25 cloud1 kernel: [165537.793055] INFO: task smbd:47578
> blocked for more than 120 seconds.
> Oct  2 08:02:25 cloud1 kernel: [165537.793068]       Not tainted 4.18.1=
0 #1
> Oct  2 08:02:25 cloud1 kernel: [165537.793079] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct  2 08:02:25 cloud1 kernel: [165537.793094] smbd            D    0
> 47578   3375 0x00000000
> Oct  2 08:02:25 cloud1 kernel: [165537.793096] Call Trace:
> Oct  2 08:02:25 cloud1 kernel: [165537.793098]  ? __schedule+0x299/0x88=
0
> Oct  2 08:02:25 cloud1 kernel: [165537.793100]  schedule+0x28/0x80
> Oct  2 08:02:25 cloud1 kernel: [165537.793102]  wait_current_trans+0xad=
/0xe0
> Oct  2 08:02:25 cloud1 kernel: [165537.793104]  ? wait_woken+0x80/0x80
> Oct  2 08:02:25 cloud1 kernel: [165537.793106]  start_transaction+0x2ee=
/0x3c0
> Oct  2 08:02:25 cloud1 kernel: [165537.793108]  btrfs_sync_file+0x279/0=
x400
> Oct  2 08:02:25 cloud1 kernel: [165537.793110]
> btrfs_file_write_iter+0x461/0x576
> Oct  2 08:02:25 cloud1 kernel: [165537.793111]  __vfs_write+0x114/0x1a0=

> Oct  2 08:02:25 cloud1 kernel: [165537.793113]  vfs_write+0xad/0x1a0
> Oct  2 08:02:25 cloud1 kernel: [165537.793115]  ksys_pwrite64+0x71/0x90=

> Oct  2 08:02:25 cloud1 kernel: [165537.793116]  ? __switch_to_asm+0x34/=
0x70
> Oct  2 08:02:25 cloud1 kernel: [165537.793117]  do_syscall_64+0x4f/0x10=
0
> Oct  2 08:02:25 cloud1 kernel: [165537.793119]
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Oct  2 08:02:25 cloud1 kernel: [165537.793120] RIP: 0033:0x7f82af38104f=

> Oct  2 08:02:25 cloud1 kernel: [165537.793120] Code: Bad RIP value.
> Oct  2 08:02:25 cloud1 kernel: [165537.793122] RSP:
> 002b:00007f8296b4fd70 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
> Oct  2 08:02:25 cloud1 kernel: [165537.793124] RAX: ffffffffffffffda
> RBX: 0000000000000009 RCX: 00007f82af38104f
> Oct  2 08:02:25 cloud1 kernel: [165537.793124] RDX: 0000000000001000
> RSI: 000055e06183fea0 RDI: 0000000000000009
> Oct  2 08:02:25 cloud1 kernel: [165537.793125] RBP: 000055e06183fea0
> R08: 0000000000000000 R09: 00007fffac636080
> Oct  2 08:02:25 cloud1 kernel: [165537.793126] R10: 00000000089c8000
> R11: 0000000000000293 R12: 0000000000001000
> Oct  2 08:02:25 cloud1 kernel: [165537.793127] R13: 00000000089c8000
> R14: 00007f82aa40e090 R15: 000055e0616b5f70
>=20
>=20
> Oct  2 08:04:25 cloud1 kernel: [165658.622345] INFO: task
> btrfs-transacti:12370 blocked for more than 120 seconds.
> Oct  2 08:04:25 cloud1 kernel: [165658.622366]       Not tainted 4.18.1=
0 #1
> Oct  2 08:04:25 cloud1 kernel: [165658.622378] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct  2 08:04:25 cloud1 kernel: [165658.622393] btrfs-transacti D    0
> 12370      2 0x80000000
> Oct  2 08:04:25 cloud1 kernel: [165658.622396] Call Trace:
> Oct  2 08:04:25 cloud1 kernel: [165658.622406]  ? __schedule+0x299/0x88=
0
> Oct  2 08:04:25 cloud1 kernel: [165658.622408]  ?
> _raw_spin_unlock_irqrestore+0xa/0x10
> Oct  2 08:04:25 cloud1 kernel: [165658.622410]  schedule+0x28/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622414]
> btrfs_commit_transaction+0x760/0x870
> Oct  2 08:04:25 cloud1 kernel: [165658.622418]  ? wait_woken+0x80/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622420]  transaction_kthread+0x1=
2e/0x150
> Oct  2 08:04:25 cloud1 kernel: [165658.622422]  ?
> btrfs_cleanup_transaction+0x520/0x520
> Oct  2 08:04:25 cloud1 kernel: [165658.622425]  kthread+0x113/0x130
> Oct  2 08:04:25 cloud1 kernel: [165658.622427]  ?
> kthread_create_worker_on_cpu+0x70/0x70
> Oct  2 08:04:25 cloud1 kernel: [165658.622428]  ret_from_fork+0x22/0x40=

> Oct  2 08:04:25 cloud1 kernel: [165658.622487] INFO: task jsvc:15530
> blocked for more than 120 seconds.
> Oct  2 08:04:25 cloud1 kernel: [165658.622501]       Not tainted 4.18.1=
0 #1
> Oct  2 08:04:25 cloud1 kernel: [165658.622512] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct  2 08:04:25 cloud1 kernel: [165658.622527] jsvc            D    0
> 15530  15312 0x00000120
> Oct  2 08:04:25 cloud1 kernel: [165658.622529] Call Trace:
> Oct  2 08:04:25 cloud1 kernel: [165658.622531]  ? __schedule+0x299/0x88=
0
> Oct  2 08:04:25 cloud1 kernel: [165658.622533]  schedule+0x28/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622536]
> btrfs_start_ordered_extent+0xea/0x120
> Oct  2 08:04:25 cloud1 kernel: [165658.622538]  ? wait_woken+0x80/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622540]  btrfs_page_mkwrite+0x1f=
3/0x500
> Oct  2 08:04:25 cloud1 kernel: [165658.622544]  do_page_mkwrite+0x31/0x=
90
> Oct  2 08:04:25 cloud1 kernel: [165658.622546]  do_wp_page+0x214/0x5a0
> Oct  2 08:04:25 cloud1 kernel: [165658.622548]  __handle_mm_fault+0xb6a=
/0x1260
> Oct  2 08:04:25 cloud1 kernel: [165658.622551]  ? __seccomp_filter+0x44=
/0x4c0
> Oct  2 08:04:25 cloud1 kernel: [165658.622553]  handle_mm_fault+0xc6/0x=
200
> Oct  2 08:04:25 cloud1 kernel: [165658.622556]  __do_page_fault+0x24c/0=
x4d0
> Oct  2 08:04:25 cloud1 kernel: [165658.622558]  ? page_fault+0x8/0x30
> Oct  2 08:04:25 cloud1 kernel: [165658.622559]  page_fault+0x1e/0x30
> Oct  2 08:04:25 cloud1 kernel: [165658.622562] RIP: 0033:0x7f9b5aadb47e=

> Oct  2 08:04:25 cloud1 kernel: [165658.622563] Code: Bad RIP value.
> Oct  2 08:04:25 cloud1 kernel: [165658.622569] RSP:
> 002b:00007f92dccced60 EFLAGS: 00010246
> Oct  2 08:04:25 cloud1 kernel: [165658.622571] RAX: 00009606c50d609c
> RBX: 00007f9b5c5a1c30 RCX: 0000000000000018
> Oct  2 08:04:25 cloud1 kernel: [165658.622572] RDX: 0000000000000000
> RSI: 00007f92dccced30 RDI: 0000000000000001
> Oct  2 08:04:25 cloud1 kernel: [165658.622572] RBP: 00007f92dccced70
> R08: 001f9c207abaa2b8 R09: 00007fff9f29c080
> Oct  2 08:04:25 cloud1 kernel: [165658.622573] R10: 00000000048732ba
> R11: 0000000000000001 R12: 0000000000000028
> Oct  2 08:04:25 cloud1 kernel: [165658.622574] R13: 0000561d92af6950
> R14: 0000000000000002 R15: 0000000000000001
> Oct  2 08:04:25 cloud1 kernel: [165658.622613] INFO: task mongod:23344
> blocked for more than 120 seconds.
> Oct  2 08:04:25 cloud1 kernel: [165658.622628]       Not tainted 4.18.1=
0 #1
> Oct  2 08:04:25 cloud1 kernel: [165658.622638] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct  2 08:04:25 cloud1 kernel: [165658.622653] mongod          D    0
> 23344  15560 0x00000120
> Oct  2 08:04:25 cloud1 kernel: [165658.622655] Call Trace:
> Oct  2 08:04:25 cloud1 kernel: [165658.622657]  ? __schedule+0x299/0x88=
0
> Oct  2 08:04:25 cloud1 kernel: [165658.622659]  schedule+0x28/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622661]
> btrfs_start_ordered_extent+0xea/0x120
> Oct  2 08:04:25 cloud1 kernel: [165658.622663]  ? wait_woken+0x80/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622665]
> btrfs_wait_ordered_range+0xbb/0x100
> Oct  2 08:04:25 cloud1 kernel: [165658.622667]  btrfs_sync_file+0x30c/0=
x400
> Oct  2 08:04:25 cloud1 kernel: [165658.622671]  do_fsync+0x38/0x60
> Oct  2 08:04:25 cloud1 kernel: [165658.622673]  __x64_sys_fdatasync+0x1=
3/0x20
> Oct  2 08:04:25 cloud1 kernel: [165658.622675]  do_syscall_64+0x4f/0x10=
0
> Oct  2 08:04:25 cloud1 kernel: [165658.622677]
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Oct  2 08:04:25 cloud1 kernel: [165658.622678] RIP: 0033:0x7f3d36c122e7=

> Oct  2 08:04:25 cloud1 kernel: [165658.622679] Code: Bad RIP value.
> Oct  2 08:04:25 cloud1 kernel: [165658.622681] RSP:
> 002b:00007f3d31aef560 EFLAGS: 00000293 ORIG_RAX: 000000000000004b
> Oct  2 08:04:25 cloud1 kernel: [165658.622683] RAX: ffffffffffffffda
> RBX: 000000000000000c RCX: 00007f3d36c122e7
> Oct  2 08:04:25 cloud1 kernel: [165658.622683] RDX: 0000000000000000
> RSI: 000000000000000c RDI: 000000000000000c
> Oct  2 08:04:25 cloud1 kernel: [165658.622684] RBP: 00007f3d31aef5a0
> R08: 00005633b3ab9c00 R09: 00007ffeef7a3080
> Oct  2 08:04:25 cloud1 kernel: [165658.622685] R10: 0000000004873546
> R11: 0000000000000293 R12: 00005633b3ab9cc0
> Oct  2 08:04:25 cloud1 kernel: [165658.622686] R13: 00005633b1075d90
> R14: 0000000000000000 R15: 00005633b39a20f8
> Oct  2 08:04:25 cloud1 kernel: [165658.622688] INFO: task ftdc:23347
> blocked for more than 120 seconds.
> Oct  2 08:04:25 cloud1 kernel: [165658.622702]       Not tainted 4.18.1=
0 #1
> Oct  2 08:04:25 cloud1 kernel: [165658.622713] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct  2 08:04:25 cloud1 kernel: [165658.622728] ftdc            D    0
> 23347  15560 0x00000120
> Oct  2 08:04:25 cloud1 kernel: [165658.622729] Call Trace:
> Oct  2 08:04:25 cloud1 kernel: [165658.622731]  ? __schedule+0x299/0x88=
0
> Oct  2 08:04:25 cloud1 kernel: [165658.622733]  schedule+0x28/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622735]  wait_current_trans+0xad=
/0xe0
> Oct  2 08:04:25 cloud1 kernel: [165658.622737]  ? wait_woken+0x80/0x80
> Oct  2 08:04:25 cloud1 kernel: [165658.622738]  start_transaction+0x2ee=
/0x3c0
> Oct  2 08:04:25 cloud1 kernel: [165658.622740]  btrfs_create+0x57/0x1f0=

> Oct  2 08:04:25 cloud1 kernel: [165658.622743]  path_openat+0x13c1/0x16=
a0
> Oct  2 08:04:25 cloud1 kernel: [165658.622746]  do_filp_open+0x9b/0x110=

> Oct  2 08:04:25 cloud1 kernel: [165658.622748]  ? try_lookup_one_len+0x=
70/0x70
> Oct  2 08:04:25 cloud1 kernel: [165658.622751]  ? close_pdeo+0x93/0xf0
> Oct  2 08:04:25 cloud1 kernel: [165658.622753]  ? __check_object_size+0=
xa7/0x1a0
> Oct  2 08:04:25 cloud1 kernel: [165658.622756]  ? __alloc_fd+0x3d/0x160=

> Oct  2 08:04:25 cloud1 kernel: [165658.622758]  ? do_sys_open+0x1bd/0x2=
50
> Oct  2 08:04:25 cloud1 kernel: [165658.622760]  do_sys_open+0x1bd/0x250=

> Oct  2 08:04:25 cloud1 kernel: [165658.622762]  do_syscall_64+0x4f/0x10=
0
> Oct  2 08:04:25 cloud1 kernel: [165658.622763]
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Oct  2 08:04:25 cloud1 kernel: [165658.622764] RIP: 0033:0x7f3d36c0ad19=

> Oct  2 08:04:25 cloud1 kernel: [165658.622765] Code: Bad RIP value.
> Oct  2 08:04:25 cloud1 kernel: [165658.622767] RSP:
> 002b:00007f3d302ec200 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
> Oct  2 08:04:25 cloud1 kernel: [165658.622769] RAX: ffffffffffffffda
> RBX: 00005633b7197d80 RCX: 00007f3d36c0ad19
> Oct  2 08:04:25 cloud1 kernel: [165658.622769] RDX: 0000000000000241
> RSI: 00005633b7106740 RDI: 00000000ffffff9c
> Oct  2 08:04:25 cloud1 kernel: [165658.622770] RBP: 00005633b1077b13
> R08: 0000000000000000 R09: 00005633b1077b14
> Oct  2 08:04:25 cloud1 kernel: [165658.622771] R10: 00000000000001b6
> R11: 0000000000000293 R12: 0000000000000004
> Oct  2 08:04:25 cloud1 kernel: [165658.622771] R13: 00005633b1077b12
> R14: 00007f3d302ec720 R15: 00005633b9942004
>=20


--qnCeeEInAl6f3oPRG1JzMDaudHnUqBy3b--

--oqx3EsJgAxFHa30CLwUUDZ1jUz9bz0JTQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu0C6gACgkQwj2R86El
/qhtGwf9FHFaGXPyXzPRb+kizfaU2XfWOeGqywXyJXmLvlXA8TwFtZXBxU2lqvfS
ua6b7AIQiYAyxQkOzXWPXhBSbr8B0WeG4tQWEc4X3s23HxKeeg1NW5vZBMK08DdJ
sd4FRyn63C4HOB/aZod1lL+ylxjSeUZj2aF9FxU4q1rCrNyqWV+sR7Dqel5oy2my
UEDlf/jB6h7hd2qMA0XD/nnsJkskyWyWCEs3nlFvVDuFY8mVtN+EJcUie8vP+gxs
CDDvY0a7nSHx3ZSQRCgnXr4L6B6lXl9nmMNFWRPv+lgtZFDstd6zozqMB5pLuiVi
U9XqW+H7iyZSgiTxg9h823j1gcYd9w==
=mLia
-----END PGP SIGNATURE-----

--oqx3EsJgAxFHa30CLwUUDZ1jUz9bz0JTQ--
