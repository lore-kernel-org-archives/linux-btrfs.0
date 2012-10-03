Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39823 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab2JCPBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 11:01:22 -0400
Received: by eekb15 with SMTP id b15so4084034eek.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 08:01:20 -0700 (PDT)
Date: Wed, 3 Oct 2012 18:01:17 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Message-ID: <20121003150117.GA1978@zambezi.lan>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 01:43:14PM +0200, Goffredo Baroncelli wrote:
> This serie of patches updated the command "btrfs filesystem
> df". I update this command because it is not so easy to get
> the information about the disk usage from the command "fi df" and "fi show".
> 
> >>From the man page (see 2nd patch):
> 
> [...]
> The  command  btrfs  filesystem  df is used to query the
> status of the chunks, how many space on the disk(s) are used  by
> the  chunks,  how many space are available in the chunks, and an
> estimation of the free space of the filesystem.
> [...]
> 
> $ ./btrfs filesystem df --help
> usage: btrfs filesystem disk-usage [-d][-s][-k] <path> [<path>..]
> 
>     Show space usage information for a mount point(s).
> 
>     -k  Set KB (1024 bytes) as unit
>     -s  Don't show the summary section
>     -d  Don't show the detail section

Hi Goffredo,

Why not show just the summary section by default and have a flag (-v)
for the details section?

> $ ./btrfs filesystem df /
> Path: /
> Summary:
>   Disk_size:                 72.57GB
>   Disk_allocated:            25.10GB
>   Disk_unallocated:          47.48GB
>   Logical_size:              23.06GB
>   Used:                      11.01GB
>   Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
>   Data_to_disk_ratio:           92 %
> 
> Details:
>   Chunk-type  Mode      Chunk-size Logical-size        Used

"Type" for the first column is probably enough.

Why is the third column called Chunk-size?  If my understanding is
correct, it's just a break down of Disk_allocated from the summary
section.  If so, why not call it Disk_allocated to avoid confusion?

Also, why do you use dashes instead of underbars for table headers?

Thanks,

		Ilya
