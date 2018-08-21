Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbeHUScM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 14:32:12 -0400
Date: Tue, 21 Aug 2018 17:11:26 +0200
From: David Sterba <dsterba@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: dsterba@suse.cz, clm@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: Do btrfs compression option changes need to be atomic?
Message-ID: <20180821151126.GE24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180821142000.GC24025@twin.jikos.cz>
 <31114.1534417285@warthog.procyon.org.uk>
 <476.1534859190@warthog.procyon.org.uk>
 <4150.1534862046@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4150.1534862046@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 21, 2018 at 03:34:06PM +0100, David Howells wrote:
> David Sterba <dsterba@suse.cz> wrote:
> 
> > Do you mean the compression type (btrfs_fs_info::compress_type) and the
> > related bits in btrfs_fs_info::mount_opt ? There are more compression
> > types but not used in the mount context.  I assume you're interested
> > only in the mount-time settings, otherwise the defrag and per-inode
> > compression has higher priority over the global settings.
> 
> Yes.  However, it would appear that remount can race with using the fs_info
> variables, so the settings can be changing whilst you're going through the
> compress_file_range() function.

compress_file_range reads the compress_type at the beginning, so remount
does not affect that and the function will continue using that for the
extent. This is racy in the sense that there's some compression going on
while the mount options do not say so.

I think this is not a big deal, there's sync_filesystem call at the
beginning of remount, so most of the data use the previous settings.
The window where new IO starts but remount has not updated the mount
options is short, so yes this is racy though I'm not sure if there's a
good way to actually measure that. The result is that eg. some extents
got compressed but should not have been.

The remount would have to flush IO and freeze all new, then change
options and thaw, but this starts to sound too heavyweight.

> I'm not sure it'll hurt exactly, but you can also find, say, DATACOW being
> disabled whilst you're considering compressing.

I think the constraint don't need to be strictly atomic, with some
intermediate states that are valid but neither the old nor what the new
options say. The race window spans a few instructions so as long as the
combination is valid or double checked later, I'd consider it ok.

The ordering of the bits set/cleared can prevent unwanted combinations,
like: when the COMPRESS bit is set, there's no NODATACOW anymore:

- clear NODATACOW
- set compress_type
- set COMPRESS

I haven't checked with the sources if this is so.

> > > Further to that, how much of an issue is it if the configuration is split
> > > out into its own struct that is accessed from struct btrfs_fs_info using
> > > RCU?
> > 
> > Depends on how intrusive it's going to be, the mount opions are tested
> > at many places. The RCU overhead and "locking" is lightweight enough so
> > it should not be a problem in principle, but without seeing the code I
> > can't tell.
> 
> Actually, a better way of doing this might be to put a subset of the settings
> into a single variable, say:
> 
> 	struct btrfs_fs_info {
> 		...
> 		unsigned int	data_storage_opt;
> 	#define BTRFS_DATA_NONE			0x0000
> 	#define BTRFS_DATA_COW			0x0001
> 	#define BTRFS_DATA_SUM			0x0002
> 	#define BTRFS_DATA_COMPRESS		0x0003
> 	#define BTRFS_DATA_FORCE_COMPRESS	0x0004
> 	#define BTRFS_DATA__STORAGE_OPT		0x000f
> 	#define BTRFS_DATA_COMPRESS_ZLIB	0x0000
> 	#define BTRFS_DATA_COMPRESS_LZO		0x0010
> 	#define BTRFS_DATA_COMPRESS_ZSTD	0x0020
> 	#define BTRFS_DATA__COMPRESS_TYPE	0x00f0
> 	#define BTRFS_DATA__COMPRESS_LEVEL	0x0f00
> 		...
> 	};
> 
> That way it might be possible for the datacow, datasum, compress and
> compress-force options to be handled atomically.

So the changes would be possible in one atomic (bitwise) call? Instead
of:

  clear_bit(opts, NODATACOW)
  set_bit(opts, COMPRESS)

do:

  set_bits_with_mask(opts, COMPRESS, BTRFS_DATA__STORAGE_OPT)

?

Side note: up to now we're all used to the NO* naming and semantics of
the feature bits, so it might take some time to do the mental switch.
