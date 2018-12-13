Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBBAC65BAE
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 00:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC0E20892
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 00:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BC0E20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbeLNAA0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 19:00:26 -0500
Received: from mout.gmx.net ([212.227.17.21]:55269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbeLNAA0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 19:00:26 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MDV5t-1gfWmK1oIX-00Gr6p; Fri, 14
 Dec 2018 00:54:58 +0100
Subject: Re: [PATCH v2 04/13] btrfs-progs: Fix Wempty-body warning
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-5-wqu@suse.com> <20181213185901.GL23615@twin.jikos.cz>
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
Message-ID: <fbba5949-8a54-5519-b172-325aa5e5ea03@gmx.com>
Date:   Fri, 14 Dec 2018 07:54:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181213185901.GL23615@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nrRt2dq76lJfEnylZfIBUwIlS9Hu036b5"
X-Provags-ID: V03:K1:rqKidQtiM6NfVbI61TSudShcAo7sljBt5Dx0U7Mue8zptwpmFyd
 QOxWCf5s0OY33TiwL7GYATd8iRu1dTzeWQ4cdr80D2zY9aRO6pydqTRZVRVRpF32QWeRKxG
 fzWapH39hWWq48x99PO8DgyuAWBOTsMTzxEeP/8rp0sSVrL8BfZQ2ifISHBsfJCXNmqGl86
 SRayOxlAwHF60bQZNn9qw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jdcK+Q+gP+Y=:WWhvTFtrbx6ZnVqm31mWzK
 xGLJbyZXhQl5zoVpdX6DXNXLKLuDTjrUiOSvv96HgiLV1SMYEagu5hBKcYuf0zG0n/AtOW8Jl
 sFgFOGqoG5S8gRgD4EtMXTCGXWAHOAYnYLGNahoMmvouNZDbUsweBXirXdOe3p+SEot1U0K1Z
 /Olwuo6nEbU50RR8XMP/hufyhJLjk/vWV7H6p8+lePw81LR4nGbesTHOMLs77HmDNjvl++RhZ
 Qi5Zm/+LSpUllrFwFbrAp3qs3Km/JfILebfnGsrWrYTud9FbdpQr5il6Dcph8HmtcXN1txVQy
 46o5j5y4QBnwrQINWMBd//fPQ9tRhuLK+wLxlqCUS0ZE3CglInz/xGCOSPg9MHL91EyzEpcKu
 tyISUeBkeLN8rcBE7V7iy2v3/5wFob6hnV2ChTWhcTTa+V8YmXlIjmtUerJQ2dBZveZ4GFlRy
 4yZM4RdzaYc8BJZA+R618LWKym7Zqmq+I3F8tm5U+SehN0tM24GyZcWn2a19nm7QLiYOCP4ci
 IEmUDcmvraKrxKP7ZrXwyy/krdCkZSAoV6qs+0YmCQaGtZPMkdh2Z2Y59QXbzVrEOKcFJPHYV
 g3vphMrnrf4hjXDYIz8pEn9NFS9UWWnCqyLhid7q5ueuAmmjaCzisM9J7gl7IjBKeOG7Itik1
 RzO30k6AALMY37GTFswRJZzBHq9xiGYoqVDrsxfGuKlbyq/NesqNlKN4ZBV4sGkCqtGIt0oiY
 NsYIQZ+8sN4qwvKIkiTISSAOpaGS68Lj8NDGw0WCKWeU42e0cvs7uoI2L4+chNIFHu8OBjyXx
 VVDLzQvOp7thZUn/eTdmkLTF7jU3FeZCUX8BuZpVV097+QkX6c+BjKBPwmBe4J+0ASVpbxuxS
 xbs+CEJPyYmnHyVdtok735N14qIO+RBPEgy+rZNSQU1A97wsIHjuI+AhEx6+7m
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nrRt2dq76lJfEnylZfIBUwIlS9Hu036b5
Content-Type: multipart/mixed; boundary="zUD1P2SAqAlbppmkSUPnmjZh7oRORZZJh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fbba5949-8a54-5519-b172-325aa5e5ea03@gmx.com>
Subject: Re: [PATCH v2 04/13] btrfs-progs: Fix Wempty-body warning
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-5-wqu@suse.com> <20181213185901.GL23615@twin.jikos.cz>
In-Reply-To: <20181213185901.GL23615@twin.jikos.cz>

--zUD1P2SAqAlbppmkSUPnmjZh7oRORZZJh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/14 =E4=B8=8A=E5=8D=882:59, David Sterba wrote:
> On Wed, Dec 05, 2018 at 02:40:09PM +0800, Qu Wenruo wrote:
>> messages.h:49:24: warning: suggest braces around empty body in an 'if'=
 statement [-Wempty-body]
>>     PRINT_TRACE_ON_ERROR;    \
>>
>> Just extra braces would solve the problem.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  messages.h | 15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/messages.h b/messages.h
>> index ec7d93381a36..16f650d19a4b 100644
>> --- a/messages.h
>> +++ b/messages.h
>> @@ -45,13 +45,16 @@
>> =20
>>  #define error_on(cond, fmt, ...)					\
>>  	do {								\
>> -		if ((cond))						\
>> +		if ((cond)) {						\
>>  			PRINT_TRACE_ON_ERROR;				\
>=20
> I think the definition of PRINT_TRACE_ON_ERROR should be fixed to alway=
s
> emit a statement, a "do { } while (0)" in the other case.

Looks much better than my braces solution.

> Otherwise it's
> "don't forget to enclose in { } if used", the proposed change looks
> lightly safer to me. I'll update the patch, no need to resend, please
> let me know if it's ok for you.
>=20

I'm completely OK with such better solution.

Thanks,
Qu


--zUD1P2SAqAlbppmkSUPnmjZh7oRORZZJh--

--nrRt2dq76lJfEnylZfIBUwIlS9Hu036b5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwS8UwACgkQwj2R86El
/qirpwf/SkJsfk81oBt8+MdDaknK3nDin3lZn63+o2m7pWvtKO+P9yBeewqO9kJb
cRgUcdzFqv657ZlMA9Wo8njyZ8p62TdiPjJlwxRPJX2xhVJnBSILYnCzU+ZHaYvO
G2nrz4jXVXb1ApioV3y74eNoKP42oE7vk3i5Sg3xOiMRn0USOOJeLZ+SUf+YAYtB
C3t7t2vsN+ppDBDy2CMdUzii4iUG08kjsy1TWNptmUXIce+VZv/1Zp6eZ0p9gmmj
7YgzDQ8I4zt0SzdJFoOC9fbiW3iuW8vy+HuakfNEy/mIOXDGJgpLMPV0PHqwL6nh
PJRtgYn4JSVm8mjm9BMJ/gNTVzxf+g==
=T575
-----END PGP SIGNATURE-----

--nrRt2dq76lJfEnylZfIBUwIlS9Hu036b5--
