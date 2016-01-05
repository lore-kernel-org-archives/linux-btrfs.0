Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36177 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbcAEQYe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 11:24:34 -0500
Received: by mail-wm0-f46.google.com with SMTP id l65so29051881wmf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 08:24:33 -0800 (PST)
Received: from [192.168.2.69] (23.115.135.37.dynamic.jazztel.es. [37.135.115.23])
        by smtp.gmail.com with ESMTPSA id kb5sm91434172wjc.20.2016.01.05.08.24.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 05 Jan 2016 08:24:32 -0800 (PST)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Psalle <psalleetsile@gmail.com>
Subject: raid1 vs raid5
Message-ID: <568BEE3F.4060402@gmail.com>
Date: Tue, 5 Jan 2016 17:24:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all and excuse me if this is a silly question. I looked around in 
the wiki and list archives but couldn't find any in-depth discussion 
about this:

I just realized that, since raid1 in btrfs is special (meaning only two 
copies in different devices), the effect in terms of resilience achieved 
with raid1 and raid5 are the same: you can lose one drive and not lose data.

So!, presuming that raid5 were at the same level of maturity, what would 
be the pros/cons of each mode?

As a corollary, I guess that if raid1 is considered a good compromise, 
then functional equivalents to raid6 and beyond could simply be 
implemented as "storing n copies in different devices", dropping any 
complex parity computations and making this mode entirely generic. Since 
this seems pretty obvious, I'd welcome your insights on what are the 
things I'm missing, since it doesn't exist (and it isn't planned to be 
this way, AFAIK). I can foresee consistency difficulties, but that seems 
hardly insurmountable if its being done for raid1?

Thanks in advance,
Psalle.
