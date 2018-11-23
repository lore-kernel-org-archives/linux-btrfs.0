Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB49C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 09:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299B820663
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 09:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 299B820663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503016AbeKWUjW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 15:39:22 -0500
Received: from mout.gmx.net ([212.227.15.15]:49831 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387933AbeKWUjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 15:39:21 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Llm5o-1fqnMu0e3c-00ZTHc; Fri, 23
 Nov 2018 10:55:45 +0100
Subject: Re: [[Missing subject]]
To:     Andy Leadbetter <andy.leadbetter@theleadbetters.com>,
        linux-btrfs@vger.kernel.org
References: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>
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
Message-ID: <7526c43f-dac7-3a32-9c53-42f3f6fa9072@gmx.com>
Date:   Fri, 23 Nov 2018 17:55:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PR1HV6yLgfLwYcmuoYZ9H8giaJZ1qvgOt"
X-Provags-ID: V03:K1:cK5AH0TFJ77U5pYW37k9gzkyIV8AT/i6ZuZbz3Y/EEXvt5q7p8p
 vqa/P7ZtVddYMFXxI4BqHjSQgmJeaBTF7MMP7jMOy2EnUHfgdYOePuDSe+Pern5xXsZDc0j
 /kdbkXRW1R/kdnow7xMt40s80fRND7xdUHDyXOeT9hyCzOfOuqava0C/puxrHjF+3QT9kpC
 vGD5FtUOaJZlqrhtL7Sqg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OoAt6ehJyBg=:uNaW7eKpm01tASgSgDmq8M
 BcZf24GJ0C9XmNVOQU/tdEwQ9rJGtMd7SVphoA/C/bj0vb/uVhMxdsb//o7rmMCrnP5QsT5XT
 S3XvAKQrbf/yvr2/Zrn+e8C7qoTkzxPABDQhcG8cZAi+eNiV845gZ8zX63KuHZysgXxH/3+P5
 xC8DU70eXiuvP1z0OY85ZUjTRrnLTPbhZIcza0cFpHYPXJnl3XTEElsD1WwkYqefMi5cozSly
 IAeJvblxKnm4+ypXhmpO2kNP0CoOCx64f0NBEGtbU2njOLM1ZZkC/t2vuEnzywmS0SIUJtf7N
 Jk8YaL5lX28IZQtxurfQEb04WbOLFhrpKSeX3gBVCRdCDdRSWQpJgERz7/57tWMvj/Yqfyq7x
 lBV93WuH0F2ypeEL7h4acMwccqxSm5/cmNtxCvAQenopevwgyucrk0hItBop+t5Yz3ig9SEf6
 kH5KUZtC++FtABEAYuDv+2lXVZLuvR3GeHI5CZGbhx/vynb83zZAe7dEDt6he85C8z3FEJRxY
 yX+So2crsswQl3SDmRyBw3IAsZYP2bbAPyecaemfEd7bjCsLncozgS+wLcB3W6Fccc96lCFwC
 Esj3uIfTXglEJ7DuvchhT3sJ7LVUINU1k0SDL8GZsWyFTWfyo4P/cBb5A8b+ES6sRDjjSeB+1
 +h7bqFKZ4Q2+z7dXGMWQZh96KQIvvh3hfGMrkUkJYAAE590iwN1Ta20m0yy668gQKUzMVQ3b6
 RWrmfnQFXmmKmzsqf6csS8gpQj5z2gxAUnqQLa7JXbbBI59x34C0hihXoGmFx2uaCJphUDRdi
 wzOMRdFgxcfitoD7on/TSlUPJrHHLJNIwuRS6RIA/DErkRWn5Qir9MyUL/vbNTTyBilaVO057
 kDNKe5pkzr3xigAxOJe1bZ1z7vmGzg8qGtxYtSKeo=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PR1HV6yLgfLwYcmuoYZ9H8giaJZ1qvgOt
Content-Type: multipart/mixed; boundary="KA3wBDOJj2iozm496e4K1WiyL86rK6DZe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Andy Leadbetter <andy.leadbetter@theleadbetters.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <7526c43f-dac7-3a32-9c53-42f3f6fa9072@gmx.com>
Subject: Re: [[Missing subject]]
References: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>
In-Reply-To: <CAJUWh6qyHerKg=-oaFN+USa10_Aag5+SYjBOeLCX1qM+WcDUwA@mail.gmail.com>

--KA3wBDOJj2iozm496e4K1WiyL86rK6DZe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/23 =E4=B8=8B=E5=8D=882:41, Andy Leadbetter wrote:
> I have a failing 2TB disk that is part of a 4 disk RAID 6 system.  I
> have added a new 2TB disk to the computer, and started a BTRFS replace
> for the old and new disk.  The process starts correctly however some
> hours into the job, there is an error and kernel oops. relevant log
> below.
>=20
> The disks are configured on top of bcache, in 5 arrays with a small
> 128GB SSD cache shared.  The system in this configuration has worked
> perfectly for 3 years, until 2 weeks ago csum errors started
> appearing.  I have a crashplan backup of all files on the disk, so I
> am not concerned about data loss, but I would like to avoid rebuild
> the system.
>=20
> btrfs dev stats shows
> [/dev/bcache0].write_io_errs    0
> [/dev/bcache0].read_io_errs     0
> [/dev/bcache0].flush_io_errs    0
> [/dev/bcache0].corruption_errs  0
> [/dev/bcache0].generation_errs  0
> [/dev/bcache1].write_io_errs    0
> [/dev/bcache1].read_io_errs     20
> [/dev/bcache1].flush_io_errs    0
> [/dev/bcache1].corruption_errs  0
> [/dev/bcache1].generation_errs  14

Unfortunately, this is not a sign of degrading disk, but something
really went wrong, screwing up some metadata.

For such case, it's recommended to do a "btrfs check --readonly", to
show how serious the problem is.

It could be some subvolume corruption, or some non-essential tree, but
anyway the generation mismatch is a problem that neither kernel or
btrfs-progs has a real good solution.

So at least please consider rebuild the fs.

Despite that, it's recommended to provide the versions of all the
kernels run on the fs, along with the mount option used.

We had some similar reports on such generation mismatch, but still we
don't have a convincing cause for it.
=46rom old kernel to space cache corruption to powerloss + space cache
corruption.

> [/dev/bcache3].write_io_errs    0
> [/dev/bcache3].read_io_errs     0
> [/dev/bcache3].flush_io_errs    0
> [/dev/bcache3].corruption_errs  0
> [/dev/bcache3].generation_errs  19
> [/dev/bcache2].write_io_errs    0
> [/dev/bcache2].read_io_errs     0
> [/dev/bcache2].flush_io_errs    0
> [/dev/bcache2].corruption_errs  0
> [/dev/bcache2].generation_errs  2
>=20
> and a smart test of the backing disk /dev/bcache1 shows a high read
> error rate, and lot of reallocated sectors.  The disk is 10 years old,
> and has clearly started to fail.
>=20
> I've tried the latest kernel, and the latest tools, but nothing will
> allow me to replace, or delete the failed disk.
>=20
>   884.171025] BTRFS info (device bcache0): dev_replace from
> /dev/bcache1 (devid 2) to /dev/bcache4 started
> [ 3301.101958] BTRFS error (device bcache0): parent transid verify
> failed on 8251260944384 wanted 640926 found 640907
> [ 3301.241214] BTRFS error (device bcache0): parent transid verify
> failed on 8251260944384 wanted 640926 found 640907
> [ 3301.241398] BTRFS error (device bcache0): parent transid verify
> failed on 8251260944384 wanted 640926 found 640907
> [ 3301.241513] BTRFS error (device bcache0): parent transid verify
> failed on 8251260944384 wanted 640926 found 640907

