Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3C326656D
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791844159; cv=none; b=n5PUmkcRijrkUhFooE/4sPm7NyEMt6mRXZlsqC69RCKvxTUpfRh0tZPh62OnOzj3HOydNeVqR4MZI+5zsImMSgoizdka5cqAbEIoowSsBlRzfTDZKXLbFLLMMRNzhViFQFsUYnXjRsEtONkZVMiatwh86IskqK+ZTYtmtK0INDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791844159; c=relaxed/simple;
	bh=ssYsPzqTmYokerB7QGwOCbmPWeGJbf8lqHoQxyjLRXo=;
	h=MIME-Version:Date:From:To:Message-Id:Subject:Content-Type; b=aQASYF5WpCnv3ySCfQIZ2e8AMTvsIpXUnI617tY7FO7hp5LAupIlA0Jm+D3eV8Oy/o70XgL5fe1EaCWsuy4snaEUiEKm+t+HqCl9kvrdmDPfyPpukMULb85pmNCwTGTZsV9ALxxQp8K8RGp9HatcgduflL8Q9q+MMCmSH/T2ixs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com; spf=pass smtp.mailfrom=colorremedies.com; dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b=p+nb5BvQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bXAKeXk5; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b="p+nb5BvQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bXAKeXk5"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 39C031D000F6
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 18:29:17 -0400 (EDT)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Mon, 12 Oct 2026 18:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to; s=fm2; t=
	1791844156; x=1791930556; bh=ssYsPzqTmYokerB7QGwOCbmPWeGJbf8lqHo
	QxyjLRXo=; b=p+nb5BvQFm9+p3VlkQ79343urfTMMxd+IP4hN0Bu///IH+F7lDM
	hid+PxReFwEMYvQ3ffR5oI5iz6eBpHQMmdQBMeiSOoLEzlvFyLmcz3jNG1gFzLIC
	8KP0oSGZcob5Zx+f8o1Uz84vdhnAaxuSWDLczRUInlAxm4cIa5EatXCd+ESkF92h
	8iMEDDxHpjpHeCTnUrYASBJypGF1111MjjsL+d2ZgYsrVv470utGL7Jx9OHCKvww
	49DjfbSLCGtEWVlF+APBPgoDGRgEZ2LHsCSfgjUrNTWehxPXY4Vsp9rUQeDwnAD2
	3hwLZIxeH5Dogyg1hXYGi0OhZa2zi/tC1RA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791844156; x=1791930556; bh=ssYsPzqTmYokerB7QGwOCbmPWeGJbf8lqHo
	QxyjLRXo=; b=bXAKeXk549g67Wc7AaZUGhAhugBiMZJtbwx6TX4V+HaPEYVaU46
	mw2HdU6IAdhK39/uwmDOLSSs9Tj/ldJy9tcW24iobNQe0W0I0eBOMcLG385QkXzV
	11tMSvvbPNRKVUD7UVR//XVCm8RjoQxpyoC4YAvNb/acNyucwfSy4MzfAbNkrv6K
	ZeW/YXPdKKBxwALDsAeNx2E5zWjNGygzwoFgrLBHZF4UN2pUVKAPSJbBgXIRDiUc
	V2kmieynQjdlK/Z8VMrr42TGg3eE7ozFlrgoJsPtHcc5H5HQDBJVb3rXBumSEGa/
	sRoIH36v6WAJJd5nzMATE7a5MbfNAiKbf0A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=colorremedies.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791844156; d=colorremedies.com;
	mf=PGxpc3RzQGNvbG9ycmVtZWRpZXMuY29tPg==;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm2:rsa-sha256:nfLZSvFGwvFEZjl1C4OiXfurU1j99dtIl0s56qAz7rgYV8L
	6xt3gKRgiYyLJXojJCtHrQr2WrBEzxvSHgsQATIKMW5Y10PvQH9GDKPfztiHEkbA
	uEX20eaFfCwU561SpEab5l/b7cKIZeFrjglXmlWSdzqwI9quxQuyTDfV0xvx3ULQ
	O4/veOoblTnR5wNfBNtEG92wfAVRVpgSSyLGbHnQ1mznRSKIOkA4LAYpKc6H4teQ
	CrHY0PGmWyP6jbUWi1PwOTePHvqOjN/ZmAZmf3YQC/fPJVJvfbDcLN4Mx3vNgSYd
	S4TK3j09IAecgQvXgEZAMPU3fridLasBQhDzX9A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=content-transfer-encoding,content-type,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:UJXCB8ieTjQ4hHFF1pHZGcIjpvVL/knP//a7iqTDwDc=:ssYsPzqTmYokerB7QGwOCbmPWeGJbf8lqHoQxyjLRXo=;
