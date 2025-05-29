Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9991AB67F
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2025 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562777; cv=none; b=FTjeZMrLDGRglV6IIQGYCNUDo7jw4ZjyajjiEROWfCeeeZ/yNrUYCmPNR9zTKTQaKCYxsh5HyfDrbbs2CPnu5I8iRNjXKvwP58bS20XtapOixuJOcNrAhBBzLWG0m1Ja5HHbJOFUaTDGO+n+SfZZJwCzXBmW/cqvJrrymijwpDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562777; c=relaxed/simple;
	bh=njO/rhSgPnCfBx47mQ5oP/w3qxKayZsV4xfBdC4DAMQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=i7TbvQYWgUJ2BiS7PvDKVDdDx44fILbPNJNj0r7v09up9SptnXAekJkXcLnlVmdmIGcTjhc8lO/GAjbzzgv/4/923gSeQ8xEeXqbuaDgQ8d4PuHzI7bBABbEZp63tEvQ2+TcMty1w6kElni0XmMf2Z1d04nujGLh9idvQ0j63ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=velocifyer.com; spf=pass smtp.mailfrom=velocifyer.com; dkim=pass (2048-bit key) header.d=velocifyer.com header.i=@velocifyer.com header.b=j563QnzW; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=velocifyer.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=velocifyer.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=velocifyer.com header.i=@velocifyer.com header.b="j563QnzW"
Message-ID: <9d74d71f-b65d-4f06-adb3-18f7698edb8a@velocifyer.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=velocifyer.com;
	s=key1; t=1748562772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=+xuE0iNUdTp59HCiHRliL2CHBYyy3iBjq0k8yxrk6XQ=;
	b=j563QnzWukY+HV9Tj3uQeasO+ec40/c7moWCOjKxepCULMSaeDJrS8isqmMeXAbmSsj0Xe
	pGyJVELfg8X63OM3R2cNCHwsMpJXofugRqX6Awv61xj1h5+o2gUHTiDcVtYqlhsjKQdbDp
	hgnmiHUafpsXx/obAoGGh1drb2xUbyUhsjML0jiRS8tluT9el8H8M18fJx2TRh15Cgrdht
	nUrfc7hu3Av9j+wX8de1ELy08/VA9bXLM97zht5sIcCifwpLWAzAhHI9+8NalswOTCjpIP
	hCyd9XvbXKwYwHhoLv5fcNapO3kWbYUw94dTUP5W3wqtoUHbxCHg4Eu9Mqotng==
Date: Thu, 29 May 2025 19:52:31 -0400
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: =?UTF-8?B?8J2VjfCdlZbwnZWd8J2VoPCdlZTwnZWa8J2Vl/CdlarwnZWW8J2Vow==?=
 <velocifyer@velocifyer.com>
Subject: Why does defragmenting break reflinks?
Autocrypt: addr=velocifyer@velocifyer.com; keydata=
 xjMEaCpEhBYJKwYBBAHaRw8BAQdAZBZWSN4ekixMHE7duMBmw/2uteCfmp68D/mxaYk/dyrN
 JlZlbG9jaWZ5ZXIgPHZlbG9jaWZ5ZXJAdmVsb2NpZnllci5jb20+wo8EExYIADcWIQQboPxL
 gODyGwJpjO5jTr+HQMdIvgUCaCpEhAUJBaOagAIbAwQLCQgHBRUICQoLBRYCAwEAAAoJEGNO
 v4dAx0i+HU8BAJGd99DA1VdBzcYgch16XK7mC78ZqEwGegVCRerWry8RAQC3MJUOiyQ062Ol
 /3iNXY6zk2QXaAsV8eUbFKUo1HiwAs44BGgqRIUSCisGAQQBl1UBBQEBB0CEoaVGilG8Qt/y
 Xp135G4fhWjJH7VQkPIFo8/MsZspfwMBCAfCfgQYFggAJhYhBBug/EuA4PIbAmmM7mNOv4dA
 x0i+BQJoKkSFBQkFo5qAAhsMAAoJEGNOv4dAx0i+yNYBAKcE1fbRCPqWwsIpRvOjSq9Spvhl
 veEFpUMPaQ1tp7qOAPkBfZroJ8veENH/8sz+Gf/QK6O1kcqC4d/vAASzMpOiAQ==
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

BTRFS-FILESYSTEM(8) says "defragmenting  with  Linux kernel versions < 
3.9 or ≥ 3.14-rc2 as well as with Linux stable kernel versions ≥ 
3.10.31, ≥ 3.12.12 or ≥ 3.13.4 will break up the reflinks of COW data 
(for example files copied with cp --reflink, snapshots or de-duplicated 
data)." Why does defragmenting not preserve reflinks and why was it removed?

-- 
George truly, 𝕍𝕖𝕝𝕠𝕔𝕚𝕗𝕪𝕖𝕣
This email does not constitute a legally binding contract
