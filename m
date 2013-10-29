Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40098 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab3J2X0b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 19:26:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VbIgA-0005u3-9w
	for linux-btrfs@vger.kernel.org; Wed, 30 Oct 2013 00:26:30 +0100
Received: from dyndsl-178-142-088-138.ewe-ip-backbone.de ([178.142.88.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 00:26:30 +0100
Received: from hurikhan77+btrfs by dyndsl-178-142-088-138.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 00:26:30 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: memory leak in <=3.11.6
Date: Wed, 30 Oct 2013 00:26:45 +0100
Message-ID: <lqs5ka-14g.ln1@hurikhan77.spdns.de>
References: <9c53ka-otf.ln1@hurikhan77.spdns.de> <CALJXSJr0sjzFwCT=w1WdDX+-CWS-CjDhYBArVpvTeUNBM88Mdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jérôme Poulin <jeromepoulin@gmail.com> schrieb:

>> If I close all my desktop programs, my system stays at +12 GB RAM usage
>> while after a fresh boot it has 12+ GB free (of 16 GB). Cache stays low
>> at 2 GB while after a few minutes uptime cache is about 5 GB.
> 
> I probably have the same problem over here, after about 2 weeks of
> random read/write it seems my memory and swap get almost full and even
> after killing all process and getting in single user mode, memory
> won't free up.  Would you happen to have quota enabled too? Kernel is
> 3.11.4

No, quota is off for me. This is a three-device btrfs desktop system. Quota 
has no real use for me (except maybe for subvolume accounting).

I first thought this may be related to having zcache enabled, turned it off. 
But anything that changed is when memory stress arises my system stays more 
responsible and does not go havoc on the CPU.

I switched to zswap instead, since then swap usage is much lower. But still 
it does not help if memory is mysteriously used somewhere. At least IO 
stress is lower now with that setting and I am better able to cleanly shut 
down programs and the system for reboot.

Regards,
Kai

