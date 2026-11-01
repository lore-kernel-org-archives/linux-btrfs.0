Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793521641;
	b=awleVwHYTjm1dRGyoY4lhvu0Jc5wLEPRk9+Ta3fbkuntOf6q5tawO/DBXwfXcZtvOnsi
	 nihbHVcfyxXG0ExJyU6z2zcBz8Fbn/KiJT2kEizEtmGyOfBZ9zwEDIVhlR24lPn1t7lHc
	 lgKmUeZ1xGRT2wiCo0UMr5046eO1hz3nERhX20+s4JCjmbKxNKRqTiNZKFZK+41DX4lla
	 /HyyEdDucU8Jabm79ufsroou5bTqzSnosCCMvjqdznHKkhPynKCcFIZ7xFLqZuX3ISR22
	 pV2TcQR9U02XWQd/baTRwscceywwqcpzr3yI1uryo4q3W4GaZqx1NPAX/rkWPKvvRMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793521641;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XwdvPeJiKid0tT+YAWUevzD66Nkkjo4l0j+JdiEgufE=;
	b=JfVH87pfIaOHiy5VnwzH0gGKcnr511TDH+++S58xEuFelERV7DGcSiqlkIzZZvuSoJgE
	 IXnoTKERgvT1Srh6wS5yHoO7P87X3+ogWmmuu0GpqORPaaYZuwlbWPoh0ILnm2NeCSuIJ
	 3atDyCIIgDH3/6kTqsPZTAIza06ek9MF7byHJmNx+1CobYutMd7rB4dprLMC3DZAekJ5i
	 8uMu+1efJkf0De15tgEds6u6ogM86VhR3M4UJ3eXH3ijyN+nWL1pLQPXOKa+lXL3+WojC
	 GPlpL1aX2iJB2GueqdDOxKkrQYDsyu/tqRsprWfW+j+Tc3DoNj0yETyzcuz9jAiMPmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=THaXowKC;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59361606A325
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 08:27:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59361606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=THaXowKC
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48dee593f18so1755199f8f.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 01:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793521640; x=1794126440; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XwdvPeJiKid0tT+YAWUevzD66Nkkjo4l0j+JdiEgufE=;
        b=THaXowKCn/CICT1iamBR4C6KvTapCVOq3VYNMA+LWNp9HbHigsp0v7S784sZYM53Pj
         5Oo41m4SF3OikptBHNILcL/mgBAe80I/Y7idV6a/66yslww5I7VXtSIfwKbCEPAbXl+g
         eYoZwOoy2kxZoQyCsMgCY83xLNW0UiemOQ3uUvItqy6ADNGwfi8IRsxF0vJJqkOXFDsf
         vk8WD75KK2c5rQJsa6W8zP9F93hey8rTeOz4jygxWKrox+3BxOKiSE+NKc4bc9g602XF
         VME5qNWyYZRTKFkFEyymsVAb0dC0Vr5neLiaTGVwgRM/lYsMW6CLeWsu/pRs0UkYBTbB
         ezhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793521640; x=1794126440;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XwdvPeJiKid0tT+YAWUevzD66Nkkjo4l0j+JdiEgufE=;
        b=n25SW80yH2RZ2VsWCoYNikLf0By9a6PvSh/5RKOELNcRMZfZ6d4DEt1+HQNNXv/v6a
         rtMZv41h3olnnw4JXBukuXF+yngBWWtDUjkUhkbDaFMqFoG3Nj4G7UYRUBRhEx2Zyfor
         mteMe9sd0GspXRgHWxMEP4ttxDKDFSIp41FvLVUYYKL45SrdqCqQaNbbeSzPRobUL9ZW
         GpBOjDpDJhTvC4U3Lh64j9Yzww9+bkflPkEmDy6c96G/F8mFRG7eSCXgVAMP+XsxpRWc
         hbkbp9zuvjVNPiB9o/8RwHM7DwAVndoLd6DwWhnl6RLvFvESPlAu+ZxR26ZsEYCeBIfY
         0kXw==
X-Forwarded-Encrypted: i=1; AKwUvBwznerIWM4JebAVeHzjZLVzl7yyNnuvXfFTleWZ8/315iM3YrySwzGO/4NibyqZoyNjCOakGJagiiaSEQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIfZZ5qiAFyFbaoPg1pIfQu002GclI0DcGcmrFpA6hW1vXdKnDG
	7PXM1xuac95KDZMwOQDwCuv746ylVm/S8tMSINlGPGj9xa9Sp0+WthwE8MoXGO7mxpU=
