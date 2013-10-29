Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35609 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3J2XfF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 19:35:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VbIoS-0007pK-7a
	for linux-btrfs@vger.kernel.org; Wed, 30 Oct 2013 00:35:04 +0100
Received: from dyndsl-178-142-088-138.ewe-ip-backbone.de ([178.142.88.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 00:35:04 +0100
Received: from hurikhan77+btrfs by dyndsl-178-142-088-138.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 00:35:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: memory leak in <=3.11.6
Date: Wed, 30 Oct 2013 00:30:26 +0100
Message-ID: <o1t5ka-p7g.ln1@hurikhan77.spdns.de>
References: <20131029132246.21258b95@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski <tch@virtall.com> schrieb:

>> I probably have the same problem over here, after about 2 weeks of
>> random read/write it seems my memory and swap get almost full and even
>> after killing all process and getting in single user mode, memory
>> won't free up.  Would you happen to have quota enabled too? Kernel is
>> 3.11.4
> 
> I experience the same daily (out of memory, server dying); sometimes
> several times daily.
> 
> It's a *big* downer.
> 
> I use 3.12-rc7, but I had this issue with earlier kernels, too.

For me it started late 3.9 if I remember right. But I'm pretty sure it 
startet with 3.10 which I mostly upgraded to for using skinny extents. While 
skinny extents has helped subjective performance a little bit I since 
experience the problem with ever increasing RAM usage - up to the point of 
15 GB swap, full RAM, and almost none of it is used for caching.

I wonder if there is a way to track where this "lost" memory is gone. Top 
shows no memory hogs. Slabtop shows some high numbers but nothing really 
impressive. It's just used for nothing it seems.

Regards,
Kai

