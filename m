Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbeCIQVP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 11:21:15 -0500
Date: Fri, 9 Mar 2018 17:18:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs-progs: check/lowmem: Fix the incorrect
 error message of check_extent_data_item
Message-ID: <20180309161852.GX23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
 <b96bc384-c98f-0351-7c0e-8e7326c92f00@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b96bc384-c98f-0351-7c0e-8e7326c92f00@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 04:13:27PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年02月28日 18:13, Lu Fengqi wrote:
> > Instead of the disk_bytenr and disk_num_bytes of the extent_item which the
> > file extent references, we should output the objectid and offset of the
> > file extent. And the leaf may be shared by the file trees, we should print
> > the objectid of the root and the owner of the leaf.
> > 
> > Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check data backref in extent tree")
> > Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> > ---
> > V2: Output the objectid of the root and the owner of the leaf.
> > 
> >  check/mode-lowmem.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> > index 62bcf3d2e126..f37b1b2c1571 100644
> > --- a/check/mode-lowmem.c
> > +++ b/check/mode-lowmem.c
> > @@ -2631,9 +2631,9 @@ static int check_extent_data_item(struct btrfs_root *root,
> >  
> >  	if (!(extent_flags & BTRFS_EXTENT_FLAG_DATA)) {
> >  		error(
> > -		    "extent[%llu %llu] backref type mismatch, wanted bit: %llx",
> > -		    disk_bytenr, disk_num_bytes,
> > -		    BTRFS_EXTENT_FLAG_DATA);
> > +"file extent[%llu %llu] root %llu owner %llu backref type mismatch, wanted bit: %llx",
> > +			fi_key.objectid, fi_key.offset, root->objectid, owner,
> 
> Indeed this is much easier to identify the problem.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

1-3 applied, thanks.
