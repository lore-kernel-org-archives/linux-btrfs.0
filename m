Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab3C2QsH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 12:48:07 -0400
Date: Fri, 29 Mar 2013 17:48:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] btrfs: document mount options in
 Documentation/fs/btrfs.txt
Message-ID: <20130329164803.GG29125@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <514DEB06.7000606@redhat.com>
 <5151F8AC.6060100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5151F8AC.6060100@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few comments that reflect current implementation

On Tue, Mar 26, 2013 at 02:36:12PM -0500, Eric Sandeen wrote:
> +When mounting a btrfs filesystem, the following option are accepted.
> +Unless otherwise specified, all options default to off.
> +
> +  alloc_start=<bytes>
> +	Debugging option to force all block allocations above a certain
> +	byte threshold on each block device.  The value is specified in
> +	bytes, optionally with a K, M, or G suffix, case insensitive.
> +	Default is 1MB.

yes it is 1MB by default, and also a hardcoded minimum.

> +  max_inline=<bytes>
> +	Specify the maximum amount of space, in bytes, that can be inlined in
> +	a metadata B-tree leaf.  The value is specified in bytes, optionally 
> +	with a K, M, or G suffix, case insensitive.  In practice, this value
> +	is limited by the root sector size, with some space unavailable due

the 'root sector size' sounds a bit confusing, the commonly used term is
'sectorsize'

> +	to leaf headers.  For a 4k sectorsize, max inline data is ~3900 bytes.
> +
> +  notreelog
> +	Disable the tree logging used for fsync and O_SYNC writes.
> +
> + skip_balance
> +	Skip automatic resume of interrupted balance operation after mount.
> +	May be resumed with "btrfs balance resume."

A dot inside a quotation looks confusing to non-us people, I hope nobody
will try to copypaste it :)

> +  subvolid=<ID>
> +	Mount subvolume specified by an ID number rather than the root subvolume.

> +	This allows mounting of subvolumes which are not in the root of the mounted
> +	filesystem.

This sentence refers to the previous behaviour when subvol did not
accept full path. I suggest to drop it.

> +	You can use "btrfs subvolume list" to see subvolume ID numbers.

Please add something in the sense of "The toplevel subvolume has ID 0".

> +  subvolrootid=<objectid> (deprecated)
> +	Mount subvolume specified by <objectid> rather than the root subvolume.
> +	This allows mounting of subvolumes which are not in the root of the mounted
> +	filesystem.

Not true for a long time, since subvol=/full/path time it's a no-op. The
patch to print a warning when the option is used has been sent not so long
ago though.

> +	You can use "btrfs subvolume show " to see the object ID for a subvolume.
> +	

It seems to me that you probably did not count
https://btrfs.wiki.kernel.org/index.php/Mount_options into the
documentation sources. We've tried to keep this page up-to-date, but it
does not cover the same things you did in this patch. Ideally merging
information from both is desirable.

thanks,
david
