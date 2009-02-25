From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs: introduce btrfs_show_options
Date: Wed, 25 Feb 2009 15:05:48 -0500
Message-ID: <1235592348.32346.67.camel@think.oraclecorp.com>
References: <1235515716.10158.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235515716.10158.1.camel@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-24 at 17:48 -0500, Eric Paris wrote:
> btrfs options can change at times other than mount, yet /proc/mounts shows the
> options string used when the fs was mounted (an example would be when btrfs
> determines that barriers aren't useful and turns them off.)  This patch
> instead outputs the actual options in use by btrfs.
> 

Nice, thanks

-chris


