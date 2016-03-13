Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474AbcCMLdd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 07:33:33 -0400
From: NeilBrown <neilb@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Date: Sun, 13 Mar 2016 22:33:22 +1100
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and its header
In-Reply-To: <56E4F7AB.4010608@cn.fujitsu.com>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com> <1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com> <87io0vjq9x.fsf@notabene.neil.brown.name> <56E0C668.4020406@cn.fujitsu.com> <20160311114305.GQ18908@twin.jikos.cz> <56E3D070.3020005@gmx.com> <56E4F7AB.4010608@cn.fujitsu.com>
Message-ID: <87egbeipdp.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 13 2016, Qu Wenruo wrote:

> Qu Wenruo wrote on 2016/03/12 16:16 +0800:
>>
>>
>> On 03/11/2016 07:43 PM, David Sterba wrote:
>>> On Thu, Mar 10, 2016 at 08:57:12AM +0800, Qu Wenruo wrote:
>>>>> The ioctl FIDEDUPERANGE and the tool duperemove both use "dupe".
>>>>> It would be nice if we could be consistent and all use the same
>>>>> abbreviation.
>>>>
>>>> Yes, current kernel VFS level offline dedup uses the name "dedupe".
>>>> But on the other hand, ZFS uses the name "dedup" for their online dedu=
p.
>>>>
>>>> And personally speaking, I'd like some difference to distinguish inline
>>>> dedup and offline dedup.
>>>> In that case, the extra "e" seems somewhat useful.
>>>> With "e", it's intended for offline use. Without "e", it's intended for
>>>> online use.
>>>
>>> Such difference is very subtle and I think we should stick to just one
>>> spelling, which shall be 'dedupe'.
>>
>> OK, I'll change them to 'dedupe' in next bug fix version.
>>
>> Thanks,
>> Qu
>>
>>
> BTW, I am always interested in, why de-duplication can be shorted as=20
> 'dedupe'.

The "u" in "duplicate" is pronounced as a long vowel sound, almost like
   d-you-plicate.

Normal pronunciation rules for English indicate that "dup" should be
pronounced with a short vowel sound, like "cup".  So "dup" sounds wrong.

To make a vowel long you can add an 'e' at the end of a word.
So:
   tub or cub  have a short "u"
   tube or cube  have a long "u".

by analogy, "dupe" has a long "u" and so sounds like the first syllable
of "duplicate".

NeilBrown


>
> I didn't see any 'e' in the whole word "DUPlication".
> Or it's an abbreviation of "DUPlicatE" instead of "DUPlication"?
>
> Thanks,
> Qu
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW5VACAAoJEDnsnt1WYoG5DrEP/355asuAKoZq+YPZ8tkcIKuk
FQ5W6X5RIkOHbg3Sb6MgyuTvazM0UDzXK/QMwWz5MsjOsl97bO8bagK8SvwObext
1glyryXZGYLO1ywzyIg7+02JoI1J/uiBEPbHfEDLjNlP8xg961e121nVFaw+8yrf
6ntLIXmQKrmM1eNXwRmBO7dFtSd3CJu0cYhlzD39JTm5oKeiyyaCat0v4NA+Rua7
ieIESCIlsLbpXTmYgf+snZO2MbY/ILm3cytlSm/AWDjqvSqtcgt9/3vbn69v/KLQ
9INjcOeazVwTGk7ttczIZjdy4cZzrtLLOtsPq4A0krpbrMmlGx8tKCS8w3xUDo01
zaUIND0OrUxiqjmkGFGZXAXNXTm68C6NgsTTOgVF3WqAV4RptdnyftKrsBZ8wX/L
EWMNua2UcsF7ZoIfv1YHG3BrD9Mf9uvTXru5Af+2OMYhnaYIVrzOd8fip9ZtC9oX
30nEbjm7CF3xNl37QplxZREKYtKp9WXcmh788gGA9tLCQL4XiNw8R0s/armijyWI
gkaFJEFBQz+/q3rhQ8/ia5a+Nijc1GiwE7sGYpC8B9T7Txe7s8uR9fK7SE15nZDC
wrW2k7OE4hNNqQkqoHccKsGR9xGrP1gIOq8NVKWd9O7mdqpmIn6Re+Sy0cK6SSj4
7pK9fH/4CNUUCwweVZ8g
=9XpN
-----END PGP SIGNATURE-----
--=-=-=--
