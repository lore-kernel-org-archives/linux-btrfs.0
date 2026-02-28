Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931F23ED130
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2026 09:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772269596; cv=none; b=knyRwP1e6LYmUxNUIAeC+AOPT03ySKfQBsoU1/Mwhvw88FQpHvnHy2YVHwqAd9G/osThDlB1PyXJD5Qy3WF2VpPYv7MWleJWptpypJ3e1ssmS0rufYNA8DW1aA7gQKv0IZvuV0Wx3+kL6Hfwr/W2WHqSYAesLf5RccVDngYjfF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772269596; c=relaxed/simple;
	bh=rA5Qdw5El2P4ubzaa4efNChDU+yx0/I3ULcOASC4qVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LPt9dFL9zmaaZjRemSnMpqWyzYRK3h+vTg6gp247dB8WGNzXrNzK4Ovv+L/0hxpNBFdoS8JtuxTS67uhsbMP08vCvFpD6gDaai5ONzzbaWbGEfNHPuQhUz26ZJ1CgSVB1C6Hvrz5qEusMl9Z3hVGa+7Tmlaql+lyw9PpK00bIx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hzPr7jcv; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzPr7jcv"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3585ec417f6so1580776a91.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2026 01:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772269595; x=1772874395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fefkLwuCcj1cIZ+T2c7Joy+DoM3AqyfSXPVH9TAjPr8=;
        b=hzPr7jcvVjNQKM1109TVd0DCizO4q0gJAQjbUBslKiG30Shts28B9W2fqMdZwQln6f
         dSnqSqjoalohx3wgljU/zbug2soHWLZC3SVKJ1+mNkESU/vexFriarEri7O7xy/i/K4E
         flDONegQDJgmnxpZalsMV8aOFxxivmcIeZYGk8gvQ70uypFwFz7AbAIMFjvxAB0zEObV
         lARt7oQBDFiTN1q0Fbr3MCrrq+T2/Pyto2ubZRKC4i1JjcFsWk6nir3OafphdLy2ijfl
         1Y5vS2XbV5E1pqqeGvoVyTvvKreL30tyHfvZsgZRwRPh8bLrDLWkbjrCrSeU6YFvlg7a
         lVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772269595; x=1772874395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fefkLwuCcj1cIZ+T2c7Joy+DoM3AqyfSXPVH9TAjPr8=;
        b=VpfMQN7IhO3TH+elkBESuuaPK4AeY3kJLd24Mv8rPA3vplCOTLJBe+oK6NyJ530Eey
         5oEZqde2vGw7yihX64rIh21hesj37PxomnT+OzIkkCS+eK1jo4jcfcVCLH+cf6W39IzP
         KkOG4mGPQXWaaqc4LqbROwbgsUSnwYLb0asu/Edz8cruWkddyvmhlwYmI4KkBARdRTYH
         XHsv0LkKbRqdFzOrH2nEnUF4snFxAN8vvdYCtu4fN48wvpfdLzUILAC3soEAFAAJ/p5T
         lMxFNNGH3jlL8uMePYRkKVhoPG5B9exrvvZ/AF+ywn4MjCXhVkW06B8sYdU7qYnquKoo
         5YqA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Z5e3owyMPwl5W1bejya3arg1sGYdKikbe+HNq8EPo2ob4UY+XJa6zGj2xu48yVI3nxBoMjSCVwfhoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEc11r322OyErrc/xCq6rMQQnl666s9ERsEIfxGVQf0LXOnuRP
	bY6Sihlll5kWAHz8NGl8uAHdkbIil/fj++KHIr3bT5lLB+SfOrZt6bWe0cc3MUnLJCI=
X-Gm-Gg: ATEYQzyO3+deEBqDHHjj/12RQqSju2Sz5tHQLyuZg0XwMqtNwtYKdBkUC8XnkP11ivW
	o4oqxKmKgWEaMRjHMfsdgj/fkQs+gXnOK3iQP1IOPJ4RsmbhvQWY8HyxkLyzllDVNcl3Se0aXBu
	TZwTczlkdCnGbhyYNy0M1NsDzkbo64gYlbWXSo/RKt4eVm07IW9eJCzDT17FpQb6ht66S0/XfM4
	sZxe7AP4217Ob00PcTCZUVxVoxbLUpyWBUilma721OyYStZG+h8rU+2Bw3t5UB6CnUq1REXejw7
	AlCumMq6mJQDaOcEsgJCA0vxYB8efGNL8Vjze08t2/KFdd3rmfuJqev4AXt77tZF4bXhO+45fnt
	h6rFoGDIyEfI4TezdOPHIWNUb04itY2xp6gKBTBxdxjJJMxSjmTdnC+u6AcNp1SHZhr7MwFBRjj
	odRZ+f+lSfDRxaDtLGBb0hc0+d
X-Received: by 2002:a17:90b:2541:b0:34c:ab9b:837c with SMTP id 98e67ed59e1d1-35938460bd3mr8935125a91.0.1772269594924;
        Sat, 28 Feb 2026 01:06:34 -0800 (PST)
Received: from archlinux ([103.208.68.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3593dda5ec8sm7589488a91.12.2026.02.28.01.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 01:06:34 -0800 (PST)
From: Adarsh Das <adarshdas950@gmail.com>
To: clm@fb.com,
	dsterba@suse.com
Cc: terrelln@fb.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Adarsh Das <adarshdas950@gmail.com>
Subject: [PATCH v2 0/2] replace BUG() and BUG_ON() with error handling
Date: Sat, 28 Feb 2026 14:36:19 +0530
Message-ID: <20260228090621.100841-1-adarshdas950@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- replace btrfs_err() + -EUCLEAN with ASSERT() for runtime logic bugs as suggested by Qu Wenruo
- fold coding style fixes into main patches

Adarsh Das (2):
  btrfs: replace BUG() with error handling in compression.c
  btrfs: replace BUG() and BUG_ON() with error handling in extent-tree.c

 fs/btrfs/compression.c | 74 ++++++++++++++----------------------------
 fs/btrfs/delayed-ref.c |  8 +++--
 fs/btrfs/extent-tree.c | 62 +++++++++++++++++------------------
 3 files changed, 61 insertions(+), 83 deletions(-)

-- 
2.53.0

