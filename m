Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45165 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387493AbeHGJPH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2018 05:15:07 -0400
Date: Tue, 7 Aug 2018 15:02:03 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH v2 00/12] mkfs: Quota support through -R|--runtime quota
Message-ID: <20180807070203.GA3288@fnst.localdomain>
References: <20171107084259.22367-1-wqu@suse.com>
 <c3643f3f-da0b-0e4c-3bb5-35c09962f409@gmx.com>
 <ef21c72b-c0ca-ee15-e245-5598401817ea@gmx.com>
 <10cc122a-9bee-fd49-f030-ca5ad65bb330@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <10cc122a-9bee-fd49-f030-ca5ad65bb330@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 30, 2018 at 01:03:00PM +0800, Qu Wenruo wrote:
>Ping the 3rd time?
>
>Or should I just rebase the patchset?

Hi Qu

Could you rebase this patchset? Because I want to test existing test cases
with enabled quota, mkfs_qgroup seems to ease my workload.

-- 
Thanks,
Lu

>
>Thanks,
>Qu
>
>On 2018年03月08日 09:17, Qu Wenruo wrote:
>> Ping again.
>> 
>> Since David is planning to merge qgroup patchset, this feature would
>> greatly improve test coverage.
>> 
>> Thanks,
>> Qu
>> 
>> On 2018年01月11日 14:04, Qu Wenruo wrote:
>>> Ping?
>>>
>>> Or do I need to rebase the patchset?
>>>
>>> Thanks,
>>> Qu
>>>
>>> On 2017年11月07日 16:42, Qu Wenruo wrote:
>>>> Can be fetched from github:
>>>> https://github.com/adam900710/btrfs-progs/tree/mkfs_qgroup
>>>>
>>>> This patchset adds quota support, which means the result fs will have
>>>> quota enabled by default, and its accounting is already consistent, no
>>>> manually rescan or quota enable is needed.
>>>>
>>>> The overall design of such support is:
>>>> 1) Create needed tree
>>>>    Both btrfs_root and real root item and tree root leaf.
>>>>    For this, a new infrastructure, btrfs_create_tree(), is added for
>>>>    this.
>>>>
>>>> 2) Fill quota root with basic skeleton
>>>>    Only 3 items are really needed
>>>>    a) global quota status item
>>>>    b) quota info for specified qgroup
>>>>    c) quota limit for specified qgroup
>>>>
>>>>    Currently only 0/5 qgroup is passed.
>>>>    If we're going to support extra subvolume at mkfs time, just pass the
>>>>    subvolume id into insert_qgroup_items().
>>>>
>>>>    The content doesn't matter at all.
>>>>
>>>> 3) Repair qgroups using infrastructure from qgroup-verify
>>>>    In fact, qgroup repair is just offline rescan.
>>>>    Although the original qgroup-verify infrastructure is mostly noisy,
>>>>    modify it a little to make it silent to function as offline quota
>>>>    rescan.
>>>>
>>>> And such support is mainly designed for developers and QA guys.
>>>>
>>>> As to enable quota, before we must normally mount the fs, enable quota
>>>> (and rescan if needed).
>>>> This ioctl based procedure is not common, and fstests doesn't provide
>>>> such support.
>>>>
>>>> There are several attempts to make fstests to support it, but due to
>>>> different reasons, all these attempts failed.
>>>>
>>>> To make it easier to test all existing test cases with btrfs quota
>>>> enabled, the current best method is to support quota at mkfs time, and
>>>> here comes the patchset.
>>>>
>>>>
>>>> BTW with -R|--runtime-features, we have several possible target to add.
>>>> Not limited to such ioctl based operation, but also mount option based
>>>> ones.
>>>> Like space-cache-tree (space_cache=v2).
>>>>
>>>>
>>>> Qu Wenruo (12):
>>>>   btrfs-progs: qgroup-verify: Also repair qgroup status version
>>>>   btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we
>>>>     should repair qgroups
>>>>   btrfs-progs: qgroup-verify: Move qgroup classification out of
>>>>     report_qgroups
>>>>   btrfs-progs: qgroup-verify: Allow repair_qgroups function to do silent
>>>>     repair
>>>>   btrfs-progs: ctree: Introduce function to create an empty tree
>>>>   btrfs-progs: mkfs: Introduce function to insert qgroup info and limit
>>>>     items
>>>>
>>>>   ^^^ Above patches are not modified at all ^^^
>>>>   vvv Modification starts below vvv
>>>>
>>>>   btrfs-progs: mkfs: Introduce function to setup quota root and rescan
>>>>   btrfs-progs: fsfeatures: Introduce a new set of features,
>>>>     runtime_features
>>>>   btrfs-progs: mkfs: Introduce --runtime-features option
>>>>   btrfs-progs: mkfs: Introduce quota runtime feature
>>>>   btrfs-progs: test/mkfs: Add test case for -R quota option
>>>>   btrfs-progs: test/mkfs: Add test case for --rootdir and -R quota
>>>>
>>>>  Documentation/mkfs.btrfs.asciidoc              |  23 +++
>>>>  cmds-check.c                                   |   2 +-
>>>>  convert/main.c                                 |   4 +-
>>>>  ctree.c                                        | 109 ++++++++++++++
>>>>  ctree.h                                        |   3 +
>>>>  fsfeatures.c                                   | 131 ++++++++++++++---
>>>>  fsfeatures.h                                   |  10 +-
>>>>  mkfs/main.c                                    | 194 ++++++++++++++++++++++---
>>>>  qgroup-verify.c                                |  51 +++++--
>>>>  qgroup-verify.h                                |   2 +-
>>>>  tests/mkfs-tests/001-basic-profiles/test.sh    |  10 ++
>>>>  tests/mkfs-tests/010-rootdir-and-quota/test.sh |  51 +++++++
>>>>  12 files changed, 529 insertions(+), 61 deletions(-)
>>>>  create mode 100755 tests/mkfs-tests/010-rootdir-and-quota/test.sh
>>>>
>>>
>> 
>


