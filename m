Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61902 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750723AbdCaBsS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 21:48:18 -0400
Subject: Re: [PATCH 00/20] Enable lowmem repair for fs/subvolume tree
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
 <20170330164453.GL4781@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
CC: <quwenruo@cn.fujitsu.com>
Message-ID: <a742ecc5-b5c8-a680-76b4-42584db4edde@cn.fujitsu.com>
Date: Fri, 31 Mar 2017 09:49:29 +0800
MIME-Version: 1.0
In-Reply-To: <20170330164453.GL4781@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 03/31/2017 12:44 AM, David Sterba wrote:
> On Wed, Mar 01, 2017 at 11:13:43AM +0800, Su Yue wrote:
>> It can be feched from my github:
>> https://github.com/Damenly/btrfs-progs.git lowmem_repair
>>
>> This patchset can repair errors found in fs tree in lowmem mode.
>>
>> This patchset request includes:
>> 1) Repair inode nbytes error.
>> 2) Repair dir isize error.
>> 3) Repair orpahan inode item.
>> 4) Repair dir item/index missing/mismatch.
>> 5) Repair inode ref missing/mismatch.
>> 6) Repair inode item missing.
>> 7) Repair inode nlink error.
>> 8) Punch file extent hole.
>> 9) Let test-fsck test cases which can be repaired in lowmem mode.
>
> I went through the patchset. At this point it's not close to being
> merged. Check and especially repair is IMO an area that deserves more
> than just a few lines in the changelog. It should really explain why the
> change is correct, what corruptions is it able to repair etc. And the
> changelog does not need to repeat the subject line or say what the name
> of the new function is. I want to know that you understand what code are
> you changing, also helping me to navigate through it as I (or somebody
> else) review it. I don't think that repair is the first project one
> should attempt in btrfs-progs, but I guess you get advice from Qu.
>
> I saw many small typos or formatting glitches that it started bothering
> me. You seem to format arguments at the column of the opening "(" which
> looks when it's near the end of line:
>
> +                               ret = repair_dir_isize_lowmem(root, path,
> +                                                             inode_id,
> +                                                             size);
> +
>
>
> +                       ret = repair_inode_nlinks_lowmem(root, path,
> +                                                        inode_id,
> +                                                        namebuf, name_len,
> +                                                        refs,
> +                                                        imode_to_type(mode),
> +                                                        &nlink);
>
>
> +                               ret = repair_inode_nlinks_lowmem(root,
> +                                                                path,
> +                                                                inode_id,
> +                                                                namebuf,
> +                                                                name_len,
> +                                                                refs,
> +                                                                imode_to_type(mode),
> +                                                                &nlink);
>
> There's a "prior art" should serve as a deterrent example for anybody using
> this style, the infamous balance_leaf from reiserfs, before it was heavily
> cleaned up by Jeff:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/reiserfs/do_balan.c?id=60f76eab19e3903e810bdc3ec846c158efcd2e21#n460
>
> Scroll around the file to get the idea what scares me. Arguments can be packed
> on next lines indented by one or two tabs. I don't bother to change that where
> it does not hurt too much.
>
> Please update the subjects, drop the file name and use just
> "btrfs-progs: check: ..." .
>
> We can schedule the changes for 4.12 release, but please start smaller this
> time and pick just say 3 fixes so we can work through the preferred style
> and quality level so you don't need to update 20 patches each time.
>
>

Thanks for your advice. I will reorganize the patches then split
them up into smaller patchsets.

Thanks,
Su


