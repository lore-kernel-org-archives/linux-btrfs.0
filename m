From: Josef Bacik <jbacik@redhat.com>
Subject: Re: Question about e8569813849b5da394a195c7e76b4faa452b12d1
Date: Thu, 9 Oct 2008 06:49:12 -0400
Message-ID: <20081009104911.GA19500@unused.rdu.redhat.com>
References: <3d0408630810081847q205c1fe2q227e9e3c7b92fc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630810081847q205c1fe2q227e9e3c7b92fc2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 09, 2008 at 09:47:41AM +0800, Yan Zheng wrote:
> 2008/10/9 Josef Bacik <jbacik@redhat.com>:
> > Hello,
> >
> > Is there a reason
> >
> > -       if (search_end == (u64)-1)
> > -               search_end = btrfs_super_total_bytes(&info->super_copy);
> >
> > happened in the commit from $SUBJECT?  If its just a mistake thats fine I'll add
> > it back with my current patch, but if there is a reason it needed to go then I
> > need to know that too so I can figure out a different way to do what I want to
> > do.  Thanks,
> >
> 
> btrfs_super_total_bytes is total size of all devices. we can't rely on it as
> search_end for two reasons:
> 
> 1) If metadata mirror is enable, the value can be larger than the last byte of
>     last chunk.
> 
> 2) For a FS has been balanced, there are some 'holes' in the chunk address
>     space, so the value can be smaller than the last byte of last chunk.
>

Awesome thanks this is what I needed.  So here's my next question, we're hitting
ENOSPC before we're empty because of the way I currently lookup block groups in
find_free_extent, so I'm rewriting find_free_extent to lookup the
btrfs_space_info that we are looking to allocate out of, and just loop through
its list of block groups, starting at the one that the hint points to, until we
find what we need.  This way I can incorporate find_free_space into
find_free_extent and make the code a little easier to read.  Will this upset
what you are trying to do with the space balancing code?  Thanks,

Josef 
