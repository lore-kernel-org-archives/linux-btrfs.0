Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:7466 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726542AbeHHJLh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 05:11:37 -0400
Date: Wed, 8 Aug 2018 14:53:06 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/4] undelete subvolume online version
Message-ID: <20180808065306.GE3288@fnst.localdomain>
References: <20180805104001.5488-1-lufq.fnst@cn.fujitsu.com>
 <20180807163950.GP3218@twin.jikos.cz>
 <bd99bd51-5813-702e-b496-654fead1be41@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <bd99bd51-5813-702e-b496-654fead1be41@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2018 at 02:11:24PM +0800, Qu Wenruo wrote:
>
>
>On 2018年08月08日 00:39, David Sterba wrote:
>> On Sun, Aug 05, 2018 at 06:39:57PM +0800, Lu Fengqi wrote:
>>> This patchset will add the BTRFS_IOC_SUBVOL_UNDELETE ioctl for online
>>> btrfs subvolume undelete.
>>>
>>> And btrfs subvolume undelete subcommand was added to btrfs-progs.
>>>
>>> So user can use the following command to recover all the subolume that
>>> is left on the device. The recovered subvolume will be link to <dest> dir
>>> named to <name_prefix><subvol_id>.
>> 
>> Hm, I don't agree with the proposed interface - to recover all deleted
>> subvolumes. IMO this should recover just one subvolume of a given id a
>> to given directory.
>> 
>> The ioctl structure has to be reworked, I've skimmed the code and saw
>> some suspicious things but will have a look after the interface is
>> settled.
>
>My concern is, is such purpose really needed?
>
>Yes, it's possible user made some mistake and want to get back the data.
>But putting an ioctl for 'undelete', then user may consider btrfs is so
>powerful that can undelete everything.
>In short, this undelete feature gives user too high expectation.
>
>And don't expect user really to read man pages. There are already tons

There is no more way about the too high expectation of users. If we provide
a feature with a sufficiently detailed man page, but users do not read the
man page when using this feature, I can only think that they are not
responsible for their own data. So, this seems to be a problem they need to
consider.

>of reports where user execute btrfs check --repair without realizing
>--repair is pretty dangerous (and thanks to the work done to repair, it
>normally doesn't cause catastrophic result, but sometimes it indeed
>causes extra damage)

The good news is that online undelete is not as dangerous as btrfs check
--repair. In fact, I think it is safe enough.

>
>And when user tried and failed due to deleted tree blocks, they will get
>even more frustrated or even betrayed.

As mentioned previous, maybe we should do what we think is right, such as
give the user more abilities to protect/recover their data, not to take
care of any sensitive users?

>
>I prefer to put such undelete as an off-line rescue tool, instead of
>making it online with an ioctl interface.

I also think that the offline undelete is more useful. After all, umount
immediately to prevent further data loss is always the most effective after
a mistake. However, since we can give the ability of online undelete to a
user which couldn't umount the filesystem easily, and don't have any side
effect on existing features. IMHO, there is no reason to reject this.

-- 
Thanks,
Lu


