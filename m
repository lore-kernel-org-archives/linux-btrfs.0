Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CD4C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 04:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E52C217F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 04:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfBZEHy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 23:07:54 -0500
Received: from mout.gmx.net ([212.227.17.22]:33713 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfBZEHy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 23:07:54 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M4CB5-1hGppM11BT-00rlKF; Tue, 26
 Feb 2019 05:07:44 +0100
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
To:     Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
 <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
 <20190225122657.GP9874@twin.jikos.cz>
 <20190225154602.gsrmmp465l7rnkm3@macbook-pro-91.dhcp.thefacebook.com>
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
Message-ID: <ed6b4151-7c8d-5132-13d2-4f00ecabd2da@gmx.com>
Date:   Tue, 26 Feb 2019 12:07:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190225154602.gsrmmp465l7rnkm3@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="neOdx4ashVbsAEP2M9U9mGjUYkMYZuU2F"
X-Provags-ID: V03:K1:6tuxjinBvz2cXQx0lStj7R8V8mfL82YDDwHCI9vo0dlA+OwaSBu
 801Sr8JLzAsgzaW7LnRL9nPqb2kvwPNr4cjniCFzzkbKQ8+vXGgZqNIIGa+lqWVqSkXHOal
 Dx1sE9QMxZBTgDoDl8kOK5hNvVzqJMnjUcvpikUyk2OIwrNbx6ITJaQKK4BzfPaDqTF+cN0
 L7TeCPKzk/Affvh41H+QA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mt0cYkX76Fg=:QaJWxQGgqq8CboLvbDo571
 Wh8gHy5znNUaRtWJEwaWr0I23WO0OpNwvGDgHYL2+CeyVQsdroGZBwRJKQyJrieqp3glTErSY
 hjPPT/h4Wqe424aUWJpJ0lLd0MaVyiNT3TIXJuad2ggNyUOhlWkbvMw6zy+hV2EVIizv54WxH
 Sc+jtiokY4RX1UEBl8RxaWEhahfrjsWmaOPSQcMKbXZ7F3Ibu22FjH+8zeZ9cSR4q0aFuEFN9
 zUbmnjDSIJRDsMaQwCwAJNLjKTA3MkhnCif960OYgxyrw/MrD7n7PFjjWaNBldiI7MHa2VeHA
 pKfi6gwe/AGO0X8KuvPTON7G6HDBg54l5N2fUNELjfTP67vU/fkHrY7puCLnN5AVi8qq/uMbo
 w/p/l8wswhz8NeEOIiyzcfhSo1J/bxtu4Rb0BUEGyZ9r2qjFjMKSHFByarWQ7pg+2oXstB3eV
 xxXrCceK/T8hbOJ8lwcuuIGbsN2gvDhqjcw1VXhqBmkjhn9Atg5Vj/5Y8BadXT/E9zErrrdG3
 g3yRqbd2tZ5VwzDOOcIAQYsrpu2VvjEe2Vmu+1B8g/5ZteNQfXO3o6oKvsub9cAD6gaj1+4St
 biqx+KoID0bfJAD+f0B3UhuFZ3Uj/aY7Zetw8exvxAIiQ//1OijMPrpvk7ASTVvnEvS2kznIe
 JobkLE7kqLxAlC1Rjwt3QOjvvSK7ucSpz7OnfEv6a4pN23Gh+SnP6obmgstzc/1JQwxf1tzfp
 nz0L4aFt/L07vPdz4nZUs4M3yMFduw3Z0Y96BGZzcHsMALR5IPdqdffHjf2ITs+yxlWGxikUi
 Okd0MmThgjVQxEvwSmI0l6Tp2KmAI6buEyVsstm1aSuBxIDo/5oYJ3zhhHLa6TX7UMGM+DAMc
 oqlGIVgTll77JM8/hkMhVQlGcB/aT/6zePgKO1O//e6IAqm39hzoykkChccaMh
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--neOdx4ashVbsAEP2M9U9mGjUYkMYZuU2F
Content-Type: multipart/mixed; boundary="Rqty5VqHl0uu34Q5JQwUYZYgQYYEnGzVs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ed6b4151-7c8d-5132-13d2-4f00ecabd2da@gmx.com>
Subject: Re: [PATCH] btrfs: Use struct inode* to replace
 extent_io_tree::private_data
References: <20190225055043.1621-1-wqu@suse.com>
 <20190225121540.GN9874@twin.jikos.cz>
 <7a8afd82-7acf-e2cc-deff-38ccf702ef2d@gmx.com>
 <20190225122657.GP9874@twin.jikos.cz>
 <20190225154602.gsrmmp465l7rnkm3@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190225154602.gsrmmp465l7rnkm3@macbook-pro-91.dhcp.thefacebook.com>

--Rqty5VqHl0uu34Q5JQwUYZYgQYYEnGzVs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/25 =E4=B8=8B=E5=8D=8811:46, Josef Bacik wrote:
> On Mon, Feb 25, 2019 at 01:26:57PM +0100, David Sterba wrote:
>> On Mon, Feb 25, 2019 at 08:17:52PM +0800, Qu Wenruo wrote:
>>>
>>>
>>> On 2019/2/25 =E4=B8=8B=E5=8D=888:15, David Sterba wrote:
>>>> On Mon, Feb 25, 2019 at 01:50:43PM +0800, Qu Wenruo wrote:
>>>>> All users of extent_io_tree::private_data are expecting struct inod=
e*.
>>>>> So just use struct inode* to replace extent_io_tree::private_data, =
and
>>>>> this should provide better type check.
>>>>>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>>  struct extent_io_tree {
>>>>>  	struct rb_root state;
>>>>> -	void *private_data;
>>>>> +	struct inode *inode;
>>>>>  	u64 dirty_bytes;
>>>>>  	int track_uptodate;
>>>>>  	spinlock_t lock;
>>>>
>>>> So this is effectively reverting c6100a4b4e3d1650deafd ("Btrfs: repl=
ace
>>>> tree->mapping with tree->private_data"),
>>>
>>> That commit message doesn't explain why this is needed for btree_inod=
e
>>> removal.
>>>
>>> Any idea what the extra type would be used in that case?
>>
>> I don't know, Josef in CC to answer that.
>=20
> Yeah there's a mapping tree thing I make to keep track of the metadata,=
 it holds
> the radix tree for the eb's and a bunch of other stuff.  This needs to =
stay a
> void *.  Thanks,

Then what about an union here?

BTW, for no btree_inode case, how do we distinguish regular inode
pointer with yours? An extra member?

Thanks,
Qu

>=20
> Josef
>=20


--Rqty5VqHl0uu34Q5JQwUYZYgQYYEnGzVs--

--neOdx4ashVbsAEP2M9U9mGjUYkMYZuU2F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx0u4kACgkQwj2R86El
/qirmAf/ZdtCUGKnO11znIsmrjFpbYR3Zhv6+3wPQR0x8q6gqfhhJ34x3uKWkvaD
/G3ZpueUs684oMBubdDPV705oMU1ifsKJM6k2dxWIrvoWAQ93/02Mo/wn1+SToLO
Gv0x5iT8xL+l7wWyfkxI3drrTmNtTbIdMrJEZpTAn4fAQC5pXiJq/DormAXyKMEO
iXAD+0o4QKwxf/rDAr5m6wurWIuw/ybH1fPo7fulSVEH3+HPyHBb6Tp4QakHbyLB
g/obBk6yKqF4IhnpD87zzRvOeW/xlcm+WvuejYJx+DoAmxBlGM1C+126wkv1L0vG
Qb+Xipys7zZj1sbOTe/VPtWQZAnovA==
=mrFm
-----END PGP SIGNATURE-----

--neOdx4ashVbsAEP2M9U9mGjUYkMYZuU2F--
