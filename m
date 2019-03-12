Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F576C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 00:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C7612084F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 00:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfCLAmT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 20:42:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:44668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725861AbfCLAmT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 20:42:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36EC5ABCB
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 00:42:17 +0000 (UTC)
Subject: Re: [PATCH v5.1 10/12] btrfs: extent_io: Kill the BUG_ON() in
 extent_write_cache_pages()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-11-wqu@suse.com> <20190312003330.GY31119@twin.jikos.cz>
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
Message-ID: <c327b20b-eb97-d1bf-6763-cf4df795f9f0@suse.de>
Date:   Tue, 12 Mar 2019 08:42:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190312003330.GY31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gdcLKH2A4HhxcUnpUx061YJVwlpWUY8Wg"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gdcLKH2A4HhxcUnpUx061YJVwlpWUY8Wg
Content-Type: multipart/mixed; boundary="loDy23mhh1jXzvzA9xcrptPPh00H58eQW";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <c327b20b-eb97-d1bf-6763-cf4df795f9f0@suse.de>
Subject: Re: [PATCH v5.1 10/12] btrfs: extent_io: Kill the BUG_ON() in
 extent_write_cache_pages()
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-11-wqu@suse.com> <20190312003330.GY31119@twin.jikos.cz>
In-Reply-To: <20190312003330.GY31119@twin.jikos.cz>

--loDy23mhh1jXzvzA9xcrptPPh00H58eQW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/12 =E4=B8=8A=E5=8D=888:33, David Sterba wrote:
> On Mon, Feb 18, 2019 at 01:27:51PM +0800, Qu Wenruo wrote:
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> ---
>>  fs/btrfs/extent_io.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 1572e892ec7b..480e138051f0 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3998,7 +3998,10 @@ static int extent_write_cache_pages(struct addr=
ess_space *mapping,
>>  			 */
>>  			if (!trylock_page(page)) {
>>  				ret =3D flush_write_bio(epd);
>> -				BUG_ON(ret < 0);
>> +				if (ret < 0) {
>=20
> This needs some more explanation why it's correct, there's conditional
> locking and writeback status manipulation. Thanks.

Because flush_write_bio() handles the cleanup in its endio function.

Thus we don't need extra cleanup in this case.

Thanks,
Qu


--loDy23mhh1jXzvzA9xcrptPPh00H58eQW--

--gdcLKH2A4HhxcUnpUx061YJVwlpWUY8Wg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyHAGQACgkQwj2R86El
/qhKYQf/deZZZybH7/1hx2FOe4HHRCFGsfBcuWbIOWu0fyI7pbnSKsV1d/5OcSUS
iXQJT8qtlkzJcdg/zGJNoIScZIdRimU9/SD0rXmo3TCOnVJDBaXIFnM1L7K5ZkH0
THa5vfJUgZN+ckrrgAaYiT/0hiLUzQPDsjWL+VNMNoyO0hR0sUx5XgtsFieSuPwX
SdFXyj0zwocb5/4h+WCYIc5BYdYUPTPmW52djE/+LxwaDWnc+K9jOa/cFl82grRt
vcQtwhQ9h/EdWJy+dR3tnmb8Q9VW4nXww6EhKUBFnHKCUwpDBeCx1DJp1HkgJ8MV
nsjNIN1ZNCpTQUBIo7GIQwRlctirJg==
=xjZv
-----END PGP SIGNATURE-----

--gdcLKH2A4HhxcUnpUx061YJVwlpWUY8Wg--
