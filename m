Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE3023BD06;
	Tue,  7 Jul 2026 05:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402586; cv=none; b=T12iy1lOd5xU9aheirb1zuIXtley6pXKdlrkJpmjyAgPn6axXVcSMPBBsmzbFQSepWZWP0RRiwFDUVGWHBFvAr69bLcla4ffGKEdeA85ehHxlaGpZ3j4/0eDyzWXvyrcGhq2dJJSuiehjKxv8vm4tT/WhFKlNZG89uJvN43/DYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402586; c=relaxed/simple;
	bh=B7ex+mqxy+WreRfbLz+mcmZbeXQc36YOrbFnel5Jhew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g1/UI8YBoc/IYjETDXDjTv+HlMKMkuSBgnuPOYu7K//buZMCaObzxN3s1cRQbzj8kazRon5eDHx9c/G98kZk7WRWyxJT2D9oyadSN6KhVUGPcGhjwVDRJsYyKBWLwV58sp5qh1gaonmmPcs/n89n1QBssRbiwJm89uJUB9/Yiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=mtKIzl63; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="mtKIzl63"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783402534;
	bh=B7ex+mqxy+WreRfbLz+mcmZbeXQc36YOrbFnel5Jhew=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=mtKIzl63SuZAERAEdSxDgd28g1sCwSfCWXpsgSrSNfe03o/0nbN1Cdqq5EUSgqA8f
	 0gbr4FOItUJBcdhxy7z8IaBjy3AMglp79QM3VUjQD+tnFkbyqo1eNWfIDBw3apBQmK
	 GndJWe/17RUGn+RZelQ6NtcriNH6rPGIZQqaSvlE=
X-QQ-mid: esmtpgz13t1783402518ta8f25a34
X-QQ-Originating-IP: A4iiDkVWwpCV6/clTt9oqHPYohbeAIyDFuJfcsBA5Ts=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 07 Jul 2026 13:35:16 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9330286288706608579
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Boris Burkov <boris@bur.io>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] btrfs: remove verity Merkle folio from page cache on error
Date: Tue,  7 Jul 2026 13:35:16 +0800
Message-Id: <20260707053516.568423-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260706053907.544337-1-chenyichong@uniontech.com>
References: <20260706053907.544337-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MbBTNOOgGymjA6cJIoMYPW1d6dROeE6oP0eGsxONiPRq1HSYie2nzypw
	lpKZ5WGTBrgPk/iolgGjGomXp+YuoTOBoYCa77aSOfL16EKMyLXvaEmwuBEpXBjatVqrhvO
	OL06sQLiEN7BbbywdEobunliGdV0Xk9L2ANBGfL04GfUeIQqc/dL6md85TNn2vFSKDrx+PQ
	4+hHZo6I8Troe+vxuHD8+xSDwNdaarZOqMuaVc7bn94YJ6+kGYnc6cjSHnAt8AwsiFAF8i5
	4R4txW8gpBDCc5cZIRWZPGOTHYSjX3bfnLgTCt4bLLeu5nk7F4NYR8ih0+G3kaJbJSFK5z+
	aMgFPkNgLtelAFKwZW2DnSNOrdtOFnXml6hq8StECpFdG8rLbf1u36bDiPhSlNUaBiOH6GK
	3pDoYUNi7pQytWxeG+PXNfQKA6tRIhvrS1BqDQp/0byoK1IXJOA0zgT4AiGkhkStPiWihxw
	7KgGCGa/1nNiiBSK6hKE66+KUB/HcZU50pVVTFK0gqxdCsY15sI0wWonGKDeVnUeaVfqCil
	4KiMStgeJeAk5gjvJTK2iEsRBg0jp5hWfd4xeS/RyHr9ao8kAFQ8+wUX69SFsRowsW/6jjD
	V6nzzCEbB0FN2OOU48wR0VvRbdSg6llgL3HsoN968TaZXJCtNswpg5LZzGqdjshBLaWMzpg
	gbLBQezTgDj6/WrcAvTBUf8tiDB5LvIcKq1XoI+y2mqBohBZbb/3trcTL8MEt8S4OU4eav8
	TOTgKGtrUgjCJG6ZOFXw4PkCkxzta6ds4+KWK0t5E1tYL5AYuafl23Xb6H5KvFGwie36V/b
	smBDGcldgZsqTBNHgUOE67fF3MklkYc8cYUlXNOJnJpFrkBnZoyB4SqDDI7u1q1raXoYbEe
	m5fIHWh8NOPC44RGWKfB447UIHoqtYuuIA8jNSpIWoMkXb9Mz266HMXAWOSKNcOytfudQh5
	ygleH3lZo19vyfZU4PDyqEs4pZzjLJUdUqPzQPY/v2CRaE8NeJoCAwDG0eErGvio/PIiGf5
	2St4fD3g==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Hi,

Please ignore this version.

I noticed that this version depends on filemap_remove_folio(). My local
debug tree had this symbol exported, so the patch built there, but exporting
that helper does not look like the right approach for this fix.

I will rework the fix to avoid inserting the folio into the page cache
before the Merkle tree read succeeds, and send a v2.

Sorry for the noise.

Thanks,
Yichong
