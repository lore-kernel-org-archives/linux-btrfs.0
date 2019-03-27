Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDCFC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 09:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A912C2075C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 09:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="LLSo+Y0T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfC0JWF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:22:05 -0400
Received: from mout.gmx.net ([212.227.15.18]:37363 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfC0JWF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 05:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553678518;
        bh=+fuiC7VazQbKlrinTtJuQld6kef3rIY89ZTRVYx/i+4=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=LLSo+Y0Tmi7zmNGh135FVinqlz6KMHPTWU9p7np943GWpJVnvsxHv23KOigbBWM7X
         vCew5iMDZq49ttaDo+x55SuucI5s+dwCjAZ4JQwp/wqnwdQNzHp3i5p/Elbt2ZtJic
         vXEvCMY4nXsP8eiVLR2skwuiNkGUzi9AHWbjkeEo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lxxrw-1gx6Ia39We-015LCp; Wed, 27
 Mar 2019 10:21:58 +0100
Subject: Re: [PATCH URGENT 2/2] btrfs-progs: disk-io: Flush to ensure super
 block write is FUA
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327072500.11156-1-wqu@suse.com>
 <20190327072500.11156-3-wqu@suse.com>
 <dbab7606-3327-2ccb-5383-885818218fee@suse.com>
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
Message-ID: <5cca58ac-fbec-2220-2494-2f03849f8d86@gmx.com>
Date:   Wed, 27 Mar 2019 17:21:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <dbab7606-3327-2ccb-5383-885818218fee@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:K4J8oDW0ZnbBK0KEmx9LovjQ3mSCC2GP1yjr+MmJu9ND8Mwc2C+
 rBpGV7DcLC5wTGtyhhkbAC3dieWEtPOxe268EjxJ8oflEqY7zi9IDlt7yLJ309a1gldwTij
 ygdDhp5MhOLKZ3cpt5wmxOw+ZfGMJDOW0RPD85falZDoWKLc80Di4VQGVKYF8mPCYinkjRS
 5wo/MtU5qMxujrhhndPXQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2273whMUXLs=:9pgqHAP6sIhqAFZ7iBtyYE
 Cx/JiI4JJn7VeQ8M7+sWQtKLJwelVdoHNo6TmabHvQl7WOAtAFTS+TFuZ4oJ/ZP1Oxd3IaAEy
 5HfRUaa3o6Bho3c6cLBFI/LcFU/NVFSqgLjbGNduV3IglyFTqsRISgRuorrHK/YrrQbSN8INM
 1o8mjod7WP68XXZ/ebRaij1aJG3rwBMd4pG8f21FFoMcTlx3sg7X24A5aIwDc+4XUuYTCvW7S
 d+9X8Nzb/0wrmSP2jhOotUWKM8KZjwTlguykBa8V0HoIfY/RMQL5B8VtjLL4LxlyltVPLuDoR
 3nItqYNjMJlsV0FxiuhoWdu9HNixcqJ/LmOMRsOwBSpN0w0GkA2mS7PgyEOioseD6hnmJqOZu
 Y7qW3m3NVf8/XFyx5iGTZ0rpq8l7Sz0MwAf79IdI3aFFXc0KYf7d7t1du/lrjJEKWDmMdvGbH
 T9uahN9wPSj4xyih0u57EjgCrgKdvjT8xXWZjHaUBmzXaZTquYufU9YmxKUmuLxkh85gdlB6y
 CfHmY8ZVWpgMDST3UWuOId50neGKU6xwUvDMtxUwfi+AnQXJsdWh7MGGFVgnhpSfojd3qtabm
 uekHcALhE9AuIxPJyIzWSdMPAxw9C7VustnHWz4p3XwOWqlIsYQKk+IFfgR6/gQIdY0c2nhzA
 OZoa+JVybwmXjknTCZdGQO2a80LKoxTULWmjwAiQFKqVi4AuQbMUMC0kg96+BA3v1MP6kQNf9
 DJjzOcwdCaHooONrJfn0eItVE97+t+AXAglnOml5Uy1Fql0CCnvg5fpWTpcpRZRvLgZexiruy
 T67E7d9FLWCngVL5tGxVOrhzZAMNzboZogmjHqVkWLIkxVtV1Cvh+yQrqsn+awwmwoG1kgI75
 CVpG+la5tTcrf8xU25WdYOAa/8uZJ/6TIaeMRVgvKTIFKLXCiNA06iV6jf6xkvStYLuAkkXtH
 jvCjS2z1YLA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/27 =E4=B8=8B=E5=8D=884:37, Nikolay Borisov wrote:
>
>
> On 27.03.19 =D0=B3. 9:25 =D1=87., Qu Wenruo wrote:
>> [BUG]
>> There are tons of reports of btrfs-progs screwing up the fs, the most
>> recent one is "btrfs check --clear-space-cache v1" triggered BUG_ON()
>> and then leaving the fs with transid mismatch problem.
>>
>> [CAUSE]
>> In kernel, we have block layer handing the flush work, even on devices
>> without FUA support (like most SATA device using default libata
>> settings), kernel handles FUA write by flushing the device, then normal
>> write, and finish it with another flush.
>>
>> The pre-flush, write, post-flush works pretty well to implement FUA
>> write.
>>
>> However in btrfs-progs we just use pwrite(), there is nothing keeping
>> the write order.
>
> This could be expanded to include the following information:
>
> 1. The device fs is opened with only O_RD or O_RDWR i.e we don't pass
> any special arguments when opening the fd.

In fact you can pass O_SYNC to solve the problem, but with possible
performance penalty.

In fact, the fsync() call here is completely compatible with any open
flag except O_RDONLY.

So I'm not sure why extra comment on this is needed.

>
> 2. We do not use fsync anywhere

Even we use, it won't cause any problem.

Here we only need to ensure one barrier for super block, if another part
of btrfs-progs wants an extra barrier, it's completely fine to do so.

So I don't see much point to explain both points.

>
>>
>> So even for basic v1 free space cache clearing, we have different visio=
n
>> on the write sequence from kernel bio layer (by dm-log-writes) and user
>> space pwrite() calls.
>>
>> In btrfs-progs, with extra debug output in write_tree_block() and
>> write_dev_supers(), we can see btrfs-progs follows the right write
>> sequence:
>>
>>   Opening filesystem to check...
>>   Checking filesystem on /dev/mapper/log
>>   UUID: 3feb3c8b-4eb3-42f3-8e9c-0af22dd58ecf
>>   write tree block start=3D1708130304 gen=3D39
>>   write tree block start=3D1708146688 gen=3D39
>>   write tree block start=3D1708163072 gen=3D39
>>   write super devid=3D1 gen=3D39
>>   write tree block start=3D1708179456 gen=3D40
>>   write tree block start=3D1708195840 gen=3D40
>>   write super devid=3D1 gen=3D40
>>   write tree block start=3D1708130304 gen=3D41
>>   write tree block start=3D1708146688 gen=3D41
>>   write tree block start=3D1708228608 gen=3D41
>>   write super devid=3D1 gen=3D41
>>   write tree block start=3D1708163072 gen=3D42
>>   write tree block start=3D1708179456 gen=3D42
>>   write super devid=3D1 gen=3D42
>>   write tree block start=3D1708130304 gen=3D43
>>   write tree block start=3D1708146688 gen=3D43
>>   write super devid=3D1 gen=3D43
>>   Free space cache cleared
>>
>> But from dm-log-writes, the bio sequence is a different story:
>>
>>   replaying 1742: sector 131072, size 4096, flags 0(NONE)
>>   replaying 1743: sector 128, size 4096, flags 0(NONE) <<< Only one sb =
write
>>   replaying 1744: sector 2828480, size 4096, flags 0(NONE)
>>   replaying 1745: sector 2828488, size 4096, flags 0(NONE)
>>   replaying 1746: sector 2828496, size 4096, flags 0(NONE)
>>   replaying 1787: sector 2304120, size 4096, flags 0(NONE)
>>   ......
>>   replaying 1790: sector 2304144, size 4096, flags 0(NONE)
>>   replaying 1791: sector 2304152, size 4096, flags 0(NONE)
>>   replaying 1792: sector 0, size 0, flags 8(MARK)
>>
>> During the free space cache clearing, we committed 3 transaction but
>> dm-log-write only caught one super block write.
>>
>> This means all the 3 writes were merged into the last super block write=
.
>> And the super block write was the 2nd write, before all tree block
>> writes, completely screwing up the metadata CoW protection.
>>
>> No wonder crashed btrfs-progs can make things worse.
>>
>> [FIX]
>> Fix this super serious problem by implementing pre and post flush for
>> the primary super block in btrfs-progs.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
>> ---
>>  disk-io.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index 238b1821be14..275ccff965e2 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -1585,6 +1585,16 @@ static int write_dev_supers(struct btrfs_fs_info=
 *fs_info,
>>  	u32 crc;
>>  	int i, ret;
>>
>> +	/*
>> +	 * We need to write super block after all metadata written.
>> +	 * This is the equivalent of kernel pre-flush for FUA.
>> +	 */
>> +	ret =3D fsync(device->fd);
>> +	if (ret < 0) {
>> +		error("failed to flush: %m");
>> +		ret =3D -errno;
>> +		goto write_err;
>> +	}
>>  	if (fs_info->super_bytenr !=3D BTRFS_SUPER_INFO_OFFSET) {
>>  		btrfs_set_super_bytenr(sb, fs_info->super_bytenr);
>>  		crc =3D ~(u32)0;
>> @@ -1605,6 +1615,12 @@ static int write_dev_supers(struct btrfs_fs_info=
 *fs_info,
>>  			error("failed to write super block: %m");
>>  			goto write_err;
>>  		}
>> +		ret =3D fsync(device->fd);
>> +		if (ret < 0) {
>> +			error("failed to flush: %m");
>> +			ret =3D -errno;
>> +			goto write_err;
>> +		}
>>  		return 0;
>>  	}
>>
>> @@ -1632,6 +1648,18 @@ static int write_dev_supers(struct btrfs_fs_info=
 *fs_info,
>>  			error("failed to write super block %i: %m", i);
>>  			goto write_err;
>>  		}
>> +		/*
>> +		 * Flush after the primary sb write, this is the equivalent of
>> +		 * kernel post-flush for FUA write.
>> +		 */
>> +		if (i =3D=3D 0) {
>> +			ret =3D fsync(device->fd);
>> +			if (ret < 0) {
>> +				error("failed to flush: %m");
>> +				ret =3D -errno;
>> +				goto write_err;
>> +			}
>> +		}
>>  	}
>>
>>  	return 0;
>>
