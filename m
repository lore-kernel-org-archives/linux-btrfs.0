From: Mike Hommey <mh@glandium.org>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 15:50:03 +0100
Message-ID: <20101201145003.GA28820@glandium.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 09:21:36AM -0500, Josef Bacik wrote:
> 1) Users need to be able to create their own subvolumes.  The permission
> semantics will be absolutely the same as creating directories, so I don't think
> this is too tricky.  We want this because you can only take snapshots of
> subvolumes, and so it is important that users be able to create their own
> discrete snapshottable targets.
> 
> 2) Users need to be able to snapshot their subvolumes.  This is basically the
> same as #1, but it bears repeating.
> 
> 3) Subvolumes shouldn't need to be specifically mounted.  This is also
> important, we don't want users to have to go around mounting their subvolumes up
> manually one-by-one.  Today users just cd into subvolumes and it works, just
> like cd'ing into a directory.

It would be helpful to be able to create subvolumes off existing
directories, instead of creating a subvolume and having to copy all the
data around.

Mike
