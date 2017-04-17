Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33284 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752861AbdDQLxN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 07:53:13 -0400
Received: by mail-io0-f181.google.com with SMTP id k87so128146951ioi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 04:53:13 -0700 (PDT)
Subject: Re: Btrfs/SSD
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
Date: Mon, 17 Apr 2017 07:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-14 07:02, Imran Geriskovan wrote:
> Hi,
> Sometime ago we had some discussion about SSDs.
> Within the limits of unknown/undocumented device infos,
> we loosely had covered data retension capability/disk age/life time
> interrelations, (in?)effectiveness of btrfs dup on SSDs, etc..
>
> Now, as time passed and with some accumulated experience on SSDs
> I think we again can have a status check/update on them if you
> can share your experiences and best practices.
>
> So if you have something to share about SSDs (it may or may not be
> directly related with btrfs) I'm sure everybody here will be happy to
> hear it.

General info (not BTRFS specific):
* Based on SMART attributes and other factors, current life expectancy 
for light usage (normal desktop usage) appears to be somewhere around 
8-12 years depending on specifics of usage (assuming the same workload, 
F2FS is at the very top of the range, BTRFS and NILFS2 are on the upper 
end, XFS is roughly in the middle, ext4 and NTFS are on the low end 
(tested using Windows 7's NTFS driver), and FAT32 is an outlier at the 
bottom of the barrel).
* Queued DISCARD support is still missing in most consumer SATA SSD's, 
which in turn makes the trade-off on those between performance and 
lifetime much sharper.
* Modern (2015 and newer) SSD's seem to have better handling in the FTL 
for the journaling behavior of filesystems like ext4 and XFS.  I'm not 
sure if this is actually a result of the FTL being better, or some 
change in the hardware.
* In my personal experience, Intel, Samsung, and Crucial appear to be 
the best name brands (in relative order of quality).  I have personally 
had bad experiences with SanDisk and Kingston SSD's, but I don't have 
anything beyond circumstantial evidence indicating that it was anything 
but bad luck on both counts.

Regarding BTRFS specifically:
* Given my recently newfound understanding of what the 'ssd' mount 
option actually does, I'm inclined to recommend that people who are 
using high-end SSD's _NOT_ use it as it will heavily increase 
fragmentation and will likely have near zero impact on actual device 
lifetime (but may _hurt_ performance).  It will still probably help with 
mid and low-end SSD's.
* Files with NOCOW and filesystems with 'nodatacow' set will both hurt 
performance for BTRFS on SSD's, and appear to reduce the lifetime of the 
SSD.
* Compression should help performance and device lifetime most of the 
time, unless your CPU is fully utilized on a regular basis (in which 
case it will hurt performance, but still improve device lifetimes).
