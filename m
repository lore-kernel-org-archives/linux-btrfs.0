Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C1FC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 01:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96EEB2082E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 01:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="bcNC5nH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfDDBBD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 21:01:03 -0400
Received: from mout.gmx.net ([212.227.15.15]:51231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfDDBBC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 21:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554339659;
        bh=mlHKET2sw5m9t6md1XsC2moUBZp5kMC5HtmfBqrLGII=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=bcNC5nH0Jg1t1jARmk5qYymfp/m7gF9rj0lCiiNl4QiwiU4AKp56mPz+aevFo3EVU
         NapjKZOYAzcLGvj+gQvkrRyshFKbn9Q0uMYnBw3qUbtdk/Ek8BrLeKdLfFn1D/q4t2
         Q2LHehoNft62YTRx1Xh8W0usxqMNiav1LDBLm5K8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M8NBi-1gzFaF0RxS-00vuAL; Thu, 04
 Apr 2019 03:00:59 +0200
Subject: Re: btrfs and write barriers
To:     Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs@vger.kernel.org,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
 <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
 <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
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
Message-ID: <741a1104-b80a-2fbd-4279-9f754bdf0eb0@gmx.com>
Date:   Thu, 4 Apr 2019 09:00:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Is93iLUCbNJ1YLijH6mhviVqBhrGcbHRQ"
X-Provags-ID: V03:K1:yJV/rRzCmaXXsaMV7K08dI9mvfs9dNgFQw43gvAfabS4e+h4q+r
 Q8TTFckvuyISayrC8qhnsd5ynBYYeYohRC/eruBwt4JdaxG4dh3vEA1b+D3iauT8hzcAale
 B6QXZUYCS8JoUG61UPVMCvb2sYTWYrYIhBN+OHPgUsy4lKffjc3/2SqhIWvnpgadDZyObyM
 dbtWiq7D7x/pfvM4++eCg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:iffmFDIwUJ8=:/pljsgT9a1s5AnT210R7Ug
 UL2Odjy9wPDRCFD88sAilud/swENa/uj0A51fnQYnS7gdMjxQdIwkKBQkaQoyErPJdxjEbxby
 mHy9rtEQU+iHC7DfNfkCwyuIqfL0nMSH0rXUUF61MzHbdFT8/xHdyp/CTDbUbLXRM/twuCTjS
 YVFFvvu+AvLUc1oY/G8GqY/QzNvPZQuk9NgBrj0Zh9PeGob1+REK0xlBLpIaWNh5mmvH/cJho
 1F3JH3ExdWHhfuS36ZWffe5MNL3IjbuaWRzpZkPv8EPSVpLnGWmRWwi4wYnLcKp+7Wfe0/SvK
 97w0tSdAmepx/dltw0rKdHEAiJS7g2xjw+xH6n3IJZiMbbB7dv6uvWK+pakbAi7tdMUAR/wAS
 H3O6blGLmzyYjQ4jvWEMCuqya2rqHzb4YUI+O4R2krowBh3eocNrxlVr4Uy+3KwUZrbVHIgjF
 07WqTwWyVhkZZLK1D1ZGPlwYIJ/6CbIOcFRoa7UeeFJeRNkCmnDzXv+GuyGAfYxwjkLzCem8e
 U6x4JERepbuAO414sBVIy18T8Ih8zUFTxcwWXxy2R/AUeq8/tgX4HTEMaga99fWJSLn4w+3zy
 tbqoXR90PgE8UnHefo2shF9gID5KI2iGF9qpb3olligcIpfqFf2W16M5gpwQeM1vC8fmG6eMj
 X4Al+uuaQ5PHcO/ox8as8081xTW/po1EB3mKankdsHqz6LVB17nw1KJOXbJQC7GlXX13lRJUn
 h3f+2ZXfEMwV0+D6IcvsTvbY1YXCJx/RTmgaXje95Ouo4Chq09HMSj1D85TEv/oRTSGOf3eFs
 0y3wRH2JxOgCRZx/HqUDdQlc9+DCJ5ZOj3DOpztCo8pzcG2JYGhD4lOqFBvB/ABEDfNqibK4d
 d645WBLp1sNnwXvv0tOgYEWgqEMIQzZLoYc98aIo0t7lqDM6dBZcAN792BvB9h
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Is93iLUCbNJ1YLijH6mhviVqBhrGcbHRQ
Content-Type: multipart/mixed; boundary="pGfLvey3Ym4q0qYzvmfc98ydmhz7AY0bS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hendrik Friedel <hendrik@friedels.name>, linux-btrfs@vger.kernel.org,
 "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <741a1104-b80a-2fbd-4279-9f754bdf0eb0@gmx.com>
Subject: Re: btrfs and write barriers
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
 <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
 <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
In-Reply-To: <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>

--pGfLvey3Ym4q0qYzvmfc98ydmhz7AY0bS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/4 =E4=B8=8A=E5=8D=882:17, Hendrik Friedel wrote:
> Hello,
>=20
> thanks for your reply.
>=20
>>> 3) Even more, it would be good, if btrfs would disable the write cach=
e
>>> in that case, so that one does not need to rely on the user
>> =C2=A0
>> Personally speaking, if user really believes it's write cache causing
>> the problem or want to be extra safe, then they should disable cache.
> How many percent of the users will be able to judge that?

