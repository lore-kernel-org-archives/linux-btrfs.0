Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B35313E01
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 05:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774330843; cv=none; b=ssy23wubLKFMttO9MnTRjrmjzeQjUqUcFapu2QnhNKDY54VutB/b5RS4lRFRarpBgpkYLfdYd/6v3GWfnEKTkrlyRePDwLUGr6JffPcwSlmgqLKuGkQqrgZpXUyspyV2hWA17sCQJW1QWGoXVbkDwmXxjFaHekhbO0nhuGFQK6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774330843; c=relaxed/simple;
	bh=jtXOQILvywLV127KTTl5yJHs/Ruh7SNhN1xKgzorgdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kivE70VnIWJbRA/R337k3ss8c6waL+dIgKtxpWeykiCVnjykaeb/HqNhdfDH1vrkNkmC7Az9hQLDEF3fTbQOfAq8a6OzCxPygh4vIoUOEx19UYYNOnIi51YT4aslrZCgJ9tcQ/6at9WALFaf0xaR93/jEQ1LPcM1/vJS5usgMOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=l2Co5ipm; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="l2Co5ipm"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4ffzQv6YwrzHWZVrc;
	Tue, 24 Mar 2026 13:40:39 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1774330840; bh=jtXOQILvywLV127KTTl5yJHs/Ruh7SNhN1xKgzorgdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2Co5ipmrG73/J0qujIOGS/7V7h+GUiNqkquPuNjfImM0eU/IRx/fGlsIYCuH/zr8
	 NRRkr393uMpi7Wir1xdhrmJoqmsN8geTE6oxXj3TUOBznI940OysSZ7NXHbVZA4JRg
	 zAhPid94rV4XQJHvxYgwMUsnbShNjK9QSkENjXu0=
From: Dave Chen <davechen@synology.com>
To: dsterba@suse.cz
Cc: cccheng@synology.com,
	davechen@synology.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	robbieko@synology.com
Subject: Re: [PATCH] btrfs: fix unnecessary flush on close when truncating zero-sized files
Date: Tue, 24 Mar 2026 13:40:39 +0800
Message-ID: <20260324054039.887316-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323140748.GK5735@twin.jikos.cz>
References: <20260323140748.GK5735@twin.jikos.cz>
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

On Mon, Mar 23, 2026 at 03:07:48PM +0100, David Sterba wrote:
> Does this have a measurable impact? Truncating 0 -> 0 without any
> intermediate writes could happen but I kind of doubt it's worth
> optimizing. I'm not against adding the patch but would like to know if
> it's fixing some problem for you. Thanks.

Yes, this comes from a real workload. We have a backup service that
creates temporary files via mkstemp(), closes them, and later reopens
them with O_TRUNC for writing. The O_TRUNC is defensive -- the file is
always empty at that point, but the temp file creation and usage are in
separate components, so removing it from userspace isn't straightforward.

This pattern repeats for a large number of files per backup job, and
each close() triggers an unnecessary filemap_flush().

When oldsize is already 0, the flag provides no protection -- there is
no data being truncated away, so the filemap_flush() on close serves
no purpose. The fix simply makes the condition match what the comment
already describes.

Thanks.

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
