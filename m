Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42444 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbaBNAPx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 19:15:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WE6Rc-00073l-Ck
	for linux-btrfs@vger.kernel.org; Fri, 14 Feb 2014 01:15:52 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 01:15:52 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 01:15:52 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to wait for snapshot deletion?
Date: Fri, 14 Feb 2014 01:12:58 +0100
Message-ID: <al30ta-po2.ln1@hurikhan77.spdns.de>
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de> <4127554.quurJk0k5Q@vfr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Garry T. Williams <gtwilliams@gmail.com> schrieb:

> On 2-13-14 20:02:43 Kai Krakow wrote:
>> Is it technically possible to wait for a snapshot completely purged
>> from disk? I imagine an option like "--wait" for btrfs delete
>> subvolume.
> 
> This may be what you're looking for:
> 
>     http://www.spinics.net/lists/linux-btrfs/msg29833.html
> 

Looks fantastic. Can I vote to get it into official sources? ;-)

-- 
Replies to list only preferred.

