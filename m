Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D4719F119
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2024 02:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=174.142.148.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798535; cv=none; b=UfGzd2H6Dcr40Y0G1P5rRR4STkRHC/arNmiYA24z/5aiRTPsrWLQqzY7wuWyJGshhhomLMdWyNCJtxax2jWofW34wva7CWfN2jOMdyT9Kvyy+N3Zc5uG8IQ+nKaK1bhmw8IxqrUAf0KHvhkKUJqn6kSfk8i3WMGm8ms8qjsdTGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798535; c=relaxed/simple;
	bh=tBoHU33q/hm2627qob5zROkByzdgBjcBjbjcjKP3N5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ro+s6O2BwvMoOm36m9xbPJgeJbM8Nqzwrb1LX8K7OJvMLq0do4YV8RQrjSTtHvvXSCm//yFtb/TFXHf/pIDZBfppmoeswk/JLEUX1mThn6YYNOLlwi8NoE7myx8pizan71GO4CxL8br03y3n01hwYMg0w+9lj1bY1Li+Rczrlss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org; spf=pass smtp.mailfrom=drax.hungrycats.org; arc=none smtp.client-ip=174.142.148.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=umail.furryterror.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=drax.hungrycats.org
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
	id 30BED1128BF6; Mon,  9 Dec 2024 21:42:13 -0500 (EST)
Date: Mon, 9 Dec 2024 21:42:13 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Scoopta <mlist@scoopta.email>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Safety of raid1 vs raid10
Message-ID: <Z1eqhWVodaL8rnzu@hungrycats.org>
References: <a7f1781b-6ae8-4e71-ba00-6c1c11c4901d@scoopta.email>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7f1781b-6ae8-4e71-ba00-6c1c11c4901d@scoopta.email>

On Mon, Dec 09, 2024 at 06:26:24PM -0800, Scoopta wrote:
> I've read online that btrfs raid10 is theoretically safer than raid1 because
> raid10 groups drives together into mirrored pairs making the filesystem more
> likely to successfully survive a multi-drive failure event. I can't find any
> documentation that says this to be the case. Is it true that btrfs pairs
> drives together for raid10 but not raid1, if this is the case what's the
> reasoning for it?

It is _possible_ for raid10 and raid1 to be arranged such that multiple drive
losses are possible.  e.g. if all odd numbered devices are paired with all
even numbered devices, then any odd numbered device can be lost and the
filesystem still survives.

This is not _guaranteed_, it is only _possible_.

In a filesystem with an odd number of drives, or with drives of varying
sizes, the block groups will only guarantee that one drive loss can be
tolerated in each block group, in order to have the flexibility needed
to fill all available space.  In such cases it is common that block
groups are arranged in such a way that loss of any two drives will break
the filesystem.
