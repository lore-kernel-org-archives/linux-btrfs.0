Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsrv.kern.pm ([138.201.172.171]:43348 "EHLO vsrv.kern.pm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbdAaAXg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 19:23:36 -0500
Received: from authenticated-user
        by vsrv.kern.pm with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <pkern@debian.org>)
        id 1cYM6O-0000Vi-IE
        for linux-btrfs@vger.kernel.org; Tue, 31 Jan 2017 01:15:16 +0100
To: linux-btrfs@vger.kernel.org
From: Philipp Kern <pkern@debian.org>
Subject: Battling an issue with btrfs quota
Message-ID: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
Date: Tue, 31 Jan 2017 01:15:14 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bGQVJWpWUSQW9eTgsCVjWkG9Bok8EB4Vh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bGQVJWpWUSQW9eTgsCVjWkG9Bok8EB4Vh
Content-Type: multipart/mixed; boundary="T8CBFqg4ED0CqDMq0H5BTnwOHmndwAATk";
 protected-headers="v1"
From: Philipp Kern <pkern@debian.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <168f5009-d525-d5ce-3a04-631339c49ec8@debian.org>
Subject: Battling an issue with btrfs quota

--T8CBFqg4ED0CqDMq0H5BTnwOHmndwAATk
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

my btrfs-based system (~2.5 TiB stored in the filesystem replicated onto
on two disks, running kernel 4.9.6-1-ARCH) locked up after I enabled
quotas and had a btrfs-size tool running. Now the question is how to
recover from that. Whenever I mount the filesystem I end up with
btrfs-cleaner and a kworker hanging:

> [  491.154603] INFO: task kworker/u128:3:105 blocked for more than 120 =
seconds.
> [  491.188559]       Not tainted 4.9.6-1-ARCH #1
> [  491.209443] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
> [  491.247188] kworker/u128:3  D    0   105      2 0x00000000
> [  491.247208] Workqueue: btrfs-qgroup-rescan btrfs_qgroup_rescan_helpe=
r [btrfs]
> [  491.247210]  ffff880103bc8800 0000000000000000 ffff8801034ba7c0 ffff=
8801062580c0
> [  491.247213]  ffff880105fe8d40 ffffc90000c63c30 ffffffff81605cdf ffff=
8801034ba7c0
> [  491.247215]  0000000000000001 ffff8801062580c0 ffffffff810aa490 ffff=
8801034ba7c0
> [  491.247217] Call Trace:
> [  491.247222]  [<ffffffff81605cdf>] ? __schedule+0x22f/0x6e0
> [  491.247224]  [<ffffffff810aa490>] ? wake_up_q+0x80/0x80
> [  491.247226]  [<ffffffff816061cd>] schedule+0x3d/0x90
> [  491.247237]  [<ffffffffa01d248e>] wait_current_trans.isra.8+0xbe/0x1=
10 [btrfs]
> [  491.247240]  [<ffffffff810c4200>] ? wake_atomic_t_function+0x60/0x60=

> [  491.247249]  [<ffffffffa01d4d1c>] start_transaction+0x2bc/0x4a0 [btr=
fs]
> [  491.247258]  [<ffffffffa01d4f18>] btrfs_start_transaction+0x18/0x20 =
[btrfs]
> [  491.247267]  [<ffffffffa02442ba>] btrfs_qgroup_rescan_worker+0x7a/0x=
610 [btrfs]
> [  491.247278]  [<ffffffffa0209abd>] btrfs_scrubparity_helper+0x7d/0x35=
0 [btrfs]
> [  491.247288]  [<ffffffffa0209dde>] btrfs_qgroup_rescan_helper+0xe/0x1=
0 [btrfs]
> [  491.247291]  [<ffffffff81098a95>] process_one_work+0x1e5/0x470
> [  491.247292]  [<ffffffff81098d68>] worker_thread+0x48/0x4e0
> [  491.247294]  [<ffffffff81098d20>] ? process_one_work+0x470/0x470
> [  491.247296]  [<ffffffff8109e8f9>] kthread+0xd9/0xf0
> [  491.247298]  [<ffffffff8102d752>] ? __switch_to+0x2d2/0x630
> [  491.247299]  [<ffffffff8109e820>] ? kthread_park+0x60/0x60
> [  491.247301]  [<ffffffff8160a995>] ret_from_fork+0x25/0x30
> [  491.247306] INFO: task btrfs-cleaner:148 blocked for more than 120 s=
econds.
> [  491.280723]       Not tainted 4.9.6-1-ARCH #1
> [  491.302026] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
> [  491.340471] btrfs-cleaner   D    0   148      2 0x00000000
> [  491.340475]  ffff880103bc8800 0000000000000000 ffff8801032acf80 ffff=
8801062580c0
> [  491.340478]  ffff8801032a8d40 ffffc90000cc3cf0 ffffffff81605cdf ffff=
8801032acf80
> [  491.340480]  0000000000000001 ffff8801062580c0 ffffffff810aa490 ffff=
8801032acf80
> [  491.340482] Call Trace:
> [  491.340487]  [<ffffffff81605cdf>] ? __schedule+0x22f/0x6e0
> [  491.340489]  [<ffffffff810aa490>] ? wake_up_q+0x80/0x80
> [  491.340491]  [<ffffffff816061cd>] schedule+0x3d/0x90
> [  491.340505]  [<ffffffffa01d248e>] wait_current_trans.isra.8+0xbe/0x1=
10 [btrfs]
> [  491.340508]  [<ffffffff810c4200>] ? wake_atomic_t_function+0x60/0x60=

