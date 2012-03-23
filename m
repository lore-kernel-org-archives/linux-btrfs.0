From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 35/35] btrfs: disallow unequal data/metadata blocksize for mixed block groups
Date: Fri, 23 Mar 2012 18:13:45 +0100
Message-ID: <20120323171345.GA11610@twin.jikos.cz>
References: <20120322011104.212214639@suse.com> <20120322011137.923792033@suse.com> <4F6B4D10.3090709@giantdisaster.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Mahoney <jeffm@suse.com>,
	Linux Btrfs List <linux-btrfs@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F6B4D10.3090709@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2012 at 05:02:24PM +0100, Stefan Behrens wrote:
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2302,6 +2302,14 @@ int open_ctree(struct super_block *sb,
> >  		goto fail_sb_buffer;
> >  	}
> >  
> > +	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
> > +			(leafsize != nodesize && sectorsize != nodesize)) {
> 
> Dave, Shouldn't this be like this (you want all three sizes to be equal
> in mixed mode, don't you?):
> 	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
> 			(leafsize != nodesize || sectorsize != nodesize)) {

Yes, you're right, thanks for catching it.


david
