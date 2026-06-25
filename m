Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24E937CD31
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408291; cv=none; b=ovVnAqd0M4iLDZF4ws9ba9bJpz1UOnG2csP6GP/flomBRO6Iwwq9RwGzdXV/6BCojNc8pYAtBXl3HREXc4jeyb+MCBjhx27KqXYkdAOsuhEWuOOHjl/ycf9sv19O0+3TU06Hecm0xkJxB+2+Lo3wR/WYBX7LRO6xDogpVyThKMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408291; c=relaxed/simple;
	bh=DtzQnNIOLn/4ory7n62H7Pe3gnst10l8LhLOcppQ5Nc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=k35wHLVASaH6l3eoShBTFzAP6YR7ar6+O8JJcniDir+8KqcuZvnWDb8EYDGfqUi2nBcyuHtkeGeREDXHGPE36FXaKooKGJRcFvMGn3GLsOWggZWOcX2DeNs0CQF/AG4tj65a+GofJRCFPdzeoWyAXbPkGPZIFSW3MW3JHIZzTOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=0S0rnm7P; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="0S0rnm7P"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b64c8311so1161075e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 10:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782408288; x=1783013088; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EmgDJGv65MnM3c/+XZGPyPCp0kL0XEvV2sMNImEwXho=;
        b=0S0rnm7PPo4CFOAtV/NSBL4GEpyJJuVgtEKXE0y4+0HixpE6dLwtzsKMP87kUd1RF1
         0OXXCS6YqJXNMgQXO6fi1f3nGI2TQUcNl1nw6fCe7wMREgoO8yteiVM9dy4UFgcwv4hF
         mwmJrVMmh8RauCTI8UQSAmhudaSkLyyW+aWdY8zHOcbfFXJJcfmhAkCNOJ2xoKbs5HhG
         PGhr9dUkbjmIJtBUUpMINLM/Kssa9Drpx3T2n3Yp91DqQW+Itjz5duWjLeYgjSnhBFNS
         re5W5OgluZQfPCqFORyqW/EToheZhL2uFU1l8rxz4g7hz2/NAbemGTu4X6vcpJzsTtgx
         yHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782408288; x=1783013088;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmgDJGv65MnM3c/+XZGPyPCp0kL0XEvV2sMNImEwXho=;
        b=iLwzPvtvM1DXdhXvHEXAL3uulxD1SDx1/JYso2fm0FtBETZCrAVUGFr8x2yVfdhSIh
         KwQHtC/jyNTgAiatoHumSTDdTKoCioh98JU07h4TWPKqR7EHT9nE4A/YHDMCJ9FhZtRs
         Y2RfEzfQmT1YxZRz1ko0szCm1o0IL4F+isfsPaVnWYGptfB8BXcPx/SICJxMrs4TNF8i
         SQmyx3RfPZD86+Ro2CYNXUBel4sG446eXlwY+n5qPuJbzomVxeCzZDRisxodZIucpiWG
         0rjNfZXOd83kCsXulgDpBUXkEk+QbHdMO1iTyvRZ+rzlFFXYWIk1Bv268OoyvPa6DMpA
         8aGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+udvZXuaXq8borcvLUd7t26yxVqifQHIoXwC6cXEmg/ON0g4kp/xvI4o4yd1jAZJ3UOuHLz2cpCPk7+A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi6rYXYBZqHJrwBMlovAyMu+SpJdAV793E4UHxraiqQDNWsIo6
	/XganbFabSAKlMdDwamyMP9VKjYXtoWjwMxSlTk+nFpnY5lXEl+iiWFzViCj1NRK0Ig=
