From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Recovering data from disk with loose cable
Date: Fri, 11 Feb 2011 11:16:41 -0500
Message-ID: <87pqqyczrp.fsf@gmail.com>
References: <AANLkTinsT-FRkV0Ja63YCqCn2OWdZnYORxPFgKm4DxQW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinsT-FRkV0Ja63YCqCn2OWdZnYORxPFgKm4DxQW@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 9 Feb 2011 21:46:38 -0500, Ben Gamari <bgamari@gmail.com> wrote:
> We have a disk array behind two external SATA port multipliers (four
> disks on each multiplier) which has been running btrfs (RAID 1 for
> both data and metadata). Unfortunately, earlier today it seems one of
> the SATA cables came loose, resulting in the kernel (2.6.37)
> eventually OOPSing although apparently not before writing quite a bit
> of data. Upon reboot, I was met with the dreaded,
> 
>     disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
> 
> Unfortunately any attempt to run any of the btrfs-progs utilities
> (from git) met a similar end. There was recently a patch to try harder
> in recovering from this problem posted to the list[1], although
> unfortunately it is unable to find a root. Considering there are eight
> disks in the array and only four were affected by the loose cable, I
> find it very hard to believe there is no way to recover this volume.
> Any suggestions at all would be greatly appreciated. Recovering this
> data would mean a lot. Thanks,
> 
Given there has been no response to this, I suppose I should assume this
data is unrecoverable? It's not the end of the world if so, but again,
it would be nice to get a few files and it seems like a small subset of
the metadata is corrupted.

Cheers,

- Ben
