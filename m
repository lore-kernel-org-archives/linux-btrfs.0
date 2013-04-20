Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33195 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab3DTPte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 11:49:34 -0400
Received: by mail-wi0-f179.google.com with SMTP id l13so2268365wie.0
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 08:49:33 -0700 (PDT)
Message-ID: <5172B905.2050807@gmail.com>
Date: Sat, 20 Apr 2013 17:49:25 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] [RFC] btrfs: offline dedupe
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
In-Reply-To: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Hi,
>
> The following series of patches implements in btrfs an ioctl to do
> offline deduplication of file extents.

I am a fan of this patch, the API is just right.  I just have a few 
tweaks to suggest to the argument checking.

At first the 1M limitation on the length was a bit inconvenient, but 
making repeated calls in userspace is okay and allows for better error 
recovery (for example, repeating the calls when only a portion of the 
ranges is identical).  The destination file appears to be fragmented 
into 1M extents, but these are contiguous so it's not really a problem.

Requiring the offset or the length to align is spurious however; it 
doesn't translate to any alignment in the extent tree (especially with 
compression).  Requiring a minimum length of a few blocks or dropping 
the alignment condition entirely would make more sense.

I notice there is a restriction on cross-subvolume deduplication. 
Hopefully it can be lifted like it was done in 3.6 for the clone ioctl.

Deduplicating frozen subvolumes works fine, which is great for backups.

Basic integration with bedup, my offline deduplication tool, is in an 
experimental branch:

   https://github.com/g2p/bedup/tree/wip/dedup-syscall

Thanks to this, I look forward to shedding most of the caveats given in 
the bedup readme and some unnecessary subtleties in the code.

> I've made significant updates and changes from the original. In
> particular the structure passed is more fleshed out, this series has a
> high degree of code sharing between itself and the clone code, and the
> locking has been updated.
>
> The ioctl accepts a struct:
>
> struct btrfs_ioctl_same_args {
> 	__u64 logical_offset;	/* in - start of extent in source */
> 	__u64 length;		/* in - length of extent */
> 	__u16 total_files;	/* in - total elements in info array */

Nit: total_files sounds like it would count the source file.
dest_count would be better.

By the way, extent-same might be better named range-same, since there is 
no need for the input to fall on extent boundaries.

> 	__u16 files_deduped;	/* out - number of files that got deduped */
> 	__u32 reserved;
> 	struct btrfs_ioctl_same_extent_info info[0];
> };
>
> Userspace puts each duplicate extent (other than the source) in an
> item in the info array. As there can be multiple dedupes in one
> operation, each info item has it's own status and 'bytes_deduped'
> member. This provides a number of benefits:
>
> - We don't have to fail the entire ioctl because one of the dedupes failed.
>
> - Userspace will always know how much progress was made on a file as we always
>    return the number of bytes deduped.
>
>
> #define BTRFS_SAME_DATA_DIFFERS	1
> /* For extent-same ioctl */
> struct btrfs_ioctl_same_extent_info {
> 	__s64 fd;		/* in - destination file */
> 	__u64 logical_offset;	/* in - start of extent in destination */
> 	__u64 bytes_deduped;	/* out - total # of bytes we were able
> 				 * to dedupe from this file */
> 	/* status of this dedupe operation:
> 	 * 0 if dedup succeeds
> 	 * < 0 for error
> 	 * == BTRFS_SAME_DATA_DIFFERS if data differs
> 	 */
> 	__s32 status;		/* out - see above description */
> 	__u32 reserved;
> };

