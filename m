From: Arne Jansen <sensille@gmx.net>
Subject: Re: What to do about subvolumes?
Date: Thu, 02 Dec 2010 10:26:40 +0100
Message-ID: <4CF76650.3090205@gmx.net>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> 
> This is a huge topic in and of itself, but Christoph mentioned wanting to have
> an idea of what we wanted to do with it, so I'm putting it here.  There are
> really 2 things here
> 
> 1) Limiting the size of subvolumes.  This is really easy for us, just create a
> subvolume and at creation time set a maximum size it can grow to and not let it
> go farther than that.  Nice, simple and straightforward.
> 

I'd love to be able to limit the size of a subvolume. Here the size comprises
all blocks this subvolume refers to.
But at least as important to me is a mode where one can build groups of sub-
volumes and snapshots and define a quota for the complete group. Again, the
size here comprises all blocks any of the subvolumes/snapshots refer to. If
a block is referred to more than once, it counts only once.
A subvolume/snapshot can be configured to be part of multiple groups.

With this I can do interesting things:
 a) The user pays only for the space he occupies, not for read-only snapshots
 b) The user pays for his space and for all the snapshots
 c) The user pays for his space and snapshots, but not for snapshots generated
    for internal backup purposes
 d) Hierarchical quotas. I can limit /home and set an additional quota on each
    homedir

Thanks,
Arne
