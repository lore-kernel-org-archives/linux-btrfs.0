Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41962 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKFFZH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 00:25:07 -0500
Message-ID: <545B072D.7080307@oracle.com>
Date: Thu, 06 Nov 2014 13:29:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        Cyril Scetbon <cyril.scetbon@free.fr>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Compatibility matrix kernel/tools
References: <4CB60C7D-97C0-4DA5-830B-CAD0E3D0C22E@free.fr> <20141105214515.GD21247@carfax.org.uk> <545AD423.2010600@cn.fujitsu.com>
In-Reply-To: <545AD423.2010600@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/06/2014 09:51 AM, Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: Re: Compatibility matrix kernel/tools
> From: Hugo Mills <hugo@carfax.org.uk>
> To: Cyril Scetbon <cyril.scetbon@free.fr>
> Date: 2014年11月06日 05:45
>> On Wed, Nov 05, 2014 at 09:57:31PM +0100, Cyril Scetbon wrote:
>>> Hi,
>>>
>>> Where can I find the compatibility matrix to know which btrfs-tools
>>> version should work with a chosen linux kernel ?
>>     Any of them should work with any kernel.
>>
>>     For normal operation, if the tools are too old, they may not
>> support newer kernel features -- but that will simply mean you can't
>> access the feature, not that anything will be broken.
>>
>>     If you're doing recovery work (btrfs check and friends) then using
>> the latest released version of the tools is strongly recommended.
>>
>>     Hugo.
>>
> As Hugo mentioned, overall any kernel/user tool combination should be OK
> and won't cause disaster.
>
> [Online operations]
> More specifically, online(btrfs mounted) operations mostly depend on the
> kernel.
> Like subvolume/snapshot device add/remove/replace balance/scrub and
> send/receive should mainly depend on the
> kernel version.
>
> [If version not match]
> 1. Kernel ver > progs ver.
> It may happens that progs don't know the new added ioctls, so some
> bleeding edge functions may not be available,
> but everything should work fine without problem.(except some known/fixed
> progs bugs)
>
> 2. Progs ver > kernel ver.
> It may happen some ioctl not supported by kernel, if there is a fallback
> method everything should work without problem,
> or progs should prompt the fact that some bleeding edge function is not
> supported by kernel.
> Everything should also works fine except some known/fixed kernel bugs,
> which maybe worse than progs bugs.
>
> [Offline operations]
> Offline operations includes mkfs, btrfsck and all its
> friends(btrfs-find-roots btrfs-show-super btrfs-debug-tree ...)
> Since offline operations needs to do some dirty job like reading/writing
> the superblock, it may cause big compatibility problem
> if using some new incompact features.
>
> [If version not match]
> 1. kernel ver > progs ver.
> There maybe some btrfs filesystems that kernel can mount but offline
> tools can't open.
> For example, before v0.20-rc1 progs doesn't support skinny metadata, and
> 3.17 kernel supports it,
> a btrfs created with skinny metadata can't be fscked using v0.20-rc1,
> but kernel can still mount it,
> and online operations should be fine.
>
> If not using the new features, it would be OK.
>
> 2. kernel ver < progs ver
> This maybe even worse.
> If you create a fs with latest progs, which may enable some new feature
> like big metadata on *DEFAULT*,
> kernels before v3.3 will be unable to even mount it since it can't
> understand the new incompact features.
>
>
> [Conclusion]
> If not using offline operations often, compatibility won't be a big
> problem.
> If using offline operations often, better keep kernel/progs version from
> differing too much.
>
> Also if you want to keep a matrix for it, it may take some time to git
> blame/log/describe...
> Tips will be focus on INCOMPACT flags in fs/btrfs/ctree.h and ioctls
> change in fs/btrfs/ioctl.c.

  for the long term its better if (some critical) offline tools are
  moved into the kernel and operate on the disks through the
  /dev/btrfs-control ioctl which in case the disks doesn't have to
  be mounted. btrfs is also a volume manger there should be a way
  to manage the disks in the kernel not necessary only when the device
  is mounted.

Thanks, Anand

> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
