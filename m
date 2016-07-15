Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:45954 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbcGOQWJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 12:22:09 -0400
Reply-To: kreijack@inwind.it
Subject: Re: New btrfs sub command: btrfs inspect physical-find
References: <7c20be09-1ac2-1d1f-f545-e2d56578a77b@libero.it>
 <16994642-2a2f-55fa-c683-7153977f4577@fb.com>
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: David Sterba <dsterba@suse.cz>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <de79e38e-7d1f-f08a-0b70-c2fb299b5200@inwind.it>
Date: Fri, 15 Jul 2016 18:22:05 +0200
MIME-Version: 1.0
In-Reply-To: <16994642-2a2f-55fa-c683-7153977f4577@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-14 23:45, Chris Mason wrote:
> 
> 
> On 07/12/2016 05:40 PM, Goffredo Baroncelli wrote:
>> Hi All,
>> 
>> the enclosed patch adds a new btrfs sub command: "btrfs inspect
>> physical-find". The aim of this new command is to show the physical
>> placement on the disk of a file. Currently it handles all the
>> profiles (single, dup, raid1/10/5/6). I develop this command in
>> order to show some bug in btrfs RAID5 profile (see next email).
> 
> I've done this manually from time to time, and love the idea of
> having a helper for it.  Can I talk you into adding a way to save the
> contents of the block without having to use dd?  btrfs-map-logical
> does this now, but not via the search ioctl and not by filename.
> 
> say:
> 
> btrfs inspect physical-find -c <copy number> -o <output file> <filename> offset

I prefer to add another command to do that (like btrfs insp physical-dump). And I will add as constraint like 
	offset % blocksize == 0
this in order to avoid handling data spread different stripes/chunks.

However <copy number> has different meaning:

single/raid0 -> means nothing
raid1/raid10 -> means the copy #
raid5/raid6  -> could mean the parity: i.e.
	-1 -> first parity (raid5/raid6)
	-2 -> 2nd parity (raid6 only)
 
> Looks like you've open coded btrfs_map_logical() below, getting
> output from the search ioctl.  Dave might want that in a more
> centralized place.

I will give a look 

 
> Also, please turn:
> 
> for(;;) if (foo) { statements }
> 
> Into
> 
> for(;;) { if (foo) { statements } }
> 
> I find that much less error prone.

Ok

> 
> -chris
> 
BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
