Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob05.myregisteredsite.com ([209.17.115.43]:43741 "EHLO
	atl4mhob05.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab3EUCRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 22:17:34 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.115])
	by atl4mhob05.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r4L2HWFY004939
	for <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 22:17:32 -0400
Message-ID: <519AD943.6060303@chinilu.com>
Date: Mon, 20 May 2013 19:17:39 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Virtual Device Support
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com> <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net>
In-Reply-To: <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan,  The problem affects btrfs volumes that span multiple drive.  If 
you are using btrfs on a single drive that works just fine.  But in a 
multidrive situation, sometimes it works (when umount guesses the right 
device name) and sometimes it fails (when umount guesses the wrong 
device name). Have fun!   - George

On 05/20/2013 06:08 PM, Duncan wrote:
> Chris Murphy posted on Sun, 19 May 2013 12:18:19 -0600 as excerpted:
>
>
>> On May 19, 2013, at 5:15 AM, Roman Mamedov <rm@romanrm.ru> wrote:
>>
>>>  From a user perspective btrfs subvolumes have a lot in common with just
>>> regular directories aka folders, and nothing in common with
>>> (block)devices.
>>> "Describing them with virtual devices" does not seem to make a whole
>>> lot of sense.
>> It's not possible to mount regular directories with other file systems.
> Actually, it /is/ possible, using bind-mounts, etc.  These even work at
> the individual file level, and I use a few that way here, for mounting
> usable device files over an otherwise nodev mounted filesystem (used for
> a named/bind chroot, bind-mounted and then remounted nodev,noexec, etc.).
>
> But yes, bind-mounts are an exception to the general rule.  However,
> they're an exception that does make your above claim questionable, at
> least.  btrfs subvolumes are another such exception.
>
>> In some ways the btrfs subvolume behaves like a folder. In other ways it
>> acts like a device. If you stat the mount point for btrfs subvolumes,
>> you get a unique device ID for each.
> Agreed.
>
>> It seems inconsistent that mount and unmount allows a /dev/ designation,
>> but only mount honors label and UUID.
> Yes.  I had tested btrfs a year ago and decided to wait so haven't been
> active here for 8 months or so, but am now getting back into btrfs as my
> requirements are different now, and as I'm reading the list, I've seen
> this frustrating inconsistency complained about more than once.  I'm
> about to setup a new btrfs system here once again, so don't yet know if
> it'll affect me personally, but given that I routinely use labels in
> fstab, it certainly could, depending on how the umounts are handled.  But
> at least I have a heads-up on the issue and can thus work around it
> should I need to.
>

