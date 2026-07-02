Received: from mxex2.tik.uni-stuttgart.de (mxex2.tik.uni-stuttgart.de [129.69.192.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21CB42885F
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 08:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980439; cv=none; b=Y6tgLn43NNy9p5Y9hjuG0CaciGcdHZiMaJA0TfOTw/3r4D6k24qZAJud6hZc396XVzDm2KXFKa9SgnlGrssS2oOwndFr3gKmD2k3FhDanvZV3zugDSPp/HUog1vAJPOzucgtxlB8sKugDA0rpX3i36HwodbI98yaPZaTBb7jTPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980439; c=relaxed/simple;
	bh=lDPRYsBJWOWG7F4iiBEV7prYNqaY0iH0sZoN/vLocRY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gt2YhbHC1lGZH5jCe5GJEJgYYuYu+nnrgEQIQgGyNc7w2eM1zrpljZ7/3KPiwmxgn4I3CHhKNs9bhVQEjgV6BLGBpGWfGi3HOOKIV1PfnjbGE3uZmFxqVClhwdxS5bBDr9NwA5T5knbBHDnwX1HxGtWbyMx6QQdcvddKwjPcJzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=ttDplDtL; arc=none smtp.client-ip=129.69.192.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="ttDplDtL"
Received: from localhost (localhost [127.0.0.1])
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 21D8C60C4C
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 10:12:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:content-disposition:content-type:content-type
	:mime-version:message-id:subject:subject:from:from:date:date; s=
	dkim; i=@rus.uni-stuttgart.de; t=1782979973; x=1784718774; bh=lD
	PRYsBJWOWG7F4iiBEV7prYNqaY0iH0sZoN/vLocRY=; b=ttDplDtLxIJgRTWupD
	KTXxC3++eOZAlBHjBy0kaUpokhmQlmtyJ+ICeYyuUUN0/1imfrCDLWqfYf1sW2JX
	U30LcxsGqNycpQtRsrxeOyzSA/+GUvZVtrYcjOJoddT5M9YwAWev7P12C+qilI0h
	HO5huSRP6RGtMDnsGOJXpGKQ/s44lqVYXsKHZ8+6Jw63cyWUENhMmPOWkdk7s3gc
	qD0QHoZ1rx4WE4d0cYJx9hO+LH++KgJK77GXPddSnaJSMGjVrrv3H/AXtDkMJ+Vr
	joHIiac1fuAKe3NYeBfBqtuN3nadsY9098+C5yXYQpyz8NJMe01AJ8KV2nKZju2R
	B28A==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id TqJTQRqRkQ-d for <linux-btrfs@vger.kernel.org>;
 Thu,  2 Jul 2026 10:12:53 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Thu, 2 Jul 2026 10:12:52 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: comparision table Btrfs/ZFS
Message-ID: <20260702081252.GA4036251@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)


Btrfs and ZFS have some similar properties and commands - and of course
many differences.

For (admin) users without Btrfs or ZFS knowledge I have written a
comparision table:

https://fex.rus.uni-stuttgart.de/Btrfs_ZFS.html

It is not a full feature table/list, just a quick overview.

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<20260702081252.GA4036251@tik.uni-stuttgart.de>
