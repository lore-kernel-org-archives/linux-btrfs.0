Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57152 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966204AbbDVQhr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:37:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ykxei-0003OP-Ms
	for linux-btrfs@vger.kernel.org; Wed, 22 Apr 2015 18:37:44 +0200
Received: from p4ff58343.dip0.t-ipconnect.de ([79.245.131.67])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 18:37:44 +0200
Received: from holger.hoffstaette by p4ff58343.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 18:37:44 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times
 during commit
Date: Wed, 22 Apr 2015 16:37:38 +0000 (UTC)
Message-ID: <pan.2015.04.22.16.37.38@googlemail.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
	<mh8h3f$l3u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 22 Apr 2015 18:09:18 +0200, Lutz Vieweg wrote:

> On 04/13/2015 09:52 PM, Chris Mason wrote:
>> Large filesystems with lots of block groups can suffer long stalls during
>> commit while we create and send down all of the block group caches.  The
>> more blocks groups dirtied in a transaction, the longer these stalls can be.
>> Some workloads average 10 seconds per commit, but see peak times much higher.
> 
> Since we see this problem very frequently on some shared development servers,
> I will try to install this ASAP.
> 
> Meanwhile, can anybody already tell success stories about successfully removing
> lags by this patch?

Works fine, but make sure to get the followup patch [1] as well while you're
at it. I've observed that my (bandwidth-throttled) backups now cause shorter,
nicely spaced-out blips of activity instead of longer ones when the writeback
kicks in.

-h

[1] https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.1&id=c1e31ffc317e4c28d242b1d961c9c6fe673c0377


