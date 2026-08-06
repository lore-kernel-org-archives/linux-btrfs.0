Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C44B3F3267;
	Thu,  6 Aug 2026 09:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008682; cv=none; b=fwR+TqkGMOts4r6RuS14DIwbdK9s3e2+6GudYN/jJhwIT455JajVD8g22S5UaKJed4u7L30aqWSQzmMzphSABwCvc0oWaAQIdLIexNOqyJR8bLWsaFuEUZJg118nZ8ldgaLdyw3C7Zn5Meom42Txc0dAKMfHclF4A09grO7IDQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008682; c=relaxed/simple;
	bh=kQ3vgPhrHSVIjbtp+JWS8fc4cTf3NwVsjqc40tYZEbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=un0ASCgm23ssDUfUESoORH6tv2qWHH1H5dHDywDeDWN644iVwVH9E7Sdkramcf0elDVnHTdXrdyDLBLzR79o+x8RvYQyWe/KhbyCI55MXhMnPHwKBB40B8LTbu7DlLzxvhc69pqosupjt6sTBtgStDoaqby2MC+jj2Ls48bCpI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Sl10AjKl; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Sl10AjKl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=kQ
	3vgPhrHSVIjbtp+JWS8fc4cTf3NwVsjqc40tYZEbA=; b=Sl10AjKlESMdXyCNWh
	7z/vTIIih3JWn13kv6c6bZ9+tudHjKm/UuG3qakX79xTzCE4NMYLeegMu+Ip4GQT
	S87K/QzdYuoBAmT1TLOl4mTLF6ARYmQDMMvo4KCldu9sIvT0SIq8Vg7fIi54QVKZ
	3+sBkGc/DRsDkGtjS/FyLvDrw=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3vwtHVHRqU1HrNg--.23150S2;
	Thu, 06 Aug 2026 17:30:48 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Qu Wenruo <wqu@suse.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Mark Harmstone <maharmstone@fb.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v2 5/7] btrfs: unlock inode and extent in caller when uring read extent fails
Date: Thu,  6 Aug 2026 17:30:47 +0800
Message-Id: <20260806093047.1491231-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2f43370d-0319-479d-998e-8cf09c84675f@suse.com>
References: <20260806085041.1410576-1-yangxiuwei@kylinos.cn> <20260806085041.1410576-6-yangxiuwei@kylinos.cn> <2f43370d-0319-479d-998e-8cf09c84675f@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3vwtHVHRqU1HrNg--.23150S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUO9N3UUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwQjeb2p0VEhOSAAA38

Hi Wenruo,

On 2026/8/6 18:40, Qu Wenruo wrote:
> Why go to that label? We have nothing to release, the old return -ENOMEM
> works completely fine now.

Right, I overlooked that and kept the v1 goto. Will use return -ENOMEM
in v3.

Thanks,
Yang Xiuwei

