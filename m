Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34463 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3HCRao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Aug 2013 13:30:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5few-0001C1-HC
	for linux-btrfs@vger.kernel.org; Sat, 03 Aug 2013 19:30:30 +0200
Received: from host-091-097-227-150.ewe-ip-backbone.de ([91.97.227.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 19:30:30 +0200
Received: from hurikhan77+btrfs by host-091-097-227-150.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 19:30:30 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Is the checkpoint interval adjustable?
Date: Sat, 03 Aug 2013 19:28:35 +0200
Message-ID: <17rvca-hju.ln1@hurikhan.ath.cx>
References: <20130731200229.221580@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Audia <mikey_a@gmx.com> schrieb:

> I believe 30 sec is the default for the checkpoint interval.  Is this
> adjustable? --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Just curious: What would be the benefit of increasing the checkpoint 
interval?

As far as I understood it would not decrease write load on the drives 
because it will only update a few pointers and probably increase the 
generation number...

Greetings,
Kai

