Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:43507
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321Ab3GZMKE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 08:10:04 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.fire (8.14.5/8.14.5) with ESMTP id r6QCA2Ct015112
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 13:10:02 +0100
Message-ID: <51F2671A.6080705@petezilla.co.uk>
Date: Fri, 26 Jul 2013 13:10:02 +0100
From: Pete <pete@petezilla.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Error on rebooting
References: <51F1C09C.9020602@petezilla.co.uk> <20130726074752.GK20517@carfax.org.uk>
In-Reply-To: <20130726074752.GK20517@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo,

thanks.

On 07/26/2013 08:47 AM, Hugo Mills wrote:

>     Looks like it. I'd recommend a scrub to check for any other out of
> date data on the affected drive. I've done pretty much the same thing
> as this myself, and a scrub, though scary in the amount of noise it
> made, fixed everything satisfactorily.

bash-4.2# btrfs scrub start -Bd /mnt/data-pool/
scrub device /dev/sdb (id 1) done
         scrub started at Fri Jul 26 08:18:00 2013 and finished after 
9849 seconds
         total bytes scrubbed: 984.77GB with 540 errors
         error details: verify=20 csum=520
         corrected errors: 540, uncorrectable errors: 0, unverified 
errors: 0


So a bit of a wobble but raid1 to the rescue!  Not sure what caused the 
wobble.  But all is well now.

Pete



