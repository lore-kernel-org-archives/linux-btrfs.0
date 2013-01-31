Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:36269 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3AaMsg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 07:48:36 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id 49C04885AB1
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 13:39:56 +0100 (CET)
Message-ID: <510A661B.8020404@siedziba.pl>
Date: Thu, 31 Jan 2013 13:39:55 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID 0 across SSD and HDD
References: <keap27$oqb$1@ger.gmane.org> <20130130100201.GN16285@carfax.org.uk> <keatr3$65q$1@ger.gmane.org>
In-Reply-To: <keatr3$65q$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> With RAID-0, you'd get data striped equally across all (in this case,
>> both) the devices, up to the size of the second-largest one, at which
>> point it'll stop allocating space.
> By "stop allocating space" I assume you mean it will return out of space
> errors, even though there is technically 250GB of unused space.  I presume
> there is no way to say that RAID-0 should be used where possible and then
> fallback to "single" for the remaining space.

There was a proposition to change the allocator, so it would fall back 
to single:

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg14517.html

I stumbled on it when faced with a different problem: I could not use 
btrfs in RAID1 degraded mode, because it would refuse to allocate more 
space, and I could not convert it to single either, because balance 
needs to allocate space too.

Regards
