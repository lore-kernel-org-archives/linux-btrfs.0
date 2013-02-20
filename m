Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:34764
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933969Ab3BTHdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 02:33:53 -0500
Message-ID: <51247C5B.8050805@gmail.com>
Date: Tue, 19 Feb 2013 23:33:47 -0800
From: Bob McGowan <ramjr0915@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: "Fixing" mount points
References: <5121DC0D.8060305@gmail.com> <C36BE313-EE1C-43CD-8A8A-D595586974DD@colorremedies.com>
In-Reply-To: <C36BE313-EE1C-43CD-8A8A-D595586974DD@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/18/2013 09:08 AM, Chris Murphy wrote:
> On Feb 18, 2013, at 12:45 AM, Bob McGowan <ramjr0915@gmail.com> wrote:
>
>> Even though things look OK from the command line, logging in through the
>> window system fails (actually, just hangs).
>>
>> I assume this means I should be doing something to "clean up" the
>> subvolume?  Or maybe there's something in the Window system
>> configuration to change?
>>
>> I'm running Linux Mint 14 KDE.  My fstab for the parts in question looks
>> like:
>>
>> # / was on /dev/sde2 during installation
>> UUID=1a...9 /     btrfs   defaults,subvol=@     0       1
>> # /home was on /dev/sde2 during installation
>> UUID=1a...9 /home btrfs   defaults,subvol=@home 0       2
>>
>> What I want is something like:
>> # / was on /dev/sde2 during installation
>> UUID=1a...9 /     btrfs   defaults              0       1
>> # /home is on /dev/sda1
>> UUID=7f...3 /home btrfs   defaults              0       2
> The 2nd fstab implies a completely different disk, the first partition is btrfs, mounted as /home. So long as the contents are user folders, i.e. the same thing found in sde2 subvol @home, then it's functionally the same as what you had before.
>
> Also, btrfs doesn't need fs_passno set.
>
>
> Chris Murphy
Hi, Chris,

Thanks for the information.  As for fs_passno, what you're seeing is
what was put there by the install process.  I'm assuming, if it's not
needed, that the proper value would be zero?

You have confirmed what I thought was correct.  But trying it the first
time failed.  My login acted as though the user was valid but login
didn't complete, returning to the login screen.

Since I was just able to reconfigure fstab, and it worked, I'd say I
probably fat fingered something and just didn't notice.

In any case, many thanks, again. ;)

Bob
