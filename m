Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FD42853FD
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777931593; cv=none; b=NqHMKGlEm3px2yU22jQ39alwUcZpskG+WDWG79P2/Z3PWdHFXTqLLp5P0KgwbnOPa2Ju+lAhwCF+w74vGU2/FI5N/TYNhS8h4IMemKhk6ObpA/6hGvgwe+i6KnEWrg0R0FtUE8o9OU/XQ3WdW1/t5Af+Nh0zFiOKTlJOeEMy5dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777931593; c=relaxed/simple;
	bh=Dnh5BL6xJ72ipR9U8fPo48Nov7Fjz0cNnckpLk8ffqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DN2KgNdlyJkW8vC14L/PXdlXUQvQxoUaYJkBDGG05mq6Cx1QCJQkLcnSvwAQGb5ih03HkySC1eJeEUWoMjxvfoYUbvIbbGWZuIlAmTxc0PmZK5KK1lUymbgHT4NVAebK1u9cRdvyr6D5XAnD9cXXn7SJ8Py84SK7IWxYxeKZBBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1kozGNR; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1kozGNR"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-364ef7a759bso2004059a91.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777931592; x=1778536392; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dnh5BL6xJ72ipR9U8fPo48Nov7Fjz0cNnckpLk8ffqQ=;
        b=J1kozGNR/TEwVEcoWG5lYsx7whDPKlO32BTdIKZs4FRJ4v7bSCDqiU5gxon9amNCD8
         8ADOX7juKQf562uR0RPyecy43UJTfeJ9W/jTSOCeE1Qg8PrgoD7yetguqm6DzNtwtXBI
         NeD5uATTrkZs+FZLxhnC7hDjzC15vVQlyA8pBeJCDnjHp3AZiq8amYRxI88AJv9lhcuk
         HiEEsRYn2huXjOa74MZqM4iARMDV/N302+c0c+0eON5E804GhPq+GYw45hAoDNbwSv6f
         MGWVVPwPnAF0nGcPi1TBtUoPqeP2CF2gqfH/TapEzg+vAuTfi+EQLwv2ua2Ey8FMOU/L
         MkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777931592; x=1778536392;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dnh5BL6xJ72ipR9U8fPo48Nov7Fjz0cNnckpLk8ffqQ=;
        b=MM2pP7jQGnHsbiP4NM6+9EuvIT73lKuMSNzEtv6H0cbIlzW4gpm4hfrYM8Woh3FQNb
         eK09oWNOlJH9Ak4f33FPz/jc5RFh/MfrbJi7Qb8vTjfND1ICzE9FaC1wX2Aeb9nOHnVA
         kTOW9wbCedDsBXDcRQ8OEwYb0cnunAzgNuSqxGrwMdo598KNT+7M0LoHW3aUYy7adWhG
         dLKLM8WLdM9Y3XBJIxisW2GczM1kX0Hs5+fehVSg+r7NKeqkUy8/eCaMgtkATwJlKeRK
         NLAJl6K4aU8RXub0MTpNcnAHBakSoxAEtEo43Vj7wzFtuEQJV7zHQ8yANVJEGt5XkqRi
         8LxQ==
X-Gm-Message-State: AOJu0Yz7faGEYoZzjpvjCd4/TYyGw3zO3kBzARdc79DyXBLAb+dHNlKg
	MWJppIk1Tf2K3KNmE64q/hElrEjvHW7KCRdmH9df0XGYk6HlAv5NiuJP
X-Gm-Gg: AeBDieuDRkRyK0amhhF4n9YiFUxvecilnuJYEi9JaxPnvmVyqBlRj+9RqHQTwkx+Num
	Dy0YE6KAYv++BdmUETpiN1cBqPSoww2b2+M4EZPQrjpe/LdCPV+muyyyywGGYwj+yy3vKL2AkMq
	pnaOOGCneDeqVbnG//5lbzH8ALGxGCvxTaUBj7OfkwRFsJJ43X+PKur6vl5KXsveDM7ehr2UcHx
	n4eM35HYIkpkcBjjX7Esn9ewWyD0hJMlNSUBUNnZe98+iiJg1/j0bBZy/O5lgCEahdLTM3hSjn1
	qUKS2dODTPKqCXhACe6bVhBpzGLcZVra4n10PRxNDHiu6RkVSnuoGzyzJN3LKO9RGP4ynYFVmRk
	wFkmYRPMXZyiGOsvlDBbNmTd2/kKYLtiRCv6LqfatY+QvNkY62piMJBYwhB8kgBHRO3SdxgONNX
	lrHgEcE71bwBXCB9UcfPx48y4nuGskqLD3y4K0H/Q=
X-Received: by 2002:a17:90a:d648:b0:35f:c258:a9a2 with SMTP id 98e67ed59e1d1-365729b398fmr943479a91.17.1777931592114;
        Mon, 04 May 2026 14:53:12 -0700 (PDT)
Received: from [192.168.50.119] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae3afdasm117093125ad.62.2026.05.04.14.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 14:53:11 -0700 (PDT)
Message-ID: <7a5a4c7f-2c1f-4dc8-b2ef-b052b62798dc@gmail.com>
Date: Tue, 5 May 2026 05:53:07 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] common/dmlogwrites: add _require_log_writes_sized
 helper
To: Disha Goel <disgoel@linux.ibm.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com,
 ojaswin@linux.ibm.com, djwong@kernel.org, fdmanana@kernel.org,
 quwenruo.btrfs@gmx.com, zlang@kernel.org
References: <20260427122551.71696-1-disgoel@linux.ibm.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20260427122551.71696-1-disgoel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


looks good.

Reviewed-by: Anand Jain <asj@kernel.org>

Thanks

