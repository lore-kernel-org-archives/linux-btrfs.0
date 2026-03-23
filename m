Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539A029B216
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305271; cv=none; b=iumGL0F2WUAjvQiO+IyMtZbQsWy1abzXXWXQ6mYr3TK4u521OB2MoDaGSopRplG8dmjbd9GqKLUGQncxlxAFdn9VZbpQ19mzSCozwkTB+TXvp0YkD1g85rtNsXyh//Tuqiiu9Lu9XvDnw3+XX8tabFBRF6j/EHgMFcVU1P779hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305271; c=relaxed/simple;
	bh=d6kWtwSDluCnDbjaPj/ngjzSXVbO5MX+Smv6qI/rU4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyMpefWUmt24XKNL355cM06xEUwj1ZavTBdaIXcrTM07sr0wHV2KXoHS7PhJ4HhdpZh8iAIVhkicGGWEASgasKNV/31zVWq2RWhS5KUFCxH0oZA/1l9yyWLO6EwBQizr623fyWAbT/nhUyzxsaeqqbiGmB9RrtMRQh/ufwKcRdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PRT4n3h7; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRT4n3h7"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439d8dc4ae4so4107271f8f.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 15:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774305269; x=1774910069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d6kWtwSDluCnDbjaPj/ngjzSXVbO5MX+Smv6qI/rU4I=;
        b=PRT4n3h7q0aqX1g9QvBpVg81/3gGeS17VkiejYCGlXO0dELa4H7kqq/QhqJRQi09ss
         k1ofUHO3E4vPvT4E2DX636aDGldHlpP7RFderyKbGDS+/BPO2Xfuv6rSeG/5mR1lw40j
         A/y5+bBURJB0jz+YW9cLmI+2W3R1ZuMdiu5kUvS66FRdjjmvgsdzJeLeG85JfcJD+0es
         ytuitRr19kfhLITL1En3qxi9kln08tma+ZOJQ6wc4Kk5cIBcdm4RuFt0EWizvscTMxy6
         qGqVHUPFr1pPQHFPOjhyS7lCKmQzoQM/ohQZ6kB6GLGYsGBF61Ic+lPXaqC+3gMpUku2
         4aGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305269; x=1774910069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d6kWtwSDluCnDbjaPj/ngjzSXVbO5MX+Smv6qI/rU4I=;
        b=lW/4svZnAz9FnLp/wQ4H1peDmwp/IYOY241ERwxEixpaaCf8B1Pu25Ht1mp2Tsev3U
         3+9vo3HNNhVtT3BJ/P8kpA3h843AKY9zDWzbVSF2IfQXzsEHXvfnRl7jdK1mGGiRltUP
         AWy22DF+4BWxsJgW6fSIsFb5jiMYOSYuE7HqiR5Jz3pUa8y5KL77QVkpJh+ZlM67e/jn
         oXeNuyKoPQnnjoK6AuNSVk6KJMtJyVbpCYkMhG6gjfFPW3ceOAQSD6rkXvX2IZbXi5Ts
         XWgmFp4b2aiRmNdbQl9oxjkzLfSu5Rp71BSJOHizCWs9hoVg9Fa8B8YzAaSFK0XQ2ENA
         9sfA==
X-Gm-Message-State: AOJu0Yzs4qAqm9ynmCXhHokxjpGCeO1kvL2lE0DwNrxdG5aDqLg7tkev
	Gn42Cndag/n2el1l/gtvOYotxSZaw/mshj4C0eOMjhhKn+tRhD89Dtqt
X-Gm-Gg: ATEYQzy0Un2yJnArzh8SxJyaUxuDvP4KdUA6eM90zCrlqGzpFEqN0zoGIMGSgHbg6yO
	ChEZRkoIyA3a10l2EERcCBMsCwHF27Yo8j/CogWEzwdEV8W5HEpcaeEqPnx+/u7HMrIndKL+mTG
	V3MrjpbWX3LLMjbjLrZYtb3NmU5qKd9R49PCVKKQJadNZTIjQZPpN9u500y0p1e+DXDENZU2nFO
	ZEsdoTso1xTTE/pLQxpNI4DEVy9/BWdr6gwoVOHFef8K0gp11AXfP+8DZwSwdvm634QOOx2fOAL
	Mr0Y49JKbtjII96Htag/fo22QcHTZBONfsucb6ncB9hCKDhGghsFyomf4HpWXvJ7D2MyqBdDUqS
	v/AoWbjpPM3WC9nFEUCRwje0yp5IOjlagVwMQee91MUSzcK4rblp3g9y1IZugqcUf/5liiIAg2C
	cmz2L7SRNUO+uzOQGCRMSaIJ94cmvX1INu
X-Received: by 2002:a05:6000:2502:b0:43b:3cd9:aa61 with SMTP id ffacd0b85a97d-43b64262e2emr21034243f8f.25.1774305268518;
        Mon, 23 Mar 2026 15:34:28 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae37dsm33215282f8f.2.2026.03.23.15.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 15:34:27 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: echelonh@gmail.com
Cc: linux-btrfs@vger.kernel.org,
	Teng Liu <27rabbitlt@gmail.com>
Subject: Re: [PATCH] fs: btrfs: fix btrfs_ioctl_space_info() slot_count
Date: Mon, 23 Mar 2026 23:34:24 +0100
Message-ID: <20260323223424.1876676-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260322063935.3951728-1-echelonh@gmail.com>
References: <20260322063935.3951728-1-echelonh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Applied and tested on v7.0-rc4 in a QEMU VM with btrfs as the root
filesystem.

Verified that BTRFS_IOC_SPACE_INFO (via btrfs fi usage) returns correct
results under normal operation and while running concurrent filesystem
activity (file creation/deletion in a loop).

No kernel warnings or errors observed in dmesg.

It's hard to create a race condition between 2 passes so didn't test whether
before-patch behaviour.

Tested-by: Teng Liu <27rabbitlt@gmail.com>
