Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536D339446D
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791823615; cv=none; b=s9xIwhGUyV56uY+JLEjunOSNsGMtjDo2cX3S+kimVtUHJPXAacYJxj9tSLO+cRfpVoL8xHfLQz1eF0p6e4PpCg+aiWflMhfcWIhvH7Ag3V57x9yrLV1K1gC5sgaD5PUJv3/rxrTfiwEAaSbKENjP8z6Qnz8GDvSQrC+Kde5ExsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791823615; c=relaxed/simple;
	bh=WAMRkCfr7H5QN6A4aQbcqsVChqM0nwv/H92TRsaVOlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JkDFRrQrq0212WEI5GUA1hKn22qUn30WiC65lnHwh3ADDeZ/JRiEPQ56oaHE83uZEKxh2ZW1gC1I3kXG4OiN64IV0cXC4MqjN0ajxjERFYn98Mka2i0ucwJI/Ms2HJOVXpXZjWEqnQKM0oKctoYMMSYc5920N4xMW1ivos4Qk1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8JAGs+q; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8JAGs+q"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-353804b591eso3500711eec.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791823612; x=1792428412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EfiNe+XyA8zhOMOl60OM1lT0ru0Yw38SRDVvcZ2Pv9w=;
        b=g8JAGs+qkBzqRG/EKXX54kowehahV9aUOVgycQZzcxnutRdEgI9w3ybGXxbzreyupi
         TZtVJkIK5tD4ZfQAf5fdTG1XDPsZTTuVVho6csyfcqjGm1SOSosLPKScob5orxGPoJ6d
         khq0kt3mydVBT/ytcB6fB8z+4Kd6UIs7QWHrXkH5InXzt5CncE+7t0sKKcJRFqIcvmyJ
         /OmnoDP0BMr8nIjkizDSxEMWMr1/fdikDrQQFR5kWc8TGEQ+v6cCpcpDWe/TgdZaouIF
         ilsj2Mv3OA9NT2AabCHpGZiIZQPGgH/1pLizW67ecNhtc+QO5GwuiwDAqzsMkedN+pOC
         0+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791823612; x=1792428412;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EfiNe+XyA8zhOMOl60OM1lT0ru0Yw38SRDVvcZ2Pv9w=;
        b=YxnMK4pHaW6eyhGov6y49yR84+zam8b7U1bd62xQrwpt889MlKsCYvp0JrDdvpIbVk
         ovhah2h+33DMqlgIGxXsGNBM0BcmomPcawf/NJEK+IngRaoqPYVbi54pcF2tfPxCRGZl
         zffBo64M3xjbZF422uSWGmIzq/lmRJYH4dka0YuYp57pa3KMlneq6v8YpsnTjrQm5AzV
         iJ44Lb9z7m7vyc4nP31ItyK88OGC80iBRQ2gaj2V7kqJxNrYJWZMvBmtKsgaGi/WfMPm
         8VUqjj2AaqE/rTVjEa3EA/7bEWtnxpNKt7NO2xKEK+U4nRvOirTVPlHgdqTkb81F5mYN
         LtYA==
X-Forwarded-Encrypted: i=1; AKwUvByNqUCP8rTc74mpYCerny10M4n30o48P7JcNvVynsJzsk+SdpiGY9XfLOejKSBu51k6Zi/zseT5wHh3NQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKZcGAE6UUqcMrsI/CLCOzzZ19NgyrUoRt3sRy2rHb6mPKZM6Jq
	FcLSqfmkUeaW7qA/O44Y7nzHIBK4H0judckYBfe/JJrKisJeDzuBPaWE
X-Gm-Gg: AYBFou3/udWF+DIJPfJHn3OxPc++yve1N0tD17PRMG3WptGnCnRg5eVaLen446bUQzU
	dwoeDC2QDx8I6cJZr4png7EAyOU90n3WVLrW8IN20TJdrbCQcs20DZ9jjhKEd/geUNOKrehj7cO
	jbWPNXIqTjXT2zaDm4FggFtU5nHulJKZzIK17hxHIyP4luK6d8NmAGZ8xsY39VUhPxSptxxXHMp
	bAoPcV3nou95pzdpU3+TZgLOP9tvwi12vvSmFtGxCOJXdaqRv6mKRPZ7fKgjRYfSLMs8jUFsBh1
	TKVqsmqC1v7wet9NH60lkDmKlS5F3vSpUL81FDVl/mkSGT0BD/9CZ5uuUo3qyTpcsitD8p15B81
	x2kCNyS8RA4g4dPiZCOSHfIg7ys/nMyw4uaSXc7gstOyMHKrjp8ukkqv5D+pbCT81FfAEAdlM14
	kQR1ll0DhAI45lhB2CEqdgxBp5Pw9IRk0mIeGK0eUqLkYOAJ4OXC1ZkJjUffbYXlpXRhyvI1ACR
	arHrD5PuIqIRxyfOP4errrcUVi86oujRGIXHdr63hA9LAUUDK8+QfvRfQFL6SONo5s37PTsiogp
	kz1C
X-Received: by 2002:a05:7301:1603:b0:351:1e89:66ab with SMTP id 5a478bee46e88-3537e03cdcamr14286574eec.7.1791823611968;
        Mon, 12 Oct 2026 09:46:51 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:5038:b049:4f32:e620? ([2406:7400:56:97af:5038:b049:4f32:e620])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca329d9sm38195439eec.5.2026.10.12.09.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 09:46:51 -0700 (PDT)
Message-ID: <6fcc096d-c049-4a72-a33f-54aef6151a0e@gmail.com>
Date: Mon, 12 Oct 2026 22:16:47 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: btrfs: test if btrfs control file rejects
 unknown ioctls
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <20261011230716.16860-1-wqu@suse.com>
Content-Language: en-US
From: Dhruva G <goledhruva@gmail.com>
In-Reply-To: <20261011230716.16860-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12-10-2026 04:37, Qu Wenruo wrote:
> This is a regression test for a recent bug fix, where unsupported ioctls
> are not properly rejected for btrfs control file (normally at
> "/dev/btrfs-control").
> 
> The test case itself is super simple, which doesn't even require test or
> scratch device, it just run the "btrfs_ioctl" program using
> "get_subvol_info" ioctl on "/dev/btrfs-control", which should fail as
> that ioctl only makes sense on a mounted btrfs, not the btrfs control
> file.
> 
> The error will be outputted to the golden output so that we can catch
> any unexpected success.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/359     | 26 ++++++++++++++++++++++++++

fails before the fix, passes after it on a local x86_64 Btrfs VM.

Tested-by: Dhruva Gole <goledhruva@gmail.com>
Reviewed-by: Dhruva Gole <goledhruva@gmail.com>

Regards,
Dhruva Gole
