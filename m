Received: from calculus.sigma-star.at (calculus.sigma-star.at [188.245.196.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9383E5A33
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.196.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789909484; cv=none; b=h6jhlDyoP/ce9UmxlFEcTmes4T9Zknrsqvs2doFrbVrX3KqEqdyx14s6u/ny2QoMZoS9EyiqYdTny7sll0GLGIL1Hw8TpZ0U9wpSrg25tydXFnT4C2vqkJNKjD+OQm2btibsq3mQuJVsLtJEGdSTNlcWsZ3RmSatSmn74D+XXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789909484; c=relaxed/simple;
	bh=m7hT4/Isdum+6kiekJTVVdgUUJV2mMNOrd5Jg9t6bFc=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=d5W+izYwSLXA+8X6x7WioSW2RD1PAwHBg8qkt392gOPENr6qPWOCxK3vaSNgSpsKsEFjMKY6co5ECKM5CBXiM+51UoYTewaynzrQFI4uOeVEmSW5go6AFyRZAsrr7U/bNqihR/KIGa7plEfEqAfLqu+EVXriXtiK1foJr/n0Mk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; dkim=permerror (0-bit key) header.d=nod.at header.i=@nod.at header.b=FEr/8c52; dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.b=C57uS5yo; arc=none smtp.client-ip=188.245.196.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=nod.at header.i=@nod.at header.b="FEr/8c52";
	dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.b="C57uS5yo"
DKIM-Signature: v=1; a=ed25519-sha256; s=v1-ed25519-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1789909466; bh=m7hT4/Isdum+6kiekJTVVdg
	UUJV2mMNOrd5Jg9t6bFc=; b=FEr/8c52CRxGCSAZJG1mSl4jS21lb9duIS5q9F+kAlUSJLA1Lx
	vS0FZBCmakSrWEYN1PmGPYMcSCe+Y3YMpGAQ==;
DKIM-Signature: v=1; a=rsa-sha256; s=v1-rsa-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1789909466; bh=m7hT4/Isdum+6kiekJTVVdg
	UUJV2mMNOrd5Jg9t6bFc=; b=C57uS5yoh8nnTkq3YtJwqPqodZzKS7R4ErDMm6LQH7blkDpkOV
	kw971bpFXNhMr02pS1Ic2wTCWIsa5NLyQX4do7igsDXAEObaEv8CR7rkxvoZ+482BQJjg3prwT4
	wp0W9TlTRYFzShLttXtvB8WqfC9USunpWdsxQIboOHs+i9go3gYzols0GKjOmij8wb+iB5so747
	K4yS8auWUsuEX4w5V54YM/yXiPQqxZFTuOu6PuvLJX+dYziwKv8EZSklenxcF7e7VOjQfCqPMXI
	44YmrLFv4RGwwB4PRkSV0B6GLZmMCortQHT3fB2yyLP1yZbUMSAw3ud7oxVxqwtnW7A==;
From: "Richard Weinberger" <richard@nod.at>
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Cc: <johannes.thumshirn@wdc.com>
Subject: AW: qgroup rescan worker makes suspend fail
Message-ID: <mu9tvrfs.69b33ebc-d8ca-49db-85f6-9bd322ccf4f3@nod.at>
In-Reply-To: <72837ffa-61da-4ea1-9d98-ad2a350a955a@gmx.com>
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
	<72837ffa-61da-4ea1-9d98-ad2a350a955a@gmx.com>
Date: Sun, 20 Sep 2026 13:04:26 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Sun, Sep 20, 2026, 01:38 schrieb Qu Wenruo <quwenruo.btrfs@gmx.com>:
> > Wouldn't it make sense to have rescan_should_stop() return true when
> > suspend starts? I think using a pm notifier could help here.
> > What do you think?
>=20
> Mind to try this diff? Although it requires certain pm freezing=20
> sequence, for now the kernel freezes the fs before processes, thus it=20
> should work:

Since the problem happens only every few weeks, testing is not that easy.
I'll try to come up with a reliable test inside a VM.
Speaking of my use case, I run openSUSE. So snapper is installed and enabled
by default.

Thanks,
//richard
