Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbeHURyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:54:31 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180821142000.GC24025@twin.jikos.cz>
References: <20180821142000.GC24025@twin.jikos.cz> <31114.1534417285@warthog.procyon.org.uk> <476.1534859190@warthog.procyon.org.uk>
To: dsterba@suse.cz, clm@fb.com
Cc: dhowells@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: Do btrfs compression option changes need to be atomic?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 21 Aug 2018 15:34:06 +0100
Message-ID: <4150.1534862046@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> wrote:

> Do you mean the compression type (btrfs_fs_info::compress_type) and the
> related bits in btrfs_fs_info::mount_opt ? There are more compression
> types but not used in the mount context.  I assume you're interested
> only in the mount-time settings, otherwise the defrag and per-inode
> compression has higher priority over the global settings.

Yes.  However, it would appear that remount can race with using the fs_info
variables, so the settings can be changing whilst you're going through the
compress_file_range() function.

I'm not sure it'll hurt exactly, but you can also find, say, DATACOW being
disabled whilst you're considering compressing.

> > Further to that, how much of an issue is it if the configuration is split
> > out into its own struct that is accessed from struct btrfs_fs_info using
> > RCU?
> 
> Depends on how intrusive it's going to be, the mount opions are tested
> at many places. The RCU overhead and "locking" is lightweight enough so
> it should not be a problem in principle, but without seeing the code I
> can't tell.

Actually, a better way of doing this might be to put a subset of the settings
into a single variable, say:

	struct btrfs_fs_info {
		...
		unsigned int	data_storage_opt;
	#define BTRFS_DATA_NONE			0x0000
	#define BTRFS_DATA_COW			0x0001
	#define BTRFS_DATA_SUM			0x0002
	#define BTRFS_DATA_COMPRESS		0x0003
	#define BTRFS_DATA_FORCE_COMPRESS	0x0004
	#define BTRFS_DATA__STORAGE_OPT		0x000f
	#define BTRFS_DATA_COMPRESS_ZLIB	0x0000
	#define BTRFS_DATA_COMPRESS_LZO		0x0010
	#define BTRFS_DATA_COMPRESS_ZSTD	0x0020
	#define BTRFS_DATA__COMPRESS_TYPE	0x00f0
	#define BTRFS_DATA__COMPRESS_LEVEL	0x0f00
		...
	};

That way it might be possible for the datacow, datasum, compress and
compress-force options to be handled atomically.

David
