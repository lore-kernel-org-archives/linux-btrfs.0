From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
 to a filesystem
Date: Tue, 28 Sep 2010 19:25:13 -0400
Message-ID: <20100928232513.GA20629@infradead.org>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1285707196-16268-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 28, 2010 at 04:53:16PM -0400, Josef Bacik wrote:
> This was a request from the systemd guys.  They need a quick and easy way to get
> all devices attached to a Btrfs filesystem in order to check if any of the disks
> are SSD for...something, I didn't ask :).   I've tested this with the
> btrfs-progs patch that accompanies this patch.  Thanks,

So please tell the "systemd guys" to explain what the fuck they're doing
to linux-fsdevel and fiend a proper interface.  Chance is they will fuck
up as much as just about ever other lowlevel userspace tool are very
high.

