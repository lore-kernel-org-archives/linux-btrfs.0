Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B15A25B09D
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 01:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790041387; cv=none; b=JWlVTha+9pRK6vhzstuMUzFQQGBKj0mlX0apphHQN8j4WyBYtre/wtvYgcKjxLF13T5T+2deodw5BX0GLotKQWjiLHTqdrDKaL+0EFmEfIM86q1QqsxCnc/7DzEP3Fb2/oTuES5SODjYCSXnfv4Rqe1zvhN7FfMjeXEnXk5DgKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790041387; c=relaxed/simple;
	bh=c2LmCu8cdXqCItINnBeiSwsRS1OJ5Mz68eYfM1pCaxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cvyc0VdhV9Epb3GUQGg7c1v9ou1zTgxR5q0I3LEnobDlBJQ13Y/A83ZG+vQxgPB8Q7kHz56HWnSqSMApnFF+ZNo2xxvNf4QqiaTcMc3ktWXCF4FV35TfJ551HFpmmoUOiMdf9a570vygWsLVHTofk1YBZz8nHkGG7mmY1laA3Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=mTBCpJOy; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=3c9Hh3QQ; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="mTBCpJOy";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="3c9Hh3QQ"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68M0ZOhw111289
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 21:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KSUv
	35Q6uQ78ZsYROYm0LB+h9p7UZYz9TOi1IegvsE4=; b=mTBCpJOyKBWRWMGQz0Gv
	g3XJGfJ3JeXlRhMfoyeGegZCTqd1seKlVqP2khj6iSA5/EStOYkEQXQj22wzO7K4
	RaSmy/g/6+urhCmyt38lGsJutFl0ZSSv3dgvQyPUVbsJVHpVzLAj4i72Gfx1W37x
	uR9uqtcZKCPyTmkVDEmKAccpxN6/MDkL1wBEGrBWcTO1F22Z5aZkjWx+mQX3frv+
	IDTsAtHDkc1j1PsdgDLtBzlc0i9u5lNFPpmlxINCsTnpEQ1I22InWYpmhxZ5E+8/
	vPlW+3T2jaWDLwhA7jk0fiAcVHEqo5HH75+3vvUrCDDmhuVxjWnhish76M2xK0AS
	iw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gu70xvdac-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 21:43:04 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-936aa34873bso642784785a.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 18:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1790041383; x=1790646183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KSUv35Q6uQ78ZsYROYm0LB+h9p7UZYz9TOi1IegvsE4=;
        b=3c9Hh3QQoNz3X2OOe7DZFgOa/52qU5SuldA5IvG1ai2sbggMgSSwtSQbRPwbNPQFlm
         akhY2RuxKBKrzc5emZXGuyzNkNRkNSRf9ppZhkwdzEaU7Oj9TGh+olx2YiWTFtBuFpkp
         vXMFFuwJ8ND1+Jltxiwl1Hq6A1cEQV6B+yROf/lYFS/MZ4ixUNjV2xYyzmb2EZVKMOxJ
         /q7QthGDYCuF9hZmTeEkyqOEZ/n6Tjd1TD9+iKiIVJ1O4vejHXuaCXE9m0iZioPJRUcF
         e+TqYm75ADBYTwj4IrpiM2u3xGOF0xLv3f9a1ej2gnKkEAtgEGXvpV9v0WWnyUDGUZqT
         x0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790041383; x=1790646183;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KSUv35Q6uQ78ZsYROYm0LB+h9p7UZYz9TOi1IegvsE4=;
        b=Ykv8SRzg6V2dlb8ijba7ll4oQiRwDSDy8N9OPheWGux7DyAJytbups4BQ4+yO+iSni
         h51jkxJc0ffYOwGqAliJ52TbeR9ncbZYu64IsAyAknOHpFUmiGUlm4DD6ctwkK4ICBSY
         SsS2PoQykpbh0zotxmrOjdn8JA6r5E9VzFlBzusGCOJ42WiUwOfUN3DvZy/Y+cx6UhYL
         79pg1tdjQY2WqQdiZlOBuBez3XO7Y+vgNxAlK0DLZHNy+W+2/JogyTf1gdRQdkQVBt8K
         G1b8hTFqkhs4aCgtPmjWprwi0DCzL5wLovkH090e9/TkraclaYxY8KBQMGqyZglDhHmF
         kqAA==
