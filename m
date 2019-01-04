Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29855C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 01:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A702184B
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 01:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfADBca (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 20:32:30 -0500
Received: from mout.gmx.net ([212.227.17.21]:47165 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727743AbfADBca (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 20:32:30 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LaXmV-1h1sm63HId-00mIG2; Fri, 04
 Jan 2019 02:32:26 +0100
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
To:     Chris Murphy <lists@colorremedies.com>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
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
Message-ID: <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
Date:   Fri, 4 Jan 2019 09:32:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="igqFILyNJeq1vnIhlMVJNwvPEkyOD0Pd0"
X-Provags-ID: V03:K1:sOZqgW8NmcTtsHXKic+OSDtAflI16kn2Scs9d91u8nA2KaONqqY
 PHyTJUr+hA4OPe30XxvkgK79i6hgsuuoktI8pOPCk1SlU9oYd/20P06Lp3FAdQlu4An0krS
 eg8UnwoD5c6s784oFCvwULeOEJHRH2/pKZR8E2g4j2lNfpGdFrIJFAQQ3U4/EclBKCGr70M
 7v+2A5Dbd/6lQNAz8l6aA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:TkVLRdtI6pE=:OdTWaarzf047UVfUv+9pGZ
 J3sdLt2EC62wE3w2FQ33bW60+p5j5bExOlQVduvvrF0pKw+gSG3POXxtXpWObEAjpSGsiNDzU
 mZpWN9vToxxTHNlyNd4OAtlDO7Uznz17XwZ9xkKQc8zr74FvVYMuqAcywFxpwmDIRXjsgshqe
 UnUrUJFcHCzoC30pkSEXeEd044KQi1XnJ6dFW5oZPEk0HmmVqPRt7+wubAOYp3ghfhfz0qJb5
 3P5rRcYkji/Ny9cwjIcTa66TxEe4/CbvChBf+i/ccs15XZFdKsR1vP+5dKYH3gsvnmiy7JpxF
 pxeP3qbu09yyQy+28MC/N3aqHNOAcIdMo1zPPpyy4HvoQ2KM9zoKBqcnPIDM3tpvfcpVAxw+M
 BUUO26Wpq7IvngtzxrqPw3AsMpW0w3HicTmWrEITrdGaPM7nqJyUVKa28OlyYrVS1c/wCkBfg
 2f3amRn4dsAqxPiAgKrk/8abkzfL01d0lioDKuRfN0hhDZgA9VKa+xfOG+tHkdul9gd4Hr/UJ
 tHYfi+csccHJHEckrTuG8q+yUK4KZF7z1z9831IJnz4g5K07SFdIkh+R8F0A6wqIfqVXzm2eD
 dqqSSorRtpGF6ocQe4ulbjKsr2eKtCyFwe/d/gHJinO7fQvpzkOUR73qAbtKKBQlbIDfiNiW6
 yvncY8FXhjnDXAUQMp6AT9aIPI+7ZkNkMScXkICwnbBAoIZxuRW6KasIMAz2yWHVHy7LnICLq
 FVJjmu7JfoTBWXtHoulLBNOcjMUyXR+A6SF83m3r3jR9Xrsga8dJZmqZFjNcophKtMm+1zB+j
 oQzss7VE/4MQKC9NVY7d7l4sO1KcZhci5usIGzru4Zm+vL+hCY8FNOHqWhe3E1mYd09BllbZL
 VMJYVmKll3QLlssAX0uC6s0GdFdCsK4YuPDtlvJ+VXlgcp2FWAvtSWFeaGdl3U
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--igqFILyNJeq1vnIhlMVJNwvPEkyOD0Pd0
Content-Type: multipart/mixed; boundary="P5nJIYVxgNBw1BlqTuTclTAOa4FZMEeme";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
In-Reply-To: <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>

--P5nJIYVxgNBw1BlqTuTclTAOa4FZMEeme
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/4 =E4=B8=8A=E5=8D=889:15, Chris Murphy wrote:
> On Thu, Jan 3, 2019 at 3:13 PM Nazar Mokrynskyi <nazar@mokrynskyi.com> =
wrote:
>=20
>> root@ubuntu:~# btrfsck /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8b=
cdb350
>> warning, bad space info total_bytes 2155872256 used 2155876352
>> warning, bad space info total_bytes 3229614080 used 3229618176
>> warning, bad space info total_bytes 4303355904 used 4303360000
>> warning, bad space info total_bytes 5377097728 used 5377101824
>> warning, bad space info total_bytes 6450839552 used 6450843648
>> warning, bad space info total_bytes 7524581376 used 7524585472
>> warning, bad space info total_bytes 8598323200 used 8598327296
>> warning, bad space info total_bytes 9672065024 used 9672069120
>> warning, bad space info total_bytes 10745806848 used 10745810944
>> warning, bad space info total_bytes 11819548672 used 11819552768
>> warning, bad space info total_bytes 12893290496 used 12893294592
>> warning, bad space info total_bytes 13967032320 used 13967036416
>> warning, bad space info total_bytes 15040774144 used 15040778240
>> warning, bad space info total_bytes 16114515968 used 16114520064
>> warning, bad space info total_bytes 17188257792 used 17188261888
>> warning, bad space info total_bytes 18261999616 used 18262003712
>> warning, bad space info total_bytes 19335741440 used 19335745536
>> warning, bad space info total_bytes 20409483264 used 20409487360
>> warning, bad space info total_bytes 21483225088 used 21483229184
>> warning, bad space info total_bytes 22556966912 used 22556971008
>> warning, bad space info total_bytes 23630708736 used 23630712832
>> warning, bad space info total_bytes 24704450560 used 24704454656
>> warning, bad space info total_bytes 25778192384 used 25778196480
>> warning, bad space info total_bytes 26851934208 used 26851938304
>> warning, bad space info total_bytes 27925676032 used 27925680128
>> warning, bad space info total_bytes 28999417856 used 28999421952
>> warning, bad space info total_bytes 30073159680 used 30073163776
>> warning, bad space info total_bytes 31146901504 used 31146905600
>> warning, bad space info total_bytes 32220643328 used 32220647424

I'm not sure what this means.
I thought it's free space cache, but code doesn't prove that.


>> Checking filesystem on /dev/mapper/luks-739967f1-9770-470a-a031-8d8b8b=
cdb350
>> UUID: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
>> checking extents
>> extent item 3114475520 has multiple extent items
>> ref mismatch on [3114475520 4096] extent item 1, found 2
>> backref bytes do not match extent backref, bytenr=3D3114475520, ref by=
tes=3D4096, backref bytes=3D36864
>> backpointer mismatch on [3114475520 4096]

So only one corruption, the only good news.

Please provide the dump of the following command:

# btrfs ins dump-tree -t extent | grep 3114475520 -C 20

Feel free to hide any sensitive output, but for this command there
should be no sensitive info at all.

But from what the output, I'm wondering it's some kernel bug, maybe from
v4.14.

>> ERROR: errors found in extent allocation tree or chunk allocation
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 39409483813 bytes used, error(s) found
>> total csum bytes: 35990412
>> total tree bytes: 2395095040
>> total fs tree bytes: 2249408512
>> total extent tree bytes: 96534528
>> btree space waste bytes: 456622616
>> file data blocks allocated: 174319587328
>>  referenced 61677670400
>=20
> I haven't seen "bad space info" before and searching the list archive
> I only came up with one other report of it and no developer replied.
>=20
> What do you get with 'btrfs check --mode=3Dlowmem' ? This is a differen=
t
> implementation of check, and might reveal some additional information
> useful to developers. It is wickedly slow however.

Yes, --mode=3Dlowmem is also preferred.

>=20
>=20
>> If this seems anything important and you want me to run some commands =
to check what happened exactly, I can start VMs with this partition image=
 connected and do whatever is needed. I can't send image anywhere though,=
 since it contains sensitive information.
>=20
> If you use btrfs-image -ss option, there won't be any sensitive
> information included. Files are hashed. Some short name files or dirs
> can't be hashed (you'll see a warning) and those are replaced with
> random garbage instead. There is only metadata with the image, no user
> data.

Please don't advice -ss for btrfs-image. It's super slow and will easily
cause tons of noise when running btrfs check on it.

It's either btrfs-image, or nothing (manual btrfs ins dump-tree check).

Thanks,
Qu

>=20
>> P.S. I really wish BTRFS can stop accidentally corrupting itself one d=
ay.
>=20
> I have several Btrfs file systems that I use constantly, all but one
> is at least three years old. I've never experienced corruption on any
> of them. I did discover some isolated corruption of file data
> (systemd-journald and also a VM image) but those were bugs that got
> fixed, and also the file system metadata was fine.
>=20
> So I guess my bigger complaint with Btrfs isn't so much that
> corruption happens, but that it sometimes happens in a way we can't
> track down and know what to blame for the problem. Knowing what to
> blame is important for fixing bugs and also working around them in the
> meantime. So for sure it's frustrating, even if I haven't experienced
> it myself.
>=20
> As Btrfs file systems get bigger, the more we're running into the very
> scalability complaints that existed pre-Btrfs. The idea of Btrfs is
> that it should always be consistent, and not need offline repair.
> Doing an offline consistency check is just too expensive. Doing a
> check and repair that ends up making the situation worse, is really
> expensive. That's a bad user experience that reasonably turns into a
> lost user. And in order to fix bugs and make Btrfs better, we need
> more and good bug reports, not less.
>=20
> So... yeah. I'm not sure if there is more tracing or debugging
> information that's needed by default in Btrfs, so we can have a better
> chance of understanding these corruptions when they occur? Or what. We
> can't expect people to leave integrity checking always on, it's too
> expensive.
>=20
> --
> Chris Murphy
>=20


--P5nJIYVxgNBw1BlqTuTclTAOa4FZMEeme--

--igqFILyNJeq1vnIhlMVJNwvPEkyOD0Pd0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwut6YACgkQwj2R86El
/qhdjAf9G1KhUbIlKx5+NNHo5R0iNYNO9H2/m83bBDZh7P7eTozV666VqnWH88LF
DwSX/OrzsXpOs/xnj4SGmFhGoVhDnS029Ecs7XVLo6E77qKVTk4RgPOX7X9EHi/d
90cNn7CYbW/+DTPyrbZ+CDYVbrDVM0yo/BWyWszh53Ggl3K05gA8XzMQrt1XVyOg
HHPdIZwkJrRfimVLuCD94CtnYW1NeGNc0shS5pyrqi0nol3n2dTW6XhUZr01vEy5
tHIgOczbmmlmIN7fXaF1oJbDc45Wup1WiLcCwYXRWCmaGdLz4ZF6Kt6K805beoWF
YXlka3WLdRE2f/DkS3I4pRkkXcXh3g==
=9tVp
-----END PGP SIGNATURE-----

--igqFILyNJeq1vnIhlMVJNwvPEkyOD0Pd0--
