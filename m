Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51836 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab2JCTcV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 15:32:21 -0400
Date: Wed, 3 Oct 2012 21:32:12 +0200
From: David Sterba <dave@jikos.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V2] btrfs filesystem df
Message-ID: <20121003193211.GX14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 07:22:30PM +0200, Goffredo Baroncelli wrote:
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
>   Chunk-type  Mode      Chunk_size Logical_size        Used
>   Data        Single       21.01GB      21.01GB     10.34GB
>   System      DUP          80.00MB      40.00MB      4.00KB
>   System      Single        4.00MB       4.00MB        0.00
>   Metadata    DUP           4.00GB       2.00GB    686.93MB
>   Metadata    Single        8.00MB       8.00MB        0.00

Please snip the following help text from basic output, eg. when I'm
running the 'df' command before/after some actions from scripts, this
is unnecessary.

> Where:
>         Disk_size                       -> sum of sizes of teh disks
>         Disk_allocated                  -> sum of chunk sizes
>         Disk_unallocated                -> Disk_size - Disk_allocated
>         Logical_size                    -> sum of logical area sizes
>         Used                            -> logical area used
>         Free_(Estimated)                -> on the basis of allocated
>                                            chunk, an estrapolation of
>                                            the free space
>         Data_to_disk_ratio              -> ration between the space occuped
>                                            by a chunk and the real space
>                                            available ( due to duplication
>                                            and/or RAID level)
>         Chunk_type                      -> kind of chunk
>         Mode                            -> allocation policy of a chunk
>         Chunk_size                      -> area of disk(s) occuped by the
>                                            chunk (see it as raw space used)
>         Logical_size                    -> logical area size of the chunk
>         Used                            -> portion of the logical area
>                                            used by the filesystem


david
