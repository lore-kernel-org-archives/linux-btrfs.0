Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57008 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964921AbeF1NVa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 09:21:30 -0400
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Remi Gauvin <remi@georgianit.com>, linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
Date: Thu, 28 Jun 2018 21:24:34 +0800
MIME-Version: 1.0
In-Reply-To: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/28/2018 09:42 AM, Remi Gauvin wrote:
> There seems to be a major design flaw with BTRFS that needs to be better
> documented, to avoid massive data loss.
> 
> Tested with Raid 1 on Ubuntu Kernel 4.15
> 
> The use case being tested was a Virtualbox VDI file created with
> NODATACOW attribute, (as is often suggested, due to the painful
> performance penalty of COW on these files.)
> 
> However, if a device is temporarily dropped (this in case, tested by
> disconnecting drives.) and re-connects automatically next boot, BTRFS
> does not in any way synchronize the VDI file, or have any means to know
> that one of copy is out of date and bad.
> 
> The result of trying to use said VDI file is.... interestingly insane.


> Scrub did not do anything to rectify the situation.

  Please use Balance to rectify as its RAID1. Because when one of the
  device was missing we wrote Single Chunks.

Thanks, Anand
