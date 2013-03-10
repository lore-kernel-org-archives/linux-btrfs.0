Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39760 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab3CJXzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 19:55:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UEq5g-000420-EV
	for linux-btrfs@vger.kernel.org; Mon, 11 Mar 2013 00:55:44 +0100
Received: from cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com ([81.97.59.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 00:55:44 +0100
Received: from samtygier by cpc2-with5-2-0-cust470.1-4.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 00:55:44 +0100
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sun, 10 Mar 2013 23:55:10 +0000
Message-ID: <khj6gq$nan$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/13 20:31, Hugo Mills wrote:
>    Some time ago, and occasionally since, we've discussed altering the
> "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> number of copies, m is the number of (data) devices in a stripe per copy,
> and p is the number of parity devices in a stripe.
> 
>    The current kernel implementation uses as many devices as it can in the
> striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
> written as "mS" (with a literal "m"). The mS and pP sections are omitted
> if the value is 1S or 0P.
> 
>    The magic look-up table for old-style / new-style is:
> 
> single 		 1C (or omitted, in btrfs fi df output)
> RAID-0		 1CmS
> RAID-1		 2C
> DUP			 2CD
> RAID-10		 2CmS
> RAID-5		 1CmS1P
> RAID-6		 1CmS2P

Are these the only valid options? Are 'sensible' new levels (eg 3C, mirrored to 3 disk or 1CmS3P, like raid6 with but with 3 parity blocks) allowed? Are any arbitrary levels allowed (some other comments in the thread suggest no)? Will there be a recommended (or supported) set?



