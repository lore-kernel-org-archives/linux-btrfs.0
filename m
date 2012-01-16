From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Possible btrfs deadlock coused by commit 660d3f6c
Date: Mon, 16 Jan 2012 20:45:29 +0000
Message-ID: <20120116204528.GP23916@ZenIV.linux.org.uk>
References: <20120116085322.GB2105@redhat.com>
 <20120116142540.GB8265@dhcp231-144.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Patrick <ragamuffin@datacomm.ch>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120116142540.GB8265@dhcp231-144.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 16, 2012 at 09:26:00AM -0500, Josef Bacik wrote:
> On Mon, Jan 16, 2012 at 09:53:23AM +0100, Stanislaw Gruszka wrote:
> > Hi Josef,
> > 
> > commit 660d3f6cde552323578b85fc5a09a6742f1fe804
> > Author: Josef Bacik <josef@redhat.com>
> > Date:   Fri Dec 9 11:18:51 2011 -0500
> > 
> >     Btrfs: fix how we do delalloc reservations and how we free reservations on error
> > 
> > introduced possible deadlock. According to comment before
> > btrfs_page_mkwrite(), that function is not allowed to take
> > node->i_mutex .
> > 
> > The problem was detected by Patrick (full lockdep info is provided):
> > http://bugzilla.kernel.org/attachment.cgi?id=72072
> > during investigating of some other issue (kernel.org bug 42576)
> > 
> 
> It's not a deadlock since you can't mmap a directory, but I posted a fix for
> this to linux-btrfs last week, afaik it's headed to -rc1.  Thanks,

Sigh...  You know, I'm getting really annoyed with the "can't mmap a directory"
bogosity resurfacing every couple of months or so.  No, you can't mmap a
directory.  You also can't bugger a hedgehog, which is about as relevant.

What you *can* do is write(2) on a regular file.  Which will happily grab
->i_mutex (in case of btrfs, that's done in the beginning of
btrfs_file_aio_write()) and eventually get the user pages in (in case of
btrfs, iov_iter_fault_in_readable() from __btrfs_buffered_write() from
btrfs_file_aio_write()).  IOW, you do get pagefaults with ->i_mutex
held.  Which means ->mmap_sem grabbed while holding ->i_mutex.  No
directories involved...
