Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D75C3932C9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781515111; cv=none; b=IeyTLdlYJRn0CMjFgz/efyWLII8YwKSKBwpSyKUo/4UvMBu2JTiNhGJUULa/taoKJ84qU+gbhY/pKezoBl20KmC+srx1hv7l2ex4mzH4T3Wkc9CPfPUcdY5yohk2xgxYOWW2YNgSbxX1DG40p53OfWGTJb7RcREzWYRaZ26m+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781515111; c=relaxed/simple;
	bh=UPsQlLgD6yJK1My7z9cXExqrbaKCs5s4CfXY9Sn8qmI=;
	h=From:Message-Id:Cc:Subject:Content-Type:Date:To:Mime-Version; b=HsiSZlTMyTVKpdMOiqtBXSzpMFkSP7Auw1wxg8bxiw34O25p/RuPEKEEyrnklu1OUjparTRgACNl1gNiM4rJtpXTN+kN8flq1S+DnwWRCdVcr8reYdXaU717ylkRiI3X3S//6R1hUok/k7kCc1xDt9A9o4+uhgHoKjWvX4xRi0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=A4kXL0Fa; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="A4kXL0Fa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1781514989;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UPsQlLgD6yJK1My7z9cXExqrbaKCs5s4CfXY9Sn8qmI=;
 b=A4kXL0FaAlHrCl14jcu9PFUHkqL+lejUmnfY71MpcNme6PsM8ESXURRYmcPK+FQ+EZqO2+
 fFwcx43Hwv24raWvWIXUvORTkUqTm1C/AGokjVI1kSqMcbzKaQgfqV9G3p0lBWdddI7foQ
 pozRXjdPjO9KErrr0xPsF3QN8HxLpjN2QiwkoofFtlYamJW4tKl68TtxqcZELa677ZBosJ
 iDHdnUKDEnDOil8ZcFHBpWM5/Vlv7Cjb78yNkR9yJA5ahvgLy222QheT1qaGmA59wHW4Oo
 zkgdtCf6fhQwUy3mYeCCPQcxX7n6cLqUvVpdYPxAnlwzLP9zW1Knx2B9E1xsAg==
From: "Sun YangKai" <sunyangkai@fnnas.com>
X-Lms-Return-Path: <lba+16a2fc2e6+d23ac0+vger.kernel.org+sunyangkai@fnnas.com>
Message-Id: <e3f872938a6ed3061a08ba18713f6d416c0b65be.f237395e.6fc4.4578.b4e1.98cb5eafd212@feishu.cn>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [Questions] about defrag related logic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Jun 2026 17:16:21 +0800
To: "Qu Wenruo" <wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi Qu,

I'm exploring the defrag related code in kernel recently, noticed some code seems misbehave in defrag_get_extent() and related code path so I want to double check them with you before modifying anything.

In this defrag_get_extent(), we use btrfs_search_forward() to search the tree if @newer_than is not zero, so we may skip some existing extent items and get a large key.offset. But later, if key.offset > start, we mark the gap as a hole, which seems not that correct because that range may contains some old extents.

The comment of the function says it will return NULL if we cannot find a file extent matching the requirement but we returned a hole extent_map instead in this case. Currently this will not cause visible misbehavior, because hole and old extent are both 'skipped' in defrag related logic IIRC.

About the design of this function, I still have a few more questions:

Why we need to use btrfs_search_forward() to skip old extents? I don't think a normal search_slot() and then drop the too old extent is expensive here since we only care about the extent that contains @start. So this optimization makes no sense for me.

Why we need @newer_than in this function at all? We already properly handle the old extent things in all callers of defrag_lookup_extent(), so I think it's ok to just return an old extent and we don't need to bother with either btrfs_search_forward() things or drop old extent at all.

And in defarg_check_next_extent(), the comment claims a case that
`... or we'll hit a case we mark current extent for defrag, but the next one will not be a target, this will just cause extra IO without really reducing the fragments.`
Does it mean we should count the next old extent in target so it can merge with this extent and we can get less extent and reduce the fragments? But the code seems doing the opposite thing.

Let me know the direction about how to improve this if needed and I'm glad to send a patch.

Thanks,
Sun YangKai