X-Gm-Message-State: AFuF++k4ujAUmLfPJ1dLoNh+7Ux5Zbrn+IqOUtkgyDPRXuouBABTq5ke
	dn4jEv+8jF+crs586V1TYIMTrutH5QmAcn0h16RNZk1RV91WzjQfXD5cF4lRDwOP09gJGPQbW9Z
	4gSJicDlLT0Ztqr62zAtBPVJT6IFZ7hGjBAX51nqbPAbJMdcNd64sQ7GmEBNyygXPW5+v
X-Gm-Gg: AYBFou3uLTogV/HPjG21pNgp6VjrZgKcR6mmrUC9J6tWZ0XxeBJuaKxD+iauZaHqzhx
	9/dADToq/86VtZZIW/qr/8mdkzobbazkrIeB6csofZstid1bQoiix4QzDVXzUrazZB3TI2eHNcC
	ISJysKpSU4JV2DJR1CmYDQVt1nbkfWgVaP4a4Jprw8lV6RiPh+/xf9ToKkHJC/vmEP3K0Ritnd7
	jcRZbKaL0atrofICNEZFWnT1kj+kUNG9AO7I4QawoDO5WpXckFAbPZK89rIh+7ZUomipFiRJNkO
	cBzxZ22cvhVUExaJHRved/Q865uSwFFRx40MnuMpP4c/bdwEpHjQWkxqpfgQ1kcslYe9I1ydLz3
	HWNOmSiDM5MZq/f/iXg03yuKXgEWbhvxO5qbe2T8iaX2zKVvr
X-Received: by 2002:a05:620a:4101:b0:939:8ecf:6025 with SMTP id af79cd13be357-93c15da261cmr346248985a.20.1790041383526;
        Mon, 21 Sep 2026 18:43:03 -0700 (PDT)
X-Received: by 2002:a05:620a:4101:b0:939:8ecf:6025 with SMTP id af79cd13be357-93c15da261cmr346247385a.20.1790041383075;
        Mon, 21 Sep 2026 18:43:03 -0700 (PDT)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1cf0dcd9sm16918185a.4.2026.09.21.18.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 18:43:02 -0700 (PDT)
Message-ID: <137069a5-f42b-4935-901d-60153d92c9d8@columbia.edu>
Date: Mon, 21 Sep 2026 21:43:02 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/17] btrfs: stop enabling the v1 space cache from the
 on-disk state
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
 <20260916-btrfs-remove-v1-space-cache-v3-1-10ebde03b96f@columbia.edu>
 <20260917041202.74A691F00893@smtp.kernel.org>
 <20260918095757.GX54722@suse.cz>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260918095757.GX54722@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: _jcOM4vs8qMY9z6FusrN47eqlsNXgb1j
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDAyMSBTYWx0ZWRfXwE0EdUhE6zUH
 sjnmI+wkUGdUpPWwOn+WO71gO8Uf3CbTIEel0PqTTCYHIYpVPqg2j4xAMSX/yuaV+vvgSarrBSn
 N1b/oTziWqok1o0S8rIqNowlmQR1eLKpW29r2A0NuUVkfstWe7ui
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDAyMSBTYWx0ZWRfX2Zoz7mS3qPsM
 CUAmJAUx3+y6nsjnrqZ1V6fmPJMYQqJ/WnWjLWnbMLqeaUHR9qHqwduuVxotgIr3FOiMcFT+bBl
 kXiBbKPaQAmIuQdRmBQjiDJ0694s7UKVbi5HsTLkOUlddIhKEFt5HmqM7frKhy++ylfE4mx70LI
 s567MFSS3BzKA9SMmPJcQ405BPMF2ZchSsH8zZUg//Ipvx8xHonnCHvvCbRw1GRYfD9tW8E0HOr
 oEHdKtH/wIl35WK2tYrWgunxgkqP6e1S5UJnMd5+7FtZluvoSnjVpoFxmf2xBo6jpCNRuLlI0Mh
 fStYr2lC5KGGSY3+56BD/CbWym3bvnB0yovhhqcVXKzDf+juBbt+6H3/FXKfA8uOgCV1gVwYvtB
 bj8jsUY1x265Z5rMgkJd/OYoe9oD1HtOUtOiIe+u5H5ACQ1ySpRnajfKTPE8j/DveuJax9n0WpL
 DJ3GexOe2GqvsF4xC7A==
