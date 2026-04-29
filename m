Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912443B1B3
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 02:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777428719; cv=none; b=jm/bAzn370AQy//Q6QbrtbwhdzUdu0P3QnRE4Ltk29C0nemV3p35xSqzSlrd7PDUkitpJPv9BpoffzQVpQvCVzMv5bb6I6uYdaSX4J4+qmIFQznW8HhnT+AVNFPUqHbxOrdRhOq3OsiYQxWFOEi5G/nFBWC34f+qhiWfXw+XLcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777428719; c=relaxed/simple;
	bh=As/Kg67OPojaDreFDpKB5RonuSn7oqJAo8K+D0ecdmo=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u8tuxKrO6TqXZWOMZnhnC3uaorVBsIyOGkCAdxR4KFUq9fv0LPzzavaLzPGdErS2JNBXIDSAsMk2aF36Vxa/tS6qUz85u/oARqoR9l10TGDQzgApzm+UCSz42E1OLAeiCuaXZe2k35nCvXvyQ9oyWXVpZO8721b0Iqf63CVyGYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=wIRJJY/6; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="wIRJJY/6"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g515H73JYz9tdV
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 04:11:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777428708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g+G8TpnAMvMk293EXR+kUkAmmgKK3ZF0yuyiWNkkRE=;
	b=wIRJJY/6V9OX5c3Ss5CBB+fr+EJ5x5kj+Qm/J/N9dEID5xKTCv3B2Y3SVJUtLLx9/GA63/
	xYilaczjWRc/+tIXRLkSG57Pb8BG3wrSlM8GN5++d7Kb/mMLbG6hwBkfzex3iKK4Kiq9Zw
	TAaEAjZDntZ+4Hxu2fwzyZwNASoD2VCBnrhGqxzr+P9sCRe4to0rV0U9xKAk5mTf67cv/q
	bX2dmkVkWatoBZXHSDEyVYF8RuNUHqoNzIxM/2GPCA53FpAPwLkW5d6eAW+wJ2gTeBnvRt
	rB+y61krf8De87dZJYYWxFiDroIY+VrcEiV+Vc8xzCfD34Y0OTSINBFiSNO00w==
Date: Tue, 28 Apr 2026 22:11:40 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <GRG8ET.3U4PW88BR25W@mailbox.org>
In-Reply-To: <76cadf51-bc18-4a16-af19-1103e0b7cef5@suse.com>
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
	<I7E8ET.MZV7K8OOT3YS1@mailbox.org>
	<76cadf51-bc18-4a16-af19-1103e0b7cef5@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-MBO-RS-META: i956ty6c4b1nxbzz4bmp6a9n5c345frj
X-MBO-RS-ID: 51f44138825c3c785c7


On Wed, Apr 29 2026 at 10:57:02 AM +09:30:00, Qu Wenruo <wqu@suse.com> 
wrote:
> 
> All I can do is to enhance the docs and hope there will be no more 
> end users sticking with stupid swapfile idea without really 
> understanding all the limitations.

I think we misunderstood each other. Running balance with swap disabled 
is not a problem. I have just done it, and as you predicted, many more 
blocks were identified for balancing.

However, I cannot disable swap permanently. If I am planning to migrate 
away from a swap file on the Btrfs volume, then I need to resize it to 
make space for a separate partition for swap. I was concerned that the 
super mismatch earlier discovered might make it unsafe to resize the 
partition.


