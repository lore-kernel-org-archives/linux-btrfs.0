From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] btrfs: allow scanning multiple devices during
	mount
Date: Tue, 10 Jun 2008 10:47:08 -0400
Message-ID: <1213109228.10187.194.camel@think.oraclecorp.com>
References: <20080610132352.GA1852@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080610132352.GA1852@lst.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-06-10 at 15:23 +0200, Christoph Hellwig wrote:
> Allows to specify one or multiple device=/dev/foo options during mount
> so that ioctls on the control device can be avoided.  Especially useful
> when trying to mount a multi-device setup as root.
> 

Thanks, these look good.  I'm trying some basic tests and I'll push to
the unstable tree shortly.

-chris


