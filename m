Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794297449;
	b=KPAI5XeJAbbFy02T2dw5hp/m+l/ju7PtQzqXKLygz2TLGGKJs76YWR755AIMOlqAcZz3
	 4K+VJaON7XTla1Hz4Z3p1EgHYBquXxblY723Gj52eNq15isJuPzGtu5iMfesQjET4BWlS
	 TjiQ/1pwIMmE6mDgvUbyV6ocJQfLg03eJCsOBfwMKCPlP7kNOtb2lvf5dOfJgdvMG2vjc
	 n45dfc1pjbdHhD5yRLUamoOhGoS6MDkHYo2FNpVMNbAKWajzVdUoXXrcVC69uDpVawFU0
	 w9hrmAMfQEwAk3aHMDqG6pQbqrn4qnOgqAgHspD/4pkVqFRqT/EgTXVMKiFRZhammxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297449;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=kvgBqQ8Rj9cy9B+tN+4CR0iM/xWv6CD5W2iAULZkH8o=;
	b=abcEgnbxB+MvkWyFRhTCR0pYQVEZCdBLGz0PjbqIUrK+PHXMGj8pGGuHdM8YIGzhSmKY
	 oBvOF+M9d1A473+V7u1sBjgDmsPP0p92ilBYj9PoGiu1iylUEEwDc0qAaBRgQ6yBNvKg+
	 zreG/XHSoPxNdrgHiXfTGGgvG/QfS24L8YXI2MvTYTgwhPg8G7KqfEi43d3+NOEeNqkkw
	 4XAfxdu+6ft8TCfDOucSCzmQdV8vs9xFQZ1rjmI/gezNhA1D32NEDLRAzDekq6cp6Vy3M
	 R01e0GaRIvL122Pquy96Pink4h2rY6D+QJr5NFP2k8Ry02a/qhno47HVFhIFrkU+FSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="L/BCF8fy";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5490B606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 07:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5490B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=L/BCF8fy
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so10986625e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 23:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794297448; x=1794902248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kvgBqQ8Rj9cy9B+tN+4CR0iM/xWv6CD5W2iAULZkH8o=;
        b=L/BCF8fyao3MnHXE70qVmRX2Chn7ndBuSWiVjcOcZxAA0z8pJVxYEuLBOFG9bNnKYB
         AFvF3izdQb5IpZB5VtqUwsTRD9uCkA7Wieod4M6KXIqSZrPNxbpJ7lv12cAqkSEiQcs3
         jgOlk3eZPDkrz+bef0HHQxbEWU0zMlbm4ofw4EqmjZYOAY0lixa3Ez5jbyHkcD4p62W5
         HMpp+8IBubsxDeQJI/rTbgIhtLRcv7zQAmpo5T+rWbhMZnesIIvaUAAKYZDRM+KFAp06
         Q9tAfSZTY3nBUUu5xDjqxApvJzgkKSSVFFtcO7cJVLubBQY6M8v0eav5zFBBJ8a6iQSD
         byoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794297448; x=1794902248;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kvgBqQ8Rj9cy9B+tN+4CR0iM/xWv6CD5W2iAULZkH8o=;
        b=FFj+1c9x/OcklLK3kQwm3gS3qqmwq5emXg4hEn3hJ9pujvobCKRMpt6S+wgp5zG9pd
         I6URKDfnxdF/pX1pJPrnaHoucQYqX7/WKFwGWHUyo1D/JAQJa/2uDolllAD4yTvOJAjT
         IjfUkT+AMZ+/38SFLwmStE/XN6TT/sgz6yJsf7KJ4H0zzl80TM3CkcxxrARW6YLYg/Jx
         jqI7R+dqytNlTCjgfxBgE7/YOJzS+BYuhwxuqxv28EcNvnQGl9tROaF4tfm+NYY0U8tp
         bCUBrcAFknmFFq+1K6N+ElVCTMwvVJy9x7+F9OK/jHXW0AOB5pvnJ7KBJo6rZg7uBc60
         50bQ==
X-Forwarded-Encrypted: i=1; AL+hErE1i8TcdjXmjPdACK7BqYi5se5CmI1CEqnoCj6sD+dGQNJjvkwchBLLwCAy3wRpPPMRjpvhVdEAs6YLag==@vger.kernel.org
X-Gm-Message-State: APuU4Z+VQKHiMFpEo088oSPIHV9AtWNw8xgJ/8nfCJFfpC5WMBpLM3SY
	N/OLzTT+T7fZN3UqBzmchupLlzz4d9VlzTv4NU3i8LsrZ/4FJnD5kzrn5lWI+WPHLt626b8Mt0X
	/hczHdjYvRg==
X-Gm-Gg: AYBFou1+N5rknD7P+sra7lgRn7q1i9uR/JVXHs15ihWGmcVButceIhGMo0rC/ct6+ch
	kM7CViZDk8SkT8tudjo0mOoB1Qlx0fm9s/DoJppMWZbrByjXRc+0XGrWbjE9dmeHYNyyjqeOcqu
	wHef2n5RzT3Ej0u9/poftXh2gPP0HbkkJ7qMdFPv9ytH5idtGhXA2BjcdT1oP1l2NOzbm4sGeRy
	4bLJvNpn3mvTpZ9qw+rwQK5FNI4nmcyrs4whACQ9+vLwOZGJphDuiyZlraKNjqSD32dnG75w/WF
	pQtfkGEDjIwHiKS/wun63BFPDlgtRcgDMMBw+Ir3cvpobRz/R5kYG7Hb+6T/Jxnfcu/VswB6o/Y
	eluNLVcaZCMDduNqkfUr+7Z1D2XiLEtUOwJvtrQgX8h4AJh6HYzR1ATgCKMAjSuqck2Je3UoNDO
	Pu6uHiw8E1z1jbKiJzofK75uT0aTtSYGiySyikg22ero9s4jXKY3HwMhObLO6T9YP4KUIRHxuRY
	ydFAKm9/Em6o0xSEFnvs9pMeuowCDfg4HcH++aFZtv1Sb6V0eYGK0VHM++uOkhJufuif2447tG1
	aotes42DIdXt6yYaPFaoIA==
X-Received: by 2002:a05:600c:1c1b:b0:4a2:1050:aff with SMTP id 5b1f17b1804b1-4ba02341314mr32598395e9.6.1794297447594;
        Mon, 09 Nov 2026 23:57:27 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6a412bbsm6129045ad.2.2026.11.09.23.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 23:57:26 -0800 (PST)
Message-ID: <193ce29f-86f0-41f2-9c32-a2e0f8f4aba1@suse.com>
Date: Tue, 10 Nov 2026 18:27:22 +1030
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
Subject: Re: [PATCH v2 2/2] btrfs: raid56: pass REQ_META to per-device bios
To: Mark Korenberg <socketpair@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com>
 <20261106-btrfs-sb-read-req-meta-v2-2-71c1afaf5c67@gmail.com>
 <e29db0cb-2054-4894-958b-800d03ad4d79@suse.com>
 <f05b71b2a735d2b9d018c072f30a0b78@gmail.com>
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
In-Reply-To: <f05b71b2a735d2b9d018c072f30a0b78@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/10 18:05, Mark Korenberg 写道:
> On 2026/11/7 06:56, Qu Wenruo wrote:
>> NACK.
>>
>> One should not even use RAID56 for metadata chunks in the first place.
>> Nor we're any different from other RAID56 implementation.
> 
> Fair enough, I'm dropping this patch.  Thanks for the reviews.
> 
> David, patch 1/2 stands on its own and has Qu's Reviewed-by.  Could
> you take it from this series, or would you prefer a v3 with only that
> patch?

No need to resent. A reviewed-by from any of the known developers is 
enough to get it merged.

The first patch is already pushed to for-next branch.

Thanks,
Qu
