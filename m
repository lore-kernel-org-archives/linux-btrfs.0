Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E605729C35A
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776980754; cv=none; b=DnurBgqjGvIRk/AZRIzTnyOhz04bZAaPFpKqNRWozdMu8XI+PMfot+pJX4zJdEiEATk5yY6oA22vdTfUXstuZ52W8E91V1YJdSMeAgW3E2/nac/AYphTHrFcLkXfI0BST5RQ/y4kDRMJD1VgicGy0Ea+NsrR2x8/pan/kxqaJc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776980754; c=relaxed/simple;
	bh=6nQvRmI+TPuGE6uHsYY2sbeILe7kznzJU4x/b3xBbh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HKUlXHGic9xzWbuI56RKsuBJbEblnFaZTBZRYr8mYK6/HWa0SNR0GC18I4gIBKFP1RsjOqvDPy4Larv+w0gpJ/5FRaqQgLKqINPbVKl8b422jxTsHHMzQKgNY/nM2V2UqrvuRggoksdHTwfcMuKt+nIqSdJmC2iXoSpVf5v0rco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EwFArHKS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EwFArHKS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso78056315e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776980751; x=1777585551; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kdm0JqH0DZyhHeqB+h1U3uSwammapocfUUpaJmk/3cc=;
        b=EwFArHKS/RP8z9DfjWGM1bYw+SRBvXFvi6iGAsT50EYsVj0ZPRnz02c5Jbc72eKGWm
         KSgdqD7ItkJ96rI9kpQ2MgUYigDeXKjl4jWIGohS0jI5ZH1dua9iEU0p8sYc87LdRxcZ
         o6KlKNevOHMyqTnAvyEY4iQc+GAqQXpcUWmos63BI1VMj4O+hRkPLoHGJMM+Wt73pkHd
         qKa9IGcV0wO1I5OQqAZH+Qp/8CC30ovNCCiCf5oMmUtmiQ9N7F6opTWCrESPggiHHsap
         WiuH57loAMw/Kus0EzUL4J58UUt+zX/K7c2tCmannNf8S759Upf2MgrGsJc3imZ4UEZO
         qa2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776980751; x=1777585551;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kdm0JqH0DZyhHeqB+h1U3uSwammapocfUUpaJmk/3cc=;
        b=cfvyjoESXvrjg7GTu8M81eqDc6le1RLtXm0RPzsllgYva3b7YnT6/8bttM45qSJEyX
         db1kE0RxzrWs8bZ071Wfyou4oRGGqokPUXHFWe5FpM/dndQVFcU2AvOZESiP0+IgfvrS
         MD4vMX5JijodIqyOqaI/j0Qmk/UJlywWr9wDuzpIvl5KIfAZddj7Fq3LGc8NelFttT7G
         ATTB8SrqoQLyCPU1jq5j7oUI1k8Ekb9B2vNHKUzHT9HuPSxtG1ftJuyn12Zz/yB6gQvm
         8Gs47uUATo87ka7bMnkVc7d8peJ5X7wj6uifV6AeW1mCcSC5sw6SgzhhgUZa61ZM81LP
         TYxg==
X-Forwarded-Encrypted: i=1; AFNElJ+H38DkWHw4FGhrxm+Spf3MfVxqO2UDqHjTocZOP1DK6VSa1ATqX0UKy0/logB4e8z0DRe/cZaZRsz6gQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6cc72Lb301UtlcxnXA8pmmUJsOHS03Vu6BX/zK3B4ljCJG/q2
	00cwwLQ/O+5rLpA1zXP5+mXdd8rKvjPAgIWe7nlPfOrBO4MqrXLegFGXqIvr8MUIOhtBio4aBR9
	YzXeLJ4A=
X-Gm-Gg: AeBDietSb4vGQpHT7yYv00saC2zs5VVwCk6nOwORykAt5Fon90EaA5oWVcP6pZIg0rY
	AgIfwxlfq0QYdXSLfIHQ0tGTwpr6FCun+OulKQY3a2XeQaZ5qZnRvDo5LIekTiQV7IDhfgF6ggU
	H51pe7WrMJWHSitQF42a2ALMkXvJTKG3MNs0Qsu96ZT6Bzhgi45YVjpCCBTlQNnM4NBEMiH/c8x
	egx4RMDmkEo6YAsV5uCQXWT7tXdsL5q4t3fIng6NzABS9XLWEq3xZOvcR72wYjZmreEsmW0+aJE
	hkLf6Beb/ZFtchJMOkKuopnHAL4gpycCl8cHU9QiwU5C0ZWO1K4agDLVdAg/DbnbaD8TMHy7WoC
	FJKiQoYMUgdnr/fH7ScQDouTe0PZUebFq7pfwJvSfg3bVVN7Sd/NdZ85olxOUmtmiBKo3cYgdmc
	Vt2xtl4tjgl5sXdnWeQ0xZtlfMWUWKlMusNinNUh38lcAkwSfmU6qkE0kbTCBoQw==
X-Received: by 2002:a05:600c:4fd1:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-488fb782a04mr417394725e9.22.1776980751266;
        Thu, 23 Apr 2026 14:45:51 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976fa40b2sm15233027a12.13.2026.04.23.14.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 14:45:50 -0700 (PDT)
Message-ID: <a5a6e1ab-39b9-4691-99a8-c2d4c40f794d@suse.com>
Date: Fri, 24 Apr 2026 07:15:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: change return type from int to bool in
 check_eb_range()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <1a69f68aedf5ea12277401b8ad5d0a17a3ac4a25.1776952936.git.fdmanana@suse.com>
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
In-Reply-To: <1a69f68aedf5ea12277401b8ad5d0a17a3ac4a25.1776952936.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/23 23:33, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The function always returns true or false but the its return type is
> defined as int, which makes no sense. Change it to bool.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/extent_io.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 2b0aec031a9a..0597b0041aa7 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3983,8 +3983,8 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
>    *
>    * Caller should not touch the dst/src memory if this function returns error.
>    */
> -static inline int check_eb_range(const struct extent_buffer *eb,
> -				 unsigned long start, unsigned long len)
> +static inline bool check_eb_range(const struct extent_buffer *eb,
> +				  unsigned long start, unsigned long len)
>   {
>   	unsigned long offset;
>   

