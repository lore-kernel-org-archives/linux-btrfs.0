Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59155 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3CPOfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 10:35:45 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 313BB7C04E9
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 08:35:45 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1363358799-17991-1-git-send-email-bo.li.liu@oracle.com>
CC: "johannes.hirte@fem.tu-ilmenau.de" <johannes.hirte@fem.tu-ilmenau.de>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
References: <1363358799-17991-1-git-send-email-bo.li.liu@oracle.com>
Message-ID: <20130316143543.5385.43571@localhost.localdomain>
Subject: Re: [PATCH] Btrfs: fix warning of free_extent_map
Date: Sat, 16 Mar 2013 10:35:43 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Liu Bo (2013-03-15 10:46:39)
> Users report that an extent map's list is still linked when it's actually
> going to be freed from cache.
> 
> The story is that
> 
> a) when we're going to drop an extent map and may split this large one into
> smaller ems, and if this large one is flagged as EXTENT_FLAG_LOGGING which means
> that it's on the list to be logged, then the smaller ems split from it will also
> be flagged as EXTENT_FLAG_LOGGING, and this is _not_ expected.
> 
> b) we'll keep ems from unlinking the list and freeing when they are flagged with
> EXTENT_FLAG_LOGGING, because the log code holds one reference.
> 
> The end result is the warning, but the truth is that we set the flag
> EXTENT_FLAG_LOGGING only during fsync.
> 
> So clear flag EXTENT_FLAG_LOGGING for extent maps split from a large one.

Thanks for tracking this down!  I've got it in my tree now.

-chris
