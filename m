Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:53535 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbeEPIDf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 04:03:35 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CE025AC02E9
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:03:26 +0900 (JST)
Subject: Re: [PATCH 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can work
 for subvolume
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
 <428b7ee1-bc44-2f2d-1117-6a031759039a@jp.fujitsu.com>
 <20180515132239.GQ6649@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <f305927c-097b-50b8-5185-abf2d2eec219@jp.fujitsu.com>
Date: Wed, 16 May 2018 17:03:15 +0900
MIME-Version: 1.0
In-Reply-To: <20180515132239.GQ6649@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/05/15 22:22, David Sterba wrote:
> On Tue, May 15, 2018 at 04:33:12PM +0900, Misono Tomohiro wrote:
>> Deletion of a subvolume by rmdir(2) has become allowed by the
>> 'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
>> subvolume")'.
>>
>> It is a kind of new feature and this commits add new sysfs entry
>>   /sys/fs/btrfs/features/rmdir_subvol
>> to indicate the feature.
>>
>> Since the behavior is independent of feature bits of superblock,
>> new type FEAT_KERNEL is added to struct btrfs_feature_set.
>> Features of FEAT_KERNEL is supposed to be visible only in /sys/fs/features
>> and not in /sys/fs/UUID/features.
> 
> As the rmdir_subvol is a static feature, depending only on the kernel
> version, it's not needed to use the same infrastructure as the optional
> features. It also makes it unnecesarily complicated, to distinguish the
> on-disk and kernel-only features and it's not a per-filesystem feature.
> 
> It should be exported among btrfs_feature_attr_group and
> btrfs_supported_feature_attrs, possibly adding a new type of helpers if
> needed.

Understood. I will send v2 which adds new attr_group for static features.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

