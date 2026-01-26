Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E761A3178
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 01:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769392738; cv=none; b=PrD/Fy8LFRH0xCxq1RDgRaHIViO7wDD6Faq7XR1FIiPWF8eeGGkbgJanY9wA3yPK04QWNmUw9dLa1tIf5BSjTkk5eChP7B7MBhzzR9D2pgA3Oi/dQkYJP5nwnzaW8FXOMckloJNMWzMKHFeX01Tjop0FUIrS4lDo3qM15Jz/8mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769392738; c=relaxed/simple;
	bh=5SxrLaCVLxEjXjsQp7f9HfiMo1GOgr6z3qaxmhkYglg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Op8XKzECmucu9klYgoXs1bSTaLbtk2hjXDnOd3IEE+X8jn1j6XuM4j1HuiId0TUSWdVO0PDrxXFgaJNSwb/iS/i81/FP5eyya4kk79/W7WWmQn0zlFLpARrwmfDMi8TM4jzEVg1o0Z4PadhDQZ/tlLf4kiJGVs9t4iu3AFyKU8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=rZ3fMv8T; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="rZ3fMv8T"
Received: from vbm-jinbaohong.. (unknown [10.17.211.178])
	by mail.synology.com (Postfix) with ESMTPA id 4dzsCF2mDQzG951xp;
	Mon, 26 Jan 2026 09:58:49 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1769392729; bh=5SxrLaCVLxEjXjsQp7f9HfiMo1GOgr6z3qaxmhkYglg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZ3fMv8TJACbPV03NRQRqFB34hVVKUHYjGpP+GLokiOvaQt9aK2WQmi0a2OlYNWSX
	 RfMCeDyV9g54WL79VDu6qQnsPveYTwsOtbY+MVgcli8OU5BevGxBuaayiKz2KYFP2k
	 Raq1ekpu5iEDAP6iBTuWPmlbrTPBwuZ7y2ajd8pE=
From: jinbaohong <jinbaohong@synology.com>
To: fdmanana@kernel.org
Cc: dsterba@suse.com,
	jinbaohong@synology.com,
	linux-btrfs@vger.kernel.org,
	robbieko@synology.com
Subject: Re: [PATCH v2] btrfs: fix transaction commit blocking during trim of unallocated space
Date: Mon, 26 Jan 2026 01:58:43 +0000
Message-Id: <20260126015843.568666-1-jinbaohong@synology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAL3q7H4F_BR00Ro5uMV4rA=jbbK-9a9+CHzPYBmVsYRFShD8Cw@mail.gmail.com>
References: <CAL3q7H4F_BR00Ro5uMV4rA=jbbK-9a9+CHzPYBmVsYRFShD8Cw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
Content-Type: text/plain

Hi Filipe,

Thanks for the review. I'll addresss all your feedback in v3.
Including issues you mentioned in the earlier review:
- Removed unnecessary punctuation updates to existing comments
- Moved *trimmed += group_trimmed outside the critical section


Thanks,
Jinbao

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
