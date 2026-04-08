Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDFF35AC2B
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 23:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775689809; cv=none; b=iTfdIRDTLk0cfhYo/WxdNj95wDbECF3fz3XlFjvj6udrPfp38atZwxvUIOnkwAPURT5XurC4M0PcPTlgIN7wnGKrlN9/GEti0QjdFcPJznzJE/jBwmJ527X0yHsgbdUfiFQslafcJxxwo2oLBH2eckx73C29ZKm1zpr7oojcuLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775689809; c=relaxed/simple;
	bh=sF/4w219LH7f/vcwffYwtFYGOmpowMQVBXQwZezvf58=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DTL679WTOPFp1jkeXpWm7AFOFYV4i/RXAaIhucOJDaprBAAhCEzQQVflPbCesPZcvQhOpBd7BST7afNQKucRkRv4A1DgVmZH7D1h4YGYtZd/NpmAFs3apIzbc2wIS/j9+qioHK8tvdwdqpEqWMK8/9QC4KEzlpLUlWO+aQv0Wq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=qE7ODwz/; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="qE7ODwz/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g8Kn21AnwMXLiRVa9ZTZL66Py5a49KS3rwTXNL/TZ6U=; b=qE7ODwz//3e0Gfq1ZvQSPEh1BK
	GVjiWL5vbRbrVu4XqT/oMxyxNNhrkrPVQkBaElJbaABejZFYl6KrHiVjXJoE9sMqCiRPxXKgyQTLZ
	P/vte4nBbSH1qARrWQGdHO2GQefZfuINoEPQcpa6cBFDrB/8zzwYktYTW0vEdNTMRzIO52uKRz+Ue
	in3Z3Brg5v152jcup3aWsrNfo4zR+rjRA1F1JfLMW7tKxWjczdRwzQKYjp/VI7OkinDEDTsNjDRNv
	9XbCkOAJVggDTdQc9mVnaLkqcuu7kwYBC9F1VBaVKCaVHqfpdvtnsMIkFAN+sus7tPgxg12CU5OdG
	fAJLQKYw==;
Received: from merlin by mail1.merlins.org with local (Exim 4.98.2 #2)
	id 1wAc2B-0000000AVCd-0q41 by authid <merlin>;
	Wed, 08 Apr 2026 16:10:07 -0700
Date: Wed, 8 Apr 2026 16:10:07 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: What's the status of BTRFS RST instead of linux md raid5?
Message-ID: <adbgT-3VINfJNctk@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org

So, I'm aware that the built in btrfs raid5 support that's been there
for 10-ish years is not recommended due to hard to fix or unfixable
flaws.

But with raid5, once I have a checksum mismatch, btrfs could easily run
all combinations of the blocks to find out which one can be removed to
yield a correct checksum for that data block, but obviously those layers
don't talk, so nothing happens outside of btrfs telling me the checksum
is bad, and there is no good way to rebuild anything, especially when
it's bit rot in a read only snapshot where I cannot reasonably delete or
rewrite the file without some surgery.

Gemini tells me that RST with the future that fixes this so I can use
raid5 or raid6 directly in btrfs where everything talks to one another,
but I can't find good docs or status on RST.
Even this list has very little about RST outside of some old patches.

So, is RST kind of ready and documented, or is it still very
experimental and "read the source, luke" ?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/  
