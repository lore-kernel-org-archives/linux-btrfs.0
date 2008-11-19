From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] fix free space accounting when unpinning extents
Date: Wed, 19 Nov 2008 15:49:34 -0500
Message-ID: <1227127774.21259.1.camel@think.oraclecorp.com>
References: <20081119195652.GD16041@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, lt73@cs.drexel.edu
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081119195652.GD16041@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-11-19 at 14:56 -0500, Josef Bacik wrote:
> Hello,
> 
> This patch fixes what I hope is the last early ENOSPC bug left.  I did not know
> that pinned extents would merge into one big extent when inserted on to the
> pinned extent tree, so I was adding free space to a block group that could
> possibly span multiple block groups. 

Ok, I've pushed this out, along with my fixes for mount -o ro.

-chris


