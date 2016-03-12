Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:52501
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbcCLNBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 08:01:20 -0500
Received: from phoenix.vfire (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2CD1HjW022215
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Mar 2016 13:01:17 GMT
Received: (from pete@localhost)
	by phoenix.vfire (8.14.9/8.14.5/Submit) id u2CD1HCC022214
	for linux-btrfs@vger.kernel.org; Sat, 12 Mar 2016 13:01:17 GMT
Date: Sat, 12 Mar 2016 13:01:17 GMT
Message-Id: <201603121301.u2CD1HCC022214@phoenix.vfire>
From: pete@petezilla.co.uk
To: linux-btrfs@vger.kernel.org
Subject: Re: Snapshots slowing system
In-Reply-To: loom.20160312T002538-774@post.gmane.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I hope this message stays within the thread on the list.  I had email problems
and ended up hacking around with sendmail & grabbing the message id off of
the web based group archives.


>I wondered whether you had elimated fragmentation, or any other known gotchas, 
>as a cause?

Subvolumes are mounted with the following options:
autodefrag,relatime,compress=lzo,subvol=<sub vol name>

Not sure if there is much else to do about fragmentation apart from running a
balance which would probally make thje machine v sluggish for a day or so.

>Out of curiosity, what is/was the utilisation of the disk? Were the snapshots 
>read-only or read-write?

root@phoenix:~# btrfs fi df /    
Data, single: total=101.03GiB, used=97.91GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=8.00GiB, used=5.29GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

root@phoenix:~# btrfs fi df /home
Data, RAID1: total=1.99TiB, used=1.97TiB
System, RAID1: total=32.00MiB, used=352.00KiB
Metadata, RAID1: total=53.00GiB, used=50.22GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


Hmm.  The system disk is getting a little tight. cddisk reports the partition I
use for btrfs containing root as 127GB approx.  Not sure why it grows so much.
Suspect that software updates can't help as snapshots will contain the legacy
versions.  On the other hand they can be useful.

Is it likely the SSD?  If likely I could get a larger one, now is a good time with
a new version of slackware imminent.  However, no point in spending money for
the sake of it.

All snapshots read-write.  However, I have mainly treated them as read-only.  
Does that make a difference?



>Apropos Nada: quick shout out to Qu to wish him luck for the 4.6 merge.

I'm wondering if it is time for an update from 4.0.4?


>[Also, damn you autocorrection on my phone!]

Yep!


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
