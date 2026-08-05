Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558CD382F28
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 04:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785903552; cv=none; b=NB6CnhUspNZETgs4sY5OoCVtKoIrvnwUDEjYID+vn2oSd0N/OA66YQyqNehld+dT4POW20fRVoVx5sxPEFFoXHRndfuH4p18B8D83/R1AwFnRxRdqPitPEnEWtBA/Xty3co82gb+QcYK8xBUiUjuuYo2TKVgMYd07OGPjMbHWeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785903552; c=relaxed/simple;
	bh=+E3k6OG8qKM/sCLy8TjKU3Y5A5/qprIOE6LSubyLG0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fIlEoBHomBMejGqWNpy2Y7MEP1IILriuhmoD8+cjswWumZK7W/pvAbHx4fufB8v7wKZdECHW9kgbRRXyvpOx0jie3ckSo1S6NvceZmwrvYFxAR2Ulr+2ZQq8Xk/qYFlBX/10g5OSS9PUjICp+c13deZDEiUUQd2G5zgxCQs9+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZGsJ7wwY; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZGsJ7wwY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=+E
	3k6OG8qKM/sCLy8TjKU3Y5A5/qprIOE6LSubyLG0A=; b=ZGsJ7wwYKispEZx+1r
	AM8xQFHxAPCcQAkDgqokb1xoZQpgH+czfFYXNWEkgk6H7YhOkk2gYmwr0czZT0iG
	kUVY7/zojCqCIUc6lIfN4AKD2D/gYYL0dizJaJ4gfGjc5VGAGVE2MREXD6lt71E2
	Sv3n3KYVNJUrFw6vOG0BGWaVU=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wCHTZObuXJq+s4GNg--.49379S2;
	Wed, 05 Aug 2026 12:18:36 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Mark Harmstone <maharmstone@fb.com>,
	Yue Sun <samsun1006219@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
Date: Wed,  5 Aug 2026 12:18:35 +0800
Message-Id: <20260805041835.2155565-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <16f7f1b7-4692-465f-9e79-a4d1cc447f69@gmx.com>
References: <20260805021135.1896609-1-yangxiuwei@kylinos.cn> <20260805021135.1896609-3-yangxiuwei@kylinos.cn> <16f7f1b7-4692-465f-9e79-a4d1cc447f69@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHTZObuXJq+s4GNg--.49379S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUjHUqUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhzMXWpyuZx6ygAA3C

Hi Wenruo,

On 2026/8/5 12:51, Qu Wenruo wrote:
> Sashiko is reporting errors on pre-existing problems for this and the
> next patch:
>
> https://sashiko.dev/#/patchset/20260805021135.1896609-1-yangxiuwei%40kylinos.cn
>
> I believe they are worth addressing since you're touching the error
> handling.

Will check those and include the relevant fixes in v2.

Thanks,
Yang Xiuwei

