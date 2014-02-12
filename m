Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45145 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaBLFPt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 00:15:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WDSAl-0002cB-No
	for linux-btrfs@vger.kernel.org; Wed, 12 Feb 2014 06:15:47 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 06:15:47 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 06:15:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs multiple mounts stacked on the same mount point
Date: Wed, 12 Feb 2014 05:15:24 +0000 (UTC)
Message-ID: <pan$783b9$6da610c9$6ead6d9b$966fb3d6@cox.net>
References: <52F9DCBA.1010002@oracle.com>
	<pan$9211b$42bef7b0$dd1350ae$978558c5@cox.net>
	<52FAEC7F.4050707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain posted on Wed, 12 Feb 2014 11:37:35 +0800 as excerpted:

> On 02/12/14 04:57 AM, Duncan wrote:
>> Anand Jain posted on Tue, 11 Feb 2014 16:18:02 +0800 as excerpted:
>>
>>> per mount(2)
>>>
>>>    ---
>>>     multiple mounts can be stacked on the same mount point.
>>>    ---
>>>
>>> In this situation how could ioctl communicate (using mount point)
>>> with each FS stacked on the same mount point ?
>>>
>>> BTW I don't understand the need for multiple mounts on the same
>>> mount point ?
>>
>> That principle of over-mount obscuring what's beneath it should apply
>> to the ioctls as well.  They will always communicate with the top
>> mounted layers. [Since] an over-mount obscuring under-mounts is how
>> Linux normally works[,] not being able to access under-mounts is the
>> normal state of affairs. =:^)

> In the context of btrfs,
>   what is the critical need of this feature ?
>     OR
>   what is that it can't do without this feature ?

IMO btrfs shouldn't behave any different than any other filesystem in 
this regard, and in fact, I'd /guess/ that btrfs has little to do with it 
since that's surely handled at the general VFS layer, except perhaps 
btrfs might need to ensure that if multiple filesystems are mounted at 
the same mountpoint, the expected (that being top) one always gets the 
ioctls.  Anything underneath the top layer should be ignored, regardless 
of whether the given mountpoint is /home and it's / underneath, or 
whether it's two filesystems mounted on /home, such that the last one 
mounted always gets the ioctls.

BTW, another (general) reason over-mounts are sometimes used is to 
deliberately obscure what's underneath.  It's worth noting that anything 
with a file already open on the underlying filesystem still has access to 
that file after something else is mounted over top, and that fact is 
sometimes used to control access to certain files/filesystems, by 
starting whatever it is that needs to access them and letting them open 
the files they need, then over-mounting a different filesystem, often 
empty, so no other applications can access the under-mounted files.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

