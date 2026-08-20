Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11AA43849C
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226348; cv=none; b=XmN942J/NybbPGxzzkh3vhAFd7t+i+bNADkrQUlHUMtebKi7Gq4v0HJBfFV1nlZx6EvZ/zzltkOTnoZQMACE/xcW62ww06cSx0gAqeNT/23UHFZ9s1bomxZkZ9lDqDOZDvECsNa6dzc9Z0BG/nGYZnBTInhMbNfBE27DqCCptGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226348; c=relaxed/simple;
	bh=uQbXgUL4/UgUkMAm/aGx481TgJhQ2YEatKjNQvhyDWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4FzI4XmONkwdzc4wwL+/tESMj7jJ5/tgF7N8HzJr39UIvmPu2OQGqt7t4ba7LKZ+oglUo5MT+CXupEldxL72L6FmCrDisIQdRKfrkjKHElWAidjrtMfzAJ9wUXXp9/aysv3+x5AjIWBIXH2x4zf+PrgJoZrgp5+MxA+b82M2Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KPgrSXq3; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KPgrSXq3"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uQbXgUL4/UgUkMAm/aGx481TgJhQ2YEatKjNQvhyDWE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787226344; v=1; x=1787831144;
 b=KPgrSXq3h3ZdBFnSq3NbGaBSlxWazmY3LxKSQhdMP20/66UpLco2ffkKTg/W4XR/NPZ36GGk
 BCPSjmqqTuelu6dE/6Guj4MqNyfhda50rI/pFWXR3W2Xgj02jtvVk9N4AjSog4LrIdK8p8I1VBs
 mXpxo1pbcDe0OWupqyZr/yZ0=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: from localhost (87.104.0.147)
	by smtp.migadu.com with ESMTPS id 60091b113213af75;
	Thu, 20 Aug 2026 11:45:44 +0000
X-Mizu-Trace-ID: 60091b113213af75
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 13:45:37 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
Message-ID: <aobov7x4-1uXpJwG@quentin>
References: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>

> [FIX]
> For iomap_dio_hole_iter() round down the copied length, and revert
> any excessive range that is beyond the aligned copied length.
> Also use @aligned_copied for the size increment and iter advancement.
> 
> This should only affect btrfs, which is the only fs utilizing iomap dio
> with page fault disabled.
> 
> Fixes: 001397f5ef49 ("iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
-- 
Pankaj
