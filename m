Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A918D636;
	Tue, 26 May 2026 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779777959; cv=none; b=DXzbCvv+HBtPfcczfEu1535Qf5XUXR6IMLvHu2UfTwU6bRR+QV+/p9qMTwXwo0loyvQOKOlyLqV09jARyXrwPXbEvamnox1Z77ywZwfbLK0NIUg1WwocOaBN8933xrKVJfQ+iksG0DFIH9rxb/CE+m/F+vlIYhUAdCXIN7Qojws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779777959; c=relaxed/simple;
	bh=OUibmlNZj1VZ0fQ8rEsKyDwq7OKDpmDls1YSbgly4lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0dVl9tnqNyjLaqSrCVxG+iUGuvHu/Do4figfxGmMosKvOPmc5Awtoeh+vwL3g1zAijm/24rX6s7GLtjhvTZGFYWC0x4zqZnQgME1lu8Ke9I4d5mC8dzMJ4dcEapPhhf9diW2AmGgWkYEfT9xtgRXm9WortZO2APnzRiPhAV0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 075E768B05; Tue, 26 May 2026 08:45:47 +0200 (CEST)
Date: Tue, 26 May 2026 08:45:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Sterba <dsterba@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260526064546.GA25187@lst.de>
References: <cover.1779412152.git.wqu@suse.com> <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com> <20260523142344.GC183694@twin.jikos.cz> <20260525060030.GB3370@lst.de> <20260525101707.GV12792@suse.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525101707.GV12792@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 25, 2026 at 12:17:07PM +0200, David Sterba wrote:
> > It absolutely is.  Adding fast path workarounds for this is completely
> > stupid when it can be trivially handled on the mount side.
> 
> It's a lazy hack at best and fix on absolutely wrong layer. The library
> should provide the support for the edge case. But we disagree on that.

No, the library should not provide hacks for something it never intended
to support, and which is a bad idea.  It's also something the
implementation that the library was factored out from for btrfs use
never supported.

So adding the workaround to btrfs, which caused the problem is a
requirement.  Doing it to only create mount time overhead instead of
burdening the I/O path is a very smart way to solve the problem,
while adding hacks to the I/O fastpath is everything but smart.

But in the end this is for the btrfs maintainers to decide.
