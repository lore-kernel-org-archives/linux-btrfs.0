Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob08.myregisteredsite.com ([209.17.115.46]:53950 "EHLO
	atl4mhob08.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbaHDEdZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 00:33:25 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail04pod1.mgt.hosting.qts.netsol.com [10.30.71.116])
	by atl4mhob08.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s744XLn7027236
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Aug 2014 00:33:21 -0400
Message-ID: <53DF0D55.3050504@chinilu.com>
Date: Sun, 03 Aug 2014 21:34:29 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scan not being performed properly on boot
References: <53DEF7DD.5070002@peter-r.co.uk> <1704788.vV3kpDkpOK@xev> <53DF0553.1010404@chinilu.com> <30613326.hzdtJptJHK@xev>
In-Reply-To: <30613326.hzdtJptJHK@xev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/03/2014 09:14 PM, Russell Coker wrote:
> On Sun, 3 Aug 2014 21:00:19 George Mitchell wrote:
>>> But just changing your boot configuration to use /dev/sdx is probably the
>>> best option.
>> Assuming you are booting with grub2, you will need to use /dev/sdx in
>> the grub2 configuration file.  This is known issue with grub2. Example
>> from my script:
> That's not a GRUB issue it's an initrd issue.  GRUB just passes text to the
> kernel.  "cat /proc/cmdline" will show you what GRUB sent to the kernel, the
> programs in the initrd read /proc/cmdline and then do what they think is
> appropriate.
>
>> ----------------------------------------------------------------------------
>> ---------- echo    'Loading Linux desktop ...'
>> linux   /vmlinuz-desktop root=/dev/sda7 ro splash quiet
>> echo    'Loading initial ramdisk ...'
>> initrd  /initrd-desktop.img
I see what you are saying.  Its a hack.  But I suspect that most of the 
distros are not yet accommodating btrfs with their standard mkinitrd 
process.  At this point modifying grub2 config does solve the problem.  
If you know a reasonably easy way to fix initrd so that it can interpret 
UUID and LABEL, I would certainly be all ears.
