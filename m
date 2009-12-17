From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: set a compat flag when setting default subvol
Date: Thu, 17 Dec 2009 16:30:21 -0500
Message-ID: <20091217213021.GA2804@think>
References: <20091217214024.GC4122@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091217214024.GC4122@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 17, 2009 at 04:40:24PM -0500, Josef Bacik wrote:
> This is just to mark the fs that it's been tinkered with to set the default
> subvolume.  It's a compatible change because older kernels will just ignore the
> default setting and mount the same thing they always have.  Thanks,

I actually don't think this is a compatible change.  If someone mounts
under 2.6.33 and gets one filesystem, they will expect the same FS under
2.6.32.  We should make sure they get what they expect or a friendly
error message.

-chris
