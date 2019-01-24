Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2C3C282C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 00:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BE68218A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 00:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbfAXAIh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 19:08:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:60818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbfAXAIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 19:08:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3BFFAAFB8
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2019 00:08:35 +0000 (UTC)
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190118021956.22949-1-wqu@suse.com>
 <20190123171635.GU2900@twin.jikos.cz>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <cc945559-a965-d1d7-6c3f-c91169496be6@suse.de>
Date:   Thu, 24 Jan 2019 08:08:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190123171635.GU2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Z2MvhbgoGFbQkCCr8M1zN4YUb7t6TatSi"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Z2MvhbgoGFbQkCCr8M1zN4YUb7t6TatSi
Content-Type: multipart/mixed; boundary="AS2UWXIq9HQV20MzhwosL82O1XJHFIxRN";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <cc945559-a965-d1d7-6c3f-c91169496be6@suse.de>
Subject: Re: [PATCH v3 0/5] btrfs: Enhancement to tree block validation
References: <20190118021956.22949-1-wqu@suse.com>
 <20190123171635.GU2900@twin.jikos.cz>
In-Reply-To: <20190123171635.GU2900@twin.jikos.cz>

--AS2UWXIq9HQV20MzhwosL82O1XJHFIxRN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/24 =E4=B8=8A=E5=8D=881:16, David Sterba wrote:
> On Fri, Jan 18, 2019 at 10:19:51AM +0800, Qu Wenruo wrote:
>> Patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>> Which is based on v5.0-rc1 tag.
>>
>> This patchset has the following two features:
>> - Tree block validation output enhancement
>>   * Output validation failure timing (write time or read time)
>>   * Always output tree block level/key mismatch error message
>>     This part is already submitted and reviewed.
>>
>> - Write time tree block validation check
>>   To catch memory corruption either from hardware or kernel.
>>   Example output would be:
>>
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detect=
ed
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): write time tree block corruption detect=
ed
>>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=
=3D-5 IO failure (Error while writing out transaction)
>>     BTRFS info (device dm-3): forced readonly
>>     BTRFS warning (device dm-3): Skipping commit of aborted transactio=
n.
>>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=3D-5=
 IO failure
>>     BTRFS info (device dm-3): delayed_refs has NO entry
>=20
> Two tests complain:
>=20
> btrfs/139
> [ 7064.718943] run fstests btrfs/139 at 2019-01-23 15:56:29
> [ 7065.345503] BTRFS info (device vda): disk space caching is enabled
> [ 7065.347577] BTRFS info (device vda): has skinny extents
> [ 7065.666692] BTRFS: device fsid bc4c99e7-906a-44fd-b797-66eb7c9592d7 =
devid 1 transid 5 /dev/vdb
> [ 7065.684618] BTRFS info (device vdb): disk space caching is enabled
> [ 7065.687310] BTRFS info (device vdb): has skinny extents
> [ 7065.688887] BTRFS info (device vdb): flagging fs with big metadata f=
eature
> [ 7065.693432] BTRFS info (device vdb): checking UUID tree
> [ 7065.743019] BTRFS warning (device vdb): qgroup rescan is already in =
progress
> [ 7065.746433] BTRFS info (device vdb): qgroup scan completed (inconsis=
tency flag cleared)
> [ 7075.359872] BTRFS critical (device vdb): corrupt leaf: root=3D7 bloc=
k=3D31653888 slot=3D0, invalid nritems, have 0 should not be 0 for non-ro=
ot leaf
> [ 7075.363155] BTRFS error (device vdb): write time tree block corrupti=
on detected

This looks strange.

In commit transaction time, we should be able to get correct csum root
node, but it obviously still didn't detect it correctly.

I'll address it.

Thanks,
Qu

