Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49970 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab2JINvu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 09:51:50 -0400
Date: Tue, 9 Oct 2012 15:51:38 +0200
From: David Sterba <dave@jikos.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS][V3] btrfs filesystem df
Message-ID: <20121009135138.GP4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349371679-10775-1-git-send-email-kreijack@inwind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349371679-10775-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I hope I'm not late to the bikeshedding party, I've tried to use the
proposed version and here are my observations/wishes, and also issues,
pointed out in the threads, that were not addressed:

* I'd like to re-add the -s -d options in some way that I can choose
  which sections I'll see; the previous output matches the 'details'
  section and contains the valuable information for me
  More flexibility via options will satisfy more users, currently I have
  no choice than only ignore the summary section, not to say that this
  consumes half of my terminal

UI details (that make human-parsing of the output more pleasant experience):

* the 'Path' should contain full path, not just the argument that was
  given (otherwise it's useless)
* I'm with Hugo that there should be space between numbers and units
* show the byte units
* the short form for metadata in --mixed filesystem
  current:  Data+M.data
  proposed: Data+Meta
* Chunk_type -> Type ?
* Size_(logical) is misaligned with the numbers underneath
* Used (in the summary) is in logical units, I needed to hand calculate
  the number to find this out -- any idea how to make it more clear?
  like Used_(logical) similar to size
* revert the order of Min and Max in Free_(Estimated)
* in code: function is still named cmd_disk_free
* in code: although you've removed -s -d the getopt string still
  contains them (but this is not an objection because I want them back :)

Also, I've noticed that you refuse to fix minor things in code that
you're not touching directly for 'df', but this renders the (much
needed!) updates to df as only half-finished (IMHO). It's fine to add a
separate patch to fix up the non-df things. Let's fix it in one go :)

thanks,
david

[Sample output for quick reference]
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
>   Chunk_type  Mode     Size_(disk) Size_(logical)     Used
>   Data        Single       21.01GB      21.01GB     10.34GB
>   System      DUP          80.00MB      40.00MB      4.00KB
>   System      Single        4.00MB       4.00MB        0.00
>   Metadata    DUP           4.00GB       2.00GB    686.93MB
>   Metadata    Single        8.00MB       8.00MB        0.00
> 
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
>         Size_(disk)                     -> area of disk(s) occuped by the
>                                            chunk (see it as raw space used)
>         Size_(logical)                  -> logical area size of the chunk
>         Used                            -> portion of the logical area
>                                            used by the filesystem
