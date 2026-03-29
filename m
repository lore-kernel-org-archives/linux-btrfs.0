Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2E25FA29
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 04:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774757314; cv=none; b=WdJaTChlTsCp+tcnd77MbB+65d2VobUeT4zbYlvm06bD7c7P4Ty6tChZbFib5+hpjwdrBK9X/gelbKMLkU94yE2FgPfAtv4jUpLTVcLLHDvspG08PZ2dcHKLZUk/fZm2BJ/Xzw2a4lvF2Z6J5Qjvg8euDV9kE+/geMEd/PE4wLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774757314; c=relaxed/simple;
	bh=ewrebA2GfSdT6QpVfkDrUS5CDGEm64zLO2fh0fmu2hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m4W0qUzRgrw9O4ii9cyuh+/i+wi4rddEQOZpqkwVKzz1oJJWVx7qb/F1IMwk/A5wOBhEiR52fDW1oHarFIcYDykWB4IKyqz5IVP7dIAj/10vzY/EYaIi8ICrLJif9lb5Ootr49U6Hu54QCgPP0wbR93qzRG2GCOeAcSyzz0zTiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20230601.gappssmtp.com header.i=@hev-cc.20230601.gappssmtp.com header.b=1gDZECIn; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20230601.gappssmtp.com header.i=@hev-cc.20230601.gappssmtp.com header.b="1gDZECIn"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c769e72512dso22020a12.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 21:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774757312; x=1775362112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcMba91l4VHF9piAdu7w9FJqozouFzyx+yXZRyx5X4k=;
        b=1gDZECInVa9/Dv29mdHI+HyhWocMDf5e567TLQdlY1Lj5u2o4QH8IWSxe1ZnyrzY0b
         fIoDEOxUFKahBEUQajw2OmyeFXGJEHrGcKKDy2/w6QlbyjKn/BCE3ujK8kt+jOA8fcBT
         yiG4BRq3UcRnb8FrgPInylc5hXY/FJ1OxshLtAq71t+HmXOeUJ7bOH48/JcSxFTzrTV5
         UuVt+B8sP+G1CBp5vqVrfIqP7dTYrvrwnX4qZmHaEp0jZBU93Sldf/Q3zZvge8rw2Yap
         QqAASZOJm331dbexWMryabh79JklSia/x273WIBaViUk/BPICqLglqv57dpl5KhsIb8k
         Lx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774757312; x=1775362112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fcMba91l4VHF9piAdu7w9FJqozouFzyx+yXZRyx5X4k=;
        b=jVviLvg6i2xRlBG91GzTgpHhlKG6KNFj5SaiJkK+T45XL9ST8PE821noWr/lr+k3YM
         CsjiZF4vOF6uNZZrKujDGmOGdlglbqw0I/QXJoYLKvx7rbd0rVltoM/QZQoSF91cOMI4
         MhppmRs4bEu806s6TksS5qfgU2Sq/fY3SZd5C2yxhFGbSoa/mvv/qRDp3kNC0TxR+auT
         12UypQdQnRjTW2TuXgk8aRsNtIQZ127trRMHtVE36LmOOPvJl5gUh+SQ7JoFmaZfXDkg
         R5I7zlVZ1LODgNmXY3UdBZjpJXpj5UNQ2B1KAz8bKxr/qHH3FNCGukafgL1L2UIUh9qB
         YxCA==
X-Forwarded-Encrypted: i=1; AJvYcCXTO/VUWLEp/L8tGTb3Mf1Jnn5Q5yYce3h3Lizwqw4C9AiyjNw7aKMiu9RuaX5Do5gDfnttE+vx2OeKDA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd6Dep/bMpZhdBCInDROlVe1GXKPd6dAMOFqhM723xYc/zpm7b
	rxDoMd4+PtVQIgmxfUgeaQvZ7tcbRFdO1ST8l7WZhIZGzgKWEQbA2EFFiGOYWGeq+Io=
