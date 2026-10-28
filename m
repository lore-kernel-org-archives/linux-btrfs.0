Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793173853;
	b=dj44we/X65PkpjctQn73BkzkTm0XbpESB0g6iQG3jzzry1BRAiF7SLTtjCwlQS3lko8U
	 p7cE1XyFE8wr36hdSCgidJ6gY80YdT84UrekB3twnr9z0v0mYYtZH9jlNGlNL4MjY6OkA
	 2lwrqk8stWBF+0FMXpvQPR4RYstub+KVl3dEIu2r8CmDzhHdcgNLK9megKF2Uy5/WZBA8
	 WiKgKNRIne0ZAIpkmL65X/cEC259VJNPY6l2WCqRLmLSInQFViEEZYPOjs4xH7gNTm5IC
	 ZCSCeR9O1Afm+EEpoWKUNBHl+HFoQSU4V1IzpLW+43Ug96McsiMBGgsa7aKgBgY6bzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793173853;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=QabUepZshTuWcPWLH/f6M3OiVm66qar29q1ZiPFt4co=;
	b=KO8220jjZQoo5eX3Z88ImQ/hCVdignVUn5uvZXUI6T1F5QoFEd0kafRlsS2RgdH6Ll48
	 6Fi1ikeKvDtrjNU+vWbLASnhk4NjKNIWIyMzvxYTymE/chMe79he2poxXlWJ2WX6Y5mTV
	 +U112dqoiUaTWnkRafbSn50U5MPtxt2XvCOqK/mr5PmZcITfvozE+TdwHLpQbIFJ2gHVo
	 ESJPuQf/Iy1+jx+kh911zWJscg+6xqkXCFIkzJxx7kJqCVM/XgLopOzWMCfgGkBWAyspX
	 sH3wzzhiSdjJpeuWVeonbyRcuMigkjG6C7ZgQYSsyi9Ut5VmjjlPBgjnuXkJFuS/qjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cIzTfwvI;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F247D606A334
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 07:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F247D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=cIzTfwvI
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so10752755e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 00:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793173851; x=1793778651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QabUepZshTuWcPWLH/f6M3OiVm66qar29q1ZiPFt4co=;
        b=cIzTfwvIeV2p3+HZONnaLs8OrALR1BiQZsuEHFv22k5tMpn87c699RB4pXtpO1BknZ
         w7mFc/NBuJ/LAraXW70R5EtX0MqSS4DHIYhaaK3x8RDhKQETu2gPyFaLw8QlT07DFmBy
         h4TeAG55cDuS9WgM/KuuXL/YnXqyY0QDsLIj4e3bPqq5OyiMw+/0Mfdyk6LGeGLmZyaE
         I2kApHS+fxHb6U8Xha4YMCFI9beSJ/0SgvmgggOctUagsh08ImbV+oTWYJfOT6s0xrWL
         t3VuHw/TDKPR6xf82IXNxdgzIU0r5Nf2P+iQ1/pq4Zq3Ps5LagWwiwVa+Ej2c5BIOp/V
         usRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793173851; x=1793778651;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QabUepZshTuWcPWLH/f6M3OiVm66qar29q1ZiPFt4co=;
        b=za/UgBAr0HZnE1hoka/Q4QMuhbFvCGFPURziUTAknQhZ/cjaE3+6RLn2oN5DMnZtuk
         hAOjlTD0TRVbhO+Ws7Rzi7vXTC1+jPz7EyqE+mQ4IwGrBWeYamUVzyJVqr8wTo40kmJM
         8TxVIS5rzKAfnPXpCd9ZXDaSTM5CxW4S3GLEYyqM/eIZyQ9uaEUtREQho/uf9xjykTrK
         hoYYFpIVz9L+8oW2Uy5iHK/9o/hwiXhffE0OUo0ynrnMvPAdgAh2hgVNB/crDrE80MeK
         MneYtdYvf39Gt5Sd6NRMETXhD32emnmTMtehUmFsiAD2JqMMVvWhZDAz6Dkj6G+1Eq8L
         wykQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTqVCUoodClCQV5nJTTxTreNFrRGHtZ+ldEf9Xztzfkh+4bkPiTcFbxQSqed2gfSy5fA2VGNa7yQMBlA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKF6cQ8svSW7LgEN2ezE6/Mvs0w8KQ3GgDOb+qxGpk0bdGrfIo3
	U1vdhJOjU0nE3NbXM/2EtUBedA4PTVNL4BD76Wcn5h5OEW2xVOovKyXjhg+vdTfdNnMktvSNwnT
	vG25X7cNNGQ==
X-Gm-Gg: AYBFou1sOWvpfxj0pAZ/84j8tT1S9tyxkfeqxpbfFX9VIqESeb4Mg/cZrGfyW8JULzO
	D85anPQfNC35LAwboLtGayECs3a47P6Krrt5qZLMA0EVZ76iL5aAi5qQQKRneN3SlkQnvS0ynw4
	1OIQrBavEZ7hoEVEFunHF8AHzd4pqbDrTHSTb9fsfWEolGqdGk9akdAKQeK1c5x1hP0Ghm0Yxu8
	KF7xsDZpHCptqSmX6MaeALTj5KE6/mehHPdp2BuxMftaZN82xYzHBnd8+YCe95nW+XENnPurlTv
	8XMmor/7C3fG7RW8O1wv1KGcaxw+PHe6OMVa/EmL9pzNZ/oLJ4/5w4njZGSNyU3avm5QT7XAqGL
	Tqx3BHBvp7sP72BibDbh/44QmLlaYNEemi8ZPkHavwwcuf8VBxE3AfGqAw/3V8qS4I/HbuVcUNq
	11pk9KSyVM2xa3CmnpG9dCfcDHNeZV4viY1Dtt4eU8Fd0seAQz4tTUZSMHr/IYBdDkqQFN4RiMA
	kEn1KwSjCihFHdtBm2/AFpyz+BU43JFFm5PluzqgIUUrUjJFsCSmmbC1KTKmUyQCrUZAmOJ2Vqp
	tHjqId6vSkUHNRCW3HNzKA==
