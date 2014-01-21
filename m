Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56440 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaAUQqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 11:46:04 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so3150147pde.35
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 08:46:03 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3 1/4] Btrfs: fix wrong send_in_progress accounting
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAL3q7H7+TcotGES=RZUOz0FRyJfyt0tkZQ9mMmZg2o8AdS_TqA@mail.gmail.com>
Date: Wed, 22 Jan 2014 00:45:57 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-Id: <B043A7E1-6AEF-4446-AD4C-554744E9E67A@gmail.com>
References: <1390021080-30788-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAL3q7H7+TcotGES=RZUOz0FRyJfyt0tkZQ9mMmZg2o8AdS_TqA@mail.gmail.com>
To: fdmanana@gmail.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello Filipe, 

> On Sat, Jan 18, 2014 at 4:58 AM, Wang Shilong
> <wangsl.fnst@cn.fujitsu.com> wrote:
>> Steps to reproduce:
>> # mkfs.btrfs -f /dev/sda8
>> # mount /dev/sda8 /mnt
>> # btrfs sub snapshot -r /mnt /mnt/snap1
>> # btrfs sub snapshot -r /mnt /mnt/snap2
>> # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
>> # dmesg
>> 
>> The problem is that we will sort clone roots(include @send_root), it
>> might push @send_root before thus @send_root's @send_in_progress will
>> be decreased twice.
>> 
>> Cc: David Sterba <dsterba@suse.cz>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>> changelog
>> v2->v3:
>>        add comments as david addressed.
>> v1->v2:
>>        use right root to check
>> ---
>> fs/btrfs/send.c | 19 ++++++++++++++++---
>> 1 file changed, 16 insertions(+), 3 deletions(-)
>> 
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index bff0b1a..83b6bdb 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -4752,6 +4752,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>>        u32 i;
>>        u64 *clone_sources_tmp = NULL;
>>        int clone_sources_to_rollback = 0;
>> +       int sort_clone_roots = 0;
>> 
>>        if (!capable(CAP_SYS_ADMIN))
>>                return -EPERM;
>> @@ -4942,6 +4943,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>>        sort(sctx->clone_roots, sctx->clone_roots_cnt,
>>                        sizeof(*sctx->clone_roots), __clone_root_cmp_sort,
>>                        NULL);
>> +       sort_clone_roots = 1;
>> 
>>        ret = send_subvol(sctx);
>>        if (ret < 0)
>> @@ -4957,11 +4959,22 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>>        }
>> 
>> out:
>> -       for (i = 0; sctx && i < clone_sources_to_rollback; i++)
>> -               btrfs_root_dec_send_in_progress(sctx->clone_roots[i].root);
>> +       if (sort_clone_roots) {
>> +               for (i = 0; i < sctx->clone_roots_cnt; i++)
>> +                       btrfs_root_dec_send_in_progress(
>> +                                       sctx->clone_roots[i].root);
> 
> sctx can be NULL here, anywhere after the 'out' label.

Not really, if @sort_clone_roots is set which means we must have allocated
sctx successfully.

> 
>> +       } else {
>> +               for (i = 0; sctx && i < clone_sources_to_rollback; i++)
>> +                       btrfs_root_dec_send_in_progress(
>> +                                       sctx->clone_roots[i].root);
> 
> Same here.

Notice there is a check above,

sctx && i < clone_sources_to_rollback

I really took care of that when i wrote the patch, please correct
me if i miss something here^_^.

Thanks,
Wang
> 
>> +               /*
>> +                * if we fail to add @send_root in clone roots, we still
>> +                * need to decrease @send_in_progress count here.
>> +                */
>> +               btrfs_root_dec_send_in_progress(send_root);
>> +       }
>>        if (sctx && !IS_ERR_OR_NULL(sctx->parent_root))
>>                btrfs_root_dec_send_in_progress(sctx->parent_root);
>> -       btrfs_root_dec_send_in_progress(send_root);
>> 
>>        kfree(arg);
>>        vfree(clone_sources_tmp);
>> --
>> 1.8.3.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
> Unreasonable men adapt the world to themselves.
> That's why all progress depends on unreasonable men."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

