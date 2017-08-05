Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46615 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdHEB1x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 21:27:53 -0400
Date: Sat, 5 Aug 2017 03:27:45 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Message-ID: <20170805012745.g44pyqgb42z6jvro@angband.pl>
References: <20170724172939.24527-1-dsterba@suse.com>
 <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 04, 2017 at 09:51:44PM +0000, Nick Terrell wrote:
> On 07/25/2017 01:29 AM, David Sterba wrote:
> > Preliminary support for setting compression level for zlib, the
> > following works:
> 
> Thanks for working on this, I think it is a great feature.
> I have a few comments relating to how it would work with zstd.

Like, currently crashing because of ->set_level being 0? :p

> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -866,6 +866,11 @@ static void free_workspaces(void)
> >   * Given an address space and start and length, compress the bytes into @pages
> >   * that are allocated on demand.
> >   *
> > + * @type_level is encoded algorithm and level, where level 0 means whatever
> > + * default the algorithm chooses and is opaque here;
> > + * - compression algo are 0-3
> > + * - the level are bits 4-7
> 
> zstd has 19 levels, but we can either only allow the first 15 + default, or
> provide a mapping from zstd-level to BtrFS zstd-level.

Or give it more bits.  Issues like this are exactly why this patch is marked
"preview".

But, does zstd give any gains with high compression level but input data
capped at 128KB?  I don't see levels above 15 on your benchmark, and certain
compression algorithms give worse results at highest levels for small
blocks.

> > @@ -888,9 +893,11 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
> >  {
> >  	struct list_head *workspace;
> >  	int ret;
> > +	int type = type_level & 0xF;
> >  
> >  	workspace = find_workspace(type);
> >  
> > +	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
> 
> zlib uses the same amount of memory independently of the compression level,
> but zstd uses a different amount of memory for each level. zstd will have
> to allocate memory here if it doesn't have enough (or has way to much),
> will that be okay?

We can instead store workspaces per the encoded type+level, that'd allow
having different levels on different mounts (then props, once we get there).

Depends on whether you want highest levels, though (asked above) -- the
highest ones take drastically more memory, so if they're out, blindly
reserving space for the highest supported level might be not too wasteful.

(I have only briefly looked at memory usage and set_level(), please ignore
me if I babble incoherently -- in bed on a N900 so I can't test it right
now.)


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs (the five fishes + two breads affair)
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water
