Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56950 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbcFWBKQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 21:10:16 -0400
Subject: Re: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1466616406-28087-1-git-send-email-dsterba@suse.com>
Cc: David Sterba <dsterba@suse.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <59a806a2-262e-42fe-404a-328569901055@mendix.com>
Date: Thu, 23 Jun 2016 03:10:09 +0200
MIME-Version: 1.0
In-Reply-To: <1466616406-28087-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2016 07:26 PM, David Sterba wrote:
> From: David Sterba <dsterba@suse.cz>
>
> Hi,
>
> the chunk dump is a useful thing, for debugging or balance filters.
>
> Example output:
>
> Chunks on device id: 1
> PNumber            Type        PStart        Length          PEnd     Age         LStart  Usage
> -----------------------------------------------------------------------------------------------
>       0   System/RAID1        1.00MiB      32.00MiB      33.00MiB      47        1.40TiB   0.06
>       1 Metadata/RAID1       33.00MiB       1.00GiB       1.03GiB      31        1.36TiB  64.03
>       2 Metadata/RAID1        1.03GiB      32.00MiB       1.06GiB      36        1.36TiB  77.28
>       3     Data/single       1.06GiB       1.00GiB       2.06GiB      12      422.30GiB  78.90
>       4     Data/single       2.06GiB       1.00GiB       3.06GiB      11      420.30GiB  78.47
> ...

On RAID0, it looks funny :)

# ./btrfs inspect-internal dump-chunks /mnt/extents/
Chunks on device id: 1
PNumber            Type        PStart        Length          PEnd Age         LStart
----------------------------------------------------------------------------------------
       0 Metadata/RAID0        1.00MiB     256.00MiB     257.00MiB 1       13.36GiB
       .           empty             .      16.00EiB             .  .              .
       1   System/RAID0      129.00MiB      64.00MiB     193.00MiB 2       13.61GiB
       .           empty             .      16.00EiB             .  .              .
       2     Data/RAID0      161.00MiB       2.00GiB       2.16GiB 3       15.68GiB
       .           empty             .     115.00MiB             .  .              .
       3     Data/RAID0        2.27GiB       2.00GiB       4.27GiB 0       11.36GiB

Chunks on device id: 2
PNumber            Type        PStart        Length          PEnd 
Age         LStart
----------------------------------------------------------------------------------------
       0     Data/RAID0        1.00MiB       2.00GiB       2.00GiB 0       11.36GiB
       .           empty             .      16.00EiB             .  .              .
       1 Metadata/RAID0        1.00GiB     256.00MiB       1.25GiB 1       13.36GiB
       .           empty             .      16.00EiB             .  .              .
       2   System/RAID0        1.13GiB      64.00MiB       1.19GiB 2       13.61GiB
       .           empty             .      16.00EiB             .  .              .
       3     Data/RAID0        1.16GiB       2.00GiB       3.16GiB 3       15.68GiB

For the correct sizes, it would be needed to either do some math, like 
if RAID0 then divide by 2, but I guess this gets horrible really soon 
with RAID5 etc... Or, if you want to print everything in the physical 
order, why not just dump the device tree with DEV_EXTENT which has the 
exact length on disk, and fill in the missing information using the 
reference to the chunk they belong to?

https://github.com/knorrie/python-btrfs/commit/be85c2a0e2774909b532326e99e0c23ab8467263

Sorry, couldn't resist /:D\

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
