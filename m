Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbeBSE2b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Feb 2018 23:28:31 -0500
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
To: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d8289a56-5874-dfe9-60fd-72b3c06b1664@oracle.com>
Date: Mon, 19 Feb 2018 12:29:59 +0800
MIME-Version: 1.0
In-Reply-To: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/14/2018 10:19 PM, Tomasz Chmielewski wrote:
> Just FYI, how dangerous running btrfs can be - we had a fatal, 
> unrecoverable MySQL corruption when btrfs decided to do one of these "I 
> have ~50 GB left, so let's do out of space (and corrupt some files at 
> the same time, ha ha!)".

  Thanks for reporting.

> Running btrfs RAID-1 with kernel 4.14.

  Can you pls let us know..
  1. What tool cli/reported/identified that data is corrupted?
  2. Disk error stat using.. btrfs dev stat <mnt>
     (dev stat is stored on disk)
  3. Wheather the disk was mounted as degraded any time before?

Thanks, Anand
