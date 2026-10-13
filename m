Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1D3B6356
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791899229; cv=pass; b=lTLs4T8UU++lUjhWPYgEti5bhBKPeGF4tCyXUFBkztORboh2cfg/XEXN/cixiK8M4OwD9MstQNzzveuRQBpQvRy3xfDmMKlrPOUYuHxed99u1te4Egv0oOL+IJwqA2kDkw7dWe7GNCqjHVKDStYcWDiXWbbcAj6eKBCjH6SGafE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791899229; c=relaxed/simple;
	bh=APuJkesL0c2KPJY7WEkO91tcKEnAiIJQWba3MFWx4wU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=q1jdt9udpcJJP/hhN6kTFh95AUamnwmeLeuPKAA/GvK6AKajErQGSr5/xI7H6fibGKGaC1ZIUcjQs+pgFN2ZoaIzslIrSmt7Qo/uzPd8lfaFtxCCC0XxT0VT/T58ocioUI+B8MzCNmiN6qvY8zf87trLDLacXT7+VG+farJHVAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com; spf=pass smtp.mailfrom=studiomoob.com; dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b=MM7nqVmG; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=studiomoob.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=studiomoob-com.20251104.gappssmtp.com header.i=@studiomoob-com.20251104.gappssmtp.com header.b="MM7nqVmG"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-53394bffe0fso91192021cf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 06:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791899227; cv=none;
        d=google.com; s=arc-20260327;
        b=FjWM70uUCtWB90UK4r7szeZcaFch898VIIijzE8j3ntGWeUTKisdBOH7VTnball8rO
         91EfhVrol9eFO+vWDgEr/ooTzGK7leERBZ/ZCLqUHCDQyiEEWBoLKoIwEOUow11hug/G
         W9JxV0oOyfxdnbkUElief3mkvaNqRtZSGSlwrZqOooE5fHO3XlkOi4Gz84lIoFbzHoro
         ECPBKly4GuXDtp+9biD1dnkZ9QyDFtn7Mm+Jssdkt7hQCorkGzl2cNRpyF6oY9RCH1JC
         KMmWhKw/SnkudBaw03bK3oXuEB0xNePBfu67RaKYweFfW0gNMd7Nz29cSg+s0/KLD1rD
         fcPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=0T4crrIjXSV74WufWbz2qcUJD8sL1xgSzqevBKsDTZk=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=QIq4CU+ET9r63aI/0h3q7IAQ7qAuZk5heqgDivuT8dvyMR6iBV+ty4GhU6rBl0BYQd
         VbGY4/CYhyVZmLndYJKBqxnL3FGxgGijSak8cIR/m/Jm2lkuuJG/J6fRJscRDRrZ9uRD
         mahTfb0qws9cjvEOjAVwqHMqWigFKIkmqwNdSd/lfwLkn8gI5uufvIw6dWGZ0jLNgJ1m
         mbkmrwINH68y8wk0JI7GU35ym4ljob09xTamnkFAKAR6Ud+QGQc3iJp+pCEcj/TK46IE
         qFBZmQuS7uK2JiOJrCSIre6MA+patWqbK9BkDUx1naMad2a/F5RPrEqLoPrwbQt6Tb30
         4fDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=studiomoob-com.20251104.gappssmtp.com; s=20251104; t=1791899227; x=1792504027; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0T4crrIjXSV74WufWbz2qcUJD8sL1xgSzqevBKsDTZk=;
        b=MM7nqVmGCglElEBG2nmgFX441/AgqnJMWpsJ4aDOoJ3pjHaN7zVYaUpR6r2YssUl0S
         IChEobEfL9awiZrPMpFjLbifAobYtCT3BEkaWUEdhTf4NFHJPv9zp8YPIyguNcu6EG8F
         mupYnnoYXHsNayYub9QZylqcxR1ITOpg5cGTq3ZbeSp0oEVSKM+Sde1xrOQ3MYX35lUw
         wAKuA9Smpgct52ozIQsCXce0xEhTGQKsFqxTh7uqHgHbfh+i7tapw0I8R9Ha5Cp2QnhN
         Fw6gSqgGesAoqNFp14DUm8EvtzrJgPcMM6B+PxkFG+2K7fBYP9nyAyiwdGAfXY6pxsnf
         tgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791899227; x=1792504027;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0T4crrIjXSV74WufWbz2qcUJD8sL1xgSzqevBKsDTZk=;
        b=lZ8D6CykVos+/KMj6kiHpXw1RMVzWxeB2bmBVkd41ESThduulTObh2YT6MdbFcvqPk
         r1fU8ppiNcXtaspf+8Ggms8wxS5DubER8WbST4qpJacvvlUHvYU9bwLGMbmEak+dw6sB
         K0bOFq7gQngmOtgzOfI3NPzfHVfypu8Mw2OQzQS0sGBO4r7FyEjtEDynJQJlqRYbQtYA
         MyVyP4cG1drXfHQY2tROLUC0hOGnbILyMzRjXMDy06bYoqvAaB1r0+CtTs3AmdyQTlcN
         MRnqhlV5nJrBibkfEORphP//qflenpqQEZa7eEEiVH1q3+vAKLl8Ko09EUAgA+jZfTC2
         /4HQ==
