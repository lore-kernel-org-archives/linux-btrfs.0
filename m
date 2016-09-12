Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933264AbcILO3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:29:03 -0400
Date: Mon, 12 Sep 2016 16:27:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Waxhead <waxhead@online.no>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Message-ID: <20160912142714.GE16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57D51BF9.2010907@online.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57D51BF9.2010907@online.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

first, thanks for choosing a catchy subject, this always helps. While it
will serve as another beating stick to those who enjoy bashing btrfs,
I'm glad to see people answer in a constructive way.

On Sun, Sep 11, 2016 at 10:55:21AM +0200, Waxhead wrote:
> I have been following BTRFS for years and have recently been starting to 
> use BTRFS more and more and as always BTRFS' stability is a hot topic.
> Some says that BTRFS is a dead end research project while others claim 
> the opposite.

I take the 'research' part, as it's still possible to implement features
that were not expected years ago, but not a research in the sense "will
shadowing and clones approach to b-trees work?", ie. the original paper
by Ohad Rodeh from 2007.  That we can still add various metadata and
structures to the same underlying format proves that the design is sound
and flexible, building on the same primitives, only extending the
logical structure.

But I'm sure you'll find people who still claim that btrfs is broken by
design, because they heared somebody say that [1].

> Taking a quick glance at the wiki does not say much about what is safe 
> to use or not and it also points to some who are using BTRFS in production.
> While BTRFS can apparently work well in production it does have some 
> caveats, and finding out what features is safe or not can be problematic 
> and I especially think that new users of BTRFS can easily be bitten if 
> they do not do a lot of research on it first.

That's a valid point, the wiki lacks that, the usrespace tools do not
warn or prevent before using features deemed unsafe. In the enterprise
SLES kernel we can afford to draw a line where the support from our side
ends, regardless of the upstream status of the features. Doing that in
the upstream kernel is a bit different, the release and update schedules
are not the same, code is not selectively backported etc.

> The Debian wiki for BTRFS (which is recent by the way) contains a bunch 
> of warnings and recommendations and is for me a bit better than the 
> official BTRFS wiki when it comes to how to decide what features to use.

The 'wiki problem' is real, for too long people went to distro wikis for
generic information, so even if our k.org wiki is up to date, it's not
the primary source anyway. Changing that back is a long-term goal.

> The Nouveau graphics driver have a nice feature matrix on it's webpage 
> and I think that BTRFS perhaps should consider doing something like that 
> on it's official wiki as well
> 
> For example something along the lines of .... (the statuses are taken 
> our of thin air just for demonstration purposes)
> 
> Kernel version 4.7
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> | Feature / Redundancy level | Single | Dup | Raid0 | Raid1 | Raid10 | 
> Raid5 | Raid 6 |
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> | Subvolumes                 | Ok     | Ok  | Ok    | Ok    | Ok   | Bad 
>    | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> | Snapshots                  | Ok     | Ok  | Ok    | Ok    | Ok     | 
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> | LZO Compression            | Bad(1) | Bad | Bad   | Bad(2)| Bad    | 
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> | ZLIB Compression           | Ok     | Ok  | Ok    | Ok    | Ok     | 
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> | Autodefrag                 | Ok     | Bad | Bad(3)| Ok    | Ok     | 
> Bad   | Bad    |
> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
> 
> (1) Some explanation here...
> (2) Some explanation there....
> (3) And some explanation elsewhere...
> 
> ...etc...etc...
> 
> I therefore would like to propose that some sort of feature / stability 
> matrix for the latest kernel is added to the wiki preferably somewhere 
> where it is easy to find. It would be nice to archive old matrix'es as 
> well in case someone runs on a bit older kernel (we who use Debian tend 
> to like older kernels). In my opinion it would make things bit easier 
> and perhaps a bit less scary too. Remember if you get bitten badly once 
> you tend to stay away from from it all just in case, if you on the other 
> hand know what bites you can safely pet the fluffy end instead :)

Somebody has put that table on the wiki, so it's a good starting point.
I'm not sure we can fit everything into one table, some combinations do
not bring new information and we'd need n-dimensional matrix to get the
whole picture.

d.


[1] https://btrfs.wiki.kernel.org/index.php/FAQ#..._btrfs_is_broken_by_design_.28aka._Edward_Shishkin.27s_.22Unbound.28.3F.29_internal_fragmentation_in_Btrfs.22.29
