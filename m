Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35343 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754271AbaDBAzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 20:55:37 -0400
Message-ID: <533B5F75.3090304@cn.fujitsu.com>
Date: Wed, 2 Apr 2014 08:53:09 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Michael Witten <mfwitten@gmail.com>
CC: Shilong Wang <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [Help] Errors found in extent allocation tree or chunk allocation
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>            <CAP9B-Qmy4NgzRPpApM+Pn7tjhu6Z-cBtz99kgC+2rYu9+o9PCQ@mail.gmail.com> <5a201e76eb0545a290305d2e62bfcd28-mfwitten@gmail.com>
In-Reply-To: <5a201e76eb0545a290305d2e62bfcd28-mfwitten@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Michael,

On 04/02/2014 03:26 AM, Michael Witten wrote:
> On Tue, 1 Apr 2014 07:15:47 +0800, Shilong Wang wrote:
>
>> hello, recently, i was working on btrfsck repair. i post some
>> patches to make btrfsck to rebuild extent tree with snapshots.
>> you can pull code from david latest branch and have a try with
>> btrfsck --init-extent-tree.
> Fortunately, the `btrfs balance' command solved the issue for me:
>
>    http://mid.gmane.org/<8e4932bb29f743419660da1846c2363b-mfwitten@gmail.com>
>
> However, I did notice `--init-extent-tree' when trying to figure
> out what I might do to fix my troubles; however, I was uncertain
> about exactly what it would do.
>
> According to `man btrfsck':
>
>    --init-csum-tree
>         create a new CRC tree.
>
>    --init-extent-tree
>         create a new extent tree.
>
> These sound potentially destructive, so I was afraid to use them;
> what exactly does it mean to create a new tree? After your email,
> I assume each action creates a new tree that is populated from the
> data in the corresponding old tree.

We may have a totally broken Extent tree, then you could not even
mount your filesystem anymore.

'--init-extent-tree' will recreate a new tree and then re-insert 
everything according to other fs/file tree.

>
> Also, you wrote:
>
>> rebuild extent tree with snapshots
> Do you mean to say that your patches handle the previously unhandled
> case in which both of the following are true?

Previouly, '--init-extent-tree' did not handle it properly if there is 
snapshots in the filesystem.

Thanks,
Wang
>
>    * There are snapshots in the file system.
>    * The extent tree needs to be rebuilt.
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