X-Authority-Analysis: v=2.4 cv=R+6WitRX c=1 sm=1 tr=0 ts=6ab1dd28 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=KDcxTFHVVmGa8HFdOuoA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: _jcOM4vs8qMY9z6FusrN47eqlsNXgb1j
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11912
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 suspectscore=0 clxscore=1015 phishscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=10 bulkscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220021

On 9/18/26 5:57 AM, David Sterba wrote:
> On Thu, Sep 17, 2026 at 04:12:02AM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [Medium] btrfs: FREE_SPACE_TREE option leaks on invalid RO remounts
>> --
>> 
>> commit 6751f883b4d1cad106e74cd1b62922302a1c3544
>> Author: Tal Zussman <tz2294@columbia.edu>
>> 
>> btrfs: stop enabling the v1 space cache from the on-disk state
>> 
>> This commit prevents the v1 space cache from being automatically enabled
>> based on the on-disk state. Remounts of read-only filesystems with an old
>> cache no longer start a transaction, and space cache cleanup happens
>> unconditionally upon a read-write mount.
>> 
>> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> > index 464129b1b0d4c..77443ded6db39 100644
>> > --- a/fs/btrfs/super.c
>> > +++ b/fs/btrfs/super.c
>> [ ... ]
>> > @@ -1535,10 +1529,6 @@ static int btrfs_reconfigure(struct fs_context *fc)
>> >  			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
>> >  			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
>> >  		}
>> > -		if (btrfs_free_space_cache_v1_active(fs_info)) {
>> > -			btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
>> > -			btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
>> > -		}
>> >  	}
>> >  
>> >  	ret = 0;
>> 
>> [Severity: Medium]
>> Does removing the v1 space cache check here allow the FREE_SPACE_TREE option
>> to leak on invalid read-only remounts?
>> 
>> If a user with a filesystem using the v1 space cache attempts a read-only
>> remount with "space_cache=v2", the kernel emits a warning that this is only
>> supported on a read-write remount and intends to reject it.
>> 
>> However, because the v1_active check that previously reverted the
>> FREE_SPACE_TREE option was removed without an unconditional fallback, the
>> option appears to silently leak into fs_info->mount_opt in
>> btrfs_reconfigure().
>> 
>> If the user later performs a standard read-write remount, could the kernel
>> see the leaked option and unexpectedly create the v2 free space tree?
> 
> This looks valid, though the consequences are not disatrous but still
> unexpected to create FST.
> 

So after looking at this some more, it seems like this "leak" already exists
in a different case.

If a remount asks for space_cache=v2 and isn't going ro->rw, we warn that
we can't change the free space tree, but the remount succeeds and the options
don't get reset. On a filesystem with neither a free space tree or v1 cache,
FREE_SPACE_TREE stays set and the next rw remount will create it.

I think the simplest solution is to add:

	} else {
		btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
	}

as part of this patch, replacing the deleted btrfs_free_space_cache_v1_active()
check.

Should I send v4 with that change?

Thanks,
Tal
