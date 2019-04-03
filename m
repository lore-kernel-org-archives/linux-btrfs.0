Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BC4C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ECED20830
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfDCOPk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:15:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:46900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbfDCOPk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:15:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5A8E4AFF6
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 14:15:38 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Make write time tree checker
 verify the content of leaves
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403141321.GN29086@twin.jikos.cz>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <6a5021cd-573c-8a8f-3867-964c51bd3823@suse.de>
Date:   Wed, 3 Apr 2019 22:15:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190403141321.GN29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AnTIpueNENYrLdrn7vdofvnJxWg00SHNb"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AnTIpueNENYrLdrn7vdofvnJxWg00SHNb
Content-Type: multipart/mixed; boundary="oyJFM1UeXzpMWVTqyA55MHLJqTKsmlOiC";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <6a5021cd-573c-8a8f-3867-964c51bd3823@suse.de>
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Make write time tree checker
 verify the content of leaves
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403141321.GN29086@twin.jikos.cz>
In-Reply-To: <20190403141321.GN29086@twin.jikos.cz>

--oyJFM1UeXzpMWVTqyA55MHLJqTKsmlOiC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/3 =E4=B8=8B=E5=8D=8810:13, David Sterba wrote:
> On Wed, Apr 03, 2019 at 07:59:18PM +0800, Qu Wenruo wrote:
>> Commit "btrfs: Do mandatory tree block check before submitting bio" is=

>> designed to check leaves contents, just as read time check.
>>
>> However due to the confusing parameter list, "false" is passed to wher=
e
>> it is supposed to be "true".
>=20
> And this seems to invalidate all testing since false->true will do
> additional expensive checks.

That's the case.

However with the next patch, btrfs_check_leaf_full() is less expensive.
Just 3~5 times expensive as csum_tree_block(), reduced from 20 times.

My full fstests run is coming to the end and so far no regression.

> I thought I'd fold the fix to the original
> patch but in this case it'd be the wrong thing to do due to the visible=

> effects of the change.

If that's the case, I'd add new Fixes: tag, but that can only happen
after write time patch get merged upstream.

Thanks,
Qu


--oyJFM1UeXzpMWVTqyA55MHLJqTKsmlOiC--

--AnTIpueNENYrLdrn7vdofvnJxWg00SHNb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlykv/8ACgkQwj2R86El
/qjdXQf9FG474/XTbmGG8Lh3MyLps8WpbyWt15CnlQxdjLLeWp7t3iabJkQlD7/3
OmXTf3Lw3h8NIG5qlLL9hcYN2O5+F9onUMu1FnF+z7RYpT7DW4rdOT1/xFeQazYW
nL0GsoDTeB41qBEAOG7XCbHd58jov9qgBuQh2OIJHRT5aOYNy9QXBga+jkDjw2O+
h+eOAGfGnvP71jLaAqOcdzzjZEtbZJYfeyx4oAouEZ05FlZD/XFUgiVKPssr2GdG
39cXnxkEGSUGKiW3GGuSKXELtqa5JK9gAnOxsNn7fLsE84sLnrI2wHo6O2tLpAlM
ajk0X44ODywB1hbYFgZz0ALHaQgf7g==
=kfe/
-----END PGP SIGNATURE-----

--AnTIpueNENYrLdrn7vdofvnJxWg00SHNb--
