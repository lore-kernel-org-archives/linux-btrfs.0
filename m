Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03E7C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 05:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92BEF214AE
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 05:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SaDSfGFE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387607AbfDYFti (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 01:49:38 -0400
Received: from mout.gmx.net ([212.227.17.20]:56473 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbfDYFth (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 01:49:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556171372;
        bh=oeJCtIIBR4x3/kdadbcoJ4HuXvXPRdm6bSP3rhK98NQ=;
        h=X-UI-Sender-Class:From:Subject:To:References:Date:In-Reply-To;
        b=SaDSfGFEi53ptYWeoTkjGjS1yCK19XiS5BQunbklyPhwQOAuo/60Kd6kbQbaFEcTg
         eMKlXiIQlnjcTdC+lYHwdGSJvZnLHko/Cg8E+OWpG6aXbO9MUXkn2/Ha+syMRLp31n
         8lphcrWisazNVqC88/dPgNaQ5MmtdbBTO0O9DC00=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M9s8K-1hUYnz0tLs-00B6n3; Thu, 25
 Apr 2019 07:49:32 +0200
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
To:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
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
Message-ID: <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
Date:   Thu, 25 Apr 2019 13:49:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423113302.GS20156@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Zychrpc8szLZW4YPkSot6pVHijfOVfq8V"
X-Provags-ID: V03:K1:9mMXRwj5nF6w2NV8gpSdzCkCVVzIxUF5n671ymvnaxYSyJ5pet6
 m3EvsD2oFaiqRu6x2qkCqZ2xNoj7Eo2DT3GCidi867v8sCUaE2JRb1fv0Dn/ekG3hOwhJc6
 ewkbswh+yaWCIyZ3zM+jIf+mJ5wtj3dlVMuQH+z4aYT1a0MEY9g6RxhMizC0QRkhCaG39aG
 3gQJTqLZJPQAVBWg7Lg6g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sCWFfBST+j4=:JsmE9YHnw/1Nw6/O5Rb4Qg
 KfTC0W8k3AuivIa1mkkClMzjMxXOQ1SND2jfIBS0a4SVAaL2UMXsqrmKCdcWs3AabH9PghLlz
 KekdaoyWWpgxtKGnY3DGPUGY/9y53nBwdMIHWckxryxT1QqQGeT7Q7lp53eZe0m4tvJmxe1iO
 SE83rYg9lSxb5L2mHwDzHY6ZGOVwtET/P+/knoQFcqaFHLAp4z8TbccFoZKPV1O8sIJ3SmCAp
 6U5fZA9YPd1EvLoTwRn5dfIhgZbVrrSVfK6la+4EkdBwLyR65T+YugyZhFPkvlCullaemcu8Q
 qxbvrfeD7IRGpJtjePUANVyVaMyPmh3lCL7e55cVQlfQNWH1edjtfVjHr226OzYW9JPfRMMX9
 DHl7tauZCeJXbMsPa8hhRcMtF+kf7OZwP/KB6VKVr2d/mjuCvShru47WIMPsbqHjYN87X8oA/
 Kjabw9P9wir3qrWGyz7UPOaJXKGjez3kzzAgvLNsqOI0/PTi/VArzT4I1SCWx0CDyeTCqO2k7
 nga/3FuxtfQWs8+O6Ok8LFFi+Uiou0Uaz93tN81XV6LrI/cOg/QEGUV4LrDsFvn3AB9X+LMTS
 4imi0JRsdHeSnoEWpm2RfBssMoXKF85Q3fHZb6+/w9GI4zv9+YgoL4QqG3CIkISi8mdo2yTWp
 C2kojQumb2X6mOF1BES9LSUPQRBi0QTa5vvc2YxRZ0+gqmKZ0hP3Gopk/FKpPgZHB+W4vWVZE
 PiitQM8x7vcGDOF6bt4DULwRyFi3jXnPBHtmHu+gnm04/kr9cuLhAbrj85q6eG7qBboBx/WB6
 rI04yCnZ5tPX8VKC2/feeIGTFWQnLP7ZYjmU+QUfUhcS2xuelSZK+IR45ic7/M6TOs45YYPl+
 zaXEqox1FOBg63ge6Tp9LegV6wQn0M4YNvkWE15ksHXak6v2fKJEwGJp9yINng
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Zychrpc8szLZW4YPkSot6pVHijfOVfq8V
Content-Type: multipart/mixed; boundary="gAawkZuShESXLrubpJ7lnWEixx369Pp45";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
 linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Message-ID: <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
Subject: Re: fallocate does not prevent ENOSPC on write
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
In-Reply-To: <20190423113302.GS20156@twin.jikos.cz>

--gAawkZuShESXLrubpJ7lnWEixx369Pp45
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/23 =E4=B8=8B=E5=8D=887:33, David Sterba wrote:
> On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
>> On 2019/4/23 =E4=B8=8A=E5=8D=885:09, Jakob Unterwurzacher wrote:
>>> I have a user who is reporting ENOSPC errors when running gocryptfs o=
n
>>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395=
 ).
>>>
>>> What is interesting is that the error gets thrown at write time. This=

>>> is not supposed to happen, because gocryptfs does
>>>
>>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
>>>
>>> before writing.
>>>
>>> I wrote a minimal reproducer in C: https://github.com/rfjakob/falloca=
te_write
>>> This is what it looks like on ext4:
>>>
>>>     $ ../fallocate_write/fallocate_write
>>>     reading from /dev/urandom
>>>     writing to ./blob.379Q8P
>>>     writing blocks of 132096 bytes each
>>>     [...]
>>>     fallocate failed: No space left on device
>>>
>>> On btrfs, it will instead look like this:
>>>
>>>     [...]
>>>     pwrite failed: No space left on device
>>>
>>> Is this a bug in btrfs' fallocate implementation or am I reading the
>>> guarantees that fallocate gives me wrong?
>>
>> Since v4.7, this commit changed the how btrfs do NodataCOW check:
>> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
>>
>> Before that commit, btrfs always check if they need to reserve space f=
or
>> COW, while after that patch, btrfs never checks unless we have no spac=
e.
>>
>> However this screws up other nodatacow space check.
>> And due to its age and deep changeset, it's pretty hard to fix it.
>> I have tried several times, but it will only cause more problems.
>=20
> What if the commit is reverted, if the problem is otherwise hard to fix=
?
> This seems to break the semantics of fallocate so the performance shoul=
d
> not the main concern here.

My blur memory of the underflow case is something like below: (failed to
locate the old thread)

- fallocate
- pwrite in to the reallocated range
  At this timing, we can do nocow, thus no data space is reserved.

- Something happened to make that preallocated extent shared, without
  writing back dirty pages.
  Some possible causes are snapshot and reflink.
  However nowadays, snapshots will write all dirty inodes, and reflink
  will write the source range to disk.

  Maybe it's a small window inside create_snapshot() between
  btrfs_start_delalloc_snapshot() and btrfs_commit_transaction() calls?

- dirty pages get written back
  We created ordered extent, but at this timing, we can't do nocow any
  more, we need to fallback to cow.
  However at the buffered write timing, we didn't reserved data space.
  Now we will underflow data space reservation.

However nowadays there are some new mechanism to handle this case more
gracefully, like btrfs_root::will_be_snapshotted.

I'll double check if reverting that patch in latest kernel still cause
problem.
But any idea on the possible problem is welcomed.

Thanks,
Qu


--gAawkZuShESXLrubpJ7lnWEixx369Pp45--

--Zychrpc8szLZW4YPkSot6pVHijfOVfq8V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzBSmMACgkQwj2R86El
/qipmgf/dq9e+McIywMfc9c3fjPwrQ3WF7BsozTe7Ulc807+j6GNBjiwB3FdkkLI
sW38Kl5IPzseFchUHX8QlGCCm3DE8so45FfiM91yc++mglfK+rvrWRl0VJ0JrVsz
QHweVIjRgUB/eAo6g6FhPwx7t42B6bMa+l3ABHJt86uoaXqiBABeaDYNnDksK1EG
zjRGXO6+KH3EufTKilyX7/VkL0f51J7DACH6IyWReLBIHe9gxZ+BL7bs8V5EoM7c
lMG/7yktOmDbQXCyCTMzYOWpPSGtY2N2xkKLMrW5vbTLYwRqXSRf8WNUf+PX4Co3
1iK8Y7arWiQD93HTWOj1HVHBAcXyRA==
=4LDJ
-----END PGP SIGNATURE-----

--Zychrpc8szLZW4YPkSot6pVHijfOVfq8V--
