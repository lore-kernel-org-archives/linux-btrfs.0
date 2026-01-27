Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9683C2F
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2026 05:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491548; cv=none; b=fi2Xp4ipNfGH9XYzmSFiaVz3xAQxoGX96MJ6z2TUB2XPpXipxjSB3RxyqYIKZsNy912xOELYV0p9fyN1M/seP7YKt5eOccsB8LayBHMDBjeHzPAn7bLGBPdIXTiI93j2OIseKhOIlZaMxQo8EbEtLtON0AW8kUPqznRq/BzfIB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491548; c=relaxed/simple;
	bh=OgnWZd28LaTv/wXHnk0Oi/Zw87DcFL8e/O3knNvzPG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUJXeYR7Szqg1kOzM+vxsDVgcgLZuMi3iRO0j7Y9kHUzEpU4SlZgY3pPic59Brw8G728W5kMbQQSph3I07mT6Sa9bjZwdtjWyfSZ3JZ+6Dxq526mS2j7ZAk2DNd3ruc/A1l2x6FdXZ5mN99TCe7SPs+6shsT4QZwhRB5OEKY3J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C507A227AAE; Tue, 27 Jan 2026 06:25:44 +0100 (CET)
Date: Tue, 27 Jan 2026 06:25:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: btrfs/124 assert failure / crash
Message-ID: <20260127052544.GC24364@lst.de>
References: <20260126045555.GB31641@lst.de> <8b0c1232-4e85-4942-8417-78e12982a090@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b0c1232-4e85-4942-8417-78e12982a090@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 03:49:13PM +1030, Qu Wenruo wrote:
>
>
> 在 2026/1/26 15:25, Christoph Hellwig 写道:
>> When running xfstets on btrfs with SCRATCH_DEV_POOL enabled, I the
>> warning below pretty much every time, and then the assert fail crashing
>> the kernel after it (also in the log below) about every second run.
>
> Mind to share the SCRATCH_DEV_POOL details? Especially the size of each 
> device.

export SCRATCH_DEV_POOL="/dev/vdc /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 /dev/nvme4n1 /dev/nvme5n1 /dev/nvme6n1"

NAME    ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE   RA WSAME

...

vdb             0   4096      0    4096    4096    1 none            256 8192    0B
vdc             0   4096      0    4096    4096    1 none            256 8192    0B
nvme0n1         0   4096      0    4096    4096    0 none           1023  128    0B
nvme4n1         0   4096      0    4096    4096    0 none           1023  128    0B
nvme3n1         0   4096      0    4096    4096    0 none           1023  128    0B
nvme6n1         0   4096      0    4096    4096    0 none           1023  128    0B
nvme2n1         0   4096      0    4096    4096    0 none           1023  128    0B
nvme5n1         0   4096      0    4096    4096    0 none           1023  128    0B
nvme1n1         0   4096      0    4096    4096    0 none           1023  128    0B

this does not seem to happen when all devices are the same size,
something I just ried after pasting this.

