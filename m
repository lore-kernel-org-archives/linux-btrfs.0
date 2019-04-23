Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C60C10F03
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 23:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 437DF20B1F
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 23:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="G86JaaXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfDWXtR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 19:49:17 -0400
Received: from mout.gmx.net ([212.227.15.18]:54999 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbfDWXtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 19:49:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556063351;
        bh=I0N9uvNrCfWmpGn+erQqyLQLvnzUIvhbs+R4xiD+HjA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=G86JaaXIL2uGElXVJ+0L2Gfan8a1XMbvv2aE5YL/a5oi/SbUF2k9VQQKLtCAcyLuY
         tIilo/xD7C4e7eUaJrFrzQUG63E0CbXCqqQn9/wUOdc8YdznSw+3FoCpIcD0xw1H/x
         kJkCqevU4vTmMhCwxat8hG30EDm39EK2kcmEDueo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MzQkE-1gx23y10vA-00vM7h; Wed, 24
 Apr 2019 01:49:11 +0200
Subject: Re: fallocate does not prevent ENOSPC on write
To:     fdmanana@gmail.com
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
 <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
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
Message-ID: <8a3b5e64-1df7-447d-3b07-e276b8d65b40@gmx.com>
Date:   Wed, 24 Apr 2019 07:49:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5W1WV3NIL54K70kg6tvQBCKiUuu3qEJjt"
X-Provags-ID: V03:K1:Hqm655qkBzLXuNsEdt/XrPr43e1geuGEMaLe5g5RAZ6jnlyeS4y
 isFI5gEbD2CSBi52hPHlPd6C1vjBe1yzexaN5HEMhThgofrYtd49NYoWB2A7fUG8DejJw5+
 BDZln/6IZahzTA5mg4hp72xxqy2hm8HfqVIoUf8ul6WcZ731WVEJK1kPfw0JYWxIGx9uWnF
 xDHjAYJrIHoEWbK5p+/gw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QPSyl/knphI=:83uhWx0FdoQuKpZbsr+qe+
 sofZZ3INfukeRMSnL09GTF2Ve73XaaAC3EbY6DtodOq3t/FWbSbqrkH1HNCMIlW/jcECgnOXb
 nOlctlUqhnHNGt/HVP1+6Z2bcdMJVcsiwYEOjlt8JswBo6u/webp+jbvGmzPc8drqFM+DVWei
 Am5a3yuMgNBeEzN/uqeM+odL0mf0WOhS2lXFG4pvDP9oUHqvcBVw03/aUhPRfzQvoKIsVA2cm
 U6TWdA9ujLbh5Z9cZ9xhUaoI38S/OlWm2fadjzailYzaWNOT76WTPVIuZe5s45H/YI9nt9Ms8
 786dQ7WXkCXMhFzQ+vzxpy2SYiy5Ep22OsC83rpcR6Wta/4xDcZNwAfP9dFUoK3Lo5RZ8URN/
 AeITi9hV+XZiNNtJ1J1bYiZFmpT7jxNBO1uk1S8stkLhk4mHm5D4bClrg1ht5bR6Eiqb56rLi
 eK3zzcZV/LQEVpDHvvKi5fcZ2ZBZFFRBeybz5Ihr0pCqP+iabXQHbvycxIGF2ED43NGAtEk7Y
 XavEZex2hrIkQbWVyUHiUFfkdW5CXM/On//TEkmuFQ9EBtC73NKT/T7EIRBcqsiEHOwggD5wf
 29CPAYAfCtwiP1xYdt70uct5grZx/gYCuJsez0pIsY2sicjMSt4VUYqu5cKjvIwnQiEDxeejA
 x8FGEM6hUkX+6e5lqjd7tR+dzuFB0X9TUvEzpr54VHFfGJkpdCZqogZaDckjtV1TsD4lvsYA8
 rLMFYhz+E/iOCHJkPpuOq5faayCnxPBiYXnHdNbdZrOwI/1cWPqX2WaLqdbFSSlDNfVbuMvc2
 wADz+NppRdUJWF94LUaoauUTYxXx9FtkOCYhLkgiAPDmdOAQ4S0bn+MzH4LMADtI7kXlmcQaR
 W2Mj+nvH5n1LJMioHQz3e1wW3dt3wpqAtjrmuDXrtHC0pv8+wWIbM2pi9HI7xW
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5W1WV3NIL54K70kg6tvQBCKiUuu3qEJjt
Content-Type: multipart/mixed; boundary="hcDjobzV2fpMbI5ibG6aibgwA1TIblRnP";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com
Cc: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <8a3b5e64-1df7-447d-3b07-e276b8d65b40@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com>
 <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
In-Reply-To: <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>

--hcDjobzV2fpMbI5ibG6aibgwA1TIblRnP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/23 =E4=B8=8B=E5=8D=8810:50, Filipe Manana wrote:
> On Tue, Apr 23, 2019 at 1:14 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>
>>
>>
>> On 2019/4/23 =E4=B8=8B=E5=8D=887:33, David Sterba wrote:
>>> On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
>>>> On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
>>>>> I have a user who is reporting ENOSPC errors when running gocryptfs=
 on
>>>>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/3=
95 ).
>>>>>
>>>>> What is interesting is that the error gets thrown at write time. Th=
is
>>>>> is not supposed to happen, because gocryptfs does
>>>>>
>>>>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
>>>>>
>>>>> before writing.
>>>>>
>>>>> I wrote a minimal reproducer in C: https://github.com/rfjakob/fallo=
cate_write
>>>>> This is what it looks like on ext4:
>>>>>
>>>>>     $ ../fallocate_write/fallocate_write
>>>>>     reading from /dev/urandom
>>>>>     writing to ./blob.379Q8P
>>>>>     writing blocks of 132096 bytes each
>>>>>     [...]
>>>>>     fallocate failed: No space left on device
>>>>>
>>>>> On btrfs, it will instead look like this:
>>>>>
>>>>>     [...]
>>>>>     pwrite failed: No space left on device
>>>>>
>>>>> Is this a bug in btrfs' fallocate implementation or am I reading th=
e
>>>>> guarantees that fallocate gives me wrong?
>>>>
>>>> Since v4.7, this commit changed the how btrfs do NodataCOW check:
>>>> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
>>>>
>>>> Before that commit, btrfs always check if they need to reserve space=
 for
