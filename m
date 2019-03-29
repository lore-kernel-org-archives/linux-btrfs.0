Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209FDC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 14:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7494206C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 14:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Atwu39he"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfC2OSs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:18:48 -0400
Received: from mout.gmx.net ([212.227.17.22]:47825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbfC2OSs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 10:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553869118;
        bh=9xSgwju+FsAZE3Ic84E6E92nTBbN9y6VFqx03zbTPtw=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Atwu39heQZlv0fld2aMfiz9Yx9c3/C/730q1BYRQrz9z8Z23GU9sFgpMOw0Z+dmyr
         HuEa7rGklJsZCLA5MTzjhONs8j8xsSjCZuHmRhvzE323MwTJmtpxPQOiiVVZuZd2/8
         kueQqeCbzYgSqtLfINOuNDLZBMBhV7mgAYp9Ykf4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lb90f-1ghe7Q1JYf-00kfoF; Fri, 29
 Mar 2019 15:18:38 +0100
Subject: Re: [PATCH v5.3 02/11] btrfs: disk-io: Show the timing of corrupted
 tree block explicitly
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-3-wqu@suse.com> <20190329141107.GT29086@twin.jikos.cz>
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
Message-ID: <5cb2fc80-973d-3277-3be5-870d2acdfdce@gmx.com>
Date:   Fri, 29 Mar 2019 22:18:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190329141107.GT29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:p/pbw4DlxuKyNUAubgae9kADRlLsGF79hV0wMU2vwkqw7j/J+Ej
 Cnr6VxndyjR7iy4Dg8gTE/XvztqyYrzwHKI5l0LSYp0qbyS+jStcauf0tdCeD9LntnD/yTb
 Zgcd1F5xm242PZqyhFZNPo7Kyei/f+B3O+2L4+rylOjxC+Dd4eTJJltx7wcWB31ctdZ4jxt
 5/3eNfH0iZh1JcHIr7vmA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YBmaLiqYaLg=:fb4n+ekWKisOZ/FuH9jVL9
 zGwvf9729cJkJ1T5K8mKaXzCq2m8rPqsJidrrMd9qtvU4VyJf10o6fyo8ekueJ+/DPeBBbA4p
 p+ZBnmgZNHHADeT0gaqIRAUNrrmRtWjrPp+B8pVqwceHgIb5Q5PpmV6/3MTkuvZChgABYiltw
 JzxzOx7iO1ps07TcucMccOqYFUp32BzoNsoYxxUDX8GsxzzbHY20v14fjUhgjIzhOWaD51LHS
 rXXL0ep36jQKaibwU7GjAvOY2bMkCHgXT3zGjYM6XQse/mrjcg5jOKEgpZsWhvaJcGUPMVopf
 t+3qqON/sBk5JNXGpR7OWjXz+mul5tubE0FZtAiBG8KnODUpPYMxbSyDsdXKEYQQUsRkPUZaV
 0kN9M210wyOCRP0PRJMdFBsA3fBP2koV6yl3f6E/UvXnsod9k3KRN/iBy3Vi3fjMN29W4S1RU
 F/ZXZgrvf6cKFOPNAVWG18JD6nxoJofcpfHSmnzonHtlciVWTA+6/oJZavlruK0UpTt7m6C0x
 gZC5vtzWUFCXofbeTj+tRRpUbULtwTLs3svHl/6QuWs+0Y79kHBO9sVx8l99fZ9+oXM6QOdrl
 acI8DNY8u1RrhYeRFD8T0T8WPUvWV4RltPadMZKAnn/Jcsohy4jFepNNY7Rv8pwNMLj3nBBhM
 nXLSElOSPcStPdtDrJNWPMtmioqADo8XxD2lmhq7JcIO2ytB5fEw3WgmaMXmTMX2ZsW1JR2sh
 y5ugmyuSsG/29ON++tD0dQS8Rs/zpC1GOfvrxn4bqCLvqOGT6099u5VIXpFPdQXgcrI1i5Qh7
 QGLVDXVpv7Jc4S3txIEVeYf+JaOLeptte4W+vabiQvlwYYcy2WZmrrXobRRROdSyYbscnh81c
 L1CE9GfgvxH5pmikUXY+BEmHzaYI5Nbrm3PXAdcesuTTC5MT7VRXbBh2BUsN471u+XCEk+B3w
 D2toKr7xtrA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/29 =E4=B8=8B=E5=8D=8810:11, David Sterba wrote:
> On Wed, Mar 20, 2019 at 02:27:40PM +0800, Qu Wenruo wrote:
>> Just add one extra line to show when the corruption is detected.
>> Currently only read time detection is possible.
>>
>> The planned distinguish line would be:
>>   read time:
>>     <detail report>
>>     block=3DXXXXX read time tree block corruption detected
>>
>>   write time:
>>     <detail report>
>>     block=3DXXXXX write time tree block corruption detected
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> ---
>>  fs/btrfs/disk-io.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 6a7a1e168169..e8d4e238f832 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -659,6 +659,10 @@ static int btree_readpage_end_io_hook(struct btrfs=
_io_bio *io_bio,
>>
>>  	if (!ret)
>>  		set_extent_buffer_uptodate(eb);
>> +	else
>> +		btrfs_err(fs_info,
>> +			  "block=3D%llu read time tree block corruption detected",
>
> This showed up in test btrfs/124, the logs below do not contain the
> selftests outpt, that runs twice, only the last line is kept for
> reference. That's the only message from the read/write time checks, the =
branch
> is misc-next.
>
> [ 5432.522317] BTRFS: selftest: running extent_map tests
> [ 5432.573684] BTRFS: device fsid 519acff4-bdb4-4459-87b6-8f64ab1360cf d=
evid 1 transid 7 /dev/vdb
> [ 5432.578232] BTRFS info (device vdb): allowing degraded mounts
> [ 5432.579703] BTRFS info (device vdb): disk space caching is enabled
> [ 5432.581348] BTRFS info (device vdb): has skinny extents
> [ 5432.583483] BTRFS warning (device vdb): devid 2 uuid dc83669e-dff7-4d=
ee-bcc6-dbef1f470896 is missing
> [ 5432.586115] BTRFS warning (device vdb): devid 2 uuid dc83669e-dff7-4d=
ee-bcc6-dbef1f470896 is missing
> [ 5513.939435] BTRFS: device fsid af58e3f0-8011-4d2a-b2bd-fc956d458a75 d=
evid 1 transid 238 /dev/vda
> [ 5513.992006] BTRFS info (device vdb): disk space caching is enabled
> [ 5513.994398] BTRFS info (device vdb): has skinny extents
> [ 5514.022526] BTRFS critical (device vdb): corrupt leaf: root=3D7 block=
=3D30474240 slot=3D0, invalid nritems, have 0 should not be 0 for non-root=
 leaf

This is csum tree, which can be empty, but the old code I kept to do the
comprehensive owner check is not doing correct thing.

Considering it's doing replace, it maybe involved in relocation code.

Anyway, I'll investigate it and possibly remove the comprehensive owner
check, just using the owner checker for empty leaves.

Thanks,
Qu

> [ 5514.028271] BTRFS error (device vdb): block=3D30474240 read time tree=
 block corruption detected
> [ 5514.031529] BTRFS info (device vdb): read error corrected: ino 0 off =
30474240 (dev /dev/vdc sector 18560)
> [ 5514.034133] BTRFS info (device vdb): read error corrected: ino 0 off =
30478336 (dev /dev/vdc sector 18568)
> [ 5514.036662] BTRFS info (device vdb): read error corrected: ino 0 off =
30482432 (dev /dev/vdc sector 18576)
> [ 5514.039784] BTRFS info (device vdb): read error corrected: ino 0 off =
30486528 (dev /dev/vdc sector 18584)
> [ 5514.042383] BTRFS error (device vdb): bad tree block start, want 3221=
0944 have 651061555542690057
> [ 5514.044666] BTRFS info (device vdb): read error corrected: ino 0 off =
32210944 (dev /dev/vdc sector 21952)
> [ 5514.047146] BTRFS info (device vdb): read error corrected: ino 0 off =
32215040 (dev /dev/vdc sector 21960)
> [ 5514.049608] BTRFS info (device vdb): read error corrected: ino 0 off =
32219136 (dev /dev/vdc sector 21968)
> [ 5514.052034] BTRFS info (device vdb): read error corrected: ino 0 off =
32223232 (dev /dev/vdc sector 21976)
> [ 5514.056223] BTRFS error (device vdb): bad tree block start, want 3227=
6480 have 0
> [ 5514.058632] BTRFS info (device vdb): read error corrected: ino 0 off =
32276480 (dev /dev/vdc sector 22080)
> [ 5514.060448] BTRFS info (device vdb): read error corrected: ino 0 off =
32280576 (dev /dev/vdc sector 22088)
> [ 5514.064681] BTRFS info (device vdb): balance: start -d -m -s
> [ 5514.066309] BTRFS info (device vdb): relocating block group 247988224=
0 flags data
> [ 5514.068870] BTRFS error (device vdb): bad tree block start, want 3153=
9200 have 723401728380766730
> [ 5514.087183] BTRFS error (device vdb): bad tree block start, want 3145=
7280 have 578721382704613384
> [ 5514.087208] BTRFS error (device vdb): bad tree block start, want 3155=
5584 have 723401728380766730
> [ 5514.087244] BTRFS error (device vdb): bad tree block start, want 3152=
2816 have 723401728380766730
> [ 5514.107976] BTRFS error (device vdb): bad tree block start, want 3155=
5584 have 723401728380766730
> [ 5514.131715] BTRFS error (device vdb): bad tree block start, want 3144=
0896 have 506381209866536711
> [ 5514.131739] BTRFS error (device vdb): bad tree block start, want 3145=
7280 have 578721382704613384
> [ 5514.155830] BTRFS error (device vdb): bad tree block start, want 3145=
7280 have 578721382704613384
> [ 5527.886754] repair_io_failure: 54 callbacks suppressed
> [ 5527.886761] BTRFS info (device vdb): read error corrected: ino 0 off =
32145408 (dev /dev/vdc sector 21824)
> [ 5527.895976] BTRFS info (device vdb): read error corrected: ino 0 off =
32149504 (dev /dev/vdc sector 21832)
> [ 5527.899446] BTRFS info (device vdb): read error corrected: ino 0 off =
32153600 (dev /dev/vdc sector 21840)
>
