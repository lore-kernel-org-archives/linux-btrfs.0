Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PLING_QUERY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED56AC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC9A20656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfAOMzu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:55:50 -0500
Received: from mout.gmx.net ([212.227.15.18]:47443 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbfAOMzu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:55:50 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M70HF-1hUC720uvd-00wjVX; Tue, 15
 Jan 2019 13:55:46 +0100
Subject: Re: How to repair "btrfs_chunk_readonly: BUG_ON `!ce` triggered,
 value 1"?
To:     HIRAKI Hideaki <hhiraki@nig.ac.jp>, linux-btrfs@vger.kernel.org
References: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
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
Message-ID: <6520ff6f-c406-b0c2-a640-55d33883b5b8@gmx.com>
Date:   Tue, 15 Jan 2019 20:55:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3r8Kv1vplA3gESy2oaV9h3pcWDZUXgyRe"
X-Provags-ID: V03:K1:YE2WyZ5vZbf40Aoy7hEt7UzyT7zdx6FjgWA6RxqFJW5e6yXZQ7j
 FLEv2Pzd5XICUYrF9tk1YwJB2l61K5JYUg7plmQ2TuA1wYd/F90kAruTzoUex37S42Lb0oy
 NJN6wyva6ukwz5a0FDcz0/HsDTZ3pRez2q9e5a1dOGV0gFV2oYzennz0cRRgH/+SmlGE7CB
 CYx6QY3YWuwHbSAJ5hCKQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:hrAZUIaOsk8=:7NHyTrgpblyhxlUOIhba3C
 xtaXKAaot4CAeFeB3gmGY0UqgKInkQk8yX60Z7w0jnbEdq5VXK2KhmTEbUvmA21b4D2B4m76g
 k4B6mgj8smNTCOnjSKfJn7E+cgGailZSvDb77FgV9wS0PHUSr902ESo9y14Fu57D62aFRBJ6K
 5kqkwETlRl5UmGTlodYAoJkSH1hfihwmXbUYXIlSKH6rUY1vUZIwbAImkEhxWxfDXOy/rYVPt
 y7HmJC2WFQpNRsQWElfap82WPoLan42/XRbG8MBDfgOnIHG19EBhrqb0rbus+W927y6hqEJjw
 Jb0QLdQFD5bhhcBnC1f8UbpS07p/WgRW0OoefHgJPfFHgvDN7jDX8XkTxbnNz6dWqCQqK1N/F
 RDxnQGTimXYryTnwPK+UDX3uiaAMYH7BleYxsavop+UV3EeDNl+EFVMyLXsJ4x3dGrFDq8euQ
 yMmCtlTW6a9pZ6SVLGfoZOdPrM9SrvpFnt/ZioKk/ww830ARUz3ZW6Z+ANXUQwtDoMQuNnixZ
 u/96EAc/wEiB4jCOXlb001vd1MLGNylXlxIMlZvuilsVgSOc3uT9t4npJSkqM7yVxjJ9kkzUo
 VoS9XRbUbe5GIxNulRTY/ClVS1o8itM3XHUkVMhY3WdfsDflMfNxVCI1hphBj09zCPc/Jprkv
 3rkNA1Q8PSO1SM7aRwvuBIj8ekLaIDH6LtNMM+Tx0hK/CUCAhHOxiJAedPPmKHLX55AzmTgO/
 SNz+g3lbdmDpCwwX5SugFFBI78R8zU4xMu7Oac4O6E4XHKtaKRMBEKlGv51yCdAE85RcAbd5B
 gW4yDDtCkhUPQr8d+mQsFEEtcxsa3BiZIVlIYkSM4WeGTV6NZd9MlGSfwJnTfdYBDoGKvofqE
 v66vG9COFsQHo6M1OUv7BFKFa4dQisZnof0sSI4w7dZQD69s+IjawAyqNsoVVA
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3r8Kv1vplA3gESy2oaV9h3pcWDZUXgyRe
Content-Type: multipart/mixed; boundary="8364M8IqoQcRqZVvmOu2wu7om6bguP1nD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: HIRAKI Hideaki <hhiraki@nig.ac.jp>, linux-btrfs@vger.kernel.org
Message-ID: <6520ff6f-c406-b0c2-a640-55d33883b5b8@gmx.com>
Subject: Re: How to repair "btrfs_chunk_readonly: BUG_ON `!ce` triggered,
 value 1"?
References: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
In-Reply-To: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>

--8364M8IqoQcRqZVvmOu2wu7om6bguP1nD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8B=E5=8D=887:47, HIRAKI Hideaki wrote:
> Hello,
>=20
> I have two questions and a bug report.
>=20
> Once upon a time I converted an ext3 partition to BTRFS to mount on
> /var/lib/docker and was happy with it. Recently an error occured:
>=20
>  kernel: BTRFS info (device sdc1): leaf 2013170442240 total ptrs 171 fr=
ee space 6365
>  kernel: BTRFS error (device sdc1): eb 2013170442240 invalid extent inl=
ine ref type 182
>  kernel: BTRFS: Transaction aborted (error -22)
>  kernel: BTRFS: error (device sdc1) in btrfs_run_delayed_refs:3089: err=
no=3D-22 unknown
>  kernel: BTRFS info (device sdc1): forced readonly
>  kernel: BTRFS error (device sdc1): pending csums is 77824
>=20
> Now I know this was caused by the kernel upgrade from 4.12.5 to 4.14.83=
 which
> introduced an additional check of alignments rather than by a recent tr=
ivial
> file system corruption.

Nope, the alignment check is mostly done by tree-checker, but it's not
the case.

It's a really valid extent type checker, introduced by commit
167ce953ca55 ("Btrfs: add a helper to retrive extent inline ref type"),
which get merged into v4.14.

I'm not pretty sure why but this looks like either some corruption in
extent tree code, or just too old btrfs-convert.

> But I was hasty and commited such follies as hard
> resets on busy kernel, btrfs rescue chunk-recover -y,

Chunk-recovery is normally useless.

> btrfs check --repair,

And this could cause more problem unless you're really knowing the
problem can be fixed or your data isn't that important.

> etc. As you may expect, the partition is not mountable any more:
>=20
> # mount -o compress=3Dlzo,noatime /dev/sdc1 /mnt/temp
> mount: /mnt/temp: wrong fs type, bad option, bad superblock on /dev/sdc=
1, missing codepage or helper program, or other error.
>=20
>  kernel: BTRFS info (device sdc1): use lzo compression
>  kernel: BTRFS info (device sdc1): disk space caching is enabled
>  kernel: BTRFS info (device sdc1): has skinny extents
>  kernel: BTRFS info (device sdc1): bdev /dev/sdc1 errs: wr 1396, rd 0, =
flush 0, corrupt 0, gen 0
>  kernel: BTRFS error (device sdc1): logical 3955568533504 len 107374182=
4 found bg but no related chunk

Some bad recovery move caused more problem, one block group doesn't has
corresponding chunk.
I don't know exactly what the cause is.

>  kernel: BTRFS error (device sdc1): failed to read block groups: -2
>  kernel: BTRFS error (device sdc1): open_ctree failed
>=20
> Even btrfs check aborts:
>=20
> # btrfs check --repair /dev/sdc1> enabling repair mode
> Opening filesystem to check...
> volumes.c:1729: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
> btrfs(+0x2e246)[0x562a5547c246]
> btrfs(+0x30cac)[0x562a5547ecac]

This could be worked around.

diff --git a/volumes.c b/volumes.c
index 30090ce5f8e8..05deeed710fb 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1725,9 +1725,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info
*fs_info, u64 chunk_offset)
         * corresponding chunk, we will rebuild it later
         */
        ce =3D search_cache_extent(&map_tree->cache_tree, chunk_offset);
