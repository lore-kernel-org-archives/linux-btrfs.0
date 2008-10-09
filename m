From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Question about e8569813849b5da394a195c7e76b4faa452b12d1
Date: Wed, 08 Oct 2008 20:14:17 -0400
Message-ID: <1223511257.7014.41.camel@think.oraclecorp.com>
References: <20081008205947.GA18375@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081008205947.GA18375@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-08 at 16:59 -0400, Josef Bacik wrote:
> Hello,
> 
> Is there a reason 
> 
> -       if (search_end == (u64)-1)
> -               search_end = btrfs_super_total_bytes(&info->super_copy);
> 
> happened in the commit from $SUBJECT?  If its just a mistake thats fine I'll add
> it back with my current patch, but if there is a reason it needed to go then I
> need to know that too so I can figure out a different way to do what I want to
> do.  Thanks,

Yan removed this as part of the prep code for space balancing.  It is
probably because he needs to change btrfs_super_total_bytes and we can't
rely on it as search_end anymore.

-chris


