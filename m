Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AA5C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0C2E20672
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0C2E20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391362AbeKWA0W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 19:26:22 -0500
Received: from mout.gmx.net ([212.227.15.18]:52167 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732583AbeKWA0W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 19:26:22 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LaXEN-1fiUcf016t-00mJzJ; Thu, 22
 Nov 2018 14:46:51 +0100
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
 <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
 <3b5c8646-42f7-e51d-e1f8-c28541558192@gmx.com>
 <20181122131257.GQ24115@twin.jikos.cz>
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
Message-ID: <2046f027-fe50-a160-bcde-cbe316cdad90@gmx.com>
Date:   Thu, 22 Nov 2018 21:46:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181122131257.GQ24115@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fGJjz5l99wuVCyfTmvjOfSJMTaszl16no"
X-Provags-ID: V03:K1:Ti5Nx+HGhoHClpVx1R4H3A4GMkpsSYbYzWH0918M1JNt349l66t
 FfX0sNuQMJsq5JQ7HDfd3yp/pWWKPS5I2Ktw4w0HKZWYf88fKl3qQ/cBjV/eyhngf4CyFl7
 U+WKHz+u69vkKNvfxxytYeZfLdqpYH9P/g3hzob3HGSLxC9JUoXDA7WT1Z/JSckFCf1tQHo
 5na02xb58MbCUrzwVQYvw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:TmTnz3y5zlw=:VTaUJThlbq0hGtHZ/B8rym
 oQnD4v3MZdBEhc6Q7MsCXJzERpr/NNRCCDzZ+Gq0VVA5X/R0BtEBDXMuNMv6qqTUPezRHNQlz
 zBRWb3lkB8UKjNZhiqvLKu10XYrd6+wCfah0GqJjc78QHIzS5gWyuxnMJDJapPzvwM1YKtTo2
 FfEJEiJyvaRb+3vJ/STo11XLpM4r9UzdosEWxMArxGn7hpptTGCmVD4GN2BUwEbkBagz3A9GJ
 HKuiwovlZhD8nSt7MHrupw2BGNvI9QalVBe3gNXTPEgL6NVbayckr2HAgJxoPCsmr7IcPRDS4
 Vlmk/fm8cS0bRx7wOmuYIKc9pE7p1xP4tf/O6KWlfuKN1M7mMA0n+UUnLmaIAdjNAfd8Qe6pZ
 yoEfTkzEDWkQGepjA3R9U9aLqT8owOialJt9ZjI120QquA03cxfoo7Zzi7rGZSCm6tzFdP+Le
 d+oiis8JwBVMJ3SY8UH6n5VmO63Q95HvpXnXk0kjY4+dVHsJT+EqQzAiwweVWdtUs9wo4ENkL
 jyq3/EnB+AEvjh1mSMjKfkeqaftyeN95kGZU/kVMgOVwb+JPvHwOzLIUtJueXDZo7WdQGLenY
 vvFVbyYMjqlhqjQOl7Jt7daPv6BzUe7PsvT8LJQ5o0FX+sYr6+52gnbKODDqU/zxx3k4Iqvw/
 ymUvyft8AM51lP/E1MijSiHskLYB1+c5MbC66BWS6q9WILXNpYDZOp1K0k/7ZeID8i8U6CmK7
 K6bnsGdIdw7o5IMueHUK8gLl/Hi6fV4Xwa6FB/6eQXopnjjoyDTAfouxgZ8xQuG1Wj3fpkDjK
 WX8XADyHTxO7TbjNHXCNAjGq1MiUSU5KfLiLPpct5MR5bDjmLhVTsbHqRe6LUk7DOaNFch/oP
 Vx8UW1mZ43h14Oo6CvZ7XpJINZAI/R/RploEEqp8Q=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fGJjz5l99wuVCyfTmvjOfSJMTaszl16no
Content-Type: multipart/mixed; boundary="YVGPwniVVg7xaFVOK9MBEMaLZcMecKGxC";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2046f027-fe50-a160-bcde-cbe316cdad90@gmx.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
 <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
 <3b5c8646-42f7-e51d-e1f8-c28541558192@gmx.com>
 <20181122131257.GQ24115@twin.jikos.cz>
In-Reply-To: <20181122131257.GQ24115@twin.jikos.cz>

--YVGPwniVVg7xaFVOK9MBEMaLZcMecKGxC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/22 =E4=B8=8B=E5=8D=889:12, David Sterba wrote:
> On Tue, Nov 20, 2018 at 08:32:42AM +0800, Qu Wenruo wrote:
>>>>> @@ -1013,16 +1013,22 @@ int btrfs_quota_enable(struct btrfs_fs_info=
 *fs_info)
>>>>>               btrfs_abort_transaction(trans, ret);
>>>>>               goto out_free_path;
>>>>>       }
>>>>> -     spin_lock(&fs_info->qgroup_lock);
>>>>> -     fs_info->quota_root =3D quota_root;
>>>>> -     set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
>>>>> -     spin_unlock(&fs_info->qgroup_lock);
>>>>>
>>>>>       ret =3D btrfs_commit_transaction(trans);
>>>>>       trans =3D NULL;
>>>>>       if (ret)
>>>>>               goto out_free_path;
>>>>
>>>> The main concern here is, if we don't set qgroup enabled bit before =
we
>>>> commit transaction, there will be a window where new tree modificati=
on
>>>> could happen before QGROUP_ENABLED bit set.
>>>
>>> That doesn't seem to make much sense to me, if I understood correctly=
=2E
>>> Essentially you're saying stuff done to any tree in the the
>>> transaction we use to
>>> enable quotas must be accounted for. In that case the quota enabled b=
it should
>>> be done as soon as the transaction is started, because before we set
>>> it and after
>>> we started (or joined) a transaction, a lot could of modifications ma=
y
>>> have happened.
>>> Nevertheless I don't think it's unexpected for anyone to have the
>>> accounting happening
>>> only after the quota enable ioctl returns success.
>>
>> The problem is not accounting, the qgroup number won't cause problem.
>>
>> It's the reserved space. Like some dirty pages are dirtied before quot=
a
>> enabled, but at run_dealloc() time quota is enabled.
>>
>> For such case we have io_tree based method to avoid underflow so it
>> should be OK.
>>
>> So v2 patch looks OK.
>=20
> Does that mean reviewed-by? In case there's a evolved discussion under =
a
> patch, a clear yes/no is appreciated and an explicit Reviewed-by even
> more. I'm about to add this patch to rc4 pull, thre's still some time t=
o
> add the tag. Thanks.
>=20

