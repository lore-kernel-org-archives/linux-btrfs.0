Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF1C2EBBA9
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 22:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776465477; cv=none; b=MfpiznjsVEjLALJQdJ1AYMUALepndmEKd/65wsTTGVRAXoA+geEk6Jb0KFO6lHLvVyxTirYEii1kDCdOOVuoptNhyzFC69APhGmg8v2BuRlIpW2XyIuzWEzy6kZfiQrSKsi7lK58NHCeAzjwCTn816OCxanJePUSAdRsl+Pifg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776465477; c=relaxed/simple;
	bh=wRUPPP7ipJRZe9mTngQnYkDwL1j00E+IYZnpxduZF4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xp51sRwKXfsEqypzf7tmWWEHuVU+eOF9vRPmlec0IT1wGkj1lRuow1maJ08z7dLOeaNCabNgME0dMGLW0KXCWHlbbp+BZVOIoSUQ72ghIbHVKHWFHyKGKO7YcROGEvMu+tZ7jfXJ51+AxHJhfbXSOXkyxWCceaKspeIPs16AJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=WEJ15hlL; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="WEJ15hlL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rW3yNX6WJr4K76YsQW0StJID2J7Ezu4WvDQHWhhYsZM=; b=WEJ15hlL+cy9ohBdqzKeqaYV+X
	yn9EhCi5dhOr1kU9aY9+gMm4CJOPOSEdcZSGqw7kGA7bCE0H7+yJGcpd4fwlRFdby/8K4DDejYzS0
	J41UIIieL59cWMzK5CeVphEXXA1Gr1723OViJfYbxnuoexoWftiJhfW1zEV3xF3bJFeJn92hl2baN
	aYAaM8x9Fd02eHUXwCda7lUe1Id6aRjrXY7Fo82NS2aq9dNNMUYKdJ408mYiAqIFY//RqXAxXmNzz
	qCuo70YpcVYny9LBavcEFgGo8FjzN0NiG4/pGQqA1MtuLeSMpCZumOaGDv4eI560nNBOmLJDovAFF
	B87wt3kg==;
Received: from [24.6.49.44] (port=43508 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDroy-00000001y6s-0aF2 by authid <merlins.org> with srv_auth_plain;
	Fri, 17 Apr 2026 15:37:56 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDrow-003e0U-1m;
	Fri, 17 Apr 2026 15:37:54 -0700
Date: Fri, 17 Apr 2026 15:37:54 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <aeK2QgUCefpVY4KX@merlins.org>
References: <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417215127.GA2310330@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Fri, Apr 17, 2026 at 02:51:27PM -0700, Boris Burkov wrote:
> Just to be extra clear as it is relevant for fully understanding the
> repro-space, are you managing these purely with receive / subvol delete
> commands? 

yes

> Did you ever delete a qgroup that was straggling around or add
> automation to do that (btrfs qgroup destroy <qgid>) or did you ever
> disable/enable squotas besides the first time?

no to all 3

> Were all the squota enables on existing fs-es?

Yes. My understanding was that I have to create the FS first and then
turn on squota. If I could turn it on as an option to mkfs.btffs, I
would but I didn't find such an option.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
