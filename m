Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41957 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CAPO3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 10:14:29 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AB5D87C0415
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Mar 2013 08:14:28 -0700 (MST)
Date: Fri, 1 Mar 2013 10:14:26 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: try harder to allocate raid56 stripe cache
Message-ID: <20130301151426.GA10225@shiny.masoncoding.com>
References: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1362150180-13792-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 01, 2013 at 08:03:00AM -0700, David Sterba wrote:
> The stripe hash table is large, starting with allocation order 4 and can go as
> high as order 7 in case lock debugging is turned on and structure padding
> happens.

Thanks Dave, I had this on my todo list but it dropped off.  We don't
really need the stripe cache for most mounts.  The code was initially
setup to only allocate it when we read a raid5/6 block group, but I ran
into trouble for the sys array.

Still, it should really be changed to only load the cache when we hit
raid5/6 goodness.

-chris