> [ 7077.578167] BTRFS: error (device vdb) in btrfs_commit_transaction:22=
20: errno=3D-5 IO failure (Error while writing out transaction)
> [ 7077.583615] BTRFS info (device vdb): forced readonly
> [ 7077.585797] BTRFS warning (device vdb): Skipping commit of aborted t=
ransaction.
> [ 7077.588813] BTRFS: error (device vdb) in cleanup_transaction:1839: e=
rrno=3D-5 IO failure
>=20
> generic/344
>=20
> [11246.567119] run fstests generic/344 at 2019-01-23 17:06:11
> [11246.652295] BTRFS info (device vda): disk space caching is enabled
> [11246.654434] BTRFS info (device vda): has skinny extents
> [11246.730069] BTRFS: device fsid b82bc1cd-b380-4eff-a40a-1924c3bf0580 =
devid 1 transid 5 /dev/vdb
> [11246.740955] BTRFS info (device vdb): disk space caching is enabled
> [11246.742694] BTRFS info (device vdb): has skinny extents
> [11246.744173] BTRFS info (device vdb): flagging fs with big metadata f=
eature
> [11246.772934] BTRFS info (device vdb): checking UUID tree
> [11300.857850] BTRFS critical (device vdb): corrupt leaf: root=3D7 bloc=
k=3D31080448 slot=3D0, invalid nritems, have 0 should not be 0 for non-ro=
ot leaf
> [11300.861739] BTRFS error (device vdb): write time tree block corrupti=
on detected
> [11300.864232] BTRFS: error (device vdb) in btrfs_commit_transaction:22=
20: errno=3D-5 IO failure (Error while writing out transaction)
> [11300.867704] BTRFS info (device vdb): forced readonly
> [11300.869355] BTRFS warning (device vdb): Skipping commit of aborted t=
ransaction.
> [11300.871857] BTRFS: error (device vdb) in cleanup_transaction:1839: e=
rrno=3D-5 IO failure
> [11300.874292] BTRFS info (device vdb): delayed_refs has NO entry
> [11301.261978] BTRFS info (device vdb): disk space caching is enabled
> [11301.264639] BTRFS info (device vdb): has skinny extents
> [11301.266467] BTRFS info (device vdb): flagging fs with big metadata f=
eature
> [11301.299713] BTRFS info (device vdb): checking UUID tree
>  [17:07:06]- output mismatch (see /tmp/fstests/results//generic/344.out=
=2Ebad)
>     --- tests/generic/344.out   2018-04-12 16:57:00.652225551 +0000
>     +++ /tmp/fstests/results//generic/344.out.bad       2019-01-23 17:0=
7:06.424000000 +0000
>     @@ -17,6 +17,7 @@
>      INFO: thread 0 created
>      INFO: thread 1 created
>      INFO: 0 error(s) detected
>     +unlink(): Read-only file system
>=20
>      INFO: zero-filled test...
>      INFO: sz =3D 268435456
>     ...
>     (Run 'diff -u /tmp/fstests/tests/generic/344.out /tmp/fstests/resul=
ts//generic/344.out.bad'  to see the entire diff)
>=20


--AS2UWXIq9HQV20MzhwosL82O1XJHFIxRN--

--Z2MvhbgoGFbQkCCr8M1zN4YUb7t6TatSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxJAf8ACgkQwj2R86El
/qiu6Qf/TBo89ZDqsd6Y67UGKmBcktK++JqBnISvH+2oW7W7117ZMB8rspomxh8x
7ki0OzkSWd95xX+7e8Rv7z5Vm0a2FkqD710DG7byJ0kYiQQ+9EqrWYKsvmDsb1Y9
EUo0+YHZEJrYnXMFN/wjVeusF/h30uOv6/wZiCMrgDSS1gxMkVYyj8p+C+JqjWIO
BrEKUaWoo8PYAfz20UI4MZOzrk9OxCTzvQCP9O13DH21mrnUjQFb6g24h7NNLz/J
O4/SLJ2kLZ2/NxO27R4j55EP0JiOhGizSY34XKYoMs4BJzGIs4mjyCn2O4g3Ln+m
dkOPYDSco0DDWxbaXe9/M3GHEdbmbg==
=ohY9
-----END PGP SIGNATURE-----

--Z2MvhbgoGFbQkCCr8M1zN4YUb7t6TatSi--
