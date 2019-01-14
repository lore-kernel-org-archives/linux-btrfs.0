Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678F9C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 10:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36D022086D
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 10:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfANKAp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 05:00:45 -0500
Received: from mout.gmx.net ([212.227.15.18]:41707 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbfANKAp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 05:00:45 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MJSLz-1ghbKu1uPb-0036Zb; Mon, 14
 Jan 2019 11:00:40 +0100
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
To:     dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <f26305c2-3c8f-6d16-f414-636e5548851e@gmx.com>
 <20190114093504.GA2900@twin.jikos.cz>
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
Message-ID: <66f134a1-09ed-9e01-5af8-c7c6353e898f@gmx.com>
Date:   Mon, 14 Jan 2019 18:00:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190114093504.GA2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JHc6pV9AdpIGVmGrva4fP4gETEwt0nhJb"
X-Provags-ID: V03:K1:i9c4PaJ4qnMmo1khHxBwB3f7/EzzC3Hb4dup67GGWOZeUwLi55v
 4zPKOO6txEKceGU3Dfnbb+9sxAe/imECGqnZaAfi9qnyhlIyZ3cpXrcLC7QX6xrm+PFAXP0
 WOkuIput4aFZJg8RaacvJKP6Jq5ioA0r0FWZia2qqMNL/TbJZIb/etnBiFuI7nnXyxaWH/0
 4b8JeGz9yNKGUYV0jhgIA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:t4fv/yNBWKc=:W0BJ+qaG+ttSDyigmMdS1a
 5cb9jGRZCysCf46sFZxoMWHjUxVSgGpVOjqfZsc5uFQy51CSylp27JjSQ9Oeb6If/wbp/mKi1
 V5MyOjzwTcCZmf5DpsA4g8XGlAG6GVUIM1aphx09BkrZrMfKTmLtf9NzvYWl55Dz1l9iwTLB0
 N5WvQRS50apkUE4bdN8vI/rtKFmP3vGw81a7SjGqazn6v6zmmZgnH3TGmxdNCBB4rALTMgtUp
 TTY1rELJ5L84iy0okIpP0LoN5Glx5UbcEJ7oWw3Uw/r4QGyW5pEh4vaDX9Ho5kNt1ZvlPZ9OC
 6JS6rmsKtWRKglkb7Tnmsf15VVUloIONGzTR4fx2cpgEo87/JJ89yGfRKgbUmxu0lQ6doKX7M
 uhlFlr+q5H7MkEtGDnMcu1suuZPj12gM0/e7ZicZ4UP6pWdDFJeYcK7hnYr2e872TtG0LLbA3
 wIezClZBkTkx7fE8mzPUxrmpFAnRFjzb0D0WvsEIP9F1yEirdDHxckhHqVAzYx/3oFup40L44
 ZLGYy+r0oXsPIG/NWAmVN2/hZvSHa5CMhAhF4sLJBCSSLioGXu1JqmosxSSv65WAWpzSUme4n
 zeSVbP0xBMituGQ5/7vxpRS32rbmb1L5s3wJOw/Wgi5gaQfbYpjP/OmOaG6mrnTjlO+OD9gVZ
 1M40cQ9jnDQzy+C9uD/YM0FrvAgnV896dzbhpNZrfoQwI37kiIhokYh6i8ERCGXIBxv6F8c8U
 fjGQSjjFr+fznjbrWT9vpPbClAdoVDLzyQbEA92Rljv6oYp5s2ONB29IySJY+T49nJsLz0Ste
 2pbZedeHeXqoQjIgWnFyUhg0WP+5geUSf+/NOQ+4yzodf+UzkWhM5KFFjSZEEzpABEYxcT1wH
 HO4cPe4j/DZuxlkQcIFJbAIXpBCO1vHn9Sf8PAfPm1ShN02q+AVj6IdGV76sV3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JHc6pV9AdpIGVmGrva4fP4gETEwt0nhJb
Content-Type: multipart/mixed; boundary="CyDj5onf3DVGFyMf5DnPMn9pdOHimAP9a";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, "linux-btrfs@vger.kernel.org"
 <linux-btrfs@vger.kernel.org>
Message-ID: <66f134a1-09ed-9e01-5af8-c7c6353e898f@gmx.com>
Subject: Re: [REGRESSION] Super slow balance in v5.0-rc1
References: <f26305c2-3c8f-6d16-f414-636e5548851e@gmx.com>
 <20190114093504.GA2900@twin.jikos.cz>
In-Reply-To: <20190114093504.GA2900@twin.jikos.cz>

--CyDj5onf3DVGFyMf5DnPMn9pdOHimAP9a
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/14 =E4=B8=8B=E5=8D=885:35, David Sterba wrote:
> On Mon, Jan 14, 2019 at 01:39:46PM +0800, Qu Wenruo wrote:
>> Hi,
>>
>> When rebasing my qgroup + balance optimization patches, I found one ve=
ry
>> obvious performance regression for balance.
>>
>> For normal 4G subvolume, 16 snapshots, balance workload, v4.20 kernel
>> only takes 3s to relocate a metadata block group, while for v5.0-rc1, =
I
>> don't really know how it will take as it hasn't finished yet.
>=20
> This looks like a lockup, unbounded waiting or missed wakeup.

Nope.

It's committing transaction like crazy.

With much smaller dataset, it in fact could finish, while v4.20 could
finish just in senconds, v5.0-rc1 finish in near 400 seconds.

And during that 400 seconds, btrfs commits itself for over 2000 times.

>=20
>> And the most important part is, this happens when quota is *DISABLED*!=
!!
>>
>> I'm bisecting for this regression, but if there are some users trying
>> latest rc kernel, please be aware of this regression.
>=20
> The rc1 can go pretty wild and issues could be caused by other
> subsystems, so I'd try to test the merged (32ee34eddad13cd4) and
> non-merged (52042d8e82ff50d) branches, this should tell you if it's a
> genuine btrfs bug or not.

I have already bisect the bug, it's 64403612b73a ("btrfs: rework
btrfs_check_space_for_delayed_refs").

And further more, I sumitted an RFC patch for fstests, which everyone
could test without using the uncertain contains from '/usr'.
https://patchwork.kernel.org/patch/10761715/

This turns out to be several change in relocation at least.

If we don't do snapshots, just one subvolume with just several megabytes
metadata to relocate, it just returns ENOSPC.
With enough snapshots, it commits like crazy.

The bisect is based on relocation duration, haven't digged deep enough
to make a judge on the ENOSPC behavior yet.

Thanks,
Qu


--CyDj5onf3DVGFyMf5DnPMn9pdOHimAP9a--

--JHc6pV9AdpIGVmGrva4fP4gETEwt0nhJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw8XcAACgkQwj2R86El
/qhIjwgAkWYvxLhf9cBBGn29K99LcaimlFIwfycfocZekHLqk6U41W/teO8JqwYV
n+A/oh6u2sI7l2rmEuRkP9V3fQ1GMiIB/gXpfkA24e/VkiS0HPXCsfsVeDRlBU8B
EYiFB7n5XHFN+TUESiRtTMJm76FZMwGEz8xaDTavQ4SX6uBheM+bf4KXNWxmUUJh
5k7aHU+jOqnYVYXacjATOqI1cAaPaY7Tbroy/qBd+hTx/zsqyBUtwZkvoD90wWug
fXbGtsANdIFkh2mSTsZ+43bYiDL+QaTvJ7+8BVgXhBQAJ8LSnD/OTOTLXv2hT46G
l0kV/aMfEBaeZXog6GhhwssjeWt+TA==
=6Z3P
-----END PGP SIGNATURE-----

--JHc6pV9AdpIGVmGrva4fP4gETEwt0nhJb--
