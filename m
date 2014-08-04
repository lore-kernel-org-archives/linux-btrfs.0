Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49376 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaHDPAW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 11:00:22 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so5193045wib.17
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 08:00:19 -0700 (PDT)
Message-ID: <53DFA001.7020002@peter-r.co.uk>
Date: Mon, 04 Aug 2014 16:00:17 +0100
From: Peter Roberts <me@peter-r.co.uk>
MIME-Version: 1.0
To: russell@coker.com.au
CC: linux-btrfs@vger.kernel.org
Subject: Re: Scan not being performed properly on boot
References: <53DEF7DD.5070002@peter-r.co.uk> <1704788.vV3kpDkpOK@xev>
In-Reply-To: <1704788.vV3kpDkpOK@xev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2014 04:31, Russell Coker wrote:
> What is GRUB (or your boot loader) giving as parameters to the kernel? 
> What error messages appear on screen? Sometimes it's helpful to 
> photograph the screen and put the picture on a web server to help 
> people diagnose the problem. 
Here a screenshot http://imgur.com/8pQgG8g

Making changes to /etc/fstab didn't seem to work and nor did manually 
adding device=/dev/sda1,device... in the GRUB config itself. What has 
fixed the problem though seems pretty horrible it to specify 
root=/dev/sda1 instead of UUID=....

> That sounds like a problem with the Ubuntu initrd, probably filing an 
> Ubuntu bug report would be the best thing to do. Is BTRFS supported in 
> that version of Ubuntu? But just changing your boot configuration to 
> use /dev/sdx is probably the best option. 
I'll file a bug report but I'm not sure whether this is a GRUB or an 
initrd / initramfs problem. Getting a persistent fix required a bodge in 
/etc/grub.d/10-linux

As for support, I don't think it is considered stable in 14.04 but I 
haven't had to do anything special to use it and used to official 
installer to get where I am (converting the single disk FS to a RAID1 
after).

In any case, thanks for the help :)
