Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0174052A5
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537373; cv=none; b=UKxWZJbgVWvAm91TDU2onK47hpjNTFjbE+Vmnd8CfiH9R4Jl7omwfjiVTCBm0/1JooVRVjZGmIu9eHCiOOyScFTfMrRn+Vd6ocDgGI3QjxUc+viewIuZiP+RUuZL1hv57GsGcrEhOHBOdN/MT6uAMhrscIdSCYkfttWbKLGmgxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537373; c=relaxed/simple;
	bh=a9xKYGvuXhnFf7dVVYflDCLf9gsjDoECsAbA8HwO8OM=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=IBe5nXiD2/DWRej/dONDQMLTy6V9Lefb2PXt+Jdhaty5PUnjoTxWRXLkzzL0JEr1m0MkpxLNweYE8DxEBduiEuRBQdP7ph12hq23lBZKB7Dsgi1DlATSYiemcJCxHQoN/qhQF5bjiPxDQacl7Uz7FKbcV+aY88mYYnimdTveg4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com; spf=pass smtp.mailfrom=tutanota.com; dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b=xDO8g8IS; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="xDO8g8IS"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id 17AD717A961E4
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 17:56:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788537364;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=a9xKYGvuXhnFf7dVVYflDCLf9gsjDoECsAbA8HwO8OM=;
	b=xDO8g8ISZoFhwruDCbnIjxaUNpAlCtgm20LUCINnyqSfD87D/GKYa3/vgwnrvUbC
	yrTcl82hVTFlmco9IywZYm6EgOX0raxEFaHay65ZCJoXWSjqNKx/EBYlFaByJ5lsEqQ
	1wLb1w7a+8ydNNwf1/b3TDAQg2Jdrr+pcv9iANMGZUwo6AYAixbiyKEizugYe+VP8cY
	VIoBt+NPGyuqlVt7s/HoHTlDikGVfwlAqwoHH6c/JuC/m3diUFLHHUlEn8GYUCpWBDk
	a0RpyenxuW3ENbSBurbFnxqXpaxRuvie0NgNnwx1Zgb1+fAJi28RhZ7bMTrotp63/s7
	/CO/oAbiPg==
Date: Fri, 4 Sep 2026 17:56:04 +0200 (CEST)
From: kocelfc@tutanota.com
To: I R E C C A K U N+kernel Org <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Message-ID: <P0h7XLr--J-9@tutanota.com>
Subject: Re: Device for root volume appears as '/dev/root', 7.3-rc1
 regression
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: 010cbb7b33206b823773619b20b76ba3df86b335583214e4fbb776cffe74e211182f5ace27d9699555a57f77c27c3eab3dd144d92bd9b12c340f88cc2299e6d812:TurnOnPrivacy!:tutamail

I am also running into this but only when I boot without an initramfs. If I boot with an initramfs, the partition seems to get mounted "properly".

CC'ing the people who signed off on the commit.

Regards,
Kostadin
