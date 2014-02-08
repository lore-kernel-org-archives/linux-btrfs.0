Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55902 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaBHXZ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 18:25:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCHH4-00034j-92
	for linux-btrfs@vger.kernel.org; Sun, 09 Feb 2014 00:25:26 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 00:25:26 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 00:25:26 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sun, 09 Feb 2014 00:17:29 +0100
Message-ID: <9hqisa-46c.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov <rm@romanrm.net> schrieb:

>> It should show the raw space available. Btrfs also supports compression
>> and doesn't try to be smart about how much compressed data would fit in
>> the free space of the drive. If one is using RAID1, it's supposed to fill
>> up with a rate of 2:1. If one is using compression, it's supposed to fill
>> up with a rate of maybe 1:5 for mostly text files.
> 
> Imagine a small business with some 30-40 employees. There is a piece of
> paper near the door at the office so that everyone sees it when entering
> or leaving, which says:
> 
> "Dear employees,
> 
> Please keep in mind that on the fileserver '\\DepartmentC', in the
> directory '\PublicStorage7' the free space you see as being available
> needs to be divided by two; On the server '\\DepartmentD', in
> '\StorageArchive' and '\VideoFiles', multiplied by two-thirds. For more
> details please contact the IT operations team. Further assistance will be
> provided at the monthly training seminar.

"Dear employees,

Please keep in mind that when you run out of space on the fileserver 
'\\DepartmentC', when you free up space in the directory '\PublicStorage7' 
the free space you gain on '\StorageArchive' is only one third of the amount 
you deleted, and in '\VideoFiles', you gain only one half. For more details 
please contact the IT operations team. Further assistance will be provided 
at the monthly training seminar.

Regards,
John S, CTO."

The exercise of why is left to the reader...

The proposed fix simply does not fix the problem. It simply shifts it 
introducing the need for another fix somewhere else, which in turn probably 
also introduces another need for a fix, and so forth... This will become an 
endless effort of fixing and tuning.

It simply does not work because btrfs' design does not allow that. Feel free 
to fix it but be prepared for the reincarnation of this problem when per-
subvolume raid levels become introduced. The problem has to be fixed in user 
space or with a new API call.

-- 
Replies to list only preferred.

