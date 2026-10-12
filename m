Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC713ADBA5
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822784; cv=none; b=ADZ06TS3t0udDhq+yoIR0wbtMeBJyyrR9QKJ7q1cjwGHX1G3OPAVVq/m710uzji37AnLE12RuwSO2V0hbcjzZE0J1AMnsXEMa4EclyHQ+7Z0yLSGU7retkejGbULt87z/Qog/GVMY3FDtY8dEBvWNBi0hOV/rPGUo5QHZQ9NDjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822784; c=relaxed/simple;
	bh=LMFg21ea/HRdvWr+H0MkJEaf5T9Sro/gkMGlzvdg1MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ByIUCp7uBG5GDwyCYjGqouTTNIUM4pdVM5jqh9WbQf5GejEeYDqxOTLk4qiF73YjmAoe5GyNfkVnBzrIJS6+GuVocYL6qGLkUCExoSGDyro0pL+HOe0IkgtaGyGMFOAdat62U3cc8+vra4IuioONR/Pg3gLGTEi4GmLksthXj04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CRtq0FcH; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CRtq0FcH"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-14394530ec6so1067677c88.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791822782; x=1792427582; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NRiPvD4kcSR893VSUB5l9+rGNh0y4KbElZYbWs0AB+s=;
        b=CRtq0FcHOhSNaMjTsS0MHnqfabWmh8BZ0EXnouz+y2UVt4UJTDG3l5b3Vx6DvGQsBd
         lP85KT+PZKqPDQAsPXr2Hsh86yHUpi/f3YSFRF/rlgEGLglFLMYsFNKrMRYN0O2PX/3f
         BJ8AmrFmD8Q7eKfS2V/MBkk5MeDM4HZYE+PknH9qonV2aKfjO2Vk6zU+T/lUnb42GuD9
         hd6KJZyyIrXIERNNc+8y0oMTKOaYNWO5SjPjHAX3oyK8YuZz+heBe/bL+8xBBBE2Lvb3
         nHZZaus0RqYO+13eWs2ZJli8/RieyTvYrropmQY7LsudwWHBANz1T8LWT7tr+R0rxIQT
         G+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822782; x=1792427582;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NRiPvD4kcSR893VSUB5l9+rGNh0y4KbElZYbWs0AB+s=;
        b=rqQA5AoojdbVaH4XpVUwanwgwLBsjvcS3wPJWdZAbfQiBMJMmlTjelQVESD3oRBSLO
         E1nTCcQDnit1dsu/aTzsN3Tof4ONJ0hJ2uu40TfAyiFHUJTmVlWKnH3ETDjhEFnTxJEY
         VVvkYq1x8B8hFTTcytH0kQ/0woQQtq2bJNgjAf8KDyQi8M1SH1U88XdVi6tZAodRCH9c
         cqJHZIc9iKu/ci3DPZmpHiyBlEps0yTmNW0QNkRpldhSosLV2OAnAUAOLG2lPyw8UYEX
         CA5j1vRlip5nnpTuruYDcupxUeuh5JZYGMi9lWStRGI9qF+kL6Uk2XUXm+7ywVeqCL4x
         9iGA==
X-Forwarded-Encrypted: i=1; AKwUvBxc4TYZOIai4JxBaRojCNrpbMeAcomBCt25VqnoJGJbVkKdGSefinNa8CYdjkqNVTJZa4/oc4jbcCXs1A==@vger.kernel.org
X-Gm-Message-State: AFq9FYKjyeLrpQEXk04HGWnNlT1f75MlGwOyPy9Z2UWebMkjFHgP4Gdk
	2toKOZvyXmCqK+RcxyAOO93xdb4Ww5SfAY1R13wyl9alqemxDQQf9VlyYrwk1qUgvOM=
X-Gm-Gg: AYBFou066BdkFF1uRBclksbishaQiWVa6HrPZD1U2IQzHu6IIZHzQPOsS0WF8g5J2Ad
	TKVUU9hsV91OX/DhjrECeB7mfsnWEZzJke+cFmYHRHYoOu30oR3uP2W4tz3bg6qGkXLuuK6Qgs7
	6HjqeJk1UiPE5Dz9xSuePCMXoH7VVLwfGDJaFh/N9U/mHpCFB6tNQBQLfp/X6O+esBfBVnsfgUy
	l8TFPhsMUNakWhguBp09GdURDBXOdCHdutBl6lrxa1gqVvT4E8J7XIQHzPFcYAvVHNEt9E/YOBk
	c7Ry43y599pK89wcTFm/W3VRWFYrybVU+WhzQ9ZWrfvRXBCpHiWj5Hz/zwIiMVVao7K4VKgoUE3
	+GjM6pLuPCh613Re8Pn24w63FBWXU+Z8tW142d0r1HbpIiYgIfZ4XvCujPU6eViXnPqshfwi2fr
	l3wKiF7jFX2c7gISNxbtj4hHIMxVhwen3FANjjcDvT7++QebkhNlFIKLHjjun5WE58Ns8lGa2vB
	TC6D6M+5MBnRwl+00QJNRR85RyFHHqFt7R3amK57z1Ompo3R9tO5RYbgETGLp5UmFIMr+X08l/3
	8zJJQ9sFpTeM1AM=
X-Received: by 2002:a05:7022:b0d4:b0:166:780c:60b6 with SMTP id a92af1059eb24-16a5fc91686mr13865643c88.9.1791822782053;
        Mon, 12 Oct 2026 09:33:02 -0700 (PDT)
Received: from ?IPV6:2406:7400:56:97af:5038:b049:4f32:e620? ([2406:7400:56:97af:5038:b049:4f32:e620])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a32eb7ebsm36603339c88.12.2026.10.12.09.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 09:33:01 -0700 (PDT)
Message-ID: <75e589b7-9a03-4f23-938e-e1b9ce5bf01e@gmail.com>
Date: Mon, 12 Oct 2026 22:02:57 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <20261011222613.10793-1-wqu@suse.com>
Content-Language: en-US
From: Dhruva G <goledhruva@gmail.com>
In-Reply-To: <20261011222613.10793-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12-10-2026 03:56, Qu Wenruo wrote:
> There is a bug report that with the recently enabled large folios
> support, fsverity enabled files on btrfs can trigger reproducible
> warnings about file corruption, but in the end no error is returned to
> user space.
> 
> It turns out to be a bug in the btrfs fsverity integration, where blocks
> not included in the read range are passed to be verified.
> 
> This is a long-standing bug where btrfs fsverity always assumed that one
> folio contains exactly one fs block, ignoring the fact that btrfs had
> block size < page size support before fsverity support was added.
> 
> Add a new regression test case for it. The workload is pretty simple:
> 
> - Create a 32M file
> 
> - Punch a 64K hole for every 128K
>   This will limit the read bio size to 64K, which is smaller than
>   a lot of large folios, and thus can trigger the btrfs bug.
> 
> - Enable fsverity digest and drop page cache
> 
> - Read that file
> 
> - Verify there is no "FILE CORRUPTED!" warning
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog
> v3:
> - Disable signature verification temporarily for the test
>   Pointed out by Dhruva, as it's a user configurable behavior that if
>   signature is required, reading the file without a signature will lead
>   to an EPERM error.

Thanks, looks good.

Tested-by: Dhruva Gole <goledhruva@gmail.com>
Reviewed-by: Dhruva Gole <goledhruva@gmail.com>


Regards,
Dhruva
