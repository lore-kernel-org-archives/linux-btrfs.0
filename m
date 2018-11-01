Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F27C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 23:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71DB82084C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 23:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71DB82084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbeKBIz0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 04:55:26 -0400
Received: from mout.gmx.net ([212.227.17.20]:52391 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbeKBIzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Nov 2018 04:55:25 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M7m0a-1fN5Gv3trs-00vSgO; Fri, 02
 Nov 2018 00:50:14 +0100
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M7m0a-1fN5Gv3trs-00vSgO; Fri, 02
 Nov 2018 00:50:14 +0100
Subject: Re: [PATCH v4 0/4] btrfs: Refactor find_free_extent()
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181017065606.8707-1-wqu@suse.com>
 <20181101185406.GV9136@twin.jikos.cz>
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
Message-ID: <ca181438-0d34-6b97-8659-ed77bef02e51@gmx.com>
Date:   Fri, 2 Nov 2018 07:50:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181101185406.GV9136@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xXoUt9ioLUEMX7rpa4GaV0dIAJfDohlwu"
X-Provags-ID: V03:K1:GdFHUnXWN8KaqQe44kndu+5AvQVWscnIvpNVN0r2CIeRMfJyP61
 4vhKlyi7nQ+Lg3jsD53juMFw6n2osfUObOIZySifvmKzVLXevWNcXvbcjtScJaxQBBHTUfz
 NkIk+Q3Mij6+M8u+I/8FDSti++9cdiIZJ3yBsvuTbXYY7OYVTE6WJ3TFouIhKuro0Lv/pEr
 GZhhKsVLdYuPMQI1BlzNQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:imVAW0xzNkw=:cjymM1nVq0zjQ9+gtgjsq9
 UqSyoAXC+Iblns+eGjqoNqBYsFGvZXQVMYXS77fSRcbxWiZHQl4ywNE9nYwl9nrwUDzBz50uz
 riXV2tDXliYUVL81XRBRKyHWXIT/4KPFMtPuIkm5caDEWfCZFOPH8fgmQ8aDMEQQtnu9q9MnN
 OB+m9depC0SA5GmQ5y762ESgSdTCzYLEH0KuEsmrAFPvGqJoIRTJ+k72NP/2VANlUMz20FjpO
 KMo4+J7u+7zUuJBdtKhxxhDXwnW4RLB0UDoAdePfzD0Ssskqk/O8nrrPETl8KdDms0bITJoki
 iPqAiROr25PHcJb9OE1NDID3ZzhV9+AHBnCXsZ/46LU0KSmo/Z9cFhBoTU5B72TEoaX6iXPxl
 NxGb5B0nVDsaPJtpHo4ISbBUYM5/ya/Y6PRhQCkskMOQCCwb/GBOyB04IE81y/hnpEWGr9u/p
 PRT8rerOW4gFQ2o0C9jsVYHPIrdNh6//BgcB3w5uLIkEwYgoln8sUESiAuLF1cL/1aCOU42sN
 i/G3wtsplrdoh8SMjz7zTRuA8joa/23T5EMv8QP7lNWj/9flVkl7kUbP/A6maq/VeEp7gxXCi
 vPh32cTFHFSPvCtKJ/SKFGHyf2gdYTnKnkF1gYFYJd64MTVxaQFEyyHuuFrGfLWpfWw1O21nD
 bGxK740+sCMwX/1UOBmbmNASuHcf6KrhFe0EBy8Nu4xdH7FV5Nl3NKhNWMdphEEY5o5nsHiNV
 CvRDfrGfh0Z+v3iYKMavD/s7yK3wl+t7AX/uLq5E4rgqjm4I8hx8Z7+BR1YBXSbeHlcnlnN4Q
 ftwAlju170gnmQ1/gc91jRABeRe9dSrT41hb9ZoVNUOH0kGMdJz4UVhwQ95Et/N1ywca1AwkC
 zH6bDKUIR38fzwMGMnsVaQHMaRUrDrGHh8homJLZW92nGvk67WUJSFMVrznARG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xXoUt9ioLUEMX7rpa4GaV0dIAJfDohlwu
Content-Type: multipart/mixed; boundary="ekVytotctBTYXd3tvdkXlpyrZeCKcwWgZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <ca181438-0d34-6b97-8659-ed77bef02e51@gmx.com>
Subject: Re: [PATCH v4 0/4] btrfs: Refactor find_free_extent()
References: <20181017065606.8707-1-wqu@suse.com>
 <20181101185406.GV9136@twin.jikos.cz>
In-Reply-To: <20181101185406.GV9136@twin.jikos.cz>

--ekVytotctBTYXd3tvdkXlpyrZeCKcwWgZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/2 =E4=B8=8A=E5=8D=882:54, David Sterba wrote:
> On Wed, Oct 17, 2018 at 02:56:02PM +0800, Qu Wenruo wrote:
>> Can be fetched from github:
>> https://github.com/adam900710/linux/tree/refactor_find_free_extent
>=20
> Can you please rebase it again, on top of current misc-4.20? Ie. the 2n=
d
> pull request. There were some fixes to the space infos, a new variable
> added to find_free_extent (conflict in the 1st patch) that was easy to
> fix, but further patches move code around and it was not a simple copy
> as the variable would probably need to be added to the free space ctl.
>=20
> This is a change beyond the level I'm confident doing during reabses an=
d
> don't want to introduce a bug to your code. This should be the last
> rebase of this series. Things that are ready will go from topic branche=
s
> to misc-next after rc1 is out. Thanks for the help.

No problem at all.

Will sent out soon.

Thanks,
Qu


--ekVytotctBTYXd3tvdkXlpyrZeCKcwWgZ--

--xXoUt9ioLUEMX7rpa4GaV0dIAJfDohlwu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvbkTEACgkQwj2R86El
/qhiZAgAmr2OkIT4Z0+tjl+DmLsX7syXSsVz7//iB/9SmSSwJkSs7LVtpo9rxcts
YrjT8M1y0DKCAWH/Sf3g46wWVIquro/vymZDaPoR2sgN5o14gtLIHhkJED9Wt2+a
ttdHjvxqU7mrybj06GDpSC0a5lGRiy2FtGR8aRpeCM12RmzE9ZppG15TZnkm2gYO
3imjsC64HLxneINo+sAcy1D/c0ouLE2vI7DJB9mqxfw/7RsYLrD1uS4VLA+XZXpP
UdisCQ9bLtiCdvLdp0L/73PXxisRcLmfQUfwoFr+REl8AuBeUbwjWAQ2J2uYGmH8
ypGj+GAbv464XbBFHk86bhHoYSGfBw==
=KUEe
-----END PGP SIGNATURE-----

--xXoUt9ioLUEMX7rpa4GaV0dIAJfDohlwu--
