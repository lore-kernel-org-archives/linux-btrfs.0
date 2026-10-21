Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=23.83.218.254
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792621929;
	b=oK6/cmDS98h+2qU3r0hbFuZyz233rl7ci8vA9jP/dT7uvjxkbHj0WW1689HeuXJ+SBDJ
	 U1s8gWxqfsWUPMF1sbY4Vp/MiNmawmpv6FdoiKzDPXWRBOs0E9uLkPzbenIE45/8E/73T
	 5E5ixXB2hNrm/87+XZGwgpLXrR9HeBsEfF6d5OIMrKTxWBZMF4e4ACC3q4pZGFkykAwDv
	 mHfJpabA5oKOYgzifhT6d4W+zSznTaAlDdWgqxV3Ga5KfBW3b1axutDqAi/HkZ46jz/j2
	 +rkuSMzfxXt7fp19Dkhxe2FUpcfEut5xthV5NuXc/pwYLd5IHcPutJhd9M2FfIeCVdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792621929;
	h=DMARC-Filter:X-Sender-Id:Received:Received:X-Sender-Id:X-MC-Relay:
	 X-MailChannels-SenderId:X-MailChannels-Auth-Id:X-Blushing-Suffer:
	 X-MC-Loop-Signature:X-MC-Ingress-Time:Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version:X-AuthUser;
	bh=jcWebnedzX6MUgxEmpyDiAZfWiG8qKSDLwC402naTwQ=;
	b=iOpfS0sr7xQ7smCv3R1xrtqIK8JSxBQDpZ1jRA5atiOL+YeGGZDtoz8SykqIRVI6HtbC
	 uNG9OPwEnsQdPiZKwKgWBFN3+lDzSRl5Ng8lVUwPGotsdsi0KuKbRKHn4wQou02rOJFfQ
	 ToRb/uH40zWYlzlq82l5vxbz4dXaQJRR6jiXUp+NLQiGQJcv/i1QaUElYRsL89yv0Dhyx
	 g9576M9l41Vd/y9gLruPDuWsXUonJIHA8JLzxFMi23bxicGdWQYpZvhc0lFvdZ0mVmnmb
	 PhgtX7qkVqpiWyujU8qFMeCmRiPv5AiKxLBirQE3n56rkqBL5lc8Va3yjBA0+GmBWwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scientia.org;
	spf=pass smtp.mailfrom=scientia.org;
	arc=none smtp.remote-ip=23.83.218.254
Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8986606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:32:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8986606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2B4C4725AEC;
	Wed, 21 Oct 2026 22:32:02 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-8.trex.outbound.svc.cluster.local [100.96.3.96])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 4BD747259CE;
	Wed, 21 Oct 2026 22:31:57 +0000 (UTC)
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Blushing-Suffer: 2c9817071594384c_1792621922030_763483267
X-MC-Loop-Signature: 1792621922030:579470060
X-MC-Ingress-Time: 1792621922030
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.3.96 (trex/8.0.2);
	Wed, 21 Oct 2026 22:32:02 +0000
Received: from [185.230.125.30] (port=11073 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <calestyo@scientia.org>)
	id 1xJeqh-00000002j2y-1NRC;
	Wed, 21 Oct 2026 22:31:55 +0000
Message-ID: <9a7a569a1dd5fedcc414bd4ddc60c153f23198ec.camel@scientia.org>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 22 Oct 2026 00:31:54 +0200
In-Reply-To: <CAL3q7H7_uhKEQbdSQb34mgW1r=Gf0L2ko2=+ocpNRDnm72L_ZA@mail.gmail.com>
References: 
	<CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
	 <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
	 <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com>
	 <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
	 <cb95f89af722c5f57e99d4424c8b31a5155fbdc0.camel@scientia.org>
	 <CAL3q7H7_uhKEQbdSQb34mgW1r=Gf0L2ko2=+ocpNRDnm72L_ZA@mail.gmail.com>
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

On Wed, 2026-10-21 at 22:49 +0100, Filipe Manana wrote:
> It depends on what you mean by data corruption.
> For some applications having a missing hole may cause
> application-level data corruption or inconsistency.

Oh? I thought this would be just like a when a sparse file is written
inefficiently and consecutive 0x0 are actually written to storage and
not punched out.

So I'd have expected that only very unusual stuff could cause breakage,
like when the software explicitly expects the hole at some point (but
then doesn't find it) or when the used space on disk is bigger than
expected... but not when it simply reads.



> Just compare the version in the received snapshot with the one in the
> original one - diff, md5sum, etc.

Would this ever report anything? I mean shouldn't file A with the hole
(which is still read as 0x0) give the same than file B without (where
the 0x0 are stored on disk)?


Thanks,
Chris.