I'd like to add reviewed-by tab, but I'm still not 100% if this will
cause extra qgroup reserved space related problem.

At least from my side, I can't directly see a case where it will cause
problem.

Does such case mean a reviewed-by tag? Or something LGTM-but-uncertain?

Thanks,
Qu


--YVGPwniVVg7xaFVOK9MBEMaLZcMecKGxC--

--fGJjz5l99wuVCyfTmvjOfSJMTaszl16no
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv2s0QACgkQwj2R86El
/qgtigf9ET9EWaInXm6TIluiGgURFyTdlUDxhJqeYXhh8m9kZTXlne4D9eUtA2eH
kQQlAu4zIadUw77lUi8Oq7+j4sZbcniuii8fgF73mfeLx/tNyI/biPILtLRu8qxl
MQmLWFCZHP2QBw1Ze7bA9qBWONx368MsaIVgmjkzpw56UsLX5p1v0maPKRzvZ/8b
n4h3JtbQ+vFzaMTnnVYgEHxYJrZlZA/nvhAloPlEvr+b64PQG8pzbeXM4J3jryFk
t0Nq15RmpAoFmiNn9IsNZSEHN+CumY+4nAl76qDn4ltFJGhU9vmvNB5amP2LQhaT
9xOrdb5VI8s6JzCOryu1Gi111ToH1Q==
=924B
-----END PGP SIGNATURE-----

--fGJjz5l99wuVCyfTmvjOfSJMTaszl16no--
