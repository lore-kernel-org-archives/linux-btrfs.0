Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34110 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbcCVVXS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 17:23:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aiTlj-0004em-MQ
	for linux-btrfs@vger.kernel.org; Tue, 22 Mar 2016 22:23:15 +0100
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 22:23:15 +0100
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 22:23:15 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Tue, 22 Mar 2016 22:23:01 +0100
Message-ID: <20160322222301.4882bc90@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<CAPmG0jY5EW3SXymZOCSFw2A-d2HrQ4tyFDESktqui5D8_H6noQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 22 Mar 2016 21:07:35 +0100
schrieb Henk Slager <eye1tm@gmail.com>:

> On Tue, Mar 22, 2016 at 9:03 AM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> > Hello!
> >
> > Since one of the last kernel updates (I don't know which exactly),
> > I'm experiencing csum errors within VDI files when running
> > VirtualBox. A side effect of this is, as soon as dmesg shows these
> > errors, commands like "du" and "df" hang until reboot.
> >
> > I've now restored the file from backup but it happens over and over
> > again.
> >
> > On another machine I'm also seeing errors with big files in the
> > following scenario (apparently an older kernel, 4.1.x I afair):
> >
> > # ntfsclone --save /dev/md126p2 -o rescue.ntfs.img
> >                    ^ big NTFS partition   ^ file on btrfs
> >
> > results in a write error and the file system goes read-only.
> >
> > Both systems have in common they are using btrfs on bcache with
> > compress=lzo,autodefrag,nossd,discard (mraid=1,draid=0 and
> > mraid=1,draid=single).  
> 
> autodefrag,nossd:  I am using these too on bcached btrfs, so far no
> issues (including kernel 4.5.0). I have been writing bigfiles (> 50G)
> without problems.
> compress=lzo: I have used it on bcached btrfs in the past, worked fine
> discard: I am not sure what this should do on top of /dev/bcacheX ; I
> don't know how this relates to the bcache discard; I currently have
> bcache setting:  Discard?  False
> 
> I am not saying that the last mount option is the direct cause of the
> problems you experience, it is just that I don't know its impact
> currently.

Well, maybe interesting... My backup drive doesn't use discard and
shows no such misbehavior. I try disabling it as soon as I'm having
some time elaborating on that.

I guess only the devs can tell how discard interacts with bcache, and
if it makes sense to enable it for this setup.

-- 
Regards,
Kai

Replies to list-only preferred.

