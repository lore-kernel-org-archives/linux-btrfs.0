Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbeBHTNM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Feb 2018 14:13:12 -0500
Date: Thu, 8 Feb 2018 11:07:14 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
Message-ID: <20180208190714.GC9008@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <cfd107b0-e08d-775d-9b46-3cc49e587242@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cfd107b0-e08d-775d-9b46-3cc49e587242@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 08, 2018 at 07:52:05PM +0100, Goffredo Baroncelli wrote:
> On 02/06/2018 12:15 AM, Liu Bo wrote:
> [...]
> > One way to mitigate the data loss pain is to expose 'bad chunks',
> > i.e. degraded chunks, to users, so that they can use 'btrfs balance'
> > to relocate the whole chunk and get the full raid6 protection again
> > (if the relocation works).
> 
> [...]
> [...]
> 
> > +
> > +	/* read lock please */
> > +	do {
> > +		seq = read_seqbegin(&fs_info->bc_lock);
> > +		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
> > +			len += snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
> > +					bc->chunk_offset);
> > +			/* chunk offset is u64 */
> > +			if (len >= PAGE_SIZE)
> > +				break;
> > +		}
> > +	} while (read_seqretry(&fs_info->bc_lock, seq));
> 
> Using this interface, how many chunks can you list ? If I read the code correctly, only up to fill a kernel page.
>
> If my math are correctly (PAGE_SIZE=4k, a u64 could require up to 19 bytes) it is possible to list only few hundred of chunks (~200). Not more; and the last one could be even listed incomplete.
> 

That's true.

> IIRC a chunk size is max 1GB; If you lost a 500GB of disks, the chunks to list could be more than 200.
>
> My first suggestion is to limit the number of chunks to show to 200 (a page should be big enough to contains all these chunks offset). If the chunks number are greater, ends the list with a marker (something like '[...]\n').
> This would solve the ambiguity about the fact that the list chunks are complete or not. Anyway you cannot list all the chunks.
>

Good point, and I need to add one more field to each record to specify
it's metadata or data.

So what I have in my mind is that this kind of error is rare and
reflects bad sectors on disk, but if there are really that many
errors, I think we need to replace the disk without hesitation.

> However, my second suggestions is to ... change completely the interface. What about adding a directory in sysfs, where each entry is a chunk ?
> 
> Something like:
> 
> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/type		# data/metadata/sys
> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/profile		# dup/linear....
> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/size		# size
> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/devs		# chunks devs 
> 
> And so on. 
> 
> Checking  "[...]<chunks-offset>/devs", it would be easy understand if the chunk is in "degraded" mode or not.

I'm afraid we cannot do that as it'll occupy too much memory for large
filesystems given a typical chunk size is 1GB.

> 
> However I have to admit that I don't know how feasible is iterate over a sysfs directory which is a map of a kernel objects list.
> 
> I think that if these interface would be good enough, we could get rid of a lot of ioctl(TREE_SEARCH) from btrfs-progs. 
>

TREE_SEARCH is faster than iterating sysfs (if we could), isn't it?

thanks,
-liubo
