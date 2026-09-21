Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015C43AEF4E
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 10:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789986372; cv=none; b=W94OkalNfI6qjhVjHMILnepCaIMUGuEXqdJaHyaG9fheuKwEum603ni50k97CVNAmgMKIGIGYO2rvzta1ppXmBdfi0Hv6ziYFpq752okDFyIHIhTnB3flwBjX9gzkZEt4xfEw18hRAXLVItXcXkqqQvUTLtCkOzVxT6ts5Ku7zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789986372; c=relaxed/simple;
	bh=D0GWSLczBWDe3yrjuNlLcFtivDLc4GginMNQj3fBKeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r1FOg0lv0ZtHe40Ym+2YzxklpdbZxMANPCZvXvE5jQ5ZVMWKdiMIoRl/OBULygIeE+hkLPL9eDIkHZXa4aBMXi9x2G84Oi2npY8ef/9HtbxpCbFT0DhUGrJ5QRAwc2XSqx8tQ1gpgtzuvVuZspOm2G28q5SwyBo3/Mdaftpbo1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NJ2m0gp7; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NJ2m0gp7"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a803458ba0so3625373a12.0
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 03:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789986369; x=1790591169; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e4qbXlVXUabf2tXEFR1ngYCVlzVBGsebmgRuOKq8NkI=;
        b=NJ2m0gp7V2pzst5Heb33NBUKpe5D0r6XorkhektP3X7tD4zKK5HYz+Lqou3uPsgraD
         F1ZHNJCgqIecRz5l1Doq4Ny5sM2AV62G4ey5tOyTUkyaalGKsEER9ba/GIr3lal9MOMP
         1P8c3PdqT7cIKQqxbuG5A9BWnG/HR2KuZTwuwClWL+/bDzJ9vdCOcooK8Kj9W1mqngMJ
         I8m9oXjx4wEZXDR64iEPCCpyPLSOMlmUqGC0DmG9JSv/6iNDSfLwpkMyY7/heilmn9zq
         hMQ4lDl7VW/80HloxSYw4RW6QPwH22yK0eIrRl3lWOBGePLgXzThTRLIM54GfKezNETK
         HVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789986369; x=1790591169;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e4qbXlVXUabf2tXEFR1ngYCVlzVBGsebmgRuOKq8NkI=;
        b=z/S+KOOHX4c30pV3YJJAmj4Nsunvmhr4abJMyk+k+7VLBClvqaQogbgd3zs4qQbVhA
         dc+OPeX8Jm3dNnMOcR/M/p45uJtII66dRPl902DaJX9ENWpLi7c8aNUHXegzq50f/jqh
         syKGZPy43KxfA1i8X96u5IUlq0AZsgB5G6zWFozxsr1/zhAKoSHl17Y0q3Xb9kRLEb8K
         eFSO+Z/uBRfW/Dlw5xtzDLh2DnvxHPk+6OLxljRoVhP710kds5LGOxgxuXQC/9irtfAl
         rXsL1XSOWPTYHFkL98oagOyVxu7EkRo5KMw7ZfueVIslB5BnIFhVHRq3+QVTKapu96Wu
         FSyQ==
X-Forwarded-Encrypted: i=1; AKwUvBwoscxgTwKzQIipSJbx0wc7zQaYikexbyGbyi32ZjqyMN/t2wEZPhdaLkDxQgb0uwtTwLKPaynsBRdEWg==@vger.kernel.org
X-Gm-Message-State: AFuF++ltoTz+i7zVGcK2AnyyH04GgkfBsGgv9ROGlJuo0LF8cGbfVF+e
	OsnEPQ97jNGi//l9TYem3dn0AwKQaXU22qtN/ckaYni8plbdyY//N+1bXL0wnLe9YK5FPCFBod9
	1d7olOD/sOw==
X-Gm-Gg: AYBFou0R63MuUPxlUCkvTP9P02K93mTct7sMbWsSPw1+uoCdkCJFu+Pk11OgYaZtopC
	fnpSegnSBzA5XlpgUACcagwvhpcKAlCWMbKe92MD7xyGpuYQLU3eFejEHkQV4ogFoRtY/2ZA97q
	5S/ULVjlBHR2QPpPgGnByUpRtdOu62elj8bAmj4ISz3TUcMM/k+Vy+SHeVpaat8Zj8dvXIwJ8nz
	uZx8+GO/UQcqyMi/GHg8sVWNe2biE7eLtfgUX+6Wyqfq/3F+ccP6ank/GeJCqvMPzMPEelRKs8L
	+xbJ3t2JuOm1Ja5JG+nj6/WgP9VDg7sD4eI55YhdyMKMDr5p+Ylp+8WNY+1772BekZcGkMDxRdd
	zI51OfHUDiHmtnVHimODzWXeO7jZqrdfEnY4elbSuLoPrxA12Pe+9APczIIcgrjWx/mhSOl/UYl
	BDNjCBDQ6GUcUqlPWEGyqTqxq63r7fydLrGcydNtBR7GXVuQUiXCCCHHfsT4HCckliNAf7lfyCl
	w==
X-Received: by 2002:a17:907:72cc:b0:c20:21be:ea75 with SMTP id a640c23a62f3a-c2a156482eamr971237266b.8.1789986369031;
        Mon, 21 Sep 2026 03:26:09 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6f1835adsm13618298a91.6.2026.09.21.03.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 03:26:08 -0700 (PDT)
Message-ID: <ab276690-ccd3-4d37-84d0-77f8796615a9@suse.com>
Date: Mon, 21 Sep 2026 19:56:04 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] btrfs: let rescan_should_stop() decide if the
 rescan flag is cleared
