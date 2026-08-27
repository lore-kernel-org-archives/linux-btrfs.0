Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CE44C955F;
	Thu, 27 Aug 2026 19:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787859073; cv=none; b=GbCAukWpcnPlJy9jIp9ZsbccwIF5DwIC2rHZTGHl94c16VyyZ/D+JQkxgH/2GBvZJ6s2EjU5UHkDMtUOFXibWP7nBsLG/bW97w2CPRU1ChPzjdlmf99MJW9+UmunDYiaqKOwRoff1gG/o8WztPEe6zksCmmui6bIcLDPZk2ueLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787859073; c=relaxed/simple;
	bh=SL8Yc6Fzpw1DxmY2ixRVk2v++EqFT7jc8I0Rc85jAdw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LZUsR1mmban4pVTaoi4LYX1+ioaJbwTzL/mQ4w9fOHUnkkLmCQ9+IV87zrxYtFqUN9zhTup9ZVB/XMZrZ1SwEh9AW5CP0iUP6pqK+xHGkhoD2mT/yhw+8dzdYW2IdMfG9RZAAQixItKjq+WSCabtZq+xxWpWWfPCDqw+zShBcKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MqoiM2HO; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MqoiM2HO"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RJM83I1856212;
	Thu, 27 Aug 2026 12:31:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Zle69xpXWisL+DXG8l9G+/BegWqpbHiyU6gIe
	8bazyk=; b=MqoiM2HOepEvu0qH6bRwx4DCX00XUJy2iA02hlQb4nuINdRcQNk4O
	zioQGR62eYwh3vmZQgEmPU0zYSJtDdbrmupSDC37OZy2jXO00VCRDDF+jT25B+1v
	vzVr5LWQi4fsrkWqLgWlucbzQLpeokpt5nJdxsXAMKmDtDiP32W2DlBAB7szAsdS
	69eYSrZBlFGPToBixkyG0ZltvmiYJeFSqRMF9Zkz1lADgJnD1vLBGNaFsQ0/bym2
	/hCtWMb8R3vgE/Q1hxanJSgOjYGu7Joa5m586E6CDOAbxBngzM3f6sL5ahWY4crE
	j7hF1J4GdKwCbinP0If/0fNK7frhA8vww==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gak20ksv5-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 27 Aug 2026 12:31:05 -0700 (PDT)
Received: from devbig011.atn7.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.45; Thu, 27 Aug 2026 19:31:04 +0000
From: Chris Mason <clm@meta.com>
To: <clm@meta.com>, <mason@kernel.org>, <dsterba@suse.com>,
        <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: update Chris Mason's email address
Date: Thu, 27 Aug 2026 12:29:16 -0700
Message-ID: <20260827193032.786461-2-clm@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260827193032.786461-1-clm@meta.com>
References: <20260827193032.786461-1-clm@meta.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDE2NCBTYWx0ZWRfXw63T/+eldv4Z
 22NddqO1lxenrslZ3KO21dAf0F+3GcGakW/Cm51br1Xg9auWRr94wRZvhfbqsVtGS6H4Qiako7G
 NWbkixe/FWETLz1ypeFGbymtSgAMeRo=
X-Authority-Analysis: v=2.4 cv=D6x37PRj c=1 sm=1 tr=0 ts=6a909079 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=4h92JMTCafKA-fb_NiOh:22 a=XLsa2Zz1AAAA:8 a=UXIAUNObAAAA:8 a=VwQbUJbxAAAA:8
 a=VabnemYjAAAA:8 a=FOH2dFAWAAAA:8 a=iox4zFpeAAAA:8 a=hrHxsFlYva6rS5mxrB4A:9
 a=DMmOWUYxRQoLAZVlW063:22 a=a1s67YnXd6TbAZZNj1wK:22 a=gKebqoRLp9LExxC7YDUY:22
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: aMqne0WUEz9wH2FwzKNoKKyh_YWCbQXj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDE2NCBTYWx0ZWRfX4z4YRLiS2Vka
 HBuQEw1S+oCBrGLj8aS4uSXo66d1cczwmGRM1BWXGy/5+HjcJn8VLop8MASrea59cUp+dYOgl1R
 9Fz7g7ysWjL7iycMP6bsmA/nYlJI6ZhSmqope1t1JO2Oi3YdFONK4RtnH/aQ31zP/2vrdf+9Ida
 nqTqCkiaKdCh+dXAqXVM6xxY7magd+p8OktUMyf8ECtgoAhpyYiHnDZDczC565Md6DLVzYj9tQ4
 SFri2bU62d69Ba/SE5wynT1+Rz5dO/aJ1tdqbAPAgj6uQAzNuNLFI3jn5jfggQvMePq6pwU7q38
 Z8wxORaJDQnhsgTqKk0q9m0/4ByZAKWOIsYTw96Podow6uI50yyHxhM6z5HG6vjf9X5/mNvnCjZ
 GszCDcgO/I6ZSLOxg8qrSdeFwJQ0zEKt4RF9YcN1TzmMvNb87fxIg/q8cVkjJZuzS5a9R1Xqu37
 gAxMSvrGTS/2ZLIhMVg==
X-Proofpoint-ORIG-GUID: aMqne0WUEz9wH2FwzKNoKKyh_YWCbQXj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_08,2026-08-27_02,2025-10-01_01

David Sterba has been doing the Btrfs maintainership work for years, and
my email update to mason@kernel.org seems like a good time to make the
MAINTAINERS file a little more accurate.

Signed-off-by: Chris Mason <clm@meta.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55b3c2d7a78a..c79988447b68 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5671,8 +5671,8 @@ W:	http://bu3sch.de/btgpio.php
 F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
-M:	Chris Mason <clm@fb.com>
 M:	David Sterba <dsterba@suse.com>
+R:	Chris Mason <mason@kernel.org>
 L:	linux-btrfs@vger.kernel.org
 S:	Maintained
 W:	https://btrfs.readthedocs.io
-- 
2.53.0-Meta

