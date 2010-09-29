From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
 	to a filesystem
Date: Wed, 29 Sep 2010 02:19:54 +0200
Message-ID: <20100929001954.GA9182@tango.0pointer.de>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org>
 <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 28.09.10 20:08, Josef Bacik (josef@redhat.com) wrote:

> 
> On Tue, Sep 28, 2010 at 07:25:13PM -0400, Christoph Hellwig wrote:
> > On Tue, Sep 28, 2010 at 04:53:16PM -0400, Josef Bacik wrote:
> > > This was a request from the systemd guys.  They need a quick and easy way to get
> > > all devices attached to a Btrfs filesystem in order to check if any of the disks
> > > are SSD for...something, I didn't ask :).   I've tested this with the
> > > btrfs-progs patch that accompanies this patch.  Thanks,
> > 
> > So please tell the "systemd guys" to explain what the fuck they're doing
> > to linux-fsdevel and fiend a proper interface.  Chance is they will fuck
> > up as much as just about ever other lowlevel userspace tool are very
> > high.
> > 
> 
> Lennart? :).  And Christoph, what would be a good interface?  LVM has a slaves/
> subdir in sysfs which symlinks to all of their dev's, would you rather I
> resurrect the sysfs stuff for Btrfs and do a similar thing?  I'm open to
> suggestions, I just took the quick and painless way out.  Thanks,

When doing readahead you want to know whether you are on SSD or rotating
media, because you a) want to order the readahead requests on bootup
after access time on SSD and after location on disk on rotating
media. And b) because you might want to priorize readahead reads over
other reads on rotating media, but prefer other reads over readahead
reads on SSD.

This in fact is how all current readahead implementations work, be it
the fedora, the suse or ubuntu's readahead or Arjan's sreadahead. What's
new is that in the systemd case we try to test for ssd/rotating
properly, instead of just hardcoding a check for
/sys/class/block/sda/queue/rotational.

I hope this explains what the fuck we are doing.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
