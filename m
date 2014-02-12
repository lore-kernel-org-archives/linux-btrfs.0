Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56565 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaBLNSA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 08:18:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WDZhN-0006Kr-AG
	for linux-btrfs@vger.kernel.org; Wed, 12 Feb 2014 14:17:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 14:17:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 14:17:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs multiple mounts stacked on the same mount point
Date: Wed, 12 Feb 2014 13:17:34 +0000 (UTC)
Message-ID: <pan$2e9dc$83411375$89da7090$541a6478@cox.net>
References: <52F9DCBA.1010002@oracle.com>
	<pan$9211b$42bef7b0$dd1350ae$978558c5@cox.net>
	<52FAEC7F.4050707@oracle.com>
	<pan$783b9$6da610c9$6ead6d9b$966fb3d6@cox.net>
	<52FB2490.1030207@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Wed, 12 Feb 2014 15:36:48 +0800 as excerpted:

>> BTW, another (general) reason over-mounts are sometimes used is to
>> deliberately obscure what's underneath.  It's worth noting that
>> anything with a file already open on the underlying filesystem still
>> has access to that file after something else is mounted over top, and
>> that fact is sometimes used to control access to certain
>> files/filesystems, by starting whatever it is that needs to access them
>> and letting them open the files they need, then over-mounting a
>> different filesystem, often empty, so no other applications can access
>> the under-mounted files.
> 
>   Thanks. Makes sense theoretically. Any eg of real practical
> application ? Any product in the market using it that way ?

At least from here over-mount-to-prevent-access seems more like an admin 
technique than something someone would ship in a product.  And yes, while 
I don't know of any specific product using the technique, I've certainly 
read of admins using the trick -- that's actually how I knew about it 
myself.

>   looks btrfs-progs shouldn't depend on the mnt-point driven ioctls to
>   manage the FS. Now that's a set of challenges.

I don't really see why not.  Why would one /need/ to issue ioctls to an 
under-mounted filesystem that's not otherwise accessible (except to apps 
with files on it opened before a different filesystem was over-mounted on 
top), and why wouldn't the ordinary rules of umounting the over-mount in 
ordered to access it if necessary, not apply?  In general, I think most 
admins are used to the general limitation, and I doubt it would even 
occur to most of them to try to (for example) run a balance or check the 
free space on a filesystem they can't otherwise access, because that sort 
of thing is in most cases simply not possible.

And if for some reason one were to need such an arrangement, that's what 
bind/move/shared-mounts are for.  (See the mount (8) manpage and $KERNDIR/
Documentation/filesystems/sharedsubtree.txt.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

