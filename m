Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56572 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750736AbbCPFDR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 01:03:17 -0400
Message-ID: <55066339.4060708@cn.fujitsu.com>
Date: Mon, 16 Mar 2015 12:59:37 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com> <54DDC62D.4070206@cn.fujitsu.com> <54EEB798.1070105@cn.fujitsu.com> <54F5988C.4020905@cn.fujitsu.com> <54F5BE84.7090202@fb.com> <20150303202057.GU21790@wotan.suse.de>
In-Reply-To: <20150303202057.GU21790@wotan.suse.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/04/2015 04:20 AM, Mark Fasheh wrote:
> On Tue, Mar 03, 2015 at 09:00:36AM -0500, Josef Bacik wrote:
>> On 03/03/2015 06:18 AM, Dongsheng Yang wrote:
>>> On 02/26/2015 02:05 PM, Dongsheng Yang wrote:
>>>> Wait a minute, this patch seems not working well in accounting quota
>>>> number when
>>>> deleting data shared by different subvolumes.
>>>>
>>>> I will investigate more about it and send a V2 out.
>>> I have sent a fstest
>>>    [PATCH] fstest: btrfs: add a test for quota number when deleting a
>>> subvol.
>>> for this problem I was trying to solve in this patch.
>>>
>>> Please consider reverting the two commits introduced the problem:
>>>
>>> e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
>>> 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
>>>
>> We aren't reverting these two commits, what we had was worse before than it
>> is now.  We need to figure out why this is resulting in problems and fix
>> that rather than throwing out a whole bunch of work.  Thanks,
> Agreed, reverting these would re-introduce far more problems than it would
> solve.

Hi Josef and Mark,

Sorry for the late.

Thanx for your reply and sorry I am not clear about the "far more 
problems".

 From the result below, I saw there are some diff reports in V4.0-rc1 
and when I
revert these two commits. It's consistent now.

But I think there must be something I am missing.  I am glad to 
investigate more
about it and solve it. But at first I need to know what's the problem 
SUBTREE is
trying to solve.

Example:
mkfs.btrfs  /dev/sdc -f
mount /dev/sdc /mnt
btrfs quota enable /mnt
btrfs sub create /mnt/sub
dd if=/dev/zero of=/mnt/sub/data bs=1024 count=1000
btrfs sub snapshot /mnt/sub /mnt/snap
btrfs qgroup create 1/1 /mnt
btrfs qgroup assign 0/257 1/1 /mnt
btrfs quota rescan -w /mnt
sync
btrfs sub delete /mnt/sub
-----------------------          <-------------wait for cleaner_kthread.
btrfs qgroup show /mnt
umount /mnt
btrfs check --qgroup-report /dev/sdc |grep diff

Result:
(1). V4.0-rc1
# btrfs qgroup show /mnt
qgroupid         rfer         excl
--------         ----         ----
0/5          16.00KiB     16.00KiB
0/257      1000.00KiB        0.00B
0/258      1016.00KiB   1016.00KiB
1/1        1000.00KiB        0.00B
# btrfs check --qgroup-report /dev/sdc |grep diff
Counts for qgroup id: 257 are different
diff:        referenced -1024000 referenced compressed -1024000
Counts for qgroup id: 281474976710657 are different
diff:        referenced -1024000 referenced compressed -1024000

(2). V4.0-rc1 with reverts of "96c92f" and "c04cad"
# btrfs qgroup show /mnt
qgroupid         rfer         excl
--------         ----         ----
0/5          16.00KiB     16.00KiB
0/257           0.00B        0.00B
0/258      1016.00KiB   1016.00KiB
1/1             0.00B        0.00B
# btrfs check --qgroup-report /dev/sdc |grep diff
#
*No diff in btrfs check --qgroup-report*


Thanx
> 	--Mark
>
> --
> Mark Fasheh
> .
>

