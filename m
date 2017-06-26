Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46828 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750799AbdFZOh0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:37:26 -0400
Date: Mon, 26 Jun 2017 16:36:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Henk Slager <eye1tm@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: Fix false alert about EXTENT_DATA
 shouldn't be hole
Message-ID: <20170626143615.GL2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170616014323.13170-1-quwenruo@cn.fujitsu.com>
 <1a0c4fe6-517a-49f3-2873-61797bc9d818@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1a0c4fe6-517a-49f3-2873-61797bc9d818@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 19, 2017 at 01:26:20PM +0200, Henk Slager wrote:
> On 16-06-17 03:43, Qu Wenruo wrote:
> > Since incompat feature NO_HOLES still allow us to have explicit hole
> > file extent, current check is too restrict and will cause false alert
> > like:
> >
> > root 5 EXTENT_DATA[257, 0] shouldn't be hole
> >
> > Fix it by removing the restrict hole file extent check.
> >
> > Reported-by: Henk Slager <eye1tm@gmail.com>
> > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > ---
> >  cmds-check.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/cmds-check.c b/cmds-check.c
> > index c052f66e..7bd57677 100644
> > --- a/cmds-check.c
> > +++ b/cmds-check.c
> > @@ -4841,11 +4841,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
> >  	}
> >  
> >  	/* Check EXTENT_DATA hole */
> > -	if (no_holes && is_hole) {
> > -		err |= FILE_EXTENT_ERROR;
> > -		error("root %llu EXTENT_DATA[%llu %llu] shouldn't be hole",
> > -		      root->objectid, fkey->objectid, fkey->offset);
> > -	} else if (!no_holes && *end != fkey->offset) {
> > +	if (!no_holes && *end != fkey->offset) {
> >  		err |= FILE_EXTENT_ERROR;
> >  		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
> >  		      root->objectid, fkey->objectid, fkey->offset);
> 
> 
> Thanks for the patch, I applied it on v4.11 btrfs-progs and re-ran the check:
> # btrfs check -p --readonly /dev/mapper/smr
> 
> on filesystem mentioned in:
> https://www.spinics.net/lists/linux-btrfs/msg66374.html
> 
> and now the "shouldn't be hole" errors don't show up anymore.
> 
> Tested-by: Henk Slager <eye1tm@gmail.com>

Thank you both, patch applied. I might also release a 4.11.x release
with this fix included.
