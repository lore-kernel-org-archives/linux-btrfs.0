Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C553D22F77B
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 03:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775531921; cv=none; b=tuARjhjNi8Z4Bgyd2H5HlnQkDDWOEowWtSuvuEYPXNc8kAIQTIDEeZmUwrEN6azAC0pT8mvzWjbiZmcVVNyrCNUqfwROA/32anUJ7cZISwhd6sj0LoquZoeL7evkvKpUe1VQP5+btrBUGba8ruzPBVW28P4AnJ2m4/piAK9EacY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775531921; c=relaxed/simple;
	bh=ABTgA5LY2U2JATMYQl6de078IFJYwifXZ+TPyXQYdIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CambcUYVTKYB3Qct3jfPg2Md+4e8Z/RdgeF8YxiwP0NlRCG5Sy5x0IRNwB5rU5YCEcl2V6bD7SqQzNN81cSaK4abAR2Qw+ruOhHHFsXLc+Um4xVq7FDnCK8HVrtYbrZRx/q787SUQLbUENf6BiG/TMqTrNjmPPH8zFiEGilZiZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=BEGOKEH5; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="BEGOKEH5"
Received: from 11212-DT-014.. (unknown [10.17.40.185])
	by mail.synology.com (Postfix) with ESMTPA id 4fqWcR224wzHnMTRn;
	Tue,  7 Apr 2026 11:18:31 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1775531911; bh=ABTgA5LY2U2JATMYQl6de078IFJYwifXZ+TPyXQYdIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEGOKEH5lq46Pk3L9jLbdp5ylnlF6h9YXWXynOWWHv41dgEydRtJ5ATFoUyoVxGHW
	 rGrzRwJtO3+6MVi3AC7dY7KR/+9BqobWsksM0CX2chg6lguMosaNjAgyo7a8iSJX4q
	 ORyZm1RCGNjtzR0L5JTRC0MOe94mUlhVyzFcBWCI=
From: Dave Chen <davechen@synology.com>
To: fdmanana@kernel.org
Cc: cccheng@synology.com,
	davechen@synology.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	robbieko@synology.com
Subject: Re: [PATCH] btrfs: fix unnecessary UUID tree rescan on mount
Date: Tue,  7 Apr 2026 11:18:24 +0800
Message-ID: <20260407031824.1207429-1-davechen@synology.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAL3q7H4FMJxNtgsNcVGiETuPSQeiJhEy0KXeC7xRxdUT6h1NLA@mail.gmail.com>
References: <CAL3q7H4FMJxNtgsNcVGiETuPSQeiJhEy0KXeC7xRxdUT6h1NLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
Content-Type: text/plain

On Thu, Apr 2, 2026 at 4:00 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> > Fixes: 70f80175472 ("Btrfs: check UUID tree during mount if required")
>
> Normally we only use the Fixes tag for functional bugs and performance
> regressions that cause usability problems.
>
> How much slowdown did you see because of the unnecessary rescan?
> For this to make any significant difference we would probably need
> several thousand subvolumes or snapshots.

You're right, I don't have benchmark numbers from a filesystem with
thousands of subvolumes to quantify the impact. I'll drop the Fixes
tag and resend a v2 as a correctness improvement.

> The change looks good to me; however, thanks.
>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks for the review, I'll carry your Reviewed-by tag in v2.

Dave

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
