Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C33A3E4101
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789310163; cv=none; b=thB5M93IlNzQvOf3wt3vqbuem2edgVX5bB7RtuA/BLJhzEJs7LJyDB9+bCE5h51jNe4TbiVBFc5CvnZenW320ZkIfk71/kwVTH8KCL7JpP5MVyKiRNWqhDv97e6z5niUbXSMtY5Au3jkOnR2YFlijibSd7BbnMleI/ZvyBY9PaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789310163; c=relaxed/simple;
	bh=sKmvlsl3MwscDA2LdyK9KsuUO6obfh5bMh+6wTXyUg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Rno8xG+7QIcn2mJWIK5YAxHmdQgKV/bTtvhgZbKeyrBLAOJRiUMgqaSOX1+pqpE+2ByUwBlHH3rXYyFqRZDT1NTYdPziEFpjBRuF10Eo240z1zQpQbZhUvF7+iZb5XVIUQzubofY2mWCbwb2vfORpx2PueKS2fudoNqZHIMjG2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FReULYkh; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FReULYkh"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c264788fd58so170405366b.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 07:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789310159; x=1789914959; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sKmvlsl3MwscDA2LdyK9KsuUO6obfh5bMh+6wTXyUg0=;
        b=FReULYkh9Pu9gewJDAoq8BTOqyrIzA6OjhXV7UQ/Y4LwrdYFddyfdpv1tUEL4Dj3bs
         EYfw3Vw5IXZ1oRFC95GBBF7saMTjIsztbmUA1ez3UKrdzzSS6GLJs7gbBm6XSwcPJssy
         bthvULhlMcGqwayHVKjmbL4D725h9Rf2JUuBgQzO2VwbVkW21GihBdy+LNNiHhLG+smr
         1nb5SFZQNCQOeNsGXOpAnKKc28k/4kBLa1kgiBYRi0GLXlSodkLDRwE7iPGdLxVZntwy
         otKorW4s+KLWhnEP1MLf/Bwk1j4GxRud1XgGdUU0/Px8SGwvli2VJIfuTnk41owuuY9t
         Omfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789310159; x=1789914959;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sKmvlsl3MwscDA2LdyK9KsuUO6obfh5bMh+6wTXyUg0=;
        b=JWFcw37MG3uXT+Hrjfk96RE4cM8taIH9RcsUOpQCLKO2NUbfu1/64F6kGbMj7vxsfh
         Znm3NmQCfKKpUAJ4hecgXluYQLCwnS4ebbexX7+jMQsV2rDYTmeBbz9F92//Y9e1QM0O
         vN74Au//3geXAEx5lxc9KTDAp/v7I2mGeQq9rqg3h2MbTNHF1wNb058VxotrlTZfacDq
         td8nQ+IXvvx1otaoNi5qn0CtsxQE//K1CBXT5AdxM+FXGk0/DaJ+RP1rLgJ7K7XyFaTj
         au+E/T0mc2DPspwF1n6W6GefBBm54kSKBd4elVqvjJ8UZ4P3pbz4UmzKSz88Yy9+lT58
         y4yw==
X-Forwarded-Encrypted: i=1; AKwUvBwMQrjHw8yIUcl1yACtOAkLq+bP3/jGCx704HD2n7rmbnWnpAl/NrYQnXV2MaJsup+YeE/f8ywvrKxHfw==@vger.kernel.org
X-Gm-Message-State: AFuF++myC6a15jatP1VonXQm6wptgUE4ink20jOx7omYK2eJ1R6+nB9M
	x2rJNGtqojjJa4yhj4sNlH90N2vUr5zw9/tZmBFUV0r0WDBVmr3vnbwB
X-Gm-Gg: AYBFou2gWkieS1fOFig+2vt5HBtCCDBG8eCNt5wvGbFj/Np/rPz2877JcuJCpCIAMz3
	YRO7WtZoxFKDhZPxr07nLphKGTHOAKB+v/gCmBgxmIYed6ghmkgQO/melzi4WM4F7MO/DQEYdE5
	fU1cBceSxjpC+izCMkl/Oa6aFGt8FZfjWtMDYIuOz+kQ1jMTy+B7BzxAfFQr4VNnyPPqvC0hNjm
	65i8/jCV3hkUIL3Vl9P3C8vBkE+EcPZVTz+FHPjfyu/pUuXhMceONVrrLbQtwflk5IxQdq2yyZm
	TdmkLNfJf6b3+7djJcJP7pWamtrQLUIRkvHLpNOprk150gywwI8qT1+HI5LrNwq31487OWgOKGB
	ZtMT9aa2tahqZaxU8P0RCYvlUzKTOwcASQutej5U297CZxG9S2XN1EmZBR7e1Urg4B5iD3OpcYd
	1yjqaCyhUvHU8/ZqBbKL7s2JOryTTe8RFLsYePIEFJezgA4YyZ5DZ68YxWQX70/pDnynidEEpow
	3gQ7ZZL7N6YtGr0JEs=
X-Received: by 2002:a17:906:8f15:b0:c26:19de:9ad1 with SMTP id a640c23a62f3a-c29858ece73mr372426366b.41.1789310159249;
        Sun, 13 Sep 2026 07:35:59 -0700 (PDT)
Received: from 127.0.0.1 ([94.41.86.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660654f2sm298023766b.28.2026.09.13.07.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 07:35:58 -0700 (PDT)
Sender: <irecca.kun@gmail.com>
Message-ID: <9a889cf5-4e47-4f6f-b8ab-4c65b2f82e3c@gmail.com>
Date: Sun, 13 Sep 2026 14:35:57 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] btrfs: add "/dev/root" exception for device path update
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
Content-Language: en-US
From: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
In-Reply-To: <3e3164206d23ef991b9bd76dab6706238592cfb0.1789202516.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I confirm that this patch fixes the '/dev/root' issue for me. Thank you.

> To be honest, this is a user space problem: no one should trust the
> device path shown in mount, only the device number.
There are too many userspace applications that simply don't know/care about such edge cases.
I'll try to report the situation where I can though.

