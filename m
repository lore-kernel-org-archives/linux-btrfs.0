Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37322 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3EEKMT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 May 2013 06:12:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYvvU-0002M8-VF
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 12:12:16 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 12:12:16 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 12:12:16 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Possible to dedpulicate read-only snapshots for space-efficient backups
Date: Sun, 05 May 2013 12:07:17 +0200
Message-ID: <mjnh5a-mcf.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey list,

I wonder if it is possible to deduplicate read-only snapshots.

Background:

I'm using an bash/rsync script[1] to backup my whole system on a nightly 
basis to an attached USB3 drive into a scratch area, then take a snapshot of 
this area. I'd like to have these snapshots immutable, so they should be 
read-only.

Since rsync won't discover moved files but instead place a new copy of that 
in the backup, I'm running the wonderful bedup application[2] to deduplicate 
my backup drive from time to time and it almost always gains back a good 
pile of gigabytes. The rest of storage space issues is taken care of by 
using rsync's inplace option (although this won't cover the case of files 
moved and changed between backup runs) and using compress-force=gzip.

Since bedup sets the immutable attribute during touching the files, I 
suspect the process will no longer work when I make the snapshots read-only.

I've read about ongoing work to integrate offline (and even online) 
deduplication into the kernel so that this process can be made atomic (and 
even block-based instead of file-based). This would - to my understandings - 
result in the immutable attribute no longer needed. So, given the fact above 
and for the case read-only snapshots cannot be used for this application 
currently, will these patches address the problem and read-only snapshots 
could be deduplicated? Or are read-only snapshots meant to be what the name 
suggests: Immutable, even for deduplication?

Regards,
Kai

[1]: https://gist.github.com/kakra/5520370
[2]: https://github.com/g2p/bedup

