Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2507F387356
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775213347; cv=none; b=GXcvB1AYN8ASmrYMYz6HOJbsLYgSskngC/7+6m4fOwGllXsRDlCzYE3ynWulKakPefpt17gpQ5cS2NexV3SBVlbfgsVVSSWxrN9XDFukDaIXnEYkcgXd+bG89kImrR0M2s3kM7RPI4Jm94H/IQ4V7vqmPPQ6IRGkZhgZieamO6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775213347; c=relaxed/simple;
	bh=Xtdi5BlqVLE0OaRbJRntWIoOcvAh5l6gonT77/nJuUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hn0a7/HYixJlEu30/eMmO02ueihqzUUZZYN89x8w2aJX7CPi7c6KcIy91LF+tJmQtHwH6nPWhFOvyAFS+ejAypLcxl9f9V7NUixkmTiobZF3jHjKzklqmT/loFtVe9jVl1Yzj2Kil1FyBmZpPJoobHwKMO7Upd4ZNZ4dla1kXoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=meaIcWyp; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="meaIcWyp"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b256a4c6b5so10506115ad.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2026 03:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775213345; x=1775818145; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p6l51h1bf94du+h3yAsk0Khmp5cE8njVVTgmz7FA/Kg=;
        b=meaIcWypHCLGe9l0KDDTA9oOx0N3pPijy8X0b3aOvtq9lsTgnSI5hMkKnHA6n14O/9
         mfvAuSqK1FAEQLRkhmVr13na16+UEu3BZ1mccF6AFHPdlz9DhHpJCqU6OVclg/6aBE0v
         /xFxbLeZGMRsPV1zDC9i0meYkevMmRnHeouZSlHDv9QWjD33BxxZLMly90CAsSTIzOjo
         Ynbhvx1L6pZdtlllNiOzHezTbans1jjPoNi0ffPBAzaIyJnGTUl2KoIp+41VtDwQ73lC
         TLWACQ/g+dGDt5lr9z3dgxUqiMBUjp+tjgPV0ZuwNW0KqwkOcfxsRESS60/gh4AkNx7e
         5A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775213345; x=1775818145;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6l51h1bf94du+h3yAsk0Khmp5cE8njVVTgmz7FA/Kg=;
        b=LVtXq0loFjui3RWxIRA6jfMsanvRTrwJZUZzrFMApAYRGRuvbTb/7nSHDhrbuo5H0c
         xdqkvfc5XRTJWqrlVEPtNr0i58H3m5NALjgXEFQak2xj9wS1ZRJYkye5tlVD02iMq+tu
         UYZPxKJSHvkwDNp6AEEw6+b/MF6Tcu7FLq75+wEF5OheZqMP7m8PxijRqEdAzpD3/7HQ
         CMmJTbBimM3xFJLFs2ojlwVRcspPNV0PIy8g3PWOc194qydpZy4/lIq9xTKTIVhYmo+V
         UDC4DM5GOrmD5BH6+UxH2LEUWs1kSS9TGc4Fp/XOVNFkgj6ANzVmEEvn1Nf/N4RIyHhx
         7cZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwu2hKbwJLlNHt9YQMFAr/IJpFHvUvWdCS3mxWhEyVgLvxzGHHrYkh2wzbym1fPuTJWNVckZaI0wpycQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfgiNUTfoXXor8A7lIQwQtq503sXscbK8YIaUQswBY38stVm8y
	3dcxWfV1hovOMEyRJHnV6h6MngFRWTk1OfBkUU8cZYocK5uU4op3gS6u
X-Gm-Gg: AeBDievhPZJfy4GCWIIgWgDbiRcFzeKKLGVOFVO5DhvAX5iyYEGLVh955dibj/a8bTY
	XF22yH+H/akrrFIQDmPwq1TqNrsTr2LhKWbquRbE0TKLYswG4/tEP+od6GGf5TyIHOcUZdWtdpd
	wGLt15OoWVCJ1adNycn2KVYTl1SmnzGbSREXSxIp6pO52wksctfJXgx8pF3k9I48sfGCxsfecsv
	gopRxs/ry93/euwN67GL3A6+yuk4PklRy7Iddt0bqPwfyQyv1Vy+jPOoo0TQkD/FJVUgDghJ3Zi
	wXKGFyYvV1WVNOWlYVgY0+yF/lrpEmh4fwI/F7MFnwtKyn9AMcTPxwr9u4+UdhsRUYRaJM9sT4y
	MmL6pKIZnnQOtAKKrr0PKSndn752NWwy2Tg1D5excYugAhjhaQt7mKnDU44dJulrsz2fF97FSjD
	7GnkvnFuW0eZeIGBvALCNmDx7NZw==
X-Received: by 2002:a17:903:1a28:b0:2b0:c90f:449c with SMTP id d9443c01a7336-2b28163b355mr29077595ad.9.1775213345360;
        Fri, 03 Apr 2026 03:49:05 -0700 (PDT)
Received: from [172.20.10.3] ([117.20.154.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a34a6sm55590625ad.60.2026.04.03.03.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2026 03:49:04 -0700 (PDT)
Message-ID: <64f5f5b5-d44e-44fc-90fc-96b4289aff34@gmail.com>
Date: Fri, 3 Apr 2026 18:49:00 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: tag as unlikely if statements that check for fs in
 error state
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <8ea3a7a9c3c4e6123925646fa6484f6ba1524173.1775066198.git.fdmanana@suse.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <8ea3a7a9c3c4e6123925646fa6484f6ba1524173.1775066198.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks good.

Reviewed-by: Anand Jain <asj@kernel.org>


However, I have a question. There is an "unlikely" opportunity that is
not fixed [2]. Based on my experiments, it appears to increase the size
[1], so I assume this was intentional. How did you determine which
approaches would contribute to reducing the overall space?

[1]

$ size btrfs.ko.after
   text	   data	    bss	    dec	    hex	filename
1732263	 165668	  19752	1917683	 1d42f3	btrfs.ko.after

$ size btrfs.ko.before
   text	   data	    bss	    dec	    hex	filename
1732257	 165668	  19752	1917677	 1d42ed	btrfs.ko.before

[2]

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c5e1eb7b363..5bc0a4b89ef2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4277,7 +4277,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
         * extents.  This will generate delayed iputs, thus we want to
handle
         * it first.
         */
-       if (BTRFS_FS_ERROR(fs_info))
+       if (unlikely(BTRFS_FS_ERROR(fs_info)))
                btrfs_error_commit_super(fs_info);

        /*




