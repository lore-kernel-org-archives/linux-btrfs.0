Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACF7C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A3F20828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="UwEjz6xQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbfCYXCf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:02:35 -0400
Received: from mout.gmx.net ([212.227.17.22]:48607 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727578AbfCYXCf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 19:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553554946;
        bh=kkd59QIUWUCX9pLtOQQaE+olWzTDw8SYGVoLsX1kthg=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=UwEjz6xQ+lyX/Xto93ceVT4FEfTpDFf/9u6FcglDVnHAnt8byOiUSu6i6Ne8gVipO
         rEkSXEejAtN6ugEXdFnAPE5fE35F1jEOQtXLjZ6Xr9BjFKSYdaR0+HOfk/DawegXUA
         tacBXNkUSbAIJxO2NT5KucQEyxh22yRMf2+9zsR0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MVvDo-1hSIQr1kBU-00X1xx; Tue, 26
 Mar 2019 00:02:26 +0100
Subject: Re: [PATCh v2 1/9] btrfs: Move btrfs_check_chunk_valid() to
 tree-check.[ch] and export it
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-2-wqu@suse.com> <20190325170630.GO10640@twin.jikos.cz>
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
Message-ID: <7f08dfa3-2b60-9213-9409-83db61c969b8@gmx.com>
Date:   Tue, 26 Mar 2019 07:02:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190325170630.GO10640@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7ERMfkmzJsiaY4Hyj3gavRERvsGurFu3i"
X-Provags-ID: V03:K1:hwneCmc56djcBz1Vu/B3I1wIKiSxUhCwq4lMuj9N5o0eK2H9HoV
 b6LMKi/dbyDDwJBqEWj5z6TuzJ7GzVgki7IC8fJ1KkjvBKhB1FXsItQAixZiT0/FCxLpAoI
 HHk1r7M1cOmAjfB30MJkir8YadEcTmd73RLjkF+NI/9MfMBiF2Wuug2SYgoAxAew+mhJ0n9
 d0A7oqaX1//XPFKnyncTg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eXL9ouUglIA=:ZWWiAXiPPJTN46p43+oYpx
 L3c+cuNXnlq6RUPr7NzsyqRbIgitLLL3MWSlYGelwIUlKDns9Be61FfbP42gVvNKibtRhUB7T
 PIQD7Mh5kTdOWsAJk8IDQZnYmYsRLQQ9fjrdaxWOyQLeEnowFqHXTAnjqyRDHV1wQP3MxANQl
 VtpcSlfE31i/H8eDhFShU4SlGoe/e02/6twpmxEANwLhUyObz6yIjNKKSZh4qSjyMcHXWgPVE
 432VxlKgkOvuc2tXxH/7rQajIS1NA8Gr9+LECowWNEnSJfuOo/CEIf1oTfuYf41ItO99rZGKf
 rmW3hWgos66bQn9f80pU+oJ95+KH13hszR+LfNJRe4YzOLL1GB5a8SXnIMQD6LP6C/Z7uRGsa
 7AfZDzDa2xTsctS3Etnc3wKjSJt+9dEpBUTarz9bMpVvnCgfMEldeQv48xZ5OnRGb3uFR9OMJ
 Qj82HZT28ZPco9tpfr7buvhw7heG96KCmz38W5P9hw7FG4D2MBK5iVmShSjRIrOanSTXB/SpQ
 lNEaEJcu6NYAlgiKG0fkuTnbdG/s85VOygGMN/7uW+Gt5YrslJwXvBNdz44xd4MUrFg+bO0CZ
 RW0MOwHyKAPLdzUlFyyetl65EuM0DGPR6Uk0lHSZFBI/UFELZjTyM166UCIs97vp4GL8z+yp/
 bQd7lJKGvcvs5FONv0d9PoNXCiAYLbERF4gb/Wnq+bfqoyLKKtsVEo96qCRUqY0hHIOd00vMq
 kN+Q9PQ/Li0KM+S46XZlszbi8CyGf5N1oDx+7CslAvtO/5sjPQU8BzXtUgFumnb9oDdoVtfmP
 WVf3McMlRc/Npa23+i38VEegrQ8beZ2FqTrsGlKeU7EFdOfcij3W7JsHLEol9e5X2wvPaLu7Q
 oubtCmZ13DAegvnjAEXfyVUZGfm9htWIlInUA5+U4nvLaN2pEi5yCkp9JyRUMB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7ERMfkmzJsiaY4Hyj3gavRERvsGurFu3i
Content-Type: multipart/mixed; boundary="GBS6fssdIbmZUUCbE6NmgE5S4njheDeWh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7f08dfa3-2b60-9213-9409-83db61c969b8@gmx.com>
Subject: Re: [PATCh v2 1/9] btrfs: Move btrfs_check_chunk_valid() to
 tree-check.[ch] and export it
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-2-wqu@suse.com> <20190325170630.GO10640@twin.jikos.cz>
In-Reply-To: <20190325170630.GO10640@twin.jikos.cz>

--GBS6fssdIbmZUUCbE6NmgE5S4njheDeWh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/26 =E4=B8=8A=E5=8D=881:06, David Sterba wrote:
> On Wed, Mar 20, 2019 at 02:37:09PM +0800, Qu Wenruo wrote:
>> By function, chunk item verification is more suitable to be done insid=
e
>> tree-checker.
>>
>> So move btrfs_check_chunk_valid() to tree-checker.c and export it.
>>
>> And since it's now moved to tree-checker, also add a better comment fo=
r
>> what this function is doing.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/tree-checker.c | 99 ++++++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/tree-checker.h |  3 ++
>>  fs/btrfs/volumes.c      | 94 +-------------------------------------
>>  3 files changed, 103 insertions(+), 93 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index b8cdaf472031..4e44323ae758 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -448,6 +448,105 @@ static int check_block_group_item(struct btrfs_f=
s_info *fs_info,
>>  	return 0;
>>  }
>> =20
>> +/*
>> + * The common chunk check which could also work on super block sys ch=
unk array.
>> + *
>> + * Return -EUCLEAN if anything is corrupted.
>=20
> Well, that's still confusing if you say EUCLEAN in the commend and use
> EIO in the code.
>=20
Oh, that EIO to EUCLEAN change is in later patch (3/9).

Do I need to resend the patchset?

Thanks,
Qu


--GBS6fssdIbmZUUCbE6NmgE5S4njheDeWh--

--7ERMfkmzJsiaY4Hyj3gavRERvsGurFu3i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyZXfwACgkQwj2R86El
/qhgKQf9G0rj7rRhvfbjGqbq3JWn17vjUnnvrzb2OSUHEcQTxxo4jfCPdqnQmCQe
avUPJuIG4ipxCxn0/77o5pwz8b92b/34pJQdqi6ZvBkThZSKlHrbbRaA9gaH75Em
lzfEWVP848HVQ/gDST62E23RQKW7GmuVrBn2CgKt4dyC89eR6BziSqJc7ebZw9ix
AW2LdYFVJRR9Y+98Mp+b//FAeBazBRtr7lCqbBWTiqIzuudzC+vZ/39yPSThJE+6
A4caj/ZGuxtwZ98qFh6UQwvBSHvwR6/f3cuQD9/Wpkc0NCX0pd8hZHacPF8/KP6l
y58nLOuWhn5hipsufZs811MamenJHA==
=qJIs
-----END PGP SIGNATURE-----

--7ERMfkmzJsiaY4Hyj3gavRERvsGurFu3i--
