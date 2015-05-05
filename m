Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49813 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761669AbbEERD0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 13:03:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpgFg-0006oP-Po
	for linux-btrfs@vger.kernel.org; Tue, 05 May 2015 19:03:24 +0200
Received: from pd953ef73.dip0.t-ipconnect.de ([217.83.239.115])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 19:03:24 +0200
Received: from holger.hoffstaette by pd953ef73.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 19:03:24 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: hard lockup while balance was running killed my raid5
Date: Tue, 5 May 2015 17:03:19 +0000 (UTC)
Message-ID: <pan.2015.05.05.17.03.19@googlemail.com>
References: <5548F177.1040309@linuxmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 05 May 2015 11:36:07 -0500, Perry Gilfillan wrote:

> My kernel
> Linux lightmyfire 4.1.0-0.rc1.git1.1.fc23.x86_64 #1 SMP Sun May 3 
> 14:26:14 CDT 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> I've got btrfs-progs and btrfs-progs-unstable from git, so I'll use 
> which ever might be useful for any further diagnostics.
> 
> Since devid 1 & 2 appear to be fully utilized, I set off a balance, the 
> system locked up,  and nothing I've read points to a solution yet.

I've also had a hard lockup just the other day during a balance (on a
single device though), so this points to some changes in the 4.1 merge
window.

Just to confirm: by "hard lockup" you mean that the entire box is frozen,
no longer shows any signs of life and no longer responds to anything?

One thing you could try is to mount your devices without the free-space
cache (-o clear_cache,nospace_cache) and try to run the balance.

Would be interesting to see if that helps.

-h

