Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0052712D1F1;
	Mon, 25 May 2026 06:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779688836; cv=none; b=lM3Kj6MiSYnv0ywOFACmEgekqsZRA3BHHN28abRbhq56qcVIFrK/qFmWLug8MH73rBpX/aV8BkBlOPwwvCwWKWnyX66FlaNd8o2ihkU+4HMgDO83BW2UcVgAT8VR26/06VeBJmOKRiHFQ4VBgYadW4r4PbWJymZfzh51bWFQa6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779688836; c=relaxed/simple;
	bh=BbuSSJrR79jDkU2ma/SgLQiauRKwS7MArDAmMuddaF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lluTXt2MFMGe+Gzta3QfjxXn2y7rLwDFnxYFLORHu6IckZR684/fYurPD0tg7smPNBDONsycpM5YkS4S9uXgdc99gaCq3daz5Ptm3vYyY4NPzSH/O14s6w+Z8GslZSKJVReo2fArYM1pp2C8yT6NWD8f05dvC5xtqXDJOeIm+sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8D07868D0D; Mon, 25 May 2026 08:00:32 +0200 (CEST)
Date: Mon, 25 May 2026 08:00:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, hch@lst.de,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260525060030.GB3370@lst.de>
References: <cover.1779412152.git.wqu@suse.com> <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com> <20260523142344.GC183694@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523142344.GC183694@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, May 23, 2026 at 04:23:44PM +0200, David Sterba wrote:
> On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
> > Recently kernel RAID56 lib is trying to remove the unexpected
> > single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
> > btrfs still supports such setup, which means in the long run btrfs has
> > to handle such corner case by ourselves.
> > 
> > Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
> > P/Q stripes all match each other, rotation also makes no difference.
> > 
> > This patch will disguise those single-data-RAID56 chunks as
> > RAID1/RAID1C3 chunks.
> 
> I don't think this is the right way to fix it. Calculations are an
> implementation detail and should be done at the time of the xor_gen or
> raid6_call, not touching the upper level structures related to format.

It absolutely is.  Adding fast path workarounds for this is completely
stupid when it can be trivially handled on the mount side.
