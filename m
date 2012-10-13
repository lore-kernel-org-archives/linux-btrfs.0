Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64432 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2JMTCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 15:02:05 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2401507eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 12:02:03 -0700 (PDT)
Message-ID: <5079BABE.100@gmail.com>
Date: Sat, 13 Oct 2012 21:02:22 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: Chris Mason <chris.mason@fusionio.com>, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
        Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [PATCH][BTRFS-PROGS][V5] btrfs filesystem df
References: <1350154331-12886-1-git-send-email-kreijack@gmail.com>
In-Reply-To: <1350154331-12886-1-git-send-email-kreijack@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please, discard this email...

On 2012-10-13 20:52, Goffredo Baroncelli wrote:
> Hi Chris,
>
> this serie of patches updated the command "btrfs filesystem
> df". I update this command because it is not so easy to get
> the information about the disk usage from the command "fi df" and "fi show".
> This patch was the result of some discussions on the btrfs
> mailing list. Many thanks to all the contributors.
>
> from the man page (see 2nd patch):
>
> [...]
> The  command  btrfs  filesystem  df is used to query the
> status of the chunks, how many space on the disk(s) are used  by
> the  chunks,  how many space are available in the chunks, and an
> estimation of the free space of the filesystem.
> [...]
>
> $ ./btrfs filesystem df --help
> usage: btrfs filesystem disk-usage [-k]<path>  [<path>..]
>
>      Show space usage information for a mount point(s).
>
>      -k  Set KB (1024 bytes) as unit
>
> $ ./btrfs filesystem df /
> Path: /
> Summary:
>    Disk_size:                 72.57GB
>    Disk_allocated:            25.10GB
>    Disk_unallocated:          47.48GB
>    Logical_size:              23.06GB
>    Used:                      11.01GB
>    Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
>    Data_to_disk_ratio:           92 %
>
> Allocated_area:
>    Type        Mode       Size_(disk)    Size_(logical)          Used
>    Data        Single         21.01GB           21.01GB       12.77GB
>    System      DUP            80.00MB           40.00MB        4.00KB
>    System      Single          4.00MB            4.00MB          0.00
>    Metadata    DUP             4.00GB            2.00GB      709.63MB
>    Metadata    Single          8.00MB            8.00MB          0.00
>
> Where:
>          Disk_size                       ->  sum of sizes of teh disks
>          Disk_allocated                  ->  sum of chunk sizes
>          Disk_unallocated                ->  Disk_size - Disk_allocated
>          Logical_size                    ->  sum of logical area sizes
>          Used                            ->  logical area used
>          Free_(Estimated)                ->  on the basis of allocated
>                                             chunk, an estrapolation of
>                                             the free space
>          Data_to_disk_ratio              ->  ration between the space occuped
>                                             by a chunk and the real space
>                                             available ( due to duplication
>                                             and/or RAID level)
>          Type				->  kind of chunk
>          Mode                            ->  allocation policy of a chunk
>          Size_(disk)                     ->  area of disk(s) occuped by the
>                                             chunk (see it as raw space used)
>          Size_(logical)                  ->  logical area size of the chunk
>          Used                            ->  portion of the logical area
>                                             used by the filesystem
>
>
>
> You can pull this change from
>     http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
> branch
>     disk_free
>
> Please pull.
>
> Signed-off-by: Goffredo Baroncelli<kreijack@gmail.com>
>
> BR
> Goffredo Baroncelli
>
> Changelog:
> V4->V5		Add a close(fd) to avoid file descriptor leaking
> V3->V4		Removed the switch -d -s from getopt(), aligned the
> 		column Size_(logical), renamed the fields:
> 		- Details ->  Allocated_area
> 		- Chunk_type ->  Type
> V2->V3          Removed the options '-s' and '-d'; replaced Chunk-size
>                  and Logical-size with Size_(disk) and Size_(logical).
>                  Update the man page.
> V1->V2          Uses getopt(); replace "-" with "_"; change the behaviour
>                  of the switches '-s' and '-d'.
> V0->V1          Change the name of command from disk-usage to df
>
>
>

