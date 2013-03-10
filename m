Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46162 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3CJNQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 09:16:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
Subject: Re: [PATCH V3][BTRFS-PROGS] Enhance btrfs fi df with raid5/6 support
Date: Sun, 10 Mar 2013 14:16:02 +0100
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com> (sfid-20130310_140722_430440_73B14E31)
In-Reply-To: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303101416.02781.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 10. März 2013 schrieb Goffredo Baroncelli:
> Hi all, 

Hi Goffredo,

> This is the third attempt of my patches related to show how the data
> are stored in a btrfs filesystem. I rebased all the patches on the latest
> mason git. I tried to address the Zach concern abou the using of
> the string_list_add() in the df_pretty_sizes(): string_list_add() is
> removed from the df_pretty_sizes() and I created the new function 
> sla_pretty_sizes() which calls df_pretty_sizes() and string_list_add().

Thanks for your new round of patches.

> Unfortunately I noticed a regression which passed all the reviews until
> now: the command btrfs fi df previous didn't require the root
> capability, now with my patches it is required, because I need to know
> some info about the chunks so I need to use the "BTRFS_IOC_TREE_SEARCH".
> 
> I think that there are the following possibilities:
> 1) accept this regresssion
> 2) remove the command "btrfs fi df" and leave only "btrfs fi disk-usage"
> and "btrfs dev disk-usage"
> 3) adding a new ioctl which could be used without root capability. Of
> course this ioctl would return only a subset of the
> BTRFS_IOC_TREE_SEARCH info
> 
> I think that the 3) would be the "long term" solution. I am not happy
> about the 1), so as "short term solution" I think that we should go with
> the 2). What do you think ?

Uhm, but exactly the new btrfs fi df contains a good overview:

> Below the description of the patches.
> 
> --
> 
> These patches update the btrfs fi df command and add two new commands:
> - btrfs filesystem disk-usage <path>
> - btrfs device disk-usage <path>
> 
> The command "btrfs filesystem df" now shows only the disk
> usage/available.
> 
> $ sudo btrfs filesystem df /mnt/btrfs1/
> Disk size:               400.00GB
> Disk allocated:            8.04GB
> Disk unallocated:        391.97GB
> Used:                     11.29MB
> Free (Estimated):        250.45GB       (Max: 396.99GB, min: 201.00GB)
> Data to disk ratio:          63 %
> 
> The "Free (Estimated)" tries to give an estimation of the free space
> on the basis of the chunks usage. Max and min are the maximum allowable
> space (if the next chunk are allocated as SINGLE) or the minimum one (
> if the next chunks are allocated as DUP/RAID1/RAID10).

What information fi df can´t display without root permissions? Maybe its
okay to just omit it for now if being run as user or display a "run as root" 
hint instead?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
