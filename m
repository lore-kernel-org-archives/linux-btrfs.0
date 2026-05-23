Received: from mxex1.tik.uni-stuttgart.de (mxex1.tik.uni-stuttgart.de [129.69.192.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EF02E62A9
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779554326; cv=none; b=XQwjuzunULKqs3DdgjJ1dHcI3D3H1ZU8gwBxrpE/HbZjjFiI5jSDe79RUS9Bf1L7h2UQFmD6UXE/JP+1D66f3stpA8+I245nmd6/5deZ9ccynHKQO71gTgLLCAbjBVeplWKYRWOU7Gzh/FV0jj1/oQ9Ur2KBM8QBaXvGjUxTM2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779554326; c=relaxed/simple;
	bh=XSHp8n1BrThm34MncY2qkNMZV07hpPtsEeaWFVAC5zs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rg6xGn50FYxtyMevMDkKBDVT07xzR9Vo5xAdPQdeRrP+JN0wSNdlSmrg7q6AR7PKqTrk9cMcGD4tHRR/d5yLQJwsxpeuSz7mgCJd57R8lQtugWrI5bZPUvLel+k6IpdfBrW/nzAGNpHPkD8phAVWwDdcetDSYlZzIobgkwnjRnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=eMCCkQvI; arc=none smtp.client-ip=129.69.192.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="eMCCkQvI"
Received: from localhost (localhost [127.0.0.1])
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTP id 3654560DE7
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 18:32:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:in-reply-to:content-disposition:content-type
	:content-type:mime-version:references:message-id:subject:subject
	:from:from:date:date; s=dkim; i=@rus.uni-stuttgart.de; t=
	1779553959; x=1781292760; bh=XSHp8n1BrThm34MncY2qkNMZV07hpPtsEea
	WFVAC5zs=; b=eMCCkQvIQceDDlPxNmbUaPIJ6wWJzqrMQWfHvpjs3SuAynwNUsf
	7QlXctzUlH5gw5nm3Y55NS8j3/Z4awkid4UISzRDI1hAMO75NYUeCfZg2LoO4Os7
	Zeh37kV9zLaR7kFVzeKsM9AWxzgvHOcTpbRb6m/PxKXap8FpeOb6kmUQGLbDa3qt
	LVgKjz0Qj98dhESCZSl0ttIYatpMpbhMX/zacxCGm4hAzAGz6D3rb0KsY2RunLiD
	aRQRAGHjeSYECE8VPA5ErQ9w35Z3ewCnYyMeT9vvmyjoeh7VtW9Z+EBnUFunyNa0
	m7tY3E7xjDFG2mePY2VkRdZyqeeSjLqhnuw==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex1.tik.uni-stuttgart.de
Received: from mxex1.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex1.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id 7YrS7v7XPsmk for <linux-btrfs@vger.kernel.org>;
 Sat, 23 May 2026 18:32:39 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex1.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Sat, 23 May 2026 18:32:38 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 7.0
Message-ID: <20260523163238.GA442860@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20260509235151.2070978-1-dsterba@suse.com>
 <20260522232533.GA316642@tik.uni-stuttgart.de>
 <20260523141808.GB183694@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523141808.GB183694@twin.jikos.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)

On Sat 2026-05-23 (16:18), David Sterba wrote:

> > To get the newest version of btrfs.box.static I have written this script:
(...)
> > Yes, it works but it is ... ugly :-}
> > 
> > Is there a more elegant solution?
> 
> Maybe it is, right now the place is the release web page (click to
> download)

I need a script, because I want to automate the download.


> or you can use the 'gh' command line tool (gh release download)

What/where is gh?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<20260523141808.GB183694@twin.jikos.cz>