-       if (!fs_info->is_chunk_recover)
-               BUG_ON(!ce);
-       else
+       if (!ce)
                return 0;

        map =3D container_of(ce, struct map_lookup, ce);



> btrfs(btrfs_read_block_groups+0x27d)[0x562a55471f8d]
> btrfs(btrfs_setup_all_roots+0x35f)[0x562a5546bc9f]
> btrfs(+0x1e0cb)[0x562a5546c0cb]
> btrfs(open_ctree_fs_info+0x8c)[0x562a5546c2cc]
> btrfs(cmd_check+0x4db)[0x562a554b670b]
> btrfs(main+0x7a)[0x562a55461e2a]
> /lib64/libc.so.6(__libc_start_main+0xee)[0x7f83e3598bde]
> btrfs(_start+0x2a)[0x562a55461f3a]
> Aborted
>=20
> How to repair this file system?

Use above diff to allow btrfs check to continue.
But no --repair, and paste the output.

Unfortunately, I don't believe the chance of a proper recovery is high.

>=20
>=20
> The second question is about btrfs-restore. It doesn't restore subvolum=
es
> even when the destination path is in a BTRFS file system.

I had a plan to support snapshot/subvolume creation for btrfs-restore if
destination is btrfs, or supports reflink.

But that feature will be too late for your use case anyway.

