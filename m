Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91F113959D
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 01:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776301687; cv=none; b=Cn8tyUGRJ8q4cPLY8vyME7g29i+dWiPT+nW/X4sR/KDrQCX3HfikyXRwToCXgwJxbmGhTKyzhSvS0BuYNbfd8sFAjpfx7Hunk1heOEx/DkoXSOmr+AOh+NUlQenT8+Z9UuII3MsLcM14m0aO+GzPVV6p8tSEF/zsoJFaolsyA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776301687; c=relaxed/simple;
	bh=6rWSSFQW61P3TcSgUHhNFQCzdsD5de1KdLj+QMCwPX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTx4OsI45g+AcdmTYQ/eBZrIvFvGV0LwZsb4TbZSpwl2kanJbA5tQq7CpBEWorPMO3pMfEDetP+NFM7Ch/zVuJudkVUQoCT/z74s2KKwZcnkgr8yaM30uA5+ZWlrUSy9rEPd7JivWr9uS4MSA0SjnvXTJwwfS7VWJXDkvypCzMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=gYpVTQjZ; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="gYpVTQjZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WQsuP+dv9zA5lTsge5R/FpU2ENf9MnJ7JPSXB9u3mkc=; b=gYpVTQjZ9avtjGHQ4jJe115KnH
	ZoC1chFyMRVWLZOKsBH9YjzWMcx7W30aBoJz8dKVC+skdbG15iaNCV3MX7Nba7I+/HaGjJEMoymKs
	QDT+XoPQhpUw/NqH/3ZsKwKRJrE7t2apsUwZmZZV/Yt3f1Ve8TqtSwAsbwT/318ZXL06YmpZJheyK
	gh1Q1BJobsG/zEHVQtB243+aFX2IrGhG8EV+muN8q2mR0x7Kv9s/xp7qD+M8pgyEqX3/GGJRPasE7
	fVuR0XQe5XucelEKgCGFYp0bOd/BMfTJ24eRqSwJTwjZhe5wr+8ZbTGul2lHngKB7AdfMV4AdmZlr
	nP87/Q6Q==;
Received: from [24.6.49.44] (port=33166 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDBDB-00000008xIW-0k7E by authid <merlins.org> with srv_auth_plain;
	Wed, 15 Apr 2026 18:08:05 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDBD9-000DUk-2B;
	Wed, 15 Apr 2026 18:08:03 -0700
Date: Wed, 15 Apr 2026 18:08:03 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <aeA2c8V4FgCctUPG@merlins.org>
References: <20260413184731.GA3448810@zen.localdomain>
 <ad1GxXgWNBfgrRtN@merlins.org>
 <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416004552.GA1045221@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Wed, Apr 15, 2026 at 05:45:52PM -0700, Boris Burkov wrote:
> I am 99% sure this is a squotas bug now. I am able to reproduce friends
> of your issue like:

Great news, thanks or looking into it.

> I also think "btrfstune --remove-simple-quota" may fix your fs. It will
> have to do work in O(extents), and might fail in its fake mount, though.
 
moremagic:/tmp# btrfstune --remove-simple-quota /dev/mapper/crypt_bcache0
bad eb member end: ptr 0x4000 start 15495725432832 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 16568941559808 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 16133011357696 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 15495760642048 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 15641229164544 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 16027775762432 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 16217851576320 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 16217853050880 member offset 16384 size 1
bad eb member end: ptr 0x4000 start 15505960157184 member offset 16384 size 1
(...) many lines

It's still running after a while and giving hundreds of those lines.

Willl report back when it's done.

> In terms of a check option, I think I can try to detect that we
> have a owner_ref item for a missing subvol and then nuke it. Working on
> that next.

thank you. But I can only check that if btrfs tune doesn't fix it. Did
you want me to stop the tune or let it run to completion?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
