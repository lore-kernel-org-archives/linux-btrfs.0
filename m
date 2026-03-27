Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935C53B47C7
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606979; cv=none; b=eB7SFHb2kBzHVF0JnOeRJgzLs5tVW9VqmjQx4UyPB6KWMQ/dkO35PA7TLZ9V4mQ8SjZMtZs7Wg6p0lgqwKfRoNph1JoCi/lFfyvwnWbcSVQ0X1wUbHnmeq1qrwjSLhgeCzE3oqqTlSYQ8Zx0MGsShVM25XUR5/yFLeZXjr/bnzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606979; c=relaxed/simple;
	bh=T0WlomudA+y+xzNfpvRJUxIP1NFN3F+PENvpnjoQXjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aeyL3mCySDtlq/O4D6z4McJvINKNzYl4N9uNMvBqguFX0n9I1J/IJByW/RPrbbEl/wgYZEn2bqAbnyFvBLLR1V/2P+uKA5e3WunVn6iKOyHq+5xhWz6yCxyKD4xfVmoaZ/R/e3DS9lJd8Gr4BWR6eHu+C1GOhAcH0yiibTLsL1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 28E5A68CFE; Fri, 27 Mar 2026 11:22:54 +0100 (CET)
Date: Fri, 27 Mar 2026 11:22:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Boris Burkov <boris@bur.io>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, sbehrens@giantdisaster.de
Subject: Re: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <20260327102253.GA18582@lst.de>
References: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io> <20260316162020.GA21157@lst.de> <20260316162951.GA1074179@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316162951.GA1074179@zen.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)

The work week is almost over, and I'm still in the explore and
experimentation phase.  So please go ahead and log extra error,
although traditionally only BLK_STS_IOERR, BLK_STS_PROTECTION and
BLK_STS_MEDIUM are real I/O ero I/O error.  The rest is unexpected
here, and maybe just logging a message about that would make sense
here.

