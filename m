Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com [74.125.224.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A2342E013
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791633801; cv=none; b=hZP5GbRxjuVcRtzx6vlWVZbi4V9Ej7VXIGpMawRxuYvhMNPiOzWY18XRz1bt8ZyOT+xERxnRdJWW2UqpdWh1JQMdDZFVsNFNhPV2FI4Vtfc6mGTfaGxntEyW+nTpIPivqIotjhL5joNb8RPW+QpFBTxHBohgIywmrD9hOnTGDV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791633801; c=relaxed/simple;
	bh=G0z+G9V3HfB3H+wfjcCgkgU0rNCXITQKEVEtrDQS+/4=;
	h=MIME-Version:Message-ID:Date:Subject:From:To:Content-Type; b=CB501iG7xa3J2tr4s7Cqcmf1l6immRuT1ZMgXdalY8qfP9nuRbrTkObjObyg3rSK33FjHunXrOm7IrNT05LyGVEjT9EuHcTNyOnd/bPO4dAMX1krRFUU6hlpRL4VMpR66d5Ub5w40e36E4jU9Q/J+Szj6QGgXZ0VfT0q3MEVBss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AfoAauoV; arc=none smtp.client-ip=74.125.224.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfoAauoV"
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66cbfb7ec42so625327d50.1
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 05:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791633799; x=1792238599; darn=vger.kernel.org;
        h=content-type:to:from:subject:date:message-id:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LIGBB38+JIoB06tMpRGQ/lkw1CAtMXTK/O/R9RACCHQ=;
        b=AfoAauoV7pLOadlWXykWt9p8kz4D9peHL9k1N8L8ZEYOHqY9V7MvrvKyuUrziK+kHj
         FcbsDwwFu6qB5Nvg57y7taoOGHFp8a0Xx9L5zgW3TW0nBzV2Ztq493EaRT/onKY8LxlF
         bMTLXW6CJNZ8QierlpUQQ1H48AUI3ovO8ozoSCIyXkCSI27Naq941mm5uKNFfR83NaHb
         ufdoGnYy8+nWSSplSxe8PDhMcdPpx6hv4iYWPUv9TV752gfDIc2iJzMjsBKXhqLRLhVN
         IJ2flJfL2zjWEqxDhulEl3tLx6YZ8+ODugYkNN2grrYrwnctXLQFQnHrPST9EGINlHse
         JUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791633799; x=1792238599;
        h=content-type:to:from:subject:date:message-id:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LIGBB38+JIoB06tMpRGQ/lkw1CAtMXTK/O/R9RACCHQ=;
        b=Afy9o3+PJi6+bf8vKvXm2Ol6qURMGelwxf40xb0RxOjp6FEnFiXUjkmEBU/QhFIqNW
         LpGeLG94BtIVfRJ/bv9JdfVJ48f0x4yMC26/V39DkVX5vBX5c7Do1D/i92oUIc3Q9wdP
         VSjVBvSLovQZEPiDezahHiYCDgwrmWLdzorvFLngB3yzKIXhKQ8CcSSFysOS5A0FK1XQ
         qF9xbHe87xoHLkEAZwzEK6WcU7yMGXfvQZB9YFpvIpPnUzT3IKl3d6qSh2DVUgmeia61
         ucCBZs4JH1w2GyLB9GBtiM3Y6k0BEFj1APDD3KYQr8Rb+HqZ0lJwgzhsnxtSKaSd2Gji
         xJxg==
X-Gm-Message-State: AFq9FYIMYO418YC8IwF8foZQQk8/uYlDQk3sbtzQRdzbBNgoSdp153Wv
	9Tq2PedPHwnLguv9oLp7Ah1z58shdFB09ET5Ul2AL4zdIn52lJUWvIW4nlPdHkMTRNvioXXiw7I
	X+3A=
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:690e:12cf:b0:677:c6ea:502b with SMTP id
 956f58d0204a3-67935d46463mr1721516d50.0.1791633798743; Sat, 10 Oct 2026
 05:03:18 -0700 (PDT)
Message-ID: <autogen-java-b2af8658-ded6-467e-ae9f-e52bbdcc0570@google.com>
Date: Sat, 10 Oct 2026 12:03:18 +0000
Subject: Search Visibility...
From: ankjain906@gmail.com
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi,

A short SEO review of your site brought up a couple of things worth  
attention.

Shall I share the SEO findings?

Thanks,

Neil