If btrfs check --readonly only reports this problem, it may be possible
for us to fix it.

Please also do a tree block dump on this block by:
# btrfs ins dump-tree -b 8251260944384 /dev/bcache0

If btrfs check --readonly reports a lot of problems, then it's strongly
recommended to rebuild the filesystem.

Thanks,
Qu

> [ 3302.381094] BTRFS error (device bcache0):
> btrfs_scrub_dev(/dev/bcache1, 2, /dev/bcache4) failed -5
> [ 3302.394612] WARNING: CPU: 0 PID: 5936 at
> /build/linux-5s7Xkn/linux-4.15.0/fs/btrfs/dev-replace.c:413
> btrfs_dev_replace_start+0x281/0x320 [btrfs]
> [ 3302.394613] Modules linked in: btrfs zstd_compress xor raid6_pq
> bcache intel_rapl x86_pkg_temp_thermal intel_powerclamp
> snd_hda_codec_hdmi coretemp kvm_intel snd_hda_codec_realtek kvm
> snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core
> irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hwdep
> snd_pcm pcbc snd_seq_midi aesni_intel snd_seq_midi_event joydev
> input_leds aes_x86_64 snd_rawmidi crypto_simd glue_helper snd_seq
> eeepc_wmi cryptd asus_wmi snd_seq_device snd_timer wmi_bmof
> sparse_keymap snd intel_cstate intel_rapl_perf soundcore mei_me mei
> shpchp mac_hid sch_fq_codel acpi_pad parport_pc ppdev lp parport
> ip_tables x_tables autofs4 overlay nls_iso8859_1 dm_mirror
> dm_region_hash dm_log hid_generic usbhid hid uas usb_storage i915
> i2c_algo_bit drm_kms_helper syscopyarea sysfillrect
> [ 3302.394640]  sysimgblt fb_sys_fops r8169 mxm_wmi mii drm ahci
> libahci wmi video
> [ 3302.394646] CPU: 0 PID: 5936 Comm: btrfs Not tainted
> 4.15.0-20-generic #21-Ubuntu
> [ 3302.394646] Hardware name: System manufacturer System Product
> Name/H110M-R, BIOS 3404 10/10/2017
> [ 3302.394658] RIP: 0010:btrfs_dev_replace_start+0x281/0x320 [btrfs]
> [ 3302.394659] RSP: 0018:ffffa8b582b5fd18 EFLAGS: 00010282
> [ 3302.394660] RAX: 00000000fffffffb RBX: ffff927d3afe0000 RCX: 0000000=
000000000
> [ 3302.394660] RDX: 0000000000000001 RSI: 0000000000000296 RDI: ffff927=
d3afece90
> [ 3302.394661] RBP: ffffa8b582b5fd68 R08: 0000000000000000 R09: ffffa8b=
582b5fc18
> [ 3302.394662] R10: ffffa8b582b5fd10 R11: 0000000000000000 R12: ffff927=
d3afece20
> [ 3302.394662] R13: ffff927d34b59421 R14: ffff927d34b59020 R15: 0000000=
000000001
> [ 3302.394663] FS:  00007fba4831c8c0(0000) GS:ffff927df6c00000(0000)
> knlGS:0000000000000000
> [ 3302.394664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3302.394664] CR2: 00002b9b83db85b8 CR3: 0000000164d3a002 CR4: 0000000=
0003606f0
> [ 3302.394665] Call Trace:
> [ 3302.394676]  btrfs_dev_replace_by_ioctl+0x39/0x60 [btrfs]
> [ 3302.394686]  btrfs_ioctl+0x1988/0x2080 [btrfs]
> [ 3302.394689]  ? iput+0x8d/0x220
> [ 3302.394690]  ? __blkdev_put+0x199/0x1f0
> [ 3302.394692]  do_vfs_ioctl+0xa8/0x630
> [ 3302.394701]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
> [ 3302.394703]  ? do_vfs_ioctl+0xa8/0x630
> [ 3302.394704]  ? do_sigaction+0xb4/0x1e0
> [ 3302.394706]  SyS_ioctl+0x79/0x90
> [ 3302.394708]  do_syscall_64+0x73/0x130
> [ 3302.394710]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [ 3302.394711] RIP: 0033:0x7fba471085d7
> [ 3302.394712] RSP: 002b:00007ffe5af753b8 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [ 3302.394713] RAX: ffffffffffffffda RBX: 000055a8eecfb2a0 RCX: 00007fb=
a471085d7
> [ 3302.394713] RDX: 00007ffe5af757f8 RSI: 00000000ca289435 RDI: 0000000=
000000003
> [ 3302.394714] RBP: 00000000ffffffff R08: 0000000000000000 R09: 00007fb=
a47160f00
> [ 3302.394715] R10: 0000000000000008 R11: 0000000000000246 R12: 00007ff=
e5af7880d
> [ 3302.394715] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000=
000000004
> [ 3302.394716] Code: 88 98 00 00 00 48 8b b0 90 00 00 00 6a 01 e8 67
> 9b fe ff 48 89 df 89 c6 e8 0d f8 ff ff 83 f8 8d 5a 74 6d 85 c0 0f 84
> 19 fe ff ff <0f> 0b e9 12 fe ff ff 89 c2 48 c7 c6 81 c1 c1 c0 48 89 df
> e8 f7
> [ 3302.394736] ---[ end trace a5f8501fc7a5d644 ]---e
>=20


--KA3wBDOJj2iozm496e4K1WiyL86rK6DZe--

--PR1HV6yLgfLwYcmuoYZ9H8giaJZ1qvgOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv3zpwACgkQwj2R86El
/qgz2ggAqD0sWllTj2zHe7evPmGzpctC6Cqd0T79H9Ht2DGSGrHZ/hQceS9KdrKk
PjsX5pOomnNDwa7WAGe4vnf8Qh9PkdSO8R1q3RcjpdB07sJA71sqjuZldSzN5/Gy
LkvlA1zqoIKhOCe+MbXqXAx6I/Bk4/40XFlIoZO/zKfoMsQwTpSHhReMDDRQeuTr
PSFIF3bABtJVFUfxl54xIWXoPqZX+GG1VJ61pNMDYOvByptFjAqVAGi88DGaWkHY
1uCZob/LaM7CA1AFom134fQEOHNYwjFpeE8xPq1AQuqkhT/TMMhUIJWh34+ULaex
3nNnTIVGlkuQbMC/217cu7b8YAQw7g==
=fT8R
-----END PGP SIGNATURE-----

--PR1HV6yLgfLwYcmuoYZ9H8giaJZ1qvgOt--
