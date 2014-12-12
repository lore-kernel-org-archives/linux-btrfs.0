Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-10v.sys.comcast.net ([96.114.154.169]:41175 "EHLO
	resqmta-po-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbaLLWyZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 17:54:25 -0500
Message-ID: <548B7220.1040403@pobox.com>
Date: Fri, 12 Dec 2014 14:54:24 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RAID0 extent sizes?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've seen it mentioned here that generally data extents are 1G and 
metadata extents are 256M.

Is that per-drive or per-stripe in the case of RAID0?

That is, if I have data mode raid0 across N drives does the system 
allocate one 1G extent on each drive making the full stripe allocation 
N-gigs; or does it allocate 1/Nth(gig) on each drive making the total 
new allocation 1G?

Does the raid0 have any arity constraints (like how raid1 is always 
arity-2)?

