Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52738 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751043AbdHECP6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 22:15:58 -0400
From: Nick Terrell <terrelln@fb.com>
To: Adam Borowski <kilobyte@angband.pl>
CC: "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Date: Sat, 5 Aug 2017 02:15:42 +0000
Message-ID: <336A13CC-78FC-4CAC-9258-0336D7683AE3@fb.com>
References: <20170724172939.24527-1-dsterba@suse.com>
 <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
 <20170805012745.g44pyqgb42z6jvro@angband.pl>
In-Reply-To: <20170805012745.g44pyqgb42z6jvro@angband.pl>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/4/17, 6:27 PM, "Adam Borowski" <kilobyte@angband.pl> wrote:
> On Fri, Aug 04, 2017 at 09:51:44PM +0000, Nick Terrell wrote:
> > On 07/25/2017 01:29 AM, David Sterba wrote:
> > > Preliminary support for setting compression level for zlib, the
> > > following works:
> > 
> > Thanks for working on this, I think it is a great feature.
> > I have a few comments relating to how it would work with zstd.
> 
> Like, currently crashing because of ->set_level being 0? :p
> 
> > > --- a/fs/btrfs/compression.c
> > > +++ b/fs/btrfs/compression.c
> > > @@ -866,6 +866,11 @@ static void free_workspaces(void)
> > >   * Given an address space and start and length, compress the bytes into @pages
> > >   * that are allocated on demand.
> > >   *
> > > + * @type_level is encoded algorithm and level, where level 0 means whatever
> > > + * default the algorithm chooses and is opaque here;
> > > + * - compression algo are 0-3
> > > + * - the level are bits 4-7
> > 
> > zstd has 19 levels, but we can either only allow the first 15 + default, or
> > provide a mapping from zstd-level to BtrFS zstd-level.
> 
> Or give it more bits.  Issues like this are exactly why this patch is marked
> "preview".
> 
> But, does zstd give any gains with high compression level but input data
> capped at 128KB?  I don't see levels above 15 on your benchmark, and certain
> compression algorithms give worse results at highest levels for small
> blocks.

Yeah, I stopped my benchmarks at 15, since without configurable compression
level, high levels didn't seem useful. But level 19 could be interesting if
you are building a base image that is widely distributed. When testing BtrFS
on the Silesia corpus, the compression ratio improved all the way to level
19.

> 
> > > @@ -888,9 +893,11 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
> > >  {
> > >  	struct list_head *workspace;
> > >  	int ret;
> > > +	int type = type_level & 0xF;
> > >  
> > >  	workspace = find_workspace(type);
> > >  
> > > +	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
> > 
> > zlib uses the same amount of memory independently of the compression level,
> > but zstd uses a different amount of memory for each level. zstd will have
> > to allocate memory here if it doesn't have enough (or has way to much),
> > will that be okay?
> 
> We can instead store workspaces per the encoded type+level, that'd allow
> having different levels on different mounts (then props, once we get there).
> 
> Depends on whether you want highest levels, though (asked above) -- the
> highest ones take drastically more memory, so if they're out, blindly
> reserving space for the highest supported level might be not too wasteful.

Looking at the memory usage of BtrFS zstd, the 128 KB window size keeps the
memory usage very reasonable up to level 19. The zstd compression levels
are computed using a tool that selects the parameters that give the best
compression ratio for a given compression speed target. Since BtrFS has a
fixed window size, the default compression levels might not be optimal. We
could compute our own compression levels for a 128 KB window size.

| Level | Memory |
|-------|--------|
| 1     | 0.8 MB |
| 2     | 1.0 MB |
| 3     | 1.3 MB |
| 4     | 0.9 MB |
| 5     | 1.4 MB |
| 6     | 1.5 MB |
| 7     | 1.4 MB |
| 8     | 1.8 MB |
| 9     | 1.8 MB |
| 10    | 1.8 MB |
| 11    | 1.8 MB |
| 12    | 1.8 MB |
| 13    | 2.4 MB |
| 14    | 2.6 MB |
| 15    | 2.6 MB |
| 16    | 3.1 MB |
| 17    | 3.1 MB |
| 18    | 3.1 MB |
| 19    | 3.1 MB |

The workspace memory usage for each compression level.

> 
> (I have only briefly looked at memory usage and set_level(), please ignore
> me if I babble incoherently -- in bed on a N900 so I can't test it right
> now.)
> 
> 
> Meow!
> -- 
> â¢€â£´â ¾â »â¢¶â£¦â € What Would Jesus Do, MUD/MMORPG edition:
> â£¾â â¢°â ’â €â£¿â¡ â€¢ multiplay with an admin char to benefit your mortal
> â¢¿â¡„â ˜â ·â šâ ‹â € â€¢ abuse item cloning bugs (the five fishes + two breads affair)
> â ˆâ ³â£„â €â €â €â € â€¢ use glitches to walk on water
> 


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
