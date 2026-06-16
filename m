Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C888379C59
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 06:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781592097; cv=none; b=Xxj2B9K9zu+BBLyPD/mqyXpL3cjp2c1RS7m5s8sdi+K88B7ALltUPxYXSkf7P9+IzddL9o98khi0Q7GaHcqeaYRM70w4LMVX/S8dY9QiYLw+Egm9ARk7A8js9knvC6GBPLCz2ABwMvDwuO5Pv9c/zVifV6l+s5q1fLUR8JOz0gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781592097; c=relaxed/simple;
	bh=I6XMLzW/6+8c4TqA/LAUv5SAqeOKUTZsUYSzU+xLkiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZyJNqVAQHd3pqnSO0aL4m4tSitdiz9t7Ft1ipVDz7bzHz2EyJEyiJT2X6B+fqaDi+UfEuIDGsRVjZ7j+0cICt/PC+4d63iGOC7VLXfVf7iJ6F/C5KUTb9RAz/W0w4YdE6JYpuCw5LuXfiC2zu5lWV3t1EG1ay6c9poldH7zVePk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X92UKoY3; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X92UKoY3"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso30820955e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 23:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781592094; x=1782196894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=andD6MOT9rcRhNzHJ1rQ6R2UuRVgvxL8U7GBv1bd1mI=;
        b=X92UKoY31lyCkLtb8QJHTAmqz3zbTRTyK452yLSYvwFCQ0aBUZ/mIkqHyD9IfINPOh
         4WXU2CcDjCs5nO0QWvN9q41uWDxfIj4Tbtm2McDv1nW1yFrMc9FrqWD42qVf0fJSF4M/
         v7V6yN8zG8pa71gWZPJpW+T3c6FtErH01e7IB8PO3dKRjB8xZ1U+I/zQGDyR4rkuyLeJ
         eOaeAXFliA0wNefJe+RWb2AfBN9SHtFef3DqYpCo1LZOJLKP9xTyMV5J6SKQ3xwyMmRk
         7mWc22HWudLCOwLr4/0sFqb/ioUp2m2G//tDqoEUrSB8LEVg6UuYO16bqlckcc/aulqC
         Kl/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781592094; x=1782196894;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=andD6MOT9rcRhNzHJ1rQ6R2UuRVgvxL8U7GBv1bd1mI=;
        b=dMTxRScwN3Z621FP0hbyNk41UABapZYN7A+eKux+wJPZfkbAvB15GDIsLF/ux2nil5
         0nsT0qwMx4I/DW5nNI1sDKMyZFB/X4wbvl5bFC+gkY0JrD8iET9J0wj5hajDfA3ehuxA
         OnOOX5ieHfmA4gbE2Z8XYcH5lT/8zp6YDJaJhND/KCLREEApoRYzE13VvY9zQJeXssn5
         I6jiGCJnxK6Dbt8dq75nA1amQJuwX6hp6ff5fhHJK6ariiDv95DbKQGtBA+XbksIb/nd
         XoRccBetSq4qb4KGQZcBmfUNSbOHIIfzvsOu16UXYv43OSmYGQ6oGdhcyCgixqPRA48H
         UHEw==
X-Gm-Message-State: AOJu0YywhTRbtbfIjCuespgJ6vB6xXkJtGQToSYZCuN5QD69ou3qmVWG
	ZwbxyYgWYFt1GuxaXhKIcykciqzdhfFgB0KO3yobCM4qRGEsy+EuHJpLMB8A9VO1CtI=
X-Gm-Gg: Acq92OEavsSNOvg8cwXCWNA/km4+AlqKxfPAZvPXX4XvUKXZ91CMIc+GtdbDIxQNAvQ
	l+d0cCf2GWqvP0Fm9SrdvOhKibUZgU61Fc1467YJwNcbYG8on6QcCknTcDgl1DWiAb153w2BPdJ
	xevsOaWFWIBhk7urU2+e4j5BVQfX6HiYFjHH+0zN+wdhaoSnA0BVrfWNHLBtaK/D4l/RST327vW
	/0awS/Dt+4X6gTSoq1goxBvqnvRxQgx+M/KU9bZIRmyACoEeRNvNgoTHDgmBvGs5Nhq/2WPUKAY
	dN6ClXzZgPAVuHPHE2LqN5LRTSIiqRVXovbwgoNicUUpo8W+v8klUzSYTYnx975eTUt0tLDgM+6
	bAQarTzxZroxvlba5uVe6oKZj61637PXF9Vsx87l0WbdgRKD0bxvuF69uGADdnIXHKAN6niSVTP
	/D0qtzjitrWLghaMH/FlT4OP0tfBfpEVuK7BtWoeWk38zOWnhHzfNlxzDS/mRwN+dCE5UEHPG2M
	izJmvSdd2tZvjn/LeR1OGa0LmtALWd7JZBLvtsCQM8bIX4YN97R/no3
X-Received: by 2002:a05:600c:4fc9:b0:490:b446:fb8 with SMTP id 5b1f17b1804b1-4922ff938e3mr34370175e9.11.1781592094431;
        Mon, 15 Jun 2026 23:41:34 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-379e84e7011sm7772024a91.1.2026.06.15.23.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 23:41:33 -0700 (PDT)
Message-ID: <780847cd-3fa7-4b17-af33-0b84bd125cbc@suse.com>
Date: Tue, 16 Jun 2026 16:11:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: re-enable tree search v2 ioctl
To: You-Kai Zheng <ykzheng@synology.com>, quwenruo.btrfs@gmx.com
Cc: linux-btrfs@vger.kernel.org
References: <545cce1f-5da7-410f-8ef2-9779e8864b43@gmx.com>
 <20260616062200.2010804-1-ykzheng@synology.com>
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
In-Reply-To: <20260616062200.2010804-1-ykzheng@synology.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/16 15:52, You-Kai Zheng 写道:
> On Tue, Jun 16, 2026 at 01:44:11PM +0930, Qu Wenruo wrote:
>> Structure btrfs_ioctl_search_args_v2 should use __u8 for the variable
>> sized buffer.
> 
> Makes sense. Do you want the kernel uapi header updated as well, or
> just btrfs-progs for now?

I'd prefer both.

> 
> I checked the kernel already casts the buffer to (char __user *) in
> btrfs_ioctl_tree_search_v2(), so only the struct member type would need
> to change there, the ABI stays the same.

Yeah, kernel ioctl itself is doing the correct type conversion, just 
need to update the UAPI header.

Thanks,
Qu

> 
> Thanks,
> You-Kai
> 
> Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
> 

