Received: from crocodile.elm.relay.mailchannels.net (crocodile.elm.relay.mailchannels.net [23.83.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913F11F4168
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774400401; cv=pass; b=pYGm4JTQe8PI8V4NNasXRvR7L86jEayKVDXALGuQO7jrdRtkp9MC9d29PZ1zL+r4QUmgajZx3pfEAfgP/LIuqoSaLRFteODMbj0MsFf8mV9G4SHX9ugqh3FvD9JrJMCWz0PkBjW8MdixO4Rp76ZGWsq5g164YocV4YWISTE+LVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774400401; c=relaxed/simple;
	bh=vT7okLOfmZU7M47o2dVs/G+8ujy9/wqzCYF2cs5sp4o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SSw7VYcW9ql0VF5JLKyQmvXxJ3rmrfswMd+L3nXNGb6qRVOVxyc3KO6bdRUOEPkYXjS526sfiPwBuSbQUVD1Yg4OZQj1wN5l6PpuRwImtWvYQx+PG918bXLEcmscckt3jyUWemeP1ln1CmnB4PImL2f8i8srOBBnBfDOmHFX+tI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1456E18141B;
	Wed, 25 Mar 2026 00:49:16 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-114-133-131.trex-nlb.outbound.svc.cluster.local [100.114.133.131])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id EB31F1832D4;
	Wed, 25 Mar 2026 00:49:14 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1774399755;
	b=xbaoFENNakzXWzatUZEWUmuMjNFmDGkOhTN63z7YG9RklQhqK/a0BnY5OHcunPogPFpZq8
	ZS8wangja6+EAUz4Vnu2213MsHsJKAxmgycVN9FyOtkIMZrZEFisahPXT5Y5z+M/J2dND2
	Dr5vnUpdVTgAK3aYfiAVGdvhHDdgYsQcxbNViAeL6bA/u5/r5IrX0U7Lhm10zDv8uhbRPJ
	7SxWlW2o+3gEpzJ36pbY31ZAHc4Vhzn4FvD7Rim3vq1PjY0ffJNBCm5s8ZI0yEL48IMu/q
	4ZYDfEtBVufbsclH1mSn2F7UPYe+iPaafSGLe/YXP4TQa9U96i9pMUDaPQwFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1774399755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vT7okLOfmZU7M47o2dVs/G+8ujy9/wqzCYF2cs5sp4o=;
	b=r8n6HMFB+UsHK41MP/uT5SO0AxFVL8AeuSyfgcnDQCRHG7Q5Q1P36HHEdcszzOM0WlZXuW
	vGjR/vVYZCJBlhZGbyVy44xSIq6bsWPUlk8eU/xSphazG+iMjfriuIeQQg9CwLUwYIyeTw
	x6Va9N/J6RPcW6vwzABKkz2ZIYAIqKX96JHsxleX0Khi9Sqhi+Kr9356oEsU7yYL4wPe33
	TU+Rrd4Gbrqvc19pqT42wHaE7aF33Y4Nyl8vo1stgBcg5ONPutoZgPL2dQeNzGZUVnBR6K
	cDyUe4Wfkgx/f9qKoGaSKabRoc2ZlNOxftoDi/bq6cHJO4CUzsEgrbD4SsKEQA==
ARC-Authentication-Results: i=1;
	rspamd-7f98bb5847-czlm4;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Juvenile-Shrill: 6adf50f0352f0e64_1774399755857_1636888858
X-MC-Loop-Signature: 1774399755857:4118083415
X-MC-Ingress-Time: 1774399755857
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.114.133.131 (trex/7.1.5);
	Wed, 25 Mar 2026 00:49:15 +0000
Received: from p5b071a6f.dip0.t-ipconnect.de ([91.7.26.111]:62318 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <calestyo@scientia.org>)
	id 1w5CQr-0000000GSqG-3hXC;
	Wed, 25 Mar 2026 00:49:13 +0000
Message-ID: <f7b7f88c6f1b94b6f09f7f54bdaa3c0ee54f60ed.camel@scientia.org>
Subject: Re: Btrfs progs release 6.19
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 25 Mar 2026 01:49:12 +0100
In-Reply-To: <20260317163424.GY5735@twin.jikos.cz>
References: <20260213185647.21966-1-dsterba@suse.com>
	 <ced007c60ff226a2988f388c9389c240c8057843.camel@scientia.org>
	 <20260317163424.GY5735@twin.jikos.cz>
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

On Tue, 2026-03-17 at 17:34 +0100, David Sterba wrote:
> > How about migrating an existing fs to use the block-group-tree
> > (with
> > btrfstune --convert-to-block-group-tree)... has that also been well
> > tested and is considered safe to be used on filesystems with
> > precious
> > data?
>=20
> The in-place conversions are a bit more tricky as they start from an
> existing filesystem and there's a possibility of finding some corner
> case. Last time this was in 6.15.

I see. Thanks for the information.


> It should be doable to test the conversion using device mapper
> snapshot
> devices on an existing valuable filesystem without destroying it.

But that would only tell me if the bug actually happens (and is
noticed) during conversion... not if something is simply stored in a
wrong way which I may not notice until much later (when it might
already be too late).

Thanks anyway :-)
Chris.
