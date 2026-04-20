Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AE223C4F3
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 06:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776666649; cv=pass; b=DmcQyaE68/GQYZxrlh/nO/YTVi84rjn7v2HYjzJ9ujxlDFtNMX/DV0eDNNtmGsuq844zSbqZmZbcbCTYrxNMz+DosaObZNH+fCJ7hHq6NK/2uy6lpDlo7BNHsvsoTpVHlnXeefMWiVBnlLHRPLOV/gzJ99gW/F3YjAFyPl2Ynz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776666649; c=relaxed/simple;
	bh=dahbqAJ0nZcqnd6aYe9vWXahQmPzLniDVO+YsQkQnUY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Fm0UnU8gxz+Mur6cMq4FycwRr8B0zkPfNlsVxGx9IuYcS17GvZToXKhzP9hWAO+gy70gAyPSrcTIMviRU/6LnUcvrK3W4Ib5zao2ky42WK9SStsu48mggVNCd1ESlBpXs9hqENwRB/MTmouKT+S/pUsEQa4jhHhhBrLcNUu5XEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dkXr5wMu; arc=pass smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dkXr5wMu"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35da1af3e10so2603165a91.3
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 23:30:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776666647; cv=none;
        d=google.com; s=arc-20240605;
        b=gRtDUSXPc/PGJi/x98LauLdPFZZDPDFQfxufs6zvnBJjC6g8afehJMiXUgvVmC+BXY
         ztRWg1P7qnFZc0AAWF3vMH0n+TAlh03PHDOU+HZeyy2hIuKWin5zLXz2MQXPS3GmgU0A
         lk6KWaMDBlIbSmpW6WjbZSS8Ikj0ovyL4Nb5opXl/yk8B391TAOQW1JHIWm14l8gzyU5
         UajE8UMaxgPN2B9RIFxDLwdAw6mbRUH/OX5EXK+nbEFmqhQXqy87X4srIGA/M7/dGNqC
         7qA0YIBRxh1uUxKkveMnJXRCt+ZzYLiX0kvowQUprSUTX278TEVKGjQ8mVn5WiTpF67a
         y6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=2VULVFUZeYNdYuuaJ646DIVUjUOZhXeTsJA4YviZ0LY=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=DCj8HF1vL6wN4yKmEg7FDVDIMnq5XWEhFYTw3gfNtfGsWcG3WEZFFyrtjlghw9NG4l
         fEbQqZsvacIEwfSBKdkrlSDvmDNPbkgQY6fSArGTQShHOsKviaE9TXECgFfmF5RlKdyK
         EoK/6QiI6/pFaAg2IaBO/hsO0+MWs4KBRAt4t3PU6yj+qRztyF57A3UR/jbGFCeV8ehW
         jiyxQK/8f2ffdQN192bJ26iiJ9yxNlfcyzeRoHrTKC5zER9odE8CoVK+PDtxNOVmvu4y
         Y1y/rw7wnVYLvosdXZJN6slLtH+sbZlBXGIvQxCDSX8IL1MLu4zY7FKTpOrH/2L5C0ww
         MGLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776666647; x=1777271447; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2VULVFUZeYNdYuuaJ646DIVUjUOZhXeTsJA4YviZ0LY=;
        b=dkXr5wMuA5JlHs1DbBGL/bVPstzuu8AXr3j2kG63Zz62LNqwV2++MU/u5WykUsi1Cc
         CAgNrITbWho1lIAkdI1YHMYyATLzV+ppMPJE2PCLiJa2GgNWeWnay7Kl0hU5ZHUH6HzE
         ud171N9myC1/MNbJWmLhcOrmhKJQV4U4GpyOiqFJIuldsE21gS7MkAos3dmzlbpdxITO
         suvyBQk9kJ30KooLEAJlm9uRX+hJCkttjR3AUjnXJ8Kul0S/DMzz/vkepXHcdxAjXOTp
         RKjibEvIMP1iU8sx19FogTq025Rpdt37/1CfRZhkG3fLGGuuiLTqQB1BUL3Y9gsUBDkJ
         kJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776666647; x=1777271447;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VULVFUZeYNdYuuaJ646DIVUjUOZhXeTsJA4YviZ0LY=;
        b=LUagQDZqvT3MF08spvcGZswdAYxEZB3m1vBvbspq5TK6j84Ue6H02DVwkcAjsvYQ9E
         J1/3zCkWi53KaQpQEmbM55WAK85wQoi4qakkHeE5Fo0L2iNoy6xARdDfnY2xOp8Ghzdy
         amjagF7/i27pAczuCylSeMM/pN+DJ4rA+7xQ2CIoqva1c0decx8ItazvnFDbzWmKqcxz
         bJfs/susT08J53YThUDCv0Q7ao6QC+6L1SHNNn7rPA1JpxOQqqJcVCul8RjZ8rb+Jrce
         gA+lUMTlpWK5WwW10Z41L90hm5JRVLcgec/IN1RRQaJWTsPYVxcH80HqeZDiFvWkPlyw
         FkXA==
X-Gm-Message-State: AOJu0YxQu5iJXh6+ALgcLbvgOkwV4xEFb/jEOyYIDIf0d5/DRxn1tirs
	zfmnHQawwmoXrjlIk1XbKqX3f74V8TPc+REt/FVfMsc7Z7gPwtu9bFLSr9ClhpnMjImyijIQIQR
	4K8bzQdTVWw0dc15hVPF7EzFDdF0h1sbZZhdH
X-Gm-Gg: AeBDiesLIGBrY8q//5iVzfoaT72658Z7Veae/pyOf7LnKkX6boCd9KK+ZgQNyP91Nlv
	lzZ9MeA7d2ohld9s0YRt7BU6yJ5V/dN+DzUIiwTPUMnns630stHD2dEsdg95A9dQgdiynT5GVVQ
	M59wXKD2Tu5dQGRa/2ttPpNl54yoeB5A6qo0RzQrfSlYPOeZ95hZZrHxEqiOBtfKafS7fM3iWmV
	J3HdGaEut01jK1sjlIbp5EOVSqH+/Np+zu1WyZ022tD7yWBgWbkIX1IvOW1T/Rp34uObeZpAdlM
	IXtz+q5wySOR5t5LmdveiIylZOL+Fqsz1OPaMUexdFTwPKNF+A==
X-Received: by 2002:a17:90b:2fc4:b0:35f:b6d3:da7d with SMTP id
 98e67ed59e1d1-361404635e6mr11935788a91.17.1776666647013; Sun, 19 Apr 2026
 23:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Torstein Eide <torsteine@gmail.com>
Date: Mon, 20 Apr 2026 08:30:35 +0200
X-Gm-Features: AQROBzB_jOsVRgVBMm_761SlB6hud_ENHwtWDQAy2JLR1MC-i6GSAKrZVqJFvys
Message-ID: <CAL5DHTHA8a=BemS5mVLdvt5CT+DVgegMFftdMqyk+=B60KFAsA@mail.gmail.com>
Subject: BtrFS, Scrub: bug fail to respect scrub_speed_max
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi
There is a issue with /sys/fs/btrfs/*/devinfo/{2...}/scrub_speed_max,
where when running it scrub the limit will change to none ("0"),
before reset after scrub finished.
tested on both 7.0 and 6.12

| Devid | Before | Running | Finnished |
|-------|--------|---------|-----------|
| 1     | 100m   | 100m    | 100m      |
| 2     | 100m   | 0       | 100m      |
| 3     | 100m   | 0       | 100m      |
| 4     | 100m   | 0       | 100m      |


-- 
Torstein Eide
