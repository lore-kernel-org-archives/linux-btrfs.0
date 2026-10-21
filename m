Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=23.83.212.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615173;
	b=B8ShB3z4wpeCn5c+aVPOTWCOrw0mAmW7JnM/yRKnMSRFblc67NRg2Cx1l78EaXg+Z6zG
	 hydu5la0Mp+Wug8k/OYNWrgwM8kn1/5AYAB1M5pqYJaAwKNi2pRlSbqPfAhI5s/REPS6Q
	 f38qF6AzcXWxQFrEvo956p/3S06kKg6ZUU8dhOdE7wqoNTHHwiIh1INwKGcdHdoR5FRrA
	 5h6dHPanm4JI9tEZVXo7/hzG/1FPamv2s4pNVkramxHmDjvwQ1a+55A09SyN2Zs76AqiC
	 RsUr5U6icmGVXmMJCpbaGZU5JgvTria2e0V5uXIKAcs+hVhx5aPPhZ+nfYbq6uucrlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615173;
	h=DMARC-Filter:X-Sender-Id:Received:Received:X-Sender-Id:X-MC-Relay:
	 X-MailChannels-SenderId:X-MailChannels-Auth-Id:X-Interest-Harmony:
	 X-MC-Loop-Signature:X-MC-Ingress-Time:Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version:X-AuthUser;
	bh=aEA1y0nUNlQQF3FO3Cz7OrImSq+yCp/YDPaJ5WSLI2c=;
	b=4uxT7cKi7brpMF3tBMKgF+GlwHo3q124ASksV6pYmnyMcx8CI/6FlCd/FyV+CicT/ulT
	 w18yrc64yGJQLpcp7iSpWO32X5P1/Q3bqkJmi46CXy+0QbCG+Djbl5JTRXNXgCu11WqF8
	 7Qxq1D1k6F38jO+GEzIauEp6zg2aDPr8WroZRukaeNg8elnFdrDQNUGeDDbnDoH1UzOda
	 dX5cW7l2lwrykyc9Pf8Ynb8z3v3lw3HyqusccmYu5i9ivIoc7dMnK/bWmFjkkWNpYd/uZ
	 B9yPOeE8fCM2ufEC9WmPvyROy7nk7cRLKxBBqKYlR+tY8Pn3zaEPGVneBP0TO+1BHsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scientia.org;
	spf=pass smtp.mailfrom=scientia.org;
	arc=none smtp.remote-ip=23.83.212.45
Received: from crocodile.elm.relay.mailchannels.net (crocodile.elm.relay.mailchannels.net [23.83.212.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C7B606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 20:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0C7B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 65E48804FCF;
	Wed, 21 Oct 2026 20:39:26 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-96-3-96.trex-nlb.outbound.svc.cluster.local [100.96.3.96])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 6039A80626A;
	Wed, 21 Oct 2026 20:39:25 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Interest-Harmony: 5c10340e4cc3126e_1792615166263_1811648420
X-MC-Loop-Signature: 1792615166263:3018660457
X-MC-Ingress-Time: 1792615166263
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.3.96 (trex/8.0.2);
	Wed, 21 Oct 2026 20:39:26 +0000
Received: from ip-188-192-254-170.vkd88.pools.vodafone-ip.de ([188.192.254.170]:60152 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <calestyo@scientia.org>)
	id 1xJd5q-00000001UC2-2wJ0;
	Wed, 21 Oct 2026 20:39:23 +0000
Message-ID: <cb95f89af722c5f57e99d4424c8b31a5155fbdc0.camel@scientia.org>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 21 Oct 2026 22:39:22 +0200
In-Reply-To: <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
References: 
	<CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
	 <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
	 <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com>
	 <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-10+b1 
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

Hey Filipe.
AFAIU the bug "merely" caused the hole to be ignored and thus the
received data to be written (inefficiently) without it?

Or did it also include any true data corruption.

I guess there's no easy way to identify&"repair" affected files?


Thanks,
Chris.
