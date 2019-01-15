Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660B4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3406920651
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfAOMWs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:22:48 -0500
Received: from mout.gmx.net ([212.227.15.19]:37419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbfAOMWr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:22:47 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LnxxQ-1hBpjW31dw-00g1eF; Tue, 15
 Jan 2019 13:22:43 +0100
Subject: Re: BTRFS critical corrupt leaf bad key order
To:     dsterba@suse.cz, Leonard Lausen <leonard@lausen.nl>,
        linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
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
Message-ID: <338c02b6-4cbd-87fb-88ea-8165b41b9208@gmx.com>
Date:   Tue, 15 Jan 2019 20:22:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115120359.GG2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MX1L5Ibc0urLQFFOENpSl8lqsk20xvkgv"
X-Provags-ID: V03:K1:GDbAt+to0S+5ZOXoqvnJoXQ+BcnHcPRhoeSw85eoY2hZqJ94MFq
 gVyHJd/gePSee/uZwb3Bx/CdOc+pHkLX9QkGKz9l3qL4CAKaDz7uIkwq37yGRq9vLDi9IQz
 Sj+Q3FG0qrch7Npybj7tJpfih80jPXieH5eUlOvRIGOfhIdzLa5zE1eHZAeSTEGCrNlyHBA
 lXfjfNjVB2uTYFf9HdXkg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:E18tjcDQBTs=:C12IQdql+CAh6DdKbLrow7
 0haSp3UnVxB+MZ/hH5Mkn8G5u4burh0CFwIGosaKgjvfjw5irkL3+GwC3go70vRunNhBeaiid
 kG+UuQelEMqg1ysBTNG3fmlFf2TUtYpzkR6Awa8Eu/nj5u6mdwhLwPKMuvgr5/TE3Yyd+/jPo
 JsP7yzhPwUUMkIhXeMgTHFwCN+1RzAlQ6DS3wWwNnJjsqk9pqFlNr6bZCa8b2nwRPvAz0s8nT
 ae95sZNHipGb4wqLOvfAHmMiyLPhjfnYub0mxp09okF2sHuCx/bLsxWdThqO257ZPbjypB1dL
 Op0MDrJy1dwEdF7DqYMDQhvIv86OUf63oAZvuE888JbouIlDPOzvij36mbWRJlwUUCfiUdTDf
 pClR2wHBX4GTxGPqhQnZNbv9hg8xHmIezKr9BNQMKiPzk2zUyKZerVpVTtr8kXc00ixQgbieT
 1ed3X/uWS2vrJLUsdiPgTVUdzCAouEDhQTIpRGOXUM/sWwFegEBOjDetVK0HGp9Csi6uSkkwa
 +gzJiB5A2L1mNEosPZBE3wc3uC4AEaEKWQrRqsDutFCaNnjQWC+LamRfj292+RyRGyJwFZiXs
 G7LZ6Kq5jfZPS2dvpikg6PMpamL1WZyubWmYWUUzP8lXd6/R5xgrZ0n3HadIV8gNJ9nEIEEQZ
 5F7giXwTlYtr1Ols423zmxyhsvSVRb7eXINX3QQktmoR+Sglyf+kbMpQyYhggMfpI3Sfok8WK
 zpySqTVxEz2RnY66ln3DSB7qzE7JEv0Ivebp9fwASkOR08a1c87otbB8Ztl5LzweLRe5+zcY1
 oY3fTagUxeqWbd0SfL+hnCQscSFjqHGj+/qdreFmTitYISDgVROmtIFh0wzv2bsPQs+0MUIxD
 mXi9DRtzEp29u6e1/xIKWnt4LvXVdSwXJNY1x8q0nRRX9ZsCiPOf5LPvRUiIcY
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MX1L5Ibc0urLQFFOENpSl8lqsk20xvkgv
Content-Type: multipart/mixed; boundary="y3I1LFpiFcCm5RzTWzoiaz7b4v2uuZ85r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Leonard Lausen <leonard@lausen.nl>,
 linux-btrfs@vger.kernel.org
Message-ID: <338c02b6-4cbd-87fb-88ea-8165b41b9208@gmx.com>
Subject: Re: BTRFS critical corrupt leaf bad key order
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
 <20190115120359.GG2900@twin.jikos.cz>
In-Reply-To: <20190115120359.GG2900@twin.jikos.cz>

--y3I1LFpiFcCm5RzTWzoiaz7b4v2uuZ85r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/15 =E4=B8=8B=E5=8D=888:03, David Sterba wrote:
> On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
>> Super nice move, it shows the corruption and the cause.
>>
>> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33=

>> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 4=
2
>> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33=

>=20
> The key order is the most frequent and also very reliable report of the=

> memory bitlips. I think we should add an unconditional check before a
> leaf or node is written so we catch such errors before the bad data hit=

> the disk.

I'm super happy for that.
Although I need to do some extra check before just removing that #ifdef
#endif pair.

>=20
> This seems to happen way too often,

Right, but I don't know if it's some bad kernel driver poking the
memory, or really just some hardware memory flip.
(Especially when it comes to ultrabook like the reporter is using,
soldered memory will really be a pain in ass)

> I believe the check overhead would
> be acceptable and at least give early warning.

The problem is, current check_leaf_relaxed() call is too frequently.
It's not at leaf write time, but every time btrfs_mark_buffer_dirty().

It may cause some performance regression.

I need to look into a better location for such check.

Thanks,
Qu


--y3I1LFpiFcCm5RzTWzoiaz7b4v2uuZ85r--

--MX1L5Ibc0urLQFFOENpSl8lqsk20xvkgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw90IwACgkQwj2R86El
/qhYlQgAp9KNcltP7LS9p6DjM33NDFRYP6sEmUk2id8heRaLIjPyXJG7Df/HVacm
cwo+07Fv3a9Er5uWsDjehxwMjRw982qHEGWo4OoUcB00BCC+uyLbj5crwXLIpLv+
K+q77JV0ceh48pSEIhWmrtvoFaYHSwv3dc/NKucKe7y4ze9oSU6/LvPVg1ZO8h+j
q20DW8ZUeM45x+5nLKEqFf/L/M03MlgpEAqSecQFLQp7riQl+q6JxhAQxFFkDvhO
dwNSyKpo7T+Swj6EaoLRLir2nvu5KibaWoeO1D07fMYZzTqWp/N4yKBavZF87oRh
RAPdB7g+sWSA6pn4bWmwVrUn7J48Yw==
=VO4Z
-----END PGP SIGNATURE-----

--MX1L5Ibc0urLQFFOENpSl8lqsk20xvkgv--
