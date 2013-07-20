Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob14.myregisteredsite.com ([209.17.115.52]:34690 "EHLO
	atl4mhob14.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138Ab3GTPwD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jul 2013 11:52:03 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob14.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r6KFq1tq005801
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jul 2013 11:52:01 -0400
Message-ID: <51EAB225.7070008@chinilu.com>
Date: Sat, 20 Jul 2013 08:52:05 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Jason Russell <jasrusable@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Lots of harddrive chatter on after booting with btrfs on root
 (slow boot)
References: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.com>
In-Reply-To: <CA+MxQPHSHVQQko8koeK=WCjS4wq+dss++PWUB6wq7TPOTsY3Yw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sounds to me like a fragmentation issue.

On 07/20/2013 08:15 AM, Jason Russell wrote:
> Hi,
>
> I've been using btrfs for my root partition for about a month on
> archlinux and recently Ive started using the i3 window manager and
> starting X manually and I now boot to run level 3 (multi-user.target
> for systemd) and Ive noticed that booting archlinux on a btrfs root,
> there is a lot off hdd chatter after the login prompts are displayed,
> which doesnt happen with ext4 on root, so I have done some testing and
> comparisons.
>
> I have stripped down two arch installs, one with btrfs root and one
> with ext4, (same laptop, same hdd) I removed all packages except for
> the base group. On the btrfs root, there is about +- 15 seconds of hdd
> chatter and it takes a long time to log in from the prompts, with the
> ext4 root, the computer is silent after the prompts pop up and login
> is almost instant. The prompts of the two installs pop up at more or
> less the same time (+- 3 seconds) but the login on the btrfs root
> takes muuch longer than the ext4.
>
> Ive also noted that this excessive hdd chatter does not occur
> immediately after a fresh format with arch on btrfs root.
>
> Ive made some deductions/assumptions:
> This only seems to occur with btrfs roots.
> This only happens after some number of reboots OR after the partition
> fills up a little bit.
> Im pretty sure of ruled out everything except for the filesystem.
>
>
> I have just done two clean installs to more thoroughly compare ext4
> and btrfs roots. So far no excessive hdd chatter from btrfs.
>
> I have also seen what I have described on two other computers
> (different hardware entirely) where there is lots of hdd chatter from
> btrfs root, and nothing from ext4.
>
> Here are two threads:
> https://bbs.archlinux.org/viewtopic.php?pid=1117932
> https://bbs.archlinux.org/viewtopic.php?pid=1301684
>
> Any ideas?
>
> Thanks,
>
> --
> Jason Russell
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

