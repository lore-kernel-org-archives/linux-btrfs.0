Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52609 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbK2BVt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 20:21:49 -0500
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com> <565784DE.5080401@oracle.com>
 <5657A757.90909@cn.fujitsu.com> <56581742.9030308@oracle.com>
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565A5317.8040506@gmx.com>
Date: Sun, 29 Nov 2015 09:21:27 +0800
MIME-Version: 1.0
In-Reply-To: <56581742.9030308@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/27/2015 04:41 PM, Anand Jain wrote:
>
>
>
>
>> I meant, it can be done in packaging level and it's much easier to do.
>
>   Its all about trade off, and there is no right or wrong, so is tough
>   to arrive at a conclusion even before this was implemented. Below are
>   the choices considered, now putting in the order of least suitable
>   to most suitable after reviewing their advantages and disadvantages.
>
>   . Update default features at the compile time, so to have a define
>     set for the default choices per release/distro. (not sure how to
>     do that), But with this, you can not solve the problem for which
>     current "-O comp=" is provided (i.e to provide features which are
>     compatible across a set of known kernels). And mainly, you are
>     letting the control of such a discussion out of btrfs/mainline.
>     Then distros will have own set of default features instead of having
>     such an effort discussed and converged at the mainline.

No need to set default feature per distro, we have make it clear, our 
btrfs-progs defaults feature are these, if the distro doesn't like it, 
do the backport yourself.

>
>   . /etc/btrfs.conf file to hold the default features (same as ext4)
>     I have to drop this idea since from the user point of view you are
>     creating another source of config/input that user/distro has to
>     care about.
>

No need as described above.

>   . Do it at run time for the running kernel. Current. In the order of
>     priority .. check sysfs, if not check kernel-version, if not use
>     progs-version-based-defaults (original).
>

As stated several times, kernel version based probe is inaccurate, as 
long as your goal is to ensure the fs can be mounted, you are wasting 
time as such probe won't meet your goal.

Even as a fallback method, it's not reliable and super easy to avoid.
Just remove the btrfs module.
Then all the features are just based on vanilla kernel version, which is 
far from the real kernel.


As long as your goal is to ensure a fs after mkfs can be used without 
error, you're already in a nightmare.
What if the kernel doesn't has btrfs compiled?
What if the fs is not only for kernel to mount, but also a boot 
partition for grub?
Do you need to check the grub2 version? Check if this is a /boot partition?

You want to handle them all? This is not the right place, you're in the 
field of distro, not btrfs-progs.


Recently I just encountered such problem. Latest xfs-progs makes xfs 
version 5 by default, but grub2 can't handle version 5 yet in latest 
stable version.
Then system can't even boot into grub2.

Did you see Dave trying to add such grub2 version based probe to change 
mkfs.xfs features?
No, just because that's not the way things should be done.

>
>> And it's much predictable than version based detection.
>
>   I think you mean to say its not predictable because it follows
>   a priority list, and we won't know which system used sysfs/version/
>   progs-version. Concern is valid. But I feel its trivial, unless
>   you have some strong reason. Further still its only a trade off that
>   could achieve.
>
>   Other concern that others commented..
>
>   if sysfs is not there and feature is backported, for this we should
>   ensure sysfs feature is also backported along with the feature it
>   self, without that feature back port is incomplete.

Just remove the btrfs module, then sysfs probe just become meaningless.

If something wrong may happen, then it will happen.
And the wrong thing is vanilla version based probe.

You are already messing up what btrfs-progs should do and what a distro 
should do.

Thanks,
Qu

> If distro does not
>   want to backport sysfs, the other choice that disto has is to update
>   the feature-to-version table in the progs.
>
>   For the system which does not provide version at all, it will fail
>   back to the original progs-version-based-defaults.
>
>
>   Hope I have captured all the concerns and addressed them.
>
>
> Thanks, Anand
>
>
