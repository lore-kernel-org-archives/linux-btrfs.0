Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3KTGfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 01:35:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vj1Nc-0005nn-4W
	for linux-btrfs@vger.kernel.org; Wed, 20 Nov 2013 07:35:16 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 07:35:16 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 07:35:16 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Date: Wed, 20 Nov 2013 06:35:01 +0000
Message-ID: <l6hl6b$i5h$1@ger.gmane.org>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com> <20131119090602.GV4315@carfax.org.uk> <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$cd41e$ced598aa$e5d2ed3a$3c71af6f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/11/13 23:16, Duncan wrote:

> So we have:
> 
> 1) raid1 is exactly two copies of data, paired devices.
> 
> 2) raid0 is a stripe exactly two devices wide (reinforced by to read a 
> stripe takes only two devices), so again paired devices.

Which is fine for some occasions and a very good start point.

However, I'm sure there is a strong wish to be able to specify n-copies
of data/metadata spread across m devices. Or even to specify 'hot spares'.

This would be a great to overcome the problem of a set of drives
becoming "read-only" when one btrfs drive fails or is removed.

(Or should we always mount with the "degraded" option?)


Regards,
Martin

