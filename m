Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163E93FAE14
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774456227; cv=pass; b=GooeMB+rVU2MOzrehWQ0pYQNjQNjwq32DoLHD8j6L0y2kPaYcyQkcnp5fgXaenKyv377b4ZUk9f0+giH4tHjk0hIbf/waNhgAscfTa5Qzwdw8lJwv0F4qlUMmNXZNKIgYhhUexCPrSScaq4VbU+a484vtbiBRMsMc9UhvBtDhNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774456227; c=relaxed/simple;
	bh=86ObXky886KsgSekgHJXZDoUewF3kt56jA5tU0JNWWw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BHPZmwRcvE83WEIWSihKiZSxCOwoXMZvveUa+OpbHWlK5skzrZMuto0mgRadMhgtniK+/GdupU6uOmOsXSIVOv2x91of0IXFUchTiiTXu6XJR9r59ZpJFZaRQP8zGEwuH7Fvkf4YCXiYE6FNNh/GYGzRJkl5oVQDNRco3iLntJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EBA5D4C1E7A;
	Wed, 25 Mar 2026 16:21:08 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-121-82-175.trex-nlb.outbound.svc.cluster.local [100.121.82.175])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 02D1F4C1F6A;
	Wed, 25 Mar 2026 16:21:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1774455668;
	b=7PMmW7TjmpPWg/qo2yfX0/OIVAEjgTtrayD0PGUbmHPMElAa6vQ16Ml/Ig+/MJOhIfuLkP
	mpBxv0Cua0WHdOtDdre2vhjBzoX6vEaeI5Rf2/th5blhxenky10m3xN4WXpcOOeBbD6AAt
	sjJ7atPPq8FUqqiLskzpl7/LkPT2m0bW7h+sRgQSRkJKxunKHG/nRD8ln9iVmsw86T4H5l
	YuVcE1EziUYPY6MWakluC2Eh5527w0Livws/iFSp36er4+slmZlhY9wUQjxTrKW13wiKla
	17s2jKnv6GQzyDaSzXm7qW+GnpvH/usNR7MU9GC6Vd2DP9OEZCmv/TmLIUDDEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1774455668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=86ObXky886KsgSekgHJXZDoUewF3kt56jA5tU0JNWWw=;
	b=eAg4+W8ozLgmUIb53plo0H2++RC3t89DRiaLwFON8g5xj/tWktp4FuR0W0syAgeXtoXbWf
	QigYhqjQa0UFZrYL2cjLYq1R/4SoUXRnMoatCs2iIhMJPGfnyB7ieAmFzEGyfPRp+oe7ax
	QMUyvkViN8HYiPWtoGhsC514/Dulzl81shPNjLibw4YiYFslJbPEGu9zrAwbNlGz1nJBpR
	KtqBtlWTSeGxfPnmXsDJdzFF2G3O3tm+7GAnC8nnBKa3XODc67vnf4DAqR6Jz7wAipXLNt
	SdEe0y91TFtc4VtQADiFPE2sBnK9cIdNT+QfGmWvq0jbX0CL4ATZGTWnMOXZtw==
ARC-Authentication-Results: i=1;
	rspamd-6d4cb6745-87h86;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Slimy-Decisive: 6247e3b37c7b29ce_1774455668698_4100718788
X-MC-Loop-Signature: 1774455668698:3816597860
X-MC-Ingress-Time: 1774455668698
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.82.175 (trex/7.1.5);
	Wed, 25 Mar 2026 16:21:08 +0000
Received: from p5b071a6f.dip0.t-ipconnect.de ([91.7.26.111]:64173 helo=heisenberg.fritz.box)
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <calestyo@scientia.org>)
	id 1w5Qyg-00000003R5O-0wKY;
	Wed, 25 Mar 2026 16:21:06 +0000
Message-ID: <032be7a912897f0cf5ee90f3e5ee0b2c690ff76c.camel@scientia.org>
Subject: Re: Btrfs progs release 6.19
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: joshua <joshua@mailmag.net>
Cc: linux-btrfs@vger.kernel.org
Date: Wed, 25 Mar 2026 17:21:04 +0100
In-Reply-To: <2A0C37E0-28BD-4829-9778-AB20F4482F6D@mailmag.net>
References: <f7b7f88c6f1b94b6f09f7f54bdaa3c0ee54f60ed.camel@scientia.org>
	 <2A0C37E0-28BD-4829-9778-AB20F4482F6D@mailmag.net>
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

On Tue, 2026-03-24 at 21:18 -0700, joshua wrote:
> For what it=E2=80=99s worth, (not much) I used --convert-to-block-group-t=
ree
> on a large fs with precious data (~10 drives, ~100Tb, Raid1 data,
> Raid1C3 metadata) and had no issues.
>=20
> Convert took a LONG time, but afterwards, all my data integrity
> checks passed, scrub passed, and mount times are approximately 1
> second now, compared to minutes previously.

Thanks for the information. How long have you been running with it?

Cheers,
Chris.
