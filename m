Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:32952 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbbCQP1b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 11:27:31 -0400
Received: by ykek76 with SMTP id k76so5173734yke.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 08:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55066339.4060708@cn.fujitsu.com>
References: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<1423563845-9103-4-git-send-email-yangds.fnst@cn.fujitsu.com>
	<54DDC62D.4070206@cn.fujitsu.com>
	<54EEB798.1070105@cn.fujitsu.com>
	<54F5988C.4020905@cn.fujitsu.com>
	<54F5BE84.7090202@fb.com>
	<20150303202057.GU21790@wotan.suse.de>
	<55066339.4060708@cn.fujitsu.com>
Date: Tue, 17 Mar 2015 23:27:30 +0800
Message-ID: <CA+qeAOoBNehH6NPaYbTdJ72Cmo5gB42t5K49cFKm9dRjDed2zQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: qgroup: fix a wrong parameter of no_quota.
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okey, I found a patch from Mark 35 weeks ago which was not merged into xfstest:

[PATCH] xfstests/btrfs: add test for quota groups and drop snapshot

It looks can answer my question here.

Thanx
Yang

On Mon, Mar 16, 2015 at 12:59 PM, Dongsheng Yang
<yangds.fnst@cn.fujitsu.com> wrote:
> On 03/04/2015 04:20 AM, Mark Fasheh wrote:
>>
>> On Tue, Mar 03, 2015 at 09:00:36AM -0500, Josef Bacik wrote:
>>>
>>> On 03/03/2015 06:18 AM, Dongsheng Yang wrote:
>>>>
>>>> On 02/26/2015 02:05 PM, Dongsheng Yang wrote:
>>>>>
>>>>> Wait a minute, this patch seems not working well in accounting quota
>>>>> number when
>>>>> deleting data shared by different subvolumes.
>>>>>
>>>>> I will investigate more about it and send a V2 out.
>>>>
>>>> I have sent a fstest
>>>>    [PATCH] fstest: btrfs: add a test for quota number when deleting a
>>>> subvol.
>>>> for this problem I was trying to solve in this patch.
>>>>
>>>> Please consider reverting the two commits introduced the problem:
>>>>
>>>> e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
>>>> 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
>>>>
>>> We aren't reverting these two commits, what we had was worse before than
>>> it
>>> is now.  We need to figure out why this is resulting in problems and fix
>>> that rather than throwing out a whole bunch of work.  Thanks,
>>
>> Agreed, reverting these would re-introduce far more problems than it would
>> solve.
>
>
> Hi Josef and Mark,
>
> Sorry for the late.
>
> Thanx for your reply and sorry I am not clear about the "far more problems".
>
> From the result below, I saw there are some diff reports in V4.0-rc1 and
> when I
> revert these two commits. It's consistent now.
>
> But I think there must be something I am missing.  I am glad to investigate
> more
> about it and solve it. But at first I need to know what's the problem
> SUBTREE is
> trying to solve.
>
> Example:
> mkfs.btrfs  /dev/sdc -f
> mount /dev/sdc /mnt
> btrfs quota enable /mnt
> btrfs sub create /mnt/sub
> dd if=/dev/zero of=/mnt/sub/data bs=1024 count=1000
> btrfs sub snapshot /mnt/sub /mnt/snap
> btrfs qgroup create 1/1 /mnt
> btrfs qgroup assign 0/257 1/1 /mnt
> btrfs quota rescan -w /mnt
> sync
> btrfs sub delete /mnt/sub
> -----------------------          <-------------wait for cleaner_kthread.
> btrfs qgroup show /mnt
> umount /mnt
> btrfs check --qgroup-report /dev/sdc |grep diff
>
> Result:
> (1). V4.0-rc1
> # btrfs qgroup show /mnt
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          16.00KiB     16.00KiB
> 0/257      1000.00KiB        0.00B
> 0/258      1016.00KiB   1016.00KiB
> 1/1        1000.00KiB        0.00B
> # btrfs check --qgroup-report /dev/sdc |grep diff
> Counts for qgroup id: 257 are different
> diff:        referenced -1024000 referenced compressed -1024000
> Counts for qgroup id: 281474976710657 are different
> diff:        referenced -1024000 referenced compressed -1024000
>
> (2). V4.0-rc1 with reverts of "96c92f" and "c04cad"
> # btrfs qgroup show /mnt
> qgroupid         rfer         excl
> --------         ----         ----
> 0/5          16.00KiB     16.00KiB
> 0/257           0.00B        0.00B
> 0/258      1016.00KiB   1016.00KiB
> 1/1             0.00B        0.00B
> # btrfs check --qgroup-report /dev/sdc |grep diff
> #
> *No diff in btrfs check --qgroup-report*
>
>
> Thanx
>>
>>         --Mark
>>
>> --
>> Mark Fasheh
>> .
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
