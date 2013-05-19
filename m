Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34333 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3ESLEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 07:04:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ue1PV-0000qa-5Y
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 13:04:17 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 13:04:17 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 13:04:17 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Virtual Device Support
Date: Sun, 19 May 2013 12:04:03 +0100
Message-ID: <knabiu$akg$1@ger.gmane.org>
References: <518CFE3A.3080900@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <518CFE3A.3080900@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/05/13 15:03, George Mitchell wrote:
> One the things that is frustrating me the most at this point from a user
> perspective ...  The current method of simply using a
> random member device or a LABEL or a UUID is just not working well for
> me.  Having a well thought out virtual device infrastructure would...

Sorry, I'm a bit lost for your comments...

What is your use case and what are you hoping/expecting to see?


I've been following development of btrfs for a while and I'm looking
forward to use it to efficiently replace some of the very useful
features of LVM2, drbd, and md-raid that I'm using at present...

OK, so the way of managing all that is going to be a little different.

How would you want that?


Regards,
Martin

