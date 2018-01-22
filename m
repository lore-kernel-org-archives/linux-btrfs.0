Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbeAVWBm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 17:01:42 -0500
Subject: Re: [PATCH RESEND v4 0/4] device_list_add() peparation to add
 reappearing missing device
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180118140236.25349-1-anand.jain@oracle.com>
 <20180118174717.GT13726@twin.jikos.cz> <20180119232756.GB15713@twin.jikos.cz>
 <334ef632-a913-372b-a91b-826278329fc3@oracle.com>
 <20180122152642.GG15713@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2b12274d-2d78-061d-b35d-fbe2f35cd0f0@oracle.com>
Date: Tue, 23 Jan 2018 05:52:47 +0800
MIME-Version: 1.0
In-Reply-To: <20180122152642.GG15713@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/22/2018 11:26 PM, David Sterba wrote:
> On Mon, Jan 22, 2018 at 09:31:47PM +0800, Anand Jain wrote:
>>    Problem was mainly due to the patch 3/4, which tried to access the
>>    return pointer even for the failed condition. The fix is to bring the
>>    device point access under the else part as show below [2]. I have
>>    included this fix in V5. Which is tested with btrfs xfstests.
>>    Pls could you consider v5 for 4.16 ?
> 
> Hm ok, thre's still some time to test it. One more fstests report that
> appeared before and also with the v5:

  I will try to nail it down. It passes on bare metal and a VM here.
  btrfs-progs: I am using your latest master at
     (git://github.com/kdave/btrfs-progs.git).


> btrfs/007 4s ...        [16:38:09] [16:38:12] [failed, exit status 1] - output mismatch (see /root/test/mmtests/work/sources/xfstests-git-installed/results//btrfs/007.out.bad)
>      --- tests/btrfs/007.out     2017-09-20 14:24:58.334716658 +0200
>      +++ /root/test/mmtests/work/sources/xfstests-git-installed/results//btrfs/007.out.bad       2018-01-22 16:38:12.883931593 +0100
>      @@ -1,4 +1,5 @@
>       QA output created by 007
>       *** test send / receive
>      -*** done
>      +failed: '/root/test/mmtests/work/sources/xfstests-git-installed/src/fssum -r /tmp/tmp.eZcr17wqNn/incr.fssum /root/test/mmtests/scratch_mnt/incr'

  Looks like fssum on the reverse copied file failed.

>      +(see /root/test/mmtests/work/sources/xfstests-git-installed/results//btrfs/007.full for details)

  Can you pls send me this ?

Thanks, Anand

>       *** unmount
>      ...
>      (Run 'diff -u tests/btrfs/007.out /root/test/mmtests/work/sources/xfstests-git-installed/results//btrfs/007.out.bad'  to see the entire diff)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
