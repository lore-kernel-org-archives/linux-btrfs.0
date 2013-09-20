Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43996 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3ITAWq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 20:22:46 -0400
Date: Fri, 20 Sep 2013 08:22:30 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jeff.liu@oracle.com
Subject: Re: [PATCH] Btrfs: export btrfs space shared info to userspace
Message-ID: <20130920002229.GA19110@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1379317212-20246-1-git-send-email-bo.li.liu@oracle.com>
 <20130918205304.GA1615@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130918205304.GA1615@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 04:53:04PM -0400, Josef Bacik wrote:
> On Mon, Sep 16, 2013 at 03:40:12PM +0800, Liu Bo wrote:
> > Similar to ocfs2, btrfs also supports that extents can be shared by
> > different inodes, and there are some userspace tools requesting
> > for this kind of 'space shared infomation'.[1]
> > 
> > ocfs2 uses flag FIEMAP_EXTENT_SHARED, so does btrfs.
> > 
> > [1]: http://thr3ads.net/ocfs2-devel/2010/09/489052-PATCH-3-3-shared-du-using-fiemap-to-figure-up-the-shared-extents-per-file-and-the-footprint-in
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> > RFC->PATCH: use type 'unsigned long' instead of 'int', as David suggested.
> 
> This broke any xfstest that used fiemap, so generic/255, generic/316 and
> shared/218.  Thanks,

I'll look into it ASAP, thanks, Josef.

-liubo
