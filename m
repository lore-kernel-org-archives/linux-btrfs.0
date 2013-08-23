Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:49604 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab3HWQWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 12:22:24 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so892587obb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 09:22:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <521721D4.3030008@giantdisaster.de>
References: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
	<20130813141542.GF2150@localhost.localdomain>
	<CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
	<CAKcLGm_c=qimNQiByVA5ko-7K4ojL2mf5yoxLyiVCwKgaLcAZA@mail.gmail.com>
	<CAKcLGm_jFa_2FaaaudRZF8JRymh1t3ASMFN1tFGbs0PGt1vNaQ@mail.gmail.com>
	<521721D4.3030008@giantdisaster.de>
Date: Fri, 23 Aug 2013 11:22:24 -0500
Message-ID: <CAKcLGm_NWAhmT0U=JsWSvXjShGtB5PV+PC97fPAax0vGo_wQKQ@mail.gmail.com>
Subject: Re: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 23, 2013 at 3:48 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On Wed, 21 Aug 2013 08:44:55 -0500, Mitch Harder wrote:
>> I've had a hard time assembling a portable reproducer for this issue.
>>
>> I discovered that my reproducer was highly dependent on a local
>> archive of out-of-date git kernel sources.  My efforts to reproduce
>> the error with a portable set of scripts with publicly available
>> kernel git sources weren't successful.
>>
>> It seems like this issue is related to a corner-case workload that is
>> difficult to reproduce.
>>
>> So I've bisected the error I was seeing with my local script, and
>> identified the following commit as triggering my issue:
>>
>> commit:    3c64a1aba7cfcb04f79e76f859b3d66660275d59
>> Btrfs: cleanup: don't check the same thing twice
>> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=for-linus&id=3c64a1aba7cfcb04
>>
>> I tested a kernel which reverted this change, and also added WARN_ON
>> lines to provide a back trace.
> [...]
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index cd46e2c..a1091f7 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -2302,6 +2302,12 @@ static noinline int
>> relink_extent_backref(struct btrfs_path *path,
>>              return 0;
>>          return PTR_ERR(root);
>>      }
>> +    if (btrfs_root_refs(&root->root_item) == 0) {
>> +        srcu_read_unlock(&fs_info->subvol_srcu, index);
>> +        /* parse ENOENT to 0 */
>> +        WARN_ON(1);
>> +        return 0;
>> +    }
> [...]
>> [ 1616.886868] ------------[ cut here ]------------
>> [ 1616.886912] WARNING: at fs/btrfs/inode.c:2308 relink_extent_backref+0x103/0x721 [btrfs]()
>> [ 1616.887050] Call Trace:
>> [ 1616.887064] [<ffffffff8161a34a>] dump_stack+0x19/0x1b
>> [ 1616.887071] [<ffffffff8103035a>] warn_slowpath_common+0x67/0x80
>> [ 1616.887077] [<ffffffff8103038d>] warn_slowpath_null+0x1a/0x1c
>> [ 1616.887100] [<ffffffffa019ea82>] relink_extent_backref+0x103/0x721
>> [ 1616.887205] [<ffffffffa019f7e2>] btrfs_finish_ordered_io+0x742/0x829
>
> Mitch,
>
> Thank you for this excellent work to find the cause of the issue. I've sent a patch "Btrfs: fix for patch "cleanup: don't check the same thing twice"" and would appreciate if you could repeat your test, just to make sure, because I was never able to reproduce this issue myself.
>

Thanks.

I've tested my "special" workload with your patch on the latest
3.11_rc6 kernel, and the patch corrects the errors I was encountering.
