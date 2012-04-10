From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Tue, 10 Apr 2012 12:34:13 -0400
Message-ID: <1334075653.2758.9.camel@ayu>
References: <1333986823.2928.6.camel@ayu> <1333991404.2817.6.camel@ayu>
	 <20120409205429.GB6958@localhost.localdomain> <1334006446.2678.0.camel@ayu>
	 <20120410151645.GC2296@localhost.localdomain> <1334073840.2758.5.camel@ayu>
	 <20120410162914.GF11041@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410162914.GF11041@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-04-10 at 18:29 +0200, David Sterba wrote:
> On Tue, Apr 10, 2012 at 12:04:00PM -0400, Calvin Walton wrote:
> > On Tue, 2012-04-10 at 11:16 -0400, Josef Bacik wrote:
> > This one brings the mount time right down on my laptop, it's back to
> > around 0.5 seconds, same as 3.3.x.
> 
> Did you notice any change during umount?

That's hard to tell, given that it's the root filesystem on my laptop
(and the only btrfs filesystem on the computer). I don't think it added
very much, if any time to rebooting my computer - but that's a remount
read-only, not an unmount.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

