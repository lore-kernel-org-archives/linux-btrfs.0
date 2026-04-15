Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942812580EE
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 05:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776230523; cv=none; b=UCeai/RwJXmiDhILDz3P2n1DJEUrG5zTLJkItUZPlsciLMMzsC6klPmrMt7x6Q0TjqiiWfE9RvvcLWbuHv5ZrRuaLk6w4kTJPL3QT3K5ZhCe9eTmGp1X3X4Gb7vY19ODWTdhHTk4adJMPaZIBK98zKcdgCsdNf7gLAJozgKfGXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776230523; c=relaxed/simple;
	bh=u4fWu9e6XdoN+clsjh1xsYtjNivFPVeSIAaEb3tMmlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SB/5pbMKzwA4UF0PFs1/QaE+eu5ghE3AsJX02gPW/5SFXaHayQbwTOToWQiiZq7sGqDyWzeU1uaZDZyLX1vZ+UE47R0Ff6bUqRP3ya1AVHi5BLjfb6vk2NEZSDCI1s3JEa53oNBiX7PrMETLOt5z8/5OVAi3nyqVdYY1+EWS7Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=ft1jEfxT; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="ft1jEfxT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rCFfaUI+nTHgQpm2VbtuShYYkf4EC252UQJoGqiYKQw=; b=ft1jEfxTAqf0yTQlf2fTPXGNqw
	sa9Uuc9xWMCLGa/B0ecgXIspAUbjwFXRlXf6hMXIHubGyO4C8hB3IaPf7FhvH+EWGHm8M0tJSC8LR
	62L/ACN/lrOEc99ZaCChhg8MpfHHj0bp9T+eA1oMQHWFSN24/Z/8WJY/NsnAIdYKwFRBe4ZLm/nS6
	OMx2K/pklZafrJYd3R69wEE0rvVCROnZ7yeSCmJOLNf/XGT9QGN42WPaTnZ+mQZ6J2ga+i9TeBWnN
	G5xsiNEiNAqMHrS8ZZ3BjTHU7gb7AiTrx8v5dlFiVoF8GBD6iFB1VGpmBInHms0/Sdt1fxvzGqbzg
	5NfmlbEw==;
Received: from [24.6.49.44] (port=50022 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wCshJ-00000004DC2-1y5r by authid <merlins.org> with srv_auth_plain;
	Tue, 14 Apr 2026 22:21:57 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wCshH-006tBG-3C;
	Tue, 14 Apr 2026 22:21:56 -0700
Date: Tue, 14 Apr 2026 22:21:55 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <ad8gcwTFOLUhBHGA@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad1GxXgWNBfgrRtN@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

If you don't mind my asking, and even if it's just a guess:

1) do you feel squotas are likely safe and I hit another bug?
2) any chance it can be block-group-tree instead? Are those 
   considered reasonably safe? (I enabled due to the number of
   snapshots, 100+, and being told it's bad for perf to have that
   many, which block-group-tree is supposed to fix)
3) anyone still taking bugs for btrfs check --repair since it
   fixed nothing on an unmountable filesystem
4) anything useful to anyone in my broken filesystem which might
   be easy to fix but not by me before I give up, delete it all
   and do the multi week restore?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
