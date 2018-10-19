Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F4BECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 14:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81FB72064A
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 14:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81FB72064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbeJSW6b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 18:58:31 -0400
Received: from mout.gmx.net ([212.227.17.22]:37379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbeJSW6b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 18:58:31 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LejNC-1fqnZc0NQM-00qWHo; Fri, 19
 Oct 2018 16:51:56 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LejNC-1fqnZc0NQM-00qWHo; Fri, 19
 Oct 2018 16:51:56 +0200
Subject: Re: [PATCH 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181019134230.GH16290@twin.jikos.cz>
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
Message-ID: <c546fa75-00b8-a897-6656-3550a8367ab2@gmx.com>
Date:   Fri, 19 Oct 2018 22:51:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181019134230.GH16290@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uxfkvCSAXahOEd6zeWzpPPNfkVIlW1BJO"
X-Provags-ID: V03:K1:yWxyjc/Qj1ZgaSsmVqzQ1Nsix3tTA2qDXwG93h9o2+1QAUEwQNs
 4fHMLZV/AMEd3H7u27rRHuonUeOdbGjBfBNhCZdAenD0nZ35b39tPS08Aw9dPwsZXNmU7Ra
 wk50Owl/QhPydiCwdt2JW9GTWv24QaJZyXRiBvbfp1dv2E6dglMbpORrQTDGXYpqPsxoaQ2
 hGwe2ZHKTnQdXqznXyAhg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:tPgKKe2l+zM=:AD5Sc25h+Dq70tmrI/GRWJ
 WB83f7uY32Y0lQHMqURmDKumvIvxxs9lY865MLeoA1AS5f62Xs7g5e/4lEoSC2EvBUtL7u9tj
 9OwIQwSRvlkWTnoNajx27b1GpDvIL44NwQabEGEbe2ZAbBY1SwvaZR8I1sH0MPgerQYfIlFjA
 BENl8+tWYdkbAr6N93tJoiyaWvmq2ybao67PjMOPg1gVYamT7Tl+lsMClbFf4sCTKywU2Hklw
 v5drjhq0SYBTvE76XSxN6sTLzA5TJPnDATxfCFcJfYPjpz1LUj5BU/Pm9R2ZJu1w/Zm2Ddw37
 VZyoZdgjj8Py06WxP9losxd5zH68WjGQd37Cn7t8gzeEcAbdExwyxzinYqC+MUuHiL2strvjL
 L0wlVcCbOp3gnsP3mAsxFCpvygzjOLTJuoV1IOcJQeUZpgRD63ojqPEAY5lpF+tsGLNRp0/+p
 DpSFQq2p/DqISvo1oFPzie1i6iIbRu6s7js5iKAz4/ouv9+dQggpsCQkp7UTRNewTKVmNwUCt
 sy/RjJrks2WmgtV9wa8XqzjT8B8Kqs/mIU38IAfAx2+JzTC2tTH6L9tvSvxy6f+V6JSuSIGcM
 qDPb/pXXajMjmu+K/VfO0vf2r/hW8+ImaslPFCgeQbXQ2TtyB2LiWwMn3Ags8gI1OYYKSL1nb
 YRIxfg+rs3t5G4PLd48UMrhMMaz+K0uxKRAx3SRgBpWfzJZF8uy2GeJeqP3gg9sqWzTqjThFK
 N0ogsLABEt3OYUw4cMbpB7GRKAvAbGAPjww4D54F8bdtQhhEmgtMicaVaS2IrONpaQrknpkJl
 mWpwptVVoKLEA/ruApuM8EWcJM+TQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uxfkvCSAXahOEd6zeWzpPPNfkVIlW1BJO
Content-Type: multipart/mixed; boundary="gR5PNs2UbTbYu3hDbnm8Yro3ExuFRGKB1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c546fa75-00b8-a897-6656-3550a8367ab2@gmx.com>
Subject: Re: [PATCH 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
References: <20181018111729.11128-1-wqu@suse.com>
 <20181019134230.GH16290@twin.jikos.cz>
In-Reply-To: <20181019134230.GH16290@twin.jikos.cz>

--gR5PNs2UbTbYu3hDbnm8Yro3ExuFRGKB1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/19 =E4=B8=8B=E5=8D=889:42, David Sterba wrote:
> On Thu, Oct 18, 2018 at 07:17:23PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
>>
>> Which is still based on v4.19-rc1, but with previous submitted patches=

>> as dependency.
>=20
> Please rebase this patchset on top of misc-4.20, this should not change=

> as it's going to be the 1st pull.
>=20
> I tried to pull the git branch and rebase but there were several
> conflicts and some of the paches appeared duplicated so the rebase did
> not recognize the changes as identical.
>=20
> Applying patches from mails causes other sort of conflicts and I can't
> seem to get a compilable version.
>=20
> This is not urgent as I want to put the patchset to a topic branch and
> give it some testing before it goes to for-next. Thanks.

Current patchset (still using while(rb_first()) for cleanup
swapped_blocks) rebased to misc-4.20.
With all checkpatch errors fixed.

The branch is:
https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_rebased

Please note that this is only for test purpose.
Due to explained reasons, I don't really think it should go misc-next
right now.

Thanks,
Qu


--gR5PNs2UbTbYu3hDbnm8Yro3ExuFRGKB1--

--uxfkvCSAXahOEd6zeWzpPPNfkVIlW1BJO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvJ74MACgkQwj2R86El
/qh6ewf+IRFDFIuNIYnrxYGqMzuEuTkQ3ZhrUMAeJb+Tz/gH/XcHWPqy4K92BzBe
Osqnrh+3JS0ESzAFbdxQ1cOsoZnYEvfPLm0ZvtLDsOjA2GyxvOOTcWrObt9i03an
XIAR3jfrN4B6601DFsrmWc+Githk4KpQZJgPf4eDYwbMqXxA/5awbQQIhN4KqniN
6WBupXTAyXEgLM1CDRhb4hxHzG1v56Z5skoq9yfoaht2uPqcO27STm2aKWcDXuuB
Oj7yHq6VIIy0jVxSSdO6658XKazyGOhlVUXDYmDtTDvQ4jKBgeFW1Xiv2cyTa+KS
m2YhrtJEmXjLOr9jI4d/OdC56iaShA==
=alX+
-----END PGP SIGNATURE-----

--uxfkvCSAXahOEd6zeWzpPPNfkVIlW1BJO--