No need, unless user really got a faulty device.
And in that case, even experienced developer can't easily spot such
problem, so it doesn't really matter until it happens.

>> As long as FLUSH is implemented without problem, the only faulty part =
is
>> btrfs itself and I haven't found any proof of either yet.
> But you have searched?

Yes, using dm-log-write with various workload, to ensure btrfs does the
correct barrier/fua to ensure metadata is CoWed between transaction.

>=20
>>>2) I find the location of the (only?) warning -dmesg- well hidden. I
> think it would be better to notify the user when creating the file-syst=
em.

As stated already, unless user got a faulty device, enabling write cache
won't cause any problem.
You guys are spending tons of attention to solve a problem that almost
nobody hits.

Thanks,
Qu

>>A notification on creating the volume and ones when adding devices
> (either via `device add` or via a replace operation)=C2=A0
>>would indeed be nice, but we should still keep the kernel log warning.=C2=
=A0
>=20
> Ok, so what would be the way to move forward on that? Would it help if =
I
> create an issue in a https://bugzilla.kernel.org/ ?
>=20
>>>3) Even more, it would be good, if btrfs would disable the write cache=

> in that case, so that one does not need to rely on the user
>> I would tend to disagree here. We should definitely _recommend_ this
> to the user if we know there is no barrier support, but just=C2=A0
>> doing it behind their back is not a good idea.
>=20
> Well, there is some room between 'automatic' and 'behind their back. E.=
g.
> "Barriers are not supported by /dev/sda. Automatically disabling
> write-cache on mount. You can suppress this with the
> 'enable-cache-despite-no-barrier-support-I-know-what-I-am-doing' mount
> option (maybe, we can shorten the option).=C2=A0
>=20
>>=C2=A0There are also plenty of valid reasons to want to use the write c=
ache
> anyway.
> I cannot think of one. Who would sacrifice data integrity/potential
> total loss of the filesystem for speed?
>=20
>> As far as FUA/DPO, I know of exactly _zero_ devices that lie about
> implementing it and don't.=C2=A0
> ...
>> but the fact that Linux used to not issue a FLUSH command to the disks=

> when you called fsync in userspace.
> Ok, thanks for that clarification.
>=20
>=20
> Greetings,
> Hendrik
>=20


--pGfLvey3Ym4q0qYzvmfc98ydmhz7AY0bS--

--Is93iLUCbNJ1YLijH6mhviVqBhrGcbHRQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlylV0MACgkQwj2R86El
/qjmJwf8CTAjNE3BLQMaEQ0NKkvwcwtq9H+Yl/Y3Fsn+Me4aqJILl4te5we2E+P/
7bsrJnqmueTphQvuAoQWn635mTjf6a68+6aVH+CkRWrFD2d8Zw4uFKfrkL147hkT
Rah5xGx+d7dd9QsnKLhap6Dw9ish2H+qgvg253Az5kJ3okwNZAHJMsmMb9hIC57C
lNKmu/qJSGT1ZdCNXvTVQ0nF7G84CGJx6S0pUUQnCobNcF2N1xFTcIR6etTfVzg6
JiVWlg5Bw0kokp8bOW0gwBksZoOrr/0cwdyidaSozp+lH2er5KjYmsR9ruFVsivt
4Wktmo4ZaePruS7JAsnZg4USWcvCqA==
=Dtph
-----END PGP SIGNATURE-----

--Is93iLUCbNJ1YLijH6mhviVqBhrGcbHRQ--
