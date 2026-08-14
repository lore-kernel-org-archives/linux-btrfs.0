Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6483D093A
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786710649; cv=none; b=mwAF8k6PNNq3XKdonNsdWdhq8mD6j/2/+XE1PD/DaHBf9hP9hUKFsH5Qu9l9L0TyzSkqAz2v2uFd/pUWz3xBf4wOmwWZ7RRyolbDMMK1bZFMAzkKXMk1pDOx8d4GhqslqLO014uwLj0PD3xIfiMf9i2oNtdF+MadtLohGqIaork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786710649; c=relaxed/simple;
	bh=U1Y2j+92d+vHnkozImzjd00wOBSLsV600VZjEpum4S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSpb8bpkNyybU5VEqk9jphrg9FGZqO9fPHhXfe+zITWQLaTVQ1HX5cB0IJs0DU5QOOqp/NX3SQaqk7EpWy85eZ5pi5R9NBuX2bCB8wd8EoSIUBnNXuDlWwJ9iYqvbUBcjx55TiMPBMxwt9K3k1vUCfTX3rk+ZH5JC9fDn3jNnSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lgn7jwVX; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lgn7jwVX"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cacb8416a1so9485875ad.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 05:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786710647; x=1787315447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1Y2j+92d+vHnkozImzjd00wOBSLsV600VZjEpum4S4=;
        b=Lgn7jwVXae/cHVFis1XSd4FTQucpCMDFTPi50+SxVq8c3oe/punicr77Xkc2EFPew5
         VtDp83dPVRNtPqGSw/KCI2VY5gxlanBzgVApvEGcpjDs98ekCwz5QbRHia7bWcqIUXWi
         zdPH7khjv9jlUsxw7QvmmSBWYrT8BOtGA68+D3RYr3YL1XvTWElaVQeBEwihSnSTP43t
         MR/WfskI5vVFrScutqK4QiKwe+HuDqTcRHyTj5bQ4bk8Cyp5bcEzIc/70shIbqbKecec
         ERr7o1DDXUCX7+ve/iF8Du+X5euFkErz8PtDfAwj6VdEQvhfaqUMXzvb9dequG0607r6
         q+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786710647; x=1787315447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U1Y2j+92d+vHnkozImzjd00wOBSLsV600VZjEpum4S4=;
        b=jBTlkev6MF+M7Rxsx0pVQDSx4lGI8+ED+RUup79jt5IzNOpUrtad6oPb21YBWfWHZ7
         RB3TQbkDBwGKt1JXWHv9bDUxsZaC/e16uuBxYE4PjRvwJQGL6ZmHsb4oY08okR4nSBcW
         v1SjCQF+kG6BwSsKxIgj5f8PoHZuZMNl9bXdXjSuaqpuuBWuBcYy8x2q+7yfTD4F7Idb
         XdIad2qc32X6QIBXxODs2lw44cSEosyp+Gf25I70xaapMAvatsMtskLgBc3jWdKRyAvT
         FFzshGY8dzJoIF3vP/mckXxxjImCwcq8edmX34xOItUC/DouPySG5p/56IxXmsAx594H
         t84w==
X-Forwarded-Encrypted: i=1; AHgh+Rq9Hq9Q50D1+WncUCEMTthJakF/R0nh1ksRI9tQZM313jP1zkfqjJhnYlCDB2A0FjP/I8OuHuTuvoq87w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJRDVtMCaYErKRm0RGhdhowW+/BEujR+I2J5t2xMqfgeFUD6q7
	a9NrrRtLOJujn9UdGZQ1HMTAry44tFUH/gN6nLw4Vd8pn5zAcjIdeOs6
X-Gm-Gg: AR+sD10qYEG4ZfF6YKEx8JLtjomMMdeo9Lb5kD7yKIILCgjwR0x6FmBEZcdWHVN4ape
	DjbWK/oqwVrHXKp5CJRdSp9f6vv+ifduJzVcRrP0oYFfVoHSJ9b/jO0pbKbgTlI7ial5CvBsR89
	BsdV0dBLAx0IMNjHG7v3PhgjQP95nVDz3J6z2IUoT6OfwwxEqmrP8wYql9HoFkvwo9y/ae3dfai
	URpQjGxsnjXqljI/uMsf6hXT6uvbgm1MSDLA0nyV9znhJyxAFzNPUecVZ2vChJT9CcoQ68Fc6Wy
	S5l5RaYKj4dYI+IMxyzXE036QXut3PCQlTsCB4Y8t6O/+cqwlL7SGEw5sQ+E79Vp3jp6E7ytDg+
	fLj+7h+rZg8jAi6mdD5SEJjc2ct4FV0wA0bliyWe6IOvY4/5gTsO+xcq/Rb1PhJO3vvv6wYQ38O
	5Okm8GUZi6WYlynmICH1YIEL5s3bXSwQvzs2svr2v7mI6aTsJ6HDt3CDyWQi+9zDcJR8F78LmnX
	x+fN1oPm4Welofz
X-Received: by 2002:a17:90b:35c6:b0:392:6638:2e6a with SMTP id 98e67ed59e1d1-3933b95d5e1mr5969840a91.13.1786710646690;
        Fri, 14 Aug 2026 05:30:46 -0700 (PDT)
Received: from localhost.localdomain ([14.153.235.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eaca3e48sm2589992a91.11.2026.08.14.05.30.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Aug 2026 05:30:46 -0700 (PDT)
From: Guanjie Chen <jk.chen1095@gmail.com>
To: wqu@suse.com
Cc: clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	jk.chen1095@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: free qgroup configuration when quota enable fails
Date: Fri, 14 Aug 2026 20:30:34 +0800
Message-ID: <20260814123034.19289-1-jk.chen1095@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <694e88fd-a165-4518-88d4-cb2f22e8925b@suse.com>
References: <694e88fd-a165-4518-88d4-cb2f22e8925b@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Qu,

> We can reach this out branch if btrfs_start_transaction() failed, but
> the fs_info->quota_root is already setup by another process.

Do you mean the window where qgroup_ioctl_lock is dropped before
btrfs_start_transaction()?

I don't think another task can set fs_info->quota_root in that window.
The quota ioctl holds fs_info->subvol_sem for writing across the whole
btrfs_quota_enable() call, including while qgroup_ioctl_lock is dropped.

As far as I can see, quota_root is only set in two places:
btrfs_quota_enable(), which is serialized by subvol_sem, and
btrfs_read_roots(), which runs during mount initialization.

The disable path also calls btrfs_free_qgroup_config() and relies on the
same subvol_sem and qgroup_ioctl_lock serialization for the qgroup
configuration. If subvol_sem did not prevent another quota operation
here, the disable path would have a similar lifetime problem.

So if quota_root was NULL at the first check, I believe it must still be
NULL when btrfs_start_transaction() fails. I agree that the changelog
should have mentioned subvol_sem as part of the protection.

Did I miss another runtime path that can set quota_root without holding
subvol_sem?

Also, just to clarify, this is not my first btrfs contribution, although
my previous change was only a small one.

Thanks,
Guanjie
