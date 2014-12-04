Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55865 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbaLDD2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 22:28:41 -0500
Message-ID: <547FD4E6.7020108@cn.fujitsu.com>
Date: Thu, 4 Dec 2014 11:28:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Sandy McArthur Jr <sandymac@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: If btrfs-find-root doesn't find tree roots is the filesystem
 lost?
References: <CAPs0BigJG7_Z34iZXdjSQjSkMGi6SOMnbf60_DjYTotrmqYJ8w@mail.gmail.com>
In-Reply-To: <CAPs0BigJG7_Z34iZXdjSQjSkMGi6SOMnbf60_DjYTotrmqYJ8w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: If btrfs-find-root doesn't find tree roots is the filesystem lost?
From: Sandy McArthur Jr <sandymac@gmail.com>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
Date: 2014年12月04日 09:20
> I have a many-disk btrfs filesystem that I cannot access after a
> crash. When I run btrfs-find-root I get lots of "Well block [#] seems
> great [...]" lines but zero "Generation: [...]" lines.
> Is this filesystem lost?
>
>
> Context info below. I'll upgrade to a 3.17.4 kernel soon and try again
> just in case.
>
> mcplex src # uname -a
> Linux mcplex 3.16.5-gentoo #1 SMP Mon Dec 1 22:03:39 EST 2014 x86_64
> Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel GNU/Linux
>
> mcplex src #   btrfs --version
> Btrfs v3.17.2
>
> mcplex src #   btrfs fi show
> parent transid verify failed on 18948425080832 wanted 720141 found 720122
> parent transid verify failed on 18948425080832 wanted 720141 found 720122
> parent transid verify failed on 18948425080832 wanted 720141 found 720122
> parent transid verify failed on 18948425080832 wanted 720141 found 720122
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Label: 'mcmedia'  uuid: 94b3345e-2589-423c-a228-d569bf94ab58
> Total devices 10 FS bytes used 11.38TiB
> devid    1 size 2.73TiB used 2.27TiB path /dev/sdb1
> devid    2 size 2.73TiB used 2.27TiB path /dev/sdc1
> devid    3 size 2.73TiB used 2.27TiB path /dev/sdd1
> devid    5 size 2.73TiB used 2.27TiB path /dev/sde1
> devid    6 size 2.73TiB used 2.27TiB path /dev/sdf1
> devid    7 size 2.73TiB used 2.27TiB path /dev/sdg1
> devid    8 size 3.64TiB used 3.18TiB path /dev/sdh1
> devid    9 size 3.64TiB used 3.18TiB path /dev/sdi1
> devid   10 size 3.64TiB used 1.40TiB path /dev/sdj1
> devid   11 size 3.64TiB used 1.40TiB path /dev/sdk1
>
> Btrfs v3.17.2
>
> [Note: devid #4 isn't there because it was cleanly removed months ago.]
>
> The relevent dmesg output from attempting to access the filesystem
> [85870.630827] BTRFS info (device sdc1): enabling auto recovery
> [85870.630832] BTRFS info (device sdc1): disk space caching is enabled
> [85870.848351] parent transid verify failed on 18948425080832 wanted
> 720141 found 720122
> [85870.848848] parent transid verify failed on 18948425080832 wanted
> 720141 found 720122
> [85870.848852] BTRFS: failed to read tree root on sdc1
> [85870.849365] parent transid verify failed on 18948425080832 wanted
> 720141 found 720122
> [85870.849974] parent transid verify failed on 18948425080832 wanted
> 720141 found 720122
> [85870.849976] BTRFS: failed to read tree root on sdc1
> [85870.850602] parent transid verify failed on 18948423397376 wanted
> 720140 found 720113
> [85870.851228] parent transid verify failed on 18948423397376 wanted
> 720140 found 720113
> [85870.851230] BTRFS: failed to read tree root on sdc1
> [85870.851857] parent transid verify failed on 18948466679808 wanted
> 720139 found 720091
> [85870.852482] parent transid verify failed on 18948466679808 wanted
> 720139 found 720091
> [85870.852485] BTRFS: failed to read tree root on sdc1
> [85870.853120] parent transid verify failed on 18948421505024 wanted
> 720138 found 720122
> [85870.853731] parent transid verify failed on 18948421505024 wanted
> 720138 found 720122
> [85870.853734] BTRFS: failed to read tree root on sdc1
> [85870.985258] BTRFS: open_ctree failed
Only transid error,IMHO it should be recoverable.
>
> mcplex src # btrfs-find-root /dev/sdh1
> Super think's the tree root is at 18948425080832, chunk root 22179840
> Well block 31789056 seems great, but generation doesn't match,
> have=720011, want=720141 level 0
> [many lines similar to the above repeated a lot but no Generation lines]
>
Since it is a transid mismatch problem, it is common since 
btrfs-find-root can't find the root which completely
matches with the transid in btrfs super block.

In that case, btrfs-find-root is a very good help tool to find the real 
root but you need to find it by hand(in 3.17.2).
1. The root node should have the highest level
2. The higher generation, the higher chance the fs can be recovered 
using that root.

Or you can try my patch sent sometimes ago:
https://patchwork.kernel.org/patch/5285521/

With this patch, btrfs-find-root should only output the highest level 
node and sort them with generation,
which can help you find the best tree root.

After you got the possible root bytenr(something like "31789056" in your 
output), with the following patch:
https://patchwork.kernel.org/patch/5206201/

You can pass the bytenr to --tree-root option.
If btrfsck reports no or only small error, you can try btrfsck --repair 
--tree-root <bytenr> to fix it.

Thank,
Qu
