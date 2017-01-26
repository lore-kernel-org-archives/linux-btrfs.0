Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44027 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753249AbdAZTWu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 14:22:50 -0500
From: Caitlyn Mason <caitmase@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>
CC: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix wrong argument for btrfs_lookup_ordered_range
Date: Thu, 26 Jan 2017 17:49:19 +0000
Message-ID: <E49E4998-0065-4EDA-A521-5322073945E1@fb.com>
References: <1485302331-20167-1-git-send-email-bo.li.liu@oracle.com>
 <10463170.nZChnp8t2y@localhost.localdomain>
 <20170125150618.GA25499@dhcp-amer-vpn-adc-anyconnect-10-154-187-238.vpn.oracle.com>
 <20170126172807.GH11951@twin.jikos.cz>
In-Reply-To: <20170126172807.GH11951@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I donâ€™t think Iâ€™m supposed to be on this thread â€“ please move me to bcc! â˜º 

-- 
caitlyn mason
Facebook | University Programs
M: (508) 963-6209
E: caitmase@fb.com
 

 
 facebook.com/careers
 

On 1/26/17, 9:28 AM, "David Sterba" <dsterba@suse.cz> wrote:

    On Wed, Jan 25, 2017 at 07:06:18AM -0800, Liu Bo wrote:
    > On Wed, Jan 25, 2017 at 01:49:09PM +0530, Chandan Rajendra wrote:
    > > On Tuesday, January 24, 2017 03:58:51 PM Liu Bo wrote:
    > > > Commit "d0b7da88 Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units"
    > > > did this, but btrfs_lookup_ordered_range expects a 'length' rather than a
    > > > 'page_end'.
    > > > 
    > > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
    > > > ---
    > > > Is this a candidate for stable?
    > > > 
    > > >  fs/btrfs/inode.c | 2 +-
    > > >  1 file changed, 1 insertion(+), 1 deletion(-)
    > > > 
    > > > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
    > > > index 4e02426..366cf0b 100644
    > > > --- a/fs/btrfs/inode.c
    > > > +++ b/fs/btrfs/inode.c
    > > > @@ -9023,7 +9023,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
    > > >  	 * we can't set the delalloc bits if there are pending ordered
    > > >  	 * extents.  Drop our locks and wait for them to finish
    > > >  	 */
    > > > -	ordered = btrfs_lookup_ordered_range(inode, page_start, page_end);
    > > > +	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
    > > >  	if (ordered) {
    > > >  		unlock_extent_cached(io_tree, page_start, page_end,
    > > >  				     &cached_state, GFP_NOFS);
    > > > 
    > > 
    > > Thanks for fixing this,
    > > Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
    > > 
    > > As for the question about whether this commit should be merged into the stable
    > > trees ... I am not sure about that since I don't notice any sort of filesystem
    > > corruption that can be caused by the current code i.e. With the existing code,
    > > apart from any ordered extents that map the page in question, we are most
    > > likely to be *unnecessarily* starting i/o on ordered extents that don't map
    > > the file offset range covered by the page. Chris, Josef or David, Please let
    > > us know your thoughts on this.
    > 
    > It could be a performance regression which causes fault writes have
    > unnecessary waits instead of a real corruption.
    
    Does not seem to be urgent for stable, but I'll consider it next time
    doing a stable round updates.
    

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
