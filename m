Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33663 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab3CFOHK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 09:07:10 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EA1389A03E9
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2013 07:07:09 -0700 (MST)
Date: Wed, 6 Mar 2013 09:07:07 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH RFC] Btrfs: improve delalloc reservation
Message-ID: <20130306140707.GA1905@localhost.localdomain>
References: <1362567669-16477-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1362567669-16477-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 04:01:09AM -0700, Liu Bo wrote:
> Although we already have over commit stuff, btrfs write performance
> still suffers from over reservation a lot.
> 

I'm getting ready to rip all of the reservation code out and put in a ENOSPC log
for a buffer area for delalloc writes and anything outstanding when we run out
of space.  This will give us the performance numbers we want and be ENOSPC safe,
we'll stop having early enospc issues and we'll never actually run out of space.
Thanks,

Josef
