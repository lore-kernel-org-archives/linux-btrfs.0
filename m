Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6842F31A7F6
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 02:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777257693; cv=pass; b=XWRFVQir6N4a/CNGl47oJqtmCavavfGCOFTi+4hakAzP7UtfsQfJ4BTbUHG8P8DhU/WAMLmzrlt6kMdm5AweDx8Ja1jTiSF0knqLGpklU14Sm76KEL390cYYJQUCwyzbZKMdwqRvgdQt+hUKXcEOHH8ngpuFE6LkpD/Na5soEOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777257693; c=relaxed/simple;
	bh=a7NzCdY+vZGeVtBp17WgL6QM8fVhYR2VM7jgwLNLy6o=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LZb1dtK5bxGDXuW+0o0JxNSQenim1G0IQudIhkM9hVPeSvlxpVOfpQ2RUh1lg1FBEaIm7U9x4xcup3Yx4DjwbZZ5QQpOCVE1FQn1CR4u9TH0UAadWaP29JyVvpaXr5S2xAqIIz5y9WhWnei6HUYablYBsL2VkFxOr2y6V81H2RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 25B9861714;
	Mon, 27 Apr 2026 02:24:07 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-4.trex.outbound.svc.cluster.local [100.96.22.203])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 230F261232;
	Mon, 27 Apr 2026 02:24:06 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1777256646;
	b=GMGps3plryWsAH8RLAkjcO1KQ4jwqJKV114LGBfCXYBzTpqVxkgMJOOp8SmKnM249xG3f0
	NuwlE02YfeveWTzIs4sCU9Y+YeFD2GfAL3EDcrVZwfZw+5hupjAaOfzn75gdDdPIJF8St+
	FFRV2L1Qn4PWlZXzmXvZDIbDuxx5LOCuhRC49voTu42tdETBxQm91IRm/sxOqKFARN4aXC
	Lv9Y3brMjYbcPzqkFFdwdEEzXHJ0YVeWmoXMXvldJAY7WG2Eh3tU/+UahAL2O9xnZlcLex
	5Ukgr0U46+VvIisC89uCopxyVDuj/JGpq4FIDbE4ZUGv8vmuexVCB8xHoppxtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1777256646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a7NzCdY+vZGeVtBp17WgL6QM8fVhYR2VM7jgwLNLy6o=;
	b=8d3Njb9GyolR5FLuitwIsKxsdEj5+7WMN+GjTGleUJNpSPCiaq0/qbXlwAc1rCq2763pRN
	r/FoGLhQXS9yYkb53ao8BGIn1Dt3F3UgkGez0OS3pbNLsiSRQ7Q52yLIn+XLJAUzfSgW2y
	MNdbzJ9CeOY3q9k2E/RvgkNiYiNGQWv5Am8RbyPecUZ8sGGSMHll8clcb1GFB8huqnrEMF
	R6veQYGtqeQU/nh7RBpl7bwTYoIYP7CDJ72YbXOomRDFdJBU7lJ+JmwFEPONoYL8zsYiyZ
	J9THDC5khmuD3i/6EPJflogFJqpTBMvqyufCoW9si2KZK0PPSOePpLTzpB+C3w==
ARC-Authentication-Results: i=1;
	rspamd-b9d4fc544-8wftt;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Cold-Trade: 0c40e8a51b8ba99f_1777256646990_3374573765
X-MC-Loop-Signature: 1777256646990:2922901508
X-MC-Ingress-Time: 1777256646990
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.22.203 (trex/7.1.5);
	Mon, 27 Apr 2026 02:24:06 +0000
Received: from [212.104.214.84] (port=58612 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <calestyo@scientia.org>)
	id 1wHBdk-0000000AHPu-17jx;
	Mon, 27 Apr 2026 02:24:04 +0000
Message-ID: <27cc875b06bb6a3e42e7d0b11e1dcfdfafaee28c.camel@scientia.org>
Subject: Re: corruption after block-group-tree conversion, how to recover?
 (data is readable)
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Qu Wenruo <wqu@suse.com>, Thomas Debesse <dev@illwieckz.net>, 
	linux-btrfs@vger.kernel.org
Date: Mon, 27 Apr 2026 04:24:03 +0200
In-Reply-To: <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
References: 
	<CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
	 <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

On Mon, 2026-04-27 at 07:48 +0930, Qu Wenruo wrote:
>=20
> Unfortunately the btrfs-progs is too old, and possibility the root
> cause.
> There are some fixes in progs v6.15, thus it's strongly recommended
> to=20
> use progs newer than v6.15.

Is there a way to verify whether his issue was actually caused by
what's fixed in 6.15?

I mean now that BGT is the default on fs creation, more people will
probably want to convert their existing fs to it... but if that would
be still unstable then there might be quite some breakage.


Cheers,
Chris.
