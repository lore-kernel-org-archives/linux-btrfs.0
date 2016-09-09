Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24646 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbcIIIb0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 04:31:26 -0400
Subject: Re: Another 4.8-rc locked splat: btrfs_close_devices()
To: Ilya Dryomov <idryomov@gmail.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
References: <CAOi1vP_9gd7XVi8acnj9SpSZoKuJnSC6ShoU8HSF=5fBH4Mv0w@mail.gmail.com>
 <36933898-3295-a9ae-aefd-3483333743dc@oracle.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cd34d188-e75a-3251-10df-70917836e721@oracle.com>
Date: Fri, 9 Sep 2016 16:33:01 +0800
MIME-Version: 1.0
In-Reply-To: <36933898-3295-a9ae-aefd-3483333743dc@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  Looks like we need to take time to clean up device_list_mutex,
  chunk_mutex, volume_mutex and rcu. As of now I have sent out,
      [PATCH] btrfs: fix a possible umount deadlock

  This has passed xfstests/btrfs.

Thanks, Anand

On 09/09/2016 08:38 AM, Anand Jain wrote:
>
> Thanks for the report Ilya.
>
> Yep. Have seen similar issues during hotspare fixes as well.
> Where the vfs call to btrfs_show_devname() and its
> device_list_mutex lock is conflicting. One of that is fixed
> here.
>
> ------
> 779bf3fefa835cb52a07457c8acac6f2f66f2493
>     btrfs: fix lock dep warning, move scratch dev out of
> device_list_mutex and uuid_mutex
> ------
>
> I was kind of expecting this here as well when wrote 142388194191.
> However couldn't reproduce.
>
> To fix this permanently, I see the following choices,
>
> Chris/David,
>
>  1. Do you think device_list_mutex is needed at btrfs_show_devname()
>  or rcu should suffice. ?
>
>  2. To me the roles of fs_info->volume_mutex can be replaced with
>  device_list_mutex. Any idea, if I am missing something ?
>
> Thanks, Anand
>
>
> On 09/08/2016 10:34 PM, Ilya Dryomov wrote:
>> Hello,
>>
>> This one seems to have appeared after Anand's commit
>> 142388194191 ("btrfs: do not background blkdev_put()") got merged into
>> 4.8-rc4.
>>
>> Thanks,
>>
>>                 Ilya
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
