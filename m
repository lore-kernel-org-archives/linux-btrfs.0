Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5433D0C07
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 06:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781590976; cv=none; b=o7uq5sJ/6n19ATmNpJw+2wSsWctlcUyLtXhmqzMid9RDoKfVWYIwF2Fp0bGPSqO9j9oB3VAK6ah7X1pp/XCYIZxIJLrmhC+sTlReEXbZjnil0f5FVgbt2ehPOe3Vu12rZZOPrta9Ca3++lHJFpTYU2INZUQk177xVWZ3sxrPvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781590976; c=relaxed/simple;
	bh=wgr7VvYydfKVGNgYFfnsYgsnbhqLFqqn03RaTS6WC/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gr1LpK/TPBG2fUBYljI6f6zwcWuMhbVJfdaxmZE3aFxsdRXViFR75ByJtexSlmwajMSaQx0F4D4s+thiMrs1po/rLACndxiiqB0Mf0k/iHewO0BmQmU026n1UK1ERitH9Igk+ljQuZq2fnCJIeKxzt7SPrMvFwAF74ErWvQ4Uk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=nk6Ou+XV; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="nk6Ou+XV"
Received: from 97097ad21e24 (unknown [10.17.41.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4gfcNs12g1zK6fHlL;
	Tue, 16 Jun 2026 14:22:53 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1781590973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wgr7VvYydfKVGNgYFfnsYgsnbhqLFqqn03RaTS6WC/U=;
	b=nk6Ou+XVeFPkoTmVZ8Kn5TkqHGZRYbS8Gyr6rIwguWDORLSCEEATqGWWMVMKVDi52w3TDF
	9h+yJxecUgidB2hIyen1wPkQ0cvGZh2h0+YEOd0haPlCKIT7O/MeNl2Zl93mOsOGEgQqqe
	vHg5VL5uYFl6KERqhqCAse9yqgbsrxA=
From: You-Kai Zheng <ykzheng@synology.com>
To: quwenruo.btrfs@gmx.com
Cc: linux-btrfs@vger.kernel.org,
	ykzheng@synology.com
Subject: Re: [PATCH] btrfs-progs: re-enable tree search v2 ioctl
Date: Tue, 16 Jun 2026 14:22:00 +0800
Message-ID: <20260616062200.2010804-1-ykzheng@synology.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <545cce1f-5da7-410f-8ef2-9779e8864b43@gmx.com>
References: <545cce1f-5da7-410f-8ef2-9779e8864b43@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Auth: pass
Content-Type: text/plain

On Tue, Jun 16, 2026 at 01:44:11PM +0930, Qu Wenruo wrote:
> Structure btrfs_ioctl_search_args_v2 should use __u8 for the variable
> sized buffer.

Makes sense. Do you want the kernel uapi header updated as well, or
just btrfs-progs for now?

I checked the kernel already casts the buffer to (char __user *) in
btrfs_ioctl_tree_search_v2(), so only the struct member type would need
to change there, the ABI stays the same.

Thanks,
You-Kai

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
