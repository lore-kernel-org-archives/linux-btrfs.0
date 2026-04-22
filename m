Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A89925A2C9
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776888663; cv=none; b=TYmxXMAqU7hJMOh4vyOiR31hzKbPp12OuxPWq632McQswThiA8UMNwiycMwCRXPk/kvMW+/Y/VHShNMigxYETDP8KQcxoM5witjGXuG3UHCS60in5BYBVOepCqZLo8j+wo3dKzejRVPQ/Y+yAFI4ZsPpYPofqoM5LrsriSjpNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776888663; c=relaxed/simple;
	bh=/8xoOmsWipjJg2hDj+pf2uCa/W7ti6ctYHkfaH3RVmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWKKnFWt4NzApAd7BT6oPAZ6qZCAdxUCQRc8UDbIsF2UImJeP1KVOtWVxdqtRgftl3Mgpif1Q9n8/h+TesqT+y8iD6Zw/YRohKgpMPCAM6swGRAVCixGWkQohJooari9lSRyO06UxrYjTQLacAf6TaXKo6yBK1mqzzZnsNiNDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=H9VkSsEF; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="H9VkSsEF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jED1UwRuDrMBEVAfMuXFcY7jQiB6PywfHR8+lEB7fto=; b=H9VkSsEF5ciyBkpvgXQPr442M/
	9n51MydvVXBbGEBI4JFhY2zGb9v9oE9COA+/LPrI3syqb4mjbf3dSqavHOHBUWpBzoz6PjaMU+RAO
	dFFlLhlbOesS3cSowD2MF0Y5rfqDBiYlf+zWRuMHdY8jvNFPKIIpH9Zo5wZWAf5eitaTzRh/n7jAF
	0tf7n4XPF0uLnaELoK1MnyL/mfSMHa1QQPyZDq7ihzaiPWmSpNyGw7mI8uLTS78IfkC27h1tzvCst
	eOmnDIj55fkEeaBjSKFq7DkSjmSGAWZ7vIhqVSvWBTjzhkiMM/NIaCfuoACeDslA+UxgL9WOFsr3F
	rk4MCWnw==;
Received: from [24.6.49.44] (port=52494 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wFduX-00000007mv8-3YoH by authid <merlins.org> with srv_auth_plain;
	Wed, 22 Apr 2026 13:11:01 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wFduW-00AObJ-0y;
	Wed, 22 Apr 2026 13:11:00 -0700
Date: Wed, 22 Apr 2026 13:11:00 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <aekrVJnCaGkYWeBp@merlins.org>
References: <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
 <aekA8mS4hppTjbA-@merlins.org>
 <20260422192344.GA1392535@zen.localdomain>
 <aekh8CX_LmbtMbQ_@merlins.org>
 <20260422193853.GA1478152@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422193853.GA1478152@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Wed, Apr 22, 2026 at 12:38:53PM -0700, Boris Burkov wrote:
> No, I'm saying that there are two explanations for your observations:
> 1. You have legitimate shared extents owned by the deleted snapshot.
>    Presumably caused by bees as you guess.
> 2. A squotas bug where we have usage recorded for your qgroup but no
>    matching extent in the extent tree.
 
Gotcha.

> btrfs check will walk the extent tree and add up the extent usage based
> on the squota owner refs and compare that to the value stored on the
> qgroup. The squotas invariant is that those are equal. If it complains,
> that means there is an extent attributed to a subvolume that isn't in

Gotcha too. When my copy is finally finished, I will run a check and
report back.

> As currently designed, squotas is quite dogmatic about never re-owning
> an extent from the original creator. That is the core design conceit and
> simplification that allows it to be fast. There are likely narrow cases

I got that part.
What I was saying is some out of band way that would be slow and long,
but only run rarely, to fix things that drifted.

You mentioned btrfs check, maybe a check --repair option to regenerate
squotas on an existing filesystem (also awesome if you add squotas later
and want them to be correct). For extra points, it would be awesome if
it were while the filesystem remains online, even if that run takes
days (since it would be a one time run after converting to squota, or a
very occasional "fix things up to be all clean and accounted for")

Is that possible at all? (separately from being worth your time, which
I'd understand). The biggest plus I see is allowing many people to
switch to squotas on existing FS without having to wipe and start over
just to benefit from squota.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
