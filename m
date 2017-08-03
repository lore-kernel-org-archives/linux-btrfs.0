Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:43398 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751079AbdHCLoM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 07:44:12 -0400
Subject: Re: Massive loss of disk space
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Cc: kreijack@inwind.it, pwm <pwm@iapetus.neab.net>,
        Hugo Mills <hugo@carfax.org.uk>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
 <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <e8abbe21-8cde-1650-8012-9b20a3fcfeec@rqc.ru>
Date: Thu, 3 Aug 2017 14:44:08 +0300
MIME-Version: 1.0
In-Reply-To: <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/17 20:52, Goffredo Baroncelli wrote:
> consider the following scenario:
>
> a) create a 2GB file
> b) fallocate -o 1GB -l 2GB
> c) write from 1GB to 3GB
>
> after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk.
Just curious. With current implementation, in the following case:
a) create a 2GB file1 && create a 2GB file2
b) fallocate -o 1GB -l 2GB file1 && fallocate -o 1GB -l 2GB file2
c) write from 1GB to 3GB file1 && write from 1GB to 3GB file2
will (c) always succeed? I.e. does fallocate really allocate 2GB per 
file, or does it only allocate additional 1GB and check free space for 
another 1GB? If it's only the latter, it is useless.

--

With Best Regards,
Marat Khalili