X-Gm-Gg: AfdE7cmCL+sOy2LHlN8Qv8ydYLi9bPSZTZmtGJ6lKa6ta5xYAlDFbmzs1gf6DZhvMCf
	+ikoHRv/IfxKCrk83D15BhYB2I8S+Nnuq5H3F20e5h2iUh3AcM4BmijxB2ujx8cSLExnChjvBXf
	KDMo+dw8XaEPy/mR1xnkejx6bZJjiJMSgI6H/XiXQBWvFt1/CYr4q/2tHI/3PfqfqxERRqWEpDo
	gqOP74Lr1v7O/oEVAhv7To9h7D1dA9Su0JMhc1aip681/JSjNsT0LP2SgsdQw59NyVF6So5Xn91
	UJvdit3hJIH+x6JJoYLj7qFegSbWuYBY/8dgjb+4+vRMfKkl8e4Yak7vpNx+InJMkBaGmZFOu4W
	b4fmZ//gln6QkULyCc3si0jAg/HulyJoccRIEJCZNJdcDzH6gYS+DNI0TKHo/hPPBoBDsU3EgrY
	ySky9yErK+iVVPMoOWePRikTRUCdaGdw==
X-Received: by 2002:a05:600c:4745:b0:490:b355:9c70 with SMTP id 5b1f17b1804b1-49266873f5bmr47260355e9.11.1782408288174;
        Thu, 25 Jun 2026 10:24:48 -0700 (PDT)
Received: from alchark-surface.localdomain ([5.194.92.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492697ba453sm2585755e9.0.2026.06.25.10.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 10:24:47 -0700 (PDT)
From: Alexey Charkov <alchark@flipper.net>
Subject: [PATCH 0/2] fs: btrfs: add support for readdir
Date: Thu, 25 Jun 2026 21:24:20 +0400
Message-Id: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMTQrCMBBA4auEWRuIIwniVcRFfqY6LqLMxCKE3
 r1pu/wW73VQEiaFm+kgNLPypw6cTwbyK9YnWS7DgA6DC+htajKpFYqlsNhropgvMXtEB6P5Ck3
 833/3x2H9pTfltk1gWVZYCBBOcQAAAA==
X-Change-ID: 20260625-btrfs-readdir-8beac3ac5220
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 u-boot@lists.denx.de
Cc: =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, 
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
 =?utf-8?q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, 
 Yao Zi <me@ziyao.cc>, Alexey Charkov <alchark@flipper.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1119; i=alchark@flipper.net;
 h=from:subject:message-id; bh=DtzQnNIOLn/4ory7n62H7Pe3gnst10l8LhLOcppQ5Nc=;
 b=owGbwMvMwCW2adGNfoHIK0sZT6slMWTZpoTcYlmrubRiGvvVfw/y3n3+/8XE/9DvUn/WK7qsz
 U35gRfFOiayMIhxMViKKbLM/bbEdqoR36xdHh5fYeawMoEMkRZpYAACFga+3MS8UiMdIz1TbUM9
 QyMdYx0jBi5OAZhq742MDO+1AkraPW6Y/ksp3qLN8dix2d9zgWl/Fvd1vS7GEItmI0aGM2IzD9j
 Pzj9yq+bJt2VJp5RKZ7zj+M6munxv4UPZV8yzmQA=
X-Developer-Key: i=alchark@flipper.net; a=openpgp;
 fpr=9DF6A43D95320E9ABA4848F5B2A2D88F1059D4A5

Btrfs in U-boot currently uses a custom callback for ls and doesn't expose
the standard opendir/readdir/closedir interface, making it harder to use
in generic code. One area where this would be useful is in discovering BLS
type 1 entries [1] on a Btrfs filesystem.

Add support for the standard interface, and implement ls in terms of it.

[1] https://lore.kernel.org/u-boot/20260604-bls-v1-0-4ce6d1ee4711@flipper.net/

Signed-off-by: Alexey Charkov <alchark@flipper.net>
---
Alexey Charkov (2):
      fs: btrfs: implement opendir(), readdir() and closedir()
      fs: btrfs: use fs_ls_generic() and drop custom implementation

 fs/btrfs/btrfs.c    | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h    |  2 ++
 fs/btrfs/dir-item.c | 88 +++++++++++++++++++++++++++++++++++---------------
 fs/fs.c             |  6 ++--
 include/btrfs.h     |  6 +++-
 5 files changed, 166 insertions(+), 28 deletions(-)
---
base-commit: 19eafbadf20f56c1a24abe6b5e8774e776894261
change-id: 20260625-btrfs-readdir-8beac3ac5220

Best regards,
--  
Alexey Charkov <alchark@flipper.net>

