Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34097 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3EUMGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 08:06:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UelKZ-00008C-Eq
	for linux-btrfs@vger.kernel.org; Tue, 21 May 2013 14:06:15 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 14:06:15 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 14:06:15 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Virtual Device Support
Date: Tue, 21 May 2013 13:06:04 +0100
Message-ID: <knfnv7$k9h$1@ger.gmane.org>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com> <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net> <9BA35EA6-D116-4223-B2C0-CE4FEA3D4010@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <9BA35EA6-D116-4223-B2C0-CE4FEA3D4010@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/05/13 04:37, Chris Murphy wrote:
> 
> On May 20, 2013, at 7:08 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> Chris Murphy posted on Sun, 19 May 2013 12:18:19 -0600 as
>> excerpted:
>> 
>>> It seems inconsistent that mount and unmount allows a /dev/
>>> designation, but only mount honors label and UUID.
>> 
>> Yes.
> 
> I'm going to contradict myself and point out that mount with label or
> UUID is made unambiguous via either the default subvolume being
> mounted, or the -o subvol= option being specified. The volume label
> and UUID doesn't apply to umount because it's an ambiguous command.
> You'd have to umount a mountpoint, or possibly a subvolume specific
> UUID.


I'll admit that I prefer working with filesystem labels.


This is getting rather semantic... From "man umount", this is what
umount intends:

#####
umount [-dflnrv] {dir|device}...

The  umount  command  detaches the file system(s) mentioned from the
file hierarchy.  A file system is specified by giving the directory
where it has been mounted.  Giving the special device on which the file
system lives may also work, but is obsolete, mainly because it will fail
in case this device was mounted on more than one directory.
#####


I guess the ideas of labels and UUID and multiple devices came out a few
years later?... For btrfs, umount needs to operate on the default subvol
but with the means for also specifying a specific subvol if needed.

One hook for btrfs to extend what/how 'umount' operates might be to
perhaps extend what can be done with a "/sbin/(u?)mount.btrfs" 'helper'?


Regards,
Martin