> [  491.340517]  [<ffffffffa01d4d1c>] start_transaction+0x2bc/0x4a0 [btr=
fs]
> [  491.340525]  [<ffffffffa01d4f18>] btrfs_start_transaction+0x18/0x20 =
[btrfs]
> [  491.340534]  [<ffffffffa01bb819>] btrfs_drop_snapshot+0x4e9/0x880 [b=
trfs]
> [  491.340542]  [<ffffffffa01d3e7b>] btrfs_clean_one_deleted_snapshot+0=
xbb/0x110 [btrfs]
> [  491.340552]  [<ffffffffa01ca7f1>] cleaner_kthread+0x141/0x1b0 [btrfs=
]
> [  491.340560]  [<ffffffffa01ca6b0>] ? btrfs_destroy_pinned_extent+0x12=
0/0x120 [btrfs]
> [  491.340562]  [<ffffffff8109e8f9>] kthread+0xd9/0xf0
> [  491.340564]  [<ffffffff8102d752>] ? __switch_to+0x2d2/0x630
> [  491.340565]  [<ffffffff8109e820>] ? kthread_park+0x60/0x60
> [  491.340566]  [<ffffffff8160a995>] ret_from_fork+0x25/0x30

Unfortunately whenever I try to execute a btrfs command against the
mounted filesystem -- e.g. to disable quota -- the command hangs. And
unfortunately that's in a shell without job control over a serial console=
=2E

Relevant output from ps:

>   105 0            0 DW   [kworker/u128:3]
>   107 0            0 SW   [kworker/u128:5]
>   111 0            0 SW<  [bioset]
>   112 0            0 SW<  [bioset]
>   113 0            0 SW<  [bioset]
>   115 0            0 SW   [kworker/1:2]
>   117 0            0 SW<  [kworker/0:1H]
>   118 0            0 SW<  [kworker/1:1H]
>   122 0            0 SW<  [bioset]
>   123 0         6724 S    sh -i
>   128 0            0 SW<  [btrfs-worker]
>   129 0            0 SW<  [kworker/u129:0]
>   130 0            0 SW<  [btrfs-worker-hi]
>   131 0            0 SW<  [btrfs-delalloc]
>   132 0            0 SW<  [btrfs-flush_del]
>   133 0            0 SW<  [btrfs-cache]
>   134 0            0 SW<  [btrfs-submit]
>   135 0            0 SW<  [btrfs-fixup]
>   136 0            0 SW<  [btrfs-endio]
>   137 0            0 SW<  [btrfs-endio-met]
>   138 0            0 SW<  [btrfs-endio-met]
>   139 0            0 SW<  [btrfs-endio-rai]
>   140 0            0 SW<  [btrfs-endio-rep]
>   141 0            0 SW<  [btrfs-rmw]
>   142 0            0 SW<  [btrfs-endio-wri]
>   143 0            0 SW<  [btrfs-freespace]
>   144 0            0 SW<  [btrfs-delayed-m]
>   145 0            0 SW<  [btrfs-readahead]
>   146 0            0 SW<  [btrfs-qgroup-re]
>   147 0            0 SW<  [btrfs-extent-re]
>   148 0            0 DW   [btrfs-cleaner]
>   149 0            0 RW   [btrfs-transacti]

So there's always a running btrfs-transaction. The kernel messages start
off like this:

> [    3.900674] BTRFS: device fsid e7ef324b-c81e-4ccf-941d-713b807ffab4 =
devid 1 transid 2030007 /dev/sdb2
> [    3.942600] BTRFS: device fsid e7ef324b-c81e-4ccf-941d-713b807ffab4 =
devid 2 transid 2030007 /dev/sda2
> [   14.569488] BTRFS info (device sda2): disk space caching is enabled
> [   14.569491] BTRFS info (device sda2): has skinny extents
> [   14.826782] random: crng init done
> [   30.738810] BTRFS info (device sda2): checking UUID tree
> [   62.916772] BTRFS info (device sda2): The free space cache file (880=
598319104) is invalid. skip it
> [   62.916772]=20

The actual disk traffic quiets down after a while, without any further
message printed into dmesg -- it'd be useful to know when it's done
checking the UUID tree.

Long story short: Is there a way for me to disable quotas again without
mounting the filesystem? Or a way to get btrfs to not spawn cleanup
tasks before I can disable quotas? I have many, many qgroups now because
of many snapshots created by snapper. Even if I try to touch these the
command hangs.

Kind regards and thanks
Philipp Kern


--T8CBFqg4ED0CqDMq0H5BTnwOHmndwAATk--

--bGQVJWpWUSQW9eTgsCVjWkG9Bok8EB4Vh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFFBAEBCAAvFiEEPzuChCNsw7gPxr3/RG4lRTXQVuwFAliP1xMRHHBrZXJuQGRl
Ymlhbi5vcmcACgkQRG4lRTXQVuyfqwf7BzkjauBaZhfjflUi2lGP9/mZOGkMsupY
A6btQASAgl+wt8JvoWu5IUuWkgr/UOjXinfgXpqBoPVV8Pd2ohaqvGkQ8bY+o6cz
qmT/K7gDtmGAjVwjMojYbCkbQ18bhA8FaXnlT01UB34WHn1O5teOZxqw4TxuEi09
thrcnC3qxB9GLzusgZADdyc96TeN1UW/uEtsqM3tephJiw55xEV2aQw6rPEJUyPN
uc2emLGPyC0+QLuodj8KcyHoaYtCDJG+x4zHsKUGa8ZY3MJlyO8sEHpmohRHoVis
E/dEkgn+7IVULCK0mED2qRbft0cbl0zjID8qrrDdw44BrFjptAQZxg==
=AzA7
-----END PGP SIGNATURE-----

--bGQVJWpWUSQW9eTgsCVjWkG9Bok8EB4Vh--
