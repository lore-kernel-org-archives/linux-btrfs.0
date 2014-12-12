Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:47122 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934631AbaLLJtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 04:49:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 1E42D3EA347
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 10:49:03 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qXztiThjU9oR for <linux-btrfs@vger.kernel.org>;
	Fri, 12 Dec 2014 10:49:02 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 10:49:02 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 12 Dec 2014 10:49:02 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Balance & scrub & defrag
Message-ID: <d4031d3b7b5f8f75469d8e822a394caa@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I use SMART (smartmontools etc) and its tests to keep track of and warn
> me of such issues. It's way more likely to catch incipient media
> failures long before scrub would. It's also more likely to correct
> situations before they become visible to userspace. Its also a way
> better full-platter scan that involves less real time delay and won't
> bog down a running system.

Don't put too much trust in SMART - sectors can rot unexpectedly even if 
SMART is thinking everything is fine with the drive.

I had exactly this issue recently:

1) one of the drives in the server failed and was replaced

2) "btrfs device delete missing" (which basically moves data from the 
remaining drive to the new one) was failing with IO error

3) according to SMART, the drive with IO error was fine (no reallocated 
sectors, no warnings etc.)


So, scrub to the rescue - it printed "broken" files, after removing them 
manually, it was possible to finish "btrfs device delete missing".

Probably it makes sense to run scrub occasionally (just like mdraid is 
doing on most distributions).


-- 
Tomasz Chmielewski
http://www.sslrack.com

