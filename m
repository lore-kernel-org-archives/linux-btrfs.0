Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57595 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaBHVzJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 16:55:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCFrc-000655-1m
	for linux-btrfs@vger.kernel.org; Sat, 08 Feb 2014 22:55:04 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 22:55:04 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 22:55:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sat, 08 Feb 2014 22:46:50 +0100
Message-ID: <a7lisa-rt7.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F33BE7.4020708@swiftspirit.co.za> <20140206184502.128b7dbe@natsu> <52F3E86B.4030805@libero.it> <20140207104005.7bd1438a@natsu> <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com> <20140207120812.43dc7982@natsu> <A9FC77DF-E4FC-4E60-94C9-CE8927FB1B9F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> 
> On Feb 6, 2014, at 11:08 PM, Roman Mamedov <rm@romanrm.net> wrote:
> 
>>  And what
>> if I am accessing that partition on a server via a network CIFS/NFS share
>> and don't even *have a way to find out* any of that.
> 
> That's the strongest argument. And if the user is using
> Explorer/Finder/Nautilus to copy files to the share, I'm pretty sure all
> three determine if there's enough free space in advance of starting the
> copy. So if it thinks there's free space, it will start to copy and then
> later fail midstream when there's no more space. And then the user's copy
> task is in a questionable state as to what's been copied, depending on how
> the file copies are being threaded.

This problem has already been solved for remote file systems maybe 20-30 
years ago: You cannot know how much space is left at the end of the copy by 
looking at the numbers before the copy - it may have been used up by another 
user copying a file at the same time. The problem has been solved by 
applying hard and soft quotas: The sysadmin does an optimistic (or possibly 
even pessimistic) planning and applies quotas. Soft quotas can be passed for 
(maybe) 7 days after which you need to free up space again before adding new 
data. Hard quotas are the hard cutoff - you cannot pass that barrier. Df 
will show you what's free within your softquota. Problem solved. If you need 
better numbers, there are quota commands instead of df. Why break with this 
design choice?

If you manage a central shared storage for end users, you should really 
start thinking about quotas. Without, you cannot even exactly plan your 
backups.

If df shows transformed/guessed numbers to the sysadmins, things start to 
become very complicated and unpredictable.

-- 
Replies to list only preferred.

