Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37677 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab3K1KWy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 05:22:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VlykG-00081V-CD
	for linux-btrfs@vger.kernel.org; Thu, 28 Nov 2013 11:22:52 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 11:22:52 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 11:22:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send size
Date: Thu, 28 Nov 2013 10:22:31 +0000 (UTC)
Message-ID: <pan$49c4c$8412de9a$240c4a4a$2eb69510@cox.net>
References: <5296516E.8000201@jrs-s.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim Salter posted on Wed, 27 Nov 2013 15:09:18 -0500 as excerpted:

> I can't find a manpage for the btrfs command that lists ANY information
> about btrfs send, and I haven't found anything online about doing a size
> check on send operations without actually sending the data.  Anybody got
> any help for this?  This is officially a Big Deal for those of us who
> customarily do asynchronous replication, so it would be really, really
> awesome if this could get addressed. =)

You're not using a current btrfs-progs version (3.12 being current as of 
just a couple days ago, when Chris tagged it and announced versions 
synced to kernel versions, now), then.

btrfs --version
Btrfs v3.12

>From the btrfs (8) manpage:

>>>>

send [-v] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol>

Send the subvolume to stdout.  Sends the subvolume specified by <subvol> 
to stdout.  By default, this will send the whole subvolume. To do an  
incremental send, use '-p <parent>'.  If you want to allow btrfs to clone 
from any additional local snapshots, use '-c <clone-src>' (multiple times 
where applicable).  You must not specify clone sources unless you 
guarantee that these snapshots are exactly in the same state on both 
sides, the sender and the receiver.  It is allowed to omit the which case 
'btrfs send' will determine a suitable parent among the clone sources 
itself.

Options

-v   Enable verbose debug output. Each occurrence of this option 	
increases the verbose level more.
       
-p <parent>
Send an incremental stream from <parent> to <subvol>.
       
-c <clone-src>
Use this snapshot as a clone source for an incremental send (multiple 
allowed).
       
-f <outfile>
Output is normally written to stdout. To write to a file, use this option.
An alternative would be to use pipes.
       
<<<<

Seems that last sentence before the options had something chopped out, 
but that's what the manpage says.

FWIW I don't use btrfs send here so I can't vouch for the accuracy of the 
above, but that's what's in the latest manpage, anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

