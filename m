Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbcEJPqv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 11:46:51 -0400
Date: Tue, 10 May 2016 17:46:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com, dsterba@suse.com
Subject: Re: [PATCH 1/3] Btrfs-progs: add validation checks for chunk loading
Message-ID: <20160510154629.GW29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 11:18:53AM -0700, Liu Bo wrote:
> To survive fuzz filesystem images, we need various validation checks to
> make btrfsck detect any invalid value inside chunks including those in
>  sys_array.
> 
> Note that these checks may not be sufficient to cover all corner cases,
> we may need to add more later.
> 
> This also refractor previous various checks into a helper function so
> that we can add more checks into it in the future.
> 
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Patches added to integration, I yet have to go through the checks, but
from a quick look it seems ok.
