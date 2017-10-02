Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750957AbdJBOlt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 10:41:49 -0400
Date: Mon, 2 Oct 2017 16:40:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add option to only list parent subvolumes
Message-ID: <20171002144013.GY31640@suse.cz>
Reply-To: dsterba@suse.cz
References: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <6c01643a-b6cd-21ae-45ec-e074995a5de2@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 30, 2017 at 03:08:13PM +0200, Holger Hoffstätte  wrote:
> Hi,
> 
> When listing subvolumes it can be useful to filter out any snapshots;
> surprisingly enough I couldn't find an option to do this easily, only
> the opposite (list only snapshots).
> 
> A "root" subvolume is identified by a null parent UUID, so adding a new
> subvolume filter and flag -P ("Parent") does the trick. 
> 
> The same can of course be accomplished with shell hackery, e.g.:
> 
>  btrfs subvol list -q -o <path> | grep -i "parent_uuid -" | cut -d " " -f 11
> 
> but a built-in way seems less fragile.
> 
> I originally cooked this up for myself, but David Sterba encouraged me to
> send this to the list, so here it is. I'm not too proud of the -P but
> couldn't find a better option letter; suggestions welcome. :)

Thanks for sending it. Filtering by non-snapshots is indeed missing.
I've applied the patch as is, but I suspect the option name will change
before it ends up in a release.

We have terminology problems (again), as 'subvolume' is commonly used
for both plain subvolumes and also snapshots, but for the filtering we
need to make the clear distinction.

For the snapshot it's easy, the starting point of a snapshot is another
subvolume or snapshot, ie. there's the parent UUID. Plain subvolume gets
created by 'btrfs subvolume create'.

While the 'parent' notion reflects that a snapshot originates from
another subvolume, there's also directory structure that uses the term.
And in combination with subvolumes it's not always true that a parent
subvolume is also parent directory.

So my idea is to use '-S' as for "subvolumes", and '-s' for "snapshots"
by the strict defintion.

The output of subvolume listing will get reworked, so I'd like to keep
the final decision about the option naming open, until I get the whole
picture and some working prototype with the libsmartcols.
