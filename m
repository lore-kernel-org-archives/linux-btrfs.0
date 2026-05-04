Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB23A19C553
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 04:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777867323; cv=none; b=K/4vmHggGekOJo8HnoeLJawgzTfam8CLESRvIS3fkltamJq36OrwchnI6rjw2+7hd1r8PkKJ9k75RUi9Gcd62M7rBHvob4blO8zqtZqHGDPGuUA9D1sssDCoM4KY3/zXA+8OPAMi1DvbUUUha5pmdb0fMv9L/fElW9fx+uIkXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777867323; c=relaxed/simple;
	bh=3P9PTGXQEqceejzlt4oB6hCgg6/9NoHPJVWEt1XjDfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4cX61UmjNYSNablIa+0ZgPYZWUQNOnWrBiFirMI5ndMXHTdYqdgMg+B35zUnhCaL+ZMxbE+7cE8KhcneE2yX+q5/9xdC7JjAASCJG4c9L5VH+CZri6P7E8s5ICG1VhznYCZkIex/alwz49Bwmd0pq7dwv4IL5l3SWeljw9IO6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZtVZ5+6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahR74mpf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZtVZ5+6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahR74mpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+5Um6TFBnBOiuOAmXBNCCA71a07CLbH3rgRCp2jTGs=;
	b=FZtVZ5+6D9hakk6rkrQTKVC+0gkXMp4hGqBw8wDQEP0qTTHHv7DtojvTaRwoT+8FaLWrE7
	YzRUepCFi3/iQMrAw10/QE5vk0wiYvJrGFWL4clLRsMEhnHlVr5LWti/MP6Wi3EVOm2D2j
	BJ88Jt8vN8tcQHrMZgEmlaJvlTl78eo=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-o59aswNkPgi1DuT24CbCEg-1; Mon, 04 May 2026 00:01:59 -0400
X-MC-Unique: o59aswNkPgi1DuT24CbCEg-1
X-Mimecast-MFC-AGG-ID: o59aswNkPgi1DuT24CbCEg_1777867319
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7bd5c9e1826so13042977b3.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 21:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777867319; x=1778472119; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m+5Um6TFBnBOiuOAmXBNCCA71a07CLbH3rgRCp2jTGs=;
        b=ahR74mpfjikES/sgx6xLa/BlnQXifJ4h6HXe6qLXrKtEC+bL/gABxFJjjNfMC+/5/+
         nLzFjIYylBjQS6n19zZio8rwBbMNlVLjdJCyUuOPC4QnmMrzjdclBu7n1gQoAspU1ceb
         tTrQOPRRr5ZBbRvkiy1c4gyyh7HMuhVAfJf0cW2ewvvT5HWPyI2ucfpBcTGTJW4YoYrK
         Ciqn3wQbO6iQaR3BbY74WB2sf/sIWETkuMl5SDK/HhynLdPK4WMSldCyOr6+DnDEiSc1
         mOAI6eEsXjYjx5x+CEPn1RhuLqLNo52XiK2DxOB3sebtOzUgUWZeEpLkszuiyy+lDtF2
         lDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867319; x=1778472119;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+5Um6TFBnBOiuOAmXBNCCA71a07CLbH3rgRCp2jTGs=;
        b=RE9WLfV9DPTqHcbtAALojvQmeN+noDeUisKCKJZbt5YJE/H8hLlhi6A4WOeBL+cdWZ
         oMZiE8GJ5wpGUZsb9hOcVXUqTJxUZAROQac1yyN2FnXGbbDzB2v4XETyOeWtdijwYTYb
         rRi4RrJVZ55kY6Zdgv0hkzMF7BEmdgMmuVMr9vYhN5c3sqGjOKDD1C/2jy231tfPaJZ+
         EjlkK9U4dH1qXTukPQOPVPMJyCtWW7775BerTSENH1FZqhawIrRZUmWgn5R/qmbC9KZG
         zncL/nTZAz+vycKiJeG0XnXCTsQtKrB4psD1Pgt2afX8HNFd/MNidr38R6ysndf6bNLt
         FsdA==
X-Forwarded-Encrypted: i=1; AFNElJ8xmlRo7UX7t9BX7l5hTvc4XjLdToJUshgat26MF3mCa/BvLbG3Z0Tm64E7vGzGHak5P1Lw1xwd44VkNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfJjQZhMZPTsbIQQHjVLy8OuUvfsiO3Bitt5XXYQnmanWjEdE6
	sEckyKzuX2GbwKAGS6aGKQVJjFimeo7Z8TI9ROKuPHUACPHq6bcjd1JBYbLC2RsGO2MZMlv3EiL
	OauMHVRKn5GuFTrHwDgKbRQqeQ8SM4NCtbxcqhNAHAnxS8a1dXqdW2v5T/0Dqv3ek
X-Gm-Gg: AeBDievoWe5Fkawdlfjh8GohlhJCQHKkOKdP/6QlA/mqfvzeaZzRiT0j+jDgCzCxMKr
	9RQDujZk5xfBdWE6Bisxre7f/iW6VsDHkxc4uDnGy7Lb1qfh0o7kjHjkCC0xGunBizXZp2QXNLl
	HWQcfMc2xYtuXwaGiCpMock4+wkAf3WfVFOA8pCSBaIxe+3Rt7qkqG6+mAjLojayYP/sd4Tl0dP
	6LqOx6khu6YNQ2IapC50XbMVwI5NdTeaQvZNjo6K0S40HR+31Vgy00DEnTXeb+1Ijb1DPQIAlL+
	VCU+C2rw1L/efn8Zd5Krmvuc+6ocVhn3PrfYf256Jiihb6jfcCQFPPpGtbdP4OI8J/+Bc+5Z82+
	AMbfi9HWgG7EOFQ7f0uhHClgxkQyNbXL3t+Cp7tMZ8GWM2CzUD2aEx/o9yyJIotECrg0=
X-Received: by 2002:a05:690c:289:b0:79a:b440:5c8d with SMTP id 00721157ae682-7bd76928ceamr64734367b3.11.1777867318937;
        Sun, 03 May 2026 21:01:58 -0700 (PDT)
X-Received: by 2002:a05:690c:289:b0:79a:b440:5c8d with SMTP id 00721157ae682-7bd76928ceamr64734087b3.11.1777867318535;
        Sun, 03 May 2026 21:01:58 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654e464sm44456777b3.14.2026.05.03.21.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 21:01:58 -0700 (PDT)
Message-ID: <0c385b67-035a-4f66-8f3a-febd68a9318b@redhat.com>
Date: Sun, 3 May 2026 22:02:30 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-1-ziy@nvidia.com>
Content-Language: en-US
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429153538.727855-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/26 9:35 AM, Zi Yan wrote:
> After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
> khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
> support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
> so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
> mapping->nr_thps, which its safe guard mechanism relies on.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/Kconfig | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e221fa1dc54d0..27dc5b0139ba6 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -936,17 +936,6 @@ config THP_SWAP
>   
>   	  For selection by architectures with reasonable THP sizes.
>   
> -config READ_ONLY_THP_FOR_FS

Yay its gone! Thanks for working on this :)

Reviewed-by: Nico Pache <npache@redhat.com>

> -	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
> -
> -	help
> -	  Allow khugepaged to put read-only file-backed pages in THP.
> -
> -	  This is marked experimental because it is a new feature. Write
> -	  support of file THPs will be developed in the next few release
> -	  cycles.
> -
>   config NO_PAGE_MAPCOUNT
>   	bool "No per-page mapcount (EXPERIMENTAL)"
>   	help

