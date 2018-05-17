Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34183 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeEQMZq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 08:25:46 -0400
Received: by mail-io0-f196.google.com with SMTP id p124-v6so1742205iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 05:25:46 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] btrfs: add read mirror policy
To: Anand Jain <anand.jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20180516100359.7752-1-anand.jain@oracle.com>
 <20180516223523.GG6649@twin.jikos.cz>
 <0ff3604a-4d67-4421-560f-40a87fe4001d@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <157ec7fa-e271-ed60-d22b-290db8122734@gmail.com>
Date: Thu, 17 May 2018 08:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <0ff3604a-4d67-4421-560f-40a87fe4001d@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-16 22:32, Anand Jain wrote:
> 
> 
> On 05/17/2018 06:35 AM, David Sterba wrote:
>> On Wed, May 16, 2018 at 06:03:56PM +0800, Anand Jain wrote:
>>> Not yet ready for the integration. As I need to introduce
>>> -o no_read_mirror_policy instead of -o read_mirror_policy=-<devid>
>>
>> Mount option is mostly likely not the right interface for setting such
>> options, as usual.
> 
>   I am ok to make it ioctl for the final. What do you think?
> 
> 
>   But to reproduce the bug posted in
>     Btrfs: fix the corruption by reading stale btree blocks
>   It needs to be a mount option, as randomly the pid can
>   still pick the disk specified in the mount option.
> 
Personally, I'd vote for filesystem property (thus handled through the 
standard `btrfs property` command) that can be overridden by a mount 
option.  With that approach, no new tool (or change to an existing tool) 
would be needed, existing volumes could be converted to use it in a 
backwards compatible manner (old kernels would just ignore the 
property), and you could still have the behavior you want in tests (and 
in theory it could easily be adapted to be a per-subvolume setting if we 
ever get per-subvolume chunk profile support).

Of course, I'd actually like to see most of the mount options available 
as filesystem level properties with the option to override through mount 
options, but that's a lot more ambitious of an undertaking.