To: Dongjiang Zhu <zhudongjiang@fygo.io>, linux-btrfs@vger.kernel.org
References: <cover.1789981860.git.wqu@suse.com>
 <b0f743a5d512c45d5184086c1b7f26af65cc261e.1789981860.git.wqu@suse.com>
 <e6a0a484-c404-4f52-a30d-2c112efe493e@fygo.io>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <e6a0a484-c404-4f52-a30d-2c112efe493e@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/21 19:44, Dongjiang Zhu 写道:
> 在 2026/9/21 17:16, Qu Wenruo 写道:
>> Currently if rescan_should_stop() returned true, aka the rescan should
>> be stopped, then we won't clear the BTRFS_QGROUP_STATUS_BIT_RESCAN
>> unless the BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN is set.
>>
>> However the reason why we should stop rescan is also affecting whether
>> we should clear the rescan flag:
>>
>> - fs closing
>>    Should not clear RESCAN flag, as the next mount will resume the rescan
>>
>> - fs remounting (from RW to RO)
>>    The next RW mount will resume qgroup rescan, so we should not clear
>>    the RESCAN flag.
>>
>> - quota already disabled
>>    We should clear the RESCAN flag.
>>
>> - CANCEL_RESCAN bit set
>>    We should clear the RESCAN flag, for now it's a special case and
>>    checked manually later.
>>
>> So it's better to let rescan_should_stop() to determine whether the
>> RESCAN flag should also be cleared.
>>
>> Since we're here, also slightly change the message, the CANCEL_RESCAN
>> bit is already cleared before outputting the message, so that
>> corresponding branch is dead.
>>
>> Save whether we still have the RESCAN bit set when still holding the
>> qgroup_rescan_lock instead, and use that saved result to determine if
>> the rescan is properly paused or canceled.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/qgroup.c | 41 ++++++++++++++++++++++++++++++-----------
>>   1 file changed, 30 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 05e35eb126dc..eb71f5d7c1a5 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -3862,16 +3862,31 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
>>   	return ret;
>>   }
>>   
>> -static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
>> +/*
>> + * Return true if the rescan should be stopped.
>> + * If returning true, update @clear_rescan_ret to indicate whether the rescan
>> + * flag should be cleared.
>> + *
>> + * Return false if the rescan should continue.
>> + */
>> +static bool rescan_should_stop(struct btrfs_fs_info *fs_info, bool *clear_rescan_ret)
>>   {
>> -	if (btrfs_fs_closing(fs_info))
>> +	if (btrfs_fs_closing(fs_info)) {
>> +		*clear_rescan_ret = false;
>>   		return true;
>> -	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
>> +	}
>> +	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state)) {
>> +		*clear_rescan_ret = false;
>>   		return true;
> 
> What about an RW-to-RW remount, such as:  mount -o remount,compress=zstd /mnt
> 
> If the rescan worker observes REMOUNTING, wouldn't it stop with RESCAN still set, but without a corresponding resume call after the remount?

That's an existing problem, feel free to fix it.

Here I only care about preparing it for the incoming freezing check.
> 
> Thanks,
> Dongjiang
> 
>> -	if (!btrfs_qgroup_enabled(fs_info))
>> +	}
>> +	if (!btrfs_qgroup_enabled(fs_info)) {
>> +		*clear_rescan_ret = true;
>>   		return true;
>> -	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags))
>> +	}
>> +	if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
>> +		*clear_rescan_ret = true;
>>   		return true;
>> +	}
>>   	return false;
>>   }
>>   
>> @@ -3883,7 +3898,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>>   	struct btrfs_trans_handle *trans = NULL;
>>   	int ret = 0;
>>   	bool stopped = false;
>> +	bool clear_rescan = false;
>>   	bool did_leaf_rescans = false;
>> +	bool canceled;
>>   
>>   	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
>>   		return;
>> @@ -3900,7 +3917,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>>   	path->search_commit_root = true;
>>   	path->skip_locking = true;
>>   
>> -	while (!ret && !(stopped = rescan_should_stop(fs_info))) {
>> +	while (!ret && !(stopped = rescan_should_stop(fs_info, &clear_rescan))) {
>>   		trans = btrfs_start_transaction(fs_info->fs_root, 0);
>>   		if (IS_ERR(trans)) {
>>   			ret = PTR_ERR(trans);
>> @@ -3947,8 +3964,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>>   	}
>>   
>>   	mutex_lock(&fs_info->qgroup_rescan_lock);
>> -	if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
>> -				 &fs_info->qgroup_flags))
>> +	if (!stopped || clear_rescan ||
>> +	    test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags))
>>   		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
>>   	if (trans) {
>>   		int ret2 = update_qgroup_status_item(trans);
>> @@ -3960,6 +3977,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>>   	}
>>   	fs_info->qgroup_rescan_running = false;
>>   	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags);
>> +	canceled = !test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
>>   	complete_all(&fs_info->qgroup_rescan_completion);
>>   	mutex_unlock(&fs_info->qgroup_rescan_lock);
>>   
>> @@ -3969,9 +3987,10 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>>   	btrfs_end_transaction(trans);
>>   
>>   	if (stopped) {
>> -		btrfs_info(fs_info, "qgroup scan paused");
>> -	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
>> -		btrfs_info(fs_info, "qgroup scan cancelled");
>> +		if (canceled)
>> +			btrfs_info(fs_info, "qgroup scan cancelled");
>> +		else
>> +			btrfs_info(fs_info, "qgroup scan paused");
>>   	} else if (ret >= 0) {
>>   		btrfs_info(fs_info, "qgroup scan completed%s",
>>   			ret > 0 ? " (inconsistency flag cleared)" : "");

