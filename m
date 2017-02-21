Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:36918
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbdBUKPO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 05:15:14 -0500
Date: Tue, 21 Feb 2017 15:44:01 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Large no.of extents for a single small file with a fresh RAID5
 setup
Message-ID: <20170221101401.GA5498@giis.co.in>
References: <20170218020711.GA23608@giis.co.in>
 <678a9608-8f42-119c-7fd3-69fbae31bfab@cn.fujitsu.com>
 <20170220140737.GA27535@giis.co.in>
 <af2aba3e-467d-6546-e9a0-e8bcc460fbd2@cn.fujitsu.com>
 <20170221092215.GA5217@giis.co.in>
 <1b567b5e-8035-33ce-ddd2-2e19065044c6@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1b567b5e-8035-33ce-ddd2-2e19065044c6@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> >I'm using Ubuntu(16.04) desktop version (not server) running Xorg and others. May be its possible its
> >flushing data to disk at constant time. If you like to give it a try again with servers, below is the
> >exact script along with its timing & multiextent output.
> 
> Archlinux here, with my btrfs vm and browser and music player, still one
> extent.
> 
looks like I have better setup to produce single-extent files than yours :-)
> Are you under heavy memory usage?
> 
no, not as per top and free. 'top' shows mem.usage as:
KiB Mem :  7092516 total,  5961796 free,   794836 used,   335884 buff/cache

where 'compiz' process uses around 2.5% of memory and 'free' command reports
almost 5gb as free. May be some 'sysctl' or others needs to be adjusted on my setup?
> >
> >one more curious thing, is it fine to have extents with size 4096 on RAID5 setup?
> >
> 
> Sure, why not?
> 
> Any size aligned to sector size is valid, no matter the profile.
> 
> For 4K extent, RAID5/6 will do read-modify-write, which is very common.
> 
> Thanks,
> Qu
> 
While looking into mapping from logical->physical chunks on RAID5. I was wondering 
how these 4KB extents will fit into 64KB data-stripe?

I didn't have idea about read-modify-write, just found few wiki links on it, will 
check. thanks

Cheers.
Lakshmipathi.G

