Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60674 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3I0Npq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 09:45:46 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 80CB19A069F
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 07:45:46 -0600 (MDT)
Date: Fri, 27 Sep 2013 09:45:44 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests/btrfs: do not test btrfs/010 with autodefrag
Message-ID: <20130927134544.GI18681@localhost.localdomain>
References: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 01:17:55PM +0800, Liu Bo wrote:
> btrfs/010 is going to create a fragmented file, however, with autodefrag
> this is impossible, so just skip the test when we're with autodefrag.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I'd rather you just strip out the autodefrag option if it is there and add it
back once the test is done (or hell just remove it, mount, and add it back).
Thanks,

Josef
