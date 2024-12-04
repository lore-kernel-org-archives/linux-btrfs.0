Received: from mail.bitfolk.com (use.bitfolk.com [85.119.80.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E931B28684
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Dec 2024 22:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.119.80.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352040; cv=none; b=BwaHnNWAH6FNHDUx5Aalczfuw53+yA9+bd24pmEgyKfNwdqeEDyO5FQTYpYDKh9KqmMMAGcr0tQBES00NrIBofS08DWWXIM0DfJen/aS2WEo3ydCTMBPeyDscIKP645RjyWjWIwkD76nTqM1lUP3iRPvl1j1PZKHl+ZBBHmovi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352040; c=relaxed/simple;
	bh=msMffHXIzDUKdRnSKlUkjT3loPZblhnvTVKxvcsH8fQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EQJKDc4tfsen6UbUmt7/mAHuGOXTBAAHJcA26AVtatNLdATEGJYIIxsc/7AtVIiK9p9bk22GaasswRsC90+zG5nGItKl8URdpO0/uuUhTJHHo3eUhwFix0LAganV1TOHueTxGb1SdzVN72glxtOBVyvrhJLLPVPGjVulJLuZooI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strugglers.net; spf=pass smtp.mailfrom=strugglers.net; dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b=HYoombAz; arc=none smtp.client-ip=85.119.80.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strugglers.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strugglers.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b="HYoombAz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=strugglers.net; s=alpha; h=Content-Type:MIME-Version:Message-ID:Subject:To:
	From:Date:In-Reply-To:Content-Transfer-Encoding:References:Sender:Reply-To:Cc
	:Content-ID:Content-Description:Resent-To;
	bh=lRVjiVuVJgGFxICs5Wmo1zDlD9zcI+nikffanq5FLxY=; b=HYoombAzC275StS/iSbnuEz37J
	BRJZLdjCA1uh9QiXeyGESSUK22/dg2pf1o2VjgjIOw5SMfPOmiBBOKirADhAGIK1g7looDsmhs8k0
	qxrvahn6z0DFluYWT7U5l2YeBiSqaIviPGDHw0XEnovCsBKkEuImOokt6TmzUnMZgab/RNy9VrcmU
	fyVrv45x3uQoW68WbvD9tBOxjT0babnerMOZgzQ608PKzvPh0r0+/+WmOVI+sfYRoJYut0WlfDb2G
	mhF3UXFuuggz1twDy7uSSZ8T/k3fs2vcIxHE717rrbQ8WhXhtutL0JA6HWThW5CySnneNFl3L3q3c
	oH9EFZ4g==;
Received: from andy by mail.bitfolk.com with local (Exim 4.94.2)
	(envelope-from <andy@strugglers.net>)
	id 1tIxn6-0002nP-9i
	for linux-btrfs@vger.kernel.org; Wed, 04 Dec 2024 22:24:16 +0000
Date: Wed, 4 Dec 2024 22:24:16 +0000
From: Andy Smith <andy@strugglers.net>
To: linux-btrfs@vger.kernel.org
Subject: Copying a btrfs filesystem from one host to another, reflinks,
 compression
Message-ID: <Z1DWkM8wjak50NrG@mail.bitfolk.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL: http://strugglers.net/wiki/User:Andy
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false

Hi,

I need to copy a pretty large filesystem from one host to another.
What's the best way to do it?

The source filesystem has a single device (redundancy is provided by md
RAID) and uses compression. Destination would be the same. It has a
large number of reflinked files. rsync or tar | ssh | tar are not going
to handle reflinked files, are they?

Should I be using btrfs-send?

There's no subvolumes and no snapshots involved here. Would I just
btrfs-send to a new subvolume and then mount that subvolume as the
"real" filesystem?

Would that preserve compression or would I have to go through and force
recompression of everything?

Source host's kernel is 5.10.0-32; btrfs-progs v5.10.1 (Debian 11).
Destination would be Debian 12 so kernel 6.1.0-28 and btrfs-progs v6.2

Thanks,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
