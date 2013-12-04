Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42071 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab3LDPaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 10:30:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VoEOp-0001mq-Ro
	for linux-btrfs@vger.kernel.org; Wed, 04 Dec 2013 16:30:04 +0100
Received: from hosted-by.leaseweb.com ([127.0.0.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Dec 2013 16:30:03 +0100
Received: from adam.gradzki by hosted-by.leaseweb.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Dec 2013 16:30:03 +0100
To: linux-btrfs@vger.kernel.org
From: Adam Gradzki <adam.gradzki@gmail.com>
Subject: Re: btrfs-cleaner leaves CPU pinned to 100%
Date: Wed, 4 Dec 2013 15:27:58 +0000 (UTC)
Message-ID: <loom.20131204T162331-814@post.gmane.org>
References: <CALnfhZDKEs7LeTrHAk3oecJ2oOqo=VJzQqoeEy3qNB92s2CC7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam G <adam.gradzki <at> gmail.com> writes:

> 
> Hello,
> 
> After a recent kernel upgrade I noticed the fans blowing at full
> throttle on my laptop.
> 
> There is currently very low load on the machine and nothing out of the
> ordinary has occurred to lead me to believe this is normal behavior.
> 
> Here is a link to the perf output I managed to capture
> 
> http://pastebin.com/a5cAy7Dw
> 
> Please let me know if I may be of any further assistance.
> 
> Regards,
> 
> Adam Gradzki
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

I would like to add an updated perf report I took shortly after the first 
one yesterday (600 seconds this time).

http://www.pastebin.ca/2492119

Removing autodefrag from /etc/fstab has ameliorated my troubles for the time 
being.

