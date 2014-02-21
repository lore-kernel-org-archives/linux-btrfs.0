Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59349 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaBUTGJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 14:06:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGvQD-0004WC-HV
	for linux-btrfs@vger.kernel.org; Fri, 21 Feb 2014 20:06:05 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 20:06:05 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 20:06:05 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Incremental backup over writable snapshot
Date: Fri, 21 Feb 2014 19:56:07 +0100
Message-ID: <73kkta-ad2.ln1@hurikhan77.spdns.de>
References: <17860756.QfG9CfNMqv@linuxpc> <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com> <2285169.jbztTl7OC0@linuxpc> <2333267.X1am0Dsk8s@linuxpc>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GEO <1g2e3o4@gmail.com> schrieb:

> First of all, I am sorry that I screw up the whole structure of the
> discussion (I have not subscribed to the mailing list, and as Kai replied
> to the mailing list only, I could not reply to his answer.)

Umm... Try a NNTP gateway like gmane to follow the list in an NNTP news 
reader of your choice. You can be semi-autosubscribed then without getting 
email sent to your email inbox and without digests being sent. It's really 
enjoyable.

> Kai: Yeah, your point was neutral and I did never understand it otherwise.
> Thank you for your answer!

NP.

> I already had idea of creating a subvolume called DATA in my home
> directory, however I find that pretty annoying, as most applications will
> open home by default.

Well, I mentioned you may want to place symlinks into that data directory 
for the well-known home directory locations like "music", "documents", etc. 
It's a bit ugly but it should do the job well. You can make your data 
directory hidden by naming it ".my-backup-data" or something, then point 
symlinks into that for documents, music, etc. That way, the applications 
still open your home fine, it is not cluttered with your data directory and 
the symlinks will serve fine. It may not be what you prefer but it can be an 
elegant solution. But there you go:

> In fact I would find it more elegant to generally backup without making
> changes to my file system structure in home.
> 
> I know that there other possibilities to do what I want, but I am asking
> whether the initially described method would work reliably, given that the
> user makes not a fundamental mistake himself.
> I know it may sound stubborn but I am really interested if my method works
> just as reliable as the other suggested methods.

Given that there are no mistakes in your procedure to do the preparation 
jobs for your backup, it should work perfectly reliable. I think, btrfs 
send/receive still has some quirks handling corner cases - and those may 
well be triggered by your idea of cleaning up the snapshot first, but 
generally it should work (at least if btrfs send/receive work as intended, 
there are no design decisions which would work against your use-case).

> As I am not having the level required to check the code myself, I am
> asking here, in the hope someone knowing the code could state if it should
> work or not.

Putting potential bugs aside (btrfs is still experimental, btrfs 
send/receive still has many corner-case quirks), it will work. But the 
design of your process to prepare the backup will put a lot of unnessecary 
work to your btrfs (in comparision to the alternatives already outlined 
here), increasing fragmentation, meta-data allocation, and probably making 
btrfs send/receive less efficient.

So to conclude: Your approach will probably be a good test scenario for 
btrfs send/receive and snapshots. But I really wouldn't try it without 
having a known-to-work backup up your sleeve.

-- 
Replies to list only preferred.

