Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D5248896
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 18:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775154757; cv=none; b=okG+qdiiZzZs9CRQZmFFwyxvTjlpgtiDfPUU0oFeR6cJhG3Gnh4/+n910eHfc8o10ICQKEoCQ5ejFTJf/gL9k8WwMxaBqVWWjjEQNtoYcnZSUJ1vHQdaIeE+dEUFReLz7jg/Ax3Ax1lik0lLBF6Nhw7o1hh511jiXhr2P8sShCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775154757; c=relaxed/simple;
	bh=zCC/fWIT1SiSrIpReXuh5LvUZyGFhrdlNhvX9pTvwAI=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eAOzQDfArteIBXzgv2TW4eWvQsLBBoW9N2TN19f16vpqeFRTNhUWqBv3Gg+EBMioP2VtXSJyBgr0IMrewnQYhjawyZLsP5aQKqfd/p2jvu5H+YyYoJJYeGxyvg4IbsTSo/3nPkuWvfxFmFVVVSzPhDHOPIMWu+IV03uW6rqRvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=georgianit.com; spf=pass smtp.mailfrom=georgianit.com; dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b=QgjwZOph; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=trZvqILA; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=georgianit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=georgianit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="QgjwZOph";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="trZvqILA"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 64FAC14001AD;
	Thu,  2 Apr 2026 14:32:34 -0400 (EDT)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-03.internal (MEProxy); Thu, 02 Apr 2026 14:32:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
	 h=cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1775154754;
	 x=1775241154; bh=JylEVmLKZuzGGmY42brryHee5dllBdFMg99snzQRBAA=; b=
	QgjwZOphXWo+RgYZlf6IeeoBjgnPSiSuEA53zLErmZvTEN7ST6dhoAfDVCP3z9aF
	Brtt7mQ8z3CF/9GKM7KenlDwmmWters3K0mwClUe8gDHHl9euItp33dZc2Blb1AJ
	iBgC7BtcOddY8feArWRRBjR3ShV00wXDj+8lIIT71QebsmAMTiSOCIOuFP18GxPv
	ihHmYhkAGILigd6/8H1ykIdEPpUqoZMlrjsvATMxPMNOVretNaVfTspGWE/UQjgA
	ti8I8o/g4f6Nf5dCTrTQZkPUlZ/By7xjbr03s+ddCVUadaIhGP5skgQc/T0ESDHd
	ADEcZzI3T+YnAj01pAATug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1775154754; x=1775241154; bh=J
	ylEVmLKZuzGGmY42brryHee5dllBdFMg99snzQRBAA=; b=trZvqILApbYESgx/0
	4ocXhwEwDRBUB5XhOpWEa9LnEvFNjh+MADkiwe8qmuVWHlHby0u/8pWmtZtih4G7
	Razx14S7ZkrgQ3e/4yYOshB/l0+jKqg+z5+gFYcFv+RG+LkC21MViRf/dqmJUITI
	Ai0hIOi+yO5/+mAXR8jGxnSjsFvna7dlAEI9IHHhxRewX1VeyqevUzVQqmR7wUIY
	Q3TSaFqV8Pp8R4TkuJrflYhvwPOgLQ8xt7lBF69wPelkTDjvQCZA72/GUIpRzYbf
	1GK0E5DwEs+waRSoUWEVmL6AK11dr5EJDqpe6jwT3xgBl2Sy0wVwQ5BwnNAOk892
	XxxcQ==
X-ME-Sender: <xms:QrbOaTNEERoFKIQt8w35eExgIidz0j-Jzh5twAmVhyfqnryuM186cA>
    <xme:QrbOaYyvMpEnABzltLGjLcHsoqvIFrkM-8zgTuS1qjhZ5PjD0dZEXOjpSycZDhhng
    pklV7AWocpeOTFeiPaJ8OLETAahY9uOX2dQNVDHjU1jDoC-1zQu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeijeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvffkjghfufgtgfesthejredtredttdenucfhrhhomheprhgvmhhisehgvgho
    rhhgihgrnhhithdrtghomhenucggtffrrghtthgvrhhnpefggedthfdtteetueeuffevle
    fhgeeikeefveeiiedtieehhfettdekleefgffgjeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehrvghmihesghgvohhrghhirghnihhtrdgtoh
    hmpdhnsggprhgtphhtthhopeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegr
    mhhithesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopeifqhhusehsuhhsvgdrtg
    homhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:QrbOabLkj1nb_hACC5SVUflZsyVzvL4H0PSiXNZRO9rCwjxtVn7eoA>
    <xmx:QrbOaW7PnoK89C2yCJMNgTIwrszt7SiITHmz13cNn9lEP0eGwQgV_w>
    <xmx:QrbOaWyhxFMH3hhw532MLwxT1VEWP5_0ke3kf4r2MHGgrPGDgvXP1g>
    <xmx:QrbOaSZE4dV5g7BCAh6S1xs6BBozWeJUGNdse4sv6j-J4cndl9ZwpA>
    <xmx:QrbOaetSismyDoeU-fF1-ZfXMVpeKaKwaB5sC9LPUa-E2ftfc4LAYHmi>
Feedback-ID: i10c840cd:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2FB0418C0067; Thu,  2 Apr 2026 14:32:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AHOSv8xyFIdR
Date: Thu, 02 Apr 2026 14:32:02 -0400
From: remi@georgianit.com
To: "Qu Wenruo" <wqu@suse.com>, "Amit Shah" <amit@infradead.org>,
 linux-btrfs@vger.kernel.org
Message-Id: <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
In-Reply-To: <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
 <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
Subject: Re: Fixing a corrupted file system
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, Apr 1, 2026, at 5:21 PM, Qu Wenruo wrote:

>
> Nope, btrfs will only try extra mirrors, but in your case your metadata 
> doesn't even have extra mirrors.
> Which is not common, as the default btrfs mkfs profiles will go DUP for 
> metadata.

I forget what mkfs version, but the default behaviour changed a few years ago so the default profile is Single on SSD's. (Correct me if this has since been reverted.)  Something about the way SSD's copy on write, the DUP entries would end up on the same physical block, so the redundancy was not effective.
