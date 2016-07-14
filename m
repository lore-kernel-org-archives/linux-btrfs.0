Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5253 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752059AbcGNVpz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 17:45:55 -0400
Subject: Re: New btrfs sub command: btrfs inspect physical-find
To: <kreijack@inwind.it>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7c20be09-1ac2-1d1f-f545-e2d56578a77b@libero.it>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <16994642-2a2f-55fa-c683-7153977f4577@fb.com>
Date: Thu, 14 Jul 2016 17:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <7c20be09-1ac2-1d1f-f545-e2d56578a77b@libero.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/12/2016 05:40 PM, Goffredo Baroncelli wrote:
> Hi All,
>
> the enclosed patch adds a new btrfs sub command: "btrfs inspect physical-find". The aim of this new command is to show the physical placement on the disk of a file. Currently it handles all the profiles (single, dup, raid1/10/5/6).
> I develop this command in order to show some bug in btrfs RAID5 profile (see next email).

I've done this manually from time to time, and love the idea of having a 
helper for it.  Can I talk you into adding a way to save the contents of 
the block without having to use dd?  btrfs-map-logical does this now, 
but not via the search ioctl and not by filename.

say:

btrfs inspect physical-find -c <copy number> -o <output file> <filename> 
offset

Looks like you've open coded btrfs_map_logical() below, getting output 
from the search ioctl.  Dave might want that in a more centralized place.

Also, please turn:

for(;;)
     if (foo) {
	statements
     }

Into

for(;;) {
     if (foo) {
         statements
     }
}

I find that much less error prone.

-chris
