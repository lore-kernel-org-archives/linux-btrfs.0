From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 3/4] change how subvolumes are organized
Date: Mon, 21 Sep 2009 17:01:22 -0400
Message-ID: <20090921210122.GF10825@think>
References: <4AB37AAF.5040508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB37AAF.5040508@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 18, 2009 at 08:18:55PM +0800, Yan, Zheng wrote:
> btrfs allows subvolumes and snapshots anywhere in the directory tree.
> If we snapshot a subvolume that contains a link to other subvolume
> called subvolA, subvolA can be accessed through both the original
> subvolume and the snapshot. This is similar to creating hard link to
> directory, and has the very similar problems.
> 
> The aim of this patch is enforcing there is only one access point to
> each subvolume. Only the first directory entry (the one added when
> the subvolume/snapshot was created) is treated as valid access point.
> The first directory entry is distinguished by checking root forward
> reference. If the corresponding root forward reference is missing,
> we know the entry is not the first one.

This is a good compromise between wanting all the features and something
maintainable.  I like how it closes the directory looping and a bunch of
the related problems.

Pretty much all of the things I don't like about this approach can be
solved with a recursive snapshotting ioctl, and that can easily be added
later.

Fantastic, thank you!

-chris
