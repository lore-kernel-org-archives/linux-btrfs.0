Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892537186A
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 19:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776886262; cv=none; b=mpvd1I4tK4bQgP+3PaWbaRdCM7+LsS8+AHUpRbMDPWpbng4K83tk/FXYbSk0XLQSIDL3R/PznPZA2ssFoZu2qfBHTzomzKxkFNDf1S4srwv5CQM8szzZMJsVl2GiQP2eKEuhutjhNZYUewUdvWa6J1GBdQZzBA6QJ3eZ03gMRx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776886262; c=relaxed/simple;
	bh=s7PG8jagWNYBXNmSNg4smzElPR7X9kU8y5LYPfv6Ceo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrqonwyA/JIpRN+DhMCqILeC+2GJi+MmueuAz7NObjEe5Fl6thpWsU2bs/lxU5LdTfujvsFznETgY4dsNmfYL9aZc3hGBHd19L/R74msllYChZC0p44+hkRfLTro22KTRZzBoLrD6ZGbL0PeR4alpqf3ZMHvJl9vcjcX9NJh3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=fyoUaVpM; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="fyoUaVpM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9IOAAH7s+HIuxRyOtAPxRia0uV7pUxJJZhnu8KCRYBg=; b=fyoUaVpMyrooISOkkvE9349S3b
	po8OIsvCkrhlNie8B+4kNh/UQUmcDU7o8oH/AvQEmiCEeBly4f+32xZOhLVvhT9hnnghVKpJBgioR
	g3NU0Ps1l+UXX0SXcllCDIoc6hktV7YO9XyH1xRw2aGVP/zbUw0M8BeBnX66qsPdiyut5CuHyRrdw
	8lti+vHC7uutGtlZpF7b8dmiK/9Xf0nzWrQPrKTcePoGW4dgLZr4W/En6cSb/KcFi5EfDci4DSH+2
	IDNdSG+4D5PpWAWLrksvZXG79ryFkgVwIaeT6TjCbgJEEy+uCYFudZg+9vlijiuq/tVR64dacCk4U
	wXoJZ11A==;
Received: from [24.6.49.44] (port=49280 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wFdHm-00000007gBd-2Dg4 by authid <merlins.org> with srv_auth_plain;
	Wed, 22 Apr 2026 12:30:58 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wFdHk-00AMKT-35;
	Wed, 22 Apr 2026 12:30:56 -0700
Date: Wed, 22 Apr 2026 12:30:56 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <aekh8CX_LmbtMbQ_@merlins.org>
References: <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
 <aekA8mS4hppTjbA-@merlins.org>
 <20260422192344.GA1392535@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422192344.GA1392535@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Wed, Apr 22, 2026 at 12:23:44PM -0700, Boris Burkov wrote:
> > Is that still working as intended and I don't quite grasp how?
> 
> We can't delete a qgroup that still has usage, and subvols own their
> extents forever. So assuming no bugs, this means that some other
> subvolume is referencing the extents originally owned by these
> subvolumes. I agree that this sounds relatively unlikely for a failed
> receive target you immediately deleted.
 
Right, especially a read only snapshot (btrfs receive), which I 1000%
know I did not re-snapshot again or re-share/re-use in any way.
The only culprit I can find is bees whose job is indeed to link blocks
across subvolumes.
So maybe the way bees works, it make squota think the new subvolume
is the main owner and when that that is deleted, it doesn't know (as
per documentation) to re-assign those blocks to the older subvolume
those blocks were shared with after bees linked them.

> I believe that btrfs check has the ability to reconcile the on-disk
> squota owner_refs with the on-disk qgroup values and find any real
> discrepancies. So if you run that (without repair please :) ), and it
> doesn't complain, I think you do have some legit sharing happening, and
> you can try to track that down more directly.

Assuming bees/beesd is to blame (the only reasonable culprit I can find,
but then again it's doing its job), are you saying btrfs check can do
a one time pass and re-assign block quotas to the remainin volume so
they are not "lost" for squota?

Also, I understand the whole point of squota is not to take the huge
amount of resources regular quota does, but is there a way (now, or
planned) to do an expensive and occasional "re-assign/re-align" blocks 
to where they belong when squota lost track due to how it works? Is that
the btrfs check you're referring to? (but then again btrfs check is read
only, is it not?)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
