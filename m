Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24007 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbcIIAg3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Sep 2016 20:36:29 -0400
Subject: Re: Another 4.8-rc locked splat: btrfs_close_devices()
To: Ilya Dryomov <idryomov@gmail.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
References: <CAOi1vP_9gd7XVi8acnj9SpSZoKuJnSC6ShoU8HSF=5fBH4Mv0w@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <36933898-3295-a9ae-aefd-3483333743dc@oracle.com>
Date: Fri, 9 Sep 2016 08:38:12 +0800
MIME-Version: 1.0
In-Reply-To: <CAOi1vP_9gd7XVi8acnj9SpSZoKuJnSC6ShoU8HSF=5fBH4Mv0w@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the report Ilya.

Yep. Have seen similar issues during hotspare fixes as well.
Where the vfs call to btrfs_show_devname() and its
device_list_mutex lock is conflicting. One of that is fixed
here.

------
779bf3fefa835cb52a07457c8acac6f2f66f2493
     btrfs: fix lock dep warning, move scratch dev out of 
device_list_mutex and uuid_mutex
------

I was kind of expecting this here as well when wrote 142388194191.
However couldn't reproduce.

To fix this permanently, I see the following choices,

Chris/David,

  1. Do you think device_list_mutex is needed at btrfs_show_devname()
  or rcu should suffice. ?

  2. To me the roles of fs_info->volume_mutex can be replaced with
  device_list_mutex. Any idea, if I am missing something ?

Thanks, Anand


On 09/08/2016 10:34 PM, Ilya Dryomov wrote:
> Hello,
>
> This one seems to have appeared after Anand's commit
> 142388194191 ("btrfs: do not background blkdev_put()") got merged into
> 4.8-rc4.
>
> Thanks,
>
>                 Ilya
>
