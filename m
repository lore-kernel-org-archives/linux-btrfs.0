Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33EFC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 23:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B4502077C
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 23:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B4502077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbeKNJ5y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 04:57:54 -0500
Received: from mout.gmx.net ([212.227.17.21]:49531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbeKNJ5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 04:57:53 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MU0U9-1fvwTP3XjF-00QgL1; Wed, 14
 Nov 2018 00:57:03 +0100
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     fdmanana@gmail.com, dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181113170724.GE24115@twin.jikos.cz>
 <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
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
Message-ID: <6027bd4f-10fc-6c70-0967-5a932dc1612e@gmx.com>
Date:   Wed, 14 Nov 2018 07:56:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nNDXGDTm5laV63I0ywIHfKg9loGExzFUs"
X-Provags-ID: V03:K1:7O0LcbJ/ClvUGmhKqaUZcVoTWtnAdtL4WAdf3RwqYGH5vGPopxB
 r1x5eamAjmEq9D0UwBae8kKFFlEjzKgl5UfC12pdV8cxMqtFzFV2K8FO4lY82f+BWqJ1zZF
 0tkkI0tJJtxp6qwSIGhtEZPvehYELkyyyJwPczLiaoeCpP47DADOgONG2BD2Fr1+RR0JrwN
 BhHAU6ctoaaha8kNkki9A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:7MQJ+6SaVj0=:l23IQUbI0f+SiqsYzPa6/8
 q/kL7xQpstlNlU7ddAwpjFAE/TIBJtqOh2s5exxunVGtr+FA0FM3MoMDlUpQOGKyXT+JyjmHS
 jY1yQnqBMhajk5A+CTnbNYEuBNf5lXfCJbFC6uaoke0kT55aFglUE0xovoiZfKdn4+0nt9DT5
 GrMVdmz2j0RtA/6/OkCLYAHFuVbLrkN9z1+bvKZA949Ml4JrCcQBgmaXc+ykmh6eppuq9zfol
 GxpvQ9TUNEqY3tkKtaBlWipSUbla5RowoSpMSuPDugrSqHW9KKPW0+fbKVgSrnNpFd7m1xT+o
 8T4xOkqFZPVSHZjUVXFwu/e6HTGdv7PYTLuxb/4mMsrQU1UgY46OeJYJG1pzfsGKB31z27M/a
 SYZn/p5huenRLIV2FwoL5ghLSO36qP0nsQq9WRlwEd0DbxqYPlmWFYxUZuhnyahGgoENSlppO
 WulSe1WLAllqxboOR+Wq1FFx7t2Q91eEB+3peQPkBzLL5SO8j4jxQ+iNKSrduJSQuQDXOt53D
 gyEQf+LoLUjLlemnuaQuXgB4V6w/0Jvw4/ZY2FDaeY5a6TPRHsjWOx6aZqBb5W83/J7UVROTh
 KKnfiIZTESmxQpwrJvfi2HWnclEMnN9FDiSnWoS/8lAvw6AW6TyO1lsrAQukr8EYCy3PVXFqV
 lJqYoHHCYP+lY4vDD6HveONM2dPu+Q6NVBt/sj9XuiObHQag2n2s5F8r1Oh5zGZ7Ux9WSuwX5
 dwZ2J9Rdr0zcWcfe01IWao4QWSD0tJOoCkZhrkwp11AC/MF5YYTkeHbOpV8aWEX5eq3/qJIy5
 xLo/HD7yft2FkEesafVBgpUnfH7Rf+BzpLT4uFzFRuwguwXj2M5CQ7ZcKoOKx841NJlgwPdPC
 7ZoAZlnPNfDAp5K7vAHiAI70IiJzUiWh+CDIrv9Q7kM3rXbxEFJz4v2a8J+OzG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nNDXGDTm5laV63I0ywIHfKg9loGExzFUs
Content-Type: multipart/mixed; boundary="K7WhSvvDikxr0KWfZ4rBDDHJOonGaC3BH";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6027bd4f-10fc-6c70-0967-5a932dc1612e@gmx.com>
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz> <20181113170724.GE24115@twin.jikos.cz>
 <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>
In-Reply-To: <CAL3q7H5H+c6XzwCQP9=bS_TdUam1fFh3HOiWojDkNfdDsKj=yQ@mail.gmail.com>

--K7WhSvvDikxr0KWfZ4rBDDHJOonGaC3BH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/14 =E4=B8=8A=E5=8D=881:58, Filipe Manana wrote:
> On Tue, Nov 13, 2018 at 5:08 PM David Sterba <dsterba@suse.cz> wrote:
>>
>> On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
>>> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
>>>> This patchset can be fetched from github:
>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_reba=
sed
>>>>
>>>> Which is based on v4.20-rc1.
>>>
>>> Thanks, I'll add it to for-next soon.
>>
>> During test generic/517, the logs were full of the warning below. The =
reference
>> test on current master, effectively misc-4.20 which was used as base o=
f your
>> branch did not get the warning.
>>
>> [11540.167829] BTRFS: end < start 2519039 2519040
>> [11540.170513] WARNING: CPU: 1 PID: 539 at fs/btrfs/extent_io.c:436 in=
sert_state+0xd8/0x100 [btrfs]
>> [11540.174411] Modules linked in: dm_thin_pool dm_persistent_data dm_b=
ufio dm_bio_prison btrfs libcrc32c xor zstd_decompress zstd_compress xxha=
sh raid6_pq dm_mod loop [last unloaded: libcrc32c]
>> [11540.178279] CPU: 1 PID: 539 Comm: xfs_io Tainted: G      D W       =
  4.20.0-rc1-default+ #329
>> [11540.180616] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
>> [11540.183754] RIP: 0010:insert_state+0xd8/0x100 [btrfs]
>> [11540.189173] RSP: 0018:ffffa0d245eafb20 EFLAGS: 00010282
>> [11540.189885] RAX: 0000000000000000 RBX: ffff9f0bb3267320 RCX: 000000=
0000000000
>> [11540.191646] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffff=
ffa40c400d
>> [11540.192942] RBP: 0000000000266fff R08: 0000000000000001 R09: 000000=
0000000000
>> [11540.193871] R10: 0000000000000000 R11: ffffffffa629da2d R12: ffff9f=
0ba0281c60
>> [11540.195527] R13: 0000000000267000 R14: ffffa0d245eafb98 R15: ffffa0=
d245eafb90
>> [11540.197026] FS:  00007fa338eb4b80(0000) GS:ffff9f0bbd600000(0000) k=
nlGS:0000000000000000
>> [11540.198251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [11540.199698] CR2: 00007fa33873bfb8 CR3: 000000006fb6e000 CR4: 000000=
00000006e0
>> [11540.201428] Call Trace:
>> [11540.202164]  __set_extent_bit+0x43b/0x5b0 [btrfs]
>> [11540.203223]  lock_extent_bits+0x5d/0x210 [btrfs]
>> [11540.204346]  ? _raw_spin_unlock+0x24/0x40
>> [11540.205381]  ? test_range_bit+0xdf/0x130 [btrfs]
>> [11540.206573]  lock_extent_range+0xb8/0x150 [btrfs]
>> [11540.207696]  btrfs_double_extent_lock+0x78/0xb0 [btrfs]
>> [11540.208988]  btrfs_extent_same_range+0x131/0x4e0 [btrfs]
>> [11540.210237]  btrfs_remap_file_range+0x337/0x350 [btrfs]
>> [11540.211448]  vfs_dedupe_file_range_one+0x141/0x150
>> [11540.212622]  vfs_dedupe_file_range+0x146/0x1a0
>> [11540.213795]  do_vfs_ioctl+0x520/0x6c0
>> [11540.214711]  ? __fget+0x109/0x1e0
>> [11540.215616]  ksys_ioctl+0x3a/0x70
>> [11540.216233]  __x64_sys_ioctl+0x16/0x20
>> [11540.216860]  do_syscall_64+0x54/0x180
>> [11540.217409]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> [11540.218126] RIP: 0033:0x7fa338a4daa7
>=20
> That's the infinite loop issue fixed by one of the patches submitted
> for 4.20-rc2:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?h=3Dv4.20-rc2&id=3D11023d3f5fdf89bba5e1142127701ca6e6014587
>=20
> The branch you used for testing doesn't have that fix?

Yep, I tried v4.20-rc1 tag, which hits tons of such warning even without
my patchset.

So it shouldn't be my patches causing the problem.

Thanks,
Qu

>=20
>>
>=20
>=20


--K7WhSvvDikxr0KWfZ4rBDDHJOonGaC3BH--

--nNDXGDTm5laV63I0ywIHfKg9loGExzFUs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvrZMkACgkQwj2R86El
/qgszAf+NX1p3/WPHt9mmkiuKV7iv+u4YmOlGty8EomEyXd/WGtPLJkdWjYXvINA
tp/ocEA6IXx1GA+DGEPB+EWK7Cs/0iLe5W34qEilLRHs7NVlwCwayBU6wV3ld/T6
55xXstS923X5U/1HJvvrzL4eBmMpPrPp3WIICUWQcg2e7gxwcT0h7s6bguQY7CXy
ucRi1xv7TnfTUCXrMpBG3vOgwUWmJoxPxIIvSUcR2aQ9nNx9EyIYB6eUvOyS9IWm
7PVQ+zGpzIFu46fgbKLpktuTVrMvQsjAzlfM44Kj8MkuikLtym/3j4yeV/GM1TCV
APtXxsEaX3eyd9CezrOyeWQOmrOJXg==
=yISM
-----END PGP SIGNATURE-----

--nNDXGDTm5laV63I0ywIHfKg9loGExzFUs--
