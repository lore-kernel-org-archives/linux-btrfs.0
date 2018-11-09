Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AA3C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 00:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F274D20840
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 00:27:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F274D20840
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbeKIKFt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 05:05:49 -0500
Received: from mout.gmx.net ([212.227.15.19]:35129 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbeKIKFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 05:05:49 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M0gww-1fVZB71PpO-00uuac; Fri, 09
 Nov 2018 01:27:40 +0100
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181108131750.27833-1-fdmanana@kernel.org>
 <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <e65de2b0-a331-4965-44f7-d7f2fc4ccc79@gmx.com>
Date:   Fri, 9 Nov 2018 08:27:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nOXQwUGFg4lJMGKFfQEho7WM8WiQMMNkn"
X-Provags-ID: V03:K1:OiyWgkev7Cknr0qUlYargRdCBgu+SX8vr0FRh0U0+tDuCmnSoYz
 x4drkWSMcKWpHdBHlm5LF17RcW3RgOeMad1BiWT48RDmeMiaWGWyX993NFObYAJ9ERN+BC/
 KMEwU6UztcJrvXs5KOtFCvHEcgD6rknb+OIY3ykaVvA7G1jTAL+uTxkdCT4XADU30N+yqP9
 kfI3ByZED93L5vnI0CAow==
X-UI-Out-Filterresults: notjunk:1;V01:K0:FxELRiQxjik=:jyUaH6IbasTkJlzos31Euv
 3/cYYCGza5PPsIjEer8H9tuzvZjmEbRp1RUvMuFvuqGQwLBtIXHcoHH/loFt96QVqoxpQlusu
 S19jSct0o21yQdK9N7sOjIxKlmFHFLi2MuWXp6bsPH9qFiNKFIxgIHkFzXSMcg7LnUb4euAat
 /k9agckXcfX+Wn+Tcny7X9yJ4gipqB55VT7AfFeNWDFeiYe4kJRv3ih2WQt5+Ycl4SL02PiCF
 KEur/5LrzqSV8AgJ2qGyq2VAur2kXrUsgYfoa5nvx2rtkW7T9g/iqM1D3Nk5u+8P7upbTJUHP
 6Fiz6XirkmRzHhPcms+SSRhqwUTYJkFxfGnvLF6mOtOsM1fIezjpEDg0dz5BT3hEbRtXwfUaS
 YAFUvcyQsl2PpU9/hE1nEbAMI2b+kKxum6OfOti23xhW3qC1b39cXfErNbgp3Pw3T6WthrU1+
 Lqmfo68rV+KuyxCVXRFRVQ1MjwC07ovX8KAxhOH/o7BUIhywxgsYuBUITJRT5v9LJeG7EL+HJ
 yP+0IibBNnB8YzgC+t807i1UYdfWg1rtsLoYIYsC2Cz1H36n48tleumcoAFASCxGHrvmvY+ms
 OFNeSYKRDuFpJXUI20ALLYgsXAq0uI/k3u/uwboQK69M1VP4DCjQZH0aPwG9Oy+jZv+OfMjZb
 Xyx1Dz2japvvmCzV8L4QfVxeu2UUMDg78mbhH+8lor0xc2K12J+N9G2AV4FYmkc+cDu9A3P32
 RqbCQFX81CbmE39Qvtdyw3woTllTIE9GjtInkWAb4Wm+f9XTADdxP8jOxXCoFlVajXfKWOmzt
 VgoSYOOD1E5ueEgEeZGpGiIZsE1D1/FwtChWdEzuJU1seiSwOcoZetuPyfbkon4iax5txh4qH
 v7UozgFBkaMIMh8AtuPIkdVM3Ps5fDVxdywiEAUNj3ZxLK9sio/9WeaYNejIfa
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nOXQwUGFg4lJMGKFfQEho7WM8WiQMMNkn
Content-Type: multipart/mixed; boundary="w47SnSI4Uyyraee6tOBwg348lIk3eNEJU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e65de2b0-a331-4965-44f7-d7f2fc4ccc79@gmx.com>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
References: <20181108131750.27833-1-fdmanana@kernel.org>
 <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
In-Reply-To: <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>

--w47SnSI4Uyyraee6tOBwg348lIk3eNEJU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/8 =E4=B8=8B=E5=8D=8810:48, Filipe Manana wrote:
> On Thu, Nov 8, 2018 at 2:37 PM Filipe Manana <fdmanana@kernel.org> wrot=
e:
>>
>> On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
>>>
>>>
>>>
>>> On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
>>>> From: Filipe Manana <fdmanana@suse.com>
>>>>
>>>> When creating a block group we don't need to set the log for full co=
mmit
>>>> if the new block group is not used for data. Logged items can only p=
oint
>>>> to logical addresses of data block groups (through file extent items=
) so
>>>> there is no need to for the next fsync to fallback to a transaction =
commit
>>>> if the new block group is for metadata.
>>>
>>> Is it possible for the log tree blocks to be allocated in that new bl=
ock
>>> group?
>>
>> Yes.
>=20
> Now I realize what might be your concern, and this would cause trouble.=

> Surprised this didn't trigger any problem and I had this (together
> with other changes) running tests for some weeks already.

Maybe it's related metadata chunk pre-allocation so it will be super
hard to hit in normal case, or some extent allocation policy preventing
us from allocating tree block of newly created bg.

Thanks,
Qu

>=20
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 577878324799..588fbd1606fb 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_tran=
s_handle *trans, u64 bytes_used,
>>>>       struct btrfs_block_group_cache *cache;
>>>>       int ret;
>>>>
>>>> -     btrfs_set_log_full_commit(fs_info, trans);
>>>> +     if (type & BTRFS_BLOCK_GROUP_DATA)
>>>> +             btrfs_set_log_full_commit(fs_info, trans);
>>>>
>>>>       cache =3D btrfs_create_block_group_cache(fs_info, chunk_offset=
, size);
>>>>       if (!cache)
>>>>
>>>


--w47SnSI4Uyyraee6tOBwg348lIk3eNEJU--

--nOXQwUGFg4lJMGKFfQEho7WM8WiQMMNkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvk1HcACgkQwj2R86El
/qiqkAf/Uppca8RttxbiENWb3yNZrbZFkf1ELuQ9lKnaEEqBRgKslOoGaIUGCqHl
ExLRkpAa0b95p4UbeZdXQmp/SI3TBVUyg4oOXmveawlMpIVvGs1K72fuNWYZFPvT
kg4G1a38qcUdn703REKa2aU1U7LhetSL37A6VCX3TPbAu0lo+nS/Ho/zAAe0TsRG
dtI06Iuj2xEVEyacETl9mDnWSYeT4wSuQWwI6udXI5W2Dz58d6VvywBHtf6sdlRG
9rUB22gBN632JoGnw1Q0YjSJ1MyrYBbFN/Bqe/j+zMTEaJVj1Dq0WsE+LfO6QOgW
WsxaKMNY7flKtP+cp9byweXnbFEf7g==
=raL2
-----END PGP SIGNATURE-----

--nOXQwUGFg4lJMGKFfQEho7WM8WiQMMNkn--
