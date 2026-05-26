Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A355DDA9;
	Tue, 26 May 2026 06:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779777994; cv=none; b=TEw7ykDzQnPUcR3vTh774/2DdAFSNi0+KHxp8+b/4HQqwuxMshY9MsJMHVI2RkfWI1zBqXJtzibgpIVbseSO4LpVqe1Tx9xF/2lTOOgc0AaMlr8QGD+eO077i9WooYYYfToDUMPJXmYHAlJUM2BzHIZ6GIko3nYRlESXIMQQud8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779777994; c=relaxed/simple;
	bh=Ukc7velbwnfULIqa3nZsgbunvm355PCg+B6x8N3EIl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajr1PxadG9KCwkcLA56Iz6ChXAKhxYBi8iy4TqoFVEEz0QiQDwSlwSUPktx6jmEkEVMGvssc1SguNDo+zSp9B8Bkw4AX2qkpZ5BzCwa6NcwighEEc+VsBSLOi21vmsasXihtZWzqgzCZfHpi4Phv+x8EvoFvhQNAH17pd8e3YJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDCBD68B05; Tue, 26 May 2026 08:46:29 +0200 (CEST)
Date: Tue, 26 May 2026 08:46:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
	linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260526064629.GB25187@lst.de>
References: <cover.1779412152.git.wqu@suse.com> <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com> <20260523142344.GC183694@twin.jikos.cz> <20260525060030.GB3370@lst.de> <20260525101707.GV12792@suse.cz> <e5eafd64-2704-42de-ad7b-e4f170c451e4@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5eafd64-2704-42de-ad7b-e4f170c451e4@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 25, 2026 at 08:09:54PM +0930, Qu Wenruo wrote:
>> It's a lazy hack at best and fix on absolutely wrong layer. The library
>> should provide the support for the edge case. But we disagree on that.
>
> I strongly disagree.
>
> Firstly on the layer to fix, let me be clear, if something writes like 
> RAID1, reads like RAID1, repairs like RAID1, then it's RAID1.

*nod*

> With that mindset, changing chunk type at read/add time is exactly the 
> correct layer to fix.

It also is amazingly simple!