> "btrfs restore -l"
> is to list subvolumes but the output lacks the path (relative to the to=
p
> level subvolume) information.

You could try my experimental patch:
https://patchwork.kernel.org/patch/10738583/

It provides kernel equivalent of btrfs-restore, using 'ro,skip_bg' mount
option.

If everything goes OK, then you should be able to get 'btrfs subv list'
working.

Thanks,
Qu

> With the information, the destination of
> btrfs-restore with the subvolumes could be prepared and hopefully
> "dockerd" would work properly with the restored file tree, though the f=
iles
> would be duplicated significantly.


>=20
> How can the subvolumes' paths be obtained from an unmountable file syst=
em?
>=20
>=20
> By the way, some constants in the source code had to be increased to ru=
n
> btrfs-restore for me.
>=20
> --- cmds-restore.c~   2018-11-03 19:06:34.000000000 +0900
> +++ cmds-restore.c    2019-01-09 00:34:17.000000000 +0900
> @@ -289,7 +289,7 @@ static int copy_one_inline(struct btrfs_
>  {
>         struct extent_buffer *leaf =3D path->nodes[0];
>         struct btrfs_file_extent_item *fi;
> -       char buf[4096];
> +       char buf[65536];
>         char *outbuf;
>         u64 ram_size;
>         ssize_t done;
> @@ -729,7 +729,7 @@ static int copy_file(struct btrfs_root *
>         }
> =20
>         while (1) {
> -               if (loops >=3D 0 && loops++ >=3D 1024) {
> +               if (loops >=3D 0 && loops++ >=3D 102400) {
>                         enum loop_response resp;
> =20
>                         resp =3D ask_to_continue(file);
> @@ -1007,7 +1007,7 @@ static int search_dir(struct btrfs_root
>         }
> =20
>         while (leaf) {
> -               if (loops++ >=3D 1024) {
> +               if (loops++ >=3D 102400) {
>                         printf("We have looped trying to restore files =
in %s "
>                                "too many times to be making progress, "=

>                                "stopping\n", in_dir);
>=20
> The first one is to avoid the abortion with "*** stack smashing detecte=
d ***".
> So, not only the increase but also a size checking code (at least) is
> necessary to fix this bug. I hope the other two constants (if necessary=
) will
> be tunable from the command line option.
>=20
>=20
> For your information:
>=20
> # uname -a
> Linux plcd1 4.14.83-gentoo #1 SMP Wed Dec 19 00:20:46 JST 2018 x86_64 I=
ntel(R) Core(TM) i7-3970X CPU @ 3.50GHz GenuineIntel GNU/Linux
>=20
> # btrfs --version
> btrfs-progs v4.19=20
>=20
> # btrfs fi show
> Label: none  uuid: 5e3d788d-5b81-4e3e-8776-5a131d008cbc
>         Total devices 1 FS bytes used 1.41TiB
>         devid    1 size 1.82TiB used 1.43TiB path /dev/sdc1
>=20
>=20
> Regards,
>=20
> Hideaki
>=20


--8364M8IqoQcRqZVvmOu2wu7om6bguP1nD--

--3r8Kv1vplA3gESy2oaV9h3pcWDZUXgyRe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw92EoACgkQwj2R86El
/qjkYgf8Cd0QGBlwogpQi8pG+KBpr6MxxvWjWBvtWDZGOmXWOz2GqArrIgZmcBYZ
8TU/sc2PP9GywOz73Ff03sO1MsKOhH1nip/2MRWeg7x217Jx7dSO9+6cFrtYSYxe
A9PZM8Wm/UjVATila0pgewJV8pRxaF8mFWrKRLtO+bfyFbb9vKLv0G2X3BuIqYVV
fHz89kchY5bhQ1a4FZROAxc8yrdX+vo+/Bs9pZ0ltzAG9FvrboQo3Sc/jgfsxWNH
D+SFoomcK8FBoBZDwUKI7JQoF0s0N8JKm9kV1MLoeXlSV/obFiABfAQXXYiHnMfF
D9ruAIR/bsxQxEGvHWDLquiVo55Crw==
=Q+06
-----END PGP SIGNATURE-----

--3r8Kv1vplA3gESy2oaV9h3pcWDZUXgyRe--
