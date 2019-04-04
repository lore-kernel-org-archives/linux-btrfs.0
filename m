Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C01C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 01:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C7320820
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 01:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDDBMd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 21:12:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:36718 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726199AbfDDBMd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 21:12:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A9CBDAF51
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 01:12:31 +0000 (UTC)
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
Message-ID: <81c717e3-d75f-56cd-9224-8680e6428178@suse.de>
Date:   Thu, 4 Apr 2019 09:12:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190403162935.GS29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sdUElpGlLM1pyPyGtMDO6m3SC38dTHjdw"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sdUElpGlLM1pyPyGtMDO6m3SC38dTHjdw
Content-Type: multipart/mixed; boundary="ppaqk7TZFaCZawzdL8J01ChoRsREdCx3J";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <81c717e3-d75f-56cd-9224-8680e6428178@suse.de>
Subject: Re: [PATCH v3 0/9] btrfs: Refactor delayed ref parameter list
References: <20190211051653.3167-1-wqu@suse.com>
 <20190403162935.GS29086@twin.jikos.cz>
In-Reply-To: <20190403162935.GS29086@twin.jikos.cz>

--ppaqk7TZFaCZawzdL8J01ChoRsREdCx3J
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


I'll rebase and retest the patchset.

Thanks for the mentioning.
Qu


--ppaqk7TZFaCZawzdL8J01ChoRsREdCx3J--

--sdUElpGlLM1pyPyGtMDO6m3SC38dTHjdw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlylWfwACgkQwj2R86El
/qjqSgf/XugKjztCE22lWJeC2o//sIhKfA52ZnZ4/lU1EIMLuxfSG9uIHB4x3pU9
ZnG4tKk8d7a3fsa+rl9eO8wkD4BZPVFawl8vFp/3jzbxolzukGrY49KYlZEJ+zsf
YuVP71PQrH8dcCJb0dNopO/0k2NlgD+/0imN0ih2vgnBf1EkVArI/WhgSclT5zlq
+lPctDWQG3A+LdjDK9nb8+p/jiEwbgXJ3lnZzdjX/pt6ERxQVYUtZK1PEPWCg9f6
/QnT3hiWDvFadGuxeqeo6vvqHzpPjqQrq9r9rCLPanm3RSgYeTLvlfZq8EPk2pJJ
xTNezduQPRLAhKhNuz0SnuERABV1ug==
=FUCX
-----END PGP SIGNATURE-----

--sdUElpGlLM1pyPyGtMDO6m3SC38dTHjdw--
