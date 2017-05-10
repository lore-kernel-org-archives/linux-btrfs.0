Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47485 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752997AbdEJPLD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 11:11:03 -0400
Date: Wed, 10 May 2017 17:10:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Colin King <colin.king@canonical.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix incorrect error return ret being passed to
 mapping_set_error
Message-ID: <20170510151053.GA27439@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170509171401.4641-1-colin.king@canonical.com>
 <20170509185855.GB17312@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170509185855.GB17312@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 11:58:55AM -0700, Liu Bo wrote:
> On Tue, May 09, 2017 at 06:14:01PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The setting of return code ret should be based on the error code
> > passed into function end_extent_writepage and not on ret. Thanks
> > to Liu Bo for spotting this mistake in the original fix I submitted.
> > 
> > Detected by CoverityScan, CID#1414312 ("Logically dead code")
> 
> Looks good.
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks, patch replaced.
