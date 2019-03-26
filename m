Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4591C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 13:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721BC2075C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 13:40:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BK0s1gdr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbfCZNkY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:40:24 -0400
Received: from mout.gmx.net ([212.227.17.22]:46341 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZNkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 09:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553607614;
        bh=FP9kwI0ssc0pOWjOEjWk2CD1+C5YQhqmz8DrFvCOsu8=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=BK0s1gdrAKTRGfom8qW0MgAPD1JC8vpMfQfLVbLKihrq2Al1R1lgG0TYL5l1Zup7j
         eLcvlgs+ZQqoVcTogLK1rXMvvaJYd1uKT498RrgI9SN4mZIh+FdJsTevEl3jY+2+u7
         tOJvjNZ8Oc//lrUivU7IrdnSudxOlfoxZKfMWp7U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LmeGF-1gZRIE2VP9-00aF7u; Tue, 26
 Mar 2019 14:40:14 +0100
Subject: Re: [PATCH] Btrfs: do not allow trimming when a fs is mounted with
 the nologreplay option
To:     Nikolay Borisov <nborisov@suse.com>, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190326104956.10314-1-fdmanana@kernel.org>
 <d828e591-22f6-faf2-76ec-1f52397ba858@suse.com>
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
Message-ID: <dbf7aa7b-3ea8-e5da-eb8f-746cbc5e4487@gmx.com>
Date:   Tue, 26 Mar 2019 21:40:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <d828e591-22f6-faf2-76ec-1f52397ba858@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tzaK31S0OZ5/ro6qv3idNOyqXxJVylWGXWGBtNPyh06lka5Y5rl
 N5ZAgxiHVtUqyQRauVtW7sYaLR9WC/gGs2BzlwJzycEoJ6IW6dfMalG4BIkPuLHcGN1C/xg
 Rc4p5zA/3Tf80+bBFdFdUwy6U6MEaLo8TQzvfRnuwf8PwIxZIwX40I5ye1cC+YYfDMe28sx
 7d3ov/JSEkkp+ObQv2SjA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:h/TGy03gb1s=:RrTPKQdW90+eApFfRqLWSK
 0y754LD8HOHS3g58DvP69lfR7Vy9XWMeo7eDa8SwUXyjZc5acjiTYcBdBGeR9+O2Ol0rvaF3M
 mZyz1hrs7DZIar3aUHCz08aQHlxh6XYeeVB6ImM6QcXs+ioZsqwZxD6SFg0JqiSY9o3dHI9dZ
 Om68iGpF/oJLXt5fgPKDEYNloBS5kAqrhwC2xEwudLqgHTtL5YIpXzBYcu7Gt8LKl6GqBJ9ks
 MTLyEwXjRiiP+oZGhbKjbl+J4X8BDxnsSkUkoas6miZDbrKw8mqPnj0v10PyvYbb2AjGKD/BO
 t3JBolg6cYmftt15mxu1qDCUftZ+r/ozIaoxpBtI+h2qoJ0FnHvS8eCvGRPFtASrCPDkp9tde
 /d3lgnzZE18vOlMktt59Jkg0ETqdP91zOR4rNsEaCfab8rts0vzj5uZYpNq/9VGM7s1H+w1iY
 +RQbvHXah5YoB/vklvcsaX5MfG0/6C+xDyAipTGj+WdQ6VtpYSCp9gvntgMceE49dbVg+klUf
 c5BKvYEXiYoA9KScJu2nUsK14u87EDSq3hQVCHc93uK7x8DJ15aNViNAQHtLmLrls3WV7hRuG
 TXzDuBzG9+v8pS+cwgLY3cjShyVyZB8bc3upheZBAj7NZCceLd64daAFFtBwjayYoh2msEnTE
 pagP0J20/TKJg5JP+1WRtLAfMwg3DRoI+y2Hwq40Swc/CkrrSMbPkCzjvb64LOqzAzNPduBaM
 pkwMvdJAMr3SOyePygyGNmokJubaNo73+WK6TzIzN1IbUxVvUhtNMtEkmj+jD6TOaP6mrNdOF
 ibf/P9s+3dP07gwUjJG6lPSzamaUatlgIW8HTnEy3thVXBoyy8Cf9sa9AcQr66Y4os3MzG3pw
 1TaGCJZY+0YulNdRl5BLIXHjsrus48h0LAht/UxD6K8Nh3Vmt1S+vjHPwsDG3HFEEa9sQK//S
 Ij9LNgGdF7Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/26 =E4=B8=8B=E5=8D=888:17, Nikolay Borisov wrote:
>
>
> On 26.03.19 =D0=B3. 12:49 =D1=87., fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Whan a filesystem is mounted with the nologreplay mount option, which
>> requires it to be mounted in RO mode as well, we can not allow discard =
on
>> free space inside block groups, because log trees refer to extents that
>> are not pinned in a block group's free space cache (pinning the extents=
 is
>> precisely the first phase of replaying a log tree).
>>
>> So do not allow the fitrim ioctl to do anything when the filesystem is
>> mounted with the nologreplay option, because later it can be mounted RW
>> without that option, which causes log replay to happen and result in
>> either a failure to replay the log trees (leading to a mount failure), =
a
>> crash or some silent corruption.
>>
>> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Does it make sense to make the check a bit more specific and only return
> EROFS when NOLOGREPLAY and the log tree has non-null generation?

To me fstrim is a WRITE operation, why it is allowed even in RO mount?

Thanks,
Qu

>
> In any case:
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
>> ---
>>  fs/btrfs/ioctl.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 494f0f10d70e..01808934d21f 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -501,6 +501,16 @@ static noinline int btrfs_ioctl_fitrim(struct file=
 *file, void __user *arg)
>>  	if (!capable(CAP_SYS_ADMIN))
>>  		return -EPERM;
>>
>> +	/*
>> +	 * If the fs is mounted with nologreplay, which requires it to be
>> +	 * mounted in RO mode as well, we can not allow discard on free space
>> +	 * inside block groups, because log trees refer to extents that are n=
ot
>> +	 * pinned in a block group's free space cache (pinning the extents is
>> +	 * precisely the first phase of replaying a log tree).
>> +	 */
>> +	if (btrfs_test_opt(fs_info, NOLOGREPLAY))
>> +		return -EROFS;
>> +
>>  	rcu_read_lock();
>>  	list_for_each_entry_rcu(device, &fs_info->fs_devices->devices,
>>  				dev_list) {
>>
