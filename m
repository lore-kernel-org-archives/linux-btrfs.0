Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3FA475348
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 09:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365000; cv=none; b=kmFkUevnQKFNr+BQZzqybFX842fS64NkGOWmE4BH3hEANPEnutg66IiBVf2uqDKYtLxYVOo93SU6ZP4UNIXhLk/iUY99PlGt1qc2z1ZzBvnWyhYmrUdoaD8Q19t1v15oYCDHv7QtWTOUuG6pGa7MfVP+aMkv8XYyD7MZf14pYtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365000; c=relaxed/simple;
	bh=49loMnyNZXHZDHY6ztGRcoRDezmZT04atOA8t1D0ziA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=q+0CLEfXdyWV1QMPjIc8WsNqsqPt5gQaBFgl4Bnplvj8/JX6kFit/brW2oQMMsRHHeSf+RDchnTOABDtoBgICb2V3iyKi8tMMV47XPRK2CIlFIG+Ef5nbjTg/W0VpUHock8HlXKiR7v9ZzuP9vGFNY+mjP2P8QPy1UMcAE2gpGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fbDkFjd4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fbDkFjd4"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2a4e013a44so564741066b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 02:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791364958; x=1791969758; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IoO2GmgQqTbMIzbKjbtZGqeaqfQkkwtp1dXjhHu5kRk=;
        b=fbDkFjd41UkA7k2HqyH0LTg1uWTMqSET/3QlPobgmrScSYCeELOTmbf5mRCJN70w21
         PIfZNGpW3e8cWNxSUFmKsjsnMwVwXYWSNryuyBbMAA+PyYTrNuz0Q4u2OtFPctOE5Ecn
         v9DRGDzOORAYIKp2MFbLgsqKjgyXtbsZbzy/cQBCdlsUzerkiBqYKf/1A15xZ3/DyGV0
         KULVneYwmBM3WzZ8qZfCT1goL1cT0Rt1mAgZGNcjh+DIjRf4D5DgM/+L8hn/BPrzUHsB
         +GWGWGNBoRLJQg57bI263k9etLOCv2RuAm5eUNPUIoVSThdZRt6BVREZnB1lnjl2ICbg
         wl2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791364958; x=1791969758;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IoO2GmgQqTbMIzbKjbtZGqeaqfQkkwtp1dXjhHu5kRk=;
        b=CuP+ITCPkxpLqW3OdZMEeMT1cN1gLR3VbhUUVLTfqvMFEvHDl2SDHQ/sPEr87m53HV
         6kQVHDrBOSC/4wfj3k4QhMUY4vs8CAs8XEGYsfKXcQskxR//sMTzeL4IUMYJEOPRwPj1
         3rnBhF0+1SLicoUVZtTUZev499KGuvoLVbDvjH2rItaB/kmcv2OEw2DFdXyjp0clO2QH
         4h4sSW1AnFtxRpKkI9MC52o042hf0VyrwM14Fikqdw0PHmL3wBZQdftJibwgiDW9OWJw
         CXfL1HLTCzhfUrauSW3gqTN+Cc5LN1UYdJ0+Zg9rQP/ti0s2C65QxP8txMwz1+yxgZq5
         kvdw==
X-Forwarded-Encrypted: i=1; AKwUvBwZZCt1/i5TA2XGklOuznYOkTPdHBSw4Jhnbyq1VQbKYzM5jwW/NuxsOEMOi6qXW5G0xga9XC5OJkwEtw==@vger.kernel.org
X-Gm-Message-State: AFuF++kPNa3GnQvinN2rQQcI2g0W2y7zdj4fdFYQJpUE43tJmeDWc3Ct
	sZ4MwrQ17OXRGnxmszX1yOXanWejw+iHAB2bId+rqrl6B9D7mnz8+w6w67WrlMnCrYU=
X-Gm-Gg: AYBFou2/MYamhNU3/+uBmFgq8yAB7WTmcNRo4HqFA2gPlUgqrfVPVE1275aNIEi+zOE
	BcOowCFFIKviVh+33yDALJVxFgtYNOxLb07ExgXxqlN4T0F440SJIjeMDq25TpEQEb9GT7ino66
	YKAYv94UPfMrOzc6A7ztwtSOCj6O89bVWNftmV0WbS0l37RsXOCkZ4G6Y0bP5hU0w0fWBv0X1ab
	CdCesAvvQcmEXgK780uclcipThm2rdz1JHfkfcWPKU+epruLpUoiDMI9biu3oQeUgYZAZ3PKX7T
	X0DO+EwjI0BYljNWt3ggkHQbJBQ+0O5kkjM6ES0zc20yy/zJsdHLRV6Cr9Xr5vFqyyHnBYBZutR
	xG+OEUeTyEj5xbs9BM3TxNEGDNQ6zcWcPv2khu1Ii7H9VflVT+yd+PQU8rkDR6+NPV2DGLtR6WZ
	1xOni5R6YcOwkNum2oo+dpcr+8NX0wTOMJ4LULpGRkAjtKaBVzS9Cr65onWL/Dt04=
X-Received: by 2002:a17:907:6d1f:b0:c2a:704c:8c74 with SMTP id a640c23a62f3a-c317c080ff4mr157588066b.28.1791364958384;
        Wed, 07 Oct 2026 02:22:38 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8921cbe37desm440650b3a.37.2026.10.07.02.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 02:22:37 -0700 (PDT)
Message-ID: <896c621b-441f-4d46-96b9-fcc209d78a7f@suse.com>
Date: Wed, 7 Oct 2026 19:52:31 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free on quota enable allocation
 failure
From: Qu Wenruo <wqu@suse.com>
To: pavankumaryalagada@gmail.com, dsterba@suse.com
Cc: mason@kernel.org, fdmanana@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
References: <20261007090656.20609-1-pavankumaryalagada@gmail.com>
 <4851139b-6cd0-4b1a-9a6e-1af947d49098@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <4851139b-6cd0-4b1a-9a6e-1af947d49098@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/7 19:47, Qu Wenruo 写道:
> 
> 
> 在 2026/10/7 19:36, pavankumaryalagada@gmail.com 写道:
>> From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>>
>> The quota root remains on the transaction's dirty root list when
>> kzalloc_obj() fails and btrfs_quota_enable() releases it without
>> aborting the transaction. Later add_root_to_dirty_list() then accesses
>> the freed dirty_list, causing a slab-use-after-free.
>>
>> Abort the transaction on allocation failure to clean up the dirty
>> root before releasing the quota root.
>>
>> Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=947286c775f432b073a8
>> Fixes: 8d54518b5e52 ("btrfs: qgroup: pre-allocate btrfs_qgroup to 
>> reduce GFP_ATOMIC usage")
>> Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
>> ---
>>   fs/btrfs/qgroup.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index f68b696b4bf7..42be06675c90 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1204,6 +1204,7 @@ int btrfs_quota_enable(struct btrfs_fs_info 
>> *fs_info,
>>       prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
>>       if (!prealloc) {
>>           ret = -ENOMEM;
>> +        btrfs_abort_transaction(trans, ret);
>>           goto out_free_path;

BTW, you are on an older branch.

The latest for-next branch has the commit "btrfs: qgroup: merge error 
labels in btrfs_quota_enable()", which changed the branch.

Next time check the MAINTAINERS file to grab the latest devel branch.

>>       }
>>       qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
> 

