Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39171 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S938132AbdAFIEe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 03:04:34 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cPPVh-00041i-PT
        for linux-btrfs@vger.kernel.org; Fri, 06 Jan 2017 09:04:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BUG at mount time on v4.8.10
Date: Fri, 6 Jan 2017 08:04:14 +0000 (UTC)
Message-ID: <pan$4d0f$d0edd215$b877b10c$95d761c6@cox.net>
References: <20170106043600.GB4502@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Petr Janecek posted on Fri, 06 Jan 2017 05:36:01 +0100 as excerpted:

> I just got a BUG on mount of a raid10 fs. /dev/sde was added to
> the fs recently and balance has been started. After reboot (balance
> still running), the fs can not be mounted any more.

Try the skip_balance mount option (as described on the wiki or in the 
btrfs (5) manpage).

If it's a balance-related bug, that should avoid triggering it, altho 
obviously the (meta?)data that triggered it is still there.  But it 
should let you mount the filesystem and freshen your backups, at least, 
before you try potentially risky repair options.

Additionally, once mounted, you can btrfs balance cancel, to kill the 
balance more permanently, so it doesn't try to start on the next mount, 
if skip_balance isn't given again.

> # btrfs fi sh
> Label: 'BTR0'  uuid: 0ec83db3-4574-4e40-8d57-ebbe9fe246e1
> 	Total devices 5 FS bytes used 5.45TiB
> 	devid    1 size 2.73TiB used 2.64TiB path /dev/sdk
> 	devid    2 size 2.73TiB used 2.64TiB path /dev/sdj
> 	devid    3 size 2.73TiB used 2.64TiB path /dev/sda
> 	devid    4 size 2.73TiB used 2.64TiB path /dev/sdb
> 	devid    5 size 2.73TiB used 356.03GiB path /dev/sde

I'm just a user and list regular, not a dev, so dumps such as the below 
don't mean much to me.  Often, about the only thing useful I can pick out 
of them is the kernel version (which matches what you provided in the 
subject, 4.8.10), but in this case, there's something additional...

> [ 1380.872569] BUG: unable to handle kernel paging request at
> fffffffffffffd60
> [ 1380.879592] IP: [<ffffffffc045cf6f>]
> qgroup_fix_relocated_data_extents+0x1f/0x2a0 [btrfs]

qgroup?  You're using btrfs quotas?  

As the wiki suggests, btrfs quota code isn't particularly stable yet, and 
has been the source of numerous bugs.  It remains under intense bug-
squashing focus, and in general, my recommendation remains don't use it 
unless you're specifically working with the devs on finding and fixing 
those quota-related bugs.

Basically, your quota use-case falls into one of two categories.  Either 
you don't need the functionality and are best served by turning it off, 
since by doing so you'll avoid the bugs it brings with it, or you really 
do need the quota functionality, and are best served by running a 
filesystem where the quota code is mature and well tested -- where it 
actually works, including corner-cases, the way it's supposed to work.

Thus, assuming mount with skip_balance works, I'd first cancel the 
balance.  Then I'd remount read-only to prevent further damage while I 
freshened my backups, just in case.

(If you don't have the resources to do backups and aren't running with 
data you can afford to lose, btrfs isn't the filesystem for you; choose a 
filesystem that's more mature and stable.  And... strongly consider doing 
backups even on fully stable filesystems, because as any sysadmin worth 
the label will tell you, the value of your data is defined by the number 
of backups you consider it worth having of it, no backups, the value is 
throw-away, no matter any claims to the contrary.)

Then after the backups are freshened, remount writable again, and if you 
don't need quotas, disable the quota functionality.

Then with your backups freshened and quota functionality turned off, try 
the balance again.  With luck the problem was limited to the quota code 
and with that off the balance will go just fine.  Many have reported that 
it goes faster as well, since there's quite a section of quota code that 
balance runs that doesn't scale as well as one might hope, that can be 
entirely skipped if it's off.

Of course if you actually need those quotas for your use-case, that won't 
work so well, but then, as I suggested above, if you actually need 
quotas, you're best served by using a filesystem where they're actually 
stable and work as intended, as well, so in that case, after your backups 
are freshened you'll probably be doing a mkfs to some other filesystem, 
instead of turning quotas off and trying again to do a balance on the 
existing filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

