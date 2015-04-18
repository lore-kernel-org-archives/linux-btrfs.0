Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38086 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbbDRQgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 12:36:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YjVjZ-00056a-3Q
	for linux-btrfs@vger.kernel.org; Sat, 18 Apr 2015 18:36:45 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 18:36:45 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 18:36:45 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: how to clone a btrfs filesystem
Date: Sat, 18 Apr 2015 18:36:05 +0200
Message-ID: <moda0c-jgd.ln1@hurikhan77.spdns.de>
References: <1429312124.8371.62.camel@scientia.net> <u6ca0c-12c.ln1@hurikhan77.spdns.de> <CAJCQCtRCvO5hE1Fo6Y=2rk7Amg6KQtm2gcUvFQTu2r=9kErvNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> On Sat, Apr 18, 2015 at 10:09 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> 
>> You could simply "btrfs device add" the new device, then "btrfs device
>> del" the old device...
> 
> That wipes the btrfs signature (maybe the entire superblock, I'm not
> sure) from the deleted device. It needs to be a seed device first to
> prevent that, which makes it ro.

Yeah, I figured I forgot about the "copy" requirement Cristoph mentioned... 
My suggestions only works for cloning if you want to actually migrate from 
the old to the new device, and no longer use the old one.

I wonder if one could split mirrors in btrfs... Read:

btrfs device add the new device, set the raid policy for data, meta data, 
and system to raid-1, balance, and then unmount and detach one of the 
devices.

I'm not sure how to get out of the degraded state then. Is it possible to 
simply resort from raid-1 to single raid policy again and remove the missing 
device from the pool? Regarding data, it should contain everything needed 
for running the filesystem - so it should have no problem here.

I guess there's one caveat: The signature of both devices will then indicate 
they are belonging to the same pool, making it impossible to ever attach 
those to the same system again without causing trouble for your data. If one 
could change that to make both devices distinct filesystems, it could be 
used to implement a "btrfs filesystem clone" call.
 
-- 
Replies to list only preferred.

