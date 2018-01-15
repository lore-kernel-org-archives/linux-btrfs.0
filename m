Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30892 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752534AbeAOCAA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 21:00:00 -0500
Date: Mon, 15 Jan 2018 09:59:52 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180115015952.GA523@fnst.localdomain>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 15, 2018 at 09:26:27AM +0800, Qu Wenruo wrote:
>
>
>On 2018年01月15日 00:38, Sebastian Andrzej Siewior wrote:
>> On 2018-01-14 08:36:41 [+0800], Qu Wenruo wrote:
>>> Still needs more. (and maybe even more depending on the output)
>>>
>>> The original mode doesn't report error clear enough, so it would help if
>>> --mode=lowmem can be used.
>>>
>>> # btrfs check --mode=lowmem /dev/sdb4
>> 
>> ~# btrfs check --mode=lowmem /dev/sdb4
>> Checking filesystem on /dev/sdb4
>> UUID: b3bfb56e-d445-4335-93f0-c1fb2d1f6df1
>> checking extents
>> checking free space cache
>> Wanted bytes 4096, found 8192 for off 159178047488
>> Wanted bytes 1073725440, found 8192 for off 159178047488
>> cache appears valid but isn't 159178031104
>> ERROR: errors found in free space cache
>
>A new bug is exposed for lowmem mode.
>It doesn't check fs tree if space cache has any problem.
>

Just a reminder, the problem is not only for lowmem mode.

        ret = check_space_cache(root);
        err |= !!ret;
        if (ret) {
                if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
                        error("errors found in free space tree");
                else
                        error("errors found in free space cache");
                goto out;
                ^^^
        }

        /*
         * We used to have to have these hole extents in between our real
         * extents so if we don't have this flag set we need to make sure there
         * are no gaps in the file extents for inodes, otherwise we can just
         * ignore it when this happens.
         */
        no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
        ret = do_check_fs_roots(info, &root_cache);
              ^^^
        err |= !!ret;
        if (ret) {
                error("errors found in fs roots");
                goto out;
        }

-- 
Thanks,
Lu

>> found 63691210752 bytes used, error(s) found
>> total csum bytes: 61339388
>> total tree bytes: 860540928
>> total fs tree bytes: 688816128
>> total extent tree bytes: 84549632
>> btree space waste bytes: 224428280
>> file data blocks allocated: 62890483712
>>  referenced 62828957696
>> 