X-Gm-Gg: ATEYQzwI8HUyFtbaq3spJmyUBD6RMUtnukmwuTofsq5O5bg2zlXNpSu13W5Hj7jtKUh
	r7NYHJxqS+rFAky1BUe+mANnSrlwHDZitI9rGbpC3N9c8F/2R0QRI7EoAe8Ojy84rT+Z67lLj9Q
	0WHVg9SssRChYtKvHRP/BlWt639UHDLmQdJZ/yIvhFc/8JcEnhu/OCkUUeVy9kTAJO/cNkOKgXW
	oXOVzFiPLJDKraOEGieLYi31HIxmJcDhLb9nvds/9e18YfFPKJ7EcJ98zITUmgpXnkQOZ+8tLHv
	0EtC/oLw9KePHBfk94LjcEzRJ1IOddMW8UjI2Lz0iu6Po9E0ia8ifgaTlume57/R829aDP/ZKgi
	eSprM+R4YyoJjD3B0NjSrYaEkVYGy2zZpZ2Ujv7iEF6dRRc8iSqhWLgt4rfmHuNxzcbv/e6XOHS
	09
X-Received: by 2002:a17:902:ced0:b0:2b0:c2d9:270a with SMTP id d9443c01a7336-2b0cdcf0019mr88952725ad.42.1774757311794;
        Sat, 28 Mar 2026 21:08:31 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24b3a82f8sm11038575ad.63.2026.03.28.21.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 21:08:31 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	clm@fb.com,
	david@kernel.org,
	dev.jain@arm.com,
	dsterba@suse.com,
	jack@suse.cz,
	lance.yang@linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	songliubraving@fb.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	WANG Rui <r@hev.cc>
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Sun, 29 Mar 2026 12:07:41 +0800
Message-ID: <20260329040742.17269-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
References: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zi,

>> Now without READ_ONLY_THP_FOR_FS you're going to:
>>
>>                        |    PF     | MADV_COLLAPSE | khugepaged |
>> 		       |-----------|---------------|------------|
>>  large folio fs        |     ✓     |       x       |      x     |
>>  large folio + r/o     |     ✓     |       ✓       |      ✓     |
>>
>> And intentionally leaving behind the 'not large folio fs, r/o' case because
>> those file systems need to implement large folio support.
>>
>> I guess we'll regress those users but we don't care?
>
> Yes. This also motivates FSes without large folio support to add large folio
> support instead of relying on READ_ONLY_THP_FOR_FS hack.

Interesting, thanks for making this feature unconditional.

From my experiments, this is going to be a performance regression.

Before this patch, even when the filesystem (e.g. btrfs without experimental)
didn't support large folios, READ_ONLY_THP_FOR_FS still allowed read-only
file-backed code segments to be collapsed into huge page mappings via khugepaged.

After this patch, FilePmdMapped will always be 0 unless the filesystem supports
large folios up to PMD order, and it doesn't look like that support will arrive
anytime soon [1].

Is there a reason we can't keep this hack while continuing to push filesystems
toward proper large folio support?

I'm currently working on making the ELF loader more THP-friendly by adjusting
the virtual address alignment of read-only code segments [2]. The data shows a
noticeable drop in iTLB misses, especially for programs whose text size is just
slightly larger than PMD_SIZE. That size profile is actually quite common for
real-world binaries when using 2M huge pages. This optimization relies on
READ_ONLY_THP_FOR_FS. If the availability of huge page mappings for code segments
ends up depending on filesystem support, it will be much harder to take advantage
of this in practice. [3]

[1] https://lore.kernel.org/linux-fsdevel/ab2IIwKzmK9qwIlZ@casper.infradead.org/
[2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc/
[3] https://lore.kernel.org/linux-fsdevel/20260320160519.80962-1-r@hev.cc/

Thanks,
Rui
