Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49879 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab2JVUea (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 16:34:30 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1151631eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 13:34:29 -0700 (PDT)
Message-ID: <5085ADF6.6050603@gmail.com>
Date: Mon, 22 Oct 2012 22:35:02 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: device delete, error removing device
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <50857C8F.9030401@gmail.com> <E9CD3D97-968D-4475-A699-95D803210DF1@colorremedies.com> <20121022195002.GB25498@carfax.org.uk>
In-Reply-To: <20121022195002.GB25498@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-22 21:50, Hugo Mills wrote:
>>>>> It's more like a balance which moves everything that has
>>>>> some (part of its) existence on a device. So when you have
>>>>> RAID-0 or RAID-1 data, all of the related chunks on other
>>>>> disks get moved too (so in RAID-1, it's the mirror chunk as
>>>>> well as the chunk on the removed disk that gets
>>>>> rewritten).
>>> 
>>> Does this mean "device delete" depends on an ability to make
>>> writes to the device being removed? I immediately think of SSD
>>> failures, which seem to fail writing, while still being able to
>>> reliably read. Would that behavior inhibit the ability to
>>> remove the device from the volume?
> No, the device being removed isn't modified at all. (Which causes 
> its own set of weird problemettes, but I think most of those have
> gone away).

IIRC, when a device is deleted, the 1st superblock is zeroed.
Moreover btrfs needs to be able to read the device in order to delete
it. Of course these rules aren't applied when a device is classified
as "missing".

See the function btrfs_rm_device() in fs/btrfs/volumes.c for the details.

> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
