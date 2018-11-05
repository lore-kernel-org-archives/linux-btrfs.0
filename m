Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5009EC32789
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 00:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4982081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 00:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED4982081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbeKEJlF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 04:41:05 -0500
Received: from mout.gmx.net ([212.227.17.21]:53363 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387476AbeKEJlF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 04:41:05 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSIf1-1g7jWE3uJ9-00TSNn; Mon, 05
 Nov 2018 01:24:02 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSIf1-1g7jWE3uJ9-00TSNn; Mon, 05
 Nov 2018 01:24:02 +0100
Subject: Re: Filesystem mounts fine but hangs on access
To:     Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Cc:     linux-btrfs@vger.kernel.org
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
 <7c69325a-7e95-7377-5a47-5c98eb941253@gmx.com>
 <d493b9d8-2ed6-4dfa-d546-e9a09c5924a6@cs.uni-bonn.de>
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
Message-ID: <41f9e8ca-d5f9-4d2b-caf0-a810096dbfc3@gmx.com>
Date:   Mon, 5 Nov 2018 08:23:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d493b9d8-2ed6-4dfa-d546-e9a09c5924a6@cs.uni-bonn.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ftZMm4KoElO2eTRyNi6juxODmdAgLxGvo"
X-Provags-ID: V03:K1:O6n8ruDLVQGZYFHvAyV9TUjaykerxkEb8tZ3n2z/w6bSff0+Q2J
 clXODqBS/6O9tNNJK8msItF78DFhoy5/SY0vfv5xLGN9lrqIywrBVEGLupVB7qF18Zcw7Xe
 7812v347e76eNUu6nWGUTo1OjHHAZ+kGJYY4yogbQaXURtmaMFn8NBoZQo2SFAlqIa6RVOG
 7PsZBKnWjwYid5GyXkrjA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:/iZhZQ1uTPo=:ocTfccj++MaCVQYPNDyAsc
 ZdBJHVeGLUGyjW7gC/E5qjkH1BFdmy7WtCmb3RBQ/HM8NKRvyfTtTtM3TbL7v7NTqbj/u6iUp
 9p6gGkGhxHnT+75L6CKnH3sw8jKYNFdXGBi9evtV7DpMRwb6VnNzO6w6YprMEMmVTmj1LG285
 BkFXozBRZ1bO2r186LT2axlFnbWOLLI0wUvL3gtaZk2yUxO3wJl10IrWGOn3zeXq5b0IDO0ii
 aQJsqmu7BuawowsEicy5qdnDBYzNTWBWRFpMamVmFkZJmEgdW7YEkUUw24e5ZqWNsvNLAVFuU
 8KR389GYGncoQ+o3PK5pZZASPJUcNIIGa4g8GCUzPV+4Dsq8HFZAfkNUZgdcDsh6/WDbk0/qx
 vKMb5PtRKRuF62glE+tZKiPEue4LqpL6oL9vaFTaHNJpIVxMYnxPk8vdA3smg2oCHcD8bhKbT
 AoqoreQsl+TzBm2D+KmbtNuFkssTvc+1pB08i4GzI8MyVtWmBDjq1Hd1UNM+57UtQda1uh1LN
 GFfaOvWoSCfbs5tcUODL7WO6T8bZ9K/KvNZ9c/5hfVwaG4Lxz9GJ92BK/b5glCARJzXcc/fo4
 H7zbfRwSZrYCbuVGNIOG5Y3TsBepQZxujYSv6K98g6dEnxQAqNE9DzoUdN2x1aZ7Iuv7SW0HG
 A5q/GklhKwPTthaVgqDbaE6ktlQv37JYvH9NYOr4sAgkzLAAmCRNmEjDuJ9aet8fxpwNs85Bk
 GiLAY4OENNopbfiiU/xvN6Iz5Aaie9F4swH76pPPLOGpl8DjsiZRktjqKXqXTlq4Ke4i9ms2X
 hcPbps1I5y41b7/2/N12zh+Ci+tdg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ftZMm4KoElO2eTRyNi6juxODmdAgLxGvo
Content-Type: multipart/mixed; boundary="fmH8tMTVA3XD5mhdy7u4263IQhpgdAlYw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <41f9e8ca-d5f9-4d2b-caf0-a810096dbfc3@gmx.com>
Subject: Re: Filesystem mounts fine but hangs on access
References: <f0e1900a-b242-06e0-b68f-0ddc146eca56@cs.uni-bonn.de>
 <7c69325a-7e95-7377-5a47-5c98eb941253@gmx.com>
 <d493b9d8-2ed6-4dfa-d546-e9a09c5924a6@cs.uni-bonn.de>
In-Reply-To: <d493b9d8-2ed6-4dfa-d546-e9a09c5924a6@cs.uni-bonn.de>

--fmH8tMTVA3XD5mhdy7u4263IQhpgdAlYw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/5 =E4=B8=8A=E5=8D=881:00, Sebastian Ochmann wrote:
> Thank you very much for the quick reply.
>=20
> On 04.11.18 14:37, Qu Wenruo wrote:
>>
>>
>> On 2018/11/4 =E4=B8=8B=E5=8D=889:15, Sebastian Ochmann wrote:
>>> Hello,
>>>
>>> I have a btrfs filesystem on a single encrypted (LUKS) 10 TB drive wh=
ich
>>> stopped working correctly. The drive is used as a backup drive with z=
std
>>> compression to which I regularly rsync and make daily snapshots. Afte=
r I
>>> routinely removed a bunch of snapshots (about 20), I noticed later th=
at
>>> the machine would hang when trying to unmount the filesystem. The
>>> current state is that I'm able to mount the filesystem without errors=

>>> and I can view (ls) files in the root level, but trying to view conte=
nts
>>> of directories contained therein hangs just like when trying to unmou=
nt
>>> the filesystem. I have not yet tried to run check, repair, etc. Do yo=
u
>>> have any advice what I should try next?
>>
>> Could you please run "btrfs check" on the umounted fs?
>=20
> I ran btrfs check on the unmounted fs and it reported no errors.

Great, then it's completely free space cache causing the problem.

You could use -o nospace_cache mount option to avoid the problem as a
workaround.

Free space cache only speed up free extent search, it doesn't has extra
effect on the fs (except the bug).
So you could disable free space cache without problem.

Thanks,
Qu
>=20
[snip]
>> This looks pretty like this bug which should be fixed by the following=

>> patch:
>>
>> https://patchwork.kernel.org/patch/10654433/
>>
>> If previous "btrfs check" shows no error, would you please try apply
>> that patch and try again?
>=20
> I tried applying the patch to the 4.18.16 kernel I was running and it
> didn't apply cleanly, so I thought maybe I'd update to 4.19.0 first
> (which is already in the Arch testing repos) and then try applying the
> patch to that.
>=20
> However, as it turns out, the fs now works again just by using 4.19.0
> even though I think the patch is not even in 4.19 yet (?). I'm able to
> navigate the directories and unmounting also works fine. Even after
> downgrading to 4.18.16, the fs still works.
>=20
> So, thanks again for the quick reply, and "sorry" for not being able to=

> test this particular patch now, but I guess the problem has been resolv=
ed.
>=20
>> Thanks,
>> Qu
>>
>=20
> Thanks,
> Ochi


--fmH8tMTVA3XD5mhdy7u4263IQhpgdAlYw--

--ftZMm4KoElO2eTRyNi6juxODmdAgLxGvo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvfjZkACgkQwj2R86El
/qgJNwgAjN+dMUBkLDsaLki1vxflxz0G3e98N2A52Ol2Mv5POb0QRxlGFjAPeke5
sudLDZWstTeWhSK0F/HXDbDepnjs+wBR1EiqSWmrl88NnYs3MjgX4CyQGglYgv2M
fKkLpRgnfQwzMyidAgIKKzt3TdfylitQJ2HvFbalPhIoV2Bm1e5D8EH4CNWa94/5
g8JcFHiyLpku0zIqhN3pQnTTItmAQ/NHYjupWbABPm+m0k0jQ476FiuP7CTSBRh5
6L/1qlKK2iA05X1w4KRHtvQ9gpxn6R4F6igW3GbcVEq7/jG0rEnJIt09lqi7djHQ
f8UJM4EHxpSiFRikGdd6J/Dn8luTMQ==
=DofZ
-----END PGP SIGNATURE-----

--ftZMm4KoElO2eTRyNi6juxODmdAgLxGvo--
