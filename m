Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CF954DAEF
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 21:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788904796; cv=pass; b=cJcKa7t+7a+gUPwX1v0wARQbkHEeUrxbtIVv5oKADHbgQaAVBLX+3BaMudUFKoQ20hrcVDRyVb1/KXrk8qNPVmnA5Wx3q83+V/NmMj9JCLrlCTdVMEOc6fzs/deTffU4bpnpYgZ6bfTOWhGJAyJaozrKGS9dfrDZgFIZnCBkyEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788904796; c=relaxed/simple;
	bh=ezKSQNkgkZsBEaDB0itB1ybfMlHc2DHjcxywuo/Bhew=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=a+26AQn02o/+hTEHsv4bmC14KQgDup84ZohjW56lRaso6qEsMtUvYE9VH7iX0tDmNixaYOkPiVuBeQbpOSTHtYN56oWVeD548U+sf5ZNJbcgk2b0vx1A33OgzSkdSX7Jo0ktpa0XoPtapUUdCQgs3CxUl7NAcQlc1fu5sxyVQyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghTSv3Yb; arc=pass smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghTSv3Yb"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c7c25d9f6fso4702376e0c.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 14:59:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788904794; cv=none;
        d=google.com; s=arc-20260327;
        b=FjuUozoLxhVXaL79Ti5yTTxlLTdnD0mIeWKVNUOcWngRWow24qsGWzVucFRuMJ8+v3
         D+GdZ85NGSNps5JI6ZNpWbDU+ALO89sWA/O+a7PrbnzRYNzC8GTR0oV2uOztfSU5HoMB
         rksrpctigGp/t/6li3yrIfL9oPeZPSwaRXGlz7x3OJdVjnRnmTQmRfhtNbKYSnR554JH
         3p5W85LWI92V3lZwZKFpolNaJCPNw3Jyc/ux4Tf1Qz5DD4WyQVq1KD+oHswFhBoRvXhR
         7qFU2BjHAOyZp6w8lZwWfaV6Y4u6HOuNcx8ge+xbalcq0IQMs/JQbbNNdL5bUSdcU2cL
         zh8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=W3okfpfF+ulwslFQA8mPfuKMUob9DrBiYFJHYdf7ib0=;
        fh=UT7GWd4Gae6L/gYi3YB+48MkxZT8Pn4PM+UR6mVpMSE=;
        b=OtaTnr0A60RYNRg6Hm/kBwOOPDyteyGAvp/tk3rKYHwJL4C8DtwMAoZVUhP5xeZdel
         JjuYCzoqFwnZrq57n1bpphaK5SF63INnzX3ubMw5m1BZl02C7i/ILFRpCNx7xlMgp8ed
         HiG9vFvkAROZyKay0W4GRasLd33mBRJa/fKHihvQec2oDHaPm3IgdXv6T7nBdHeo46sA
         z0Xvaxb80bmXbOV/qraGiY61Ld+Pq/WZlyvbYektoqb3pRbQK1eeSIt/7OpxQpUhoQfD
         5t6SVqoQrCwr7KdqOeQhHg0v7JoXL6rZbZzz4o6/6DFE+0L23tZzqynpJ0nJlfKAyOI7
         LwcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788904794; x=1789509594; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=W3okfpfF+ulwslFQA8mPfuKMUob9DrBiYFJHYdf7ib0=;
        b=ghTSv3YbO0/p+7bIrHoMzYZJpg+oK0AlyH6RfaSRhy6sr94sP41f+o/UHIPqJGVn+i
         izG6b/Oq5dnAjc5BxB9WKMfq5kRxxDKRvsbjr+AlBsDnqhUJWGW0ExjhngW2CJsfMnMP
         my1uVIh1icmszdgRWrJsWwWrSl6gwgXDXTyGKlAyoah8kceHEg/oRtaN5LSwfhl3WAFP
         E44CPVJfV3qb7POkDQ0FPodV0d1XdAgij+yx0iXrOTrui/gECvM7r8gPI8xXl9a/Z5c0
         CbwpvKPHJJek/eLNMCnetIA27SeuSz4D03oUp3BKuj+SlROsLvtPj6lu9OwkPGtF/Z03
         8/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788904794; x=1789509594;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W3okfpfF+ulwslFQA8mPfuKMUob9DrBiYFJHYdf7ib0=;
        b=IZbJ/dvZuZ/bmgUw0Hzmv1OSWKMEpVbqCoaVvqGJmtPzOfKDeGjX/E9mO6j1OG/FPs
         /pLqmfsi4UIUC2GeH4zPa55s1+3GMUhdijyH2j7eUvxyt3/MD8qLDVA/68yNltRQbPk5
         3fMP7Y5ucugN9X1Dp/BLfdU9HyxUzyR6vq4GSkmhcZfRFAVYEQFVRyuEkOznJHK2MV1Z
         905Bz1vawTwV7vXtzKZcuQYfpuWAY9OKLsjM4eGRt6apbAIZeHnMwMYt6ny52PmwP60I
         ZSs4CChA2CFro5aGAR5MZYQW3BofmK6lWo/rt27A2Wsx7iYW9OntgzNQe4dBh3kBwrzZ
         gFWw==
