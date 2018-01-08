Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44145 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933223AbeAHTyA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 14:54:00 -0500
Date: Mon, 8 Jan 2018 20:51:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        wqu@suse.com
Subject: Re: [PATCH 2/3] btrfs: define SUPER_FLAG_METADUMP_V2
Message-ID: <20180108195152.GN13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180108080421.17668-1-anand.jain@oracle.com>
 <20180108080421.17668-3-anand.jain@oracle.com>
 <54854609-4a25-2b8b-3bab-ab18c1a14071@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54854609-4a25-2b8b-3bab-ab18c1a14071@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 08, 2018 at 04:20:58PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年01月08日 16:04, Anand Jain wrote:
> > btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 34).
> > So just define that in kernel so that we know its been used. This patch
> > does not add it to BTRFS_SUPER_FLAG_SUPP yet.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> >  include/uapi/linux/btrfs_tree.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> > index 6d6e5da51527..38ab0e06259a 100644
> > --- a/include/uapi/linux/btrfs_tree.h
> > +++ b/include/uapi/linux/btrfs_tree.h
> > @@ -456,6 +456,7 @@ struct btrfs_free_space_header {
> >  
> >  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
> >  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
> > +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
> 
> Please also include this to BTRFS_SUPER_FLAG_SUPP.
> 
> It's quite common developers (at least myself) may try to mount a
> recovered btrfs image.
> 
> (That's also the reason why the patch should be put before the
> BTRFS_SUPER_FLAG_SUPP check patch)

Agreed.
