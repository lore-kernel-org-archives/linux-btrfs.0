From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH] Btrfs: add discard flag to btrfs_device and make btrfs_discard_extent aware of that
Date: Fri, 10 Jun 2011 13:40:31 +0800
Message-ID: <201106101340.31230.lidongyang@novell.com>
References: <1307604489-7884-1-git-send-email-lidongyang@novell.com> <20110610000017.GP12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110610000017.GP12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, June 10, 2011 08:00:17 AM David Sterba wrote:
> On Thu, Jun 09, 2011 at 03:28:09PM +0800, Li Dongyang wrote:
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -45,6 +45,7 @@ struct btrfs_device {
> >  	int running_pending;
> >  	u64 generation;
> >  
> > +	int discard;
> 
> can you pick a better name? this does not describe that it's the
> capability of the device, but rather 'do a discard'.
I feel the same, I picked the name because there was btrfs_device->barriers,
and it was removed in commit c3b9a62c8f932f32a733d6b628f61f3f28345727
> 
> something like has_discard, can_discard, has_trim, etc
> 
> >  	int writeable;
> >  	int in_fs_metadata;
> >  	int missing;
> 
> otherwise the patch looks good (and matches my view how to do it). I
> will test it eventually.
Thanks a lot, I'll resend this this a proper name.
> 
> 
> david
> 
