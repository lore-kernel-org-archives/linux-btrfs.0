Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:38437 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932162AbdJYTQb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:16:31 -0400
Date: Wed, 25 Oct 2017 21:16:28 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid misleading talk about "compression level 0"
Message-ID: <20171025191628.m6n7uw2ovjoj6gat@angband.pl>
References: <20171021164901.11529-1-kilobyte@angband.pl>
 <20171025132311.GY3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171025132311.GY3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 25, 2017 at 03:23:11PM +0200, David Sterba wrote:
> On Sat, Oct 21, 2017 at 06:49:01PM +0200, Adam Borowski wrote:
> > Many compressors do assign a meaning to level 0: either null compression or
> > the lowest possible level.  This differs from our "unset thus default".
> > Thus, let's not unnecessarily confuse users.
> 
> I agree 'level 0' confusing, however I'd like to keep the level
> mentioned in the message.
> 
> We could add
> 
> #define	BTRFS_COMPRESSION_ZLIB_DEFAULT		3
> 
> and use it in btrfs_compress_str2level.

I considered this but every algorithm has a different default, thus we'd
need separate cases for zlib vs zstd, while lzo has no settable level at
all.  Still, this is just some extra lines of code, thus doable.

> > Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> > ---
> >  fs/btrfs/super.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index f9d4522336db..144fabfbd246 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -551,7 +551,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> >  			      compress_force != saved_compress_force)) ||
> >  			    (!btrfs_test_opt(info, COMPRESS) &&
> >  			     no_compress == 1)) {
> > -				btrfs_info(info, "%s %s compression, level %d",
> > +				btrfs_printk(info, info->compress_level ?
> > +					   KERN_INFO"%s %s compression, level %d" :
> > +					   KERN_INFO"%s %s compression",
> 
> Please keep using btrfs_info, the KERN_INFO prefix would not work here.
> btrfs_printk prepends the filesystem description and the message level
> must be at the beginning.

Seems to work for me:
[   14.072575] BTRFS info (device sda1): use lzo compression
with identical colors as other info messages next to it.

But if we're to expand this code, ternary operators would get too hairy,
thus this can go at least for clarity.

> >  					   (compress_force) ? "force" : "use",
> >  					   compress_type, info->compress_level);
> >  			}
> 

-- 
⢀⣴⠾⠻⢶⣦⠀ Laws we want back: Poland, Dz.U. 1921 nr.30 poz.177 (also Dz.U. 
⣾⠁⢰⠒⠀⣿⡁ 1920 nr.11 poz.61): Art.2: An official, guilty of accepting a gift
⢿⡄⠘⠷⠚⠋⠀ or another material benefit, or a promise thereof, [in matters
⠈⠳⣄⠀⠀⠀⠀ relevant to duties], shall be punished by death by shooting.
