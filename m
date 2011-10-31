From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: introduce mount option no_space_cache
Date: Tue, 1 Nov 2011 00:42:55 +0100
Message-ID: <20111031234255.GA12759@twin.jikos.cz>
References: <1317665561-8114-1-git-send-email-josef@redhat.com> <20111003215130.GN22205@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111003215130.GN22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Mon, Oct 03, 2011 at 11:51:30PM +0200, David Sterba wrote:
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -164,7 +164,7 @@ enum {
> >  	Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
> >  	Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
> >  	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag,
> > -	Opt_inode_cache, Opt_err,
> > +	Opt_inode_cache, Opt_no_space_cache, Opt_err,
> 
> how about _not_ adding a new optoin and just extend the existing one:
> 
> space_cache=off

Thanks for fixing the patch in your tree, however adding the 'no' prefix
seems more in line with other options and their disabling counterparts
(like ssd/nossd, more to come).

I would have asked you to consider changing it to 'nospace_cache' and
refreshing the patch, but it's deep inside your for-chris branch so I'll
rather send patch if there aren't objections voiced.


thanks,
david
