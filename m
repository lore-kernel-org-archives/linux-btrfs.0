From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
	to a filesystem
Date: Tue, 28 Sep 2010 20:08:10 -0400
Message-ID: <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com> <20100928232513.GA20629@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	mzerqung@0pointer.de
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100928232513.GA20629@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 28, 2010 at 07:25:13PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 28, 2010 at 04:53:16PM -0400, Josef Bacik wrote:
> > This was a request from the systemd guys.  They need a quick and easy way to get
> > all devices attached to a Btrfs filesystem in order to check if any of the disks
> > are SSD for...something, I didn't ask :).   I've tested this with the
> > btrfs-progs patch that accompanies this patch.  Thanks,
> 
> So please tell the "systemd guys" to explain what the fuck they're doing
> to linux-fsdevel and fiend a proper interface.  Chance is they will fuck
> up as much as just about ever other lowlevel userspace tool are very
> high.
> 

Lennart? :).  And Christoph, what would be a good interface?  LVM has a slaves/
subdir in sysfs which symlinks to all of their dev's, would you rather I
resurrect the sysfs stuff for Btrfs and do a similar thing?  I'm open to
suggestions, I just took the quick and painless way out.  Thanks,

Josef
