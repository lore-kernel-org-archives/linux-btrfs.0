Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45557 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab3ECLuG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 07:50:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYEV1-0006ur-Hx
	for linux-btrfs@vger.kernel.org; Fri, 03 May 2013 13:50:03 +0200
Received: from 84-72-179-110.dclient.hispeed.ch ([84.72.179.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 13:50:03 +0200
Received: from alexanders.mailinglists+nospam by 84-72-179-110.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 13:50:03 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Re: Creating recursive snapshots for all filesystems
Date: Fri, 3 May 2013 11:46:59 +0000 (UTC)
Message-ID: <loom.20130503T134340-902@post.gmane.org>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <20130503084822.GA22531@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Sander <sander <at> humilis.net> writes:

> 
> Alexander Skwar wrote (ao):
> > Where I'm hanging right now, is that I can't seem to figure out a
> > "bullet proof" way to find all the subvolumes of the filesystems I
> > might have.
> 
> > Is there an easier way to achieve what I want? I want to achieve:
> > 
> > Creating recursive snapshots for all filesystems
> 
> Not sure if this helps, but I have subvolid=0, which contains all my
> subvolumes, mounted under /.root/

Hm, not quite what I'm after and not nearly as easy as ZFS...

"Problem" with your approach: The admin has to maintain this. 
I was looking for something, which "maints itself", so to say.
And your approach also wouldn't scale if there are sub-subvolumes.

ZFS really is so much easier (at least regarding that).

Thanks a lot, though. It's a worthwhile idea.

Regards,
Alexander


