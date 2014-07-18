Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44276 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761082AbaGRKe5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 06:34:57 -0400
Message-ID: <53C8F720.4040803@cn.fujitsu.com>
Date: Fri, 18 Jul 2014 18:29:52 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kevin Brandstatter <icarusthecow@gmail.com>
Subject: Re: [BUG] "Quota Ignored On write" problem still exist with 3.16-rc5
References: <53C8DEB0.1060404@jp.fujitsu.com>
In-Reply-To: <53C8DEB0.1060404@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2014 04:45 PM, Satoru Takeuchi wrote:
> Hi Josef, Chris,
>
> I found "Quota Ignored On write" problem still exist with 3.16-rc5,
> which Kevin reported before.
>
> Kevin's report:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35292.html
>
> The result of bisect:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35304.html
I guess this is because Josef's patch delayed qgroup accounting, it will
cause @refer and @excl updating very late...

The patch maybe optimize to merge some delayed refs(for example), but
it updates qgroup accounting when commiting transaction which will be
very late,
we may have accumulated many data..

Thanks,
Wang
>
>> I bisected and found the bad commit is the following patch.
>>
>> ===============================================================================
>> commit fcebe4562dec83b3f8d3088d77584727b09130b2
>> Author: Josef Bacik <jba...@fb.com>
>> Date:   Tue May 13 17:30:47 2014 -0700
>>
>>     Btrfs: rework qgroup accounting
>> ===============================================================================
>>
>> Josef, please take a look at this patch.
> Reproducer:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35299.html
>
> Could you tell me the progress of fixing this bug?
> In addition, could you fix it by 3.16?
>
> command log:
> ===============================================================================
> # ./test.sh
> + uname -a
> Linux luna.soft.fujitsu.com 3.16.0-rc5 #2 SMP Tue Jul 15 13:39:46 JST 2014 x86_64 x86_64 x86_64 GNU/Linux
> + df -T /test7
> Filesystem     Type  1K-blocks  Used Available Use% Mounted on
> /dev/sdc7      btrfs  29296640  1536  27169536   1% /test7
> + btrfs quota ena /test7
> + cd /test7
> + btrfs sub cre test
> Create subvolume './test'
> + btrfs sub l -a /test7
> ID 270 gen 66 top level 5 path test
> + btrfs qg lim 1G test                          # limit test subvol to 1GB
> + btrfs qg show -pcre /test7
> qgroupid rfer  excl  max_rfer   max_excl parent  child
> -------- ----  ----  --------   -------- ------  -----
> 0/5      16384 16384 0          0        ---     ---
> 0/270    16384 16384 1073741824 0        ---     ---
> + dd if=/dev/zero of=test/file0 bs=1M count=2000
> 2000+0 records in
> 2000+0 records out
> 2097152000 bytes (2.1 GB) copied, 9.67876 s, 217 MB/s   # write 2GB. It's a bug!
> + sync
> + ls -lisaR /test7
> /test7:
> total 20
> 256 16 drwxr-xr-x   1 root root    8 Jul 18 15:12 .
>   2  4 drwxr-xr-x. 43 root root 4096 Jul 16 08:34 ..
> 256  0 drwxr-xr-x   1 root root   10 Jul 18 15:17 test
>
> /test7/test:
> total 2048016
> 256       0 drwxr-xr-x 1 root root         10 Jul 18 15:17 .
> 256      16 drwxr-xr-x 1 root root          8 Jul 18 15:12 ..
> 257 2048000 -rw-r--r-- 1 root root 2097152000 Jul 18 15:17 file0
> + btrfs qg show -pcre /test7
> qgroupid rfer       excl       max_rfer   max_excl parent  child
> -------- ----       ----       --------   -------- ------  -----
> 0/5      16384      16384      0          0        ---     ---
> 0/270    2097168384 2097168384 1073741824 0        ---     ---
> + btrfs quota dis /test7
> + btrfs sub del test
> Transaction commit: none (default)
> Delete subvolume '/test7/test'
> + set +x
> #
> ===============================================================================
>
>   NOTE:
>   The reproducer here (./test.sh) is a bit different from above-mentioned
>   one because of some reason.
>
> Thanks,
> Satoru
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

