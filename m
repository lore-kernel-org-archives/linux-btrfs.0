Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864AF41B346
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2026 05:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061347; cv=none; b=TUZqOyq+b5KrG3ThnMQ8PtqOaLWd3pDXGl6zfilv7+mJKv7a+2iqWXu8xz/oBaWL8Cnjxg36X8JBwgckQPNyX21I0S4kEaAsUg6b7HFP750+fP6LroYgBHzhhZ5B+LfNjgCkzTprkC0wEzwfvTOsuKDyP/3z6nQlWNO9TAz/h5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061347; c=relaxed/simple;
	bh=7NdcwZcTFf2R8A8jcCh7Y3OLTsH+UxGzAWQbezvUj8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BQ5RihDsUW6onT8yCnOe4VYcDiJLDn12chx8H1JnDEp/De3O0JTNVHgeXCAIB3cAszDG4p53XQLcwLAM9IF3NuDSEk9G+8EVo4kG0fnEysz+rTxV4l1+l4QZcXAC92WUmqllTCJhYW00EO3EY0PkNBpdKMfTph5XGhsf1cC/M0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=UGTKApb6; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="UGTKApb6"
Received: from vbm-jinbaohong.. (unknown [10.17.211.178])
	by mail.synology.com (Postfix) with ESMTPA id 4dxVfK69NfzG5nXpR;
	Thu, 22 Jan 2026 13:55:37 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1769061338; bh=7NdcwZcTFf2R8A8jcCh7Y3OLTsH+UxGzAWQbezvUj8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGTKApb6Urb9fpLbR37RgYt3DqmJEfyAsdqv2enAJY+SoM0dl1xyG/qoHMlbkl6mn
	 +kSDriuDQoxhmM59ffKpbCiSq0HZitMHIUJqg+GiZ8qIpncvh2O4SsrJHq7gP2Y1jY
	 2Ver1p/shQljHU9Ob9e9kg8sY8ckpuMmBkSyLfng=
From: jinbaohong <jinbaohong@synology.com>
To: fdmanana@kernel.org
Cc: dsterba@suse.com,
	jinbaohong@synology.com,
	linux-btrfs@vger.kernel.org,
	robbieko@synology.com
Subject: Re: [PATCH] btrfs: fix transaction commit blocking during trim of unallocated space
Date: Thu, 22 Jan 2026 05:55:31 +0000
Message-Id: <20260122055531.461874-1-jinbaohong@synology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAL3q7H4NnuPgTfGs7+=Hf11k61V+1XJ_AXrjv5mhCDrvStVk5A@mail.gmail.com>
References: <CAL3q7H4NnuPgTfGs7+=Hf11k61V+1XJ_AXrjv5mhCDrvStVk5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
Content-Type: text/plain

Hi Filipe,

Thanks for the review. I'll address all your feedback in v2.

Thanks,
Jinbao

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
