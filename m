Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FDB19E968
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 02:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776047671; cv=none; b=Wv+HABeRJeQvT4zYDRvEJIp0AmN64SL+szpi3CeZbbMpLUbg1FCHoXd6ZYnceISkKM0hXvF3j7VNVpHeO8bu3EPZeinnhdIlCvofyhYQe7XMzlfqY8ZtA/T6p2nUK90HKYm5CRiuryuQuovUpJCz+2JkfyRVpzf0STVS8nFBTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776047671; c=relaxed/simple;
	bh=NgsRaRbKp1nSOFK55V/ETaFwRzisuU3AgHIFU8d9Sv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bNp+mHKEzjQw9TryObpbCikXB6PmIyD0gwgDL+xOsS1gRhQ47wyWEB5PR3OhLS9T37mu9qYtbBfVJDVaZx6YyC8VHr+VIvQReYRUFTIHvI2cPxMQ/iJAKZ4SaaB+h0SBNMxf8ODz4ULBgD0YHP7d+lPHmRHoOkOFvsL3Q3ebhyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=mPDojc7S; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="mPDojc7S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KeXfODUuQ4aeJlypbad3PzH26RLh6+WSIjdyasxlqH4=; b=mPDojc7SVcGaD67uSD/IpHfHrz
	jANIwSWTBq2dJEwYt1WisA4ckuh8bx3o4F08rNWPQJ5P7YDBAjrNEIy2/dlFQa5fHFz8umGln20KO
	tUoSNWzJAh0dKoBcwD55/JY1tkwHcNJjhSzmEcnVQSimO1sgzBfjKQo+PkQ0kYExUbsag8SE7s35g
	7b7tpBXgm5g4g+R5LLUf4RipJL01LneaDLLSsy44yKJTBZnne+Z8hw4yPh0xW27O9sH+WwuFz1GzY
	u/d44XoHYLjE1RzoEXOypv3nMWtEsMFM8Z7HlZ4kwRMt9NciAxC9GxIs3Op/OQ8YLcQ/QDed4cgdR
	KfXWhagQ==;
Received: from [24.6.49.44] (port=52068 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wC789-00000009JP2-0sz9 by authid <merlins.org> with srv_auth_plain;
	Sun, 12 Apr 2026 19:34:29 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wC786-003sjZ-2w;
	Sun, 12 Apr 2026 19:34:26 -0700
Date: Sun, 12 Apr 2026 19:34:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <adxWMtHwAfhfvYvJ@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <adr8DUbqkdFyvZsf@merlins.org>
 <adsDRShNS8OkIcbr@merlins.org>
 <advYoKqUCUmD4oO6@merlins.org>
 <adv-2iUrLuHK7MsJ@merlins.org>
 <20260413071419.70345051@nvm>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413071419.70345051@nvm>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org

On Mon, Apr 13, 2026 at 07:14:19AM +0500, Roman Mamedov wrote:
> I think you'd better not put LLM usage in the forefront of your messages :)

I'm just being honest about how I got the commands, due to lack of
better online source I was able to find.

> > Gemini says the following
> 
> Everyone has access to Gemini, and if Btrfs developers would be interested in
> what it has to say about their filesystem, they could go and ask it directly :)
 
I don't quite agree. If google search (before) and gemini (now) are
giving incorrect and potentially harmful answers, it's actually
important to know. 
I'm a developer myself (for much simpler userspace code), and if I don't
have sufficient docs for my software and users end up finding and doing
the wrong things from google searches or LLM suggestions, I need and
want to know.
 
> And that's a whole another story, arguing with a person wielding an LLM and
> trusting it more than a person in front of them. Many have been there by now
> I'm sure. :)
 
I absolutely do not trust an LLM over anyone here or any actual
published doc I can find.
I've been stuck for 3 days with a broken filesystem I need to fix,
cannot find any docs that help (but there may not be any), am providing
as many ample logs and commands on what I'm doing and the kernel errors
I'm getting, as well as the workflow that is getting me from A to B to
C, and why I'm going that route, even I'm entirely wrong in doing so.

I do not expect anyone here to answer every few hours or daily or during
the weekend, or at all sicne this list is technically not a support
list, but then again I'm not sure there is one (I asked, got no answer
on that topic), so I can't wait days or weeks for an answer that may
never come.
So given that, LLM is worst option I have, but it's also the only one left.
Some steps like btrfs repair which I had to try 3 times at up to half a
day of runtime each time, are also good that I already took them and 
finally got it to finish (and sadly fix nothing)

Still, even if my FS is hosed and no one can or has time to help, I'm
still spending the time to share what I found and hit, in case it can
help fix future kernels or versions of check --repair.

Since it's not safe for me to stay very long with my main backup mostly
dead/unusable, I'll wait another day or so in case any one here would
like to me to give more info/try things before I wipe, and if not, I'll
sadly have to do that and suck up the likely multi week data resync

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