X-Gm-Gg: AYBFou3YtqnAIZ88qb9IMWFRwmJD6V1oDUQ/yB1lioGZix4e03KClk8HVaBJ9s60UB3
	W2gP/BUvOL7QDxlxt63QC4EbAnk6f0EWujqZ6l3ZVROiZlmPK3Y38oLgqcFCZYLHPazBUEqx/G1
	VjYM9V22hCyTCtzKF7X2rs5ftpmWNvfNKiRC2Tn34ghhSRhEP7ejtcrU6Sal/8loCmDP5SwVyFT
	JR8EjnFrA+T+rdUbwcVJSghmHqPNIOZPuQUngiyMguhNckXXfVBGuG2AMGT0bqBO+Ql17+tXoZn
	cq9PDjRyMa9biHfsamMA+EKiP0MVx03k2JsWG9AEgIvscq97p6ZJf8m6vKnXI5ej69R5h5pPYKK
	Q5w4qRmB6SRHhX8bnEGAcrOkGzzJJAE6gp3FQ25nE88CKruVlTJPrdHJWcHhceXKlIkktgf5qgC
	ogtcK+fMd72wCKEPbb4t7yJn/itxw1xEnlWnKRqHjSRULqkZ87BzK7tMCP3LgnnrhES+tdcieGo
	ehBxA3fhsW61IpstZR5MpvwydcCI7hSkbfKr3afd/9eoZkZ82jQXOfPT4NlQXSKZPSlCY1ai79v
	pOHODuOul+uNCZJFGYqNh4IeFcYiReAwfpRoa9khUw==
X-Received: by 2002:a05:600c:6087:b0:4a1:fe26:24f0 with SMTP id 5b1f17b1804b1-4ac1765ce52mr153859635e9.20.1793521639667;
        Sun, 01 Nov 2026 01:27:19 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42935b4asm34278128eec.16.2026.11.01.01.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 01:27:18 -0700 (PDT)
Message-ID: <9ed1529d-3b4b-4b3d-8ab2-a84d902b6621@suse.com>
Date: Sun, 1 Nov 2026 18:57:13 +1030
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
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
To: Cheng Yongkang <teel4res@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261101062539.1744605-1-teel4res@gmail.com>
 <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
 <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
 <20261101073317.1867816-1-teel4res@gmail.com>
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
In-Reply-To: <20261101073317.1867816-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/1 18:03, Cheng Yongkang 写道:
> Hi Qu,
> 
> Thanks for taking the time to list these.
> 
> To be upfront about where this came from: I work on automated bug
> finding for the kernel, and this ASSERT was one of its findings; the
> analysis and the patch were LLM-assisted. I sent a fix rather than a
> bare report because I had the impression that reports without a fix
> get little attention, but I'm not the right person to rework
> SUBVOL_SYNC_WAIT and add the btrfs-progs support and test cases you
> describe.
> 
> One data point on the return value: in my testing on for-next, waiting
> for a subvolume that was being deleted returned -ENOENT once the
> cleaner had removed it, with and without this patch, so the success
> path is never reached.
> 
> Since the tool keeps finding issues like this, I'd like to ask how you
> would prefer to receive them:
> 
> - Would a [BUG] report with a reproducer, the tree and config, the
>    trace and a short analysis be more useful to you than a patch I
>    can't take further?

Yes, that would be preferred.

If you want, you can attach your LLM generated fix as a reference.
If it's really some simple fix, one of the co-developers will push your 
patch with your fix.

If not, we will address it with your reported-by tags.

> - For low-priority cases like this one (a debug-only ASSERT in an
>    ioctl with no real users), would you rather I batch them, or not
>    send them at all?

If you have hit more than 10 of such ASSERT()s, report them in a batch.
Otherwise one by one is fine.

> 
> If the ASSERT fix alone is still useful, I can send a v3 that only
> replaces it with -EUCLEAN.

I'll merge the v2 fix with modified commit message. You have no need to 
resend.

> Otherwise I'm fine with dropping the patch
> and leaving this as a report.
> 
> Thanks,
> Cheng Yongkang

