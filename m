Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC72362127
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773129518; cv=none; b=TW3xm4dLurKkEdUnZWT/7vHK53qddfJb3cjUQT5NXYHKqMuln+3OOuxFXbR/k1HBnY7T7AZpt6rWiUCadvkfo3v+uPdBk0GqhbKjV1vfv06VwLdSh+/lSE19OYrLPDUUkVYCpESkOkaEoiHT5fteonOxizD3DR/j+y+p17dDaWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773129518; c=relaxed/simple;
	bh=dJACL1xbOca8NL+RsOamc/5iSH56+g8ukHRHQpWpNKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUGyTU8aHlf7CdTfcW/LOWklIUquOApgqD0tYAPfeQI1+gLwFyXdxflRSreiIjuM0Qx22mhwLRT/OHm1dNoTKm+87Vr3mkjb1C5t622b3HCjGqTUiOyQvhVG0yaD09Gfc9YT46xUMqRau/4sk5We4QaT+tTbWeYbEbWOfYnPFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CImAbvDR; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CImAbvDR"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-482f454be5bso125911985e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 00:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773129514; x=1773734314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ld4ELcIlsbp6AsYdibpY6RsTU9tdCfqscQU2GvVbvM8=;
        b=CImAbvDRcrQ1QnBrixGKhP8CHFGmBADvF2qdfMEGQj/xy8I0fo3fuPb0U++nwC3Q8d
         T7oZuYwm1W8uY5tw4/FTblpPChu6dxBulHZKNDeCv5Z6tdMdA8fCN5uRnKOcQHYJEifb
         cxC7e3GGF/+o+yesC4Xt0Uajj7JZiCoaJ5ahbgDECG5hrQdDqRlUbgj+blRzULevHogX
         /wEFR5Gas5JflSQVqyEYC09RX2cKs9v8xrQpdhsxlEI0zOUULpA+G2gSZjLaVMOQIU35
         TZy/AbcPBDa4xlPLcHlI3bH2juho+IXKHDI8Vx80t9JVlxSViPWsY5pFSVgAViI/Fe1u
         Hcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773129514; x=1773734314;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ld4ELcIlsbp6AsYdibpY6RsTU9tdCfqscQU2GvVbvM8=;
        b=dTudBOoaXPbXZYUYIXBLX79oetm71XVxYQT21mrm7/p98u9jrXxRv4j82ZQXp5iBhF
         WJ1U2zw/RwS8IR3CIodrBX8r2nQUBqcG0dx2TT6ww8XqS39clauwN2uZRE2JrKF/vYNc
         XogLcwzQr9ufJHKFRVT34zXn7A9s7dJclWFOJ7BQkDWicoGluZyghC5G8LOqJ/39x5FA
         BDr9SGT8xwkhPqsLy4gbTvtSOZgqdndOD9ohf+WvSyn0euhLZ7it5edz1+x5KYsfD+P5
         rVl/Cuu14rfLq7oTTHve1Q4/PQU/SSMliy57YPmo3m0GxBJlM6UjGKfCufuk9PUS3pm3
         3AEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsVi5AJXSi/KvWUFnlyC/nvuG92j2PEzYRS9UAx2o3Z1nflrwnijpYpcl62vJnDdGgJudFyhMd6Yv6Lg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNPoYV9x313EKX0Z6xBYGawMHJ9uXszOkGIetGoLZeiugeKnBb
	ZOcYZha113uWgID3gw+Zvu4HCcVQYg1w/qBKdLxuZ/xiNRNEDkrhqs8DPC9yqbO4wJKi+4TrIkS
	O8qKccM4=
X-Gm-Gg: ATEYQzwWB0ehbwWaXh7IQkVtKyihpfKsKgheMqr8qx+4NgeGnO6md7/qmae5tjRPJ1+
	pfw5RoD53f5qBt0ow9EMUhJUbI0N/KitBaRDEQufiV9Arj1fSA0c2IsxwDjAOTwjgkhlHomIU2M
	XldzlrmxYP9/MwjigEvB6kQMqvuwYpcV8wFHw7Ez8Awh4NMTTj2CcPGhp0GyQnK6F1YVcwF3CkA
	Atyq1A85bPkgCuVd72iVINjqKIGSVdiKUvMDAJDrpWgjYun9kiSIjyJ4tsWuMP8q73gkC1ZYc91
	vZvTbdBtc4jUf0sMA+ABEMNThCN/bV9blXCN71OjBc+HfMPU9qt44dSae7SvyJPudECDgg3bAqW
	6clUxeV4nLBNpT4ckxLGrie72NXCXXuLEY4IOa2SUh3k+j0/MOmo0vylWdsvJ5JYLv4vDFb4McN
	CKqW14EqS5VXd0ZqegOW1lya9c3AbEVEDbl32ZhW+k3z64TpFV7SyZUF2oiDEAqA==
X-Received: by 2002:a05:600c:c178:b0:485:343b:38d with SMTP id 5b1f17b1804b1-485419dabdcmr42533045e9.5.1773129514183;
        Tue, 10 Mar 2026 00:58:34 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e16cebbsm10993260a12.16.2026.03.10.00.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 00:58:33 -0700 (PDT)
