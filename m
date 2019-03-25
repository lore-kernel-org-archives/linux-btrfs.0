Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1775C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B2DB20828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="VyqU6Mun"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbfCYXAV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:00:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:57721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfCYXAV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 19:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553554790;
        bh=zLVb/XsmpX6/5MtVYybGyClFTcLFVF8DK5Wbra9yb8M=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VyqU6MunUajmnE9pcgG+usqAy04NLo1/LtwSTYzHRxwNQdES4UAv8GhGL23dSlM1w
         3rhQ2KmLHSM/iUdp3RkzeFqDx8AiwBTh2HD2AqyFOu2JzY8V/9vgY5u0mHSYit/LVI
         YW/S5BAmlhkhvbG2HjRiSHxNMzAZBB3+YzvN8qGw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LpsmR-1gWS4A0sNj-00fmZM; Mon, 25
 Mar 2019 23:59:50 +0100
Subject: Re: [PATCH 2/7] btrfs-progs: check/original: Add inode mode check
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     Thorsten Hirsch <t.hirsch@web.de>
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-3-wqu@suse.com>
 <401e97ad-b1a3-fba7-94a0-3232055a85a9@suse.com>
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
Message-ID: <2f58316e-2278-9c37-821f-e081b5a706c2@gmx.com>
Date:   Tue, 26 Mar 2019 06:59:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <401e97ad-b1a3-fba7-94a0-3232055a85a9@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SKbHyqpcvonnDj9vgBuw6bSV0A0mAReuFeKbHANDajwRimRaTNx
 8nQeDvT081OnA4i2utXm7a+jIoZbNNrikqiGh+bNkuTUbeVqEeJE06NFIATwRZHJTk4Jdp0
 tD90M+zBwRd+iRbfbJq+SUIo6QGmiY5kImD2w2lhzHgFkpjGjCQ8jjmjG7XLIzuRI/iV7sJ
 C1kqQ8StnQhgf2CQta2QQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZVg6i9UdW9A=:92eFmsgW6/HMxBbpldI2oZ
 6yzRDedGcgnrrlPBDPYlxE9R8ue43h2vFLkH3JtheZstXkX3BfaoIK78JNVNFs2ayoeUUTLxH
 Nrqx0w/AwK6+iiska3Mdq/bEipdEbDAkLG+f0KfO2ps8XqToVfq6Zfwljo0IcxEjNnLHtOfnb
 TZqQEvJJit2uNEB6bDx98sb+QU6E1R3+jSUbw7vmU6vhFa4Qa0rTupsT9u5nKk1ht73QjKthx
 e615vpIO9xgeeuQWSi+cDDi3Tf3XkH1JT+yK08+ZEN/82lele5fkYjeXtHxvZig1+kEn37hC3
 T/es4Ygz/NaJ33deHv956pP6A2k50wpKzcNlSlorskzN4Zc4bbgafogPymkfOdcci98lhVzXc
 B9Sz3XcpRWf0q58k7pUh8OoIXyQTqveJ25dNrK8XgVEkMPL7ks4NCEvd4r6SKICbnsF0CgBA3
 +AWpCMPWMBHXZRdMubfNduhxgV2r21xZGz/orjR3tAvs985D/A8oIqT5t2GNx72SbQ2xCzTxv
 WWTV+V5sF4BvL8YYpzB8HgWtIwmlrFb9IaJXmVhu4zKcXoK0DoiejVWXOo/K6VOGKLb2bj5Dq
 CybX3tCSR/qqhJzQ3I/i/3yJ7z2+zTuXkChcvpz32lrru0QrbluUZzdsyZqaryX/doKksaQxl
 njMIfk8mQclk1C7dHmBwxiioPQ/ap87JAueVdfijuf10HEfmkjE0vj8+IGFVxIXO4BEEMaBfh
 fv+em1jJxi3vOMikZDu+RXH2ryNAQnGB9rjxD+Otj963TH4KdqXnItIzPJr8SfCOJQNFD13oo
 zIEd8VW7lRLiaGUr1T5eHh/MlkWWOGRkAXIOzNHjT5ZfVkZJ4ADAaqN3i5E2NXbJ/sbW7/Wet
 PyukP1Kssl1QMk9Ru9+CAPO2H82EKJGCDPCcQhywR5pmm7YOPxWiNWrMtI/uMyZE3OZTsixdd
 qFQvlqYoFpw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/25 =E4=B8=8B=E5=8D=8811:43, Nikolay Borisov wrote:
>
>
> On 25.03.19 =D0=B3. 10:22 =D1=87., Qu Wenruo wrote:
>> Just like lowmem mode, check inode mode, specially for S_IFMT bits and
>> beyond.
>>
>> Please note that, this check only applies to inodes in fs/subvol trees.
>> It doesn't apply to free space cache inodes.
>>
>> Reported-by: Thorsten Hirsch <t.hirsch@web.de>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/main.c          | 5 +++++
>>  check/mode-original.h | 1 +
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 7547209c5604..553c93caa2c9 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -616,6 +616,9 @@ static void print_inode_error(struct btrfs_root *ro=
ot, struct inode_record *rec)
>>  		fprintf(stderr, ", odd inode flags");
>>  	if (errors & I_ERR_INLINE_RAM_BYTES_WRONG)
>>  		fprintf(stderr, ", invalid inline ram bytes");
>> +	if (errors & I_ERR_INVALID_IMODE)
>> +		fprintf(stderr, ", invalid inode mode bit 0%o",
>> +			rec->imode & ~07777);
>>  	fprintf(stderr, "\n");
>>  	/* Print the orphan extents if needed */
>>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>> @@ -811,6 +814,8 @@ static void maybe_free_inode_rec(struct cache_tree =
*inode_cache,
>>  	if (!rec->checked || rec->merging)
>>  		return;
>>
>> +	if (!is_valid_imode(rec->imode))
>> +		rec->errors |=3D I_ERR_INVALID_IMODE;
>
> should this check actually be moved before the call to imode_to_type.
> Because if the mode is busted this means we could potentially get
> REF_ERR_FILETYPE_UNMATCH error?  I.e this check should really fail
> before anything else ?

Yes, that should be the case.

I'll update the patch to do this check before using imode.

Thanks,
Qu

>
>>  	if (S_ISDIR(rec->imode)) {
>>  		if (rec->found_size !=3D rec->isize)
>>  			rec->errors |=3D I_ERR_DIR_ISIZE_WRONG;
>> diff --git a/check/mode-original.h b/check/mode-original.h
>> index 25ca274118a7..e40a12930a6f 100644
>> --- a/check/mode-original.h
>> +++ b/check/mode-original.h
>> @@ -189,6 +189,7 @@ struct file_extent_hole {
>>  #define I_ERR_ODD_INODE_FLAGS		(1 << 16)
>>  #define I_ERR_INLINE_RAM_BYTES_WRONG	(1 << 17)
>>  #define I_ERR_MISMATCH_DIR_HASH		(1 << 18)
>> +#define I_ERR_INVALID_IMODE		(1 << 19)
>>
>>  struct inode_record {
>>  	struct list_head backrefs;
>>