>>>> COW, while after that patch, btrfs never checks unless we have no sp=
ace.
>>>>
>>>> However this screws up other nodatacow space check.
>>>> And due to its age and deep changeset, it's pretty hard to fix it.
>>>> I have tried several times, but it will only cause more problems.
>>>
>>> What if the commit is reverted, if the problem is otherwise hard to f=
ix?
>>
>> Tried reverted, but all other problems came up.
>=20
> I haven't seen an explanation on why that patch causes ENOSPC or what
> nodatacow space check screw ups it causes.
>=20
> It seems fine to me, and what we currently do:
>=20
> 1) For any buffered write, check if there's enough free data space;
> 2) If not try to allocate a new data chunk;
> 3) If that fails check if the file has the "have prealloc extents"
> flag or has the nodatacow flag set
> 4) If any of those conditions is true, check if we can write to the
> existing extent - if it's not shared or no checksums exist in its
> range, meaning it's an unwritten (prealloc) extent, return success to
> userspace
>=20
> So what's wrong with it? And how does it cause the ENOSPC?

E.g.

We have a 128Mb preallocated file extent.
And assume the fs only have 128M free data space, meaning 0 remaining
space at all.

Then we try to buffer write, which means buffered will just fail as it
will need data space.

The idea is always here for fallocate/pwrite, just the timing where the
ENOSPC happens.


We have btrfs/153 for the same reason to fail for a long time, although
it's from quota, but the reason the completely the same.

Thanks,
Qu

>=20
> Trying the reproducer, at least on a 5.0 kernel, does never fail on a
> pwrite for me, but always on fallocate:
>=20
> $ mkfs.btrfs -f -b $((4 * 1024 * 1024 * 1024)) /dev/sdi
> $ mount /dev/sdi /mnt/sdi
> $ cd /mnt/sdi
> $ /path/to/reproducer
> reading from /dev/urandom
> writing to ./blob.IIa6tH
> writing blocks of 132096 bytes each
> total    125 MiB,  65.52 MiB/s
> total    251 MiB,  44.59 MiB/s
> total    377 MiB,  55.23 MiB/s
> total    503 MiB,  66.21 MiB/s
> total    629 MiB,  59.97 MiB/s
> total    755 MiB,   3.70 MiB/s
> total    881 MiB,  50.24 MiB/s
> total   1007 MiB,  64.51 MiB/s
> total   1133 MiB,  50.70 MiB/s
> total   1259 MiB,  49.29 MiB/s
> total   1385 MiB,  47.93 MiB/s
> total   1511 MiB,   4.00 MiB/s
> total   1637 MiB,  49.85 MiB/s
> total   1763 MiB,  48.11 MiB/s
> total   1889 MiB,  66.62 MiB/s
> total   2015 MiB,   5.60 MiB/s
> total   2141 MiB,  19.58 MiB/s
> total   2267 MiB,  64.80 MiB/s
> total   2393 MiB,  13.23 MiB/s
> total   2519 MiB,  14.95 MiB/s
> fallocate failed: No space left on device
>=20
> So either that was tested on a rather old kernel or:
>=20
> 1) we had snapshotting happening between a fallocate and a pwrite (or
> at the same time as the pwrite)
> 2) before the pwrite (or during) the unwritten/prealloc extent was
> reflinked (cp --reflink, clone or dedupe ioctls)
>=20
> What did I miss here?
>=20
> Thanks.
>=20
>>
>> E.g. reserved space underflow.
>>
>> I'll find the old thread and retry again.
>>
>> Thanks,
>> Qu
>>
>>> This seems to break the semantics of fallocate so the performance sho=
uld
>>> not the main concern here.
>>>
>>
>=20
>=20


--hcDjobzV2fpMbI5ibG6aibgwA1TIblRnP--

--5W1WV3NIL54K70kg6tvQBCKiUuu3qEJjt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly/pG4ACgkQwj2R86El
/qjv2gf8CMaqs2xldS/pNJgXMwGDufjCTc2UiCOFuCbGDETeXwcxS6kU4/RrDQuj
hF/pXtXTaI5kDinQ5W/lm89BVP6dWUPfWeXupj2MnYye4HtmxyXGtHXaS6AkMFWV
JzHBozFebtT+1D89kLOw3DthPYVp2hSz0fnSndn+7J9hXyH3UxogomNU+sx2ptFK
eJD0uA8Om8vaQCtr0M0EvW0xYl3vZAOyo1dPNOGANXXXGqTTwaKMwTfjTfV48Za/
S5TXltqc2pL1dtPqWjc23SLiJ1z5UldCv/uFrv9oMj/7FssJjTG4L4OPoLj3UZyo
s014aRi/RqNIKMUX+GxrEIRqv5kcjw==
=b+yG
-----END PGP SIGNATURE-----

--5W1WV3NIL54K70kg6tvQBCKiUuu3qEJjt--