X-ME-Sender: <xms:PF_NavTV9yE9kRJyUyh81WutiG_zWX99dDQTxO4xgYt1ClPC0FqD5g>
    <xme:PF_NarkkPtHSMPk5Ub8S661CLzk3qq16rIzvXZxXoo5Rr55PgXSIUraIdK4cv3r-2
    8Woh0hfeE-S67xwjFdZIV985Yjrld3_kUm8jzqvTA-zTQbxmj6kEWnX>
X-ME-Proxy-Cause: dmFkZTGGqRDhg4fRplFOAlgvGXvpypih0+oOVhln7N38tTrfhSCp7SKl2qkKE1/9bH9jIc
    wZkSHiz3FTaepBcKtO320j27BElhMp4EAhvPNf08C0OEJRcagCdXpO6vBsqIFPH3W640pz
    caw0U6ITQ9GefkrdZGngS2IUv1GLKqPMBUf7Njww8DMsdE2P3czCco96jkR1Ix03hEmIyM
    bOwQy02dS6EtwUugdGuNdfs8lm5Tlq+2tcUHNJNyjQA/dR2RMnMtXw+cMFmc1tL5bjawsj
    ti4ej+G3EVPf24+2TPiy0LKf6b6XYmxEhcEYGqTOFeMmxLqUgxGQuJCXuvEeKO7X12IPMT
    AXGOme2fE9GMa3625m6CQJ3po5P5G5sfrZJhMa+AIU6XGZsOSDTwPpm66Y5tgJBAYzPb2/
    02TeMQvPXtXasQY/ePSLVATnSIXcFVXZmtnMAzDlzuEwmqensooZICOzAWvUoBdsPf+uV7
    JHSKsv6Kq53/YSCZEgSn6Upt2TQZumcGmaGg26Vx1iiD4U0lrLNN9QknqS4jyR1nStoRpM
    7UWspRKEr4yUDCSobfzW+Y7apJFo/ReeVBLul8Ykxq5zl4BTF6d7XoBM6J/txcSCnEnfSE
    DxlqQ7IAwoUarNCwxp93g5IC/gPMpY5yve5pUpnFaAvqvQTp9f4ORX7JA1DQ
X-ME-Proxy: <xmx:PF_Naqvwh0TL3g6Aa34hoQcQeHkC_ytbfSbIwNQvGT_0VzfdXCuAoQ>
    <xmx:PF_NanOeiWAlLBKTPed_J6KT9QuHFyMdY-4oPBAHxxAo7VOnwdaB3A>
    <xmx:PF_Nao1EWfWq3_81Z7zjW3SeVLr39B1tOGdpnWeiB3fb27OQYbCy1w>
    <xmx:PF_NajNfJi0RMLFEhSJj-zbQ5Iw6D5tXT5tk4bcM-GjRMTY3L7V-NQ>
    <xmx:PF_NamIRqGAy_vu47nk8fp3X3zwSh_O53va1l3Cm-ZCMBdmu1HdUhDcl>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8C23218C0067; Mon, 12 Oct 2026 18:29:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 16:28:56 -0600
From: "Chris Murphy" <lists@colorremedies.com>
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <9fd8f4f4-02bf-4273-8115-e3b7c700d880@app.fastmail.com>
Subject: feature/enhancement, btrfs check --repair combined with seed-sprout device
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Given the state changes that --repair inevitably causes (overwrites), I'm wondering if we could optionally leverage btrfs seed-sprout feature to force COW, even when using --repair? If repair succeeds the seed+sprout can then be mounted to test it. If it fails, throw away the sprout.

A further enhancement could be to make this feature automatically use a zram device as the sprout - redirect the repairs to volatile memory.

--
Chris Murphy
