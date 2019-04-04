Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14432C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9880206DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfDDGoQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:44:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:36150 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfDDGoQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:44:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 239DEACBA
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 06:44:14 +0000 (UTC)
Subject: Re: [PATCH v3 0/9] btrfs: Refactor delayed ref parameter list
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190211051653.3167-1-wqu@suse.com>
 <20190403162935.GS29086@twin.jikos.cz>
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
Message-ID: <a70f3ce4-b58b-ea06-3a3d-290926ebc9cd@suse.de>
Date:   Thu, 4 Apr 2019 14:44:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190403162935.GS29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5efBg2An3tSmFGHK26KFSLNLtuAva7LYM"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5efBg2An3tSmFGHK26KFSLNLtuAva7LYM
Content-Type: multipart/mixed; boundary="mQQnqoXs1XY7OeCV7N4Px7ta4LlviIdye";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a70f3ce4-b58b-ea06-3a3d-290926ebc9cd@suse.de>
Subject: Re: [PATCH v3 0/9] btrfs: Refactor delayed ref parameter list
References: <20190211051653.3167-1-wqu@suse.com>
 <20190403162935.GS29086@twin.jikos.cz>
In-Reply-To: <20190403162935.GS29086@twin.jikos.cz>

--mQQnqoXs1XY7OeCV7N4Px7ta4LlviIdye
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/4 =E4=B8=8A=E5=8D=8812:29, David Sterba wrote:
> On Mon, Feb 11, 2019 at 01:16:44PM +0800, Qu Wenruo wrote:
>> Qu Wenruo (9):
>>   btrfs: delayed-ref: Introduce better documented delayed ref structur=
es
>>   btrfs: extent-tree: Open-code process_func in __btrfs_mod_ref
>>   btrfs: delayed-ref: Use btrfs_ref to refactor
>>     btrfs_add_delayed_tree_ref()
>>   btrfs: delayed-ref: Use btrfs_ref to refactor
>>     btrfs_add_delayed_data_ref()
>>   btrfs: ref-verify: Use btrfs_ref to refactor btrfs_ref_tree_mod()
>>   btrfs: extent-tree: Use btrfs_ref to refactor add_pinned_bytes()
>>   btrfs: extent-tree: Use btrfs_ref to refactor btrfs_inc_extent_ref()=

>>   btrfs: extent-tree: Use btrfs_ref to refactor btrfs_free_extent()
>=20
> If you would like to get the above merged (ie. the parameter cleanup) t=
o
> 5.2, please refresh and resend on top of current misc-next. I tested
> this patchset back then and it did not pass fstests but I haven't
> investigated. As this patchset does only a transformation, I'm
> suspecting some typo so another look from you would be helpful. Thanks.=


I have rebased the patchset and re-test with full fstests run.

It passes with no new regression.

Although without the initial report, I'm not 100% sure what's causing
problem for your old test.

While the new patchset passes full fstests, I'm going to send out the
patch anyway, hoping the initial fail is from my previous inode mode
check bug.

Thanks,
Qu


--mQQnqoXs1XY7OeCV7N4Px7ta4LlviIdye--

--5efBg2An3tSmFGHK26KFSLNLtuAva7LYM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlylp7kACgkQwj2R86El
/qhIcQf5ASZAEGgiZ0xpTMex6TSfNZodq4WqsGLPgZpII/Zj8gwaZ+BAPGHf53lN
UDiWQdys3IMalQ0M9a3acBZMglpzpV1drjGfe9qsrO04k0bYOGB4xEVNsXxisANm
mnjWMjnGYQP+W6WuxnbyMCqjtI6+gHt88j+WVa/DZK9Cx2s2X3DUSiQUI2NRqliJ
9ESqp8JlSOWi9d1RslOIr5N+piTEcnY8FXa1Q4R34yGMnwyhsrpnnUqnq/FOyPDD
0YJpR3Cjw5/5TjaOJiufZ1LLp/Jnsra8i7+u5XaQon2m8IRmW16p50k6CMybdt/C
D8IIvN9wUx3WQkrmPdvY8EHhRlcDsg==
=T58A
-----END PGP SIGNATURE-----

--5efBg2An3tSmFGHK26KFSLNLtuAva7LYM--