Message-ID: <35bb4d50-012a-4bbe-ae4c-eb44b69d4cf3@suse.com>
Date: Tue, 10 Mar 2026 18:28:28 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: move larger data folios out of experimental
 features
To: Oliver Sang <oliver.sang@intel.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-btrfs@vger.kernel.org
References: <202603101405.288f83f3-lkp@intel.com>
 <933c12fd-0d10-4ef7-b10e-cb64497829eb@gmx.com>
 <aa/Ga0S+ZtmpNWVl@xsang-OptiPlex-9020>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
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
In-Reply-To: <aa/Ga0S+ZtmpNWVl@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/10 17:51, Oliver Sang 写道:
> hi, Qu,
> 
> On Tue, Mar 10, 2026 at 05:33:16PM +1030, Qu Wenruo wrote:
>>
>>
>> 在 2026/3/10 17:13, kernel test robot 写道:
>>>
>>>
>>> Hello,
>>>
>>> kernel test robot noticed "xfstests.btrfs.052.fail" on:
>>>
>>> commit: 50bb0fb60d1d55c7447535d17081ea009700cfd7 ("[PATCH v2 3/4] btrfs: move larger data folios out of experimental features")
>>> url: https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/btrfs-drop-2K-block-size-support/20260227-113649
>>> base: https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git for-next
>>> patch link: https://lore.kernel.org/all/0d8fe02f58ccbc0c53714ea45b0a4303f2ee8206.1772162871.git.wqu@suse.com/
>>> patch subject: [PATCH v2 3/4] btrfs: move larger data folios out of experimental features
>>>
>>> in testcase: xfstests
>>> version: xfstests-x86_64-63a29724-1_20260218
>>> with following parameters:
>>>
>>> 	disk: 6HDD
>>> 	fs: btrfs
>>> 	test: btrfs-052
>>>
>>>
>>>
>>> config: x86_64-rhel-9.4-func
>>> compiler: gcc-14
>>> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 8G memory
>>>
>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>>
>>>
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>>> | Closes: https://lore.kernel.org/oe-lkp/202603101405.288f83f3-lkp@intel.com
>>>
>>>
>>> 2026-03-06 18:12:00 cd /lkp/benchmarks/xfstests
>>> 2026-03-06 18:12:00 export TEST_DIR=/fs/sdb1
>>> 2026-03-06 18:12:00 export TEST_DEV=/dev/sdb1
>>> 2026-03-06 18:12:00 export FSTYP=btrfs
>>> 2026-03-06 18:12:00 export SCRATCH_MNT=/fs/scratch
>>> 2026-03-06 18:12:00 mkdir /fs/scratch -p
>>> 2026-03-06 18:12:00 export SCRATCH_DEV_POOL="/dev/sdb2 /dev/sdb3 /dev/sdb4 /dev/sdb5 /dev/sdb6"
>>> 2026-03-06 18:12:00 echo btrfs/052
>>> 2026-03-06 18:12:00 ./check btrfs/052
>>> FSTYP         -- btrfs
>>> PLATFORM      -- Linux/x86_64 lkp-hsw-d01 7.0.0-rc1-00110-g50bb0fb60d1d #1 SMP PREEMPT_DYNAMIC Sat Mar  7 01:56:32 CST 2026
>>> MKFS_OPTIONS  -- /dev/sdb2
>>> MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch
>>>
>>> btrfs/052          [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//btrfs/052.out.bad)
>>>       --- tests/btrfs/052.out	2026-02-18 09:47:02.000000000 +0000
>>>       +++ /lkp/benchmarks/xfstests/results//btrfs/052.out.bad	2026-03-06 18:12:03.421371379 +0000
>>>       @@ -91,553 +91,5 @@
>>>        23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>>>        *
>>>        30
>>>       -0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>       -*
>>>       -2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>>>       -*
>>>       ...
>>>       (Run 'diff -u /lkp/benchmarks/xfstests/tests/btrfs/052.out /lkp/benchmarks/xfstests/results//btrfs/052.out.bad'  to see the entire diff)
>>> Ran: btrfs/052
>>> Failures: btrfs/052
>>> Failed 1 of 1 tests
>>
>> Can you provide the full btrfs/052.full?
> 
> I attached tar.gz which contains all test results. thanks

Thanks a lot!

It shows it's the defrag ioctl failed, and it's indeed a bug in that 
patch, that I forgot to remove the experimental check from defrag.

Thus it won't cause bug for CONFIG_BTRFS_EXPERIMENTAL but will cause 
problems for end users.

Will get it fixed in the next update.

Thanks again for the consistent report!
Qu


> 
>>
>> I checked my older logs (we have enabled larger folios for a while for
>> experimental tests) and can not fild a similar failure.
>>
>> Thus I'm wondering what is causing the failure.
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>
>>>
>>> The kernel config and materials to reproduce are available at:
>>> https://download.01.org/0day-ci/archive/20260310/202603101405.288f83f3-lkp@intel.com
>>>
>>>
>>>
>>

