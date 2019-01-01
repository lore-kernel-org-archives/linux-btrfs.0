Return-Path: <SRS0=BfcD=PJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFDCC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 00:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2672070C
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 00:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbfAAAMg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Dec 2018 19:12:36 -0500
Received: from mout.gmx.net ([212.227.17.22]:34101 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727405AbfAAAMf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Dec 2018 19:12:35 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIdYi-1gbvny09zU-002EBl; Tue, 01
 Jan 2019 01:12:15 +0100
Subject: Re: Scrub aborts due to corrupt leaf
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
 <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
 <CAJCQCtSbLkpYnwEO05D5R2oXVznJ3KwBxjyfBDnM4PaGwSXUhg@mail.gmail.com>
 <3f3020c0-2643-074d-b88d-02123ece911c@nuclearwinter.com>
 <CAJCQCtTc49Qe3_zN7OVF7TQbONhdsh4-383=ttu_0i-5OOig7g@mail.gmail.com>
 <CAJCQCtQ68Oz=biJ=Z5fZJiqB0QzAR6mK_1eRvuqYXZjecL3bxw@mail.gmail.com>
 <b8b50f6e-60ed-6988-0556-50c94c077099@nuclearwinter.com>
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
Message-ID: <9dbfde05-4b20-4681-9286-3db0e8cf4f56@gmx.com>
Date:   Tue, 1 Jan 2019 08:12:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <b8b50f6e-60ed-6988-0556-50c94c077099@nuclearwinter.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a5s9cnSNQ0vBjXvYE4uiq7gdnJj0xngFr"
X-Provags-ID: V03:K1:qllVFaGrzE25GyT5VznJEOu0JAsAITX6shEOoX36srcotTuY94w
 6bVab7Dd4jViGhRGPAiMX7RHQVIm5/Nlma3CGRPqPj7jXQ3AkxBTbgiVYD5ZSEqJls9J8/J
 ss3ffI15j+5qPb4wizetlCq/bZy1aQJMt+M3CxFNlzpRn3nAkcp9vK8t6RxQZ3U4q0jGeMG
 +PWE+LSTAMmRknn5bXaqA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:H+RkCh7Ri68=:CDSVnv/QVEvsNGeY8EvSUp
 wWP3X8V2696qwCon4yU0YO0KyBxjNtma/FjQMuFmHCJco+soitYx8562HFF6x69TkTJDhUiM5
 OM1HJMD5IPnOnYye+n8sFQPy5QsrFTYIc+txRko/p7rfIZ5gzBZWG7Ill9r1jAhEol1nXWUeV
 fHTicHKLHlgvGeG7BD5EUFHLSvNM3hSnpo21XRyU5MvNlWH9Q4Iz5E0+t5qBXQLhEv+fLpPzB
 +F7HjZ1CWnwbT9GnQGCgHv2t9mDnxQEI8uguY4CeRNoNgFFqB4pwXvOVLnMteRcThxQwLsi/n
 a57qZBbeWK4oAwRwoY44fzGlHxt+kKs6o1EaZl/U8PmXv7CsgZvizR9AJDMNpaS6HXb8U1xdM
 z0dO8zGnK/49Ng65KGjiHWbYxjcJZl/z4FYOgnuoNaRl1SD5kFipydtKZx+S/aY0Jo0JKtyNh
 DqvG8Pm0ycrRHtdtEswsGYHBueUhR8MCT1F7cj77bfb540eVeYW2Ic5hmoJ8W63qAy9HmkYYw
 Rn+Mzm1XPKiI64lgsKlm9qRVnf7GtzvCVwz+RtJH9Jy/IXe3w9ZnvL4uPfT4eTkpQUk7kKNvo
 sAGKC2uURurxCxaVo+eBf7C586JdkcxMdd7i6cHA+2WeBIkKRnTMGJ9SOTjv9WGc9I7BNZVcS
 bFsqEKcLGGAdqjYAUZe2/G6XxrW3er4cAE+jZ3qxbpod2bfvHtFTg2rUsE9/DtziA6neY0Ptz
 I1a/CRr4rtKEKA1cvR6m4g5z4yjCfurR/iNcXgBGSZPN5a5eQRE4eRKopz+SpzZNTOWwb+tDi
 DkD3kup3eEG8/x/3nRsEwVTzOq1xD/mLYElAp/N3GXDhvkRDEHlCrgD2noL9nt9fLlF8o4YxR
 8Z3DGm3k7S7pocUp57NN2+JZvamkAGKiYeunbLjTH7COHpX/+Q2vU3tPkDEF1m
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a5s9cnSNQ0vBjXvYE4uiq7gdnJj0xngFr
Content-Type: multipart/mixed; boundary="qoYn8pNlOFML80YqxDgLETclGGvgHxg1s";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Larkin Lowrey <llowrey@nuclearwinter.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <9dbfde05-4b20-4681-9286-3db0e8cf4f56@gmx.com>
Subject: Re: Scrub aborts due to corrupt leaf
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
 <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
 <CAJCQCtSbLkpYnwEO05D5R2oXVznJ3KwBxjyfBDnM4PaGwSXUhg@mail.gmail.com>
 <3f3020c0-2643-074d-b88d-02123ece911c@nuclearwinter.com>
 <CAJCQCtTc49Qe3_zN7OVF7TQbONhdsh4-383=ttu_0i-5OOig7g@mail.gmail.com>
 <CAJCQCtQ68Oz=biJ=Z5fZJiqB0QzAR6mK_1eRvuqYXZjecL3bxw@mail.gmail.com>
 <b8b50f6e-60ed-6988-0556-50c94c077099@nuclearwinter.com>
In-Reply-To: <b8b50f6e-60ed-6988-0556-50c94c077099@nuclearwinter.com>

--qoYn8pNlOFML80YqxDgLETclGGvgHxg1s
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/31 =E4=B8=8B=E5=8D=8811:52, Larkin Lowrey wrote:
> On 10/11/2018 12:15 AM, Chris Murphy wrote:
>> Is this a 68T file system? Seems excessive.
>> Haha, by excessive I mean nuking such a big fs just for being unable
>> to remove the space tree. I'm quite sure the devs would like to get
>> that crashing bug fixed, anyway.
>=20
> A second FS just started failing. I never had this much trouble with
> space cache v1.
>=20
> This host had a DIMM failure a couple of weeks ago which caused the
> system to halt due to uncorrectable ECC error(s).

That looks like a pretty possible cause for the corruption.

Like strange items in your extent tree of your other fs, if your memory
is unreliable, all your fs is possible corrupted.

And for the victim of memory corruption, the hotter tree block the
easier to be a victim.

For both case, the corruption happens at extent tree, which matches the
symptom.

Please do a btrfs check on all your filesystems.

Thanks,
Qu

> That was the only
> recent unsafe shutdown. Other than that, things have been running
> normally until today when the FS went read-only during backups. As with=

> the other host, I tried to clear the space-cache (v2) before doing a
> 'check --repair' but got this:
>=20
> [root@fubar ~]# btrfs check --clear-space-cache=3Dv2 /dev/Cached/Nearli=
ne
> Opening filesystem to check...
> Checking filesystem on /dev/Cached/Nearline
> UUID: 68d31d5f-97a2-4a73-a398-c7c13ff439a5
> Clear free space cache v2
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF8=
4
> bad tree block 271262429573120, bytenr mismatch, want=3D271262429573120=
,
> have=3D17478763091281320157
> extent-tree.c:2703: alloc_reserved_tree_block: BUG_ON `ret` triggered,
> value -17
> btrfs(+0x1ff96)[0x55eae7dc5f96]
> btrfs(+0x2109f)[0x55eae7dc709f]
> btrfs(+0x2115e)[0x55eae7dc715e]
> btrfs(+0x22054)[0x55eae7dc8054]
> btrfs(+0x22c57)[0x55eae7dc8c57]
> btrfs(btrfs_alloc_free_block+0xc2)[0x55eae7dcca72]
> btrfs(__btrfs_cow_block+0x18a)[0x55eae7dbc05a]
> btrfs(btrfs_cow_block+0x104)[0x55eae7dbc874]
> btrfs(btrfs_search_slot+0x35f)[0x55eae7dbf6cf]
> btrfs(btrfs_clear_free_space_tree+0x104)[0x55eae7de8b54]
> btrfs(cmd_check+0xb11)[0x55eae7e0ce31]
> btrfs(main+0x88)[0x55eae7dbaaa8]
> /lib64/libc.so.6(__libc_start_main+0xf3)[0x7fead8094413]
> btrfs(_start+0x2e)[0x55eae7dbabbe]
> Aborted (core dumped)
>=20
> # btrfs fi show /public/nearline/
> Label: none=C2=A0 uuid: 68d31d5f-97a2-4a73-a398-c7c13ff439a5
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Total devices 1 FS bytes use=
d 61.09TiB
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 1 si=
ze 65.25TiB used 61.45TiB path
> /dev/mapper/Cached-Nearline
>=20
> # btrfs fi df /public/nearline/
> Data, single: total=3D61.39TiB, used=3D61.03TiB
> System, single: total=3D32.00MiB, used=3D6.59MiB
> Metadata, single: total=3D67.00GiB, used=3D65.85GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D4.02MiB
>=20
> # btrfs fi usage /public/nearline/
> Overall:
> =C2=A0=C2=A0=C2=A0 Device size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 65.25TiB
> =C2=A0=C2=A0=C2=A0 Device allocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 61.45TiB
> =C2=A0=C2=A0=C2=A0 Device unallocated:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3.79TiB
> =C2=A0=C2=A0=C2=A0 Device missing:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00B
> =C2=A0=C2=A0=C2=A0 Used:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 61.09TiB
> =C2=A0=C2=A0=C2=A0 Free (estimated):=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4.15TiB=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 (min: 4.15TiB)
> =C2=A0=C2=A0=C2=A0 Data ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1.00
> =C2=A0=C2=A0=C2=A0 Metadata ratio:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.0=
0
> =C2=A0=C2=A0=C2=A0 Global reserve:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 512.00MiB=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 (used: 4.02MiB)
>=20
> Data,single: Size:61.39TiB, Used:61.03TiB
> =C2=A0=C2=A0 /dev/mapper/Cached-Nearline=C2=A0=C2=A0=C2=A0 61.39TiB
>=20
> Metadata,single: Size:67.00GiB, Used:65.85GiB
> =C2=A0=C2=A0 /dev/mapper/Cached-Nearline=C2=A0=C2=A0=C2=A0 67.00GiB
>=20
> System,single: Size:32.00MiB, Used:6.59MiB
> =C2=A0=C2=A0 /dev/mapper/Cached-Nearline=C2=A0=C2=A0=C2=A0 32.00MiB
>=20
> Unallocated:
> =C2=A0=C2=A0 /dev/mapper/Cached-Nearline=C2=A0=C2=A0=C2=A0=C2=A0 3.79Ti=
B
>=20
> 4.19.10-300.fc29.x86_64
> btrfs-progs v4.17.1
>=20
> I haven't nuked the other FS yet so I now have two that are either in
> the same or at least very similar states.
>=20
> What additional information can I provide?
>=20
> --Larkin


--qoYn8pNlOFML80YqxDgLETclGGvgHxg1s--

--a5s9cnSNQ0vBjXvYE4uiq7gdnJj0xngFr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwqsFYACgkQwj2R86El
/qhb2gf7BhglBH0JyE0w1h3IN0g5fMZLkaLHKIbOfuxmcDtzsJ2Pwo0lMGdOT7cQ
VjvfABnR2qng6xwJz2iPO43QdGkNvXelKunOFE7b6LnoXKGempIBZAjRrviLAeN7
BEW0+giliwJlt4tr7IHNGei+649wpLE1s/txzsbmFw5dNmAx1OOXbxtdtdB+yKY/
hlxrJUBOvxgVp+fRO2O//9aRoj3VWe05OmY8pIrXgjobAA8o1sEXZMZXBv0U52hF
C1y97nwpUR/Uh8gy91LxF9tBKfRo78RbhA6zsQt5daeH5Q0a2kGHhVHfJIJ2b5nd
99agY6GpAzbYJFkIMGPx9ynAu6KSgw==
=xtkF
-----END PGP SIGNATURE-----

--a5s9cnSNQ0vBjXvYE4uiq7gdnJj0xngFr--
