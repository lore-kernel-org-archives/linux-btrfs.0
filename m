Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35597 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaANLxu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 06:53:50 -0500
Message-ID: <52D5250A.204@cn.fujitsu.com>
Date: Tue, 14 Jan 2014 19:52:42 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs: fix wrong send_in_progress accounting
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140108121609.GF6498@suse.cz> <FBF55D09-2D04-4ACF-A159-2DDD3D896C3A@gmail.com> <20140113184024.GT6498@twin.jikos.cz>
In-Reply-To: <20140113184024.GT6498@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/14/2014 02:40 AM, David Sterba wrote:
> On Wed, Jan 08, 2014 at 11:09:02PM +0800, Wang Shilong wrote:
>> Hello David,
>>
>>> On Tue, Jan 07, 2014 at 05:25:18PM +0800, Wang Shilong wrote:
>>>> Steps to reproduce:
>>>> # mkfs.btrfs -f /dev/sda8
>>>> # mount /dev/sda8 /mnt
>>>> # btrfs sub snapshot -r /mnt /mnt/snap1
>>>> # btrfs sub snapshot -r /mnt /mnt/snap2
>>>> # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
>>>> # dmesg
>>>>
>>>> The problem is that we will sort clone roots(include @send_root), it
>>>> might push @send_root before thus @send_root's @send_in_progress will
>>>> be decreased twice.
>>> Of course, the sort(). I think your fix adds some complexity that's not
>>> necessary. Whether the clone_roots array is sorted is not important, we
>>> just have to process each root once.
>>>
>>> send_root becomes a clone_root member, so the missing part is to account
>>> in the rollback counter:
>>>
>>> --- a/fs/btrfs/send.c
>>> +++ b/fs/btrfs/send.c
>>> @@ -4937,6 +4937,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>>>          * for possible clone sources.
>>>          */
>>>         sctx->clone_roots[sctx->clone_roots_cnt++].root = sctx->send_root;
>>> +       clone_sources_to_rollback++;
>> Not really, If we fail to come here, we still need decrease @send_root.
> Right. I was thinking if the code can be simplified somehow, but don't
> have anything vastly better. Can you please add a comment to the first
> branch that send_root is processed in the loop and not missed? It looks
> unabalanced when it's handled just a few lines below and not in the 1st
> loop.
Reasonable, i will send v3 for this patch and add some comments.
David, really thanks for you costing time to review and correct me.^_^

Thanks,
Wang
>
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

