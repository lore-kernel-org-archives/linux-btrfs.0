Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A239C648
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771940505; cv=none; b=he7Jelc9YfcZp+UEuSPd77HQ7WZoFD8a5gvR+8KFaQbx5qcTO+s8G8l7Gix2Qr1MxRMCKjGmkmeCjCWnpEWrWB85Kt3XUZZB3C8TAE2alq9e8GtmvOuxmimyXNf2j+iD7Lvqenjz53h0hcKVpWq3n1NNqkWCzGdn9f0q0VoVXWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771940505; c=relaxed/simple;
	bh=x2tjq5rxzE6T8u50wg2gQvEnWxNlrY8iJGxwNTs9h+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=j/d+Ze6VhjkWBdPNaT+rFybMDxTG+nPsADHWoQQpuZMjdqEAGvUGgRsCZFRhlTSnYa+qmrjxAhJy5ghtwWPK18tuP7RZzxD4V4e1vrpzbIMmISEjkSH/9XuLjM9Jhn1Pk7Ex3saTJP+BbRWW7KzLVITDWYgf27BuRpEtJdvfya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=go9zVcaK; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="go9zVcaK"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8230c33f477so2390198b3a.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2026 05:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771940504; x=1772545304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x2tjq5rxzE6T8u50wg2gQvEnWxNlrY8iJGxwNTs9h+Q=;
        b=go9zVcaKbkWWY8ZVcHnLHM2jZn6Y/emP6U0lZ1hzhIM57HNUIaQxILIEOu7ymzK9sY
         oWAckuLbaQIl9KU4Ck/yqr7g16ujQ78T9HK5ZlJlINqTlPmCXPTH94jbaBp1PJMjLcwp
         A+xXXWWm/oni5PgDp4B5VfN22UMTJNyzZTjMomH5azITjl/16vc8zc4CN2rZNPnSQ4Xn
         b0BB8gAY6+arXPeoZxZCw1VdZ5dYAeIesRvJp0hYafQ9QtIyX34R9rLs8L6yx84bozpy
         2Vu8FYuehc9yaCqgb5mpjmV7Zd3ZzCYTZfrbBUS7rHRtWspzVnI77KkFGULpgm1p7cgN
         Jmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771940504; x=1772545304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x2tjq5rxzE6T8u50wg2gQvEnWxNlrY8iJGxwNTs9h+Q=;
        b=dEXx6ObaDnmH/OXefoMS1w3rEcEwNmEoGKRb9qYnGtoJm4pG42M8FHkpSiU+E3RUS5
         1i0DXp+OK0k/uTFIwRLymzdwHKnXEKyIU9TBDRCnOxY/Q8/hbzKVkS1D93XBU5pzBold
         cGxKxppSu6ZbDJyAeTosnRvSCLIgyEdgvFrZ7k35B7jx2EQ33/TC+9J91yPcTyln89i4
         AplyBKlcaezvOtWPG1d0nZC50SybB2ukIhcW0LZ3sJrL/h1xmIZkBqd2QT5iAxsFhg0L
         k5vNBoZiT3mAc5HucXMJhAnPcKw0+QRWTZpwtyQ7fIML8ANmHNjbF1bzOLAkFrkJu4L2
         uGiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1jApLi9f+3xpQibXl4uuqseRiN5d/XBkfvKQ/V1O5Vz/4XwBnAaz8vWxwSr9Ni3sxD07CExoSnaKnYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwL2HZZkLfgs41sU3mnYZHC3vt3R0xSVryT0NjaFzVJnnnNikQJ
	twb1ofc5pGSCYsxXtY6GCWz8k4qWq+Cv7uMQsFiiB8EP5Iatx4Fu7aMwrksKJQ==
X-Gm-Gg: ATEYQzz8GpRVfZLEJNTPXFcYEEQYjj3hVG83ZG/iVFrYASVjD3CEHpiR+90kU+wJn9e
	zQDGBKbuiPiPQ9zp0xwU9XPAzbhy2Oxox9CMr1AnZffq+8Fa1dQGK/iUUzfmQZSo8f35gu9okID
	g543xsBAkue+fGEHRrlYMCe+46S5Zdw33naGAZECE97O+4s6WMVQA6Ke+6mAbzAwzf9Vq4GfWVG
	sk/5f0U5BjGFqH36XlRcqhmNycrx/oBzBMKu6HSBNvMZJjnkYti/35wSfjt604AzqZ+RlJq9+cZ
	fBSqYQ1chrb9SdwC1HslUE/GIQnudigzlMR8iKvLRmglSTOt2Oj6Q3cxYzmRw72h877ZXqyrfYO
	M2IceDEmHMu4jp64XlvI6KV79qI4JUKZb2wpaGl3MgZDFFlAlhjBTye8t7ssNcj9AkIl6YGiA+p
	HOo7vHByc2wzA71nTz5Y9o/GmdjaI=
X-Received: by 2002:a05:6a00:148b:b0:81f:c6d1:d167 with SMTP id d2e1a72fcca58-826daab6d37mr11544183b3a.61.1771940503595;
        Tue, 24 Feb 2026 05:41:43 -0800 (PST)
Received: from [192.168.50.89] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8bc0c8sm10220304b3a.54.2026.02.24.05.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 05:41:43 -0800 (PST)
Message-ID: <92829df2-8c66-49eb-879d-0fbc1cb178cd@gmail.com>
Date: Tue, 24 Feb 2026 21:41:40 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: do compressed bio size roundup and zeroing in one
 go
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <5d98d50379077b98164f3b962ada7b0526e1d4bb.1771544612.git.wqu@suse.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <5d98d50379077b98164f3b962ada7b0526e1d4bb.1771544612.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Looks good to me.

Reviewed-by: Anand Jain <asj@kernel.org>

Anan

