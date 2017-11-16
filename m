Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757597AbdKPGzC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 01:55:02 -0500
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
Date: Thu, 16 Nov 2017 08:54:59 +0200
MIME-Version: 1.0
In-Reply-To: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.11.2017 04:18, Qu Wenruo wrote:
> Hi all,
> 
> [Background]
> Recently I'm considering the possibility to use checksum from filesystem
> to enhance device-mapper raid.
> 
> The idea behind it is quite simple, since most modern filesystems have
> checksum for their metadata, and even some (btrfs) have checksum for data.
> 
> And for btrfs RAID1/10 (just ignore the RAID5/6 for now), at read time
> it can use the checksum to determine which copy is correct so it can
> return the correct data even one copy get corrupted.
> 
> [Objective]
> The final objective is to allow device mapper to do the checksum
> verification (and repair if possible).
> 
> If only for verification, it's not much different from current endio
> hook method used by most of the fs.
> However if we can move the repair part from filesystem (well, only btrfs
> supports it yet), it would benefit all fs.
> 
> [What we have]
> The nearest infrastructure I found in kernel is bio_integrity_payload.
> 
> However I found it's bounded to device, as it's designed to support
> SCSI/SATA integrity protocol.
> While for such use case, it's more bounded to filesystem, as fs (or
> higher layer dm device) is the source of integrity data, and device
> (dm-raid) only do the verification and possible repair.
> 
> I'm not sure if this is a good idea to reuse or abuse
> bio_integrity_payload for this purpose.
> 
> Should we use some new infrastructure or enhance existing
> bio_integrity_payload?
> 
> (Or is this a valid idea or just another crazy dream?)
> 

This sounds good in principle, however I think there is one crucial
point which needs to be considered:

All fs with checksums store those checksums in some specific way, then
when they fetch data from disk they they also know how to acquire the
respective checksum. What you suggest might be doable but it will
require lower layers (dm) be aware of how to acquire the specific
checksum for some data. I don't think at this point there is such infra
and frankly I cannot even envision how it will work elegantly. Sure you
can create a dm-checksum target (which I believe dm-verity is very
similar to) that stores checksums alongside data but at this point the
fs is really out of the picture.


> Thanks,
> Qu
> 
