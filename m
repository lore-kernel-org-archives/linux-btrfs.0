Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56375 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab3HWSdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 14:33:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 253FD7C0431
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:33:40 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:33:38 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstest: fix btrfs/006 for 10+ devices in
 SCRATCH_DEV_POOL
Message-ID: <20130823183338.GF29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
 <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1377263233-8903-4-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 23, 2013 at 03:07:13PM +0200, Stefan Behrens wrote:
> One problem was the output of "uniq -c" which added spaces depending
> on the size of the count value (e.g. one space less for 10+ devices).
> 
> The second problem was that "btrfs fi show" was doing the same:
> "devid %4llu size %s used %s path %s".
> 

Got 11 devices together and this works

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
