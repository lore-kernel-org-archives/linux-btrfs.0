Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob03.myregisteredsite.com ([209.17.115.41]:49733 "EHLO
	atl4mhob03.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbaHDD7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Aug 2014 23:59:13 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail05pod1.mgt.hosting.qts.netsol.com [10.30.71.117])
	by atl4mhob03.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s743xC6B022051
	for <linux-btrfs@vger.kernel.org>; Sun, 3 Aug 2014 23:59:12 -0400
Message-ID: <53DF0553.1010404@chinilu.com>
Date: Sun, 03 Aug 2014 21:00:19 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scan not being performed properly on boot
References: <53DEF7DD.5070002@peter-r.co.uk> <1704788.vV3kpDkpOK@xev>
In-Reply-To: <1704788.vV3kpDkpOK@xev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/03/2014 08:31 PM, Russell Coker wrote:
> On Mon, 4 Aug 2014 04:02:53 Peter Roberts wrote:
>> I've just recently started testing btrfs on my server but after just 24
>> hours problems have started. I get booted to a busybox prompt user
>> ubuntu 14.04. I have a multi device FS setup and I can't say for sure if
>> it managed to boot initially or not but it worked fine in regular usage.
> What is GRUB (or your boot loader) giving as parameters to the kernel?
>
> What error messages appear on screen?  Sometimes it's helpful to photograph
> the screen and put the picture on a web server to help people diagnose the
> problem.
>
>> I cannot mount my root with anything other than an explicit /dev/sdx
>> reference until I manually run a scan. Then UUID etc all work. I've
> That sounds like a problem with the Ubuntu initrd, probably filing an Ubuntu
> bug report would be the best thing to do.  Is BTRFS supported in that version
> of Ubuntu?
>
> But just changing your boot configuration to use /dev/sdx is probably the best
> option.
>
Assuming you are booting with grub2, you will need to use /dev/sdx in 
the grub2 configuration file.  This is known issue with grub2. Example 
from my script:

--------------------------------------------------------------------------------------
echo    'Loading Linux desktop ...'
linux   /vmlinuz-desktop root=/dev/sda7 ro splash quiet
echo    'Loading initial ramdisk ...'
initrd  /initrd-desktop.img

---------------------------------------------------------------------------------------
