Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496293AA1B6
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 06:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786776322; cv=none; b=kJebbWStPamWG2Lqbby5yMx00BOK2hacQoU4bpiA0zZfqzZXV2SZd11bdlQcKxfmJ89owpqjvHZgN1a4jBAAbDbuFPbRbxo0DgVOkJr7fS41TZEzGlgYNnw/TOLKqwiaDm0CvfTL5Fr7MieHluYRimi/NY69wSRmwqaonS57lC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786776322; c=relaxed/simple;
	bh=JkfU/qU3fOegS+X13WMrunVgNhji7i+aUn3ZP2pKttY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyMJXUNNPLMEF4wMbXW6TySGuinqRc1BjkfazLM52/ekqYUbJs9a8TitlMW1dp103CmK3lQPDFQtFQewtq/oZBgK+oBa7YgmIv6vShxTDAhfpaEv2fYq5aQzjLvvpeIbcnuEsBOkb9xhlYphmb64IJ6u1BATYiU0ssJUl4z8iaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QeDGiFIY; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QeDGiFIY"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ca80d708489so958082a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 23:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786776313; x=1787381113; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JkfU/qU3fOegS+X13WMrunVgNhji7i+aUn3ZP2pKttY=;
        b=QeDGiFIYmPfbvJlp/WNO1dp88FVd2+T5RZXJUraoBeITNcEYQX1x/hqF4JzV8trANw
         fgp9ffpEgiyHlWxv274Dx/ZOee8Do26iD5tcRomVe/94GOW+V/IAWj8rp5mltITrnbun
         kHhj1QMUcdLfKhmwVzAETwiQrfEernr2uNzWiy+40fxOEr7t44gXmCMjR9CeMwoB1MbV
         svf5u3UuItBrcPlz06xwFGBxUCKV+v7HQvifO6uMNba4HzIN1uwlun/tK5CtfQAdWQkz
         TxbsjRaDhhufzjX4mnsA4Vic+9v4ftoBYndorHD7lKrTnuvonH7oxj8OpaKnqDURMLJR
         RUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786776313; x=1787381113;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JkfU/qU3fOegS+X13WMrunVgNhji7i+aUn3ZP2pKttY=;
        b=OmhlYSxqOSD1B2sLeP2R/qk9OAaFABXmnKQP6ElltW9ctlXf7aLNymxryKITfcaSaH
         WkvVUVM56WsG2KMaOx02mNEMMcA05BOkd0qXUd/kfXSnimms+q93fogj72M4oz4WLwSv
         CNXXM5LxoSKw0NOxO6W5SsIubJ1gsx1iRn2ZWhrvUJm9RhU7ZWTr523exVq/c3IOKg25
         1P/e3myfsdr233GX1SlYB+cz7KfbfaBvHfAYjMy9QD8xLD55THw1GfivwZgGmWkF0krc
         HsY5fMWilLUnHyrVOW14D/x9gMbq9tiywPWKoMP7l0i9UevaFtB3upa/BYoRomXpYQVf
         fC6A==
X-Forwarded-Encrypted: i=1; AHgh+RoteQEQshEMmR25KE7T5YXdZMf2U1Ib9w1SMtIkEp2s8UgnarsWDZtl1K97sQia8PsJ/1ygdvJk2DSbGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGHE2Hd5aiwVrrA8nPTrk35EKxSgsFc5djME1M5ToLbbecsYAe
	nJTmpDbnPuquMba2iHKAby+6GxR52F5YTmEU4Tyv2gkTj5/XFFX0qHaj
X-Gm-Gg: AR+sD10zzGPmUCm1njHQL5KOd+652qLSHYpAQKoq0jZoGg1HL6hiTXOR6hcZbTKNciq
	5KlvdWEVcjpPZRHtOC/NVAgrg0JYLE4/MqEiHb5MZauDWRovtrbDb3KT/s3KA3NQ95WbxujavvE
	KPTn9B32h4zBOB6NmlDX59zkalRQy7/jasIr12EA7Aqof3Akop1pcGQ3guxcZQ62u2+Th7hnXez
	draJbFtTcINpuk/eWRFxAjf36Z6oFMpCnS9CnfFrxzbxadk4d8J1pDqu1VaijqAiBqpfmEvf98Q
	KdP/qfkbFU9RNh3cfk2ecvpDY9fiQUGoRLHbmXEslwTFDbS6B5gXZMPsC/ZA3yV4XkYlx/obQAn
	qE7ofp+Ewkls+2AGmsG++HrI5a0G59YQprsJgdGGNH/taoBaQTQVAXH66A1coTYHHfliC7nzlUf
	uZUk3AB7ttvCuDZ1giA6hzx7stuvXntkEHxUIOuTZMMniIQe9HA1v/72yJLtzuqI7MaoGlnPiVM
	O4=
X-Received: by 2002:a17:90a:d407:b0:38e:4f42:d0d6 with SMTP id 98e67ed59e1d1-3933b09f4f3mr8871167a91.12.1786776313005;
        Fri, 14 Aug 2026 23:45:13 -0700 (PDT)
Received: from localhost.localdomain ([203.175.14.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ebb888cbsm5254979a91.9.2026.08.14.23.45.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Aug 2026 23:45:12 -0700 (PDT)
From: Guanjie Chen <jk.chen1095@gmail.com>
To: wqu@suse.com
Cc: clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	jk.chen1095@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: free qgroup configuration when quota enable fails
Date: Sat, 15 Aug 2026 14:44:59 +0800
Message-ID: <20260815064503.67385-1-jk.chen1095@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <7845cec2-adf1-408f-b7eb-019a5cd398f7@suse.com>
References: <7845cec2-adf1-408f-b7eb-019a5cd398f7@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Qu,

Thanks for the review.

I agree the error path should be reversed, even though btrfs_free_qgroup_config() has defensive checks so it won't UAF. But this isn't a one-liner – maybe we can refactor the whole init/cleanup flow later and fix it properly.

As for contributing: I know there's been lots of LLM noise lately, and I don't want to add to it. I've been studying btrfs for about 2~3 years now. For my next patch, would it help if I clearly explain the root cause, my reasoning, and the solution in the commit message or cover letter? I'd like to make review smoother.

Thanks again for your time.

Best,
Guanjie
