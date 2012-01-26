From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 12/12] Btrfs: Fix file clone when source offset is not 0
Date: Thu, 26 Jan 2012 17:17:45 +0100
Message-ID: <20120126161745.GM7322@twin.jikos.cz>
References: <4D412FE6.7050101@cn.fujitsu.com> <4D4130D4.2000001@cn.fujitsu.com> <4F215AA0.8040505@jan-o-sch.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F215AA0.8040505@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 26, 2012 at 02:52:32PM +0100, Jan Schmidt wrote:
> I was looking at the clone range ioctl and have some remarks:
> 
> On 27.01.2011 09:46, Li Zefan wrote:
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index f87552a..1b61dab 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -1788,7 +1788,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
> >  
> >  			memcpy(&new_key, &key, sizeof(new_key));
> >  			new_key.objectid = inode->i_ino;
> > -			new_key.offset = key.offset + destoff - off;
> > +			if (off <= key.offset)
> > +				new_key.offset = key.offset + destoff - off;
> > +			else
> > +				new_key.offset = destoff;
> 						 ^^^^^^^
> 1) This looks spurious to me. What if destoff isn't aligned? That's what
> the "key.offset - off" code above is for. Before the patch, the code
> didn't work at all, I agree. But this fix can only work for aligned
> requests.

Source range and destination offset are accepted iff are aligned:

2300         /* verify the end result is block aligned */
2301         if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs) ||
2302             !IS_ALIGNED(destoff, bs))
2303                 goto out_unlock;


david
