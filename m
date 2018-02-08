Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:45539 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752058AbeBHSwI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Feb 2018 13:52:08 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
To: Liu Bo <bo.li.liu@oracle.com>
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <cfd107b0-e08d-775d-9b46-3cc49e587242@libero.it>
Date: Thu, 8 Feb 2018 19:52:05 +0100
MIME-Version: 1.0
In-Reply-To: <20180205231502.12900-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2018 12:15 AM, Liu Bo wrote:
[...]
> One way to mitigate the data loss pain is to expose 'bad chunks',
> i.e. degraded chunks, to users, so that they can use 'btrfs balance'
> to relocate the whole chunk and get the full raid6 protection again
> (if the relocation works).

[...]
[...]

> +
> +	/* read lock please */
> +	do {
> +		seq = read_seqbegin(&fs_info->bc_lock);
> +		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
> +			len += snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
> +					bc->chunk_offset);
> +			/* chunk offset is u64 */
> +			if (len >= PAGE_SIZE)
> +				break;
> +		}
> +	} while (read_seqretry(&fs_info->bc_lock, seq));

Using this interface, how many chunks can you list ? If I read the code correctly, only up to fill a kernel page.

If my math are correctly (PAGE_SIZE=4k, a u64 could require up to 19 bytes) it is possible to list only few hundred of chunks (~200). Not more; and the last one could be even listed incomplete.

IIRC a chunk size is max 1GB; If you lost a 500GB of disks, the chunks to list could be more than 200.

My first suggestion is to limit the number of chunks to show to 200 (a page should be big enough to contains all these chunks offset). If the chunks number are greater, ends the list with a marker (something like '[...]\n').
This would solve the ambiguity about the fact that the list chunks are complete or not. Anyway you cannot list all the chunks.

However, my second suggestions is to ... change completely the interface. What about adding a directory in sysfs, where each entry is a chunk ?

Something like:

/sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/type		# data/metadata/sys
/sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/profile		# dup/linear....
/sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/size		# size
/sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/devs		# chunks devs 

And so on. 

Checking  "[...]<chunks-offset>/devs", it would be easy understand if the chunk is in "degraded" mode or not.

However I have to admit that I don't know how feasible is iterate over a sysfs directory which is a map of a kernel objects list.

I think that if these interface would be good enough, we could get rid of a lot of ioctl(TREE_SEARCH) from btrfs-progs. 

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
