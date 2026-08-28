Received: from out28-80.mail.aliyun.com (out28-80.mail.aliyun.com [115.124.28.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED70A1C5499
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2026 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787925457; cv=none; b=Fqk08ul/5iIS1qztYBEszxaez50dmOLgKZZ9Rzn8F8HjAyJops+KijWy41vHEvQkC05WXW+wH2bVG/h5pGImmNiPKdo/E1SiqRGzMboBiz/EIDKQ4ZhshL8OjDJn/ajgbRfbBHXopeRSRxcXzEdOgqF4DBMH9Or4RhvLrbedXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787925457; c=relaxed/simple;
	bh=Fi7UcHiXK8jBnqKG7Vc6rSOXhr47xNrvyOL8RPZ+iu4=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=GhLBWAoNLxENpKUw/An2RE9R78r1e3HH2ecZgu9LUQ7mcp5HEDiJhwYBHG38+cyGka4sQHj7Nhc7Pnnh1EgO42pnIRP8KxG6XhqTcOm0EP4tC3GBMh5kFtVVcYY1BF0pWq9Y8neY1apNx/UbgxBbmI2lT5zHR6OJ8bxJaiIP23s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1311733|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.077658-0.00221838-0.920124;FP=10044159892226403549|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032062159;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.j-fphcl_1787923589;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.j-fphcl_1787923589 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 21:26:30 +0800
Date: Fri, 28 Aug 2026 21:26:31 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] btrfs: use IOMAP_DIO_BOUNCE flag for direct reads
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
References: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
Message-Id: <20260828212630.5D50.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.03 [en]

Hi,

> Similar to direct writes, if the inode requires data checksum, we should
> use a stable buffer for IO, or even for direct reads an unstable buffer
> (e.g. the buffer is being modified during the direct read) can lead to
> checksum mismatch and even cause read failure.
> 
> To address the potential problems of unstable dio read buffers, use
> IOMAP_DIO_BOUNCE for dio reads if the inode requires data checksum.
> 
> This will bring a small performance drop, around 7% for my benchmark,
> which is definitely observable on modern NVME SSDs, but the overhead is
> still much smaller compared to data checksum:
> 
>  Fio command line:
> 
>  # fio --name=randread --filename $mnt/foobar --ioengine=libaio --size=4G \
>     --rw=randread --bs=64k --iodepth=64 --runtime=60 --time_based --direct=1
> 
>  The VM setup:
> 
>  10 vCPUs (host-passthrough), 8G RAM, target storage has cache=none
>  option, is backed by a cheap DRAM-less 1T mainstream PCIe4 SSD.
> 
>                                  | Bandwidth (MiB/s) |   Diff
>  --------------------------------+-------------------+-----------
>  Nodatasum, zero-copy (Baseline) | 988               |     0
>  Datasum, zero-copy (unpatched)  | 853               | -13.7%
>  Datasum, bounce (patched)       | 794               | -19.6%
> 
> The difference between data csum bounce and zero-copy is only 7%, which
> is much more acceptable than falling back to buffered IO.

for direct write, there is some process of 'falling back to buffered IO' in
btrfs_direct_write().

for direct read, there is no process of 'falling back to buffered IO' ?
Or I missed something?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/08/28


