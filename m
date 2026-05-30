Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925463546C2
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 23:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780182186; cv=none; b=BXlg5npY+1nz8lQRMrRQT6+TYhaoNp5o5bK59oykWHd738/0T7jtOkZWOpvzkj8krxhjsSESIblYyQlAvWA45weGgFYFJ2+lGjvO7fAUVBz/A51229RBnkXObgMCLRQhOBtrz1R+x3G8oiqHkI6L+JbnED3FJCEXK+BeXAhr1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780182186; c=relaxed/simple;
	bh=/z1GEMoaggoZeWMXx891eeZJvZW4qhmqPzwSJW6f5bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qoHF3Q6OEpdw+W48aCdFmN54rcdbRWA8jOA/DCCZZe/LpfJ70bbUy4FvBvb2f/+rdPnLtY060xsSMoJ1c/KoYpVBlQvxbhHWI5JcOTrjh9BesiJagAs6LoZTQOkUAsOMV3C5gX3wFmt2wdzMjuzLKs8hh2JiD5brLsfx+rBNUjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 388EB41308;
	Sat, 30 May 2026 22:55:28 +0000 (UTC)
Date: Sun, 31 May 2026 03:55:26 +0500
From: Roman Mamedov <rm@romanrm.net>
To: xerobrinhek <xerobrinhek@proton.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: multi-device pool corrupted after repeated
 removal/recreation of missing device
Message-ID: <20260531035526.17ac92c3@nvm>
In-Reply-To: <ISRv0Ku3zGY139-n3o62hjAyUorcln7sKNLrUViaahtGK-bidGOIjXvj6OeK6_od0CwGnW0RuTP1Un8PXSUv6owZVbEfIJkRuiS8NLwIBqU=@proton.me>
References: <JJ5S5tQDVkTmHxqx0ncj423p-TgogJGM8fSviYuGeF1i-xc7NtTdlmd1VO0aopC3SEVqYZF_Z6opVqrTz4eJ8sbDOiceQNzgwnjerSXJWhM=@proton.me>
	<ISRv0Ku3zGY139-n3o62hjAyUorcln7sKNLrUViaahtGK-bidGOIjXvj6OeK6_od0CwGnW0RuTP1Un8PXSUv6owZVbEfIJkRuiS8NLwIBqU=@proton.me>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 30 May 2026 20:25:42 +0000
xerobrinhek <xerobrinhek@proton.me> wrote:

> Hello btrfs developers,
> 
> I have a btrfs multi-device setup that got corrupted after a failed device
> removal. I need help recovering the filesystem structure (not just raw file
> extraction).
> 
> Setup:
> 
> - Two devices: nvme0n1p9 (17.53GB) and nvme0n1p8 (31,30GB) originally
> 
> - The filesystem uses subvolumes: @, @home, @var, @snapshots
> 
> - Compression: enabled (zstd)

What were the profiles used for data and metadata? Since they were both on the
same physical device, did you use "single"? And what for metadata, e.g. I
believe DUP wouldn't guarantee copies across different devices in this case.

> 1. I removed /dev/nvme0n1p8 (devid 2) from the pool without proper 'btrfs device remove'

How do you "remove" partition 8 of an NVMe drive, at the same time retaining
partition 9 of the same NVMe drive? Just by deleting the partition? Recreating
it with the same offset would have been enough to make btrfs see it again
(after a device-scan).

> 2. I tried to recreate the missing device multiple times, creating and removing btrfs on it

This bit sounds weird, what exactly do you mean by that? If mkfs.btrfs, then
that makes an entirely separate FS, ruining all data that was on there before,
and with a guarantee to do so, because it full-device TRIMs the partition.

> I understand the risk of data loss. My goal is to restore the filesystem
> structure (subvolumes, names, directory hierarchy), not just raw file
> extraction.

I'd suggest to abandon that goal, all of that doesn't seem comparably as
important as the actual data (that you can try to btrfs-recover or just restore
from backups).

-- 
With respect,
Roman