X-Forwarded-Encrypted: i=1; AKwUvBwOGLQ34p5ftwAE1d0IovAxQkJeQFSpSVIiCZdAMTyY3mZdbFJqMmER6m1yDHfc4JI1068Gf7QRCJ/KdA==@vger.kernel.org
X-Gm-Message-State: AFuF++kjZbgOSxkbEqyz2Qm+iSwYvkQtgGrQEta1pxKohnOkxoUitwyH
	M5UH8H9JSUICTJhoyz1Fi3+odSNzoMuOomoFhrue4l9hR0QSLo2EbYo9oaBkqnF9LQH4z9sw1CA
	FwY+yJgsGU/yBGoutWCtTIkCeZzZzulBgYp4I
X-Gm-Gg: AYBFou1xFPbXh4a7b+Mp5YY5wRdHpEd6pKaqWUluYftZptil5TSy1eXxEgypC7OHWeh
	wKHqbtfy8MeKsOT2jL9F/9nm0o1t3S3QuN5wZDDtdmFl1dF3mKihBLmhCOUJSVE+qs+hs24VYQ0
	aQY6AyYUEitMF5Qz7fThy5NM6Isto61rYZYEGQ4JvhLUuQ313kbwtklLz0y+KAlBcp1XZ0b4YIl
	8C2IC6OlITjToUT02FWiU7hCCp5I7w3BDbjM0SR0EJwPq0xLuLplPmIrdwos/WsDNwy8Uxxx1e+
	Ht2eW6hu8fo79dZSyxqA/OiUJS2cJGx54wPQTT3tPHp6bfBUssGpXDSEbIxTEmxNafPUTM9UAi1
	viH3D1N0uMquUPYAFwTt0sCCYsTLKH5auwjY2HHMuMf3b
X-Received: by 2002:a05:6122:e189:b0:5bb:eebe:7ffd with SMTP id
 71dfb90a1353d-5c7ed846723mr18448528e0c.8.1788904794291; Tue, 08 Sep 2026
 14:59:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alex Romosan <aromosan@gmail.com>
Date: Tue, 8 Sep 2026 23:59:43 +0200
X-Gm-Features: AcwNN1VoLis_qTCJaciWzG8fuCVG19iFAIAUytuAB7zTbqg3IQjg-3SPQQCa67s
Message-ID: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
Subject: commit 108cc873398932af589c295f78c348513b8d70d9 breaks update-grub on
 btrfs root filesystem
To: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please Cc me as I am not subscribed to the list.

Running my own compiled kernel without initramfs on a lenovo thinkpad
x1 carbon gen 7.  The linux disk is the only disk on the system. Since
version 7.3-rc1 i haven't been able to to a grub-update, instead i get
this error:

/usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).

7.2 is fine. a git-bisect identified commit
108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
reverting this commit from 7.3-rc2 allowed me to run grub-update
again.

this is not the first time i reported grub-update being broken on
btrfs. i reported exactly the same problem on jan 8, 2024
(https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). maybe
the discussion that followed would help come up with a fix that will
make everybody happy.

thank you.

--alex--
