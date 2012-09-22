Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59136 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751445Ab2IVHsy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Sep 2012 03:48:54 -0400
Message-ID: <505D6D87.1070403@gmx.net>
Date: Sat, 22 Sep 2012 09:49:27 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Jp Wise <jpwise@theflat.net.nz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Identifying reflink / CoW files
References: <505D32C2.8070105@theflat.net.nz>
In-Reply-To: <505D32C2.8070105@theflat.net.nz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/12 05:38, Jp Wise wrote:
> Good morning, I'm working on an offline deduplication script intended to
> work around the copy-on-write functionality of BTRFS.
> 
> Simply put - is there any existing utility to compare two files (or
> dirs) and output if the files share the same physical extents / data
> blocks on disk?
> - aka - they're CoW copies.
> 
> I'm not actively working with BTRFS yet, but for the project i'm working
> on it's looking to the be most suitable candidate, and the CoW
> functionality avoids issues with file changes that hardlinks would create.
> From reading other posts, aware the information could be pulled out via
> btrfs-debug-tree, but it would then involve parsing the entire output to
> locate the required files inodes and their extents which seems like
> quite a roundabout way to retrieve the information.
> 
> Also my programming skills aren't  up to the task of trying to pull the
> tree data directly from the filesystem to do it, and I'd like to avoid
> doing byte-by-byte comparisons on all files as it's inefficient if the
> file can instead be identified as a CoW copy.

The information is available in the kernel, but to find a good way to
extract it you have to describe in much more detail what you intend to
do. What I, first of all, don't understand, is, why you need the
information of already shared (=deduped) blocks to build a dedup. Don't
you want to find data that is identical, but not shared, instead?

> 
> Open to suggestions of other tools that could be used to acheive the
> desired result.
> 

Afaik without playing with it myself fiemap can give you information
about the mappings of each file. If the mappings of 2 files match,
the data is shared.

> Thanks.
> Jp.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

