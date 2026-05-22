Received: from mxex2.tik.uni-stuttgart.de (mxex2.tik.uni-stuttgart.de [129.69.192.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323C033F5A9
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 23:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779492809; cv=none; b=qiYDCwcS+qgaSf852hSYH9WAZiP/nF0RTd1S5b/goj8qaTT1iPHbr+yaiH2dLV8yDKGdqO/GtcPqeHD+S0NYoh712Nm3fdYxVliPTQPzXua+uoVRf0DOyPpYS0ebv+0QX+74kvylbsqAwa6SntDKwQ9VKKc2rdlfu5cfj2S2pH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779492809; c=relaxed/simple;
	bh=KIXfQsuDLFgKVL8jv4C7rVljwwGHx7lLmuO4U5PsmMc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pLY6N0siFA7trJf3FTQFaZLBa/7Ch51EPmsFVrxC0g6SPE6xcLWJbeU8MuowOa2HCjqD0zaWUs/wx87aR3rf+JUChkPZa3iTeOZQCto8www7Wv60I8inevMapenI5l3R2bo3U0mpAbw6fWJud8Kb9Cebpl3WNF2MOy7uwmarabg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=F1g1CMfU; arc=none smtp.client-ip=129.69.192.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="F1g1CMfU"
Received: from localhost (localhost [127.0.0.1])
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 5D07660E0F
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 01:25:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:in-reply-to:content-disposition:content-type
	:content-type:mime-version:references:message-id:subject:subject
	:from:from:date:date; s=dkim; i=@rus.uni-stuttgart.de; t=
	1779492333; x=1781231134; bh=KIXfQsuDLFgKVL8jv4C7rVljwwGHx7lLmuO
	4U5PsmMc=; b=F1g1CMfUvpApXTMhkTPx51eiBfxHYC65SzfX6ZWn5fvxeOiEfQg
	zDM50TMIgRUsvY4dLA+lAhGRif6P6USLf4AdXmxj2308oUcAKZyp4sdqnYOnz67t
	H2nAC2qZYU2wWgbuNmz9rovIjgIjunpct1/Wx+ObWi7PnlOv6Cyl0lzzFDmdyn/r
	sgcRAn535NX9zDSWFR6UYjM50avVMAQQs+WyY/9cAFo5m4C3ujuTUS8T+/RnwSe4
	PtVRrZJsixzM6A/7yumXqof4WdNeez6w7aJoEDUN3FYLVwqwH7zYRSlHP/GWYoGn
	+mECerUZT23gQdTVQgPk/4OFWKks6S1Lz1Q==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id aJ-Mmvdl1bjl for <linux-btrfs@vger.kernel.org>;
 Sat, 23 May 2026 01:25:33 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Sat, 23 May 2026 01:25:33 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 7.0
Message-ID: <20260522232533.GA316642@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20260509235151.2070978-1-dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260509235151.2070978-1-dsterba@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)

On Sun 2026-05-10 (01:51), David Sterba wrote:

> btrfs-progs version 7.0 have been released.

Thanks.
This version correct some bugs in the Ubuntu 24 btrfs package.


> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> Release: https://github.com/kdave/btrfs-progs/releases/tag/v7.0

To get the newest version of btrfs.box.static I have written this script:

root@fex:/opt/btrfs-tools# cat btrfs-update
#!/bin/bash

bbs=btrfs.box.static
cd /opt/btrfs-tools/bin || exit 1
vv -s btrfs
rm -f $bbs
curl -sS -D- https://github.com/kdave/btrfs-progs/releases/latest |\
perl -ne 's/^location: (\S+)/wget -q $1\/'$bbs'/ and s:/tag/:/download/: and print' |sh -x
if [[ $(file $bbs) =~ executable ]]; then
  cat $bbs > btrfs
  del $bbs
fi
btrfs --version


Yes, it works but it is ... ugly :-}

Is there a more elegant solution?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<20260509235151.2070978-1-dsterba@suse.com>
