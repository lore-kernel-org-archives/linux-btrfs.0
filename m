Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C4FC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0362075E
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 14:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDCO0M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:26:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbfDCO0L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 10:26:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99F73ADF2
        for <linux-btrfs@vger.kernel.org>; Wed,  3 Apr 2019 14:26:10 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Remove comprehensive root owner
 check
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403115919.17049-2-wqu@suse.com> <20190403142142.GO29086@twin.jikos.cz>
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
Message-ID: <3dc771f7-156b-0909-dd78-f6da539c1972@suse.de>
Date:   Wed, 3 Apr 2019 22:26:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190403142142.GO29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="D3SKrRKDFuOr1ifhAfI7VOCNHgQ8HgTC4"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D3SKrRKDFuOr1ifhAfI7VOCNHgQ8HgTC4
Content-Type: multipart/mixed; boundary="K9wJSQsPxB7pgkUQQJssoCSp6kzeFJwfI";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <3dc771f7-156b-0909-dd78-f6da539c1972@suse.de>
Subject: Re: [PATCH 2/2] btrfs: tree-checker: Remove comprehensive root owner
 check
References: <20190403115919.17049-1-wqu@suse.com>
 <20190403115919.17049-2-wqu@suse.com> <20190403142142.GO29086@twin.jikos.cz>
In-Reply-To: <20190403142142.GO29086@twin.jikos.cz>

--K9wJSQsPxB7pgkUQQJssoCSp6kzeFJwfI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/3 =E4=B8=8B=E5=8D=8810:21, David Sterba wrote:
> On Wed, Apr 03, 2019 at 07:59:19PM +0800, Qu Wenruo wrote:
>> Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
>> zero item") introduced comprehensive root owner checker.
>=20
> That's 4.7, so we might want to do stable backport to 4.9+.

It's just a performance optimization.

I'm not sure if we should backport such things even if we can solve the
conflicts.

>>
>> However it's pretty expensive tree search to locate the owner root,
>> especially when it get reused by mandatory read and write time
>> tree-checker.
>>
>> This patch will remove that check, and completely rely on owner based
>> empty leaf check, which is much faster and still works fine for most
>> case.
>>
>> And since we skip the old root owner check, now write time tree check
>> can be merged with btrfs_check_leaf_full().
>=20
> And for that reason the change should be minimal, this patch depends on=

> current development queue so it's not suitable for the backport.
>=20
> I'm thinking what to do here, I want to avoid patches that effectively
> revert changes that are still in the development branch and haven't bee=
n
> released.

OK, I'll resend write time tree checker patchset.

>=20
> This means to rework "btrfs: Do mandatory tree block check before
> submitting bio", though it's deep in the branch, the scope of changes i=
s
> only 2 files so this should not cause any conflicts.

BTW, I'm a little interesting in the workflow on your side.

In this case, what's the correct way to handle them?
Just remove those two related patches from misc-next branch and re-apply
the newer version?

Or remove all those write time tree checker and later enhancement
patches and reapply them all?

Either way, I hope to experience the same workflow so I could reduce
your workload.

Thanks,
Qu


--K9wJSQsPxB7pgkUQQJssoCSp6kzeFJwfI--

--D3SKrRKDFuOr1ifhAfI7VOCNHgQ8HgTC4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlykwn0ACgkQwj2R86El
/qhKBQf/cn8MHp7NMtnfIanWZ4mzRjKyxyD9XYholsqAM+NPMByIMOpl4NpMjCb2
sP62pXnPCyp2cKNKQowrDSnEPtrzhLpmVULI3yNKXeIIGYZPEqUnkzK4EqGrXAob
O+6sslwDvjEK6QtD1SOVlyNRqThN3F45lDV5sxMUge3/UwjvjN49ydDMj3xc8FXg
VAe5y0uKVDSIDijuipk+Zs3Vjx6cPLhPEX7halslyLKfAteKcaMs2FCZNr+AOG2X
gm59WgtTbXo0N4h1xT+dst1zax6CbJY+k0AiteMcKzUqerHw6DFf0kBZY1Is61x/
Qdsm0FFfAnVzAzo9ronWYcQLa3YITg==
=K6p3
-----END PGP SIGNATURE-----

--D3SKrRKDFuOr1ifhAfI7VOCNHgQ8HgTC4--
