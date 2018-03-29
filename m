Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeC2KR5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 06:17:57 -0400
Subject: Re: [PATCH v2 6/8] btrfs: verify superblock checksum during scan
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180327234000.23656-1-anand.jain@oracle.com>
 <20180327234000.23656-7-anand.jain@oracle.com>
 <13c339bb-1beb-45e0-6504-dde4d2e806b5@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a406e066-c30e-d060-9627-d5666257ed75@oracle.com>
Date: Thu, 29 Mar 2018 18:17:41 +0800
MIME-Version: 1.0
In-Reply-To: <13c339bb-1beb-45e0-6504-dde4d2e806b5@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/28/2018 03:21 PM, Nikolay Borisov wrote:
> 
> 
> On 28.03.2018 02:39, Anand Jain wrote:
>> During the scan context, we aren't verifying the superblock-
>> checksum when read.
>> This patch fixes it by adding the checksum verification function
>> btrfs_check_super_csum() in the function btrfs_read_disk_super().
>> And makes device scan to error fail if the primary superblock csum
>> is wrong, whereas if the copy-superblock csum is wrong it will just
>> just report mismatch and continue mount/scan as usual. When the
> 
> Where in this patch do you deal with the secondary sb.


> btrfs_read_disk_super verifies only the primary sb which corresponds to
> the first part of the sentence. But I'm confused about the second?

  btrfs_read_disk_super() actaully reads and csum verifies the copy_num 
as provided.

         bytenr = btrfs_sb_offset(copy_num);

> I also think that 4/8 should be merged into this one.

  Right. I can do that.

Thanks, Anand
