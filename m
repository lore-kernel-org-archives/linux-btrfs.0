Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37025 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3CJPvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 11:51:21 -0400
Received: by mail-wg0-f43.google.com with SMTP id e12so4219631wge.22
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 08:51:20 -0700 (PDT)
Message-ID: <513CAC59.9020803@gmail.com>
Date: Sun, 10 Mar 2013 16:52:57 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com> (sfid-20130310_140722_430440_73B14E31) <201303101416.02781.Martin@lichtvoll.de>
In-Reply-To: <201303101416.02781.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

On 03/10/2013 02:16 PM, Martin Steigerwald wrote:
> Am Sonntag, 10. März 2013 schrieb Goffredo Baroncelli:
>> Hi all, 
> 
> Hi Goffredo,
> 
>> This is the third attempt of my patches related to show how the data
>> are stored in a btrfs filesystem. I rebased all the patches on the latest
>> mason git. I tried to address the Zach concern abou the using of
>> the string_list_add() in the df_pretty_sizes(): string_list_add() is
>> removed from the df_pretty_sizes() and I created the new function 
>> sla_pretty_sizes() which calls df_pretty_sizes() and string_list_add().
> 
> Thanks for your new round of patches.
> 
>> Unfortunately I noticed a regression which passed all the reviews until
>> now: the command btrfs fi df previous didn't require the root
>> capability, now with my patches it is required, because I need to know
>> some info about the chunks so I need to use the "BTRFS_IOC_TREE_SEARCH".
>>
>> I think that there are the following possibilities:
>> 1) accept this regresssion
>> 2) remove the command "btrfs fi df" and leave only "btrfs fi disk-usage"
>> and "btrfs dev disk-usage"
>> 3) adding a new ioctl which could be used without root capability. Of
>> course this ioctl would return only a subset of the
>> BTRFS_IOC_TREE_SEARCH info
>>
>> I think that the 3) would be the "long term" solution. I am not happy
>> about the 1), so as "short term solution" I think that we should go with
>> the 2). What do you think ?
> 
> Uhm, but exactly the new btrfs fi df contains a good overview:
> 
>> Below the description of the patches.
>>
>> --
>>
>> These patches update the btrfs fi df command and add two new commands:
>> - btrfs filesystem disk-usage <path>
>> - btrfs device disk-usage <path>
>>
>> The command "btrfs filesystem df" now shows only the disk
>> usage/available.
>>
>> $ sudo btrfs filesystem df /mnt/btrfs1/
>> Disk size:               400.00GB
>> Disk allocated:            8.04GB
>> Disk unallocated:        391.97GB
>> Used:                     11.29MB
>> Free (Estimated):        250.45GB       (Max: 396.99GB, min: 201.00GB)
>> Data to disk ratio:          63 %
>>
>> The "Free (Estimated)" tries to give an estimation of the free space
>> on the basis of the chunks usage. Max and min are the maximum allowable
>> space (if the next chunk are allocated as SINGLE) or the minimum one (
>> if the next chunks are allocated as DUP/RAID1/RAID10).
> 
> What information fi df can´t display without root permissions? Maybe its
> okay to just omit it for now if being run as user or display a "run as root" 
> hint instead?

I need the root permission to know how many stripes the raid5/6 chunks
are allocated.
For the RAID1/RAID10/RAID0 the computation of the disk usage by the
stripes was easy. I need to multiply the field " total_bytes" of the
struct btrfs_ioctl_space_args by a factor depending by the kind of RAID
(for example for RAID1 this factor is two: the disk space used is two
times the space available).
Instead for RAID5/6 this value depends by the number of disk at "the
time of the chunk creation". If the chunk was created in a RAID5 with 4
disks, the ratio space available/disk space used is 3/4. If I add
another disk and don't perform a balance, for the old chunk the ration
is 3/4 for a new chunk the ratio become 4/5. To got this information I
need to retrieve the chunk info using the BTRFS_IOC_TREE_SEARCH ioctl.

GB




-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
