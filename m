Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6733BC68E
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 02:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782787762; cv=none; b=rCVcV1NGwkdWzIORX3VArWEuhZYjeB8+LojjmSwxxCvdF/iYNqAYw6gR35AaLrTOFXPa5ER1uEAbuobGDo0VO6IvwKpUaS/afBeifB2EcwY/BSQz6CNyu1zXJFkBHndQ1houYyfVjbI/PzJ/iym75jmkks6lAYUmpK74OFWCOaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782787762; c=relaxed/simple;
	bh=TuYPrxTOYduc8BCgy6Gb6v7n32ZoU6FBA3DhE8GOzuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2dic5j/NFgQZC3Zd9XO/RH/UomehTKTl5nO9GFBva1VrTh8yVOJJJgT/8xldMw3CvAqHUV7qP3OVyOteGYmOt+bapynVVHNISkPAFxuQufj45bu3ykYMSS9+8LRpfYoSTPaRiC+NBm2Wf7kT2IE2pDG7XNhuNYI/XaYHh3DFdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=AZf9j23f; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="AZf9j23f"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4gq6zy5gSfzKMrKkH;
	Tue, 30 Jun 2026 10:49:18 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synology.com;
	s=123; t=1782787758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DTGlhBYdBaoJsKoJCHyqp1MlGaP0b3HP/VCV7g+n9VU=;
	b=AZf9j23fqYXbU3heG0gw6e7J+TWFUb14loqq3puUoxDv/QOdtzW0uAG8dJX3W6p9ZpzryD
	O78UbXqxy+ZP1/qhpu732Z4S6SR7zRAVW34S9Z0WJusAMBro59AnSYSmXi77Z85VFNe0yo
	VohUL9NexNVnK/MGRHgDynHVHigdPYI=
From: Dave Chen <davechen@synology.com>
To: fdmanana@kernel.org
Cc: cccheng@synology.com,
	davechen@synology.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix u32 to s64 type conversion in dirty_metadata_bytes accounting
Date: Tue, 30 Jun 2026 10:49:16 +0800
Message-ID: <20260630024917.449937-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAL3q7H5x_nz79nJv418DpWCeU=Pk3Q7zL3cCDpNNtj2to0ij9w@mail.gmail.com>
References: <CAL3q7H5x_nz79nJv418DpWCeU=Pk3Q7zL3cCDpNNtj2to0ij9w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Auth: pass
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no

On Mon, Jun 29, 2026 at 01:08:05PM +0100, Filipe Manana wrote:
> Curious, do you have any performance data to give an idea of the impact?
>
> I'm asking not only for clarity but also to determine if adding a
> Fixes tag for stable backports makes sense.

We don't have upstream performance benchmark data for this.  We
discovered the issue while debugging an unrelated internal bug —
dirty_metadata_bytes had grown to petabyte-range values on a filesystem
with a fraction of that in actual dirty metadata, which led us to trace
it back to the u32 negation.

The writeback impact described in the commit message
(balance_dirty_pages_ratelimited() being called unconditionally) is
based on code analysis, not measured.

I'll leave the Fixes tag decision to you and David.

Thanks for the review.


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
