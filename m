Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80392410D13;
	Tue,  1 Sep 2026 02:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788228589; cv=none; b=j161usEzfK2rQsS1OfAccpYj/eXzD5XVvpK2Q4qVxbSNgLPPOiIBqfU4eki0TMDzAoA3/jHX6vuskccepyIC4E4y+Efo39UMLg1cMy+9Y8JbVUiKNTIs52L0fxxQ1VVYphfvczl9dUFjv4O+8RPm8QGR+eiydTY0OHtEB9VxCoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788228589; c=relaxed/simple;
	bh=NfdJgkRpo+EMbzEJo/sJjUqIvklsv0rXf2ILqCiHY9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b53KWCkbpjBT58e2c0MV0HCyPpYt8GdvMhpcErW9i4YO7/+D3VbvU1VpruYBgyTfae3RdJrm1FjVtMzGEI0SzCt/1y0/BFmeDV9uycve7PjcpDudPrJdpSlcn9cHZXowKuFNSkzuAwxs3fmQ8W0HCdYGke/+2I2+6SSNwU+3cSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nRuoBsqc; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nRuoBsqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Nf
	dJgkRpo+EMbzEJo/sJjUqIvklsv0rXf2ILqCiHY9E=; b=nRuoBsqcajZIoGlO4b
	uH10pdGgI2uew/qAoNHPU9gmmslf76bxbixinyPy+KcrYWdLc0l6lG9Hu2wWuvx1
	YTut3l75YzHbk9/+Qri43Py47vTUW2qudhrsHn1GFjj5DtYgb2UY9adkZLBSjerN
	lJWMOhE02xfgZYOSxtyr8dnJY=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgBXM4_RM5ZqnWxgNA--.22190S2;
	Tue, 01 Sep 2026 10:09:21 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: clm@fb.com,
	dsterba@suse.com
Cc: quwenruo.btrfs@gmx.com,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/5] btrfs: fix io_uring encoded IO cleanup
Date: Tue,  1 Sep 2026 10:09:21 +0800
Message-Id: <20260901020921.3261749-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
References: <20260819025436.1949152-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgBXM4_RM5ZqnWxgNA--.22190S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4REksyUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRFB0WqWM9Fo8AAA3G

Hi,

On Wed, Aug 19, 2026, Yang Xiuwei wrote:
> Fixes for the io_uring ENCODED_READ / ENCODED_WRITE cleanup paths.

Gentle ping on this v3 series.

Thanks,
Yang Xiuwei

