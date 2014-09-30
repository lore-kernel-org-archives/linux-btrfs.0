Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42779 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaI3SaF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 14:30:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XZ2BW-0003BJ-Qc
	for linux-btrfs@vger.kernel.org; Tue, 30 Sep 2014 20:30:03 +0200
Received: from pool-98-113-246-12.nycmny.fios.verizon.net ([pool-98-113-246-12.nycmny.fios.verizon.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 20:30:02 +0200
Received: from elliot.wolk by pool-98-113-246-12.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 20:30:02 +0200
To: linux-btrfs@vger.kernel.org
From: Elliot Wolk <elliot.wolk@gmail.com>
Subject: Re: 3.16.3 btrfs receive dies with rename o4736059-335172-0 -> merlin/RC/OSD failed. Directory not empty machine
Date: Tue, 30 Sep 2014 18:24:24 +0000 (UTC)
Message-ID: <loom.20140930T202206-887@post.gmane.org>
References: <20140927201941.GL26729@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc <at> merlins.org> writes:

> 
> Hi Filipe and others,
> 
> After I moved directories around, and since then my hourly 
> btrfs backup is failing.
> ...
> ERROR: rename o4736059-335172-0 -> merlin/RC/OSD failed. Directory not empty
> 


i have the exact same problem, also 3.16-3. i did something along these lines:
mv Music/2/VideoGamesLive Music/2/VolumeOne
mkdir Music/2/VideoGamesLive
mv Music/2/VolumeOne Music/2/VideoGamesLive

and got:
ERROR: rename o3854555-52412-0 -> Music/2/VideoGamesLive failed. Directory
not empty