X-Received: by 2002:a05:600c:6dc2:b0:4a3:5d64:e063 with SMTP id 5b1f17b1804b1-4a7c4c7e93dmr87769765e9.9.1793173851270;
        Wed, 28 Oct 2026 00:50:51 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a4fc46csm1876135a91.7.2026.10.28.00.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 00:50:50 -0700 (PDT)
Message-ID: <8ac505b5-cb6c-46ae-8791-c39de5babe66@suse.com>
Date: Wed, 28 Oct 2026 18:20:42 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: do not leak -ERESTARTSYS from FITRIM to userspace
To: zhiwei.liang@zliang.me, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Luca Stefani <luca.stefani.ge1@gmail.com>
Cc: Filipe Manana <fdmanana@suse.com>, Robbie Ko <robbieko@synology.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/28 17:27, Zhiwei Liang via B4 Relay 写道:
> From: Zhiwei Liang <zhiwei.liang@zliang.me>
> 
> When a suspend starts during FITRIM, fstrim can fail with:
> 
>    fstrim: /: FITRIM ioctl failed: Unknown error 512
> 
> On a Fedora 44 laptop with kernel 7.2.7, 3 of the last 21 weekly
> fstrim.service runs were in progress when an automatic suspend started.
> All three failed this way and left the filesystem untrimmed.
> 
> Since commit 69313850dce3 ("btrfs: add cancellation points to trim
> loops"), the trim loops return -ERESTARTSYS when
> btrfs_trim_interrupted() sees freezing(current), and FITRIM returns it
> to userspace. Since commit bfb670b9183b ("btrfs: handle user interrupt
> properly in btrfs_trim_fs()"), btrfs_trim_fs() returns it right away.
> 
> -ERESTARTSYS is only valid while a signal is pending, because only the
> signal handling on syscall exit turns it into a restart. But
> freeze_processes() first sets pm_freezing, which makes freezing() true
> for every user task. Then it walks the task list and sends each task a
> fake signal. The trim loops check btrfs_trim_interrupted() after every
> extent. If a check falls in this window, the loop returns -ERESTARTSYS
> with no signal pending. Nothing restarts the syscall. On that laptop,
> with a few thousand threads, freezing user space took 2 to 5 ms in each
> of the three suspends above, and all three runs hit this window.
> 
> Make btrfs_trim_interrupted() treat a freeze as an interruption only
> once the fake signal has arrived, i.e. when
> freezing(current) && signal_pending(current). freeze_processes() sends
> that signal in the same call. The trim loop stops at the next check
> after it, so suspend is not delayed.
> 
> The restarted syscall re-reads struct fstrim_range from user memory.
> When the device phase is interrupted, btrfs_trim_fs() has already stored
> the trimmed byte count in range->len, and btrfs_ioctl_fitrim() copies
> the struct back unconditionally. The restart is then asked to trim
> [start, start + trimmed) instead of the requested range, or fails with
> -EINVAL when nothing was counted yet. Skip the copy_to_user() for
> -ERESTARTSYS. In all other cases the partial count is still copied back.
> 
> Tested in a VM with pm_test=freezer. Without the patch, 18 of 20 freezes
> during a trim leaked errno 512, and 10 of 10 restarts after a
> device-phase interruption failed with -EINVAL. With the patch, all 30
> runs restarted and trimmed the full amount.
> 
> Fixes: 69313850dce3 ("btrfs: add cancellation points to trim loops")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Zhiwei Liang <zhiwei.liang@zliang.me>
> ---
>   fs/btrfs/free-space-cache.h | 3 ++-
>   fs/btrfs/ioctl.c            | 7 +++++++
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> index e22443598b..cba2f5fd6b 100644
> --- a/fs/btrfs/free-space-cache.h
> +++ b/fs/btrfs/free-space-cache.h
> @@ -58,7 +58,8 @@ static inline bool btrfs_free_space_trimming_bitmap(
>   
>   static inline bool btrfs_trim_interrupted(void)
>   {
> -	return fatal_signal_pending(current) || freezing(current);
> +	return fatal_signal_pending(current) ||
> +	       (freezing(current) && signal_pending(current));

What if pm freeze has began but a real signal is also pending before the 
fake pm signal?

>   }
>   
>   /*
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ac070c745b..b02c59cbb0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -529,6 +529,13 @@ static noinline int btrfs_ioctl_fitrim(struct btrfs_fs_info *fs_info,
>   	range.minlen = max(range.minlen, minlen);
>   	ret = btrfs_trim_fs(fs_info, &range);
>   
> +	/*
> +	 * A restart re-reads the range from user space, so do not clobber it
> +	 * with the partial len the rerun would otherwise take as its input.
> +	 */
> +	if (ret == -ERESTARTSYS)
> +		return ret;
> +
>   	if (copy_to_user(arg, &range, sizeof(range)))
>   		return -EFAULT;
>   
> 
> ---
> base-commit: e17e64baf63f7c85bec209ed73f14c1b2a7e39fb
> change-id: 20261028-btrfs-fitrim-freezer-d4cba16e7e13
> 
> Best regards,

