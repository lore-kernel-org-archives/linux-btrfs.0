From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Separate mount options for subvolumes?
Date: Tue, 15 Sep 2009 09:44:43 -0400
Message-ID: <20090915134443.GV8839@think>
References: <615c05430909141255s614702deu44e42bbb7f7cd169@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs list <linux-btrfs@vger.kernel.org>
To: Michel Alexandre Salim <michael.silvanus@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <615c05430909141255s614702deu44e42bbb7f7cd169@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2009 at 03:55:39PM -0400, Michel Alexandre Salim wrote:
> Hello,
> 
> It is my understanding that currently, the only difference between
> subvolumes and snapshots are that snapshots share a root with an
> existing tree, while subvolumes start off empty.
> 
> There is an interesting use case difference, though: because a
> subvolume by definition cannot share data with other subvolumes, that
> frees it up to being mounted with different options (e.g. nodatasum,
> nodatacow).
> 
> The reason I'm wondering is that I just switched my home directory to
> btrfs, and one of my machine is often used for rebuilding RPMs (for
> initial testing, before getting it built on a build server). The data
> is never kept for a long time, and so checksumming and COW would just
> slow things down.
> 
> Would this be possible, and if so, is it planned for implementation by 1.0?

It would be possible, and long term we plan on storing a number of
options directly in the root so that you don't have to keep doing mount
-o foo.

-chris
