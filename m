Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E441482E8
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 01:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777425401; cv=none; b=OKdd1Wy8Lb2FR0RjbdRo8aNd2/RTpqy7Y23Jvf2IXli9W3RauEuYQGOQz4FXBk2AEuxtU2L3eyEDtySYSXp8W4HHAC5xRrcMKYPxPpn5cTw7nusLcCgNf8iw8/GrA0e7hAPWl+RwrsxpC5L/sTjO8kXF1Di8ql3t0JyMZ03zXPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777425401; c=relaxed/simple;
	bh=WlJx2/fmslp2969hsosSxVgoyu/fnC0Y+1lo5Ox5svI=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiFZk+Qsze7PE5oMfmZWET9f2g/PFR57NKf1VqvyloZV7FnH9+ZUfQ9pBrQvBDt3cG7D/g2i55ONfWUvKEQ7jLxV8Qrb6UcU1w46oRvkTYxWvd3tuo3Taf//kYCodRuC7NlDtDdNrYxP6wwpNECmWRMr33m5ePeUvGOBGwBZexI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=HWHLiYsB; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="HWHLiYsB"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4g4zsc6Qm4z9tpl
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 03:16:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777425396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8UNsSecIf7rsb5NqIJJ7PaUwuXB1E9hpwhx0EXd0EQ=;
	b=HWHLiYsBPoY3U6sgfB7zU7Z5HshJmfEET568Fttw8Ubi6+7rorKla+UFFyCHuED1Avs3Pt
	Gy+hdfJ0grfmruOXWiX1LdYERjexXMHOJvxw1ASQgjce8rV0A9Xb/XsQK7pSAuq0OWHtBs
	pP6CURK61Eo03KYqLFmSVmncUYvIBO6ha3wE6m+r4gJJME7bNGHjWlHl2VNEmf6UQvgmsq
	fUVPMdD9JV/R+o3vqsKB7XbXq4c4SYMYop1cbJTYwPg+MP3QdoODTONH+Zpe7nXA8hyv4p
	qiaZ9TOUxrNVtw0pZhgiNs2l/LRIjUIV4v5BLT1pxEWMrVdzxSlSSV6gWhYYvQ==
Date: Tue, 28 Apr 2026 21:16:30 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <I7E8ET.MZV7K8OOT3YS1@mailbox.org>
In-Reply-To: <ac3e8496-26dd-43c4-8ef8-6f7223c1c61a@suse.com>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
	<20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
	<2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
	<KAR6ET.BWL8BEMZPLSV@mailbox.org>
	<0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
	<d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
	<19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
	<06Y7ET.5XM6UHU999Y21@mailbox.org>
	<70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
	<2CD8ET.98SA563QWYJ71@mailbox.org>
	<ac3e8496-26dd-43c4-8ef8-6f7223c1c61a@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: y99qp6jo8k7dx7cync33c43bsr9ob3ef
X-MBO-RS-ID: 3983cee314a3012a17a


On Wed, Apr 29 2026 at 10:41:51 AM +09:30:00, Qu Wenruo <wqu@suse.com> 
wrote:

> Nope, just disable the swap file.

Is shrinking the volume safe, or even possible, in the current 
condition?


