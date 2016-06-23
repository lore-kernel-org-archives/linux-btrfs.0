Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbcFWNHc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 09:07:32 -0400
Date: Thu, 23 Jun 2016 15:07:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
Message-ID: <20160623130755.GB4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466616406-28087-1-git-send-email-dsterba@suse.com>
 <02c731c5-f784-41f4-8cd1-4cf25d7f32e7@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <02c731c5-f784-41f4-8cd1-4cf25d7f32e7@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 09:20:40AM +0800, Qu Wenruo wrote:
> Yes, quite useful.
> I don't ever need to manually check btrfs-debug-tree output to figure 
> out the dev-extent layout.
> 
> But according to the output, it's more like dev-extent dump, not chunk dump.
> 
> It's better to make things more clear for objects at different logical 
> level.

Agreed, therefore I'd create 2 commands, one for dumping the logical
chunks and another for the dev-extents (which is unfortunatelly not as
short for a command name).

> > Example output:
> >
> > Chunks on device id: 1
> > PNumber            Type        PStart        Length          PEnd     Age         LStart  Usage
> > -----------------------------------------------------------------------------------------------
> >       0   System/RAID1        1.00MiB      32.00MiB      33.00MiB      47        1.40TiB   0.06
> 
> [Mixed chunk/dev-extent output]
> For "PStart/Length/Pend/Lstart" that's OK.
> (Although I prefer "Plength" to "Length", as it's a little confusing for 
> chunk logical length and dev_extent physical length)

This should be sorted once the commands are split. Using the 'P' or 'L'
prefixes for clarity is a good thing.

> Since "pstart" = key.offset, "length" = dev_extent_length, "Pend" = 
> pstart + length and "Lstart" = dev_extent_chunk_offset, these values are 
> all straightforward.
> 
> But for Usage, it's completely a chunk/block group level thing, so 
> personally speaking it's better not to output per chunk usage in 
> dev-extent dump

Agreed.

> If there is real "chunk dump", then that's the best place to output 
> per-chunk "usage".
> 
> For dev-extent level usage, it should be the usage of a device, not per 
> chunk.
> 
> ["Age" calculation]
> Another concern is about "age", since there is no generation in 
> chunk_item nor dev_extent, so you're using logical bytenr as a hint.
> 
> This method implies the fact that btrfs will always allocates new chunk 
> with increasing logical bytenr, never reuse lower logical bytenr.
> 
> Such behavior provides the basis for a lot of other btrfs functions, 
> like balance/qgroup rescan.
> IMHO it won't be changed in any time soon. But I'm still a little 
> concerned about using such assumption.
> 
> 
> Since "age" here is more like a sorting index, not the generation when 
> the chunk is created.
> It may not really reflect how long one chunk really lived.
> 
> It maybe completely OK for most people, but at least it's not as 
> straightforward as generation.

Yes, I'll change it to LNumber.

> [Support for offline btrfs]
> BTW, it's also a good idea to support not only mounted fs, but also 
> offlined one.
> 
> As for offlined one, no need to bother about the tree search ioctl, just 
> straightforward search_slots().
> (That's why I like offline btrfs tools)

Yeah, the offline mode would be useful and not only for this command, so
this should be sorted first on the whole tool level so we don't stitch
it to each command separately.
