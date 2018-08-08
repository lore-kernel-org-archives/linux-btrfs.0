Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:50335 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726158AbeHHFBv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 01:01:51 -0400
Date: Wed, 8 Aug 2018 10:44:17 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
Message-ID: <20180808024416.GC3288@fnst.localdomain>
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
 <20180807163950.GP3218@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180807163950.GP3218@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 07, 2018 at 06:39:50PM +0200, David Sterba wrote:
>On Sun, Aug 05, 2018 at 06:39:57PM +0800, Lu Fengqi wrote:
>> This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for online
>> btrfs subvolume undelete.
>> 
>> And btrfs subvolume undelete subcommand was added to btrfs-progs.
>> 
>> So user can use the following command to recover all the subolume that
>> is left on the device. The recovered subvolume will be link to <dest> dir
>> named to <name_prefix><subvol_id>.
>
>Hm, I don't agree with the proposed interface - to recover all deleted
>subvolumes. IMO this should recover just one subvolume of a given id a
>to given directory.

Thank you for taking the time to respond. I may have thought too much about
the interface before. In my imagination, the cleaner kthread is like a
monster that devours user data at any time, so the user must perform an
online undelete operation as soon as possible, so there is no time to
determine the subvol_id that should be passed. However, I have to admit
that I don't know much about the user's actual usage scenarios, I will
accept the interface you provided. Of course, I really like this because it
greatly simplifies the ioctl structure.

>
>The ioctl structure has to be reworked, I've skimmed the code and saw
>some suspicious things but will have a look after the interface is
>settled.

When I rework the ioctl structure, I will carefully recheck the
incorrect place in the code.

-- 
Thanks,
Lu


