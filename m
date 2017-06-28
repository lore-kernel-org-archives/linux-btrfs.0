Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7996 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdF1Bbg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 21:31:36 -0400
Date: Wed, 28 Jun 2017 09:31:22 +0800
From: Dai Xiang <xiangx.dai@intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: generic/015 run failed with btrfs
Message-ID: <20170628013122.GA7292@localhost>
References: <F0E6DFCE2B6C644393F2574FF351D65BB2321B@SHSMSX101.ccr.corp.intel.com>
 <20170627200917.GA7736@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170627200917.GA7736@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 01:09:17PM -0700, Darrick J. Wong wrote:
>[cc linux-btrfs, drop linux-xfs cc]
Thank you very much, but another question is that i do not know who to
send while i directly send to linux-btrfs has been rejected.

>On Tue, Jun 27, 2017 at 07:42:16AM +0000, Dai, XiangX wrote:
>> Hi! I test on my host and find this issue, i want to know how can fix it?
>> 
>> root@localhost ~/xfstests# ./check generic/015
>> FSTYP         -- btrfs
>
>                   ^^^^^ please contact the btrfs list, not the xfs list.
>
>--D
>
>> PLATFORM      -- Linux/x86_64 localhost 4.12.0-rc6
>> MKFS_OPTIONS  -- /dev/sda6
>> MOUNT_OPTIONS -- /dev/sda6 /fs/scratch
>> 
>> generic/015     - output mismatch (see ~/xfstests/results//generic/015.out.bad)
>>     --- tests/generic/015.out    2017-05-31 18:15:23.000000000 +0800
>>     +++ ~/xfstests/results//generic/015.out.bad    2017-06-26 14:41:53.265215409 +0800
>>     @@ -1,7 +1,778 @@
>>     +++ basename ./tests/generic/015
>>     ++ seq=015
>>     ++ seqres=~/xfstests/results//generic/015
>>     ++ echo 'QA output created by 015'
>>      QA output created by 015
>>     +++ pwd
>>     ++ here=~/xfstests
>>     ...
>>     (Run 'diff -u tests/generic/015.out ~/xfstests/results//generic/015.out.bad'  to see the entire diff)
>> Ran: generic/015
>> Failures: generic/015
>> Failed 1 of 1 tests
>> 
>> The output is like below:
>> QA output created by 015
>> fill disk:
>>    !!! disk full (expected)
>> check free space:
>> delete fill:
>> check free space:
>>    !!! free space has value of 17348 <===
>> free space is NOT in range 45591.48 .. 46512.52
>> 
>> 
>> I copy the cmd and write to log:
>> 
>> root@localhost ~/xfstests# cat log
>> _df_dir /fs/scratch | /usr/bin/awk '{ print  }'
>> Filesystem     Type  1024-blocks  Used Available Capacity Mounted on
>> /dev/sda6      btrfs       51200 46144     17348      73% /fs/scratch   <===
>> 17348
>> 
>> 
>> Does it means i need to test on a larger machine?
>> 
>> Thanks
>> Dai Xiang
