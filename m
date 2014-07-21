Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50730 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaGUOAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 10:00:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X9E8n-0007OO-OF
	for linux-btrfs@vger.kernel.org; Mon, 21 Jul 2014 16:00:33 +0200
Received: from athedsl-372136.home.otenet.gr ([79.131.5.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 16:00:33 +0200
Received: from tmjuju by athedsl-372136.home.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 16:00:33 +0200
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Mon, 21 Jul 2014 14:00:20 +0000 (UTC)
Message-ID: <loom.20140721T155907-291@post.gmane.org>
References: <loom.20140720T102642-239@post.gmane.org> <53CC6B39.1060705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong <wangsl.fnst <at> cn.fujitsu.com> writes:

> Just my two cents:
> 
> Since 'btrfs replace' support RADI10, I suppose using replace
> operation is better than 'device removal and add'.
> 
> Another Question is related to btrfs snapshot-aware balance.
> How many snapshots did you have in your system?
> 
> Of course, During balance/resize/device removal operations,
> you could still snapshot, but fewer snapshots should speed things up!
> 
> Anyway 'btrfs replace' is implemented more effective than
> 'device remova and add'.
> 


Hi Wang,
just one subvolume, no snaphots or anything else.

device replace: to tell you the truth I have not used it in the past. Most
of my testing was done 2 years ago. So in this 'kind of production' system I
did not try it. But if I knew that it was faster, perhaps I could have used
it. Anyone has statistics for such a replace and the time it takes?

Also, can replace be used when one device is missing? Cant find
documentation. eg.
btrfs replace start missing /dev/sdXX


TM


