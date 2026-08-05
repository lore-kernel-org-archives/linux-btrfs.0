Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5633A9DBA
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Aug 2026 04:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785903511; cv=none; b=ZIdBXNbu6+HSuSs6zNo7pClaRIaIUrFCDKpHzihn7EXw4U2RnqX2s0mzs+T6astLQA/Cs7hNOoMY21PhG+a9uXfGUvwjGvZtbtJuHcVnZe//S9kL+v2LQxVXsX9Ny/sShM98hkdXrMdbmMl1fTAeE5pYjDUXH5VmxfPrXjvYvZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785903511; c=relaxed/simple;
	bh=PmuPgkfzYYOPN8CreASDb1bK+vUBan1LjPc3vVYv56Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=czUycWBRHcjAQvqWAttU+62YrfC4yacCIL3w5KgVo72YgIQE1lhz98nRbkNSAaWXVRnbtVtMNJIuCOs3QBTgO8hl3yPB82taXZ58MgQW735ByvMJliup4bYQfqCr2swWQZy00LHrb5YSbpg1ZzMI+dtUzysSRRK+x+9fNtqBECs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Y7jj6qRz; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Y7jj6qRz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Pm
	uPgkfzYYOPN8CreASDb1bK+vUBan1LjPc3vVYv56Y=; b=Y7jj6qRz8+4p+mw74c
	sd+Y8FCx+kGK/ppdp+eP+VF5XJprOVjSCicKtn8qNDsQeczaGdzNT+w7D5xNQ1Mw
	bT58CelA9feIIQiIxtbu8FPD3+l4mf7yBLX5lYy7PfRehbzSe8CYRpNJsbjrWOt/
	GQT9XYjTnC/g70Bg4RhwnENho=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD31914uXJqc2T6NA--.33187S2;
	Wed, 05 Aug 2026 12:18:01 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Mark Harmstone <maharmstone@fb.com>
Subject: Re: [PATCH 1/3] btrfs: unlock inode and extent on pages alloc failure in uring read
Date: Wed,  5 Aug 2026 12:18:00 +0800
Message-Id: <20260805041800.2154526-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <49b72d7e-be1b-4bd1-a6b5-3261502ed1a0@gmx.com>
References: <20260805021135.1896609-1-yangxiuwei@kylinos.cn> <20260805021135.1896609-2-yangxiuwei@kylinos.cn> <49b72d7e-be1b-4bd1-a6b5-3261502ed1a0@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD31914uXJqc2T6NA--.33187S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUeZXoDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhrDVGpyuXp3qAAA3L

Hi Wenruo,

On 2026/8/5 12:49, Qu Wenruo wrote:
> The extra handling is only to unlock the inode and extent io tree.
>
> And neither the inode nor extent io tree is locked by the function
> itself, but btrfs_encoded_read().
>
> I do not believe this is the correct location to unlock inode/extent io
> tree.
>
> Move the unlock into the caller, as the caller is already doing such
> unlock after copy_to_user() failed.

Right, will move the unlock to the caller in v2.

Thanks,
Yang Xiuwei

