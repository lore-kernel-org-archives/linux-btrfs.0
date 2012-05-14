From: David Sterba <dave@jikos.cz>
Subject: Re: Create subvolume from a directory?
Date: Mon, 14 May 2012 14:36:31 +0200
Message-ID: <20120514123631.GI25501@twin.jikos.cz>
References: <loom.20120327T190041-268@post.gmane.org>
 <8026880.aVIK1HJLHr@bursa01>
 <20120502163337.GH6740@twin.jikos.cz>
 <18314084.XgMbhzHaqD@bursa01>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, Liu Bo <liubo2009@cn.fujitsu.com>,
	kreijack@inwind.it, "Matthias G. Eckermann" <mge@suse.com>,
	Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <18314084.XgMbhzHaqD@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 03, 2012 at 03:26:20PM +0200, Hubert Kario wrote:
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -2321,6 +2321,10 @@ static noinline long btrfs_ioctl_clone(struct file
> > *file, unsigned long srcfd, goto out_drop_write;
> >         }
> > 
> > +       ret = -EXDEV;
> > +       if (src_file->f_path.mnt != file->f_path.mnt)
> 
> I'm not sure about this comparision. Is the f_path struct member used just as 
> reference to some general kernel structure?

f_path is 'struct path' pointer obtained from a 'struct file' hence the
'f_' prefix, this is a naming scheme used in vfs.

Patch updated in my git repo (branch dev/cross-subvol-clone-v2).

david
