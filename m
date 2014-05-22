Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35791 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaEVRub (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 13:50:31 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 6E7B836AA82
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 19:50:28 +0200 (CEST)
Received: from s9 (7.Red-88-15-60.dynamicIP.rima-tde.net [88.15.60.7])
	by mail.virtall.com (Postfix) with ESMTPSA id 06E6136AA7F
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 19:50:27 +0200 (CEST)
Date: Thu, 22 May 2014 18:50:25 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: mount hangs after disk crash (RAID-1)
Message-ID: <20140522185025.4c72aab9@s9>
In-Reply-To: <20140522161634.054ec95f@s9>
References: <20140522032258.234aaab7@s9>
	<20140522095101.107b62e8@s9>
	<20140522161634.054ec95f@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Try -o recovery,degraded
> 
> I would drop the other options for now, since they aren't necessary
> to recover from a \ device failure.

Yes I've tried that as well, and it ends in the similar "hang" - high
IO for a while, then no IO at all, mount does not return.


It *does* mount as ro,degraded, but then, it's not possible to add a
disk and recover to a functioning RAID-1.
Also, when I try to remount rw, the mount command hangs as well.

Is there anything else I can try?


-- 
Tomasz Chmielewski
http://wpkg.org
