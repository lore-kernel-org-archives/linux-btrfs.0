Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbbLBQy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 11:54:59 -0500
Subject: Re: Bug/regression: Read-only mount not read-only
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Russell Coker <russell@coker.com.au>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <565F2260.1080004@redhat.com>
Date: Wed, 2 Dec 2015 10:54:56 -0600
MIME-Version: 1.0
In-Reply-To: <565EB878.9090501@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/2/15 3:23 AM, Qu Wenruo wrote:
> 
> 
> Qu Wenruo wrote on 2015/12/02 17:06 +0800:
>>
>>
>> Russell Coker wrote on 2015/12/02 17:25 +1100:
>>> On Wed, 2 Dec 2015 06:05:09 AM Eric Sandeen wrote:
>>>> yes, xfs does; we have "-o norecovery" if you don't want that, or need
>>>> to mount a filesystem with a dirty log on a readonly device.
>>>
>>> That option also works with Ext3/4 so it seems to be a standard way of
>>> dealing
>>> with this.  I think that BTRFS should do what Ext3/4 and XFS do in this
>>> regard.
>>>
>> BTW, does -o norecovery implies -o ro?
>>
>> If not, how does it keep the filesystem consistent?
>>
>> I'd like to follow that ext2/xfs behavior, but I'm not familiar with
>> those filesystems.
>>
>> Thanks,
>> Qu
>>
> 
> OK, norecovery implies ro.

For XFS, it doesn't imply it, it requires it; i.e. both must be stated explicitly:

        /*
         * no recovery flag requires a read-only mount
         */
        if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
            !(mp->m_flags & XFS_MOUNT_RDONLY)) {
                xfs_warn(mp, "no-recovery mounts must be read-only.");
                return -EINVAL;
        }

ext4 is the same, I believe:

        } else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) &&
                   ext4_has_feature_journal_needs_recovery(sb)) {
                ext4_msg(sb, KERN_ERR, "required journal recovery "
                       "suppressed and not mounted read-only");
                goto failed_mount_wq;

so if you'd like btrfs to be consistent with these, I would not make
norecovery imply ro; rather, make I would make it require an explicit ro, i.e.

mount -o ro,norecovery

-Eric

> So I think it's possible to do the same thing for btrfs.
> I'll try to do it soon.
> 
> Thanks,
> Qu
> 
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

