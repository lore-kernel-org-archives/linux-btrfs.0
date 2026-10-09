Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD063546EB
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579865; cv=none; b=jaIvSY8PuPY8nv8HSrsCHF8XhvUzbLjtwZr4EyzD3CvR+hYlEnGXuTdVh0WTGpP2AkRWipjGuGDMIq/BTq13fw1Qst2jPeo9STwO7NuSn1ZEbVnVslgCWBRiq3ebxDH6jSfpCEzFwnV3D3l9ajKD8lqxXQUfEQnkV5ISK35wZmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579865; c=relaxed/simple;
	bh=qN6wTt6esSVYwsfd775JJM+9/nreJkmrqFCaV4SlCAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uwp86JiwyiywoRHSQF/CIaBqaI4cDRKV3tObibXhTsbUUifNn4+/n2YY0DhPy+Z5cqubhqsVd+jBaZRMZArtE/BKqUAqhS4rrmM7GCUiMIvCLU+HutkZ1++H/HBu6P077wsEfSF4een2qzBZoJYf8oOtxiBBv2ezFH3eHrfTPf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PpgYCpNl; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PpgYCpNl"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso2114245e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2026 14:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791579862; x=1792184662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YL0mzFwQsFAIJ3BQgODpXdK53+kc5uCfH8dR9lXMlSQ=;
        b=PpgYCpNlcN6xqx4hSvp6+7G+ne44tQlbCxYqn1tOpkEG8g3Cii1NnmCG9dQ0D3PfG4
         5Yvjfzcmf5ac2chIUN1ChGDf8VkbEaejE0axP04dWoD9IBUXf02xGrQ/P5AVQFGeIgIc
         EALUWdjBiwNCzYGcUQQ7m9ZARvh+DszmV+DsM6Mdr1h4stqUw0TPnf1uvWcTEt1qN/Pr
         H+Kt/HsglHSjNdvbt2VOfu2gpLsqsmB4P9F9yD22ZDAAX5zLOITjeU8B+yX4ccf6/TXf
         kZqSVbWXrRTAdSbBfF8IlEw0TmxPqTgvoBzkNWQNd2ri85qh/6XryTHXO/tj51meY4vx
         w6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791579862; x=1792184662;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YL0mzFwQsFAIJ3BQgODpXdK53+kc5uCfH8dR9lXMlSQ=;
        b=gjXt2v4ZszgL+Nxrq45FqyEhZuOVSoIFR2ez9VpnPc+5uVXIUcIuEbOhl1oS4W9df4
         AtosILXUS8580JBU0Uc9txyr+bYue26j1DLdVAuGnbGkDqfh5PIc99c7YXwoi9t89enK
         fHehLQI9y0fTC6HhiLpDX+4sCFrK30Q8RriBVVxFZP9cd3VqgvLQkJzEdYIumt/kMzS0
         WhxjVLf+V0pP7sGA0TLoca0yuRktnmiIrEOYhXCs2hv0f38JDjvxDbnklyvNQ0wTH72J
         kdJo1KI/qY9rivcI0DtdXv8Es/sRc9fPeaIgUUg00HvNUNUEAss1wIyEzv3m5y7xh0Zp
         Gwng==
X-Forwarded-Encrypted: i=1; AKwUvByg6eehXTL4LEt6h3RvmuCxXw86kH1d5OIPb1zY6TxV6TXWUBOAIzy/9tSte4Qlfu6lOyeuxcWn4q7iqQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nRNiEKdG0DGVQrtWVr2sTpHHMXH47/2W99TxDnkF07064bt412
	cpNuxwcngqIa2xOE/6ltRc5NkD6I++Vf/s4cLBirA6/sCGxYAoR5T/vSdzGKQJckGidAFUOOI0X
	d2DKNIuI3uw==
X-Gm-Gg: AYBFou0UGOySzE0u65qtsQXtmT8EwK5qn8DuCT0GVhCoH8sgOtsql7S5za+3A3EWFwK
	zjJd2XffNWgGv7BdAH0UHOmc/9zW63x4Sl2lTS580lhFnRpJtQsQeN0jHICvb8bT+K314afq4h/
	CiVrjnvC7XNgjEmt/HeR016ZVunzI6uMwHfMoHitGTEkK6AXYjLQhysUaaAa0OOKVIcm2KpX3Hy
	Q42FrImbkLKVzFZfeS11NlXu1LV6+DdEoossmiJy3mSh3NDTe24G8mgemXz/l4gw8sij4Zdu1lk
	5BWR4A/poziw7QApUO7fT7o4RQgaBkx1AORvkv8XJ20luv4gPnl0hllfhjG8fgWOJfZLfjxjNso
	nN/50NhoytfbZawJOiAed8jXmtoCmJM36RTcf0EgbypAu7IXPR0BWDF4XaSVulAwiJxwpfdjBkR
	VsZba1GR9JJh/PeLj1+97Y354684snecZPxVduRyVikW4lIkrd9tZnAkwcLCMIRTs=
X-Received: by 2002:a05:600c:83c7:b0:4a1:7733:5102 with SMTP id 5b1f17b1804b1-4a18e4a3fc8mr56932985e9.15.1791579861503;
        Fri, 09 Oct 2026 14:04:21 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e84219e6cdsm16113685ad.28.2026.10.09.14.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 14:04:20 -0700 (PDT)
Message-ID: <5f16e819-f9e9-432a-9544-9277c356ce09@suse.com>
Date: Sat, 10 Oct 2026 07:34:15 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: return -ENOTTY for unknown ioctls on the control
 device
To: Hengyu Liang <hengyul@cs.unc.edu>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Boris Burkov <boris@bur.io>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261009173359.3486877-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261009173359.3486877-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/10 04:03, Hengyu Liang 写道:
> Commit 5ab2b180884c ("btrfs: factor out validation of
> btrfs_ioctl_vol_args::name") made btrfs_control_ioctl() store the result
> of btrfs_check_ioctl_vol_args_path() in ret before it looks at the
> command.
> 
> However, ret is initialized to -ENOTTY and the switch has no default
> case, so this initial value was what an unknown command returned. As of
> now, every unknown ioctl on /dev/btrfs-control returns 0. A tool that
> tries a control ioctl which the running kernel does not have is told
> that the ioctl succeeded.
> 
> The issue can be reproduced with a simple C program, run as root:
> 
>      #include <fcntl.h>
>      #include <stdio.h>
>      #include <sys/ioctl.h>
> 
>      int main(void)
>      {
>              static char buf[4096];
>              int fd = open("/dev/btrfs-control", O_RDWR);
> 
>              if (ioctl(fd, TCGETS, buf) < 0)
>                      perror("ioctl");
>              else
>                      printf("ioctl succeeded\n");
>              return 0;
>      }
> 
> Before commit 5ab2b180884c ("btrfs: factor out validation of
> btrfs_ioctl_vol_args::name"), the result is:
> 
>      ioctl: Inappropriate ioctl for device
> 
> After that commit, the result is:
> 
>      ioctl succeeded
> 
> This patch will add a default case that returns -ENOTTY.
> 
> Fixes: 5ab2b180884c ("btrfs: factor out validation of btrfs_ioctl_vol_args::name")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/super.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 823a58bd2685..acb704b20c2b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2291,6 +2291,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
>   		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
>   		break;
> +	default:
> +		ret = -ENOTTY;
> +		break;
>   	}
>   
>   out:

