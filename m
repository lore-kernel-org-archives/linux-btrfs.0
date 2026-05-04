Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE2F38D6BD
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777936608; cv=none; b=gmwMq3gGx3nvWbzJgJYovK2RhvUYWwr5EkjkIjpqru4PMRepb81qslTjkC8+irl+WwcVIj02Ws9HTCKgC/xK+S6W52/f8+WSEjfDVlzt95G8Wr86PC1b+unFX74NvldrUYHYLLrFEppL2QAUDhyZruG7toZZGdpOSkWUCW9n1gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777936608; c=relaxed/simple;
	bh=GT+NVb9IzNRl7jv5sfO58xbxSyRh1YQjk8rTr0vA12I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=FjXlA4q2B7Cd0bbUwex0vLu1M00f8ldFBte/I8Vri2w0lmgDyuGKudQxcc3/RxxRkMrWVUQjXQvbFBvyDJCJ9jCJW6vblsvVf3PXv/od+a7oeK8OxqF1aMb0P76LfF92yrUKf1At8BvTGF06MCIt3RwljjmCixb3UEtQ9GdZfP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FO/KQ5Hv; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO/KQ5Hv"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c796163fac5so2844085a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 16:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777936607; x=1778541407; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kVVCTflPQBR/6MOOzvGW4z3v1drFnoSJzIwzf+PfZh8=;
        b=FO/KQ5HvEMiNvaU9BmNQJtLmKuxftS+qvgDVEPWn8KK4i3C7nuW8MLCCye8X2XZcdV
         2fyCPYksM/Qwdrb3Z3kcIDGASC1T/BixaGkn1kZcXKBLsfGK3gYi5MadNXqGgcaXp6FN
         t2w3IQvom1qRbJU1HoTB2o3AG/3ZZNTMoL4/ifUSbL7Fw/yTbqwKOvgEWMHyuV+uAjjQ
         px4uFwna6PaEkBnOXB+t9ZATJNjCT/z5GWj3BgtVgQGjvrAuZK4KakLkkJPAkQbkoc17
         j+HB6Zu6Y255PXSkwZ7XlSmx9XE1CQiTeelDwg9zDsTtv1FRUOsncxoW9veWFqjVcr2g
         msdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777936607; x=1778541407;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVVCTflPQBR/6MOOzvGW4z3v1drFnoSJzIwzf+PfZh8=;
        b=kOdx/RpQIGyehZ7en93E9UgTcQ8k9yidMgXkJokOXLf43ANvJrlVbydenjiT/zBV5z
         TEgdCN9Ru3770sQ1NDyumsTKuPbfGJYxk0BEL59x4dFIsa31nvXX8DA6nptEXpLtmVgX
         I+bpD5XANWyyqEW06/0R2SyfoVnecNE2OPT6w0OqElmHyttU9uxD091aeF48psIV4Pok
         Q4WzvYiQdWS57SEcHU9lsjt1E0JTY5OC1yni5U53X78Bm7l37UNkk0uDggsel7hFf9Dx
         3cqQF5psAyq112MgjqwbzBXN7DXjO5Gj3VXzpTO7XXANRGTacGolQGHrLpVr0VLa52/1
         BacQ==
X-Gm-Message-State: AOJu0Yz63EuTz2URu8qpb+6lC3voyqCnp1Gp+0FfS+KEEU/mMivnaoBE
	JV70hmOITzLwI09AhseftDSU7So5Jh6ve7NmT50xEAjkyagWjrjfe/Xt
X-Gm-Gg: AeBDiesPiwNSP+udgtJMY/IQ6bX7x2b9KJY588RyfbORlZb1MFfhKlzTnAi93np1PyW
	28R/sKrvOslkVIQDToAFHu7YUcuuEK2choWuzjMciCUh26GFWGhCkko4sNOwDHsxmWL6gSrQ4c0
	xFfmRgXHy4lzm133tRYDvJNf42bjoibwZfsSkIrOwGdIBoL3beX9yqrfW8NrWVa8Wrlgu0BzZ9W
	LQ1uYKv2so8sKNR6jH2WWpsz2jgTYimjR2kgnras8V3SpbDySMTaIa45cVgJ2spuckCoUK2Ddm5
	munPC3rWB9Z4A5VXRbHwqwBaM64pmUSxdywcWfeu0MyFLQZf65xRtdVIbO/AcISEvccYcr1z3jo
	lMPwWPczHinnKoV37Kq4yGmNR/YKlUVHzVxRGw5LhIWyOgc50We4Nr8mDiQKwSckTJFO6Y2346Q
	WvjatVVz/HmEvfZYGXf06Rtv4OBf1piNqgRrZ0H2c=
X-Received: by 2002:a05:6a20:7350:b0:39f:a42:9247 with SMTP id adf61e73a8af0-3a7f1c7bdb1mr12722832637.37.1777936606990;
        Mon, 04 May 2026 16:16:46 -0700 (PDT)
Received: from [192.168.50.119] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839460a0423sm209670b3a.33.2026.05.04.16.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 16:16:46 -0700 (PDT)
Message-ID: <3cc304b6-0069-4cb8-b3c2-a15d0365cde3@gmail.com>
Date: Tue, 5 May 2026 07:16:43 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] common/dmlogwrites: add _require_log_writes_sized
 helper
From: Anand Jain <anajain.sg@gmail.com>
To: Disha Goel <disgoel@linux.ibm.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com,
 ojaswin@linux.ibm.com, djwong@kernel.org, fdmanana@kernel.org,
 quwenruo.btrfs@gmx.com, zlang@kernel.org
References: <20260427122551.71696-1-disgoel@linux.ibm.com>
 <7a5a4c7f-2c1f-4dc8-b2ef-b052b62798dc@gmail.com>
Content-Language: en-US
In-Reply-To: <7a5a4c7f-2c1f-4dc8-b2ef-b052b62798dc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/5/26 05:53, Anand Jain wrote:
> 
> looks good.
> 
> Reviewed-by: Anand Jain <asj@kernel.org>
> 
> Thanks
> 

sorry, not yet; I'm canceling the RVB.
Details below.


> v2:
> - Renamed function from _require_logwrites_size to
_require_log_writes_sized
> - Added documentation comment clarifying the parameter is in KB
> - Made function call _require_log_writes() internally to avoid redundant
>   calls in test code


 This change log should be below the Signed-off-by "---"


> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Suggested-by: Anand Jain <anajain.sg@gmail.com>
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> ---

... v2 changes  here...


>  common/dmlogwrites | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index a27e1966..0925b333 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -14,6 +14,21 @@ _require_log_writes()
>  	_require_test_program "log-writes/replay-log"
>  }
>
> +# Require a log writes device of a minimum size
> +# $1: minimum size in KB
> +_require_log_writes_sized()
> +{
> +        local size=$1
> +
> +        [ $# -eq 1 ] || _fail "_require_log_writes_sized: expected
size param"
> +
> +        _require_log_writes
> +
> +        local devsize=$(_get_device_size $LOGWRITES_DEV)

Please keep all declarations at the beginning of the function.

> +        [ $devsize -lt $1 ] && \

use $size instead of $1 and

$devsize and $size units are different, 512 sectors vs KiB


> +                _notrun "LOGWRITES_DEV too small, ${devsize}KB <
${size}KB"
> +}
> +

$devsize is not in KB and $size is in KiB



