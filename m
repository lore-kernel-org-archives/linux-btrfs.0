Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbcGOPib (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 11:38:31 -0400
Date: Fri, 15 Jul 2016 17:38:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH v3] Btrfs: fix unexpected balance crash due to BUG_ON
Message-ID: <20160715153834.GA1293@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468257695-22445-1-git-send-email-bo.li.liu@oracle.com>
 <1468347861-16930-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468347861-16930-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 11:24:21AM -0700, Liu Bo wrote:
> Mounting a btrfs can resume previous balance operations asynchronously.
> An user got a crash when one drive has some corrupt sectors.
> 
> Since balance can cancel itself in case of any error, we can gracefully
> return errors to upper layers and let balance do the cancel job.
> 
> Reported-by: sash <master.b.at.raven@chefmail.de>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
