Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BF83783C9
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Feb 2026 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648687; cv=none; b=o/shOmI82GCpHC4xHTE4rOkVqVZTcayEABOUAoi/o8oVdgTrS8WCzfqbGXUc1yA8wkBw4yLsyZaax5hejGqdd7B8wFEa3xwSJfHdo/7CGD9OH0qVEHAWPNdegrNW5ljsbipoaJwjDWim2eu4oqOCQLapoBctuUyb8l/Q9TAjPaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648687; c=relaxed/simple;
	bh=YjsKth4aP23kQ3V+lW0+o6KuhRmLjvNsyLssxRZS2vQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g3aBA1f8JqRh/0ljYd7m+OW3uDuzzk7drSgpn5mElmD2yDX/oy5RHPNfsYk4cpW5TZscfTbbA1q1vLHLjD7a8EAxAnOZzB1hmNuKYB0idv7SlsDNHR6N9pazDFBjIrTOd71puZ12n+mnpjS3zF26F0ZJ5Omga5JiUmdGxqjEgc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6F0E968CFE; Mon,  9 Feb 2026 15:51:24 +0100 (CET)
Date: Mon, 9 Feb 2026 15:51:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 0/3] btrfs: zoned fix two long standing ENOSPC bugs
Message-ID: <20260209145124.GA17906@lst.de>
References: <20260209143644.96411-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209143644.96411-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 09, 2026 at 03:36:41PM +0100, Johannes Thumshirn wrote:
> For all these patches a single reproducer was used (and it can be turned
> into a fstest):

Yes, please.

