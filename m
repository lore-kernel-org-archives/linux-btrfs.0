Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D423C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 13:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5698F20854
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 13:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbfB1N4s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:56:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:42434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730698AbfB1N4o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 08:56:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC1BDADE1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 13:56:43 +0000 (UTC)
Subject: Re: [PATCH 0/2] btrfs: trace: Add trace events for extent_io_tree
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190228100255.10953-1-wqu@suse.com>
 <20190228135157.GE31119@twin.jikos.cz>
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
Message-ID: <fe5c5f10-6388-2802-1a61-8d7851613b24@suse.de>
Date:   Thu, 28 Feb 2019 21:56:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190228135157.GE31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tXBJbBqFKTCuyok5AKvwbRW5ah82RGbpJ"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tXBJbBqFKTCuyok5AKvwbRW5ah82RGbpJ
Content-Type: multipart/mixed; boundary="MInIULsoGTAxwWbl3hX7VZBx8Ju07ijdg";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fe5c5f10-6388-2802-1a61-8d7851613b24@suse.de>
Subject: Re: [PATCH 0/2] btrfs: trace: Add trace events for extent_io_tree
References: <20190228100255.10953-1-wqu@suse.com>
 <20190228135157.GE31119@twin.jikos.cz>
In-Reply-To: <20190228135157.GE31119@twin.jikos.cz>

--MInIULsoGTAxwWbl3hX7VZBx8Ju07ijdg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/28 =E4=B8=8B=E5=8D=889:51, David Sterba wrote:
> On Thu, Feb 28, 2019 at 06:02:53PM +0800, Qu Wenruo wrote:
>> 2) No way to distinguish between different btrfs filesystems
>>    Due to the fact that we can't get fs_info easily from extent_io_tre=
e,
>>    there is no way to distinguish events from different fses.
>>    To avoid extra noise, please ensure there is only one btrfs in your=

>>    test environment.
>=20
> The id of the filesystem is IMO important for tracepoints, I think we
> can live with the 8 bytes of fs_info pointer in extent_io_tree.

That's my original concern about the extra 8 bytes.
But since you're OK with that, I'm completely fine adding fs_info into th=
em.

Thanks,
Qu


--MInIULsoGTAxwWbl3hX7VZBx8Ju07ijdg--

--tXBJbBqFKTCuyok5AKvwbRW5ah82RGbpJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx36JMACgkQwj2R86El
/qhIjwgAn5bieuJfjIDQDQo110+Y5KjnwkOveozWMKK9e2SMoEUTUHi9vFIdOUBk
vhemx4S7/++GxAhJ/N+0CH8BBXuYy0Y7NoAug8vmNmAD1P6rWnp0YKZV1ZwCBhmu
lgEbgbWE8KhTMQOAJAsmIKFahMEltSMnamSitKWbp9uL3SX/qI0TbBfFRXBDd/Z6
avPP5eBufmW5vT4+WwCh55enLZRe26YjHWR/pwEF+XlKMErYmpCC60m+KYjOyYfv
ytkOxsUoefS0AVEeh4jtfo4hWEV8d2+yYOukpzWoQ5p6O5tYuiVd+i22oUDfV31N
M9wdpIkTJbWwDb2h5u+cXHL5sVAS9A==
=zxUX
-----END PGP SIGNATURE-----

--tXBJbBqFKTCuyok5AKvwbRW5ah82RGbpJ--
