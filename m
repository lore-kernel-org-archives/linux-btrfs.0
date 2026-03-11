Received: from mx2.mythic-beasts.com (mx2.mythic-beasts.com [46.235.227.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC333D7D73
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 12:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773231742; cv=none; b=V+fuFZUd+1lNSd2OkDARQWs77AQ3fsuvNTQ8bgd9qS43Mv6dAFVUc0/YuPCc1FdCAnPfzZjoaQprPvK3sRWB+MfY/Iw5Fn1jvrjBdIWHEVh2eo+vlS2lUegWwY2qUdh//fv1XWv/LtKpzJTltkrkDmAmM7F01bSBE7bczbjNpOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773231742; c=relaxed/simple;
	bh=ZeMYf4ZiTW6Xbd64a+MBhKIEF1oUW2EcF74c172y6x0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=mKVsKoXU6VktHoyXsn0eRwmPbL+Vr50PKsMwy9+xPNSWT191Vmp2xNnKsXQmd+Rg85F76eKslkg923punBvF5+zRQyna3XKCNMygX5i0TK7XjsGoFE1seMlnn8RGYk4Jrqo2grZo2J4it2bGRT9rggabwcrrRKi8Vqzejns257Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cobb.uk.net; spf=pass smtp.mailfrom=cobb.uk.net; dkim=pass (2048-bit key) header.d=cobb.uk.net header.i=@cobb.uk.net header.b=Wuv/ZELQ; arc=none smtp.client-ip=46.235.227.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cobb.uk.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cobb.uk.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cobb.uk.net header.i=@cobb.uk.net header.b="Wuv/ZELQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cobb.uk.net
	; s=mythic-beasts-k1; h=Subject:From:To:Date;
	bh=3VIBXkWBXuui/IGR+gm3mcEWfaxB3hMsCPm+aeyAKEA=; b=Wuv/ZELQm3EElxQ4weMZkMlYuN
	Nuxpjbarcw42a4O3isgzDkqSOe+C+w4nbtWbL678tYu/RDzhfSCFLCW0yBAnHm7NDbkF7ELfMuOVY
	/V5kE+iJgQvToJ5Ms2xX+79bugrRNk53+Na5V+82sAxcH3zlwm6K84v4MS4MNKOszNxXri3mLrL8L
	cJ2+ihchUsVuikGLJXyZF3dQ6zIZfvAumrdh7h7rt1wyeJYefk5FkCOfSrwqi7q0Loc7ij4Et6nKy
	vIIB+kRNFKEdcr+65VgpNFP40QX5yz2u5NcIHl1Xcjq6do7Kfm4BZdQZqmLil8kWNAZA1VubwqqKc
	btB0G9xA==;
Received: by mailhub-hex-d.mythic-beasts.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <g.btrfs@cobb.uk.net>)
	id 1w0IFB-00132s-0d
	for linux-btrfs@vger.kernel.org;
	Wed, 11 Mar 2026 12:00:53 +0000
Message-ID: <b20efb6c-bb7e-4879-9982-856986c87886@cobb.uk.net>
Date: Wed, 11 Mar 2026 12:00:51 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-btrfs@vger.kernel.org
From: Graham Cobb <g.btrfs@cobb.uk.net>
Content-Language: en-US
Subject: Documentation bugs for scrub limits
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 0

I have been playing with the btrfs scrub limits capability and have 
found a few minor problems with the documentation. I am happy to create 
patches for these if that is preferred, but I seem to remember that 
there is a "collected typos and minor documentation fixes" patchset 
occasionally and these might be good candidates for the next one.


1) I (incorrectly) entered: btrfs scrub limit /mnt/snapshots/ -l 100m

The error message was:

       ERROR: --limit must be used with either --all or --deivd

This should be "--devid"


2) The btrfs-scrub manpage shows how to set the limits "using 
/sys/fs/btrfs/FSID/devinfo/DEVID/scrub_speed_max". However, the text 
below explains that the limit can now be set with the --limit option. I 
suggest rewriting this to remove the reference to the scrub_speed_max 
file altogether and adding an example like "btrfs scrub limit --devid 1 
--limit 100m /".


3) It might be useful to give users some help understanding typical 
scrub limits. While there are many possible differences, less 
experienced users would probably not be familiar with what are typical 
useful values (is "100m" a lot?).


4) Related to the point above... The man page explains the "limit" 
option talking about "sizes" and accepts things like "--tbytes". 
Presumably these are really "rates" ("sizes per second")  And it might 
be helpful to mention that things like "--tbytes" are unlikely to ever 
be useful for rates!!


5) Mention that "--si" applies only to display, not to "--limit" values.


6) Mention that the --limit suffices are not case sensitive.


In addition to these documentation issues, I wonder if a small 
functional change might also be useful... The display format for the 
rate limit shows things like "1.07TiB". However, the syntax for setting 
the limit does not allow typing in 1.07TiB (or, even, 1TiB - only 
"1100g" or "1100G").


Graham



