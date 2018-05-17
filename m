Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751375AbeEQCaD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 22:30:03 -0400
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0ff3604a-4d67-4421-560f-40a87fe4001d@oracle.com>
Date: Thu, 17 May 2018 10:32:29 +0800
MIME-Version: 1.0
In-Reply-To: <20180516223523.GG6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/17/2018 06:35 AM, David Sterba wrote:
> On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
>> Not yet ready for the integration. As I need to introduce
>> -o no_read_mirror_policy instead of -o read_mirror_policy=-<devid>
> 
> Mount option is mostly likely not the right interface for setting such
> options, as usual.

  I am ok to make it ioctl for the final. What do you think?


  But to reproduce the bug posted in
    Btrfs: fix the corruption by reading stale btree blocks
  It needs to be a mount option, as randomly the pid can
  still pick the disk specified in the mount option.

-Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
