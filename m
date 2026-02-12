Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E957C346AF5
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2026 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770897113; cv=none; b=pA8neS6kKpySDEe9UOkmuHbNagdDFonVBe9T6MuBpkVMsDFadRBcGqOJhMbWblpANhaI4UOsNq7fNqIW/aql/TghpfB/AjUC3VfpNxce3wlh2ytMerkYer6ChuT3tMM3gRyWER/OYIuL9WQE5TB9ONaBBYB5wIpNTJfy17U0W7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770897113; c=relaxed/simple;
	bh=XjSWJvCqXNs6KFHlJCEjDBXFilEFAsp8RQ/y0dAQPl8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=fuPAF4BwAbPU531X/BDoHCxe2h7BLvypbSmkkavFipDeVdnwgPndx86DXm1TQLI+UEQhmPS2/8FdWB7neKKi0TLy5AkovyPhcaS1AXzgqR1S2tZf4agprnO/9EN1AZjBHZuSAESzT3SYWn4RDe1PmfB72B8P5jGiyp8EYEuobeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FhQMjqt9; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhQMjqt9"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-385bc6910eeso26710921fa.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2026 03:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770897110; x=1771501910; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=icNB5xuvo+j+qezx7gqf5Y6Yw5qJ0+ofGzzhpNwJwdA=;
        b=FhQMjqt90S68QJBXL9jHocY7B1/g5ZRIw4R14Jz+q8ubrflb3FFjMjVVlBxz2Hi0VC
         0dnIBz/gzOseJszrl/f6To9dnq3zIQmBrE2uq6bq0Ovnr3t6Ia26bEm/EL3ZVhgKGiZZ
         wQ//I9DlDaDkl9wDQF/XYTMzSS6V1ph0rqylYdQcs3t19ho+cjMCq+OqV9gLICvEpsZr
         Y06Sm3TKWgqdUHJhAHoRcyfWmegywK32x990iLePGZFvgtE1Fpv0CJZ08tt3/hZBJNDx
         yMjYZXUOv1u0ya1pDSipjc908Q1650HRawkTSMMf6GcDdJb2iLZfYEMQYvDiMb9kVIex
         /d8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770897110; x=1771501910;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=icNB5xuvo+j+qezx7gqf5Y6Yw5qJ0+ofGzzhpNwJwdA=;
        b=ojrJdmrvqj5cq+L9hB+HANuPAloBbkfxtdB0Ea3tggco4/H++pOO6MPx0D5gxXfEyp
         un1Xa5fzZyBIdNJR9yMw9wlzHGrJzCML1TZju3IjjCX7x7cXBYpKfWqg+iZ82XG8D3zn
         1tK6u0NBuSzUS0cslKNP+6dTN4ugxItk6sPyXRBJ4telN9FW2KzKDg0zjffuwLPpvBRQ
         ivAxx2pnkV4wlLV8r3GbHtWGAJOexwxShRN17eGRP5s3DIuicE3vxtdF4/jvnSPU0Jt0
         2aHyKlLo17C+M0kFvw+2y+2BWTLqSxZm8VeQdCz6ZD8sZd/f/npl9AM+/iWgEpBIVXnE
         cZrw==
X-Forwarded-Encrypted: i=1; AJvYcCWK4D5cQ9qhz+IF9C/V0yiWGGDm69mvuub0X8ZdBJyZ1iaPlWJ5crMygKbwHyCqMcbTzVelXUXNumzwkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOobrFQn2GPhckXssjoOy4Ga9oBWG1VxDfladAelO8FKs41pts
	uGaUh/WWnaIWle9Ofgu/usoi0BwCodnc9elmMBQlCJ83wIAUcDtSm9Rr
X-Gm-Gg: AZuq6aIfJG0hCJohZZbWBPQgu9/cW/Zn4axYBFz38COHk/33ZTvGnv98IqQoc48mBxK
	LEZnvX/4gOtRrvokzpOrCLcGP4zPueVpqcOTOs2Yy8sWyq2jqnS8rgz4oFyQEgF4i81sybr3Tix
	xlnzgYk1eHv0AT4NFT/P3U/fcGfGHuw7c7YdOmbEb3tRiwJnNzJq+gmlWgiAxS7gOZ0/BufpGkQ
	kXJRzh5HV7550ptek83Oni35QiMoUPlDblKC/bJiPwzX/1eY9+Z78yfVVAdkPEsOuKJRKWR/Eis
	AEmM9Mgd4CZUz8SVAV0JGN0FSWGXeKvl1dMc/JGTSkyGD+BZRT9DFQCw0SVXBIR6k9nqkTLMu97
	OovJAQEjVfuXUZYBDWD5yJn9/XWUWJJHEY4B2rZPQSiSKUGqnsx4CWQGRwho5IUlIOFzwqQaZiK
	Ql9GgeSRydhn9NuTecsBxESdQjxWSPO/E6/oG3c5PZxVhg
X-Received: by 2002:a05:651c:4193:b0:382:624d:a703 with SMTP id 38308e7fff4ca-38712c1064amr7134971fa.45.1770897109932;
        Thu, 12 Feb 2026 03:51:49 -0800 (PST)
Received: from [10.128.170.182] ([77.234.210.12])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3870689e107sm7206681fa.14.2026.02.12.03.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 03:51:48 -0800 (PST)
Message-ID: <4b207a36-5789-41d2-ac17-df86d4cde6da@gmail.com>
Date: Thu, 12 Feb 2026 14:51:47 +0300
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: viro@zeniv.linux.org.uk, brauner@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
From: Vyacheslav Kovalevsky <slava.kovalevskiy.2014@gmail.com>
Subject: File name is not persisted if opened with O_SYNC and O_TRUNC flags
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Detailed description
====================

Hello, there seems to be an issue with O_SYNC flag when used together 
with O_TRUNC on various file systems.
Opening a file with O_SYNC (or using fsync(fd)) should persist directory 
entry.
However, if O_SYNC is used together with O_TRUNC the file will be 
missing if system crashes.
According to POSIX this is OK, but most file systems provide stronger 
guarantees (would be actually nice to have a more recent documentation 
on this behavior).
This happens on Btrfs, ext4, XFS, F2FS and likely other file systems.


System info
===========

Linux version 6.19-rc7, also tested on 6.17


How to reproduce
================

```
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
   int status;

   status = creat("file", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
   printf("CREAT: %d\n", status);
   close(status);

   status = open("file", O_RDWR | O_TRUNC | O_SYNC);
   printf("OPEN: %d\n", status);
}
// after the crash `file` is missing
```

Steps:
1. Create and mount new file system in default configuration.
2. Change directory to root of the file system and run the compiled test.
3. Cause hard system crash (e.g. QEMU `system_reset` command).
4. Remount file system after crash.
5. Observe that file is missing.

