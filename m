Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.120.160.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794656100;
	b=ZqNn8uIOxg8VAwpF/hZV2UKyuRSNqgWezJT6qFU9MN5JnQfIQdi9PtzGkjLip8MreQO+
	 Dk6Ri+vaKRayseW8oyi+ofwLDfFcux/ieWG94rmzz0Tejwq50NZx0KTO58MqAHVgpNaLN
	 iHKKabnvsw/M7AnXpbDaWSKlD9N2GIArwOr72IGk+vmvefVGgUIW3HpB0IJjvlvxFK2CX
	 LihLQps2S2hUI8N1ElpnL1L5a0a2xR9q7NMezfxJDz+6lqkNIieyIUey20FM1bUKDmMOA
	 8iPjPpdeNB4vzPzyJrp4bYMen5h6shbQZ2M6rLKVIwO3mMcc0MHgZmd35j7UuEzqmOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794656100;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=BWbcsR5jTd9T4hQdC0uwofPH3ayAL6wloxEw5LrZ4cY=;
	b=UqyG/4Af/KKyccHUOdhn7+2+0pEDWThIVITyj73L+0T9iZwcFYcKlqRy4TG4yAWTGGYx
	 cpO9KHMzMEpSICQ+HHFOs8rVq25wzVwJcag488100geYw1js/XVJ0i/5Y4WpIEfy5otWZ
	 nGIFbkeikfV3594av1NYK0rp7jqivNhUyKx/UfRmbIUmorJ4JbcmNxIPimOdMPIrd1IQB
	 MxhfGowb1iqz47pC6r1CcGTVY4RpbeID2MCwn4d1RnjlcP84fypzkeXZjZHcvqdIlgK8O
	 unqjjb0PDtSNa0QQ914hXCzqfgf/YuXpx8R+jdcF+mLmuKwERWaObvw8okH39lG7l2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=lichtvoll.de;
	spf=pass smtp.mailfrom=lichtvoll.de;
	arc=none smtp.remote-ip=37.120.160.25
Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBF7606A323
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 11:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BBF7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 075AB291BB9;
	Sat, 14 Nov 2026 11:34:56 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: BTRFS <linux-btrfs@vger.kernel.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>
Subject:
 Re: SSD overheating during scrub in laptop (SOLVED: no overheating but
 firmware issue)
Date: Sat, 14 Nov 2026 12:34:56 +0100
Message-ID: <FE3VHcvvQgKIWKcueGk98A@lichtvoll.de>
In-Reply-To: <-s0v2GXuRt2gJpFQn2y9bw@lichtvoll.de>
References:
 <1938311.tdWV9SEqCh@lichtvoll.de> <-8JrlgE5SLizPVsfOSFaOg@lichtvoll.de>
 <-s0v2GXuRt2gJpFQn2y9bw@lichtvoll.de>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Martin Steigerwald - 14.11.26, 12:05:24 CET:
> With an BCacheFS filesystem with 180 GiB I have even seen rates of up to
> 5,5 GiB/s during scrub.

Make that 6.1 GiB/s.

-- 
Martin


