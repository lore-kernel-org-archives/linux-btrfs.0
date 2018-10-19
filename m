Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8476AECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3885720644
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3885720644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbeJSVJ0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 17:09:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:57225 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727336AbeJSVJZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 17:09:25 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSY2q-1g5kgw0Bwi-00RXNd; Fri, 19
 Oct 2018 15:03:15 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSY2q-1g5kgw0Bwi-00RXNd; Fri, 19
 Oct 2018 15:03:15 +0200
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com> <20181018162059.GJ29418@twin.jikos.cz>
 <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
 <20181019091516.GB16290@twin.jikos.cz>
 <63697e20-9c39-da22-437d-b43612f25d3c@suse.de>
 <20181019100419.GC16290@twin.jikos.cz>
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
Message-ID: <5684c607-0b73-3fa7-0e8e-003fbecf2cf8@gmx.com>
Date:   Fri, 19 Oct 2018 21:03:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181019100419.GC16290@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="twHviTAXYf0XmNWnteCQ4Cr63AaDtjwsS"
X-Provags-ID: V03:K1:XG9jq0XqoItN0NurbCZb1yl+6sBRN+RTey1cRBDz9mX5yXK1Txp
 ziYc2RBJQyr1KLgnNfpgq6gGNuBD7craEIuti+nTcWorzJOxuEhLUrx1MpfsBHl0RHCFJNr
 3lQGooJZSWwvgvfC5Xmu9FXPizeJ8flrGjFiAlSb3fuElX6y9FMfISuGbZJZO/DKN5toVym
 8sc2caDQHbUCcQlo8t7Wg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:3BvXLec9BRI=:g0hFh4st+uiOA/noeczRNa
 AmIXwprIUPNdGYCsFyYbhRh8Vu8Yu+GNfAZlaM2gyEAVvmuscvIGMG9KQnXJQdKD3lYhA2y2b
 RBSmLSmya+JpuVt/UTDHAqZTLEIsQPL8G6bp2tB6PbFuloTKDlTBACBTZ34R6jUv0YUZmwEc8
 79MHcsBjMc36Rk/OWipCWzmCRo29lEku9fa3+MV6fCfJ63q/2FhZ1yzK7GSj2FV7eZO0CCPiv
 fM+rXQ4Hjatt+tmT078t9+EciQQugh2TBN+tyOF5A0SGT5VLTyi/zvL0YAREmyqLUhmgZHXaV
 uMxFvjPEdIn+Jw4qq5iYMSWhCdCpDIaGLNk3+Z5qTq36cqkll/F7q/uJ1EJllNpO0XCECbVe0
 Fan/GivbTdYqZr1MIr9WDuwufecIMOgOqVzqn4CjVJ1kA1h/LhtXQKzdxZYFSTVu6K636Spln
 L5xtaZb8xtBE9zfhaqmZsKVXNnpdZEswaijSks6giwNtKD7JWeEXYoRQz+fmgwlj7KqxKNLKn
 xGmU98kGwuwoSuv4xu2f7tKO+8GKt7WOyg6Na+xoFGaN96i5ToInbo/8ErmCa7i3vTOsYzchs
 SA9iuCIs2WcOiCFtGgwwdQkYsHf5chfNM25Vm9PxlfYsVgs7bcimIxo2ThdQwbf47SCLRQCCm
 txCbVIhaJ31JMRXI+arbcXSqNdiIbiSIMfXw/WjbZpZ73BaAhSGZKGEOIwIQz2Mm6nfdroxBM
 tZeWHTl9SCXW+7AKNudIlqJGI9ohql/qpUdiNGE8nVEGzIYE+iwGer9mUPmatkBYNLgwe6ubg
 gGEJeXjppZIUqV6+u/b3T7NJD9ZyQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--twHviTAXYf0XmNWnteCQ4Cr63AaDtjwsS
Content-Type: multipart/mixed; boundary="qFcCxkVKPPLZnwBmXxxip0ujsaPZ8Elrp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <5684c607-0b73-3fa7-0e8e-003fbecf2cf8@gmx.com>
Subject: Re: [PATCH 4/6] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
References: <20181018111729.11128-1-wqu@suse.com>
 <20181018111729.11128-5-wqu@suse.com> <20181018162059.GJ29418@twin.jikos.cz>
 <dfa39127-3cdc-b98d-b0a0-eed82ba984a5@gmx.com>
 <20181019091516.GB16290@twin.jikos.cz>
 <63697e20-9c39-da22-437d-b43612f25d3c@suse.de>
 <20181019100419.GC16290@twin.jikos.cz>
In-Reply-To: <20181019100419.GC16290@twin.jikos.cz>

--qFcCxkVKPPLZnwBmXxxip0ujsaPZ8Elrp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/19 =E4=B8=8B=E5=8D=886:04, David Sterba wrote:
> On Fri, Oct 19, 2018 at 05:46:28PM +0800, Qu Wenruo wrote:
>> Did you mean some like this is possible?
>>
>> rbtree_postorder_for_each_entry_safe() {
>> 	kfree(entry);
>> }
>>
>> If so, I still don't really believe it's OK.
>>
>> For the following tree:
>>                           4
>>                        /     \
>>                       2       6
>>                     /  \     / \
>>                    1    3   5   7
>>
>> If current entry is 2, next is 3.
>> And 2 get freed.
>> Then we go 3, to reach next we need to go back to access 2, which is
>> already freed, we will trigger use-after-free.
>>
>> So the only correct way to free the whole rbtree is still that tried a=
nd
>> true while(rb_first()) loop.
>>
>> Or did I miss something?
>=20
> It's postorder traversal so the node is ready for processing after all
> it's children are processed. In the above example, it will result in th=
e
> followin sequence: 1 3 2 5 7 6 4 .

Oh, I totally misunderstand the word post-order.

Post-order is LRN, so upper nodes are always accessed last, then kfree()
inside post-order is completely OK.

Thanks,
Qu

>=20
> The iterator is safe in the sense that there's enough information saved=

> before going to the node so it's not needed to be accessed later, eg.
> after it's freed.
>=20
> prelim_release uses the same postorder/kfree pattern.
>=20


--qFcCxkVKPPLZnwBmXxxip0ujsaPZ8Elrp--

--twHviTAXYf0XmNWnteCQ4Cr63AaDtjwsS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvJ1gwACgkQwj2R86El
/qjA7Qf9Eq7kCL2VqsLRShTz5BMnG4qUf8YhjgfwsNAs8rbDumDz9FQQODrSM6jR
+c3RPSCKyFcYqLyivc0sfSEkCKKhBPB5z/VMBoCjfb/WolJwNjFc2d+zU93TXCZX
JRLSCfnidttlDqIJAc6+iEimtU+qKdIrclrCFKrD9mN1cHBwhkClvEnLQ0REcRXR
aEHbKYLTJMn3SJSRLmeRgnih0BXrWDmeso8YqcXtrtho9IhMOqy/+tYYf4tHrcWE
D5Njg05tD7Amu7ToIfi9JI100bGiSLI4UthfRCmqzFidatBJC2k7T3gPOgTSnZGi
NeP8uQGzPaM8eGhbs+YSwvbmmRrlZw==
=BO4W
-----END PGP SIGNATURE-----

--twHviTAXYf0XmNWnteCQ4Cr63AaDtjwsS--
