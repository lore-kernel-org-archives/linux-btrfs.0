Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481A62D7D59
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 07:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778915818; cv=none; b=jkWC4PpTspfeDeNoASHLjBpwRbIAOwQuaAo6FeVHzye9NwTSTNT3p1L5K7OCPwwidhcs2EkbNrIgLGFaPv49BYVvdn/OhU+qAw8mj1bR6hi9SBKmjYkYLG3KOzRbKpQH8PSJyyv2zs12Sos41ijwLW/FhBT0asKI8y18kuOO+CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778915818; c=relaxed/simple;
	bh=PibgjZqkX/Lvv8LAD4y/jWc8+9uGZ1ppiohWHQbdKCM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=p6k0CYnedS5tm50oMkiLkWzcxYgME8PLuQIewwPJ6i6Ycc2ZxgWQpbfH4oyHJ40jC/Esgsywptah7296jsDOxPT8SzNwt9KhV3HYSarsb438TJ8zneYy4CbcS5aL4h88ZwpD6DwcLIKdd4IKz/zcBZ/B4az/geWYhqlhqqFHLNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WVwfOZvD; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVwfOZvD"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2bcdc085c52so746095ad.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 00:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778915816; x=1779520616; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yoitvfM05S2pQp9brCwg5hSoyQrB1rZ2sXniwHysT8Y=;
        b=WVwfOZvD5AHje1x6AVFy5QIWVLj1etRrnEXAbpGWainKBKf+AM8wGomYRuRkTCvMIl
         Vhyse/12iGhXGteHRTzkLQRk0fJQq0D0bGe7bEIsnY53IJB4iWXQWKA++w8zquUanEtT
         jJU0/0hfLGg2h8nbMf6FhpK7BV3IrCb0w5lR2eXE+/5KiGqtAChwI7S/E2tq8yZT/4B7
         mcXIpnuROvxQQhZilM1dbgMHdWATsXJFESddLRMcCRl7Tv83ykhp4fUMnTQ3VUhdDAgZ
         u+8sQwj2AKBla38DLQ3ZBWAwe860vDVDXzZVOnRibySXotoIMlD+u4GUXxOthUX01Nad
         a+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778915816; x=1779520616;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yoitvfM05S2pQp9brCwg5hSoyQrB1rZ2sXniwHysT8Y=;
        b=AXP+lJqL6O5F/oEFbacBPPyj2FJoNx89JWKTgIwbK3/BuKZJK3lXe3M2ho1vPZ1Qxf
         tglH+ocriDqL5xR5yztaT/cpp1fbA/9A7mIPIm5PfP1HK/HI9WGzRTdL4kQKcjtb8iIV
         I2yUlk+5hG4pZj429zx0qJS0vXvn0R/MeVqe+5h6ascELuIW6GzfboEELYL4gTy7IqOy
         f+5UKk5VCLnJyoMVYLUjLToTlA1E+prqAuRpMGyWSZ0aCOrMez7JFeQxC9IrXG48FFo4
         LHJuoQ40phKExyJPxgPa9dnMzLjf7wS86zBd2N2KU9wjS0kjYjkTSnos+5XEnORFKTJh
         EduA==
X-Gm-Message-State: AOJu0YyCB/IgpKC3/nZwhsHoW5aEphbTV0szH/fglEgq8pZcGZJNG/Sz
	/EY3CVgXzGyF4tUIwGoKti8oMkQQ+053rq+bszeUJhOf768s+kXEMJgJ+W/c5ak+
X-Gm-Gg: Acq92OGBMnwiMjg+6yy0iVqgz5cgt6H6hGv+11GHYEXNWI1qJMxaaEIGwYmkfcfhhBv
	fmXPxuB+oqpf7LFER+cx3idDNtbjs23YG7p5UwdJsc0iOIan7g0N2vvpwws2UNnvxrDNhDxXWfS
	7qruHRLeGLkRiEkOzdj+02MlTVIz5Awcontv1C2hC9tVqvnuT07vBTpGdoypWGHkm1k2ufPxqax
	miTtKtlF4Jhv0xDpgOtkr8RDM/cosle3GjiEYKJ10ClSry5NlTDhYFRBfcOaWeawTVc9/Fm8pKV
	P/zHYcFdTKNthV2isjOppFeTcn0xUiIL1IV1g/lJD/RT0cF3pjOVt9U1S+QX47NErXZbQjVBLO6
	r1QyvFb/QbLO5pWwrTWcLkowM9H5U5dgkePbMgkqgYL068jdmri/kRYEw2Yd9b+nGnYQ9nGVSgw
	tSEl4mOOUX7rDN2HR8I5OTrp6u4f59WkC+fG5JDyrHF2D0fNB3Hufc81MsDkAlvox2gUtSVAN3s
	ho7eSxSlpbIPPfruH8emIUv0vJgrO9fqRQ=
X-Received: by 2002:a05:6a21:6f11:b0:3a3:2195:b536 with SMTP id adf61e73a8af0-3b22eceac9cmr4211792637.8.1778915816549;
        Sat, 16 May 2026 00:16:56 -0700 (PDT)
Received: from ?IPV6:240e:3b6:c21:8af0:5d7b:130f:ee39:2eca? (softbank126013051224.bbtec.net. [126.13.51.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f196660f9sm10289117b3a.10.2026.05.16.00.16.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 00:16:56 -0700 (PDT)
Message-ID: <eb259b63-e19e-4bc9-9741-161faa15fb55@gmail.com>
Date: Sat, 16 May 2026 15:16:43 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Sun YangKai <sunk67188@gmail.com>
Subject: Opt-in non-fatal data csum mismatch handling?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi btrfs developers and maintainers,

Many btrfs deployments run on consumer hardware — desktop PCs, home NAS 
boxes, laptops with no ECC RAM, USB-attached drives, consumer SSDs — 
environments where occasional data corruption are not rare. For many of 
these users, the data that fills most of the volume is also the data 
they care least about per-byte: BitTorrent downloads, build caches, 
browser caches, transcoded media, and so on. They would prefer "warn me 
and give me the data" over "fail the read with -EIO".

Today btrfs offers two ways out: `nodatasum` (and the `chattr +C` 
linkage) and `rescue=ignoredatacsums`. Both disable detection entirely, 
losing the diagnostic signal users might still want. The middle option — 
keep verifying, keep logging, but let the read succeed on mismatch — 
isn't available short of patching the kernel.

A possible interface: a mount option (e.g. `datacsum_action=warn`) that 
preserves the existing diagnostics — `btrfs_print_data_csum_error()` and 
the `BTRFS_DEV_STAT_CORRUPTION_ERRS` counter — but, after all 
mirror-repair attempts have failed, returns the corrupted data to the 
caller instead of `-EIO`. Disk-layer EIO from below the csum check would 
continue to propagate unchanged.

Before sketching a patch I wanted to ask:

1. Is the concept acceptable in principle, or is "never silently return 
corrupt data" a hard line for btrfs?
2. If acceptable, is "suppress csum-fail only, never disk EIO" the right 
boundary?
3. Are the existing diagnostic anchors (dev_stat counter + ratelimited 
dmesg) sufficient for the "warn" half, or would you want a statx/xattr 
surface as well?

Happy to send an RFC patch if the direction sounds reasonable.

Thanks,
Sun YangKai
