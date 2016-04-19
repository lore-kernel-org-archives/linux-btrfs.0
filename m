Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41187 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbcDSJjf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 05:39:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1asS80-0005bv-1L
	for linux-btrfs@vger.kernel.org; Tue, 19 Apr 2016 11:39:28 +0200
Received: from 168.159.160.61 ([168.159.160.61])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 11:39:28 +0200
Received: from toyours_sridhar by 168.159.160.61 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 11:39:28 +0200
To: linux-btrfs@vger.kernel.org
From: sri <toyours_sridhar@yahoo.co.in>
Subject: Re: btrfs-image and btrfs send related queries
Date: Tue, 19 Apr 2016 09:39:09 +0000 (UTC)
Message-ID: <loom.20160419T113817-47@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>
 <20160415124910.GD30971@carfax.org.uk>
 <CAPmG0jbp15p6shXq2GtVude_AKTcN2xRDwki0M5m-iiC_Wh51g@mail.gmail.com>
 <loom.20160418T092105-74@post.gmane.org>
 <CAPmG0jbDDG+aLHn+ymBT1Mbd2UZg17rDiwYXu8AYoxb666GXMA@mail.gmail.com>
 <20160418192619.4749bc17@natsu>
 <CAPmG0jb0e5L=BYbO7k-4qh+o4qNqEjDqLe1=04+QMSWyhk0hFg@mail.gmail.com>

Henk Slager <eye1tm <at> gmail.com> writes:

> 
> On Mon, Apr 18, 2016 at 4:26 PM, Roman Mamedov <rm <at> romanrm.net> 
wrote:
> > On Mon, 18 Apr 2016 16:13:28 +0200
> > Henk Slager <eye1tm <at> gmail.com> wrote:
> >
> >> (your email keeps ending up in gmail spam folder)
> >>
> >> On Mon, Apr 18, 2016 at 9:24 AM, sri <toyours_sridhar <at> 
yahoo.co.in> wrote:
> >> > I tried btrfs-image and created image file and ran btrfs-image -r 
to a
> >> > different disk. Once recovered and mounted, I can able to see 
data is
> >> > not zeroed out as mentioned in btrfs-image man page.
> >>
> >> "different disk"  you mention, that is important info. If you doe 
the
> >> restore to a image file, that image file is sparse and all data 
blocks
> >> are read as zeros.
> >>
> >> However, if you restore to a block device, then you can assume it 
just
> >> writes the device blocks for metadata and leaves the rest 
untouched.
> >> So trim whole device first or brute-force overwrite completely with
> >> zeros.
> >>
> >> So maybe the man pages needs some correction / extra notes.
> >>
> >> > I tried on same machine.
> >
> > Does btrfs-image store/restore the FS UUID? If it does, then 
potentially both
> > the source FS and the restored one were visible at the same time to 
the kernel
> > with identical UUIDs, and maybe it was actually accessing/mounting 
the source
> > one.
> 
> Very good point! The UUID's are the same. I remember I used a VM to
> separate the source FS from the restored FS
> 
> Also, the assumption I made about restoring to a block device is not
> correct: If you restore to a loopdev that has a file with all
> non-zeros as backing-store, the files in the mounted restored FS are
> read as zeros.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
thank you for inputs. Actually I have tried in the following way.
I have /dev/sdb , /dev/sdc. Using wipefs -fa I cleared both devices and 
cre=
ated btrfs on /dev/sdb. Mounted and written some files and unmounted it.
Then I ran btrfs-image /dev/sdc /img1.img and got the dump.
Once image created I again ran wipefs -fa /dev/sdb.
Then I ran btrfs-image -r /img1.img /dev/sdc and mounted /dev/sdc.
ls to dumped filesystem shows the file size as original and no file 
content=
. I guess btrfs-image doesn't modify files stat so i feel it is showing 
siz=
e as original.
However running cat on some of files give i/o error
qd67:/btrfs1 # cat shadow.hcat: shadow.h: Input/output error
These errors are not on all files on other files, since dump doesn't 
contai=
ns any data it just prompts for cat as below.
qd67:/btrfs1 # cat stab.hqd67:/btrfs1 # cat stdio_ext.h
Not sure why i/o errors are coming.



