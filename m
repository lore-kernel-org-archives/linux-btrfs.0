Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3EJLUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 07:20:06 -0400
Date: Fri, 10 May 2013 13:20:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: image: handle superblocks correctly on fs
 with big blocks
Message-ID: <20130510112000.GJ16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367874680-9502-1-git-send-email-dsterba@suse.cz>
 <5188BED5.3040201@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5188BED5.3040201@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 07, 2013 at 10:44:05AM +0200, Stefan Behrens wrote:
> On Mon,  6 May 2013 23:11:20 +0200, David Sterba wrote:
> > Superblock is always 4k, but metadata blocks may be larger. We have to
> > use the appropriate block size when doing checksums, otherwise they're
> > wrong.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> >  btrfs-image.c | 27 +++++++++++++++++++++++----
> >  1 file changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/btrfs-image.c b/btrfs-image.c
> > index 188291c..dca7a28 100644
> > --- a/btrfs-image.c
> > +++ b/btrfs-image.c
> > @@ -469,6 +469,16 @@ static int read_data_extent(struct metadump_struct *md,
> >  	return 0;
> >  }
> >  
> > +static int is_sb_offset(u64 offset) {
> > +	switch (offset) {
> > +		case 65536:
> > +		case 67108864:
> > +		case 274877906944:
> 
> Using btrfs_sb_offset() and an if statement would produce the same code
> and would be more readable.

It was there originally, but this function is called for each block and
I've optimized it a bit right away. I'll add a comment.

> Additionally, the last huge number will cause a warning on 32-bit
> systems, I assume.

No warning with -m32 -Wall.

david
