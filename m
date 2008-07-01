From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] NFS Support
Date: Tue, 1 Jul 2008 03:01:56 -0400
Message-ID: <20080701070156.GA26299@infradead.org>
References: <200806290505.31641.balajirrao@gmail.com> <20080630145002.GA18866@unused.rdu.redhat.com> <569c97d20806300820p1e6f3b9eha359f93ea41c6705@mail.gmail.com> <20080630150811.GB18866@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Balaji Rao R <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080630150811.GB18866@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 30, 2008 at 11:08:11AM -0400, Josef Bacik wrote:
> > >>
> > >>               spin_unlock(&dentry->d_lock);
> > >>
> > >>               len += 3;
> > >
> > > there is no need to take the d_lock here.
> > OK. Will remove it. It was done at fs/ocfs2/export.c. So probably i
> > thought it was necessary.
> > 
> > <snip>
> >
> 
> Ahh see this is where me not being familiar with NFS gets me in trouble, you do
> need the d_lock in that case.  Sorry about that.

It's not really about nfs, dereferencing ->d_parent needs d_lock.

