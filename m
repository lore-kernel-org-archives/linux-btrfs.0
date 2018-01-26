Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:50606 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbeAZOSR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:18:17 -0500
Received: by mail-it0-f50.google.com with SMTP id x128so701561ite.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:18:17 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Christophe Yayon <cyayon-list@nbux.org>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
Date: Fri, 26 Jan 2018 09:18:13 -0500
MIME-Version: 1.0
In-Reply-To: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-26 09:02, Christophe Yayon wrote:
> Hi all,
> 
> I don't know if it the right place to ask. Sorry it's not...
No, it's just fine to ask here.  Questions like this are part of why the 
mailing list exists.
> 
> Just a little question about "degraded" mount option. Is it a good idea to add this option (permanent) in fstab and grub rootflags for raid1/10 array ? Just to allow the system to boot again if a single hdd fail.
Some people will disagree with me on this, but I would personally 
suggest not doing this.  I'm of the opinion that running an array 
degraded for any period of time beyond the bare minimum required to fix 
it is a bad idea, given that:
* It's not a widely tested configuration, so you are statistically more 
likely to run into previously unknown bugs.  Even aside from that, there 
are probably some edge cases that people have not yet found.
* There are some issues with older kernel versions trying to access the 
array after it's been mounted writable and degraded when it's only two 
devices in raid1 mode.  This in turn is a good example of the above 
point about not being widely tested, as it took quite a while for this 
problem to come up on the mailing list.
* Running degraded is liable to be slower, because the filesystem has to 
account for the fact that the missing device might reappear at any 
moment.  This is actually true of any replication system, not just BTRFS.
* For a 2 device raid1 volume, there is no functional advantage to 
running degraded with one device compared to converting to just use a 
single device (this is only true of BTRFS because of the fact that it's 
trivial to convert things, while for MD and LVM it is extremely 
complicated to do so online).

Additionally, adding the `degraded` mount option won't actually let you 
mount the root filesystem if you're using systemd as an init system, 
because systemd refuses to mount BTRFS volumes which have devices missing.

Assuming that the systemd thing isn't an issue for you, I would suggest 
instead creating a separate GRUB entry with the option set in rootflags. 
  This will allow you to manually boot the system if the array is 
degraded, but will make sure you notice during boot (in my case, I don't 
even do that, but I'm also reasonably used to tweaking kernel parameters 
from GRUB prior to booting the system that it would end up just wasting 
space).
> 
> Of course, i have some cron jobs to check my array health.
It's good to hear that you're taking the initiative to monitor things, 
however this fact doesn't really change my assessment above.