X-Gm-Message-State: AFq9FYKP98KkKBguWOcZ1DimFNibRz7LfRtlYmS9BGihqpg7OHSpomH5
	aqPDSxlw3Jtk8ACXCnNGiYN53hHpFj5h7LcKAVOPvAr5nxrR/fCagHjSKHa+qtuH2IIWDYs9A4k
	dkMe8XGCbpc5s6EnO7zFjakITwF4PwxGhh0YydcwTRP8aadAFnIoUh0s=
X-Gm-Gg: AYBFou3a6txUdLs/BTnMWO1msze/qpAJzOtDrm6Oxq91TazPUfStyu060M0uTEcY3Fm
	dYfp5maCBQPt4NdPM8QSNWL30ptwz5JrBxO0WSVDVqtbH0FOdj2j03cHWkkmh3waMYuGbnToFLy
	f/LRLXSSbqdoa4n0iy/cmsLNxk+wgXTHsVXYJoLhNejmKcpGgTHYQD6PivnTT4shFpopcH8CnEY
	7np2aAY/Wd0rmsgP6oDT7SOIHNo/p+RW5bACITBRNmIg3uzOD+uBE4xRWZqFD04lLr7KJGmtTCC
	zRXj2FMZMNuVZY0RyzbztNSxHk9u3BpnFIOtpIYnKl45YIs1v9UgY/oC2LIHqe8GDbCzb4Uvpae
	J+/TWv25cq5Mf
X-Received: by 2002:a05:622a:1a92:b0:535:16c4:7304 with SMTP id
 d75a77b69052e-535a60e70a4mr153017351cf.12.1791899226988; Tue, 13 Oct 2026
 06:47:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Cl=C3=A1udio_Fernando_Pinto?= <claudio@studiomoob.com>
Date: Tue, 13 Oct 2026 10:46:54 -0300
X-Gm-Features: AclHuK-CTqspSUwLCq1Rj_1--XW0aW8Y5uN3Md4wwpRF-k9Xez_cQHSo0Hu_G6g
Message-ID: <CACU5Mh9KdABHuGXFTY3=s1DiPSPUSLabhWZnQRrYjnjK5PGPSg@mail.gmail.com>
Subject: [RFC] Stacked fs keyed by lower i_ino: detecting a nested subvolume root
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I maintain MoobFS, an out-of-tree, experimental GPL-2.0 stacked
filesystem for 6.12. It is not proposed for merging and this is not a
patch. It was developed with AI coding assistants; I review and test
the result, and it has had no outside review.

The layer keeps an in-memory index of extended attributes, keyed by
the lower inode number. Over btrfs that broke as soon as the lower
tree contained a subvolume: a file inside it and a file outside it can
have the same i_ino on the same superblock, and the two shared one
index record.

For now the layer refuses to enter a nested subvolume. Lookup returns
EXDEV when the lower dentry is

    a directory, on a superblock with BTRFS_SUPER_MAGIC,
    with i_ino == BTRFS_FIRST_FREE_OBJECTID (256)

and the mount-time scan skips it. The lower root itself may be such a
directory; it is never looked up.

Two questions:

1. Is that test right and complete for "this dentry is the root of
   another subvolume or snapshot", as seen from another kernel module?
   Is there a case it misses, or a directory with inode 256 that is
   not a subvolume root?

2. Is there a better signal a stacked filesystem should use, short of
   calling getattr on every lookup to compare st_dev?

The check is moobl_nested_subvolume() in layer/moobl.h, and the test
that creates a subvolume under the layer is in vm/suite.sh:
https://github.com/studiomoob/llmoobfs

A pointer to code or to an earlier thread is as useful as an answer.

Thank you,
Claudio
