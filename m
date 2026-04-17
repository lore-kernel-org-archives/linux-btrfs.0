Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970D3153BE9
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 05:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776403154; cv=none; b=MWiPXQOfRa9/A/nolLjJBbrziavdn4VE4Mgs3kLRubFdL9dr7p5HXcTP1MwGD4MZAYsfRWa0VictQhG3gywwrYaoej9Pdesht+mGtyuQdOHgNsrmCKbGEh5dRaJLYrWcj/3e/OwzaLX29vesFYHo2Of/SVRGvmHDgvoL8jr0m5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776403154; c=relaxed/simple;
	bh=IsdlIQz/I2QRpMJulrbKDT246Ul8bLgzFlFEY0B0ic4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8qIpEQbA/cRXA42c2y5O30KjGd+rRoAbPLCK7YHw6quQmgqGr1UhMbOnMKGFKeovc6QAHpoTXk/qgbg9UO1g5OBYXPIoC6YslfecqiL49V9NVrDX11R3XmUGWK+PGsRdU4VkZGAFZaMQQmsL2p52pNJTmS4Tu8mmhreq882wE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=KbX9BsoE; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="KbX9BsoE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=p+y+eWQLSrfi+Hd3N34l4z9IiD/akiRMsyd5ITZYvzo=; b=KbX9BsoErWn+WlVcMPGBco6cgP
	6Z5jQDuVSKQkTrrACb/CmK/aLqRc/AO1jbtnASI5eBojS/ZXtuwWeZ8pFdfJjP1jyCI1brKtXBjqX
	fQkwrxNwlfcdYKrJbARQjhuyfNe2FnUxbUunqMp+uQERZhD9ovUwf/wCpZDJ6eotH8vBt6INLjrQ+
	cOjtxAVq+Lf8iSEjBLXZrWkVr/FIhYG1+X9/7DJi+wVe2n7rJgZbTyOzDuXKJm0MRMl51ihNSCRdu
	xlsA17TUbnHdMKXpogVK/fnvpvaY7VawWDtmsiGiN0aR6Na9Y8Rt5pyFcggtC3pictwM237L4U0rJ
	rU0pLPIA==;
Received: from [24.6.49.44] (port=57676 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDbbk-0000000Fdlx-35rj by authid <merlins.org> with srv_auth_plain;
	Thu, 16 Apr 2026 22:19:12 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDbbj-002jUL-0k;
	Thu, 16 Apr 2026 22:19:11 -0700
Date: Thu, 16 Apr 2026 22:19:11 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <aeHCz5zRDN0nNutV@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <20260417134329.65693165.ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417134329.65693165.ddiss@suse.de>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Fri, Apr 17, 2026 at 01:43:29PM +1000, David Disseldorp wrote:
> From the look of your block-dev path and loaded modules, the filesystem
> is atop a bcache caching layer. This would make it far from a simple
> dev topology; bcache would be expected to invalidate discarded cache
> regions regardless of underlying HDD discard support.
> Are you able to reproduce the bug if you remove the bcache layer?

Fair question, this used to an array running with bcache.
The cache has gone away, so it's running in degraded mode without cache,
with just an extra layer that hopefully does nothing.

That said, I reproduced this twice on both my laptops that are running
without raid5 and directly on ssd without bcache

All that said, thank you for making sure we're not missing some other
reason for a bug

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
